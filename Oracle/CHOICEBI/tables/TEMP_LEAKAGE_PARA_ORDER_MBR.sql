DROP TABLE CHOICEBI.TEMP_LEAKAGE_PARA_ORDER_MBR CASCADE CONSTRAINTS;

CREATE TABLE CHOICEBI.TEMP_LEAKAGE_PARA_ORDER_MBR
(
         PATIENT_ID                    NUMBER 
    ,SUBSCRIBER_ID                 VARCHAR2 (1000)
    ,LINE_OF_BUSINESS              VARCHAR2 (40)
    ,LOB_ID                        NUMBER
    ,MEDICAID_NUM1                 VARCHAR2 (200)
    ,MEDICAID_NUM2                 VARCHAR2 (200)
    ,MRNTEXT                       VARCHAR2 (200)
    ,MRN                           NUMBER 
    ,CURRENT_STAFF_FIRST_NAME      VARCHAR2 (50)
    ,CURRENT_STAFF_LAST_NAME       VARCHAR2 (50)
    ,VENDOR_NAME                   VARCHAR2 (1000)
    ,ASSIGNED_TO_VENDOR_ON         DATE
    ,REASSESSMENT_LIST_MONTH       DATE
    ,PLAN_DESC                     VARCHAR2 (4000)
    ,PLAN_NAME                     VARCHAR2 (1000)
    ,PLAN_START_DATE               DATE
    ,PLAN_END_DATE                 DATE
    ,PROGRAM_NAME                  VARCHAR2 (1000)
    ,PROGRAM_START_DATE            DATE
    ,PROGRAM_END_DATE              DATE
    ,ATTEMPT1_DATE                 DATE
    ,ATTEMPT1_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT1_COMMENTS             VARCHAR2 (4000)
    ,ATTEMPT2_DATE                 DATE
    ,ATTEMPT2_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT2_COMMENTS             VARCHAR2 (4000)
    ,ATTEMPT3_DATE                 DATE
    ,ATTEMPT3_OUTCOME              VARCHAR2 (4000)
    ,ATTEMPT3_COMMENTS             VARCHAR2 (4000)
    ,ASSESSMENTDATE                DATE
    ,ONURSEDATE                    DATE
    ,ONURSENAME                    VARCHAR2 (50)
    ,PREVIOUS_ASSESSMENTDATE       DATE
    ,PREVIOUS_ONURSEDATE           DATE
    ,PREVIOUS_ONURSENAME           VARCHAR2 (50)
    ,PREVIOUS_ONURSEORGNAME        VARCHAR2 (100)
    ,PSP_SCPT_ACTIVITY_STATUS      VARCHAR2 (10)
    ,PSP_SCPT_FORM_ACTIVITY_STATUS VARCHAR2 (50)
    ,PSP_START_DATE                DATE
    ,PSP_END_DATE                  DATE
    ,PSP_APPROVED_UNITS            VARCHAR2 (100)
    ,PSP_APPROVED_UNITS_NUM        NUMBER 
    ,PSP_APPROVED_UNITS_INVALID    NUMBER 
    ,PSP_ATSP_TOOL_TOTAL_PER_WEEK  NUMBER 
    ,ATSP_DATE                     DATE
    ,UNAVAILABLE_IND               NUMBER 
    ,ALL_DOCS_COMPLETED            NUMBER 
    ,ALL_DOCS_NOSNF                NUMBER 
    ,UNAVAILABLE_IND_SVC           NUMBER 
    ,SVCPLAN_LATEUAS               NUMBER 
    ,SVC_CREATED_ON                DATE
    ,SVCSTAFF_FIRST_NAME           VARCHAR2 (50)
    ,SVCSTAFF_LAST_NAME            VARCHAR2 (50)
    ,SVC_FROM_DATE                 DATE
    ,SVC_TO_DATE                   DATE
    ,AUTH_CLOSED_SEQ1              NUMBER 
    ,AUTH_CLOSED_SEQ2              NUMBER 
    ,AUTH_CLOSED                   NUMBER 
    ,AUTHS_SUMMED                  NUMBER 
    ,SVC_LOB_ID                    NUMBER 
    ,SUM_REQ_UNITS                 NUMBER 
    ,SUM_APPROVED_UNITS            NUMBER 
    ,SVC_UNIT_TYPE_ID              NUMBER 
    ,SERVICE_STATUS_ID             NUMBER 
    ,SERVICE_STATUS                VARCHAR2 (50)
    ,AUTH_NO                       NUMBER 
    ,AUTH_CLASS_ID                 NUMBER 
    ,SUM_HOURS                     NUMBER 
    ,SUM_DAYS                      NUMBER 
    ,WEEKS                         NUMBER 
    ,SUM_HRS_X_DAYS                NUMBER 
    ,PCW_APP_UNITS                 NUMBER 
    ,PCW_REC_UNITS                 NUMBER 
    ,PCW_CUR_UNITS                 NUMBER 
    ,AUTH_ID                       VARCHAR2 (50)
    ,AUTH_PRIORITY_ID              NUMBER 
    ,AUTH_PRIORITY                 VARCHAR2 (50)
    ,AUTH_NOTI_DATE                DATE
    ,AUTH_FROM_DATE                DATE
    ,AUTH_STATUS_ID                NUMBER 
    ,AUTH_STATUS                   VARCHAR2 (50)
    ,AUTH_STATUS_REASON_ID         NUMBER 
    ,AUTH_STATUS_REASON_NAME       VARCHAR2 (50)
    ,AUTH_CREATED_ON               DATE
    ,DECISION_STATUS               VARCHAR2 (50)
    ,DECISION_AUTH_NOTI_DATE       DATE
    ,DECISION_CREATED_ON           DATE
    ,DECISION_UPDATED_ON           DATE
    ,SVCPLAN_CREATED               NUMBER 
    ,SVCPLAN_CREATED_PRMR_COMPLETE NUMBER 
    ,SVCPLAN_CREATED_PSPHRS_OK     NUMBER 
    ,SVCPLAN_CLOSED                NUMBER 
    ,SVCPLAN_CLOSED_PRMR_COMPLETE  NUMBER 
    ,SVCPLAN_CLOSED_PSPHRS_OK      NUMBER 
    ,HHA_VARIANCE_DATE             DATE
    ,HHA_VARIANCE_STATUS           VARCHAR2 (200)
    ,HHA_VARIANCE_STATUS_DATE      DATE
    ,CONTRACTADMIN_REQ_DATE        DATE
    ,OPS_UPDATED_DATE              DATE
    ,OPS_COMMENTS                  VARCHAR2 (4000)
    ,HHA_VARIANCE_ACTIVITY         NUMBER 
    ,CONTRACTADMIN_REQ_ACTIVITY    NUMBER 
    ,OPS_UPDATED_ACTIVITY          NUMBER 
    ,JOB_RUN_ID                    VARCHAR2 (1)
    ,SYS_UPD_TS      DATE  DEFAULT SYSDATE,
    PARA_ORD_MRN                  NUMBER, 
    PARA_CASE_NBR                 NUMBER ,
    PARA_CASE_SEQ                 NUMBER ,
    PARA_ORD_PROG                 VARCHAR2 (3),
    PARA_ORD_CHOICE               NUMBER ,
    PARA_ORD_FIDA                 NUMBER ,
    PARA_ORD_MLTC                 NUMBER ,
    PARA_ORD_STATUS               VARCHAR2 (2),
    PARA_ORD_SERVICE              NUMBER ,
    PARA_ORD_ENTRY_DTE            DATE,
    PARA_REQ_START_DTE            DATE,
    ORDER_END                     DATE,
    SCHED_WK_BEG_DATE             DATE,
    SCHED_WK_END_DATE             DATE,
    SEQ_NO_DESC                   NUMBER, 
    SUMHOURS_LV_WK                NUMBER, 
    SCHED_SATURDAY_LV             NUMBER ,
    SCHED_SUNDAY_LV               NUMBER ,
    SCHED_MONDAY_LV               NUMBER ,
    SCHED_TUESDAY_LV              NUMBER ,
    SCHED_WEDNESDAY_LV            NUMBER ,
    SCHED_THURSDAY_LV             NUMBER ,
    SCHED_FRIDAY_LV               NUMBER ,
    LAGDATE                       DATE,
    OFFSET_DATE                   DATE,
    SCHED_BEG                     DATE,
    SCHED_END                     DATE,
    ATSP_DT_HRS                   NUMBER, 
    WKHRS1                        NUMBER ,
    WKHRS2                        NUMBER ,
    WKHRS_M1                      NUMBER ,
    WKHRS_M2                      NUMBER ,
    WKHRS_M3                      NUMBER ,
    UMEFFWKHRS                    NUMBER ,
    UMEFFWKHRS1                   NUMBER 
)
NOPARALLEL;
