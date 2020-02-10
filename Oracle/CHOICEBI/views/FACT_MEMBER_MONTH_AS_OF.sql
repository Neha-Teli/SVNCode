DROP VIEW FACT_MEMBER_MONTH_AS_OF;

CREATE OR REPLACE VIEW FACT_MEMBER_MONTH_AS_OF
(
    DATA_SOURCE,
    AS_OF_MONTH_DT,
    MRN,
    MONTH_ID,
    PROGRAM,
    BOROUGH,
    COUNTY_CODE,
    STAFF_ID,
    MEDICAID_NUM,
    MEDICARE_NUM,
    SUBSCRIBER_ID,
    BENEFIT_REGION,
    UAS_DATE,
    UAS_NFLOC_SCORE,
    DC_REASON,
    DISENROLL_DISP,
    FLAG,
    CASE_NBR,
    STATE_CODE,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE,
    ENROLLED_FLAG,
    DISENROLLED_FLAG,
    LINE_OF_BUSINESS,
    PROVIDER_ID,
    PROVIDER_NAME,
    MONTH,
    SSN,
    LAST_NAME,
    FIRST_NAME,
    DATE_OF_BIRTH,
    AGE,
    SEX,
    COUNTY,
    HIGHEST_CASE_NUMBER,
    LOB_ID,
    UAS_RECORD_ID,
    REFERRAL_DATE,
    MANDATORY_ENROLLMENT,
    DISENROLL_RSN_DESC,
    PRODUCT_ID,
    PRODUCT_NAME,
    PLAN_ID,
    PLAN_DESC,
    REGION_NAME,
    REGION_NAME2,
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
    DL_LOB_GRP_ID,
    DL_MEMBER_ADDRESS_SK,
    DL_COUNTY_SK,
    DL_JOB_RUN_ID,
    DL_CRT_TS,
    DL_UPD_TS
) AS
    WITH member_mrn AS
             (SELECT * from choicebi.member_mrn@odsdev),
         REF_LOB_GROUP_MAPPING AS
             (SELECT 1 DL_LOB_GRP_ID, 1 DL_LOB_ID FROM DUAL
              UNION ALL
              SELECT 1 DL_LOB_GRP_ID, 5 DL_LOB_ID FROM DUAL
              UNION ALL
              SELECT 2, 2 DL_LOB_ID FROM DUAL
              UNION ALL
              --SELECT 2, 5 DL_LOB_ID FROM DUAL UNION ALL
              SELECT 3, 3 DL_LOB_ID FROM DUAL
              UNION ALL
              SELECT 4, 4 DL_LOB_ID FROM DUAL),
         V_REF_PLAN AS
             (SELECT D.DL_LOB_GRP_ID, E.LOB_GRP_DESC, B.*
              FROM   CHOICE.REF_PLAN@DLAKE B
                     JOIN CHOICE.REF_LOB@DLAKE C
                         ON (C.DL_LOB_ID = B.DL_LOB_ID)
                     JOIN REF_LOB_GROUP_MAPPING D
                         ON (C.DL_LOB_ID = D.DL_LOB_ID)
                     JOIN mstrstg.D_LOB_GROUP E
                         ON (E.DL_LOB_GRP_ID = D.DL_LOB_GRP_ID))
    SELECT /*+ driving_site(a)  no_merge */
          'CHOICEDM' DATA_SOURCE,
           AS_OF_MONTH_DT,
           NVL(c.MRN, member_mrn.mrn) MRN,
           REPORTING_MONTH MONTH_ID,
           PLAN_PACKAGE PROGRAM,
           E.BOROUGH,
           COUNTY_CODE,
           --NULL TEAM,
           CARE_MANAGER_ID STAFF_ID,
           MEDICAID_NUMBER MEDICAID_NUM,
           HICN MEDICARE_NUM,
           SUBSCRIBER_ID,
           C.BENEFIT_REGION,
           ASSESSMENTDATE UAS_DATE,
           LEVELOFCARESCORE UAS_NFLOC_SCORE,
           DISENROLL_RSN_CODE DC_REASON,
           DISENROLL_RSN_DESC DISENROLL_DISP,
           1 FLAG,
           CASE_NBR,
           STATE STATE_CODE,
           TO_DATE(TO_CHAR(ORIG_ENROLLMENT_START_MONTH)||
                   '01',
                   'YYYYMMDD')
               ENROLLMENT_DATE,
             ADD_MONTHS(
                 TO_DATE(TO_CHAR(LATEST_ENROLLMENT_END_MONTH), 'YYYYMM'),
                 1)
           - 1
               DISENROLLMENT_DATE,
           NEW_ENR_IND ENROLLED_FLAG,
           NEW_DISENR_IND DISENROLLED_FLAG,
           LOB_GRP_DESC LINE_OF_BUSINESS,
           PROVIDER_ID,
           PCP_NAME PROVIDER_NAME,
           REPORTING_MONTH MONTH,
           SSN,
           D.LAST_NAME,
           D.FIRST_NAME,
           DOB DATE_OF_BIRTH,
           ROUND(MONTHS_BETWEEN(SYSDATE, DOB) / 12, 1) AGE,
           SEX_CODE SEX,
           COUNTY,
           TO_CHAR(CASE_NBR) HIGHEST_CASE_NUMBER,
           A.dl_LOB_ID LOB_ID,
           A.DL_ASSESS_SK UAS_RECORD_ID,
           I.REFERRAL_DATE,
           NVL(MANDATORY_ENROLLMENT, 'N') MANDATORY_ENROLLMENT,
           --NVL(C.MANDATORY_ENROLLMENT, 'N') mandatory_enrollment,
           -- DISENROLLMENT_MONTH,
           c.DISENROLL_RSN_DESC,
           b.product_id,
           PRODUCT_NAME,
           b.PLAN_ID,
           PLAN_DESC,
           REGION_NAME,
           DESCRIPTION_1 REGION_NAME2,
           A.DL_MEMBER_SK,
           D.MEMBER_ID,
           A.DL_PMPM_ENR_SK,
           A.DL_ENROLL_ID,
           A.DL_ENRL_SK,
           A.DL_LOB_ID,
           A.DL_PLAN_SK,
           A.DL_PROV_SK,
           A.CM_SK_ID,
           A.DL_ASSESS_SK,
           DL_LOB_GRP_ID,
           DL_MEMBER_ADDRESS_SK,
           cnty.DL_COUNTY_SK,
           A.DL_JOB_RUN_ID,
           A.DL_CRT_TS,
           A.DL_UPD_TS
    FROM   CHOICE.FCT_PMPM_ENROLLMENT@DLAKE A
           LEFT JOIN V_REF_PLAN B ON (A.DL_PLAN_SK = B.DL_PLAN_SK)
           LEFT JOIN CHOICE.DIM_MEMBER_ENROLLMENT@DLAKE C ON (A.DL_ENRL_SK = C.DL_ENRL_SK)
           LEFT JOIN CHOICE.DIM_MEMBER@DLAKE D ON (A.DL_MEMBER_SK = D.DL_MEMBER_SK)
           LEFT JOIN CHOICE.DIM_MEMBER_ADDRESS@DLAKE E ON (E.DL_MBR_ADDR_SK = A.DL_MEMBER_ADDRESS_SK)
           LEFT JOIN CHOICE.DIM_MEMBER_ASSESSMENTS@DLAKE F ON (F.DL_ASSESS_SK = A.DL_ASSESS_SK)
           LEFT JOIN CHOICE.DIM_MEMBER_PRIMARY_PROVIDER@DLAKE G ON (G.DL_PROV_SK = A.DL_PROV_SK)
           LEFT JOIN CHOICE.DIM_MEMBER_CARE_MANAGER@DLAKE H ON (H.CM_SK_ID = A.CM_SK_ID)
           LEFT JOIN member_mrn ON (member_mrn.member_id = D.member_id)
           LEFT JOIN choice.REF_COUNTY@DLAKE cnty ON (COUNTY_CODE = FIPS_CODE)
           LEFT JOIN
           (SELECT DL_ENRL_SK,
                   DL_ENROLL_ID,
                   NVL(MIN(referral_date) OVER (PARTITION BY DL_ENROLL_ID),
                       orig_enrollment_start_dt)
                       AS referral_date --keep the earliest referral date for the
            --                                                                                                                                consecutive enrollment, if null then populate
            --                                                                                                                                with orig enrollment date
            FROM   CHOICE.DIM_MEMBER_ENROLLMENT@DLAKE
            WHERE  dl_lob_id IN (2, 4, 5)) I  --For MLTC, FIDA, and Total only
               ON (I.DL_ENRL_SK = A.DL_ENRL_SK)
    WHERE  AS_OF_MONTH_DT > 201501;


GRANT SELECT ON FACT_MEMBER_MONTH_AS_OF TO SF_CHOICE;
