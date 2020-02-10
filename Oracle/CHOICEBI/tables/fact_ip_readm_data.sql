--drop table fact_ip_readm_data;

create table fact_ip_readm_data_new
(
     DL_CLAIM_UNIV_SK     NUMBER 
    ,SRC_SYS              VARCHAR2 (10)
    ,LOB                  VARCHAR2 (20)
    ,MONTH_ID             NUMBER
    ,SUBSCRIBER_ID        VARCHAR2 (9)
    ,MEMBER_ID            NUMBER
    ,STMT_FROM_DT         DATE
    ,STMT_TO_DT           DATE
    ,CLHP_STAMENT_FR_DT   DATE
    ,CLHP_STAMENT_TO_DT   DATE
    ,LOS                  NUMBER
    ,PAID_AMT             NUMBER
    ,TOT_PAID             NUMBER
    ,SERVICE_PROVIDER_ID  VARCHAR2 (50)
    ,PRPR_ID              VARCHAR2 (50)
    ,MATERN_FLG           VARCHAR2(1) 
    ,PRPR_NAME            VARCHAR2 (400)
    ,CLAIM_ID             VARCHAR2 (50)
    ,CLAIM_STATUS         VARCHAR2 (2)
    ,PROC_CD              VARCHAR2 (10)
    ,DIAG_CD              VARCHAR2 (10)
    ,DL_PROVIDER_SK       NUMBER
    ,DL_LOB_ID            NUMBER 
    ,DL_PLAN_SK           NUMBER 
    ,CM_SK_ID             NUMBER 
    ,DL_ASSESS_SK         NUMBER 
    ,DL_MEMBER_ADDRESS_SK NUMBER 
    ,REVENUE_CD           VARCHAR2 (10)
    ,DL_DIAG_CD_SK        NUMBER
    ,DL_REVENUE_CD_SK     NUMBER
    ,DL_PROC_CD_SK        NUMBER
    ,DENOM                NUMBER
    ,READMIT              NUMBER
    ,CRTE_USR_ID          NUMBER
    ,CRTE_TS              DATE
    ,UPDT_USR_ID          NUMBER
    ,UPDT_TS              DATE
);

GRANT SELECT ON FACT_IP_READM_DATA TO CHOICEBI_RO;

GRANT SELECT ON FACT_IP_READM_DATA TO MSTRSTG;

GRANT SELECT ON FACT_IP_READM_DATA TO MSTRSTG2;

select * from
(
select dl_lob_id, month_id, sum(readmit) readm, sum(denom) denom From FACT_IP_READM_DATA group by dl_lob_id, month_id
) a,
(
select dl_lob_id, month_id, sum(readmit) readm, sum(denom) denom From FACT_IP_READM_DATA_new group by dl_lob_id, month_id
) b
where a.month_id = b.month_id and a.dl_lob_id = b.dl_lob_id
order by a.dl_lob_id desc, a.month_id desc