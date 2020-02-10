DROP VIEW V_QUALITY_RISK_MEASURES_LONG;

CREATE OR REPLACE VIEW V_QUALITY_RISK_MEASURES_LONG
(
    SOURCE,
    MEDICAID_NUM,
    SUBSCRIBER_ID,
    LOB_ID,
    REFERRAL_DATE,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE,
    CURRENT_PERIOD,
    NEXT_DUE_PERIOD,
    QIP_MONTH_ID,
    RESULTING_PERIOD,
    NEXT_DUE,
    RECORD_ID1,
    RECORD_ID2,
    RECORD_ID3,
    ASSESSMENT_REASON1,
    ASSESSMENT_REASON2,
    ASSESSMENT_REASON3,
    ASSESSMENT_DATE1,
    ASSESSMENT_DATE2,
    ASSESSMENT_DATE3,
    ASSESSMENT_MONTH1,
    ASSESSMENT_MONTH2,
    ASSESSMENT_MONTH3,
    ONURSEORG,
    ONURSEORGNAME,
    ONURSENAME,
    MSR_TOKEN,
    RISK,
    OUTCOME,
    RISK_NOTE,
    DESIRED_OUTCOME,
    DL_MEMBER_SK,
    MEMBER_ID,
    DL_LOB_GRP_ID,
    DL_LOB_ID,
    DL_ENROLL_ID,
    DL_PLAN_SK,
    PROGRAM
) AS
    WITH PREV_RISK AS
             ((SELECT DISTINCT
                      CURR.MEDICAID_NUM,
                      CURR.SUBSCRIBER_ID,
                      CURR.MRN,
                      CURR.CHOICE_CASE_NUM,
                      CURR.LOB_ID,
                      CURR.REFERRAL_DATE,
                      CURR.ENROLLMENT_DATE,
                      CURR.DISENROLLMENT_DATE,
                      TO_NUMBER(TO_CHAR(CURR.NEXT_DUE, 'YYYYMM'))
                          AS QIP_MONTH_ID,
                      CURR.QIP_PERIOD AS CURRENT_PERIOD,
                      CURR.NEXT_DUE_PERIOD,
                      RES.QIP_PERIOD AS RESULTING_PERIOD,
                      CURR.NEXT_DUE AS NEXT_DUE,
                      NVL(RES.ONURSEORG, CURR.ONURSEORG) AS ONURSEORG, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME)
                          AS ONURSEORGNAME, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      NVL(RES.ONURSENAME, CURR.ONURSENAME) AS ONURSENAME, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      CURR.RECORD_ID AS RECORD_ID1,
                      RES.RECORD_ID AS RECORD_ID2,
                      CURR.QIP_PERIOD AS QIP_PERIOD1,
                      RES.QIP_PERIOD AS QIP_PERIOD2,
                      CURR.ASSESSMENTDATE AS ASSESSMENTDATE1,
                      RES.ASSESSMENTDATE AS ASSESSMENTDATE2,
                      CURR.ASSESSMONTH AS ASSESSMONTH1,
                      RES.ASSESSMONTH AS ASSESSMONTH2,
                      CURR.NEXT_DUE AS NEXT_DUE1,
                      RES.NEXT_DUE AS NEXT_DUE2,
                      CURR.ASSESSMENTREASON AS ASSESSMENTREASON1,
                      RES.ASSESSMENTREASON AS ASSESSMENTREASON2,
                      CURR.DL_MEMBER_SK,
                      CURR.MEMBER_ID,
                      CURR.DL_LOB_GRP_ID,
                      CURR.DL_LOB_ID,
                      CURR.DL_ENROLL_ID,
                      --CURR.ASSESSMENT_SK_ID,
                      --CURR.PROV_SK_ID,
                      --CURR.PROVIDER_ID,
                      CURR.DL_PLAN_SK,
                      CURR.PROGRAM
               FROM                                                /*current*/
                   (  SELECT *
                      FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                      WHERE  QIP_FLAG = 1) CURR
                      LEFT JOIN /*"resulting" assessment six months later from current, where current year and resulting year are the same*/
                                    /* e.g. current 201601, resulting 201602*/
                       (SELECT *
                        FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                        WHERE  QIP_FLAG = 1) RES
                          ON (    CURR.SUBSCRIBER_ID = RES.SUBSCRIBER_ID
                              AND CURR.ENROLLMENT_DATE = RES.ENROLLMENT_DATE
                              AND CURR.RECORD_ID <> RES.RECORD_ID
                              AND RES.QIP_PERIOD - CURR.QIP_PERIOD = 1))
              UNION
              (SELECT DISTINCT
                      CURR.MEDICAID_NUM,
                      CURR.SUBSCRIBER_ID,
                      CURR.MRN,
                      CURR.CHOICE_CASE_NUM,
                      CURR.LOB_ID,
                      CURR.REFERRAL_DATE,
                      CURR.ENROLLMENT_DATE,
                      CURR.DISENROLLMENT_DATE,
                      TO_NUMBER(TO_CHAR(CURR.NEXT_DUE, 'YYYYMM'))
                          AS QIP_MONTH_ID,
                      CURR.QIP_PERIOD AS CURRENT_PERIOD,
                      CURR.NEXT_DUE_PERIOD,
                      RES.QIP_PERIOD AS RESULTING_PERIOD,
                      CURR.NEXT_DUE AS NEXT_DUE,
                      NVL(RES.ONURSEORG, CURR.ONURSEORG) AS ONURSEORG, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME)
                          AS ONURSEORGNAME, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      NVL(RES.ONURSENAME, CURR.ONURSENAME) AS ONURSENAME, --, NVL(RES.ONURSEORGNAME, CURR.ONURSEORGNAME) AS ONURSEORGNAME
                      CURR.RECORD_ID AS RECORD_ID1,
                      RES.RECORD_ID AS RECORD_ID2,
                      CURR.QIP_PERIOD AS QIP_PERIOD1,
                      RES.QIP_PERIOD AS QIP_PERIOD2,
                      CURR.ASSESSMENTDATE AS ASSESSMENTDATE1,
                      RES.ASSESSMENTDATE AS ASSESSMENTDATE2,
                      CURR.ASSESSMONTH AS ASSESSMONTH1,
                      RES.ASSESSMONTH AS ASSESSMONTH2,
                      CURR.NEXT_DUE AS NEXT_DUE1,
                      RES.NEXT_DUE AS NEXT_DUE2,
                      CURR.ASSESSMENTREASON AS ASSESSMENTREASON1,
                      RES.ASSESSMENTREASON AS ASSESSMENTREASON2,
                      CURR.DL_MEMBER_SK,
                      CURR.MEMBER_ID,
                      CURR.DL_LOB_GRP_ID,
                      CURR.DL_LOB_ID,
                      CURR.DL_ENROLL_ID,
                      --CURR.ASSESSMENT_SK_ID,
                      --CURR.PROV_SK_ID,
                      --CURR.PROVIDER_ID,
                      CURR.DL_PLAN_SK,
                      CURR.PROGRAM
               FROM                                                /*current*/
                   (  SELECT *
                      FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                      WHERE  QIP_FLAG = 1) CURR
                      LEFT JOIN /*"resulting" assessment six months later from current, where resulting year is after the current year*/
                                    /* e.g. current 201602, resulting 201701*/
                       (SELECT *
                        FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                        WHERE  QIP_FLAG = 1) RES
                          ON (    CURR.SUBSCRIBER_ID = RES.SUBSCRIBER_ID
                              AND CURR.ENROLLMENT_DATE = RES.ENROLLMENT_DATE
                              AND CURR.RECORD_ID <> RES.RECORD_ID
                              AND RES.QIP_PERIOD - CURR.QIP_PERIOD = 99))) /*deduplicate prev dataset*/
                                                                          ,
         PREV_RISK_CONT AS
             (SELECT *
              FROM   (SELECT C.* /*prioritize assessment groupings with earliest baseline assessment for the most recent enrollment per member/qip_period*/
                                ,
                             ROW_NUMBER()
                             OVER (
                                 PARTITION BY SUBSCRIBER_ID,
                                              LOB_ID,
                                              CURRENT_PERIOD
                                 ORDER BY
                                     ASSESSMENTDATE1 ASC,
                                     ASSESSMENTDATE2 DESC NULLS LAST)
                                 AS SORT_SEQ
                      FROM   PREV_RISK C)
              WHERE  SORT_SEQ = 1),
         PREV_RISK_MEASURES_PROJ AS
             (SELECT A.*,
                     'locomotion' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLLOCOMOTION IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLLOCOMOTION IN (3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'bathing' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLBATHING IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE WHEN ADLBATHING IN (3, 4, 5, 6) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'toilettransfer' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN ADLTOILETTRANSFER IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLTOILETTRANSFER IN (3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dressupper' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLDRESSUPPER IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLDRESSUPPER IN (3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dresslower' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLDRESSLOWER IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLDRESSLOWER IN (3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'toiletuse' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLTOILETUSE IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLTOILETUSE IN (3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'eating' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLEATING IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLEATING IN (0, 1) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN ADLEATING IN (2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'adlmeds' AS MSR_TOKEN,
                     (CASE
                          WHEN IADLPERFORMANCEMEDS IS NOT NULL THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN IADLPERFORMANCEMEDS = 0 THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE
                          WHEN IADLPERFORMANCEMEDS IN (1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'urinary' AS MSR_TOKEN,
                     (CASE
                          WHEN BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN BLADDERCONTINENCE IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN BLADDERCONTINENCE IN (3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'bowel' AS MSR_TOKEN,
                     (CASE
                          WHEN BOWELCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN BOWELCONTINENCE IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN BOWELCONTINENCE IN (3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'cognitive' AS MSR_TOKEN,
                     (CASE
                          WHEN     COGNITIVESKILLS IS NOT NULL
                               AND MEMORYRECALLSHORT IS NOT NULL
                               AND MEMORYRECALLPROCEDURAL IS NOT NULL
                               AND SELFUNDERSTOOD IS NOT NULL
                               AND ADLEATING IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     COGNITIVESKILLS IS NOT NULL
                               AND MEMORYRECALLSHORT IS NOT NULL
                               AND MEMORYRECALLPROCEDURAL IS NOT NULL
                               AND SELFUNDERSTOOD IS NOT NULL
                               AND ADLEATING IS NOT NULL
                               AND CPS2_SCALE IN (0, 1) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN CPS2_SCALE IN (2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'behavioral' AS MSR_TOKEN,
                     (CASE
                          WHEN     BEHAVIORWANDERING IS NOT NULL
                               AND BEHAVIORVERBAL IS NOT NULL
                               AND BEHAVIORPHYSICAL IS NOT NULL
                               AND BEHAVIORDISRUPTIVE IS NOT NULL
                               AND BEHAVIORSEXUAL IS NOT NULL
                               AND BEHAVIORRESISTS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     BEHAVIORWANDERING = 0
                               AND BEHAVIORVERBAL = 0
                               AND BEHAVIORPHYSICAL = 0
                               AND BEHAVIORDISRUPTIVE = 0
                               AND BEHAVIORSEXUAL = 0
                               AND BEHAVIORRESISTS = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN    BEHAVIORWANDERING IN (1, 2, 3)
                               OR BEHAVIORVERBAL IN (1, 2, 3)
                               OR BEHAVIORPHYSICAL IN (1, 2, 3)
                               OR BEHAVIORDISRUPTIVE IN (1, 2, 3)
                               OR BEHAVIORSEXUAL IN (1, 2, 3)
                               OR BEHAVIORRESISTS IN (1, 2, 3) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'livingarr' AS MSR_TOKEN,
                     (CASE
                          WHEN LIVINGARRANGEMENT IS NOT NULL THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN LIVINGARRANGEMENT = 1 THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE WHEN LIVINGARRANGEMENT = 1 THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'anxious' AS MSR_TOKEN,
                     (CASE WHEN MOODANXIOUS IN (0, 1, 2, 3) THEN 1 ELSE 0 END)
                         AS DENOMINATOR,
                     (CASE WHEN MOODANXIOUS IN (0) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE WHEN MOODANXIOUS IN (1, 2, 3) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'depressed' AS MSR_TOKEN,
                     (CASE WHEN MOODSAD IN (0, 1, 2, 3) THEN 1 ELSE 0 END)
                         AS DENOMINATOR,
                     (CASE WHEN MOODSAD IN (0) THEN 1 ELSE 0 END)
                         AS NUMERATOR,
                     (CASE WHEN MOODSAD IN (1, 2, 3) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dyspnea' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND DYSPNEA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND DYSPNEA = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN DYSPNEA IN (1, 2, 3) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'noseverepain' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND PAININTENSITY IS NOT NULL
                               AND PAINFREQUENCY IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN        NVL(B.ASSESSMENTREASON, 0) <> 1
                                  AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                                  AND PAININTENSITY IN (0, 1, 2)
                               OR (    PAININTENSITY IN (3, 4)
                                   AND PAINFREQUENCY IN (0, 1)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     PAININTENSITY IN (3, 4)
                               AND PAINFREQUENCY IN (2, 3) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'paincontrol' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (    PAINFREQUENCY IS NOT NULL
                                    AND PAINCONTROL IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   (    PAINFREQUENCY = 0
                                        AND PAINCONTROL IS NOT NULL)
                                    OR (    PAINFREQUENCY IN (1, 2, 3)
                                        AND PAINCONTROL IN (0, 1, 2))) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN PAINCONTROL IN (3, 4, 5) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'notlonely' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND LONELY IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   LONELY = 0
                                    OR (    LONELY = 1
                                        AND (    NVL(SOCIALCHANGEACTIVITIES,
                                                     0) < 1
                                             AND NVL(TIMEALONE, 0) <> 3
                                             AND NVL(LIFESTRESSORS, 0) <> 1
                                             AND NVL(WITHDRAWAL, 0) < 1
                                             AND NVL(MOODSAD, 0) < 1))) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     LONELY = 1
                               AND (   SOCIALCHANGEACTIVITIES IN (1, 2)
                                    OR TIMEALONE = 3
                                    OR LIFESTRESSORS = 1
                                    OR WITHDRAWAL IN (1, 2, 3)
                                    OR MOODSAD IN (1, 2, 3)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'fluvax' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINFLUENZA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINFLUENZA = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN TXINFLUENZA = 0 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'pneumovax' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND AGE >= 65
                               AND TXPNEUMOVAX IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND AGE >= 65
                               AND TXPNEUMOVAX = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     AGE >= 65
                               AND TXPNEUMOVAX = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dental' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXDENTAL IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXDENTAL = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN TXDENTAL = 0 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'eye' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXEYE IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXEYE = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN TXEYE = 0 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'hearing' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXHEARING IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXHEARING = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN TXHEARING = 0 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'mammogram' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND GENDER = '2'
                               AND AGE BETWEEN 50 AND 74
                               AND TXMAMMOGRAM IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND GENDER = '2'
                               AND AGE BETWEEN 50 AND 74
                               AND TXMAMMOGRAM = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     GENDER = '2'
                               AND AGE BETWEEN 50 AND 74
                               AND TXMAMMOGRAM = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'nofalls' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLSMEDICAL IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLSMEDICAL = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN FALLSMEDICAL IN (1, 2, 3) THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'nofallsinj' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(b.assessmentreason, 0) <> 1
                               AND NVL(b.residenceassessment, 0) <> 7
                               AND b.assessmentdate >= '07-NOV-2017' THEN
                              1
                          ELSE
                              0
                      END)
                         AS denominator,
                     (CASE
                          WHEN     NVL(b.assessmentreason, 0) <> 1
                               AND NVL(b.residenceassessment, 0) <> 7
                               AND b.assessmentdate >= '07-NOV-2017'
                               AND NVL(fallsminorinj, 0) = 0
                               AND NVL(fallsmajorinj, 0) = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS numerator,
                     (CASE
                          WHEN    fallsmedical IN (1, 2, 3)
                               OR NVL(fallsminorinj, 0) > 0
                               OR NVL(fallsmajorinj, 0) > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS risk
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'noER' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXEMERGENCY = 0
                                    OR TXEMERGENCY IS NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN NVL(TXEMERGENCY, 0) > 0 THEN 1 ELSE 0 END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'falls' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLS IN (1, 2, 3) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN FALLS IN (1, 2, 3) THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'fracture' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   MUSCULOSKELETALHIP IS NOT NULL
                                    OR MUSCULOSKELETALOTHERFRACTURE
                                           IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   MUSCULOSKELETALHIP IN (1, 2, 3)
                                    OR MUSCULOSKELETALOTHERFRACTURE IN
                                           (1, 2, 3)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN (   MUSCULOSKELETALHIP IN (1, 2, 3)
                                OR MUSCULOSKELETALOTHERFRACTURE IN (1, 2, 3)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'hosp_er' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXINPATIENT IS NOT NULL
                                    OR TXEMERGENCY IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXINPATIENT > 0
                                    OR TXEMERGENCY > 0) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN    TXINPATIENT > 0
                               OR TXEMERGENCY > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'inpatient' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINPATIENT > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN TXINPATIENT > 0 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'weightloss' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND WEIGHTLOSS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND WEIGHTLOSS = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE WHEN WEIGHTLOSS = 1 THEN 1 ELSE 0 END) AS RISK
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID1 = B.RECORD_ID)),
         PREV_RISK_MEASURES_OBS AS
             (SELECT A.*,
                     'locomotion' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLLOCOMOTION IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'bathing' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLBATHING IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'toilettransfer' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLTOILETTRANSFER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN ADLTOILETTRANSFER IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dressupper' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLDRESSUPPER IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dresslower' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLDRESSLOWER IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'toiletuse' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLTOILETUSE IN (0, 1, 2) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'eating' AS MSR_TOKEN,
                     (CASE
                          WHEN ADLEATING IN (0, 1, 2, 3, 4, 5, 6) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN ADLEATING IN (0, 1) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'adlmeds' AS MSR_TOKEN,
                     (CASE
                          WHEN IADLPERFORMANCEMEDS IS NOT NULL THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN IADLPERFORMANCEMEDS = 0 THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'urinary' AS MSR_TOKEN,
                     (CASE
                          WHEN BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN BLADDERCONTINENCE IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'bowel' AS MSR_TOKEN,
                     (CASE
                          WHEN BOWELCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN BOWELCONTINENCE IN (0, 1, 2) THEN 1
                          ELSE 0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'cognitive' AS MSR_TOKEN,
                     (CASE
                          WHEN     COGNITIVESKILLS IS NOT NULL
                               AND MEMORYRECALLSHORT IS NOT NULL
                               AND MEMORYRECALLPROCEDURAL IS NOT NULL
                               AND SELFUNDERSTOOD IS NOT NULL
                               AND ADLEATING IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     COGNITIVESKILLS IS NOT NULL
                               AND MEMORYRECALLSHORT IS NOT NULL
                               AND MEMORYRECALLPROCEDURAL IS NOT NULL
                               AND SELFUNDERSTOOD IS NOT NULL
                               AND ADLEATING IS NOT NULL
                               AND CPS2_SCALE IN (0, 1) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'behavioral' AS MSR_TOKEN,
                     (CASE
                          WHEN     BEHAVIORWANDERING IS NOT NULL
                               AND BEHAVIORVERBAL IS NOT NULL
                               AND BEHAVIORPHYSICAL IS NOT NULL
                               AND BEHAVIORDISRUPTIVE IS NOT NULL
                               AND BEHAVIORSEXUAL IS NOT NULL
                               AND BEHAVIORRESISTS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     BEHAVIORWANDERING = 0
                               AND BEHAVIORVERBAL = 0
                               AND BEHAVIORPHYSICAL = 0
                               AND BEHAVIORDISRUPTIVE = 0
                               AND BEHAVIORSEXUAL = 0
                               AND BEHAVIORRESISTS = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'livingarr' AS MSR_TOKEN,
                     (CASE
                          WHEN LIVINGARRANGEMENT IS NOT NULL THEN 1
                          ELSE 0
                      END)
                         AS DENOMINATOR,
                     (CASE WHEN LIVINGARRANGEMENT = 1 THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'anxious' AS MSR_TOKEN,
                     (CASE WHEN MOODANXIOUS IN (0, 1, 2, 3) THEN 1 ELSE 0 END)
                         AS DENOMINATOR,
                     (CASE WHEN MOODANXIOUS IN (0) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'depressed' AS MSR_TOKEN,
                     (CASE WHEN MOODSAD IN (0, 1, 2, 3) THEN 1 ELSE 0 END)
                         AS DENOMINATOR,
                     (CASE WHEN MOODSAD IN (0) THEN 1 ELSE 0 END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dyspnea' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND DYSPNEA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND DYSPNEA = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'noseverepain' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND PAININTENSITY IS NOT NULL
                               AND PAINFREQUENCY IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN        NVL(B.ASSESSMENTREASON, 0) <> 1
                                  AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                                  AND PAININTENSITY IN (0, 1, 2)
                               OR (    PAININTENSITY IN (3, 4)
                                   AND PAINFREQUENCY IN (0, 1)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'paincontrol' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (    PAINFREQUENCY IS NOT NULL
                                    AND PAINCONTROL IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   (    PAINFREQUENCY = 0
                                        AND PAINCONTROL IS NOT NULL)
                                    OR (    PAINFREQUENCY IN (1, 2, 3)
                                        AND PAINCONTROL IN (0, 1, 2))) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'notlonely' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND LONELY IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   LONELY = 0
                                    OR (    LONELY = 1
                                        AND (    NVL(SOCIALCHANGEACTIVITIES,
                                                     0) < 1
                                             AND NVL(TIMEALONE, 0) <> 3
                                             AND NVL(LIFESTRESSORS, 0) <> 1
                                             AND NVL(WITHDRAWAL, 0) < 1
                                             AND NVL(MOODSAD, 0) < 1))) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'fluvax' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINFLUENZA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINFLUENZA = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'pneumovax' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND AGE >= 65
                               AND TXPNEUMOVAX IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND AGE >= 65
                               AND TXPNEUMOVAX = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'dental' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXDENTAL IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXDENTAL = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'eye' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXEYE IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXEYE = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'hearing' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXHEARING IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXHEARING = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'mammogram' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND GENDER = '2'
                               AND AGE BETWEEN 50 AND 74
                               AND TXMAMMOGRAM IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND GENDER = '2'
                               AND AGE BETWEEN 50 AND 74
                               AND TXMAMMOGRAM = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'nofalls' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLSMEDICAL IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLSMEDICAL = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'nofallsinj' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(b.assessmentreason, 0) <> 1
                               AND NVL(b.residenceassessment, 0) <> 7
                               AND b.assessmentdate >= '07-NOV-2017' THEN
                              1
                          ELSE
                              0
                      END)
                         AS denominator,
                     (CASE
                          WHEN     NVL(b.assessmentreason, 0) <> 1
                               AND NVL(b.residenceassessment, 0) <> 7
                               AND b.assessmentdate >= '07-NOV-2017'
                               AND NVL(fallsminorinj, 0) = 0
                               AND NVL(fallsmajorinj, 0) = 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS numerator
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'noER' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXEMERGENCY = 0
                                    OR TXEMERGENCY IS NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'falls' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND FALLS IN (1, 2, 3) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'fracture' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   MUSCULOSKELETALHIP IS NOT NULL
                                    OR MUSCULOSKELETALOTHERFRACTURE
                                           IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   MUSCULOSKELETALHIP IN (1, 2, 3)
                                    OR MUSCULOSKELETALOTHERFRACTURE IN
                                           (1, 2, 3)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'hosp_er' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXINPATIENT IS NOT NULL
                                    OR TXEMERGENCY IS NOT NULL) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND (   TXINPATIENT > 0
                                    OR TXEMERGENCY > 0) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'inpatient' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND TXINPATIENT > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)
              UNION
              SELECT A.*,
                     'weightloss' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND WEIGHTLOSS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(B.ASSESSMENTREASON, 0) <> 1
                               AND NVL(B.RESIDENCEASSESSMENT, 0) <> 7
                               AND WEIGHTLOSS = 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   PREV_RISK_CONT A
                     JOIN MV_UAS_DETAILS B ON (A.RECORD_ID2 = B.RECORD_ID)),
         /*--dataset for monitoring performance at the member level (6-month episodes)*/
         RISK AS
             (SELECT DISTINCT
                     BASE.MEDICAID_NUM,
                     BASE.SUBSCRIBER_ID,
                     BASE.MRN,
                     BASE.CHOICE_CASE_NUM,
                     BASE.LOB_ID,
                     BASE.REFERRAL_DATE,
                     BASE.ENROLLMENT_DATE,
                     BASE.DISENROLLMENT_DATE,
                     NVL(CURR.QIP_PERIOD, BASE.QIP_PERIOD) AS CURRENT_PERIOD,
                     DECODE(CURR.MEDICAID_NUM,
                            NULL, BASE.NEXT_DUE_PERIOD,
                            CURR.NEXT_DUE_PERIOD)
                         AS NEXT_DUE_PERIOD,
                     RES.QIP_PERIOD AS RESULTING_PERIOD,
                     TO_NUMBER(
                         TO_CHAR(
                             DECODE(CURR.MEDICAID_NUM,
                                    NULL, BASE.NEXT_DUE,
                                    CURR.NEXT_DUE),
                             'YYYYMM'))
                         AS QIP_MONTH_ID,
                     DECODE(CURR.MEDICAID_NUM,
                            NULL, BASE.NEXT_DUE,
                            CURR.NEXT_DUE)
                         AS NEXT_DUE,
                     DECODE(RES.ONURSEORG,
                            NULL, NVL(CURR.ONURSEORG, BASE.ONURSEORG),
                            RES.ONURSEORG)
                         AS ONURSEORG, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     DECODE(
                         RES.ONURSEORGNAME,
                         NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME),
                         RES.ONURSEORGNAME)
                         AS ONURSEORGNAME, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     DECODE(RES.ONURSENAME,
                            NULL, NVL(CURR.ONURSENAME, BASE.ONURSENAME),
                            RES.ONURSENAME)
                         AS ONURSENAME, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     BASE.RECORD_ID AS RECORD_ID1,
                     CURR.RECORD_ID AS RECORD_ID2,
                     RES.RECORD_ID AS RECORD_ID3,
                     BASE.QIP_PERIOD AS QIP_PERIOD1,
                     CURR.QIP_PERIOD AS QIP_PERIOD2,
                     RES.QIP_PERIOD AS QIP_PERIOD3,
                     BASE.ASSESSMENTDATE AS ASSESSMENTDATE1,
                     CURR.ASSESSMENTDATE AS ASSESSMENTDATE2,
                     RES.ASSESSMENTDATE AS ASSESSMENTDATE3,
                     BASE.ASSESSMONTH AS ASSESSMONTH1,
                     CURR.ASSESSMONTH AS ASSESSMONTH2,
                     RES.ASSESSMONTH AS ASSESSMONTH3,
                     BASE.NEXT_DUE AS NEXT_DUE1,
                     CURR.NEXT_DUE AS NEXT_DUE2,
                     RES.NEXT_DUE AS NEXT_DUE3,
                     BASE.ASSESSMENTREASON AS ASSESSMENTREASON1,
                     CURR.ASSESSMENTREASON AS ASSESSMENTREASON2,
                     RES.ASSESSMENTREASON AS ASSESSMENTREASON3,
                     MONTHS_BETWEEN(CURR.ASSESSMONTH, BASE.ASSESSMONTH) + 1
                         AS ASSESSMONTH_DIFF12,
                     MONTHS_BETWEEN(RES.ASSESSMONTH, BASE.ASSESSMONTH) + 1
                         AS ASSESSMONTH_DIFF13,
                     CASE
                         WHEN BASE.ASSESSMENTREASON = 1 THEN
                               MONTHS_BETWEEN(
                                   CURR.ASSESSMONTH,
                                   TRUNC(BASE.ENROLLMENT_DATE, 'MM'))
                             + 1
                         ELSE
                             NULL
                     END
                         AS ENROLLMONTH_DIFF,
                     BASE.DL_MEMBER_SK,
                     BASE.MEMBER_ID,
                     BASE.DL_LOB_GRP_ID,
                     BASE.DL_LOB_ID,
                     BASE.DL_ENROLL_ID,
                     --BASE.ASSESSMENT_SK_ID,
                     --BASE.PROV_SK_ID,
                     --BASE.PROVIDER_ID,
                     BASE.DL_PLAN_SK,
                     BASE.PROGRAM
              FROM                                                /*baseline*/
                  (  SELECT *
                     FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                     WHERE  QIP_FLAG = 1) BASE
                     LEFT JOIN /*"current" assessment six months later from baseline, where baseline year and current year are the same*/
                                     /* e.g. baseline 201601, current 201602*/
                      (SELECT *
                       FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                       WHERE      QIP_FLAG = 1
                              AND NVL(ASSESSMENTREASON, 0) <> 1
                              AND NVL(RESIDENCEASSESSMENT, 0) <> 7) CURR
                         ON (    CURR.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID
                             AND CURR.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE
                             AND CURR.RECORD_ID <> BASE.RECORD_ID
                             AND CURR.QIP_PERIOD - BASE.QIP_PERIOD = 1)
                     LEFT JOIN /*the "resulting" assessment, one year later from "baseline" assessment (baseline and current years are prior to "resulting" year) */
                    /*e.g. baseline 201601, current 201602, resulting 201701*/
                      (SELECT *
                       FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                       WHERE      QIP_FLAG = 1
                              AND NVL(ASSESSMENTREASON, 0) <> 1
                              AND NVL(RESIDENCEASSESSMENT, 0) <> 7) RES
                         ON (    RES.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID
                             AND RES.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE
                             AND RES.RECORD_ID <> BASE.RECORD_ID
                             AND RES.QIP_PERIOD - BASE.QIP_PERIOD = 100)
              UNION
              SELECT DISTINCT
                     BASE.MEDICAID_NUM,
                     BASE.SUBSCRIBER_ID,
                     BASE.MRN,
                     BASE.CHOICE_CASE_NUM,
                     BASE.LOB_ID,
                     BASE.REFERRAL_DATE,
                     BASE.ENROLLMENT_DATE,
                     BASE.DISENROLLMENT_DATE,
                     NVL(CURR.QIP_PERIOD, BASE.QIP_PERIOD) AS CURRENT_PERIOD,
                     DECODE(CURR.MEDICAID_NUM,
                            NULL, BASE.NEXT_DUE_PERIOD,
                            CURR.NEXT_DUE_PERIOD)
                         AS NEXT_DUE_PERIOD,
                     RES.QIP_PERIOD AS RESULTING_PERIOD,
                     TO_NUMBER(
                         TO_CHAR(
                             DECODE(CURR.MEDICAID_NUM,
                                    NULL, BASE.NEXT_DUE,
                                    CURR.NEXT_DUE),
                             'YYYYMM'))
                         AS QIP_MONTH_ID,
                     DECODE(CURR.MEDICAID_NUM,
                            NULL, BASE.NEXT_DUE,
                            CURR.NEXT_DUE)
                         AS NEXT_DUE,
                     DECODE(RES.ONURSEORG,
                            NULL, NVL(CURR.ONURSEORG, BASE.ONURSEORG),
                            RES.ONURSEORG)
                         AS ONURSEORG, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     DECODE(
                         RES.ONURSEORGNAME,
                         NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME),
                         RES.ONURSEORGNAME)
                         AS ONURSEORGNAME, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     DECODE(RES.ONURSENAME,
                            NULL, NVL(CURR.ONURSENAME, BASE.ONURSENAME),
                            RES.ONURSENAME)
                         AS ONURSENAME, --, DECODE(RES.ONURSEORGNAME, NULL, NVL(CURR.ONURSEORGNAME, BASE.ONURSEORGNAME), RES.ONURSEORGNAME) AS ONURSEORGNAME
                     BASE.RECORD_ID AS RECORD_ID1,
                     CURR.RECORD_ID AS RECORD_ID2,
                     RES.RECORD_ID AS RECORD_ID3,
                     BASE.QIP_PERIOD AS QIP_PERIOD1,
                     CURR.QIP_PERIOD AS QIP_PERIOD2,
                     RES.QIP_PERIOD AS QIP_PERIOD3,
                     BASE.ASSESSMENTDATE AS ASSESSMENTDATE1,
                     CURR.ASSESSMENTDATE AS ASSESSMENTDATE2,
                     RES.ASSESSMENTDATE AS ASSESSMENTDATE3,
                     BASE.ASSESSMONTH AS ASSESSMONTH1,
                     CURR.ASSESSMONTH AS ASSESSMONTH2,
                     RES.ASSESSMONTH AS ASSESSMONTH3,
                     BASE.NEXT_DUE AS NEXT_DUE1,
                     CURR.NEXT_DUE AS NEXT_DUE2,
                     RES.NEXT_DUE AS NEXT_DUE3,
                     BASE.ASSESSMENTREASON AS ASSESSMENTREASON1,
                     CURR.ASSESSMENTREASON AS ASSESSMENTREASON2,
                     RES.ASSESSMENTREASON AS ASSESSMENTREASON3,
                     MONTHS_BETWEEN(CURR.ASSESSMONTH, BASE.ASSESSMONTH) + 1
                         AS ASSESSMONTH_DIFF12,
                     MONTHS_BETWEEN(RES.ASSESSMONTH, BASE.ASSESSMONTH) + 1
                         AS ASSESSMONTH_DIFF13,
                     CASE
                         WHEN BASE.ASSESSMENTREASON = 1 THEN
                               MONTHS_BETWEEN(
                                   CURR.ASSESSMONTH,
                                   TRUNC(BASE.ENROLLMENT_DATE, 'MM'))
                             + 1
                         ELSE
                             NULL
                     END
                         AS ENROLLMONTH_DIFF,
                     BASE.DL_MEMBER_SK,
                     BASE.MEMBER_ID,
                     BASE.DL_LOB_GRP_ID,
                     BASE.DL_LOB_ID,
                     BASE.DL_ENROLL_ID,
                     --BASE.ASSESSMENT_SK_ID,
                     --BASE.PROV_SK_ID,
                     --BASE.PROVIDER_ID,
                     BASE.DL_PLAN_SK,
                     BASE.PROGRAM
              FROM                                                /*baseline*/
                  (  SELECT *
                     FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                     WHERE  QIP_FLAG = 1) BASE
                     LEFT JOIN /*"current" assessment six months later from baseline, where baseline year is prior to current year */
                                      /*e.g. baseline 201602, current 201701*/
                      (SELECT *
                       FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                       WHERE      QIP_FLAG = 1
                              AND NVL(ASSESSMENTREASON, 0) <> 1
                              AND NVL(RESIDENCEASSESSMENT, 0) <> 7) CURR
                         ON (    CURR.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID
                             AND CURR.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE
                             AND CURR.RECORD_ID <> BASE.RECORD_ID
                             AND CURR.QIP_PERIOD - BASE.QIP_PERIOD = 99)
                     LEFT JOIN /*the "resulting" assessment, one year later from "baseline" assessment (baseline year is prior to current and "resulting" years)*/
                    /*e.g. baseline 201602, current 201701, resulting 201702*/
                      (SELECT *
                       FROM   MV_QUALITY_MEASURE_ALL_ASSESS
                       WHERE      QIP_FLAG = 1
                              AND NVL(ASSESSMENTREASON, 0) <> 1
                              AND NVL(RESIDENCEASSESSMENT, 0) <> 7) RES
                         ON (    RES.SUBSCRIBER_ID = BASE.SUBSCRIBER_ID
                             AND RES.ENROLLMENT_DATE = BASE.ENROLLMENT_DATE
                             AND RES.RECORD_ID <> BASE.RECORD_ID
                             AND RES.QIP_PERIOD - BASE.QIP_PERIOD = 100)) /*--risk_cont*/
                                                                         /*ensure continuous enrollment in same plan between previous and most recent UAS*/
         ,
         RISK_CONT AS
             (SELECT *
              FROM   (SELECT C.* /*prioritize assessment groupings with earliest baseline assessment for the most recent enrollment per member/qip_period*/
                                ,
                             ROW_NUMBER()
                             OVER (
                                 PARTITION BY SUBSCRIBER_ID,
                                              LOB_ID,
                                              CURRENT_PERIOD
                                 ORDER BY
                                     ENROLLMENT_DATE DESC, ASSESSMENTDATE1)
                                 AS SORT_SEQ
                      FROM   RISK C)
              WHERE  SORT_SEQ = 1),
         RISK_CONT_MEASURES_PROJ AS
             (SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_nfloc' AS MSR_TOKEN,
                     1 AS DENOMINATOR,
                     (CASE
                          WHEN     N1.LEVELOFCARESCORE = 48
                               AND N2.LEVELOFCARESCORE = 48 THEN
                              0
                          WHEN     N1.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE BETWEEN 0
                                                                                 AND 4 THEN
                              1
                          WHEN     N1.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE <
                                       0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.LEVELOFCARESCORE = 48
                               AND N2.LEVELOFCARESCORE IS NULL THEN
                              1
                          WHEN N2.LEVELOFCARESCORE = 48 THEN
                              1
                          WHEN     N1.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE >
                                       3 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_adl' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.ADLLOCOMOTION
                                    + N1.ADLHYGIENE
                                    + N1.ADLBATHING) = 18
                               AND (  N2.ADLLOCOMOTION
                                    + N2.ADLHYGIENE
                                    + N2.ADLBATHING) = 18 THEN
                              0
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.ADLLOCOMOTION
                                      + N2.ADLHYGIENE
                                      + N2.ADLBATHING)
                                   - (  N1.ADLLOCOMOTION
                                      + N1.ADLHYGIENE
                                      + N1.ADLBATHING) BETWEEN 0
                                                           AND 2 THEN
                              1
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.ADLLOCOMOTION
                                      + N2.ADLHYGIENE
                                      + N2.ADLBATHING)
                                   - (  N1.ADLLOCOMOTION
                                      + N1.ADLHYGIENE
                                      + N1.ADLBATHING) < 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.ADLLOCOMOTION
                                    + N1.ADLHYGIENE
                                    + N1.ADLBATHING) = 18
                               AND NVL(N2.ADLLOCOMOTION, 8) = 8
                               AND NVL(N2.ADLHYGIENE, 8) = 8
                               AND NVL(N2.ADLBATHING, 8) = 8 THEN
                              1
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND (  N2.ADLLOCOMOTION
                                    + N2.ADLHYGIENE
                                    + N2.ADLBATHING) = 18 THEN
                              1
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.ADLLOCOMOTION
                                      + N2.ADLHYGIENE
                                      + N2.ADLBATHING)
                                   - (  N1.ADLLOCOMOTION
                                      + N1.ADLHYGIENE
                                      + N1.ADLBATHING) > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_iadl' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.IADLPERFORMANCEMEALS
                                    + N1.IADLPERFORMANCEHOUSEWORK
                                    + N1.IADLPERFORMANCEMEDS
                                    + N1.IADLPERFORMANCESHOPPING
                                    + N1.IADLPERFORMANCETRANSPORT) = 30
                               AND (  N2.IADLPERFORMANCEMEALS
                                    + N2.IADLPERFORMANCEHOUSEWORK
                                    + N2.IADLPERFORMANCEMEDS
                                    + N2.IADLPERFORMANCESHOPPING
                                    + N2.IADLPERFORMANCETRANSPORT) = 30 THEN
                              0
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.IADLPERFORMANCEMEALS
                                      + N2.IADLPERFORMANCEHOUSEWORK
                                      + N2.IADLPERFORMANCEMEDS
                                      + N2.IADLPERFORMANCESHOPPING
                                      + N2.IADLPERFORMANCETRANSPORT)
                                   - (  N1.IADLPERFORMANCEMEALS
                                      + N1.IADLPERFORMANCEHOUSEWORK
                                      + N1.IADLPERFORMANCEMEDS
                                      + N1.IADLPERFORMANCESHOPPING
                                      + N1.IADLPERFORMANCETRANSPORT) BETWEEN 0
                                                                         AND 3 THEN
                              1
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.IADLPERFORMANCEMEALS
                                      + N2.IADLPERFORMANCEHOUSEWORK
                                      + N2.IADLPERFORMANCEMEDS
                                      + N2.IADLPERFORMANCESHOPPING
                                      + N2.IADLPERFORMANCETRANSPORT)
                                   - (  N1.IADLPERFORMANCEMEALS
                                      + N1.IADLPERFORMANCEHOUSEWORK
                                      + N1.IADLPERFORMANCEMEDS
                                      + N1.IADLPERFORMANCESHOPPING
                                      + N1.IADLPERFORMANCETRANSPORT) < 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.IADLPERFORMANCEMEALS
                                    + N1.IADLPERFORMANCEHOUSEWORK
                                    + N1.IADLPERFORMANCEMEDS
                                    + N1.IADLPERFORMANCESHOPPING
                                    + N1.IADLPERFORMANCETRANSPORT) = 30
                               AND NVL(N2.IADLPERFORMANCEMEALS, 8) = 8
                               AND NVL(N2.IADLPERFORMANCEHOUSEWORK, 8) = 8
                               AND NVL(N2.IADLPERFORMANCESHOPPING, 8) = 8
                               AND NVL(N2.IADLPERFORMANCETRANSPORT, 8) = 8 THEN
                              1
                          WHEN     N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND (  N2.IADLPERFORMANCEMEALS
                                    + N2.IADLPERFORMANCEHOUSEWORK
                                    + N2.IADLPERFORMANCEMEDS
                                    + N2.IADLPERFORMANCESHOPPING
                                    + N2.IADLPERFORMANCETRANSPORT) = 30 THEN
                              1
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.IADLPERFORMANCEMEALS
                                      + N2.IADLPERFORMANCEHOUSEWORK
                                      + N2.IADLPERFORMANCEMEDS
                                      + N2.IADLPERFORMANCESHOPPING
                                      + N2.IADLPERFORMANCETRANSPORT)
                                   - (  N1.IADLPERFORMANCEMEALS
                                      + N1.IADLPERFORMANCEHOUSEWORK
                                      + N1.IADLPERFORMANCEMEDS
                                      + N1.IADLPERFORMANCESHOPPING
                                      + N1.IADLPERFORMANCETRANSPORT) > 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_locomotion' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION = 6
                               AND N2.ADLLOCOMOTION = 6 THEN
                              0
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION <= N1.ADLLOCOMOTION THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION = 6
                               AND NVL(N2.ADLLOCOMOTION, 8) = 8 THEN
                              1
                          WHEN N2.ADLLOCOMOTION = 6 THEN
                              1
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION > N1.ADLLOCOMOTION THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_bathing' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLBATHING = 6
                               AND N2.ADLBATHING = 6 THEN
                              0
                          WHEN     N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING <= N1.ADLBATHING THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLBATHING = 6
                               AND NVL(N2.ADLBATHING, 8) = 8 THEN
                              1
                          WHEN N2.ADLBATHING = 6 THEN
                              1
                          WHEN     N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING > N1.ADLBATHING THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_toilettransfer' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLTOILETTRANSFER = 6
                               AND N2.ADLTOILETTRANSFER = 6 THEN
                              0
                          WHEN     N2.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETTRANSFER <=
                                       N1.ADLTOILETTRANSFER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLTOILETTRANSFER = 6
                               AND NVL(N2.ADLTOILETTRANSFER, 8) = 8 THEN
                              1
                          WHEN N2.ADLTOILETTRANSFER = 6 THEN
                              1
                          WHEN     N2.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETTRANSFER >
                                       N1.ADLTOILETTRANSFER THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_dressupper' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLDRESSUPPER = 6
                               AND N2.ADLDRESSUPPER = 6 THEN
                              0
                          WHEN     N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSUPPER <= N1.ADLDRESSUPPER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLDRESSUPPER = 6
                               AND NVL(N2.ADLDRESSUPPER, 8) = 8 THEN
                              1
                          WHEN N2.ADLDRESSUPPER = 6 THEN
                              1
                          WHEN     N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSUPPER > N1.ADLDRESSUPPER THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_dresslower' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLDRESSLOWER = 6
                               AND N2.ADLDRESSLOWER = 6 THEN
                              0
                          WHEN     N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSLOWER <= N1.ADLDRESSLOWER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLDRESSLOWER = 6
                               AND NVL(N2.ADLDRESSLOWER, 8) = 8 THEN
                              1
                          WHEN N2.ADLDRESSLOWER = 6 THEN
                              1
                          WHEN     N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSLOWER > N1.ADLDRESSLOWER THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_toiletuse' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLTOILETUSE = 6
                               AND N2.ADLTOILETUSE = 6 THEN
                              0
                          WHEN     N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETUSE <= N1.ADLTOILETUSE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLTOILETUSE = 6
                               AND NVL(N2.ADLTOILETUSE, 8) = 8 THEN
                              1
                          WHEN N2.ADLTOILETUSE = 6 THEN
                              1
                          WHEN     N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETUSE > N1.ADLTOILETUSE THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_eating' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLEATING = 6
                               AND N2.ADLEATING = 6 THEN
                              0
                          WHEN     N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLEATING <= N1.ADLEATING THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.ADLEATING = 6
                               AND NVL(N2.ADLEATING, 8) = 8 THEN
                              1
                          WHEN N2.ADLEATING = 6 THEN
                              1
                          WHEN     N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLEATING > N1.ADLEATING THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_urinary' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.BLADDERCONTINENCE = 5
                               AND N2.BLADDERCONTINENCE = 5 THEN
                              0
                          WHEN     N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE <=
                                       N1.BLADDERCONTINENCE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.BLADDERCONTINENCE = 5
                               AND NVL(N2.BLADDERCONTINENCE, 8) = 8 THEN
                              1
                          WHEN N2.BLADDERCONTINENCE = 5 THEN
                              1
                          WHEN     N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE >
                                       N1.BLADDERCONTINENCE THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_managemeds' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEDS = 6
                               AND N2.IADLPERFORMANCEMEDS = 6 THEN
                              0
                          WHEN     N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS <=
                                       N1.IADLPERFORMANCEMEDS THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEDS = 6
                               AND NVL(N2.IADLPERFORMANCEMEDS, 8) = 8 THEN
                              1
                          WHEN N2.IADLPERFORMANCEMEDS = 6 THEN
                              1
                          WHEN     N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS >
                                       N1.IADLPERFORMANCEMEDS THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_cognitive' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.CPS2_SCALE = 6
                               AND N2.CPS2_SCALE = 6 THEN
                              0
                          WHEN     N1.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE <= N1.CPS2_SCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.CPS2_SCALE = 6
                               AND N2.CPS2_SCALE IS NULL THEN
                              1
                          WHEN N2.CPS2_SCALE = 6 THEN
                              1
                          WHEN     N1.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE > N1.CPS2_SCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_understood' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.SELFUNDERSTOOD IS NOT NULL
                               AND N2.SELFUNDERSTOOD IS NOT NULL
                               AND N1.UNDERSTANDOTHERS IS NOT NULL
                               AND N2.UNDERSTANDOTHERS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.SELFUNDERSTOOD = 4
                               AND N2.SELFUNDERSTOOD = 4
                               AND N1.UNDERSTANDOTHERS = 4
                               AND N2.UNDERSTANDOTHERS = 4 THEN
                              0
                          WHEN     N1.SELFUNDERSTOOD IS NOT NULL
                               AND N2.SELFUNDERSTOOD IS NOT NULL
                               AND N1.UNDERSTANDOTHERS IS NOT NULL
                               AND N2.UNDERSTANDOTHERS IS NOT NULL
                               AND (N2.SELFUNDERSTOOD + N2.UNDERSTANDOTHERS) <=
                                       (  N1.SELFUNDERSTOOD
                                        + N1.UNDERSTANDOTHERS) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.SELFUNDERSTOOD = 4
                               AND N1.UNDERSTANDOTHERS = 4
                               AND N2.SELFUNDERSTOOD IS NULL
                               AND N2.UNDERSTANDOTHERS IS NULL THEN
                              1
                          WHEN     N2.SELFUNDERSTOOD = 4
                               AND N2.UNDERSTANDOTHERS = 4 THEN
                              1
                          WHEN     N1.SELFUNDERSTOOD IS NOT NULL
                               AND N2.SELFUNDERSTOOD IS NOT NULL
                               AND N1.UNDERSTANDOTHERS IS NOT NULL
                               AND N2.UNDERSTANDOTHERS IS NOT NULL
                               AND (N2.SELFUNDERSTOOD + N2.UNDERSTANDOTHERS) >
                                       (  N1.SELFUNDERSTOOD
                                        + N1.UNDERSTANDOTHERS) THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_pain' AS MSR_TOKEN,
                     (CASE
                          WHEN    (    N1.PAININTENSITY IS NULL
                                   AND N2.PAININTENSITY IS NULL)
                               OR (    N1.PAINFREQUENCY IS NULL
                                   AND N2.PAINFREQUENCY IS NULL)
                               OR (    N1.PAININTENSITY IS NULL
                                   AND NVL(N1.PAINFREQUENCY, -1) <> 0)
                               OR (    N2.PAININTENSITY IS NULL
                                   AND NVL(N2.PAINFREQUENCY, -1) <> 0) THEN
                              0
                          ELSE
                              1
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     (CASE
                                        WHEN    (    N1.PAININTENSITY IS NULL
                                                 AND N2.PAININTENSITY IS NULL)
                                             OR (    N1.PAINFREQUENCY IS NULL
                                                 AND N2.PAINFREQUENCY IS NULL)
                                             OR (    N1.PAININTENSITY IS NULL
                                                 AND NVL(N1.PAINFREQUENCY,
                                                         -1) <> 0)
                                             OR (    N2.PAININTENSITY IS NULL
                                                 AND NVL(N2.PAINFREQUENCY,
                                                         -1) <> 0) THEN
                                            0
                                        ELSE
                                            1
                                    END) = 1
                               AND (CASE
                                        WHEN    NVL(N1.PAINFREQUENCY, -1) = 0
                                             OR NVL(N1.PAININTENSITY, -1) = 0 THEN
                                            0
                                        ELSE
                                            N1.PAININTENSITY
                                    END) = 4
                               AND (CASE
                                        WHEN    NVL(N2.PAINFREQUENCY, -1) = 0
                                             OR NVL(N2.PAININTENSITY, -1) = 0 THEN
                                            0
                                        ELSE
                                            N2.PAININTENSITY
                                    END) = 4 THEN
                              0
                          WHEN     (CASE
                                        WHEN    (    N1.PAININTENSITY IS NULL
                                                 AND N2.PAININTENSITY IS NULL)
                                             OR (    N1.PAINFREQUENCY IS NULL
                                                 AND N2.PAINFREQUENCY IS NULL)
                                             OR (    N1.PAININTENSITY IS NULL
                                                 AND NVL(N1.PAINFREQUENCY,
                                                         -1) <> 0)
                                             OR (    N2.PAININTENSITY IS NULL
                                                 AND NVL(N2.PAINFREQUENCY,
                                                         -1) <> 0) THEN
                                            0
                                        ELSE
                                            1
                                    END) = 1
                               AND ((CASE
                                         WHEN    NVL(N2.PAINFREQUENCY, -1) =
                                                     0
                                              OR NVL(N2.PAININTENSITY, -1) =
                                                     0 THEN
                                             0
                                         ELSE
                                             N2.PAININTENSITY
                                     END) <= (CASE
                                                  WHEN    NVL(
                                                              N1.PAINFREQUENCY,
                                                              -1) = 0
                                                       OR NVL(
                                                              N1.PAININTENSITY,
                                                              -1) = 0 THEN
                                                      0
                                                  ELSE
                                                      N1.PAININTENSITY
                                              END)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.PAININTENSITY = 4
                               AND N2.PAININTENSITY IS NULL THEN
                              1
                          WHEN N2.PAININTENSITY = 4 THEN
                              1
                          WHEN     N2.PAININTENSITY IS NOT NULL
                               AND N1.PAININTENSITY IS NOT NULL
                               AND N2.PAININTENSITY > N1.PAININTENSITY THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_mood' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(N1.EXCLUDE_MOOD, 0) <> 1
                               AND NVL(N2.EXCLUDE_MOOD, 0) <> 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(N1.EXCLUDE_MOOD, 0) = 1
                               AND NVL(N2.EXCLUDE_MOOD, 0) = 1 THEN
                              0
                          WHEN     N1.MOODSCALE = 5
                               AND N2.MOODSCALE = 5 THEN
                              0
                          WHEN     N1.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE <= N1.MOODSCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.EXCLUDE_MOOD = 1
                               AND N2.EXCLUDE_MOOD = 1 THEN
                              0
                          WHEN     N1.MOODSCALE = 5
                               AND N2.MOODSCALE IS NULL THEN
                              1
                          WHEN N2.MOODSCALE = 5 THEN
                              1
                          WHEN     N1.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE > N1.MOODSCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'projected' AS RISK_TYPE,
                     'pot_dyspnea' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.DYSPNEA = 3
                               AND N2.DYSPNEA = 3 THEN
                              0
                          WHEN     N1.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA <= N1.DYSPNEA THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR,
                     (CASE
                          WHEN     N1.DYSPNEA = 3
                               AND N2.DYSPNEA IS NULL THEN
                              1
                          WHEN N2.DYSPNEA = 3 THEN
                              1
                          WHEN     N1.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA > N1.DYSPNEA THEN
                              1
                          ELSE
                              0
                      END)
                         AS RISK
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     LEFT JOIN MV_UAS_DETAILS N2
                         ON (A.RECORD_ID2 = N2.RECORD_ID)),
         RISK_CONT_MEASURES_OBS AS
             (SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_nfloc' AS MSR_TOKEN,
                     1 AS DENOMINATOR,
                     (CASE
                          WHEN     N1.LEVELOFCARESCORE = 48
                               AND N2.LEVELOFCARESCORE = 48 THEN
                              0
                          WHEN     N1.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE BETWEEN 0
                                                                                 AND 4 THEN
                              1
                          WHEN     N1.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE IS NOT NULL
                               AND N2.LEVELOFCARESCORE - N1.LEVELOFCARESCORE <
                                       0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_adl' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.ADLLOCOMOTION
                                    + N1.ADLHYGIENE
                                    + N1.ADLBATHING) = 18
                               AND (  N2.ADLLOCOMOTION
                                    + N2.ADLHYGIENE
                                    + N2.ADLBATHING) = 18 THEN
                              0
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.ADLLOCOMOTION
                                      + N2.ADLHYGIENE
                                      + N2.ADLBATHING)
                                   - (  N1.ADLLOCOMOTION
                                      + N1.ADLHYGIENE
                                      + N1.ADLBATHING) BETWEEN 0
                                                           AND 2 THEN
                              1
                          WHEN     N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLHYGIENE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.ADLLOCOMOTION
                                      + N2.ADLHYGIENE
                                      + N2.ADLBATHING)
                                   - (  N1.ADLLOCOMOTION
                                      + N1.ADLHYGIENE
                                      + N1.ADLBATHING) < 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_iadl' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND (  N1.IADLPERFORMANCEMEALS
                                    + N1.IADLPERFORMANCEHOUSEWORK
                                    + N1.IADLPERFORMANCEMEDS
                                    + N1.IADLPERFORMANCESHOPPING
                                    + N1.IADLPERFORMANCETRANSPORT) = 30
                               AND (  N2.IADLPERFORMANCEMEALS
                                    + N2.IADLPERFORMANCEHOUSEWORK
                                    + N2.IADLPERFORMANCEMEDS
                                    + N2.IADLPERFORMANCESHOPPING
                                    + N2.IADLPERFORMANCETRANSPORT) = 30 THEN
                              0
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.IADLPERFORMANCEMEALS
                                      + N2.IADLPERFORMANCEHOUSEWORK
                                      + N2.IADLPERFORMANCEMEDS
                                      + N2.IADLPERFORMANCESHOPPING
                                      + N2.IADLPERFORMANCETRANSPORT)
                                   - (  N1.IADLPERFORMANCEMEALS
                                      + N1.IADLPERFORMANCEHOUSEWORK
                                      + N1.IADLPERFORMANCEMEDS
                                      + N1.IADLPERFORMANCESHOPPING
                                      + N1.IADLPERFORMANCETRANSPORT) BETWEEN 0
                                                                         AND 3 THEN
                              1
                          WHEN     N1.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEALS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEHOUSEWORK IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCESHOPPING IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCETRANSPORT IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND   (  N2.IADLPERFORMANCEMEALS
                                      + N2.IADLPERFORMANCEHOUSEWORK
                                      + N2.IADLPERFORMANCEMEDS
                                      + N2.IADLPERFORMANCESHOPPING
                                      + N2.IADLPERFORMANCETRANSPORT)
                                   - (  N1.IADLPERFORMANCEMEALS
                                      + N1.IADLPERFORMANCEHOUSEWORK
                                      + N1.IADLPERFORMANCEMEDS
                                      + N1.IADLPERFORMANCESHOPPING
                                      + N1.IADLPERFORMANCETRANSPORT) < 0 THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_locomotion' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLLOCOMOTION = 6
                               AND N2.ADLLOCOMOTION = 6 THEN
                              0
                          WHEN     N2.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLLOCOMOTION IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLLOCOMOTION <= N1.ADLLOCOMOTION THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_bathing' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLBATHING = 6
                               AND N2.ADLBATHING = 6 THEN
                              0
                          WHEN     N2.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLBATHING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLBATHING <= N1.ADLBATHING THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_toilettransfer' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLTOILETTRANSFER = 6
                               AND N2.ADLTOILETTRANSFER = 6 THEN
                              0
                          WHEN     N2.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETTRANSFER IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETTRANSFER <=
                                       N1.ADLTOILETTRANSFER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_dressupper' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLDRESSUPPER = 6
                               AND N2.ADLDRESSUPPER = 6 THEN
                              0
                          WHEN     N2.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSUPPER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSUPPER <= N1.ADLDRESSUPPER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_dresslower' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLDRESSLOWER = 6
                               AND N2.ADLDRESSLOWER = 6 THEN
                              0
                          WHEN     N2.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLDRESSLOWER IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLDRESSLOWER <= N1.ADLDRESSLOWER THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_toiletuse' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLTOILETUSE = 6
                               AND N2.ADLTOILETUSE = 6 THEN
                              0
                          WHEN     N2.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLTOILETUSE IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLTOILETUSE <= N1.ADLTOILETUSE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_eating' AS MSR_TOKEN,
                     (CASE
                          WHEN     N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.ADLEATING = 6
                               AND N2.ADLEATING = 6 THEN
                              0
                          WHEN     N2.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N1.ADLEATING IN (0, 1, 2, 3, 4, 5, 6)
                               AND N2.ADLEATING <= N1.ADLEATING THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_urinary' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.BLADDERCONTINENCE = 5
                               AND N2.BLADDERCONTINENCE = 5 THEN
                              0
                          WHEN     N1.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE IN (0, 1, 2, 3, 4, 5)
                               AND N2.BLADDERCONTINENCE <=
                                       N1.BLADDERCONTINENCE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_managemeds' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6) THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.IADLPERFORMANCEMEDS = 6
                               AND N2.IADLPERFORMANCEMEDS = 6 THEN
                              0
                          WHEN     N1.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS IN
                                       (0, 1, 2, 3, 4, 5, 6)
                               AND N2.IADLPERFORMANCEMEDS <=
                                       N1.IADLPERFORMANCEMEDS THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_cognitive' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.CPS2_SCALE = 6
                               AND N2.CPS2_SCALE = 6 THEN
                              0
                          WHEN     N1.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE IS NOT NULL
                               AND N2.CPS2_SCALE <= N1.CPS2_SCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_understood' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.SELFUNDERSTOOD IS NOT NULL
                               AND N2.SELFUNDERSTOOD IS NOT NULL
                               AND N1.UNDERSTANDOTHERS IS NOT NULL
                               AND N2.UNDERSTANDOTHERS IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.SELFUNDERSTOOD = 4
                               AND N2.SELFUNDERSTOOD = 4
                               AND N1.UNDERSTANDOTHERS = 4
                               AND N2.UNDERSTANDOTHERS = 4 THEN
                              0
                          WHEN     N1.SELFUNDERSTOOD IS NOT NULL
                               AND N2.SELFUNDERSTOOD IS NOT NULL
                               AND N1.UNDERSTANDOTHERS IS NOT NULL
                               AND N2.UNDERSTANDOTHERS IS NOT NULL
                               AND (N2.SELFUNDERSTOOD + N2.UNDERSTANDOTHERS) <=
                                       (  N1.SELFUNDERSTOOD
                                        + N1.UNDERSTANDOTHERS) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_pain' AS MSR_TOKEN,
                     (CASE
                          WHEN    (    N1.PAININTENSITY IS NULL
                                   AND N2.PAININTENSITY IS NULL)
                               OR (    N1.PAINFREQUENCY IS NULL
                                   AND N2.PAINFREQUENCY IS NULL)
                               OR (    N1.PAININTENSITY IS NULL
                                   AND NVL(N1.PAINFREQUENCY, -1) <> 0)
                               OR (    N2.PAININTENSITY IS NULL
                                   AND NVL(N2.PAINFREQUENCY, -1) <> 0) THEN
                              0
                          ELSE
                              1
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     (CASE
                                        WHEN    (    N1.PAININTENSITY IS NULL
                                                 AND N2.PAININTENSITY IS NULL)
                                             OR (    N1.PAINFREQUENCY IS NULL
                                                 AND N2.PAINFREQUENCY IS NULL)
                                             OR (    N1.PAININTENSITY IS NULL
                                                 AND NVL(N1.PAINFREQUENCY,
                                                         -1) <> 0)
                                             OR (    N2.PAININTENSITY IS NULL
                                                 AND NVL(N2.PAINFREQUENCY,
                                                         -1) <> 0) THEN
                                            0
                                        ELSE
                                            1
                                    END) = 1
                               AND (CASE
                                        WHEN    NVL(N1.PAINFREQUENCY, -1) = 0
                                             OR NVL(N1.PAININTENSITY, -1) = 0 THEN
                                            0
                                        ELSE
                                            N1.PAININTENSITY
                                    END) = 4
                               AND (CASE
                                        WHEN    NVL(N2.PAINFREQUENCY, -1) = 0
                                             OR NVL(N2.PAININTENSITY, -1) = 0 THEN
                                            0
                                        ELSE
                                            N2.PAININTENSITY
                                    END) = 4 THEN
                              0
                          WHEN     (CASE
                                        WHEN    (    N1.PAININTENSITY IS NULL
                                                 AND N2.PAININTENSITY IS NULL)
                                             OR (    N1.PAINFREQUENCY IS NULL
                                                 AND N2.PAINFREQUENCY IS NULL)
                                             OR (    N1.PAININTENSITY IS NULL
                                                 AND NVL(N1.PAINFREQUENCY,
                                                         -1) <> 0)
                                             OR (    N2.PAININTENSITY IS NULL
                                                 AND NVL(N2.PAINFREQUENCY,
                                                         -1) <> 0) THEN
                                            0
                                        ELSE
                                            1
                                    END) = 1
                               AND ((CASE
                                         WHEN    NVL(N2.PAINFREQUENCY, -1) =
                                                     0
                                              OR NVL(N2.PAININTENSITY, -1) =
                                                     0 THEN
                                             0
                                         ELSE
                                             N2.PAININTENSITY
                                     END) <= (CASE
                                                  WHEN    NVL(
                                                              N1.PAINFREQUENCY,
                                                              -1) = 0
                                                       OR NVL(
                                                              N1.PAININTENSITY,
                                                              -1) = 0 THEN
                                                      0
                                                  ELSE
                                                      N1.PAININTENSITY
                                              END)) THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_mood' AS MSR_TOKEN,
                     (CASE
                          WHEN     NVL(N1.EXCLUDE_MOOD, 0) <> 1
                               AND NVL(N2.EXCLUDE_MOOD, 0) <> 1 THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     NVL(N1.EXCLUDE_MOOD, 0) = 1
                               AND NVL(N2.EXCLUDE_MOOD, 0) = 1 THEN
                              0
                          WHEN     N1.MOODSCALE = 5
                               AND N2.MOODSCALE = 5 THEN
                              0
                          WHEN     N1.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE IS NOT NULL
                               AND N2.MOODSCALE <= N1.MOODSCALE THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)
              UNION
              SELECT A.*,
                     'observed' AS RISK_TYPE,
                     'pot_dyspnea' AS MSR_TOKEN,
                     (CASE
                          WHEN     N1.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA IS NOT NULL THEN
                              1
                          ELSE
                              0
                      END)
                         AS DENOMINATOR,
                     (CASE
                          WHEN     N1.DYSPNEA = 3
                               AND N2.DYSPNEA = 3 THEN
                              0
                          WHEN     N1.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA IS NOT NULL
                               AND N2.DYSPNEA <= N1.DYSPNEA THEN
                              1
                          ELSE
                              0
                      END)
                         AS NUMERATOR
              FROM   RISK_CONT A
                     JOIN MV_UAS_DETAILS N1 ON (A.RECORD_ID1 = N1.RECORD_ID)
                     JOIN MV_UAS_DETAILS N2 ON (A.RECORD_ID3 = N2.RECORD_ID)),
         ALL_RISK_MEASURES_LONG AS
             ((SELECT 'CONT' SOURCE,
                      PROJ.MEDICAID_NUM,
                      PROJ.SUBSCRIBER_ID,
                      PROJ.LOB_ID,
                      PROJ.REFERRAL_DATE,
                      PROJ.ENROLLMENT_DATE,
                      PROJ.DISENROLLMENT_DATE,
                      PROJ.CURRENT_PERIOD,
                      PROJ.NEXT_DUE_PERIOD,
                      PROJ.QIP_MONTH_ID,
                      PROJ.RESULTING_PERIOD,
                      PROJ.NEXT_DUE,
                      PROJ.RECORD_ID1,
                      PROJ.RECORD_ID2,
                      PROJ.RECORD_ID3,
                      PROJ.ASSESSMENTREASON1 ASSESSMENT_REASON1,
                      PROJ.ASSESSMENTREASON2 ASSESSMENT_REASON2,
                      PROJ.ASSESSMENTREASON3 ASSESSMENT_REASON3,
                      PROJ.ASSESSMENTDATE1 ASSESSMENT_DATE1,
                      PROJ.ASSESSMENTDATE2 ASSESSMENT_DATE2,
                      PROJ.ASSESSMENTDATE3 ASSESSMENT_DATE3,
                      PROJ.ASSESSMONTH1 ASSESSMENT_MONTH1,
                      PROJ.ASSESSMONTH2 ASSESSMENT_MONTH2,
                      PROJ.ASSESSMONTH3 ASSESSMENT_MONTH3,
                      PROJ.ONURSEORG,
                      PROJ.ONURSEORGNAME,
                      PROJ.ONURSENAME,
                      PROJ.MSR_TOKEN,
                      PROJ.RISK,
                      CASE WHEN OBS.DENOMINATOR IS NOT NULL THEN 1 ELSE 0 END
                          AS OUTCOME,
                      CASE
                          WHEN     PROJ.NUMERATOR = 1
                               AND PROJ.RISK = 1 THEN
                              'lower risk'
                          WHEN     PROJ.NUMERATOR = 0
                               AND PROJ.RISK = 1 THEN
                              'high risk'
                          WHEN PROJ.RISK = 0 THEN
                              'not at risk'
                          ELSE
                              ' '
                      END
                          AS RISK_NOTE,
                      CASE
                          WHEN     OBS.NUMERATOR = 1
                               AND OBS.DENOMINATOR = 1 THEN
                              'yes'
                          WHEN     OBS.NUMERATOR = 0
                               AND OBS.DENOMINATOR = 1 THEN
                              'no '
                          WHEN OBS.DENOMINATOR = 0 THEN
                              'n/a'
                          WHEN OBS.DENOMINATOR IS NULL THEN
                              'not yet assessed'
                          ELSE
                              ' '
                      END
                          AS DESIRED_OUTCOME,
                      PROJ.DL_MEMBER_SK,
                      PROJ.MEMBER_ID,
                      PROJ.DL_LOB_GRP_ID,
                      PROJ.DL_LOB_ID,
                      PROJ.DL_ENROLL_ID,
                      --PROJ.ASSESSMENT_SK_ID,
                      --PROJ.PROV_SK_ID,
                      --PROJ.PROVIDER_ID,
                      PROJ.DL_PLAN_SK,
                      PROJ.PROGRAM
               FROM   RISK_CONT_MEASURES_PROJ PROJ
                      LEFT JOIN RISK_CONT_MEASURES_OBS OBS
                          ON (    PROJ.SUBSCRIBER_ID = OBS.SUBSCRIBER_ID
                              AND PROJ.LOB_ID = OBS.LOB_ID
                              AND PROJ.ENROLLMENT_DATE = OBS.ENROLLMENT_DATE
                              AND PROJ.CURRENT_PERIOD = OBS.CURRENT_PERIOD
                              AND PROJ.MSR_TOKEN = OBS.MSR_TOKEN))
              UNION
              (SELECT 'RISK' SOURCE,
                      PROJ.MEDICAID_NUM,
                      PROJ.SUBSCRIBER_ID,
                      PROJ.LOB_ID,
                      PROJ.REFERRAL_DATE,
                      PROJ.ENROLLMENT_DATE,
                      PROJ.DISENROLLMENT_DATE,
                      PROJ.CURRENT_PERIOD,
                      PROJ.NEXT_DUE_PERIOD,
                      PROJ.QIP_MONTH_ID,
                      PROJ.RESULTING_PERIOD,
                      PROJ.NEXT_DUE,
                      PROJ.RECORD_ID1,
                      PROJ.RECORD_ID2,
                      NULL AS RECORD_ID3,
                      PROJ.ASSESSMENTREASON1 ASSESSMENT_REASON1,
                      PROJ.ASSESSMENTREASON2 ASSESSMENT_REASON2,
                      NULL ASSESSMENT_REASON3,
                      PROJ.ASSESSMENTDATE1 ASSESSMENT_DATE1,
                      PROJ.ASSESSMENTDATE2 ASSESSMENT_DATE2,
                      NULL ASSESSMENT_DATE3,
                      PROJ.ASSESSMONTH1 ASSESSMENT_MONTH1,
                      PROJ.ASSESSMONTH2 ASSESSMENT_MONTH2,
                      NULL ASSESSMENT_MONTH3,
                      PROJ.ONURSEORG,
                      PROJ.ONURSEORGNAME,
                      PROJ.ONURSENAME,
                      PROJ.MSR_TOKEN,
                      PROJ.RISK,
                      CASE WHEN OBS.DENOMINATOR IS NOT NULL THEN 1 ELSE 0 END
                          AS OUTCOME,
                      CASE
                          WHEN     PROJ.NUMERATOR = 1
                               AND PROJ.RISK = 1 THEN
                              'lower risk'
                          WHEN     PROJ.NUMERATOR = 0
                               AND PROJ.RISK = 1 THEN
                              'high risk'
                          WHEN PROJ.RISK = 0 THEN
                              'not at risk'
                          ELSE
                              ' '
                      END
                          AS RISK_NOTE,
                      CASE
                          WHEN     OBS.NUMERATOR = 1
                               AND OBS.DENOMINATOR = 1 THEN
                              'yes'
                          WHEN     OBS.NUMERATOR = 0
                               AND OBS.DENOMINATOR = 1 THEN
                              'no '
                          WHEN OBS.DENOMINATOR = 0 THEN
                              'n/a'
                          WHEN OBS.DENOMINATOR IS NULL THEN
                              'not yet assessed'
                          ELSE
                              ' '
                      END
                          AS DESIRED_OUTCOME,
                      PROJ.DL_MEMBER_SK,
                      PROJ.MEMBER_ID,
                      PROJ.DL_LOB_GRP_ID,
                      PROJ.DL_LOB_ID,
                      PROJ.DL_ENROLL_ID,
                      --PROJ.ASSESSMENT_SK_ID,
                      --PROJ.PROV_SK_ID,
                      --PROJ.PROVIDER_ID,
                      PROJ.DL_PLAN_SK,
                      PROJ.PROGRAM
               FROM   PREV_RISK_MEASURES_PROJ PROJ
                      LEFT JOIN PREV_RISK_MEASURES_OBS OBS
                          ON (    PROJ.SUBSCRIBER_ID = OBS.SUBSCRIBER_ID
                              AND PROJ.LOB_ID = OBS.LOB_ID
                              AND PROJ.ENROLLMENT_DATE = OBS.ENROLLMENT_DATE
                              AND PROJ.CURRENT_PERIOD = OBS.CURRENT_PERIOD
                              AND PROJ.MSR_TOKEN = OBS.MSR_TOKEN)))
    SELECT SOURCE,
           "MEDICAID_NUM",
           "SUBSCRIBER_ID",
           "LOB_ID",
           "REFERRAL_DATE",
           "ENROLLMENT_DATE",
           "DISENROLLMENT_DATE",
           "CURRENT_PERIOD",
           "NEXT_DUE_PERIOD",
           "QIP_MONTH_ID",
           "RESULTING_PERIOD",
           "NEXT_DUE",
           "RECORD_ID1",
           "RECORD_ID2",
           "RECORD_ID3",
           "ASSESSMENT_REASON1",
           "ASSESSMENT_REASON2",
           "ASSESSMENT_REASON3",
           "ASSESSMENT_DATE1",
           "ASSESSMENT_DATE2",
           "ASSESSMENT_DATE3",
           "ASSESSMENT_MONTH1",
           "ASSESSMENT_MONTH2",
           "ASSESSMENT_MONTH3",
           "ONURSEORG",
           "ONURSEORGNAME",
           "ONURSENAME",
           "MSR_TOKEN",
           "RISK",
           "OUTCOME",
           "RISK_NOTE",
           "DESIRED_OUTCOME",
           "DL_MEMBER_SK",
           "MEMBER_ID",
           "DL_LOB_GRP_ID",
           "DL_LOB_ID",
           "DL_ENROLL_ID",
           "DL_PLAN_SK",
           PROGRAM
    FROM   ALL_RISK_MEASURES_LONG


GRANT SELECT ON V_QUALITY_RISK_MEASURES_LONG TO SF_CHOICE;
