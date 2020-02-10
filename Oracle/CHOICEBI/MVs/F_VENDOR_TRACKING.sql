DROP TABLE CHOICEBI.F_VENDOR_TRACKING CASCADE CONSTRAINTS;

CREATE TABLE CHOICEBI.F_VENDOR_TRACKING
(
     TAX_ID                        VARCHAR2 (50)
    ,PHYSICIAN_ID                  NUMBER (19)
    ,PHYSICIAN_CODE                VARCHAR2 (50)
    ,PROVIDER_NAME                 VARCHAR2 (200)
    ,PATIENT_PHYSICIAN_ID          NUMBER (19)
    ,PATIENT_ID                    NUMBER (19)
    ,VENDOR_ID                     NUMBER (10)
    ,VENDOR_NAME                   VARCHAR2 (500)
    ,ASSESSMENT_TYPE_ID            NUMBER (10)
    ,ASSESSMENT_TYPE               VARCHAR2 (500)
    ,ASSESSMENT_DUE_MONTH          DATE
    ,FILE_NAME                     VARCHAR2 (1000)
    ,CREATED_BY                    NUMBER (19)
    ,UPDATED_BY                    NUMBER (19)
    ,CREATED_ON                    DATE
    ,START_DATE                    DATE
    ,END_DATE                      DATE
    ,MEMBER_ID                     NUMBER
    ,SUBSCRIBER_ID                 VARCHAR2 (200)
    ,FIRST_NAME                    VARCHAR2 (200)
    ,LAST_NAME                     VARCHAR2 (200)
    ,MEDICAID_NUM1                 VARCHAR2 (200)
    ,MEDICAID_NUM2                 VARCHAR2 (200)
    ,MRN                           NUMBER
    ,CARE_MANAGER_NAME             VARCHAR2 (101)
    ,ATTEMPT1_DATE                 DATE
    ,ATTEMPT1_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT1_DATE_OF_VISIT        DATE
    ,ATTEMPT1_COMMENTS             VARCHAR2 (4000)
    ,ATTEMPT2_DATE                 DATE
    ,ATTEMPT2_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT2_DATE_OF_VISIT        DATE
    ,ATTEMPT2_COMMENTS             VARCHAR2 (4000)
    ,ATTEMPT3_DATE                 DATE
    ,ATTEMPT3_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT3_DATE_OF_VISIT        DATE
    ,ATTEMPT3_COMMENTS             VARCHAR2 (4000)
    ,ATTEMPT_FINAL_DATE            DATE
    ,ATTEMPT_FINAL_OUTCOME         VARCHAR2 (4000)
    ,ATTEMPT_FINAL_DATE_OF_VISIT   DATE
    ,ATTEMPT_FINAL_COMMENTS        VARCHAR2 (4000)
    ,ATTEMPT_FINAL_NUMBER          NUMBER
    ,RECORD_ID                     NUMBER
    ,ASSESSMENTDATE                DATE
    ,ONURSEDATE                    DATE
    ,ONURSENAME                    VARCHAR2 (50)
    ,ONURSEORGNAME                 VARCHAR2 (100)
    ,ONURSECOMMENTS                VARCHAR2 (4000)
    ,RECORD_ID_OTH_VENDOR          NUMBER
    ,ASSESSMENTDATE_OTH_VENDOR     DATE
    ,ONURSEDATE_OTH_VENDOR         DATE
    ,ONURSENAME_OTH_VENDOR         VARCHAR2 (50)
    ,ONURSEORGNAME_OTH_VENDOR      VARCHAR2 (100)
    ,ATSP_DOCUMENT_ID              NUMBER (19)
    ,ATSP_CREATED_ON_DATE          DATE
    ,PSP_SCRIPT_RUN_LOG_ID         NUMBER (19)
    ,PSP_SCPT_ACTIVITY_STATUS      VARCHAR2 (10)
    ,PSP_SCPT_FORM_ACTIVITY_STATUS VARCHAR2 (50)
    ,PSP_START_DATE                DATE
    ,PSP_END_DATE                  DATE
    ,PSP_APPROVED_UNITS            NUMBER
    ,PSP_ASSESSMENT_DATE           VARCHAR2 (4000)
    ,PSP_ATSP_TOOL_TOTAL_PER_WEEK  VARCHAR2 (4000)
    ,SYS_UPD_DT                       DATE
);


GRANT SELECT ON CHOICEBI.F_VENDOR_TRACKING TO DW_OWNER;

GRANT SELECT ON CHOICEBI.F_VENDOR_TRACKING TO MSTRSTG;
