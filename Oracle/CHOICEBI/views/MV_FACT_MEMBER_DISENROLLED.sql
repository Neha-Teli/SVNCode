DROP VIEW CHOICEBI.MV_FACT_MEMBER_DISENROLLED;

CREATE OR REPLACE FORCE VIEW CHOICEBI.MV_FACT_MEMBER_DISENROLLED
 AS
    SELECT mrn mrn,
           TO_NUMBER(TO_CHAR(ADD_MONTHS(disenrollment_date, 1), 'YYYYMM'))
               month_id,
           program program,
           borough borough,
           county_code county_code,
           medicaid_num medicaid_num,
           medicare_num medicare_num,
           subscriber_id subscriber_id,
           benefit_region benefit_region,
           uas_date uas_date,
           uas_nfloc_score uas_nfloc_score,
           dc_reason dc_reason,
           disenroll_disp disenroll_disp,
           flag flag,
           case_nbr case_num,
           state_code state_code,
           enrollment_date enrollment_date,
           disenrollment_date disenrollment_date,
           enrolled_flag enrolled_flag,
           disenrolled_flag disenrolled_flag,
           LOB_ID,
           line_of_business,
           provider_id,
           provider_name,
           referral_date PRODUCT_ID,
           PRODUCT_NAME,
           PLAN_ID,
           PLAN_DESC,
           DL_MEMBER_SK,
           MEMBER_ID,
           DL_PMPM_ENR_SK,
           DL_ENROLL_ID,
           DL_ENRL_SK,
           DL_LOB_ID,
           DL_PLAN_SK,
           DL_PROV_SK,
           CM_SK_ID,
           DL_ASSESS_SK,
           DL_LOB_GRP_ID
    FROM   FACT_MEMBER_MONTH
    WHERE  DISENROLLED_FLAG = 1;
    
    
grant select on  CHOICEBI.MV_FACT_MEMBER_DISENROLLED to mstrstg
