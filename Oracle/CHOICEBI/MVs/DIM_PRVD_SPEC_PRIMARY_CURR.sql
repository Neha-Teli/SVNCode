DROP VIEW DIM_PRVD_SPEC_PRIMARY_CURR

CREATE MATERIALIZED VIEW DIM_PRVD_SPEC_PRIMARY_CURR
BUILD IMMEDIATE
REFRESH FORCE
NEXT TRUNC(SYSDATE) + 1.25  
as
select * from
(
    WITH DS_SUB1 AS
             (SELECT /*+ materialize no_merge */
                    PROVIDER_ID, SRC_SYS, MIN(SPECIALTY_TYPE) SPECIALTY_TYPE
              FROM     CHOICEBI.DIM_PROVIDER_SPECIALTY a
              WHERE    DL_ACTIVE_REC_IND = 'Y' --506,863
              --and SPECIALITY_CODE is not null --484,313
              GROUP BY PROVIDER_ID, SRC_SYS) --Then we get the data for each record from the main table                                            ,
         ,DS2 AS
             (SELECT /*+ materialize no_merge */
                    DL_SPECIALTY_SK,
                     b.PROVIDER_ID,
                     b.SRC_SYS,
                     NPI,
                     ADDR_ID,
                     b.SPECIALTY_TYPE,
                     SPECIALTY_CODE,
                     SPECIALTY_DESCRIPTION,
                     TAXONOMY_CODE,
                     DL_ACTIVE_REC_IND,
                     DL_EFF_DT,
                     DL_END_DT,
                     DL_JOB_RUN_ID,
                     DL_CRT_TS,
                     DL_UPD_TS
              FROM   CHOICEBI.DIM_PROVIDER_SPECIALTY a, DS_SUB1 b
              WHERE  a.DL_ACTIVE_REC_IND = 'Y' --506,863
                                              AND a.PROVIDER_ID = b.PROVIDER_ID AND a.SRC_SYS = b.SRC_SYS AND a.SPECIALTY_TYPE = b.SPECIALTY_TYPE)
    SELECT /*+ materialize no_merge */
          "DL_SPECIALTY_SK",
           "PROVIDER_ID",
           "SRC_SYS",
           "NPI",
           "ADDR_ID",
           "SPECIALTY_TYPE",
           "SPECIALTY_CODE",
           "SPECIALTY_DESCRIPTION",
           "TAXONOMY_CODE",
           "DL_ACTIVE_REC_IND",
           "DL_EFF_DT",
           "DL_END_DT",
           "DL_JOB_RUN_ID",
           "DL_CRT_TS",
           "DL_UPD_TS"
    FROM   ds2
)    


GRANT SELECT ON DIM_PRVD_SPEC_PRIMARY_CURR TO ROC_RO

GRANT SELECT ON DIM_PRVD_SPEC_PRIMARY_CURR TO MSTRSTG
