DROP VIEW REF_AUTH_WORKFLOW_TYPE;

CREATE OR REPLACE VIEW REF_AUTH_WORKFLOW_TYPE as 
select * from choice.REF_AUTH_WORKFLOW_TYPE@dldev;

GRANT SELECT ON REF_AUTH_WORKFLOW_TYPE TO MSTRSTG;

DROP VIEW REF_AUTH_WORKFLOW_STAGE;

CREATE OR REPLACE VIEW REF_AUTH_WORKFLOW_STAGE
AS SELECT * FROM   choice.REF_AUTH_WORKFLOW_STAGE@dldev;

GRANT SELECT ON REF_AUTH_WORKFLOW_STAGE TO MSTRSTG;

DROP VIEW FCT_AUTH_WORKFLOW;

DROP VIEW FCT_AUTH_WORKFLOW;

CREATE OR REPLACE VIEW FCT_AUTH_WORKFLOW
(
    DL_FCT_AUTH_WF_SK,
    DL_UM_AUTH_SK,
    REF_AUTH_WF_TYPE_SK,
    REF_AUTH_WF_STAGE_SK,
    DL_MEMBER_SK,
    MEMBER_ID,
    SUBSCRIBER_ID,
    AUTH_ID,
    AUTH_NO,
    AUTH_PRIORITY_ID,
    AUTH_PRIORITY,
    AUTH_PRIORITY_IND,
    LOB_BEN_ID,
    WF_START_TSP,
    WF_END_TSP,
    FLAG,
    NUM_OF_SECONDS,
    UPDATED_BY,
    WF_VERSION,
    DL_JOB_RUN_ID,
    DL_CRT_TS,
    DL_UPD_TS
) AS
    WITH mxwf AS
             (SELECT *
              FROM   (SELECT /*+ no_merge matarialize  */
                            REF_AUTH_WF_STAGE_SK
                      FROM     REF_AUTH_WORKFLOW_STAGE
                      WHERE    IS_ACTIVE = 'Y'
                      ORDER BY 1 DESC)
              WHERE  ROWNUM = 1)
    SELECT   DL_FCT_AUTH_WF_SK,
             DL_UM_AUTH_SK,
             REF_AUTH_WF_TYPE_SK,
             REF_AUTH_WF_STAGE_SK,
             DL_MEMBER_SK,
             MEMBER_ID,
             SUBSCRIBER_ID,
             AUTH_ID,
             AUTH_NO,
             AUTH_PRIORITY_ID,
             AUTH_PRIORITY,
             AUTH_PRIORITY_IND,
             LOB_BEN_ID,
             WF_START_TSP,
             CAST(DECODE(WF_START_TSP, NULL, NULL, WF_END_TSP) AS TIMESTAMP) WF_END_TSP,
             DECODE(NVL(WF_END_TSP, WF_START_TSP), NULL, 0, 1) FLAG,
             EXTRACT(DAY FROM ((WF_END_TSP - WF_START_TSP)) DAY TO SECOND) * 86400 + EXTRACT(HOUR FROM (WF_END_TSP - WF_START_TSP) DAY TO SECOND) * 3600 + EXTRACT(MINUTE FROM (WF_END_TSP -
             WF_START_TSP) DAY TO SECOND) * 60 + EXTRACT(SECOND FROM (WF_END_TSP - WF_START_TSP) DAY TO SECOND)
                 NUM_OF_SECONDS,
             UPDATED_BY,
             WF_VERSION,
             DL_JOB_RUN_ID,
             DL_CRT_TS,
             DL_UPD_TS
    FROM     (SELECT /*+ driving_site(a) ordered full(a) full(b) use_hash(b) */
                    A.DL_FCT_AUTH_WF_SK,
                     A.DL_UM_AUTH_SK,
                     A.REF_AUTH_WF_TYPE_SK,
                     A.REF_AUTH_WF_STAGE_SK,
                     A.DL_MEMBER_SK,
                     NULL MEMBER_ID,
                     A.SUBSCRIBER_ID,
                     A.AUTH_ID,
                     A.AUTH_NO,
                     A.AUTH_PRIORITY_ID,
                     A.AUTH_PRIORITY,
                     A.AUTH_PRIORITY_IND,
                     A.LOB_BEN_ID,
                     A.WF_TSP WF_START_TSP,
                     CAST(
                         DECODE(a.REF_AUTH_WF_STAGE_SK,
                                mxwf.REF_AUTH_WF_STAGE_SK, WF_TSP,
                                LEAD(WF_TSP) OVER (PARTITION BY AUTH_NO, SUBSCRIBER_ID ORDER BY DECODE(WF_TSP, NULL, 0, 1) DESC, REF_AUTH_WF_TYPE_SK, a.REF_AUTH_WF_STAGE_SK)) AS TIMESTAMP)
                         WF_END_TSP,
                     A.UPDATED_BY,
                     1 WF_VERSION,
                     A.DL_JOB_RUN_ID,
                     A.DL_CRT_TS,
                     A.DL_UPD_TS
              FROM   CHOICE.FCT_AUTH_WORKFLOW@dldev a
                     JOIN choice.dim_member@dldev b ON (a.dl_member_sk = b.dl_member_sk)
                     LEFT JOIN mxwf ON (a.REF_AUTH_WF_STAGE_SK = mxwf.REF_AUTH_WF_STAGE_SK)) A
    --where auth_id = '0912E8665'
    ORDER BY AUTH_NO, REF_AUTH_WF_TYPE_SK, a.REF_AUTH_WF_STAGE_SK;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO LINKADM;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO LINKADM2;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO MSTRSTG WITH GRANT OPTION;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO ROC_RO;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO ROC_RO2;

GRANT SELECT ON FCT_AUTH_WORKFLOW TO MSTRSTG WITH GRANT OPTION;

DROP VIEW V_FACT_COMPLETED_AUTH_WORKFLOW;

CREATE OR REPLACE VIEW V_FACT_COMPLETED_AUTH_WORKFLOW
AS
    SELECT "DL_FCT_AUTH_WF_SK",
           "DL_UM_AUTH_SK",
           "REF_AUTH_WF_TYPE_SK",
           "REF_AUTH_WF_STAGE_SK",
           "DL_MEMBER_SK",
           "SUBSCRIBER_ID",
           "AUTH_ID",
           "AUTH_NO",
           AUTH_PRIORITY_ID,
           AUTH_PRIORITY,
           AUTH_PRIORITY_IND,
           LOB_BEN_ID,
           "WF_START_TSP",
           "WF_END_TSP",
           "UPDATED_BY",
           "WF_VERSION",
           "DL_JOB_RUN_ID",
           "DL_CRT_TS",
           "DL_UPD_TS",
           "FLAG",
           "NUM_OF_SECONDS"
    FROM   FCT_AUTH_WORKFLOW
    WHERE  REF_AUTH_WF_TYPE_SK = 1 AND REF_AUTH_WF_STAGE_SK = 13;

GRANT SELECT ON V_FACT_COMPLETED_AUTH_WORKFLOW TO MSTRSTG;

