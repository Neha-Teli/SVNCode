DROP VIEW V_HHA_ZUNO2_RAW_ENROLL;

CREATE OR REPLACE VIEW V_HHA_ZUNO2_RAW_ENROLL
(
    MEMBER_ID,
    SUBSCRIBER_ID,
    DL_LOB_ID,
    PRODUCT_ID,
    PRODUCT_NAME,
    LOB,
    LTP_IND,
    MONTH_ID,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE,
    ACTIVE_IND,
    ENROLLED_FLAG,
    DISENROLLED_FLAG,
    MONTHS_ENROLLED,
    REGION_NAME,
    REGION,
    COUNTY,
    RECORD_ID,
    UAS_DATE,
    UAS_NFLOC_SCORE,
    RISK_SCORE,
    ORDERED_AUTHED_HRS_MONTH,
    AUTHED_HRS_MONTH,
    PAID_HRS_MONTH,
    MONTH_DURATION,
    ORDERED_AUTHED_HRS_MONTH_STD30,
    AUTHED_HRS_MONTH_STD30,
    PAID_HRS_MONTH_STD30,
    FLAG
) AS
    SELECT /*+ use_hash(A B C M))*/
          a.member_id,
           a.subscriber_id,
           a.dl_lob_id,
           a.product_id,
           a.product_name,
           CASE
               WHEN a.product_name = 'VNSNY CHOICE MLTC' THEN '2-MLTC'
               WHEN a.product_name = 'VNSNY CHOICE FIDA COMPLETE (MEDICARE-MEDICAID PLAN)' THEN '4-FIDA'
               WHEN a.product_name = 'VNSNY CHOICE TOTAL (HMO SNP)' THEN '3-MAP'
           END
               AS LOB,
           CASE WHEN a.subgroup_id BETWEEN 2000 AND 2007 AND a.dl_lob_id = 4 THEN 1 ELSE c.ltp_ind END AS ltp_ind,
           a.month_id,
           a.enrollment_date,
           a.disenrollment_date,
           CASE WHEN a.disenrollment_date = '31dec2199' THEN 1 ELSE 0 END AS active_ind,
           a.enrolled_flag,
           a.disenrolled_flag,
           MONTHS_BETWEEN( TO_DATE( a.month_id, 'yyyymm'), a.enrollment_date) + 1 AS months_enrolled,
           a.region_name,
           CASE
               WHEN a.region_name = 'NEW YORK METRO' THEN '2-REGION 1-NYC'
               WHEN a.region_name = 'MID-HUDSON/NORTHERN' THEN '3-REGION 2-MH/N'
               WHEN a.region_name = 'NORTHEAST/WESTERN' THEN '4-REGION 3-NE/W'
               WHEN a.region_name = 'REST OF NY STATE' THEN '5-REGION 4-ROS'
           END
               AS region,
           a.county,
           a.uas_record_id AS record_id,
           uas_date,
           uas_nfloc_score,
           --b.risk_score,
           RISK_SCORE,
           NVL(ROUND( NVL(c.ordered_hha_hours_month, c.auth_hours_month), 1), 0) AS ordered_authed_hrs_month,
           NVL(ROUND( c.auth_hours_month, 1), 0) AS authed_hrs_month,
           NVL(c.paid_hha_hours_month, 0) AS paid_hrs_month,
           m.month_duration,
           NVL(ROUND( NVL(c.ordered_hha_hours_month / m.month_duration * 30, c.auth_hours_month / m.month_duration * 30), 1), 0) AS ordered_authed_hrs_month_std30,
           NVL(ROUND( c.auth_hours_month / m.month_duration * 30, 1), 0) AS authed_hrs_month_std30,
           NVL(c.paid_hha_hours_month / m.month_duration * 30, 0) AS paid_hrs_month_std30,
           1 flag
    FROM   CHOICEBI.FACT_MEMBER_MONTH a
           --LEFT JOIN choicebi.uas_risk_score b ON (a.uas_record_id = b.record_id AND b.mercer_doc_year = '2017')
           LEFT JOIN choicebi.fact_hha_ltp_monthly_data c ON (a.member_id = c.member_id AND a.month_id = c.month_id)
           LEFT JOIN mstrstg.LU_MONTH m ON (m.month_id = a.month_id)
    WHERE  a.dl_lob_id IN (2, 4, 5) AND a.program IN ('MLTC', 'FIDA') AND a.month_id >= 201701 AND (CASE WHEN a.subgroup_id BETWEEN 2000 AND 2007 AND a.dl_lob_id = 4 THEN 1 ELSE c.ltp_ind END) = 0;


GRANT SELECT ON V_HHA_ZUNO2_RAW_ENROLL TO MICHAEL_K;

GRANT SELECT ON V_HHA_ZUNO2_RAW_ENROLL TO MSTRSTG;

GRANT SELECT ON V_HHA_ZUNO2_RAW_ENROLL TO MSTRSTG2;

GRANT SELECT ON V_HHA_ZUNO2_RAW_ENROLL TO ROC_RO;

GRANT SELECT ON V_HHA_ZUNO2_RAW_ENROLL TO ROC_RO2;
