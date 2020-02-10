DROP VIEW V_QUALITY_POT_MSR_LONG;

CREATE OR REPLACE VIEW V_QUALITY_POT_MSR_LONG
(
    MEDICAID_NUM,
    SUBSCRIBER_ID,
    QIP_MONTH_ID,
    QIP_PERIOD,
    LOB_ID,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE,
    RECORD_ID1,
    RECORD_ID2,
    ASSESSMENTDATE1,
    ASSESSMENTDATE2,
    ASSESSMONTH,
    NEXT_DUE,
    NEXT_DUE_PERIOD,
    ONURSEORG,
    ONURSEORGNAME,
    ONURSENAME,
    ONURSECOMPANY,
    MEMBER_ID,
    DL_LOB_ID,
    DL_ENROLL_ID,
    DL_PLAN_SK,
    PROGRAM,
    DL_LOB_GRP_ID,
    DL_MEMBER_SK,
    ASSESSMENTREASON1,
    ASSESSMENTREASON2,
    MSR_TOKEN,
    DENOMINATOR,
    NUMERATOR,
    STATE_MSR_ELIG_FLAG
) AS
    WITH mv_quality_assess_all AS
             (SELECT /*+ materialize  */
                    *
              FROM   (SELECT *
                      FROM   CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS
                      WHERE  qip_flag = 1
                      UNION ALL
                      SELECT /*+ no_merge*/
                            *
                      FROM   CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS a1
                      WHERE  qip_flag = 0 AND NOT EXISTS
                                 (            SELECT /*+ no_merge*/
                                                    'X'
                                              FROM   CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS a2
                                              WHERE  qip_flag = 1 AND a1.record_id = a2.record_id) AND QIP_PERIOD_SEQ = 1)),
         POT AS
             (SELECT DISTINCT CURR.MEDICAID_NUM,
                              CURR.SUBSCRIBER_ID,
                              CURR.QIP_MONTH_ID,
                              CURR.QIP_PERIOD,
                              CURR.LOB_ID,
                              CURR.ENROLLMENT_DATE,
                              CURR.DISENROLLMENT_DATE,
                              BASE.RECORD_ID AS RECORD_ID1,
                              CURR.RECORD_ID AS RECORD_ID2,
                              BASE.ASSESSMENTDATE AS ASSESSMENTDATE1,
                              CURR.ASSESSMENTDATE AS ASSESSMENTDATE2,
                              CURR.ASSESSMONTH AS ASSESSMONTH,
                              CURR.NEXT_DUE AS NEXT_DUE,
                              CURR.NEXT_DUE_PERIOD AS NEXT_DUE_PERIOD,
                              CURR.ONURSEORG,
                              CURR.ONURSEORGNAME,
                              CURR.ONURSENAME,
                              CURR.ONURSECOMPANY,
                              CURR.MEMBER_ID,
                              CURR.DL_LOB_ID,
                              CURR.DL_ENROLL_ID,
                              --                     CURR.DL_ASSESS_SK,
                              --                     CURR.DL_PROV_SK,
                              --                     CURR.PROVIDER_ID,
                              CURR.DL_PLAN_SK,
                              CURR.PROGRAM,
                              CURR.DL_LOB_GRP_ID,
                              CURR.DL_MEMBER_SK,
                              --MONTHS_BETWEEN( CURR.ASSESSMONTH, BASE.ASSESSMONTH) + 1 AS ASSESSMONTH_DIFF,
                              --CASE WHEN BASE.ASSESSMENTREASON = 1 THEN MONTHS_BETWEEN( CURR.ASSESSMONTH, TRUNC( CURR.ENROLLMENT_DATE, 'MM')) + 1 ELSE NULL END AS ENROLLMONTH_DIFF,
                              MONTHS_BETWEEN( CURR.ASSESSMONTH, BASE.ASSESSMONTH) AS ASSESSMONTH_DIFF,
                              CASE WHEN BASE.ASSESSMENTREASON = 1 THEN MONTHS_BETWEEN( CURR.ASSESSMONTH, TRUNC( CURR.ENROLLMENT_DATE, 'MM')) ELSE NULL END AS ENROLLMONTH_DIFF,
                              BASE.ASSESSMENTREASON AS ASSESSMENTREASON1,
                              CURR.ASSESSMENTREASON AS ASSESSMENTREASON2,
                              CURR.QIP_FLAG
              FROM /*"current" assessment*/
                  (  SELECT *
                     FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                         mv_quality_assess_all
                     WHERE /*+QIP_FLAG = 1 AND */
                          NVL(ASSESSMENTREASON, 0) <> 1 AND NVL(RESIDENCEASSESSMENT, 0) <> 7) CURR
                     /*baseline: attempt to find latest assessment from previous year (previous year, same semi-year period)*/
                     /*e.g. current 201601, baseline 201501*/
                     JOIN (SELECT *
                           FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                               mv_quality_assess_all
                           WHERE  QIP_FLAG = 1) BASE
                         ON (CURR.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID AND CURR.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE AND CURR.RECORD_ID <> BASE.RECORD_ID AND CURR.QIP_PERIOD - BASE.QIP_PERIOD = 100)
              UNION
              SELECT DISTINCT CURR.MEDICAID_NUM,
                              CURR.SUBSCRIBER_ID,
                              CURR.QIP_MONTH_ID,
                              CURR.QIP_PERIOD,
                              CURR.LOB_ID,
                              CURR.ENROLLMENT_DATE,
                              CURR.DISENROLLMENT_DATE,
                              BASE.RECORD_ID AS RECORD_ID1,
                              CURR.RECORD_ID AS RECORD_ID2,
                              BASE.ASSESSMENTDATE AS ASSESSMENTDATE1,
                              CURR.ASSESSMENTDATE AS ASSESSMENTDATE2,
                              CURR.ASSESSMONTH AS ASSESSMONTH,
                              CURR.NEXT_DUE AS NEXT_DUE,
                              CURR.NEXT_DUE_PERIOD AS NEXT_DUE_PERIOD,
                              CURR.ONURSEORG,
                              CURR.ONURSEORGNAME,
                              CURR.ONURSENAME,
                              CURR.ONURSECOMPANY,
                              CURR.MEMBER_ID,
                              CURR.DL_LOB_ID,
                              CURR.DL_ENROLL_ID,
                              --                     CURR.DL_ASSESS_SK,
                              --                     CURR.DL_PROV_SK,
                              --                     CURR.PROVIDER_ID,
                              CURR.DL_PLAN_SK,
                              CURR.PROGRAM,
                              CURR.DL_LOB_GRP_ID,
                              CURR.DL_MEMBER_SK,
                              MONTHS_BETWEEN( CURR.ASSESSMONTH, BASE.ASSESSMONTH) AS ASSESSMONTH_DIFF,
                              CASE WHEN BASE.ASSESSMENTREASON = 1 THEN MONTHS_BETWEEN( CURR.ASSESSMONTH, TRUNC( CURR.ENROLLMENT_DATE, 'MM')) ELSE NULL END AS ENROLLMONTH_DIFF,
                              BASE.ASSESSMENTREASON AS ASSESSMENTREASON1,
                              CURR.ASSESSMENTREASON AS ASSESSMENTREASON2,
                              CURR.QIP_FLAG
              FROM /*"current" assessment*/
                  (  SELECT *
                     FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                         mv_quality_assess_all
                     WHERE /*+QIP_FLAG = 1  AND */
                          NVL(ASSESSMENTREASON, 0) <> 1 AND NVL(RESIDENCEASSESSMENT, 0) <> 7) CURR
                     /*baseline: attempt to find latest assessment in last 6 month period (same year)*/
                     /*e.g. current 201602, baseline 201601*/
                     JOIN (SELECT *
                           FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                               mv_quality_assess_all
                           WHERE  QIP_FLAG = 1) BASE
                         ON (CURR.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID AND CURR.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE AND CURR.RECORD_ID <> BASE.RECORD_ID AND CURR.QIP_PERIOD - BASE.QIP_PERIOD = 1)
              UNION
              SELECT DISTINCT CURR.MEDICAID_NUM,
                              CURR.SUBSCRIBER_ID,
                              CURR.QIP_MONTH_ID,
                              CURR.QIP_PERIOD,
                              CURR.LOB_ID,
                              CURR.ENROLLMENT_DATE,
                              CURR.DISENROLLMENT_DATE,
                              BASE.RECORD_ID AS RECORD_ID1,
                              CURR.RECORD_ID AS RECORD_ID2,
                              BASE.ASSESSMENTDATE AS ASSESSMENTDATE1,
                              CURR.ASSESSMENTDATE AS ASSESSMENTDATE2,
                              CURR.ASSESSMONTH AS ASSESSMONTH,
                              CURR.NEXT_DUE AS NEXT_DUE,
                              CURR.NEXT_DUE_PERIOD AS NEXT_DUE_PERIOD,
                              CURR.ONURSEORG,
                              CURR.ONURSEORGNAME,
                              CURR.ONURSENAME,
                              CURR.ONURSECOMPANY,
                              CURR.MEMBER_ID,
                              CURR.DL_LOB_ID,
                              CURR.DL_ENROLL_ID,
                              --                     CURR.DL_ASSESS_SK,
                              --                     CURR.DL_PROV_SK,
                              --                     CURR.PROVIDER_ID,
                              CURR.DL_PLAN_SK,
                              CURR.PROGRAM,
                              CURR.DL_LOB_GRP_ID,
                              CURR.DL_MEMBER_SK,
                              MONTHS_BETWEEN( CURR.ASSESSMONTH, BASE.ASSESSMONTH) AS ASSESSMONTH_DIFF,
                              CASE WHEN BASE.ASSESSMENTREASON = 1 THEN MONTHS_BETWEEN( CURR.ASSESSMONTH, TRUNC( CURR.ENROLLMENT_DATE, 'MM')) ELSE NULL END AS ENROLLMONTH_DIFF,
                              BASE.ASSESSMENTREASON AS ASSESSMENTREASON1,
                              CURR.ASSESSMENTREASON AS ASSESSMENTREASON2,
                              CURR.QIP_FLAG
              FROM /*"current" assessment*/
                  (  SELECT *
                     FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                         mv_quality_assess_all
                     WHERE /*+QIP_FLAG = 1 AND */
                          NVL(ASSESSMENTREASON, 0) <> 1 AND NVL(RESIDENCEASSESSMENT, 0) <> 7) CURR
                     /*baseline: attempt to find latest assessment in last 6 month period (from prvious year)*/
                     /*e.g. current 201601, baseline 201502*/
                     JOIN (SELECT *
                           FROM --choicebi.MV_QUALITY_MEASURE_ALL_ASSESS
                               mv_quality_assess_all
                           WHERE  QIP_FLAG = 1) BASE
                         ON (CURR.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID AND CURR.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE AND CURR.RECORD_ID <> BASE.RECORD_ID AND CURR.QIP_PERIOD - BASE.QIP_PERIOD = 99)),
         /*--DOH would probably sort to one assessment pair per qip_period and then exclude any that are not continuous enrollment*/
         /*-- of 6-13 months*/
         POT_CONT_DOH AS
             (SELECT MEDICAID_NUM,
                     SUBSCRIBER_ID,
                     QIP_MONTH_ID,
                     QIP_PERIOD,
                     LOB_ID,
                     ENROLLMENT_DATE,
                     DISENROLLMENT_DATE,
                     RECORD_ID1,
                     RECORD_ID2,
                     ASSESSMENTDATE1,
                     ASSESSMENTDATE2,
                     ASSESSMONTH,
                     NEXT_DUE,
                     NEXT_DUE_PERIOD,
                     ONURSEORG,
                     ONURSEORGNAME,
                     ONURSENAME,
                     ONURSECOMPANY,
                     MEMBER_ID,
                     DL_LOB_ID,
                     DL_ENROLL_ID,
                     DL_PLAN_SK,
                     PROGRAM,
                     DL_LOB_GRP_ID,
                     DL_MEMBER_SK,
                     ASSESSMENTREASON1,
                     ASSESSMENTREASON2,
                     QIP_FLAG
              FROM   (SELECT C.*, ROW_NUMBER() OVER (PARTITION BY SUBSCRIBER_ID, LOB_ID, QIP_PERIOD ORDER BY ASSESSMENTDATE1 ASC, QIP_FLAG DESC) AS SORT_SEQ, CASE WHEN ASSESSMENTREASON1 <> 1 AND ASSESSMONTH_DIFF BETWEEN 6 AND 13 THEN 1 WHEN ASSESSMENTREASON1 = 1 AND ASSESSMENTDATE1 < ENROLLMENT_DATE AND ENROLLMONTH_DIFF BETWEEN 6 AND 13 THEN 1 WHEN ASSESSMENTREASON1 = 1 AND ASSESSMENTDATE1 >= ENROLLMENT_DATE AND ASSESSMONTH_DIFF BETWEEN 6 AND 13 THEN 1 ELSE 0 END AS CONT_ENROLL_6_13
                      FROM   POT C)
              WHERE  SORT_SEQ = 1 AND CONT_ENROLL_6_13 = 1),
         POT_CONT_DOH_MEASURES_LONG AS
             (SELECT A.*,
              'pot_nfloc' AS MSR_TOKEN,
              1 AS DENOMINATOR,
              (CASE
                  WHEN N1.LEVELOFCARESCORE = 48 AND N2.LEVELOFCARESCORE = 48 THEN 0
                  WHEN N1.LEVELOFCARESCORE IS NOT NULL AND N2.LEVELOFCARESCORE IS NOT NULL AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE BETWEEN 0 AND 4 THEN 1
                  WHEN N1.LEVELOFCARESCORE IS NOT NULL AND N2.LEVELOFCARESCORE IS NOT NULL AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE < 0 THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_adl' AS MSR_TOKEN,
              (CASE
                  WHEN N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
              AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN
                  1
                  ELSE
                  0
              END)
                  AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
              AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND (N1.ADLLOCOMOTION + N1.ADLHYGIENE + N1.ADLBATHING) = 18 AND (N2.ADLLOCOMOTION + N2.ADLHYGIENE
              + N2.ADLBATHING) = 18 THEN
                  0
                  WHEN N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
              AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND (N2.ADLLOCOMOTION + N2.ADLHYGIENE + N2.ADLBATHING) - (N1.ADLLOCOMOTION + N1.ADLHYGIENE + N1.
              ADLBATHING) BETWEEN 0
                              AND 2 THEN
                  1
                  WHEN N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
              AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND (N2.ADLLOCOMOTION + N2.ADLHYGIENE + N2.ADLBATHING) - (N1.ADLLOCOMOTION + N1.ADLHYGIENE + N1.
              ADLBATHING) < 0 THEN
                  1
                  ELSE
                  0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_iadl' AS MSR_TOKEN,
              (CASE
                  WHEN N1.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEHOUSEWORK IN (0, 1, 2, 3, 4, 5, 6) AND N2.
              IADLPERFORMANCEHOUSEWORK IN
                  (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6
              ) AND N2.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) THEN
                  1
                  ELSE
                  0
              END)
                  AS DENOMINATOR,
              (CASE
                  WHEN N1.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEHOUSEWORK IN (0, 1, 2, 3, 4, 5, 6) AND N2.
              IADLPERFORMANCEHOUSEWORK IN
                  (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6
              ) AND N2.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND (N1.
              IADLPERFORMANCEMEALS + N1.IADLPERFORMANCEHOUSEWORK + N1.IADLPERFORMANCEMEDS + N1.IADLPERFORMANCESHOPPING + N1.IADLPERFORMANCETRANSPORT) = 30 AND (N2.IADLPERFORMANCEMEALS + N2.
              IADLPERFORMANCEHOUSEWORK + N2.IADLPERFORMANCEMEDS + N2.IADLPERFORMANCESHOPPING + N2.IADLPERFORMANCETRANSPORT) = 30 THEN
                  0
                  WHEN N1.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEHOUSEWORK IN (0, 1, 2, 3, 4, 5, 6) AND N2.
              IADLPERFORMANCEHOUSEWORK IN
                  (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6
              ) AND N2.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND (N2.
              IADLPERFORMANCEMEALS + N2.IADLPERFORMANCEHOUSEWORK + N2.IADLPERFORMANCEMEDS + N2.IADLPERFORMANCESHOPPING + N2.IADLPERFORMANCETRANSPORT) - (N1.IADLPERFORMANCEMEALS + N1.
              IADLPERFORMANCEHOUSEWORK + N1.IADLPERFORMANCEMEDS + N1.IADLPERFORMANCESHOPPING + N1.IADLPERFORMANCETRANSPORT) BETWEEN 0
                                                                                                                                AND 3 THEN
                  1
                  WHEN N1.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEALS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEHOUSEWORK IN (0, 1, 2, 3, 4, 5, 6) AND N2.
              IADLPERFORMANCEHOUSEWORK IN
                  (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6
              ) AND N2.IADLPERFORMANCESHOPPING IN (0, 1, 2, 3, 4, 5, 6) AND N1.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCETRANSPORT IN (0, 1, 2, 3, 4, 5, 6) AND (N2.
              IADLPERFORMANCEMEALS + N2.IADLPERFORMANCEHOUSEWORK + N2.IADLPERFORMANCEMEDS + N2.IADLPERFORMANCESHOPPING + N2.IADLPERFORMANCETRANSPORT) - (N1.IADLPERFORMANCEMEALS + N1.
              IADLPERFORMANCEHOUSEWORK + N1.IADLPERFORMANCEMEDS + N1.IADLPERFORMANCESHOPPING + N1.IADLPERFORMANCETRANSPORT) < 0 THEN
                  1
                  ELSE
                  0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_locomotion' AS MSR_TOKEN,
              (CASE WHEN N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLLOCOMOTION = 6 AND N2.ADLLOCOMOTION = 6 THEN 0
                  WHEN N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLLOCOMOTION <= N1.ADLLOCOMOTION THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_bathing' AS MSR_TOKEN,
              (CASE WHEN N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLBATHING = 6 AND N2.ADLBATHING = 6 THEN 0
                  WHEN N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLBATHING <= N1.ADLBATHING THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_toilettransfer' AS MSR_TOKEN,
              (CASE WHEN N2.ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLTOILETTRANSFER = 6 AND N2.ADLTOILETTRANSFER = 6 THEN 0
                  WHEN N2.ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLTOILETTRANSFER <= N1.ADLTOILETTRANSFER THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_dressupper' AS MSR_TOKEN,
              (CASE WHEN N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLDRESSUPPER = 6 AND N2.ADLDRESSUPPER = 6 THEN 0
                  WHEN N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLDRESSUPPER <= N1.ADLDRESSUPPER THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_dresslower' AS MSR_TOKEN,
              (CASE WHEN N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLDRESSLOWER = 6 AND N2.ADLDRESSLOWER = 6 THEN 0
                  WHEN N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLDRESSLOWER <= N1.ADLDRESSLOWER THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_toiletuse' AS MSR_TOKEN,
              (CASE WHEN N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLTOILETUSE = 6 AND N2.ADLTOILETUSE = 6 THEN 0
                  WHEN N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLTOILETUSE <= N1.ADLTOILETUSE THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_eating' AS MSR_TOKEN,
              (CASE WHEN N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.ADLEATING = 6 AND N2.ADLEATING = 6 THEN 0
                  WHEN N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) AND N2.ADLEATING <= N1.ADLEATING THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_urinary' AS MSR_TOKEN,
              (CASE WHEN N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.BLADDERCONTINENCE = 5 AND N2.BLADDERCONTINENCE = 5 THEN 0
                  WHEN N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) AND N2.BLADDERCONTINENCE <= N1.BLADDERCONTINENCE THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_managemeds' AS MSR_TOKEN,
              (CASE WHEN N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.IADLPERFORMANCEMEDS = 6 AND N2.IADLPERFORMANCEMEDS = 6 THEN 0
                  WHEN N1.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS IN (0, 1, 2, 3, 4, 5, 6) AND N2.IADLPERFORMANCEMEDS <= N1.IADLPERFORMANCEMEDS THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_cognitive' AS MSR_TOKEN,
              (CASE WHEN N1.CPS2_SCALE IS NOT NULL AND N2.CPS2_SCALE IS NOT NULL THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE WHEN N1.CPS2_SCALE = 6 AND N2.CPS2_SCALE = 6 THEN 0 WHEN N1.CPS2_SCALE IS NOT NULL AND N2.CPS2_SCALE IS NOT NULL AND N2.CPS2_SCALE <= N1.CPS2_SCALE THEN 1 ELSE 0 END) AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_understood' AS MSR_TOKEN,
              (CASE WHEN N1.SELFUNDERSTOOD IS NOT NULL AND N2.SELFUNDERSTOOD IS NOT NULL AND N1.UNDERSTANDOTHERS IS NOT NULL AND N2.UNDERSTANDOTHERS IS NOT NULL THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN N1.SELFUNDERSTOOD = 4 AND N2.SELFUNDERSTOOD = 4 AND N1.UNDERSTANDOTHERS = 4 AND N2.UNDERSTANDOTHERS = 4 THEN
                  0
                  WHEN N1.SELFUNDERSTOOD IS NOT NULL AND N2.SELFUNDERSTOOD IS NOT NULL AND N1.UNDERSTANDOTHERS IS NOT NULL AND N2.UNDERSTANDOTHERS IS NOT NULL AND (N2.SELFUNDERSTOOD + N2.
              UNDERSTANDOTHERS) <= (N1.SELFUNDERSTOOD + N1.UNDERSTANDOTHERS) THEN
                  1
                  ELSE
                  0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_pain' AS MSR_TOKEN,
              (CASE
                  WHEN (N1.PAININTENSITY IS NULL AND N2.PAININTENSITY IS NULL) OR (N1.PAINFREQUENCY IS NULL AND N2.PAINFREQUENCY IS NULL) OR (N1.PAININTENSITY IS NULL AND NVL(N1.PAINFREQUENCY, -1)
              <> 0) OR (N2.PAININTENSITY IS NULL AND NVL(N2.PAINFREQUENCY, -1) <> 0) THEN
                  0
                  ELSE
                  1
              END)
                  AS DENOMINATOR,
              (CASE
                  WHEN (CASE
                  WHEN (N1.PAININTENSITY IS NULL AND N2.PAININTENSITY IS NULL) OR (N1.PAINFREQUENCY IS NULL AND N2.PAINFREQUENCY IS NULL) OR (N1.PAININTENSITY IS NULL AND NVL(N1.PAINFREQUENCY, -1)
              <> 0) OR (N2.PAININTENSITY IS NULL AND NVL(N2.PAINFREQUENCY, -1) <> 0) THEN
                  0
                  ELSE
                  1
              END) = 1 AND (CASE WHEN NVL(N1.PAINFREQUENCY, -1) = 0 OR NVL(N1.PAININTENSITY, -1) = 0 THEN 0 ELSE N1.PAININTENSITY END) = 4 AND (CASE
                  WHEN NVL(N2.PAINFREQUENCY, -1) = 0 OR NVL(N2.PAININTENSITY, -1) = 0 THEN 0
                  ELSE N2.PAININTENSITY
              END) = 4 THEN
                  0
                  WHEN (CASE
                  WHEN (N1.PAININTENSITY IS NULL AND N2.PAININTENSITY IS NULL) OR (N1.PAINFREQUENCY IS NULL AND N2.PAINFREQUENCY IS NULL) OR (N1.PAININTENSITY IS NULL AND NVL(N1.PAINFREQUENCY, -1)
              <> 0) OR (N2.PAININTENSITY IS NULL AND NVL(N2.PAINFREQUENCY, -1) <> 0) THEN
                  0
                  ELSE
                  1
              END) = 1 AND ((CASE WHEN NVL(N2.PAINFREQUENCY, -1) = 0 OR NVL(N2.PAININTENSITY, -1) = 0 THEN 0 ELSE N2.PAININTENSITY END) <=
                  (CASE WHEN NVL(N1.PAINFREQUENCY, -1) = 0 OR NVL(N1.PAININTENSITY, -1) = 0 THEN 0 ELSE N1.PAININTENSITY END)) THEN
                  1
                  ELSE
                  0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_mood' AS MSR_TOKEN,
              (CASE WHEN NVL(N1.EXCLUDE_MOOD, 0) <> 1 AND NVL(N2.EXCLUDE_MOOD, 0) <> 1 THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE
                  WHEN NVL(N1.EXCLUDE_MOOD, 0) = 1 AND NVL(N2.EXCLUDE_MOOD, 0) = 1 THEN 0
                  WHEN N1.MOODSCALE = 5 AND N2.MOODSCALE = 5 THEN 0
                  WHEN N1.MOODSCALE IS NOT NULL AND N2.MOODSCALE IS NOT NULL AND N2.MOODSCALE <= N1.MOODSCALE THEN 1
                  ELSE 0
              END)
                  AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
              'pot_dyspnea' AS MSR_TOKEN,
              (CASE WHEN N1.DYSPNEA IS NOT NULL AND N2.DYSPNEA IS NOT NULL THEN 1 ELSE 0 END) AS DENOMINATOR,
              (CASE WHEN N1.DYSPNEA = 3 AND N2.DYSPNEA = 3 THEN 0 WHEN N1.DYSPNEA IS NOT NULL AND N2.DYSPNEA IS NOT NULL AND N2.DYSPNEA <= N1.DYSPNEA THEN 1 ELSE 0 END) AS NUMERATOR
              FROM   POT_CONT_DOH A
              JOIN choicebi.MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
              JOIN choicebi.MV_UAS_DETAILS N2 ON (A.RECORD_ID2 = N2.RECORD_ID))
    SELECT "MEDICAID_NUM",
           "SUBSCRIBER_ID",
           "QIP_MONTH_ID",
           "QIP_PERIOD",
           "LOB_ID",
           "ENROLLMENT_DATE",
           "DISENROLLMENT_DATE",
           "RECORD_ID1",
           "RECORD_ID2",
           "ASSESSMENTDATE1",
           "ASSESSMENTDATE2",
           "ASSESSMONTH",
           "NEXT_DUE",
           "NEXT_DUE_PERIOD",
           "ONURSEORG",
           "ONURSEORGNAME",
           "ONURSENAME",
           ONURSECOMPANY,
           "MEMBER_ID",
           "DL_LOB_ID",
           "DL_ENROLL_ID",
           "DL_PLAN_SK",
           "PROGRAM",
           "DL_LOB_GRP_ID",
           "DL_MEMBER_SK",
           "ASSESSMENTREASON1",
           "ASSESSMENTREASON2",
           "MSR_TOKEN",
           "DENOMINATOR",
           "NUMERATOR",
           QIP_FLAG
    FROM   POT_CONT_DOH_MEASURES_LONG;
    
    
    
    select*  from FACT_QUALITY_MEASURES