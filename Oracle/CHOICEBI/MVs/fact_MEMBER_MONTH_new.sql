DROP MATERIALIZED VIEW CHOICEBI.FACT_MEMBER_MONTH;

CREATE MATERIALIZED VIEW CHOICEBI.FACT_MEMBER_MONTH 
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
WITH D_LOB_GROUP AS
         (SELECT 1 DL_LOB_GRP_ID, 'MA' LOB_GRP_DESC FROM DUAL
          UNION ALL
          SELECT 2, 'MLTC' DL_LOB_ID FROM DUAL
          UNION ALL
          SELECT 3, 'SH' DL_LOB_ID FROM DUAL
          UNION ALL
          SELECT 4, 'FIDA' DL_LOB_ID FROM DUAL),
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
          FROM   CHOICE.REF_PLAN@DL_CHOICE B
                 JOIN CHOICE.REF_LOB@DL_CHOICE C
                     ON (C.DL_LOB_ID = B.DL_LOB_ID)
                 JOIN REF_LOB_GROUP_MAPPING D ON (C.DL_LOB_ID = D.DL_LOB_ID)
                 JOIN D_LOB_GROUP E ON (E.DL_LOB_GRP_ID = D.DL_LOB_GRP_ID))
SELECT /*+ driving_site(a)  cardinality(A 400000) cardinality(b 60000000) cardinality(c 60000000)   cardinality(d 60000000)  cardinality(e 60000000) cardinality(f 60000000) no_merge */
      'CHOICEDM' DATA_SOURCE,
       c.MRN,
       REPORTING_MONTH MONTH_ID,
       PLAN_PACKAGE PROGRAM,
       BOROUGH,
       COUNTY_CODE,
       --NULL TEAM,
       H.MEMBER_ID STAFF_ID,
       MEDICAID_NUMBER MEDICAID_NUM,
       HICN MEDICARE_NUM,
       SUBSCRIBER_ID,
       C.BENEFIT_REGION,
       ASSESSMENTDATE UAS_DATE,
       LEVELOFCARESCORE UAS_NFLOC_SCORE,
       --NULL REFERRAL_SOURCE,
       DISENROLL_RSN_CODE DC_REASON,
       DISENROLL_RSN_DESC DISENROLL_DISP,
       --NULL AGE,
       1 FLAG,
       NVL(mem_case_number.case_num, CASE_NBR) CASE_NBR,
       STATE STATE_CODE,
       --ENROLLMENT_START_DT ENROLLMENT_DATE,
       --ENROLLMENT_END_DT DISENROLLMENT_DATE,
       TO_DATE(TO_CHAR(ORIG_ENROLLMENT_START_MONTH)||
               '01',
               'YYYYMMDD')
           ENROLLMENT_DATE,
         ADD_MONTHS(TO_DATE(TO_CHAR(LATEST_ENROLLMENT_END_MONTH), 'YYYYMM'),
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
       --NVL(MANDATORY_ENROLLMENT, 'N') MANDATORY_ENROLLMENT,
       nvl(NVL(mandatory_enroll.mandatory_enrollment, C.MANDATORY_ENROLLMENT), 'N') mandatory_enrollment,
       -- DISENROLLMENT_MONTH,
       c.DISENROLL_RSN_DESC,
       b.product_id,
       PRODUCT_NAME,
       b.PLAN_ID,
       PLAN_DESC,
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
       A.DL_JOB_RUN_ID,
       A.DL_CRT_TS,
       A.DL_UPD_TS
FROM   CHOICE.FCT_PMPM_ENROLLMENT_CURR@DL_CHOICE A
       LEFT JOIN V_REF_PLAN B ON (A.DL_PLAN_SK = B.DL_PLAN_SK)
       LEFT JOIN CHOICE.DIM_MEMBER_ENROLLMENT@DL_CHOICE C
           ON (A.DL_ENRL_SK = C.DL_ENRL_SK)
       LEFT JOIN CHOICE.DIM_MEMBER@DL_CHOICE D
           ON (A.DL_MEMBER_SK = D.DL_MEMBER_SK)
       LEFT JOIN CHOICE.DIM_MEMBER_ADDRESS@DL_CHOICE E
           ON (E.DL_MBR_ADDR_SK = A.DL_MEMBER_ADDRESS_SK)
       LEFT JOIN CHOICE.DIM_MEMBER_ASSESSMENTS@DL_CHOICE F
           ON (F.DL_ASSESS_SK = A.DL_ASSESS_SK)
       LEFT JOIN CHOICE.DIM_MEMBER_PRIMARY_PROVIDER@DL_CHOICE G
           ON (G.DL_PROV_SK = A.DL_PROV_SK)
       LEFT JOIN CHOICE.DIM_MEMBER_CARE_MANAGER@DL_CHOICE H
           ON (H.CM_SK_ID = A.CM_SK_ID)
       LEFT JOIN
       (SELECT MRN,
               CASE_NUM,
               admission_date,
               referral_date,
               referral_source,
               discharge_reason,
               patient_id,
               ROW_NUMBER()
               OVER (PARTITION BY mrn, TO_CHAR(admission_date, 'yyyymm')
                     ORDER BY admission_entry_date DESC)
                   case_seq
        FROM   MS_OWNER.VW_CASE_FACTS@ms_owner_rcprod
        WHERE      company_code = 'VCP'
               AND admission_date IS NOT NULL) mem_case_number
           ON (    mem_case_number.mrn = c.MRN
                   AND ORIG_ENROLLMENT_START_MONTH = TO_CHAR(mem_case_number.admission_date, 'yyyymm')
                   AND mem_case_number.case_seq = 1
               )
       LEFT JOIN
       (SELECT /*+ no_merge driving_site(m) materialize */
              a13.LABEL_TEXT LABEL_TEXT,
                 a13.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                 a13.ITEM_VALUE ITEM_VALUE,
                 a11.CASE_NUM CASE_NUM,
                 --SUM(a11.FLAG) WJXBFS1,
                 'Y' mandatory_enrollment
        FROM     MS_OWNER.FACT_CASE_REFERRAL@ms_owner_rcprod a11
                 JOIN
                 (SELECT CASE_NUM CASE_NUM, CONTACT_SOURCE ITEM_VALUE
                  FROM   DW_OWNER.CHOICEPRE_CASE_LVL_INFO@nexus2) a12
                     ON (a11.CASE_NUM = a12.CASE_NUM)
                 JOIN
                 (SELECT a01.LABEL_TEXT LABEL_TEXT,
                         a01.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                         a01.ITEM_VALUE ITEM_VALUE
                  FROM   (SELECT LOOKUP_ITEM_ID,
                                 ITEM_VALUE,
                                 LABEL_TEXT,
                                 LOOKUP_GROUP_ID
                          FROM   DW_OWNER.CHOICEPRE_LOOKUP_ITEM@nexus2
                          WHERE  LOOKUP_GROUP_ID IN (50, 51, 52)) a01
                  WHERE  UPPER(label_text) LIKE '%MAND%') a13
                     ON (a12.ITEM_VALUE = a13.ITEM_VALUE)
        GROUP BY a13.LABEL_TEXT,
                 a13.LOOKUP_ITEM_ID,
                 a13.ITEM_VALUE,
                 a11.CASE_NUM) mandatory_enroll
           ON (NVL(mem_case_number.case_num, CASE_NBR) = mandatory_enroll.case_num)
       LEFT JOIN
       (SELECT DL_ENRL_SK,
               DL_ENROLL_ID,
               NVL(MIN(referral_date) OVER (PARTITION BY DL_ENROLL_ID),
                   orig_enrollment_start_dt)
                   AS referral_date  --keep the earliest referral date for the
        --                                                                                                                                consecutive enrollment, if null then populate
        --                                                                                                                                with orig enrollment date
        FROM   CHOICE.DIM_MEMBER_ENROLLMENT@DL_CHOICE
        WHERE  dl_lob_id IN (2, 4, 5)) I      --For MLTC, FIDA, and Total only
           ON (I.DL_ENRL_SK = A.DL_ENRL_SK)
WHERE  AS_OF_MONTH_DT =
           (SELECT /*+ driving_site(a)  cardinality(A 400000) no_merge */
                  MAX(AS_OF_MONTH_DT)
            FROM   CHOICE.FCT_PMPM_ENROLLMENT_CURR@DL_CHOICE);

COMMENT ON MATERIALIZED VIEW CHOICEBI.FACT_MEMBER_MONTH IS 'snapshot table for snapshot CHOICEBI.FACT_MEMBER_MONTH';

GRANT SELECT ON CHOICEBI.FACT_MEMBER_MONTH TO MSTRSTG WITH GRANT OPTION;
