DROP VIEW V_HOSP_RATE_CALC_PIC;

CREATE OR REPLACE VIEW V_HOSP_RATE_CALC_PIC
(
    YEAR,
    MEMBER_ID,
    DL_LOB_ID,
    RECORD_ID,
    ASSESSMENT_DT,
    UAS_PERIOD,
    RISK_SCORE,
    NUM_SERVICE_DAYS,
    NUM_HOSP,
    ESTIMATED_NUM_HOSP
) AS
    WITH pic_claims AS
             (
        /*
              SELECT DISTINCT b1.member_id, a.mrn, a.service_from_dt AS service_dt
              FROM   choice.fct_claim_pcrs@dlake a
                     JOIN (SELECT mrn, member_id, ROW_NUMBER() OVER (PARTITION BY mrn ORDER BY mrn_src DESC) AS mrn_seq FROM choicebi.xwalk_member_id_mrn) b1
                         ON (TO_CHAR(a.mrn) = TO_CHAR(b1.mrn) AND b1.mrn_seq = 1) --- logic to get MEMBER_ID from ETL of HHA_LTP
              WHERE  a.service_from_dt >= '01jan2016' AND a.claim_type = 'V' AND a.dl_active_rec_ind = 'Y' AND a.service_provider_id IN ('CX', '03', 'CC') ---  for Partners in Care
                        */
           select  distinct member_id,
            --a.mrn, 
            a.service_from_dt as service_dt 
            from choice.fct_claim_universe@dlake a where
            1=1  
            and CLAIM_STATUS = '02'
            and SERVICE_PROVIDER_ID like ('ANC000038%') 
            and a.SERVICE_FROM_DT >= '01jan2016'                                                                                                                                                            
          ),
         uas AS
             (SELECT DISTINCT EXTRACT(YEAR FROM assessmentdate) AS year,
                              member_id,
                              dl_assess_sk AS record_id,
                              assessmentdate AS assessment_dt
              FROM   (SELECT a0.*, ROW_NUMBER() OVER (PARTITION BY a0.member_id, a0.assessmentdate ORDER BY a0.dl_assess_sk DESC) AS seq
                      FROM   choice.dim_member_assessments@dlake a0)
              WHERE  1 = 1 AND seq = 1 ---  dedup assessments
                                      AND EXTRACT(YEAR FROM assessmentdate) BETWEEN 2016 AND 2018 AND EXTRACT(MONTH FROM assessmentdate) BETWEEN 4 AND 9 --- look for assessments between April and September every year
                                                                                                                                                        ),
         hosp_uas AS
             (SELECT DISTINCT record_id,
                              assessmentreason,
                              residenceassessment,
                              NVL(txinpatient, 0) AS num_hosp
              FROM   dw_owner.uas_communityhealth),
         uas_exclude1 AS
             (SELECT a.*, b.num_hosp
              FROM   uas a LEFT JOIN hosp_uas b ON (a.record_id = b.record_id)
              WHERE  1 = 1 AND NVL(assessmentreason, 0) != 1 --- remove initial assessments
                                                            AND NVL(residenceassessment, 0) != 7 --- remove nursing home assessments
                                                                                                ),
         members AS
             (SELECT *
              FROM   choicebi.fact_member_month
              WHERE  dl_lob_id IN (2, 4, 5) AND program IN ('MLTC', 'FIDA') --- pull all members that could possibly have a UAS
                                                                           ),
         lob AS
             (SELECT DISTINCT a.*, b1.dl_lob_id, CASE WHEN b2.dl_lob_id IS NOT NULL AND b3.dl_lob_id IS NOT NULL THEN 1 ELSE 0 END AS active_ind --- to make sure member is active during the past 2 months
              FROM   uas_exclude1 a
                     LEFT JOIN members b1 ON (a.member_id = b1.member_id AND TO_CHAR( a.assessment_dt, 'YYYYMM') = b1.month_id)
                     LEFT JOIN members b2 ON (a.member_id = b2.member_id AND TO_CHAR( ADD_MONTHS( a.assessment_dt, -1), 'YYYYMM') = b2.month_id)
                     LEFT JOIN members b3 ON (a.member_id = b3.member_id AND TO_CHAR( ADD_MONTHS( a.assessment_dt, -2), 'YYYYMM') = b3.month_id)),
         uas_exclude2 AS
             (SELECT *
              FROM   (SELECT DISTINCT a.*, CASE WHEN assessment_dt >= MAX(assessment_dt) OVER (PARTITION BY year, member_id) THEN 1 ELSE 0 END AS ind2 ---  second layer to get the latest assessment if there are multiple assessments with the highest # hosp
                      FROM   (SELECT DISTINCT a.*, MAX(num_hosp) OVER (PARTITION BY year, member_id) AS max_num_hosp, CASE WHEN num_hosp >= MAX(num_hosp) OVER (PARTITION BY year, member_id) THEN 1 ELSE 0 END AS ind1 --- first layer to get the assessment with the highest # hosp
                              FROM   lob a
                              WHERE  dl_lob_id IS NOT NULL AND active_ind = 1) a
                      WHERE  ind1 = 1)
              WHERE  ind2 = 1),
         cal_base AS
             (SELECT DISTINCT a.year,
                              a.member_id,
                              a.dl_lob_id,
                              a.record_id,
                              a.assessment_dt,
                              90 AS uas_period,
                              c.risk_score,
                              COUNT(DISTINCT b.service_dt) OVER (PARTITION BY a.year, a.member_id, a.dl_lob_id, a.record_id) AS num_service_days, ---  count the number of days Partners in Care served the member during past 90 days
                              a.num_hosp,
                              COUNT(DISTINCT b.service_dt) OVER (PARTITION BY a.year, a.member_id, a.dl_lob_id, a.record_id) / 90 * a.num_hosp AS estimated_num_hosp
              FROM   uas_exclude2 a
                     LEFT JOIN pic_claims b ON (a.member_id = b.member_id AND b.service_dt BETWEEN a.assessment_dt - 90 AND a.assessment_dt - 1)
                     LEFT JOIN choicebi.uas_risk_score c ON (a.record_id = c.record_id AND mercer_doc_year = '2017'))
    /*
    , cal_lob as
    (
        select
            year,
            decode(dl_lob_id, '2', 'MLTC', '4', 'FIDA', '5', 'MAP') as lob,
            sum(num_service_days) as sum_service_days,
            90 * count(*) as total_num_days,
            round(sum(num_service_days) / (90 * count(*)) * 100, 2) as service_pct,
            round(sum(estimated_num_hosp), 3) as sum_estimated_hosp,
            count(*) as num_member,
            round(sum(estimated_num_hosp) / count(*), 3) as rate,
            avg(risk_score) as avg_risk_score
        from cal_base
        where num_service_days > 0
        group by
            year,
            dl_lob_id
    )
    , cal_all as
    (
        select
            year,
            'ALL' as lob,
            sum(num_service_days) as sum_service_days,
            90 * count(*) as total_num_days,
            round(sum(num_service_days) / (90 * count(*)) * 100, 2) as service_pct,
            round(sum(estimated_num_hosp), 3) as sum_estimated_hosp,
            count(*) as num_member,
            round(sum(estimated_num_hosp) / count(*), 3) as rate,
            avg(risk_score) as avg_risk_score
        from cal_base
        where num_service_days > 0
        group by year
    )
    */
    SELECT   "YEAR",
             "MEMBER_ID",
             "DL_LOB_ID",
             "RECORD_ID",
             "ASSESSMENT_DT",
             "UAS_PERIOD",
             "RISK_SCORE",
             "NUM_SERVICE_DAYS",
             "NUM_HOSP",
             "ESTIMATED_NUM_HOSP"
    FROM     cal_base
    --union select * from cal_all
    ORDER BY 1, 3, 2;
