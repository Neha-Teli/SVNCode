INSERT INTO MV_QUALITY_MEASURE_ALL_ASSESS
WITH MEMBERS AS
         (SELECT                  /* driving_site(m)  cardinality(m 400000) */
                M.MEDICAID_NUM,
                 M.SUBSCRIBER_ID,
                 M.MRN,
                 M.CASE_NBR CHOICE_CASE_NUM,
                 M.LOB_ID,
                 M.LINE_OF_BUSINESS,
                 M.MONTH_ID,
                 MONTH_START_DATE AS MBR_MONTH,
                 MONTH_END_DATE AS MBR_MONTH_END, --, substr(m.month_id,1,4)*100 + (case when substr(m.month_id,5,2) in (1,2,3,4,5,6) then 1 when substr(m.month_id,5,2) in (7,8,9,10,11,12) then 2 end) as qip_period
                 REPORT_PERIOD,
                 REPORT_PERIOD2 AS QIP_PERIOD,
                 M.ENROLLMENT_DATE,
                 M.DISENROLLMENT_DATE,
                 M.REFERRAL_DATE,
                 M.MEMBER_ID,
                 M.DL_LOB_ID,
                 M.DL_ENROLL_ID,
                 --M.DL_ASSESS_SK,
                 --M.DL_PROV_SK,
                 --M.PROVIDER_ID,
                 M.DL_PLAN_SK,
                 M.DL_LOB_GRP_ID,
                 M.DL_MEMBER_SK
          FROM   V_FACT_MEMBER_MONTH_EXP M, DIM_REPORTING_PERIOD B
          WHERE      M.MONTH_ID = B.REPORTING_PERIOD_ID
                 AND M.MONTH_ID >= 201401 /*start from 2014, since UAS began in 2014*/
                 AND M.LINE_OF_BUSINESS IN ('MLTC', 'FIDA')),
     /*--uas*/
     UAS_HEADER AS
         (SELECT /* driving_site(A)  cardinality(A 400000) cardinality(b 60000000) cardinality(c 60000000) */
                *
          FROM   (SELECT ROW_NUMBER()
                         OVER (PARTITION BY MEDICAIDNUMBER1, ASSESSMENTDATE
                               ORDER BY RECORD_ID DESC)
                             AS UAS_TWICEDAILY,
                         Z.*
                  FROM   (SELECT A.RECORD_ID,
                                 A.MEDICAIDNUMBER1,
                                 C.GENDER,
                                 TO_NUMBER(C.LEVELOFCARESCORE)
                                     AS LEVELOFCARESCORE,
                                 A.ASSESSMENTDATE,
                                 TRUNC(A.ASSESSMENTDATE, 'MM')
                                     AS ASSESSMENTMONTH,
                                 A.ONURSEDATE,
                                 C.ONURSEORG,
                                 C.ONURSEORGNAME,
                                 C.ONURSENAME,
                                   TO_CHAR(A.ASSESSMENTDATE, 'yyyy') * 100
                                 + CASE
                                       WHEN TO_CHAR(A.ASSESSMENTDATE, 'q') IN
                                                (1, 2) THEN
                                           1
                                       WHEN TO_CHAR(A.ASSESSMENTDATE, 'q') IN
                                                (3, 4) THEN
                                           2
                                   END
                                     AS UAS_PERIOD,
                                 A.ASSESSMENTTYPE,
                                 A.ASSESSMENTREASON,
                                 A.RESIDENCEASSESSMENT
                          FROM   DW_OWNER.UAS_COMMUNITYHEALTH A
                                 LEFT JOIN DW_OWNER.UAS_CHASUPPLEMENT B
                                     ON (A.RECORD_ID = B.RECORD_ID)
                                 LEFT JOIN DW_OWNER.UAS_PAT_ASSESSMENTS C
                                     ON (A.RECORD_ID = C.RECORD_ID)
                          WHERE      A.RECORD_ID IS NOT NULL
                                 AND A.MEDICAIDNUMBER1 IS NOT NULL
                                 AND C.ONURSEORG IN
                                         ('1684L001',
                                          '0846L001',
                                          '1086L003',
                                          '1086L004',
                                          '1086L005',
                                          '1086L006',
                                          '1086L007',
                                          '1086L008',
                                          '1665L003',
                                          '4952',
                                          '1877',
                                          '0018L002',
                                          '01750467',
                                          '0018L007',
                                          '1153L001',
                                          '1787',
                                          '3990',
                                          '5521',
                                          '1816',
                                          '1477L001',
                                          '1477L002',
                                          '1873')
                                 AND (   C.ASSESFORORGID IS NULL
                                      OR C.ASSESFORORGID IN ('01750467'))) Z)
          WHERE  UAS_TWICEDAILY = 1),
     /*--This is adapted from f_assessment_timeliness (as of 12/1/2016)*/
     COMPLIANCE_MEASURE AS
         (SELECT F.LINE_OF_BUSINESS,
                 F.LOB_ID,
                 F.MRN,
                 F.CASE_NUM,
                 F.SUBSCRIBER_ID,
                 F.MEDICAID_NUM,
                 F.REFERRAL_DATE,
                 F.ENROLLMENT_DATE,
                 F.DISENROLLMENT_DATE,
                 NVL(M.MANDATORY_ENROLLMENT, 'N') MANDATORY_ENROLLMENT,
                 U.ASSESSMENTDATE,
                 F.MEMBER_ID,
                 F.DL_LOB_ID,
                 F.DL_ENROLL_ID,
                 --F.DL_ASSESS_SK,
                 --F.DL_PROV_SK,
                 --F.PROVIDER_ID,
                 F.DL_PLAN_SK,
                 F.DL_LOB_GRP_ID,
                 F.DL_MEMBER_SK,
                 U.RECORD_ID,
                 U.ONURSEORG,
                 U.ONURSEORGNAME,
                 U.ONURSENAME,
                 U.ASSESFORORGID,
                 U.ASSESSMENTREASON,
                 U.RESIDENCEASSESSMENT,
                 1 AS COMPLIANCE_FLAG,
                 ROW_NUMBER()
                 OVER (PARTITION BY F.MRN, F.SUBSCRIBER_ID, F.ENROLLMENT_DATE
                       ORDER BY U.ASSESSMENTDATE)
                     AS ENROLL_ASSESS_SEQ,
                 ROW_NUMBER()
                 OVER (PARTITION BY F.MRN, F.SUBSCRIBER_ID, F.ENROLLMENT_DATE
                       ORDER BY U.ASSESSMENTDATE DESC)
                     AS ENROLL_ASSESS_SEQ_DESC,
                 CASE
                     WHEN     U.ASSESSMENTDATE IS NULL
                          AND F.ENROLLMENT_DATE >= '01OCT2013'
                          AND ADD_MONTHS(ENROLLMENT_DATE, 6) <=
                                  F.DISENROLLMENT_DATE THEN
                         ADD_MONTHS(ENROLLMENT_DATE, 6) /*--assuming next due is 6 months from enrollment??*/
                     WHEN     U.ASSESSMENTDATE IS NULL
                          AND F.ENROLLMENT_DATE >= '01OCT2013'
                          AND ADD_MONTHS(ENROLLMENT_DATE, 6) >
                                  F.DISENROLLMENT_DATE THEN
                         NULL
                     WHEN     U.ASSESSMENTDATE IS NULL
                          AND F.ENROLLMENT_DATE < '01OCT2013' THEN
                         NULL
                     WHEN TO_DATE(
                              TO_CHAR(ADD_MONTHS(ASSESSMENTDATE, 6),
                                      'yyyymm'),
                              'yyyymm') <= F.DISENROLLMENT_DATE THEN
                         TO_DATE(
                             TO_CHAR(ADD_MONTHS(ASSESSMENTDATE, 6), 'yyyymm'),
                             'yyyymm')
                     WHEN TO_DATE(
                              TO_CHAR(ADD_MONTHS(ASSESSMENTDATE, 6),
                                      'yyyymm'),
                              'yyyymm') > F.DISENROLLMENT_DATE THEN
                         NULL
                 END
                     AS NEXT_DUE
          FROM   (SELECT          /* driving_site(m)  cardinality(m 400000) */
                        DISTINCT MRN,
                                 SUBSCRIBER_ID,
                                 MEDICAID_NUM,
                                 ENROLLMENT_DATE,
                                 DISENROLLMENT_DATE,
                                 REFERRAL_DATE,
                                 CASE_NBR CASE_NUM,
                                 LINE_OF_BUSINESS,
                                 LOB_ID,
                                 M.MEMBER_ID,
                                 M.DL_LOB_ID,
                                 M.DL_ENROLL_ID,
                                 --M.DL_ASSESS_SK,
                                 --M.DL_PROV_SK,
                                 --M.PROVIDER_ID,
                                 M.DL_PLAN_SK,
                                 M.DL_LOB_GRP_ID,
                                 M.DL_MEMBER_SK
                  FROM   V_FACT_MEMBER_MONTH_EXP M
                  WHERE  LINE_OF_BUSINESS IN ('MLTC', 'FIDA')) F
                 JOIN
                 (SELECT A.MEDICAIDNUMBER1,
                         A.ASSESSMENTDATE,
                         A.RECORD_ID,
                         A.ONURSEORG,
                         A.ONURSEORGNAME,
                         A.ONURSENAME,
                         A.ASSESFORORGID,
                         B.ASSESSMENTREASON,
                         B.RESIDENCEASSESSMENT,
                         ROW_NUMBER()
                         OVER (
                             PARTITION BY A.MEDICAIDNUMBER1, A.ASSESSMENTDATE
                             ORDER BY A.RECORD_ID DESC)
                             AS ASSESS_SEQ
                  FROM   DW_OWNER.UAS_PAT_ASSESSMENTS A
                         LEFT JOIN DW_OWNER.UAS_COMMUNITYHEALTH B
                             ON (A.RECORD_ID = B.RECORD_ID)) U
                     ON (    U.MEDICAIDNUMBER1 = F.MEDICAID_NUM
                         AND U.ASSESSMENTDATE BETWEEN F.REFERRAL_DATE
                                                  AND F.DISENROLLMENT_DATE
                         AND U.ASSESS_SEQ = 1)
                 LEFT JOIN
                 (SELECT /* cardinality(A 400000) cardinality(b 60000000) cardinality(c 60000000) */
                        A13.LABEL_TEXT LABEL_TEXT,
                           A13.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                           A13.ITEM_VALUE ITEM_VALUE,
                           A11.CASE_NUM CASE_NUM,
                           SUM(A11.FLAG) WJXBFS1,
                           'Y' MANDATORY_ENROLLMENT
                  FROM     MS_OWNER.FACT_CASE_REFERRAL@MS_OWNER_RCPROD A11
                           LEFT JOIN
                           (SELECT CASE_NUM CASE_NUM, CONTACT_SOURCE ITEM_VALUE
                            FROM   DW_OWNER.CHOICEPRE_CASE_LVL_INFO) A12
                               ON (A11.CASE_NUM = A12.CASE_NUM)
                           JOIN
                           (SELECT A01.LABEL_TEXT LABEL_TEXT,
                                   A01.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                                   A01.ITEM_VALUE ITEM_VALUE
                            FROM   (SELECT LOOKUP_ITEM_ID,
                                           ITEM_VALUE,
                                           LABEL_TEXT,
                                           LOOKUP_GROUP_ID
                                    FROM   DW_OWNER.CHOICEPRE_LOOKUP_ITEM
                                    WHERE  LOOKUP_GROUP_ID IN (50, 51, 52)) A01
                            WHERE  UPPER(LABEL_TEXT) LIKE '%MAND%') A13
                               ON (A12.ITEM_VALUE = A13.ITEM_VALUE)
                  GROUP BY A13.LABEL_TEXT,
                           A13.LOOKUP_ITEM_ID,
                           A13.ITEM_VALUE,
                           A11.CASE_NUM) M
                     ON (M.CASE_NUM = F.CASE_NUM)),
     /*--mbr_uas*/
     /*keep assessments that took place during an enrolled month*/
     /*if initial assessment, keep if it was done no more than 42 days prior to an enrolled month*/
     MBR_UAS AS
         (SELECT A.*,
                 B.RECORD_ID,
                 B.GENDER,
                 B.LEVELOFCARESCORE,
                 B.ASSESSMENTDATE,
                 B.ASSESSMENTMONTH,
                 B.ONURSEDATE,
                 B.ONURSEORG,
                 B.ONURSEORGNAME,
                 B.ONURSENAME,
                 B.UAS_PERIOD,
                 B.ASSESSMENTTYPE,
                 B.ASSESSMENTREASON,
                 B.RESIDENCEASSESSMENT,
                 CASE
                     WHEN     B.ASSESSMENTDATE IS NULL
                          AND A.ENROLLMENT_DATE >= '01OCT2013'
                          AND ADD_MONTHS(A.ENROLLMENT_DATE, 6) <=
                                  A.DISENROLLMENT_DATE THEN
                         ADD_MONTHS(A.ENROLLMENT_DATE, 6) /*--assuming next due is 6 months from enrollment??*/
                     WHEN     B.ASSESSMENTDATE IS NULL
                          AND A.ENROLLMENT_DATE >= '01OCT2013'
                          AND ADD_MONTHS(A.ENROLLMENT_DATE, 6) >
                                  A.DISENROLLMENT_DATE THEN
                         NULL
                     WHEN     B.ASSESSMENTDATE IS NULL
                          AND A.ENROLLMENT_DATE < '01OCT2013' THEN
                         NULL
                     WHEN TO_DATE(
                              TO_CHAR(ADD_MONTHS(B.ASSESSMENTDATE, 6),
                                      'yyyymm'),
                              'yyyymm') <= A.DISENROLLMENT_DATE THEN
                         TO_DATE(
                             TO_CHAR(ADD_MONTHS(B.ASSESSMENTDATE, 6),
                                     'yyyymm'),
                             'yyyymm')
                     WHEN TO_DATE(
                              TO_CHAR(ADD_MONTHS(B.ASSESSMENTDATE, 6),
                                      'yyyymm'),
                              'yyyymm') > A.DISENROLLMENT_DATE THEN
                         NULL
                 END
                     AS NEXT_DUE
          FROM   MEMBERS A
                 JOIN
                 UAS_HEADER B
                     ON (    A.MEDICAID_NUM = B.MEDICAIDNUMBER1
                         AND (   A.MBR_MONTH = B.ASSESSMENTMONTH
                              OR (    B.ASSESSMENTREASON = 1
                                  AND B.ASSESSMENTDATE BETWEEN   A.MBR_MONTH
                                                               - 42
                                                           AND A.MBR_MONTH_END)))),
     /*--qip_assessments*/
     /*create a qip_flag to indicate most recent assessment per member per semi-year as per methodology of DOH measures*/
     /*use this set to create prevalence (qip_FLAG=1), pot, and six-month datasets*/
     /*qip_flag=0 means the assessment is not the most recent assessment in the QIP period for the member*/
     QIP_ASSESSMENTS AS
         (SELECT DISTINCT
                 Z2.MEDICAID_NUM,
                 Z2.SUBSCRIBER_ID,
                 Z2.MRN,
                 Z2.CHOICE_CASE_NUM,
                 Z2.LOB_ID,
                 Z2.LINE_OF_BUSINESS,
                 Z2.QIP_PERIOD,
                 CASE
                     WHEN z2.qip_period = z2.uas_period THEN
                         TO_NUMBER(TO_CHAR(z2.assessmentmonth, 'YYYYMM'))
                     WHEN     z2.qip_period <> z2.uas_period
                          AND SUBSTR(qip_period, 6, 1) = 1 THEN
                         SUBSTR(qip_period, 1, 4) * 100 + 1
                     WHEN     z2.qip_period <> z2.uas_period
                          AND SUBSTR(qip_period, 6, 1) = 2 THEN
                         SUBSTR(qip_period, 1, 4) * 100 + 7
                     ELSE
                         NULL
                 END
                     AS QIP_MONTH_ID,
                 Z2.ENROLLMENT_DATE,
                 Z2.DISENROLLMENT_DATE,
                 Z2.REFERRAL_DATE,
                 Z2.RECORD_ID,
                 Z2.GENDER,
                 Z2.LEVELOFCARESCORE,
                 Z2.ASSESSMENTDATE,
                 Z2.ASSESSMENTMONTH,
                 Z2.ONURSEDATE,
                 Z2.ONURSEORG,
                 Z2.ONURSEORGNAME,
                 Z2.ONURSENAME,
                 Z2.UAS_PERIOD,
                 Z2.ASSESSMENTTYPE,
                 Z2.ASSESSMENTREASON,
                 Z2.RESIDENCEASSESSMENT,
                 Z2.NEXT_DUE,
                 Z2.QIP_PERIOD_SEQ_DESC,
                 Z2.QIP_PERIOD_SEQ,
                 Z2.QIP_ENROLL_SEQ,
                 Z2.MEMBER_ID,
                 Z2.DL_LOB_ID,
                 Z2.DL_ENROLL_ID,
                 --Z2.DL_ASSESS_SK,
                 --Z2.DL_PROV_SK,
                 --Z2.PROVIDER_ID,
                 Z2.DL_PLAN_SK,
                 Z2.DL_LOB_GRP_ID,
                 Z2.DL_MEMBER_SK,
                 CASE
                     WHEN     z2.qip_period_seq_desc = 1
                          AND DENSE_RANK()
                              OVER (
                                  PARTITION BY mrn,
                                               subscriber_id,
                                               lob_id,
                                               qip_period,
                                               assessmentdate
                                  ORDER BY enrollment_date DESC) = 1 THEN
                         1
                     ELSE
                         0
                 END
                     AS qip_flag
          FROM   (SELECT Z.*,
                         DENSE_RANK()
                         OVER (
                             PARTITION BY MRN,
                                          SUBSCRIBER_ID,
                                          LOB_ID,
                                          QIP_PERIOD
                             ORDER BY ASSESSMENTDATE DESC)
                             AS QIP_PERIOD_SEQ_DESC,
                         DENSE_RANK()
                         OVER (
                             PARTITION BY MRN,
                                          SUBSCRIBER_ID,
                                          LOB_ID,
                                          QIP_PERIOD
                             ORDER BY ASSESSMENTDATE)
                             AS QIP_PERIOD_SEQ,
                         DENSE_RANK()
                         OVER (
                             PARTITION BY MRN, SUBSCRIBER_ID, ENROLLMENT_DATE
                             ORDER BY ASSESSMENTDATE)
                             AS QIP_ENROLL_SEQ
                  FROM   MBR_UAS Z --ORDER BY SUBSCRIBER_ID, QIP_PERIOD, ASSESSMENTDATE
                                  ) Z2),
     /*Join the assessments from compliance dashboard to assessments used for QIP*/
     /*qip_flag = NULL means that the assessment did not meet the QIP criteria
         (e.g. the initial assessment took place before the 42-day grace period)
         and compliance_flag=1 means that the assessment did not take place within the bounds of referral date and disenrollment date */
     ALL_ASSESS AS
         (SELECT NVL(A.MEDICAID_NUM, B.MEDICAID_NUM) AS MEDICAID_NUM,
                 NVL(A.SUBSCRIBER_ID, B.SUBSCRIBER_ID) AS SUBSCRIBER_ID,
                 NVL(A.MRN, B.MRN) AS MRN,
                 NVL(A.CHOICE_CASE_NUM, B.CASE_NUM) AS CHOICE_CASE_NUM,
                 NVL(A.LOB_ID, B.LOB_ID) AS LOB_ID,
                 NVL(A.LINE_OF_BUSINESS, B.LINE_OF_BUSINESS)
                     AS LINE_OF_BUSINESS,
                 NVL(A.REFERRAL_DATE, B.REFERRAL_DATE) AS REFERRAL_DATE,
                 NVL(A.ENROLLMENT_DATE, B.ENROLLMENT_DATE) AS ENROLLMENT_DATE,
                 NVL(A.DISENROLLMENT_DATE, B.DISENROLLMENT_DATE)
                     AS DISENROLLMENT_DATE,
                 NVL(A.RECORD_ID, B.RECORD_ID) AS RECORD_ID,
                 NVL(A.ASSESSMENTDATE, B.ASSESSMENTDATE) AS ASSESSMENTDATE,
                 TRUNC(NVL(A.ASSESSMENTDATE, B.ASSESSMENTDATE), 'MM')
                     AS ASSESSMONTH,
                 NVL(A.NEXT_DUE, B.NEXT_DUE) AS NEXT_DUE,
                   TO_CHAR(NVL(A.NEXT_DUE, B.NEXT_DUE), 'yyyy') * 100
                 + CASE
                       WHEN TO_CHAR(NVL(A.NEXT_DUE, B.NEXT_DUE), 'q') IN
                                (1, 2) THEN
                           1
                       WHEN TO_CHAR(NVL(A.NEXT_DUE, B.NEXT_DUE), 'q') IN
                                (3, 4) THEN
                           2
                   END
                     AS NEXT_DUE_PERIOD,
                 NVL(A.ASSESSMENTREASON, B.ASSESSMENTREASON)
                     AS ASSESSMENTREASON,
                 NVL(A.RESIDENCEASSESSMENT, B.RESIDENCEASSESSMENT)
                     AS RESIDENCEASSESSMENT,
                 NVL(A.ONURSEORG, B.ONURSEORG) AS ONURSEORG,
                 NVL(A.ONURSEORGNAME, B.ONURSEORGNAME) AS ONURSEORGNAME,
                 NVL(A.ONURSENAME, B.ONURSENAME) AS ONURSENAME,
                 NVL(A.MEMBER_ID, B.MEMBER_ID) AS MEMBER_ID,
                 NVL(A.DL_LOB_ID, B.DL_LOB_ID) AS DL_LOB_ID,
                 NVL(A.DL_ENROLL_ID, B.DL_ENROLL_ID) AS DL_ENROLL_ID,
                 NVL(A.DL_LOB_GRP_ID, B.DL_LOB_GRP_ID) AS DL_LOB_GRP_ID,
                 NVL(A.DL_PLAN_SK, B.DL_PLAN_SK) AS DL_PLAN_SK,
                 NVL(A.DL_MEMBER_SK, B.DL_MEMBER_SK) AS DL_MEMBER_SK,
                 A.QIP_MONTH_ID,
                 A.QIP_PERIOD,
                 A.QIP_PERIOD_SEQ,
                 A.QIP_PERIOD_SEQ_DESC,
                 A.QIP_ENROLL_SEQ,
                 A.QIP_FLAG,
                 B.COMPLIANCE_FLAG,
                 B.ENROLL_ASSESS_SEQ,
                 B.ENROLL_ASSESS_SEQ_DESC
          FROM   QIP_ASSESSMENTS A
                 FULL OUTER JOIN (SELECT *
                                  FROM   COMPLIANCE_MEASURE
                                  WHERE  ASSESSMENTDATE >= '01-JAN-2014') B
                     ON (    A.RECORD_ID = B.RECORD_ID
                         AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                         AND A.LOB_ID = B.LOB_ID
                         AND A.ENROLLMENT_DATE = B.ENROLLMENT_DATE) --          ORDER BY NVL(A.SUBSCRIBER_ID, B.SUBSCRIBER_ID) DESC,
                                                                   --                   NVL(A.ASSESSMENTDATE, B.ASSESSMENTDATE),
                                                                   --                   A.QIP_PERIOD
     )
SELECT *
FROM   ALL_ASSESS