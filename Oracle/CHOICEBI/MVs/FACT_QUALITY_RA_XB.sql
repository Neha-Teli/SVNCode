DROP MATERIALIZED VIEW FACT_QUALITY_RA_XB;

CREATE MATERIALIZED VIEW FACT_QUALITY_RA_XB
BUILD IMMEDIATE
REFRESH FORCE
--NEXT TRUNC(SYSDATE) + 1        
WITH PRIMARY KEY
AS 
WITH prev_msr AS
         (SELECT DISTINCT a.dl_lob_id,
                          a.dl_plan_sk,
                          a.member_id,
                          a.subscriber_id,
                          a.uas_record_id1,
                          a.assessment_date1,
                          a.reporting_period_id,
                          curr.enrollment_date,
                          curr.qip_month_id,
                          curr.lob_id,
                          base.record_id AS record_id_ra,
                          base.assessmentdate AS assessment_date_ra,
                          MONTHS_BETWEEN( curr.assessmonth, base.assessmonth) AS month_bt_assess
          FROM   CHOICEBI.FACT_QUALITY_MEASURES a
                 /*find the "current" assessment*/
                 LEFT JOIN (SELECT *
                            FROM   CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS
                            WHERE  qip_flag = 1) curr
                     ON (a.subscriber_id = curr.subscriber_id AND a.uas_record_id1 = curr.record_id AND a.reporting_period_id = curr.qip_period)
                 /*baseline for risk adjustment: attempt to find latest assessment from previous year (previous year, same semi-year period)*/
                 /*e.g. current 201601, baseline 201501*/
                 LEFT JOIN (SELECT *
                            FROM   CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS
                            WHERE  qip_flag = 1) base
                     ON (curr.subscriber_id = base.subscriber_id AND curr.enrollment_date = base.enrollment_date AND curr.record_id <> base.record_id AND curr.qip_period - base.qip_period = 100)
          WHERE  a.msr_type = 'PREV'),
     ra_uas AS
         (SELECT a.dl_lob_id,
                 a.dl_plan_sk,
                 a.member_id,
                 a.msr_id,
                 a.msr_token,
                 a.reporting_period_id,
                 a.subscriber_id,
                 a.assessment_date1,
                 a.assessment_date2,
                 a.uas_record_id1,
                 a.uas_record_id2,
                 CASE WHEN a.msr_type = 'PREV' THEN b.record_id_ra WHEN a.msr_type = 'POT' THEN a.uas_record_id1 END AS uas_record_id_ra,
                 CASE WHEN a.msr_type = 'PREV' THEN b.assessment_date_ra WHEN a.msr_type = 'POT' THEN a.assessment_date1 END AS assessment_date_ra,
                 CASE WHEN a.msr_type = 'PREV' THEN b.month_bt_assess WHEN a.msr_type = 'POT' THEN MONTHS_BETWEEN( TRUNC( a.assessment_date2, 'MM'), TRUNC( a.assessment_date1, 'MM')) END
                     AS month_bt_assess
          FROM   CHOICEBI.FACT_QUALITY_MEASURES a
                 LEFT JOIN prev_msr b ON (a.subscriber_id = b.subscriber_id AND a.uas_record_id1 = b.uas_record_id1 AND a.reporting_period_id = b.reporting_period_id AND a.msr_type = 'PREV')
          WHERE  b.record_id_ra IS NOT NULL OR a.msr_type = 'POT'),
     xb AS
         ( --risk factors for instances where UAS_RECORD_ID_RA is defined
          SELECT a.dl_lob_id,
                 a.dl_plan_sk,
                 a.member_id,
                 a.msr_id,
                 a.msr_token,
                 a.reporting_period_id,
                 a.subscriber_id,
                 a.assessment_date1,
                 a.assessment_date2,
                 a.uas_record_id1,
                 a.uas_record_id2,
                 a.uas_record_id_ra,
                 x.RISK_FACTOR,
                 x.RISK_FACTOR_VAL,
                 b.ra_year,
                 b.RISK_FACTOR_BETA_VAL,
                 x.RISK_FACTOR_VAL * b.RISK_FACTOR_BETA_VAL AS xb
          FROM   ra_uas a
                 JOIN FACT_QUALITY_RA_RISKFCTR_L x ON (a.uas_record_id_ra = x.record_id)
                 LEFT JOIN DIM_QUALITY_RSKADJ_BETA b ON (a.msr_id = b.msr_id AND LOWER(x.RISK_FACTOR) = LOWER(B.RISK_FACTOR))
          WHERE  b.RISK_FACTOR_BETA_VAL IS NOT NULL
          UNION
          --only the MONTH_BT_ASSESS risk factor
          SELECT a.dl_lob_id,
                 a.dl_plan_sk,
                 a.member_id,
                 a.msr_id,
                 a.msr_token,
                 a.reporting_period_id,
                 a.subscriber_id,
                 a.assessment_date1,
                 a.assessment_date2,
                 a.uas_record_id1,
                 a.uas_record_id2,
                 a.uas_record_id_ra,
                 'MONTH_BT_ASSESS' AS RISK_FACTOR,
                 a.month_bt_assess AS RISK_FACTOR_VAL,
                 b.ra_year,
                 b.RISK_FACTOR_BETA_VAL,
                 a.month_bt_assess * b.RISK_FACTOR_BETA_VAL AS xb
          FROM   ra_uas a
                 JOIN FACT_QUALITY_RA_RISKFCTR_L x ON (a.uas_record_id_ra = x.record_id)
                 LEFT JOIN DIM_QUALITY_RSKADJ_BETA b ON (a.msr_id = b.msr_id AND LOWER(B.RISK_FACTOR) = 'month_bt_assess')
          WHERE  b.RISK_FACTOR_BETA_VAL IS NOT NULL
          UNION
          --risk factors for prevalence measure where there is no prior assessment in past year to use for risk adjustment (set all risk factors to 0 exception for intercept)
          SELECT a.dl_lob_id,
                 a.dl_plan_sk,
                 a.member_id,
                 b.msr_id,
                 b.msr_token,
                 a.reporting_period_id,
                 a.subscriber_id,
                 a.assessment_date1,
                 NULL AS assessment_date2,
                 a.uas_record_id1,
                 NULL AS uas_record_id2,
                 NULL AS uas_record_id_ra,
                 b.RISK_FACTOR,
                 CASE WHEN LOWER(b.RISK_FACTOR) = 'intercept' THEN 1 ELSE 0 END AS factor_val,
                 b.ra_year,
                 b.RISK_FACTOR_BETA_VAL,
                 (CASE WHEN LOWER(b.RISK_FACTOR) = 'intercept' THEN 1 ELSE 0 END) * b.RISK_FACTOR_BETA_VAL AS xb
          FROM   (SELECT *
                  FROM   prev_msr
                  WHERE  record_id_ra IS NULL) a,
                 DIM_QUALITY_RSKADJ_BETA b
          WHERE  b.RISK_FACTOR_BETA_VAL IS NOT NULL AND b.outcome_type = 'Quality - Prevalence')
SELECT *
FROM   xb;

GRANT SELECT ON FACT_QUALITY_RA_XB TO CHOICEBI_RO;
