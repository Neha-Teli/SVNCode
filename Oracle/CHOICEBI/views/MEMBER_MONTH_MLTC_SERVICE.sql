DROP VIEW MEMBER_MONTH_MLTC_SERVICE;

CREATE OR REPLACE VIEW MEMBER_MONTH_MLTC_SERVICE
(
    DL_MEMBER_SK,
    DL_PROVIDER_SK,
    MEMBER_ID,
    SUBSCRIBER_ID,
    FIRST_NAME,
    MIDDLE_INITIAL,
    LAST_NAME,
    DOB,
    MEDICARE_NUMBER,
    MEDICAID_NUMBER,
    REPORTING_MONTH,
    PRODUCT_ID,
    PRODUCT_NAME,
    PLAN_ID,
    SERVICE_PROVIDER_ID,
    NPI,
    PROVIDER_NAME,
    PROVIDER_SERVICE_CATEGORY,
    SRC_SYS,
    DL_JOB_RUN_ID,
    DL_CRT_TS,
    DL_UPD_TS
) AS
    SELECT /*+ driving_site(a) */
          "DL_MEMBER_SK",
           "DL_PROVIDER_SK",
           "MEMBER_ID",
           "SUBSCRIBER_ID",
           "FIRST_NAME",
           "MIDDLE_INITIAL",
           "LAST_NAME",
           "DOB",
           "MEDICARE_NUMBER",
           "MEDICAID_NUMBER",
           "REPORTING_MONTH",
           "PRODUCT_ID",
           "PRODUCT_NAME",
           "PLAN_ID",
           "SERVICE_PROVIDER_ID",
           "NPI",
           "PROVIDER_NAME",
           "PROVIDER_SERVICE_CATEGORY",
           "SRC_SYS",
           "DL_JOB_RUN_ID",
           "DL_CRT_TS",
           "DL_UPD_TS"
    FROM   CHOICE.MEMBER_MONTH_MLTC_SERVICE@dlake a


GRANT SELECT ON MEMBER_MONTH_MLTC_SERVICE TO MSTRSTG
