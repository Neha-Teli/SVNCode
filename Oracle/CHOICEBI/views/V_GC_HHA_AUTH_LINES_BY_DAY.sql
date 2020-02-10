DROP VIEW V_GC_HHA_AUTH_LINES_BY_DAY;

CREATE OR REPLACE VIEW V_GC_HHA_AUTH_LINES_BY_DAY
(
    DAY_DATE,
    CHOICE_WEEK_ID,
    MONTH_ID,
    MEMBER_ID,
    SUBSCRIBER_ID,
    AUTH_ID,
    ALTERNATE_SERVICE_ID,
    DECISION_ID,
    PHYSICIAN_ID,
    PHYSICIAN_CODE,
    PROV_ID,
    PROVIDER_NAME,
    AUTH_TYPE_NAME,
    AUTH_STATUS,
    DECISION_STATUS_DESC,
    AUTH_CREATED_ON,
    AUTH_UPDATED_ON,
    AUTH_CREATED_BY_NAME,
    UNIT_TYPE,
    AUTH_CODE_REF_NAME,
    AUTH_CODE_REF_ID,
    SERVICE_DECISION_MODIFIER,
    CPT_CODE,
    SERVICE_FROM_DATE,
    SERVICE_TO_DATE,
    DAYS_OF_SERVICE,
    CURRENT_REQUESTED,
    HOURS_X_DAYS,
    HOURS_PER_WEEK_UBC,
    HOURS_PER_WEEK_CODES,
    HOURS_PER_WEEK_COMBO,
    UB_IND,
    UB_RULE,
    UNIT_HR,
    SERVICE_GROUP_ID,
    SERVICE_GROUP_DESC,
    AUTH_STATUS_ID
) AS
    WITH A AS
             (SELECT /*+ materialize no_merge */
                     --DAY_DATE,
                     --CHOICE_WEEK_ID,
                    M.MEMBER_ID,
                    A.UNIQUE_ID AS SUBSCRIBER_ID,
                    A.AUTH_ID,
                    A.ALTERNATE_SERVICE_ID,
                    A.DECISION_ID,
                    A.PHYSICIAN_ID,
                    B.PHYSICIAN_CODE,
                    SUBSTR( B.PHYSICIAN_CODE, 1, 9) AS PROV_ID,
                    A.PROVIDER_NAME,
                    A.AUTH_TYPE_NAME,
                    A.AUTH_STATUS,
                    A.DECISION_STATUS_DESC,
                    A.AUTH_CREATED_ON,
                    A.AUTH_UPDATED_ON,
                    A.AUTH_CREATED_BY_NAME,
                    A.UNIT_TYPE,
                    A.AUTH_CODE_REF_NAME,
                    A.AUTH_CODE_REF_ID,
                    A.SERVICE_DECISION_MODIFIER,
                    A.AUTH_CODE_REF_ID || A.SERVICE_DECISION_MODIFIER AS CPT_CODE,
                    TRUNC(A.SERVICE_FROM_DATE) AS SERVICE_FROM_DATE,
                    TRUNC(A.SERVICE_TO_DATE) AS SERVICE_TO_DATE,
                    TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1 AS DAYS_OF_SERVICE,
                    A.CURRENT_REQUESTED,
                    A.HOURS_X_DAYS,
                    ROUND( CASE WHEN (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) = 0 THEN NULL WHEN C.UB_IND = 1 THEN C.UNIT_HR * (A.CURRENT_REQUESTED * 7) / (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) END, 4)
                        AS HOURS_PER_WEEK_UBC --Calculated from Universal Billing Criteria (UBC) Only
                                             ,
                    ROUND( CASE WHEN (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) = 0 THEN NULL ELSE C.UNIT_HR * (A.CURRENT_REQUESTED * 7) / (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) END, 4)
                        AS HOURS_PER_WEEK_CODES --Calculated from Service Codes - UBC and Non-UBC
                                               ,
                    ROUND( NVL(A.HOURS_X_DAYS, CASE WHEN (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) = 0 THEN NULL ELSE C.UNIT_HR * (A.CURRENT_REQUESTED * 7) / (TRUNC(A.SERVICE_TO_DATE) - TRUNC(A.SERVICE_FROM_DATE) + 1) END), 4)
                        AS HOURS_PER_WEEK_COMBO --Calculated from Hours_X_Days and Service Codes
                                               ,
                    C.UB_IND,
                    CASE WHEN A.SERVICE_TO_DATE <= '31mar2018' THEN 'NA' WHEN C.UB_IND = 1 THEN 'MET' ELSE 'ERROR' END AS UB_RULE,
                    C.UNIT_HR,
                    C.SERVICE_GROUP_ID,
                    C.SERVICE_GROUP_DESC
                   ,A.AUTH_STATUS_ID
              FROM  CHOICEBI.V_AUTH_DATA A
                    --JOIN (select /*+ no_merge  materialize */* from MSTRSTG.LU_DAY where DAY_DATE >= '01jan2015') D ON (D.DAY_DATE BETWEEN A.SERVICE_FROM_DATE AND A.SERVICE_TO_DATE)
                    LEFT JOIN CMGC.PHYSICIAN_DEMOGRAPHY B ON (A.PHYSICIAN_ID = B.PHYSICIAN_ID)
                    LEFT JOIN DIM_CPT_CODES C ON (C.SYSTEM = 'PCS' AND A.AUTH_CODE_REF_ID || A.SERVICE_DECISION_MODIFIER = C.PROC_CD_FULL)
                    LEFT JOIN (SELECT SBSB_ID, MEMBER_ID, ROW_NUMBER() OVER (PARTITION BY SBSB_ID ORDER BY DL_UPD_TS DESC) AS SEQ FROM CHOICE.DIM_MEMBER_DETAIL@DLAKE) M
                        ON (A.UNIQUE_ID = M.SBSB_ID AND M.SEQ = 1)
              WHERE A.UNIQUE_ID LIKE 'V%' AND A.AUTH_CODE_TYPE_ID != 2 AND A.AUTH_STATUS_ID IN (2, 6, 1, 7) AND A.DECISION_STATUS = 3 AND A.AUTH_TYPE_ID IN (29, 31, 47, 67, 74))
    SELECT /*+ parallel(2) */
          DAY_DATE,
           CHOICE_WEEK_ID,
           TO_CHAR( DAY_DATE, 'yyyymm') AS MONTH_ID,
           A."MEMBER_ID",
           A."SUBSCRIBER_ID",
           A."AUTH_ID",
           A."ALTERNATE_SERVICE_ID",
           A."DECISION_ID",
           A."PHYSICIAN_ID",
           A."PHYSICIAN_CODE",
           A."PROV_ID",
           A."PROVIDER_NAME",
           A."AUTH_TYPE_NAME",
           A."AUTH_STATUS",
           A."DECISION_STATUS_DESC",
           A."AUTH_CREATED_ON",
           A."AUTH_UPDATED_ON",
           A."AUTH_CREATED_BY_NAME",
           A."UNIT_TYPE",
           A."AUTH_CODE_REF_NAME",
           A."AUTH_CODE_REF_ID",
           A."SERVICE_DECISION_MODIFIER",
           A."CPT_CODE",
           A."SERVICE_FROM_DATE",
           A."SERVICE_TO_DATE",
           A."DAYS_OF_SERVICE",
           A."CURRENT_REQUESTED",
           A."HOURS_X_DAYS",
           A."HOURS_PER_WEEK_UBC",
           A."HOURS_PER_WEEK_CODES",
           A."HOURS_PER_WEEK_COMBO",
           A."UB_IND",
           A."UB_RULE",
           A."UNIT_HR",
           A."SERVICE_GROUP_ID",
           A."SERVICE_GROUP_DESC",
           A.AUTH_STATUS_ID
    FROM   A JOIN MSTRSTG.LU_DAY D ON (DAY_DATE >= '01jan2015' AND D.DAY_DATE BETWEEN A.SERVICE_FROM_DATE AND A.SERVICE_TO_DATE)


GRANT SELECT ON V_GC_HHA_AUTH_LINES_BY_DAY TO ROC_RO;

GRANT SELECT ON V_GC_HHA_AUTH_LINES_BY_DAY TO SF_CHOICE;
