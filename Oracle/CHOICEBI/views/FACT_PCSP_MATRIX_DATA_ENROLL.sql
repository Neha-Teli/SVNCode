DROP VIEW FACT_PCSP_MATRIX_DATA_ENROLL;

CREATE OR REPLACE VIEW FACT_PCSP_MATRIX_DATA_ENROLL
 AS
    SELECT "MONTH_ID",
           "DL_LOB_ID",
           "MEMBER_ID",
           "SUBSCRIBER_ID",
           "PRODUCT_NAME",
           "ENROLLMENT_DATE",
           "DISENROLLMENT_DATE",
           "ACTIVE_IND",
           "CARE_MANAGER_NAME",
           "PCSP_CATEGORY",
           "DOCUMENT_ID",
           "DOCUMENT",
           "DOCUMENT_TYPE",
           "PCSP_CREATED_BY",
           "PCSP_CREATED_ON",
           "PCSP_SEQ",
           "PSP_DATE",
           "PSP_BUSINESS_DAYS",
           "PSP_CATEGORY",
           "ASSESSMENTDATE",
           "ENROLL_ASSESS_SEQ",
           "REASSESSMENT_FLAG",
           "TEAM_MANAGER_NAME",
           "PSP_STATUS",
           "DL_PLAN_SK",
           1 FLAG
    FROM   FACT_PCSP_MATRIX_DATA
    WHERE  REASSESSMENT_FLAG = 0


GRANT SELECT ON FACT_PCSP_MATRIX_DATA_ENROLL TO MSTRSTG;
