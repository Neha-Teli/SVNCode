create or replace view gc_hha_auths_by_day as
WITH ZZZ_AUTHS1 AS
(
    SELECT  /*+ no_merge materialize
            USE_HASH(svc.AUTH_DIM1)
            USE_HASH(svc.STAFF3)
            FULL(SVC.AUTH_DIM2)
            */
                 UNIQUE_ID,
                 AUTH_ID,
                 AUTH_TYPE_NAME,
                 PROVIDER_NAME,
                 AUTH_CREATED_ON,
                 AUTH_UPDATED_ON,
                 AUTH_CREATED_BY_NAME,
                 UNIT_TYPE,
                 AUTH_CODE_REF_ID,
                 TRUNC(SERVICE_FROM_DATE) AS SERVICE_FROM_DATE,
                 TRUNC(SERVICE_TO_DATE) AS SERVICE_TO_DATE,
                 TRUNC(SERVICE_TO_DATE) - TRUNC(SERVICE_FROM_DATE) + 1
                     AS DAYS_OF_SERVICE,
                 HOURS_X_DAYS,
                 CURRENT_REQUESTED,
                 CASE
                     WHEN (  TRUNC(SERVICE_TO_DATE)
                           - TRUNC(SERVICE_FROM_DATE)
                           + 1) = 0 THEN
                         NULL
                     WHEN AUTH_CODE_REF_ID IN ('T1019') THEN
                         ROUND(
                               (CURRENT_REQUESTED * 7)
                             / (  4
                                * (  TRUNC(SERVICE_TO_DATE)
                                   - TRUNC(SERVICE_FROM_DATE)
                                   + 1)),
                             3)
                     WHEN AUTH_CODE_REF_ID IN ('T1020', 'T1021') THEN
                         ROUND(
                               (CURRENT_REQUESTED * 7 * 13)
                             / ((  TRUNC(SERVICE_TO_DATE)
                                 - TRUNC(SERVICE_FROM_DATE)
                                 + 1)),
                             3)
                     ELSE
                         ROUND(
                               (CURRENT_REQUESTED * 7)
                             / (  TRUNC(SERVICE_TO_DATE)
                                - TRUNC(SERVICE_FROM_DATE)
                                + 1),
                             3)
                 END
                     AS AVG_REQUESTED_PER_WEEK,
                 ROUND(
                     NVL(
                         HOURS_X_DAYS,
                         CASE
                             WHEN (  TRUNC(SERVICE_TO_DATE)
                                   - TRUNC(SERVICE_FROM_DATE)
                                   + 1) = 0 THEN
                                 NULL
                             WHEN AUTH_CODE_REF_ID IN ('T1019') THEN
                                 ROUND(
                                       (CURRENT_REQUESTED * 7)
                                     / (  4
                                        * (  TRUNC(SERVICE_TO_DATE)
                                           - TRUNC(SERVICE_FROM_DATE)
                                           + 1)),
                                     3)
                             WHEN AUTH_CODE_REF_ID IN ('T1020', 'T1021') THEN
                                 ROUND(
                                       (CURRENT_REQUESTED * 7 * 13)
                                     / ((  TRUNC(SERVICE_TO_DATE)
                                         - TRUNC(SERVICE_FROM_DATE)
                                         + 1)),
                                     3)
                             ELSE
                                 ROUND(
                                       (CURRENT_REQUESTED * 7)
                                     / (  TRUNC(SERVICE_TO_DATE)
                                        - TRUNC(SERVICE_FROM_DATE)
                                        + 1),
                                     3)
                         END),
                     1)
                     AS HOURS_PER_WEEK
          FROM   CHOICEBI.V_AUTH_DATA SVC
          WHERE      AUTH_TYPE_ID IN (29, 47, 67)
                 AND UPPER(SUBSTR(UNIQUE_ID, 1, 1)) = 'V'
                 AND AUTH_CODE_TYPE_ID != 2
                 AND AUTH_STATUS_ID IN (2, 6, 1, 7)
                 AND DECISION_STATUS = 3
                 AND AUTH_CREATED_ON >= '01jan2016'
                 AND (    UNIT_TYPE IN ('Hours', 'Days', 'Units')
                      AND (   HOURS_X_DAYS IS NOT NULL
                           OR AUTH_CODE_REF_ID IN
                                  ('T1019', 'T1020', 'T1021', 'S9122')))
                 AND UNIQUE_ID IS NOT NULL
                 AND ROUND(
                         NVL(
                             HOURS_X_DAYS,
                             CASE
                                 WHEN (  TRUNC(SERVICE_TO_DATE)
                                       - TRUNC(SERVICE_FROM_DATE)
                                       + 1) = 0 THEN
                                     NULL
                                 WHEN AUTH_CODE_REF_ID IN ('T1019') THEN
                                     ROUND(
                                           (CURRENT_REQUESTED * 7)
                                         / (  4
                                            * (  TRUNC(SERVICE_TO_DATE)
                                               - TRUNC(SERVICE_FROM_DATE)
                                               + 1)),
                                         3)
                                 WHEN AUTH_CODE_REF_ID IN ('T1020', 'T1021') THEN
                                     ROUND(
                                           (CURRENT_REQUESTED * 7 * 13)
                                         / ((  TRUNC(SERVICE_TO_DATE)
                                             - TRUNC(SERVICE_FROM_DATE)
                                             + 1)),
                                         3)
                                 ELSE
                                     ROUND(
                                           (CURRENT_REQUESTED * 7)
                                         / (  TRUNC(SERVICE_TO_DATE)
                                            - TRUNC(SERVICE_FROM_DATE)
                                            + 1),
                                         3)
                             END),
                         1) <= 168
),
ZZZ_AUTHS2 AS
(
        SELECT /*+ no_merge materialize */
                UNIQUE_ID,
                   AUTH_ID,
                   AUTH_TYPE_NAME,
                   PROVIDER_NAME,
                   AUTH_CREATED_ON,
                   AUTH_CREATED_BY_NAME,
                   SERVICE_FROM_DATE,
                   SERVICE_TO_DATE,
                   DAYS_OF_SERVICE,
                   COUNT(*) AS N_LINES,
                   SUM(HOURS_PER_WEEK) AS HOURS_PER_WEEK
        FROM     ZZZ_AUTHS1
        GROUP BY UNIQUE_ID,
                   AUTH_ID,
                   AUTH_TYPE_NAME,
                   PROVIDER_NAME,
                   AUTH_CREATED_ON,
                   AUTH_CREATED_BY_NAME,
                   SERVICE_FROM_DATE,
                   SERVICE_TO_DATE,
                   DAYS_OF_SERVICE
        HAVING   SUM(HOURS_PER_WEEK) <= 168
),
ZZZ_AUTHS3 AS
(
    SELECT /*+no_merge  */ DAY_DATE,
         CHOICE_WEEK_ID,
         TO_CHAR(DAY_DATE, 'yyyymm') AS MONTH_ID,
         UNIQUE_ID,
         AUTH_ID,
         AUTH_TYPE_NAME,
         PROVIDER_NAME,
         AUTH_CREATED_ON,
         AUTH_CREATED_BY_NAME,
         SERVICE_FROM_DATE,
         SERVICE_TO_DATE,
         DAYS_OF_SERVICE,
         HOURS_PER_WEEK,
         CASE
             WHEN DAYS_OF_SERVICE + 1 < 7 THEN
                 HOURS_PER_WEEK / (DAYS_OF_SERVICE + 1)
             ELSE
                 HOURS_PER_WEEK / 7
         END
             AS HOURS_PER_DAY_AVG,
         ROW_NUMBER()
             OVER (PARTITION BY UNIQUE_ID ORDER BY DAY_DATE DESC)
             AS AUTH_DAY_SEQ_DESC,
         ROW_NUMBER()
         OVER (PARTITION BY UNIQUE_ID, DAY_DATE
               ORDER BY AUTH_CREATED_ON DESC, SERVICE_FROM_DATE DESC)
             AS AUTH_SEQ_DESC,
         ROW_NUMBER()
         OVER (PARTITION BY UNIQUE_ID, DAY_DATE, AUTH_TYPE_NAME
               ORDER BY AUTH_CREATED_ON DESC, SERVICE_FROM_DATE DESC)
             AS AUTH_TYPE_SEQ_DESC
  FROM   ZZZ_AUTHS2 A
         JOIN MSTRSTG.LU_DAY D ON (D.DAY_DATE BETWEEN SERVICE_FROM_DATE AND SERVICE_TO_DATE)
)
SELECT
    DAY_DATE,
    CHOICE_WEEK_ID,
    MONTH_ID,
    UNIQUE_ID,
    AUTH_ID,
    AUTH_TYPE_NAME,
    PROVIDER_NAME,
    AUTH_CREATED_ON,
    AUTH_CREATED_BY_NAME,
    SERVICE_FROM_DATE,
    SERVICE_TO_DATE,
    DAYS_OF_SERVICE,
    HOURS_PER_WEEK,
    HOURS_PER_DAY_AVG,
    AUTH_DAY_SEQ_DESC
FROM 
    ZZZ_AUTHS3
WHERE  
    AUTH_SEQ_DESC = 1;