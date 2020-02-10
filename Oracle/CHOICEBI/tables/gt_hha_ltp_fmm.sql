drop table gt_hha_ltp_fmm;

create global temporary table gt_hha_ltp_fmm
(
DAY_DATE       DATE
,CHOICE_WEEK_ID NUMBER
,MONTH_ID       NUMBER
,MEMBER_ID      NUMBER
,SUBSCRIBER_ID  VARCHAR2 (10)
,PRODUCT_ID     VARCHAR2 (40)
,DL_PLAN_SK     NUMBER
,DL_LOB_ID      NUMBER
,PROGRAM        VARCHAR2 (10)
,COUNTY         VARCHAR2 (50)
,REGION_NAME    VARCHAR2 (50)
,MRN            NUMBER
)
ON COMMIT PRESERVE ROWS;

drop table gt_hha_ltp_claims_details

create global temporary table gt_hha_ltp_claims_details 
(
     SUBSCRIBER_ID       VARCHAR2 (10)
    ,PRODUCT_ID          VARCHAR2 (40)
    ,PAID_AMT            NUMBER
    ,SERVICE_FROM_DT     DATE
    ,SERVICE_PROVIDER_ID VARCHAR2 (100)
    ,LINE_PAID_AMT       NUMBER
    ,TMG_HHA             NUMBER
    ,TMG_PCA             NUMBER
    ,TMG_HOURS           NUMBER
)
ON COMMIT PRESERVE ROWS;



drop table GT_HHA_LTP_CLAIM_DETAILS

create global temporary table GT_HHA_LTP_CLAIM_DETAILS 
(
     SUBSCRIBER_ID       VARCHAR2 (10)
    ,PRODUCT_ID          VARCHAR2 (40)
    ,PAID_AMT            NUMBER
    ,SERVICE_FROM_DT     DATE
    ,SERVICE_PROVIDER_ID VARCHAR2 (100)
    ,LINE_PAID_AMT       NUMBER
    ,TMG_HHA             NUMBER
    ,TMG_PCA             NUMBER
    ,TMG_HOURS           NUMBER
)
ON COMMIT PRESERVE ROWS;


drop table gt_hha_ltp_assess;

create global temporary table gt_hha_ltp_assess 
(
DAY_DATE         DATE
,MEMBER_ID        NUMBER 
,DL_ASSESS_SK     NUMBER 
,ASSESSMENTDATE   DATE
,LEVELOFCARESCORE VARCHAR2 (3)
,SEQ              NUMBER 
)
ON COMMIT PRESERVE ROWS;

drop table gt_hha_ltp_snf_data;

create global temporary table gt_hha_ltp_snf_data
(
SUBSCRIBER_ID        VARCHAR2 (10)
,DAY_DATE             DATE
,CLAIM_PAID_AMT_TOTAL NUMBER
,CLAIM_PAID_AMT_DAY   NUMBER
,SNF_HOURS            NUMBER
)
ON COMMIT PRESERVE ROWS;