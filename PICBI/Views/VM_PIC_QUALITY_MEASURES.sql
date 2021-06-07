/* Formatted on 6/7/2021 11:18:11 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW VM_PIC_QUALITY_MEASURES
(
    MEASURE_ID,
    CLIENTID,
    SOC,
    MONTH_ID,
    THE_DATE,
    DATE_TYPE,
    ASSESS_DATE,
    STAFF_ID,
    COMPANY_ID,
    NUM,
    DEN
)
BEQUEATH DEFINER
AS
    SELECT DISTINCT
           '001'
               MEASURE_ID,
           PATIENT_CODE
               CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           SCHEDULEDATE
               AS THE_DATE,
           '1st_HHA_Visit'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE
               WHEN (VISIT_DATE BETWEEN SCHEDULEDATE AND SCHEDULEDATE + 2)
               THEN
                   1
               ELSE
                   0
           END
               AS NUM,
           1
               AS DEN
      FROM (SELECT /*+ materialize use_hash(den, num)*/
                   den.*, num.SCHEDULEDATE
              FROM (SELECT *
                      FROM (SELECT /*+ materialize use_hash(sp c  a p) */
                                   SP.PATIENT_CODE,
                                   C.MR_NUMBER,
                                   TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                                       VISIT_DATE,
                                   FIRSTNAME,
                                   LASTNAME,
                                   DOB,
                                   A.SOC,
                                   A.EOC,
                                   A.CLIENTID,
                                   A.COMPANYID,
                                   SP.CAREGIVER_CODE,
                                   RANK ()
                                       OVER (PARTITION BY A.clientid, A.SOC
                                             ORDER BY SP.VISIT_DATE)
                                       RK
                              FROM PIC.SPOC_FORM  SP
                                   JOIN PIC.SPOC_PATIENT_CHART C
                                       ON     C.PATIENT_CODE =
                                              SP.PATIENT_CODE
                                          AND C.CHART_NUMBER =
                                              SP.CHART_NUMBER
                                   JOIN PIC.PATIENT_ADMISSIONS A
                                       ON     A.clientid = SP.PATIENT_CODE
                                          AND C.MR_NUMBER = A.CHARTID
                                          AND TO_DATE (SP.VISIT_DATE,
                                                       'YYYYMMDD') BETWEEN A.SOC
                                                                       AND NVL (
                                                                               A.EOC,
                                                                               SYSDATE)
                                   JOIN PIC.PATIENTS P
                                       ON SP.PATIENT_CODE = P.CLIENTID
                             WHERE     SP.FORM_NAME IN
                                           ('Adult Assessment SOC')
                                   AND SP.REMOVED = 'N'
                                   AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                                   AND SP.FORM_STATUS != 'Pending'
                                   AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                                       '7/01/2020',
                                                                                       'mm/dd/yyyy')
                                                                               AND SYSDATE)
                     WHERE RK = 1) den
                   LEFT JOIN
                   (SELECT *
                      FROM (SELECT /*+ materialize USE_HASH(A S ts) */
                                   A.clientid,
                                   A.SOC,
                                   A.EOC,
                                   S.SCHEDULEDATE,
                                   A.ADMISSIONSTATUS,
                                   A.COMPANYID,
                                   RANK ()
                                       OVER (PARTITION BY A.clientid, A.SOC
                                             ORDER BY S.SCHEDULEDATE)    RK2
                              FROM PIC.PATIENT_ADMISSIONS  A
                                   JOIN PICBI.VW_SCHEDULES S
                                       ON     S.CLIENTID = A.CLIENTID
                                          AND S.SCHEDULEDATE BETWEEN A.SOC
                                                                 AND NVL (
                                                                         A.EOC,
                                                                         SYSDATE)
                                   JOIN PIC.SCHEDULES_TASKS TS
                                       ON TS.SCHEDULEID = S.SCHEDULEID
                             WHERE TS.TASKNAME != '0085 Travel Time')
                     WHERE RK2 = 1) num
                       ON     den.PATIENT_CODE = num.clientid
                          AND num.SOC = den.SOC
                          AND NVL (num.EOC, SYSDATE) = NVL (den.EOC, SYSDATE))
    UNION ALL
    SELECT DISTINCT
           '003'                                     MEASURE_ID,
           PATIENT_CODE                              CLIENTID,
           SOC,
           CONCAT (TO_CHAR (CERT_END_DATE, 'yyyy'),
                   TO_CHAR (CERT_END_DATE, 'mm'))    AS MONTH_ID,
           CERT_END_DATE                             THE_DATE,
           'CERT_END_DATE'                           DATE_TYPE,
           ASSESS_DATE,
           MANAGERID                                 STAFF_ID,
           COMPANYID                                 COMPANY_ID,
           CASE
               WHEN ASSESS_DATE BETWEEN START_DATE_FOR_ASSESS
                                    AND (CERT_END_DATE + 1) --- ADDED +1 to END_DATE to INCLUDE ACTUAL RECERTIFICATION DATE TO COMPLETE THE VISIT
               THEN
                   1
               ELSE
                   0
           END                                       AS NUM,
           1                                         AS DEN
      FROM (SELECT PATIENT_CODE,
                   CHARTID,
                   CERT_START_DATE,
                   CERT_END_DATE,
                   COMPANYID,
                   SOC,
                   EOC,
                   DATE_MODIFIED,
                   START_DATE_FOR_ASSESS,
                   CERTIFICATION_NUMBER,
                   ASSESS_DATE,
                   MANAGERID,
                   CAREGIVER_CODE,
                   FORM_STATUS,
                   RK
              FROM (SELECT DEN.PATIENT_CODE,
                           DEN.CHARTID,
                           TO_DATE (DEN.START_DATE, 'YYYYMMDD')
                               CERT_START_DATE,
                           TO_DATE (DEN.END_DATE, 'YYYYMMDD')
                               CERT_END_DATE,
                           DEN.COMPANYID,
                           DEN.SOC,
                           DEN.EOC,
                           DEN.DATE_MODIFIED,
                           DEN.START_DATE_FOR_ASSESS,
                           DEN.CERTIFICATION_NUMBER,
                           TO_DATE (NUM.VISIT_DATE, 'YYYYMMDD')
                               ASSESS_DATE,
                           DEN.MANAGERID,
                           NUM.CAREGIVER_CODE,
                           NUM.FORM_STATUS,
                           RANK ()
                               OVER (
                                   PARTITION BY DEN.PATIENT_CODE,
                                                DEN.CHARTID,
                                                DEN.COMPANYID,
                                                DEN.SOC,
                                                TO_DATE (DEN.START_DATE,
                                                         'YYYYMMDD'),
                                                TO_DATE (DEN.END_DATE,
                                                         'YYYYMMDD')
                                   ORDER BY
                                       TO_DATE (NUM.VISIT_DATE, 'YYYYMMDD') DESC)
                               RK
                      FROM (SELECT DISTINCT
                                   C.*,
                                   TO_DATE (end_date, 'YYYYMMDD') - 21
                                       start_date_for_assess,
                                   A.COMPANYID,
                                   A.SOC,
                                   A.EOC,
                                   A.CHARTID,
                                   A.MANAGERID
                              FROM PIC.SPOC_PATIENT_CERTIFICATION_PERIOD  C
                                   JOIN PIC.PATIENT_ADMISSIONS A
                                       ON     A.CLIENTID = C.PATIENT_CODE
                                          AND TO_DATE (C.START_DATE,
                                                       'YYYYMMDD') BETWEEN A.SOC
                                                                       AND NVL (
                                                                               A.EOC,
                                                                               SYSDATE)
                             WHERE     C.REMOVED = 'N'
                                   AND SUBSTR (A.CHARTID, -3, 2) != 'KD'
                                   AND TO_DATE (C.END_DATE, 'YYYYMMDD') BETWEEN '01-JUL-2020'
                                                                            AND SYSDATE
                                   AND TO_DATE (C.END_DATE, 'YYYYMMDD') !=
                                       NVL (A.EOC, SYSDATE + 10)
                                   AND A.COMPANYID NOT IN (7, 10) -- ADDED filter to exclude CERTIFIED and HOSPICE
                                                                 ) DEN
                           LEFT JOIN
                           (SELECT SP.*, C.MR_NUMBER, C.START_OF_CARE
                              FROM PIC.SPOC_FORM  SP
                                   JOIN PIC.SPOC_PATIENT_CHART C
                                       ON     C.PATIENT_CODE =
                                              SP.PATIENT_CODE
                                          AND C.CHART_NUMBER =
                                              SP.CHART_NUMBER
                             WHERE     form_name IN
                                           ('Adult Assessment Recert',
                                            'Adult Assessment - Recert')
                                   AND SP.REMOVED = 'N'
                                   AND FORM_STATUS != 'Pending') NUM
                               ON     DEN.PATIENT_CODE = NUM.PATIENT_CODE
                                  AND DEN.CHARTID = NUM.MR_NUMBER
                                  AND TO_DATE (NUM.VISIT_DATE, 'YYYYMMDD') BETWEEN DEN.SOC
                                                                               AND NVL (
                                                                                       DEN.EOC,
                                                                                       SYSDATE)
                                  AND TO_DATE (NUM.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                                       DEN.START_DATE,
                                                                                       'YYYYMMDD')
                                                                               AND TO_DATE (
                                                                                       END_DATE,
                                                                                       'YYYYMMDD') --  AND DEN.CERTIFICATION_NUMBER = NUM.CERTIFICATION_NUMBER
                                                                                                  )
             WHERE RK = 1)
    UNION ALL
    SELECT DISTINCT
           '004'
               MEASURE_ID,
           PATIENT_CODE
               CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               AS THE_DATE,
           'Supervisory_Visit'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE
               WHEN SUP_VISIT = 1 AND SUP_PRE = 1 AND OTHER_CHK = 9 THEN 1
               ELSE 0
           END
               AS NUM,
           1
               AS DEN
      FROM (SELECT DISTINCT den.PATIENT_CODE,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER     AS CHARTID,
                            den.FORM_ID,
                            den.FORM_NAME,
                            num.SUP_VISIT,
                            num.SUP_PRE,
                            num.OTHER_CHK
              FROM (SELECT C.MR_NUMBER,
                           A.CLIENTID,
                           SP.FORM_ID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           SP.PATIENT_CODE,
                           P.FIRSTNAME,
                           P.LASTNAME,
                           SP.DATE_CREATED,
                           SP.FORM_STATUS,
                           A.COMPANYID,
                           A.CHARTID,
                           A.SOC,
                           A.EOC,
                           F.FORM_FIELD_NAME,
                           F.FORM_FIELD_VALUE
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_FORM_NEWFIELDS_V F
                               ON SP.FORM_ID = F.FORM_ID
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PIC.PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     UPPER (F.FORM_FIELD_NAME) =
                               UPPER ('supervisoryUserType')
                           AND FORM_FIELD_VALUE = 'HHA'
                           AND SP.REMOVED = 'N'
                           AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (A.CHARTID, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (  SELECT FORM_ID,
                             SUM (
                                 CASE
                                     WHEN    FORM_FIELD_NAME =
                                             'Supervision performed this visit'
                                          OR     FORM_FIELD_NAME =
                                                 'sup_Supervision_Rdo'
                                             AND FORM_FIELD_VALUE =
                                                 '1'
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS SUP_VISIT,
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME =
                                              'sup_Present_Rdo'
                                          AND FORM_FIELD_VALUE = '1'
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS SUP_PRE,
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME IN
                                                  ('sup_Staff_Rdo',
                                                   'sup_Poc_Rdo',
                                                   'sup_PatientReso_Rdo',
                                                   'sup_CommFam_Rdo',
                                                   'sup_PatientCondi_Rdo',
                                                   'sup_Demonstrate_Rdo',
                                                   'sup_HonorPat_Rdo',
                                                   'sup_PolicyCnt_Rdo',
                                                   'sup_Patient_Rdo')
                                          AND FORM_FIELD_VALUE IN
                                                  ('0', '1', '2')
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS OTHER_CHK
                        FROM PIC.SPOC_FORM_NEWFIELDS_V
                       WHERE FORM_NAME IN ('Adult Assessment',
                                           'Adult Assessment (CoP Version)',
                                           'Adult Assessment (CoP) Version',
                                           'Adult Assessment - ROC',
                                           'Adult Assessment - Readmission',
                                           'Adult Assessment - Recert',
                                           'Adult Assessment Readmission',
                                           'Adult Assessment Recert',
                                           'Adult Assessment SOC',
                                           'Nursing Visit Note')
                    GROUP BY FORM_ID) num
                       ON num.FORM_ID = den.FORM_ID)
    UNION ALL
    SELECT DISTINCT
           '006'
               MEASURE_ID,
           CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               THE_DATE,
           'ASSESS_DATE'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE WHEN FORM_FIELD_NAME IS NOT NULL THEN 1 ELSE 0 END
               AS NUM,
           1
               AS DEN
      FROM (SELECT /*+ materialize use_hash(den, num)*/
                   DISTINCT den.CLIENTID,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.DOB,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER,
                            den.FORM_ID,
                            den.FORM_NAME,
                            num.FORM_FIELD_NAME,
                            num.FORM_FIELD_VALUE
              FROM (SELECT /*+ use_hash(sp c A P) */
                           SP.PATIENT_CODE,
                           C.MR_NUMBER,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           FIRSTNAME,
                           LASTNAME,
                           DOB,
                           A.SOC,
                           A.EOC,
                           A.CLIENTID,
                           A.COMPANYID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           SP.FORM_ID
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PIC.PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     SP.FORM_NAME LIKE ('%Adult Assessment%')
                           AND SP.REMOVED = 'N'
                           AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (SELECT *
                      FROM PIC.SPOC_FORM_NEWFIELDS_V
                     WHERE FORM_ID IN
                               (SELECT /*+ no_merge */
                                       FORM_ID
                                  FROM (SELECT FORM_ID
                                          FROM PIC.SPOC_FORM_NEWFIELDS_V
                                         WHERE FORM_FIELD_NAME LIKE
                                                   'SafetyHazards%'
                                        INTERSECT
                                        SELECT FORM_ID
                                          FROM PIC.SPOC_FORM_NEWFIELDS_V
                                         WHERE     FORM_FIELD_NAME =
                                                   'cp_safety_measures'
                                               AND REGEXP_LIKE (
                                                       FORM_FIELD_VALUE,
                                                       'Clear Pathways|Fall Precautions|Equipment Safety|Keep Pathways Clear
                                                              |Safety in ADLs|Keep Siderails Up|Seizure Precautions|Siderails up|
                                                               Slow Position Change|Support During Transfer and Ambulation|Use of Assistive Devices'))))
                   num
                       ON     num.FORM_ID = den.FORM_ID
                          AND (   FORM_FIELD_NAME LIKE 'SafetyHazards%'
                               OR FORM_FIELD_NAME = 'cp_safety_measures'))
    UNION ALL
    SELECT DISTINCT
           '007'
               MEASURE_ID,
           CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               THE_DATE,
           'ASSESS_DATE'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE WHEN FORM_FIELD_VALUE IS NOT NULL THEN 1 ELSE 0 END
               AS NUM,
           1
               AS DEN
      FROM (SELECT DISTINCT den.CLIENTID,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.DOB,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER,
                            den.FORM_ID,
                            den.FORM_NAME,
                            num.FORM_FIELD_NAME,
                            num.FORM_FIELD_VALUE
              FROM (SELECT SP.PATIENT_CODE,
                           C.MR_NUMBER,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           FIRSTNAME,
                           LASTNAME,
                           DOB,
                           A.SOC,
                           A.EOC,
                           A.CLIENTID,
                           A.COMPANYID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           SP.FORM_ID
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PIC.PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     SP.FORM_NAME LIKE ('%Adult Assessment%')
                           AND SP.REMOVED = 'N'
                           AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (SELECT form_id,
                           cnt,
                           'Caregiver Education'     AS FORM_FIELD_NAME,
                           'Caregiver Education'     AS FORM_FIELD_VALUE
                      FROM (  SELECT form_id,
                                     SUM (
                                         CASE
                                             WHEN UPPER (FORM_FIELD_VALUE) =
                                                  'ON'
                                             THEN
                                                 1
                                             ELSE
                                                 0
                                         END)    AS CNT
                                FROM PIC.SPOC_FORM_NEWFIELDS_V
                               WHERE FORM_FIELD_NAME IN ('InstructMaterial10', --- Medication Regimen/ Administation
                                                         'InstructMaterial4', --- Standard precautions
                                                         'InstructMaterial6', --- home safety
                                                         'ima_FallPrevent_Chk', -- Provided fall prevention
                                                         'InstructMaterial2', --When to contact physician and/or agency
                                                         'InstructMaterial8' --Disease Info
                                                                            )
                            GROUP BY form_id)
                     WHERE cnt = 6 -- this is to pull records with only mandatory (6 FORM) checks
                                  ) num
                       ON num.FORM_ID = den.FORM_ID)
    UNION ALL
    SELECT DISTINCT
           '008'
               MEASURE_ID,
           CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               THE_DATE,
           'SPOC_VISIT_DATE'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE
               WHEN     RW_CHK >= 1
                    AND RA_CNT >= 1
                    AND DRR_CNT = 8
                    AND MR_CHK = 1
               THEN
                   1
               ELSE
                   0
           END
               AS NUM,
           1
               AS DEN
      FROM (SELECT DISTINCT den.CLIENTID,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.DOB,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER,
                            den.FORM_ID,
                            den.FORM_NAME,
                            num.RW_CHK,
                            num.DRR_CNT,
                            num.RA_CNT,
                            num.MR_CHK
              FROM (SELECT SP.PATIENT_CODE,
                           C.MR_NUMBER,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           FIRSTNAME,
                           LASTNAME,
                           DOB,
                           A.SOC,
                           A.EOC,
                           A.CLIENTID,
                           A.COMPANYID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           SP.FORM_ID
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PIC.PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     UPPER (SP.FORM_NAME) LIKE
                                   ('MEDICATION PROFILE')
                           AND SP.REMOVED = 'N'
                           --AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (  SELECT FORM_ID,
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME IN
                                                  ('CaregiverPeriodic',
                                                   'Patient')
                                          AND FORM_FIELD_VALUE = 'on'
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS RW_CHK,
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME IN
                                                  ('ActionsDoses',
                                                   'AvoidanceContamination',
                                                   'DisposalMeds',
                                                   'PrescriptionRefill',
                                                   'ReferSNNotes')
                                          AND FORM_FIELD_VALUE = 'on'
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS RA_CNT,
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME IN
                                                  ('mmp_DrugInteract1_Rdo',
                                                   'mmp_DrugReact1_Rdo',
                                                   'mmp_DrugReg1_Rdo',
                                                   'mmp_DrugTherapy1_Rdo',
                                                   'mmp_FurMedicIns1_Rdo',
                                                   'mmp_MedicIns1_Rdo',
                                                   'mmp_PotNonComp1_Rdo',
                                                   'mmp_SideEffects1_Rdo')
                                          AND FORM_FIELD_VALUE IN
                                                  (0, 1)
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS DRR_CNT,     --DRUG REGIMEN REVIEW
                             SUM (
                                 CASE
                                     WHEN     FORM_FIELD_NAME =
                                              'mmp_Reconciled_Chk'
                                          AND FORM_FIELD_VALUE = 'on'
                                     THEN
                                         1
                                     ELSE
                                         0
                                 END)    AS MR_CHK --MEDICATION RECONCILED CHECK
                        FROM PIC.SPOC_FORM_NEWFIELDS_V SP_F
                       WHERE UPPER (FORM_NAME) LIKE ('MEDICATION PROFILE')
                    GROUP BY FORM_ID) num
                       ON num.FORM_ID = den.FORM_ID)
    UNION ALL
    SELECT DISTINCT
           '009'                         MEASURE_ID,
           CLIENTID,
           SOC,
           DUE_MONTH                     AS MONTH_ID,
           V_DUE_DATE                    AS THE_DATE,
           '90_Day_Supervisory_Visit'    AS DATE_TYPE,
           ASSESSMENT_DATE               AS ASSESS_DATE,
           CAREGIVER_CODE                STAFF_ID,
           COMPANYID                     COMPANY_ID,
           CASE
               WHEN     DAYS_DIFF <= 91
                    AND SUP_TYPE = 1
                    AND SUP_VISIT = 1
                    AND SUP_PRE = 1
                    AND OTHER_CHK = 9
               THEN
                   1
               ELSE
                   0
           END                           AS NUM,
           1                             AS DEN
      FROM (SELECT den.CLIENTID,
                   den.CAREGIVER_CODE,
                   den.COMPANYID,
                   den.EOC,
                   den.SOC,
                   den.MR_NUMBER,
                   den.CHARTID,
                   den.VISIT_DATE,
                   den.ASSESSMENT_DATE,
                   den.FIRSTNAME,
                   den.LASTNAME,
                   den.FORM_ID,
                   num.FORM_ID,
                   den.FORM_NAME,
                   num.V_DATE,
                   den.ASSESSMENT_DATE + 91
                       AS V_DUE_DATE,
                   TO_CHAR (den.ASSESSMENT_DATE + 91, 'YYYYMM')
                       AS DUE_MONTH,
                   num.PREV_V_DATE,
                   num.DAYS_DIFF,
                   num.SUP_TYPE,
                   num.SUP_VISIT,
                   num.SUP_PRE,
                   num.OTHER_CHK
              FROM (SELECT DISTINCT
                           C.MR_NUMBER,
                           C.CHART_NUMBER,
                           A.CLIENTID,
                           P.FIRSTNAME,
                           P.LASTNAME,
                           A.CHARTID,
                           SP.FORM_ID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                               VISIT_DATE,
                           TO_CHAR (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'),
                                    'YYYYMM')
                               CURR_MONTH_ID,
                           A.SOC,
                           A.EOC,
                           NVL (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'), SOC)
                               ASSESSMENT_DATE,
                           SP.PATIENT_CODE,
                           A.COMPANYID
                      FROM PIC.PATIENT_ADMISSIONS  A
                           JOIN PIC.ADMISSION_SERVICES PAD_ADM_SER
                               ON A.ADMISSIONID = PAD_ADM_SER.ADMISSIONID
                           LEFT JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.MR_NUMBER = A.CHARTID
                                  AND UPPER (CHART_STATUS) = 'ACTIVE'
                           LEFT JOIN PIC.SPOC_FORM SP
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                                  AND SP.FORM_NAME IN
                                          ('Adult Assessment - Recert',
                                           'Adult Assessment Recert',
                                           'Adult Assessment SOC',
                                           'Nursing Visit Note')
                                  AND SP.REMOVED = 'N'
                                  AND SP.FORM_STATUS != 'Pending'
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN
                           (SELECT DISTINCT CLIENTID, FIRSTNAME, LASTNAME
                              FROM PIC.PATIENTS) P
                               ON A.CLIENTID = P.CLIENTID
                     WHERE     SUBSTR (A.CHARTID, -3, 2) != 'KD'
                           AND A.COMPANYID = 8
                           AND A.ADMISSIONSTATUS = '02'
                           AND NVL (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'), SOC) BETWEEN TO_DATE (
                                                                                          '20210101',
                                                                                          'YYYYMMDD')
                                                                                  AND SYSDATE
                           AND SERVICEID IN ('HHA', 'PCW', 'PCA')) den
                   LEFT JOIN
                   (SELECT *
                      FROM (SELECT PATIENT_CODE,
                                   CHARTID,
                                   FORM_ID,
                                   SUP_TYPE,
                                   SUP_VISIT,
                                   SUP_PRE,
                                   OTHER_CHK,
                                   V_DATE,
                                   PREV_V_DATE,
                                   V_DATE - PREV_V_DATE     AS DAYS_DIFF
                              FROM (SELECT FORM_ID,
                                           PATIENT_CODE,
                                           CHARTID,
                                           SUP_TYPE,
                                           SUP_VISIT,
                                           SUP_PRE,
                                           OTHER_CHK,
                                           V_DATE,
                                           NVL (
                                               LAG (V_DATE, 1)
                                                   OVER (
                                                       PARTITION BY PATIENT_CODE,
                                                                    CHART_NUMBER
                                                       ORDER BY V_DATE ASC),
                                               V_DATE)    AS PREV_V_DATE
                                      FROM (  SELECT SP.FORM_ID,
                                                     SP.PATIENT_CODE,
                                                     A.CHARTID,
                                                     SP.CHART_NUMBER,
                                                     TO_DATE (SP.VISIT_DATE,
                                                              'YYYYMMDD')
                                                         AS V_DATE,
                                                     SUM (
                                                         CASE
                                                             WHEN     UPPER (
                                                                          FORM_FIELD_NAME) =
                                                                      UPPER (
                                                                          'supervisoryUserType')
                                                                  AND FORM_FIELD_VALUE =
                                                                      'HHA'
                                                             THEN
                                                                 1
                                                             ELSE
                                                                 0
                                                         END)
                                                         AS SUP_TYPE,
                                                     SUM (
                                                         CASE
                                                             WHEN     FORM_FIELD_NAME =
                                                                      'sup_Supervision_Rdo'
                                                                  AND FORM_FIELD_VALUE =
                                                                      '1'
                                                             THEN
                                                                 1
                                                             ELSE
                                                                 0
                                                         END)
                                                         AS SUP_VISIT,
                                                     SUM (
                                                         CASE
                                                             WHEN     FORM_FIELD_NAME =
                                                                      'sup_Present_Rdo'
                                                                  AND FORM_FIELD_VALUE =
                                                                      '1'
                                                             THEN
                                                                 1
                                                             ELSE
                                                                 0
                                                         END)
                                                         AS SUP_PRE,
                                                     SUM (
                                                         CASE
                                                             WHEN     FORM_FIELD_NAME IN
                                                                          ('sup_Staff_Rdo',
                                                                           'sup_Poc_Rdo',
                                                                           'sup_PatientReso_Rdo',
                                                                           'sup_CommFam_Rdo',
                                                                           'sup_PatientCondi_Rdo',
                                                                           'sup_Demonstrate_Rdo',
                                                                           'sup_HonorPat_Rdo',
                                                                           'sup_PolicyCnt_Rdo',
                                                                           'sup_Patient_Rdo')
                                                                  AND FORM_FIELD_VALUE IN
                                                                          ('0',
                                                                           '1',
                                                                           '2')
                                                             THEN
                                                                 1
                                                             ELSE
                                                                 0
                                                         END)
                                                         AS OTHER_CHK
                                                FROM PIC.SPOC_FORM SP
                                                     JOIN
                                                     (SELECT DISTINCT
                                                             FORM_ID,
                                                             CASE
                                                                 WHEN FORM_FIELD_NAME = 'Supervision performed this visit'
                                                                 THEN
                                                                     'sup_Supervision_Rdo'
                                                                 ELSE
                                                                     FORM_FIELD_NAME
                                                             END
                                                                 AS FORM_FIELD_NAME,
                                                             FORM_FIELD_VALUE
                                                        FROM PIC.SPOC_FORM_NEWFIELDS_V)
                                                     F
                                                         ON SP.FORM_ID =
                                                            F.FORM_ID
                                                     JOIN
                                                     PIC.SPOC_PATIENT_CHART C
                                                         ON     C.PATIENT_CODE =
                                                                SP.PATIENT_CODE
                                                            AND C.CHART_NUMBER =
                                                                SP.CHART_NUMBER
                                                     JOIN
                                                     PIC.PATIENT_ADMISSIONS A
                                                         ON     A.clientid =
                                                                SP.PATIENT_CODE
                                                            AND C.MR_NUMBER =
                                                                A.CHARTID
                                                            AND TO_DATE (
                                                                    SP.VISIT_DATE,
                                                                    'YYYYMMDD') BETWEEN A.SOC
                                                                                    AND NVL (
                                                                                            A.EOC,
                                                                                            SYSDATE)
                                               WHERE     SP.REMOVED = 'N'
                                                     AND C.REMOVED = 'N'
                                                     AND SP.FORM_STATUS !=
                                                         'Pending'
                                                     AND SUBSTR (A.CHARTID,
                                                                 -3,
                                                                 2) !=
                                                         'KD'
                                                     AND COMPANYID = 8
                                                     AND A.ADMISSIONSTATUS =
                                                         '02'
                                                     AND TO_DATE (
                                                             SP.VISIT_DATE,
                                                             'YYYYMMDD') BETWEEN TO_DATE (
                                                                                     '01/01/2021',
                                                                                     'mm/dd/yyyy')
                                                                             AND SYSDATE
                                                     AND SP.FORM_NAME IN
                                                             ('Adult Assessment - Recert',
                                                              'Adult Assessment Recert',
                                                              'Adult Assessment SOC',
                                                              'Nursing Visit Note')
                                            GROUP BY SP.FORM_ID,
                                                     SP.PATIENT_CODE,
                                                     A.CHARTID,
                                                     SP.CHART_NUMBER,
                                                     TO_DATE (SP.VISIT_DATE,
                                                              'YYYYMMDD')))))
                   num
                       ON     num.PATIENT_CODE = den.CLIENTID
                          AND num.CHARTID = den.CHARTID
                          AND num.V_DATE = den.ASSESSMENT_DATE
                          AND num.FORM_ID = den.FORM_ID)
    UNION ALL
    SELECT DISTINCT
           '012'
               MEASURE_ID,
           CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               AS THE_DATE,
           'ASSESS_DATE'
               AS DATE_TYPE,
           VISIT_DATE
               AS ASSESS_DATE,
           CAREGIVER_CODE
               AS STAFF_ID,
           COMPANYID
               AS COMPANY_ID,
           CASE WHEN FORM_FIELD_VALUE IS NOT NULL THEN 1 ELSE 0 END
               AS NUM,
           1
               AS DEN
      FROM (SELECT DISTINCT den.CLIENTID,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.DOB,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER,
                            den.FORM_ID,
                            den.FORM_NAME,
                            num.FORM_NAME,
                            num.FORM_FIELD_NAME,
                            num.FORM_FIELD_VALUE
              FROM (SELECT DISTINCT
                           SP.PATIENT_CODE,
                           C.MR_NUMBER,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           FIRSTNAME,
                           LASTNAME,
                           DOB,
                           A.SOC,
                           A.EOC,
                           A.CLIENTID,
                           A.COMPANYID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           SP.FORM_ID
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PICBI.VW_PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     UPPER (SP.FORM_NAME) LIKE 'AIDE%'
                           AND SP.REMOVED = 'N'
                           AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (SELECT SP.PATIENT_CODE,
                           SP.FORM_ID,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                               AS VISIT_DATE,
                           SP.FORM_NAME,
                           F.FORM_FIELD_NAME,
                           F.FORM_FIELD_VALUE
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_FORM_NEWFIELDS_V F
                               ON SP.FORM_ID = F.FORM_ID
                     WHERE     UPPER (FORM_FIELD_NAME) = 'CP_SAFETY_MEASURES'
                           AND UPPER (FORM_FIELD_VALUE) LIKE
                                   'AIDE%DIRECTION%'
                           AND UPPER (SP.FORM_NAME) LIKE 'AIDE%') num
                       ON num.FORM_ID = den.FORM_ID)
    UNION ALL
    SELECT '010'
               MEASURE_ID,
           CLIENTID,
           SOC,
           CONCAT (TO_CHAR (VISIT_DATE, 'yyyy'), TO_CHAR (VISIT_DATE, 'mm'))
               AS MONTH_ID,
           VISIT_DATE
               THE_DATE,
           'ASSESS_DATE'
               DATE_TYPE,
           VISIT_DATE
               ASSESS_DATE,
           CAREGIVER_CODE
               STAFF_ID,
           COMPANYID
               COMPANY_ID,
           CASE
               WHEN        Client_Receipt_of_Information_Received <=
                           VISIT_DATE
                       AND Client_Guarantor_Agreement_Received <= VISIT_DATE
                       AND MedicareMedicaid_Information_Sheet_Received <=
                           VISIT_DATE
                    OR MLTC_Admission_Forms_Received <= VISIT_DATE
               THEN
                   1
               WHEN        Client_Receipt_of_Information_Received BETWEEN MIN_DATE
                                                                      AND MAX_DATE
                       AND Client_Guarantor_Agreement_Received BETWEEN MIN_DATE
                                                                   AND MAX_DATE
                       AND MedicareMedicaid_Information_Sheet_Received BETWEEN MIN_DATE
                                                                           AND MAX_DATE
                    OR MLTC_Admission_Forms_Received BETWEEN MIN_DATE
                                                         AND MAX_DATE
               THEN
                   1
               WHEN     Client_Receipt_of_Information_Received IS NULL
                    AND Client_Guarantor_Agreement_Received IS NULL
                    AND MedicareMedicaid_Information_Sheet_Received IS NULL
                    AND MLTC_Admission_Forms_Received IS NULL
                    AND CURRENT_DATE BETWEEN MIN_DATE AND MAX_DATE
               THEN
                   1
               ELSE
                   0
           END
               AS NUM,
           1
               AS DEN
      FROM (SELECT DISTINCT den.PATIENT_CODE     AS CLIENTID,
                            den.CAREGIVER_CODE,
                            den.COMPANYID,
                            den.DOB,
                            den.EOC,
                            den.SOC,
                            den.VISIT_DATE,
                            den.FIRSTNAME,
                            den.LASTNAME,
                            den.MR_NUMBER,
                            den.FORM_ID          AS den_FORM_ID,
                            den.FORM_NAME        AS DEN_FORM_NAME,
                            num.FORM_ID          AS num_FORM_ID,
                            num.Client_Receipt_of_Information_Received,
                            num.Client_Guarantor_Agreement_Received,
                            num.MedicareMedicaid_Information_Sheet_Received,
                            num.MLTC_Admission_Forms_Received,
                            num.MIN_DATE,
                            num.MAX_DATE,
                            num.FORM_NAME        AS NUM_FORM_NAME
              FROM (SELECT DISTINCT
                           SP.PATIENT_CODE,
                           C.MR_NUMBER,
                           TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')    VISIT_DATE,
                           FIRSTNAME,
                           LASTNAME,
                           DOB,
                           A.SOC,
                           A.EOC,
                           A.COMPANYID,
                           SP.CAREGIVER_CODE,
                           SP.FORM_NAME,
                           SP.FORM_ID
                      FROM PIC.SPOC_FORM  SP
                           JOIN PIC.SPOC_FORM_NEWFIELDS_V F
                               ON SP.FORM_ID = F.FORM_ID
                           JOIN PIC.SPOC_PATIENT_CHART C
                               ON     C.PATIENT_CODE = SP.PATIENT_CODE
                                  AND C.CHART_NUMBER = SP.CHART_NUMBER
                           JOIN PIC.PATIENT_ADMISSIONS A
                               ON     A.clientid = SP.PATIENT_CODE
                                  AND C.MR_NUMBER = A.CHARTID
                                  AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                              AND NVL (
                                                                                      A.EOC,
                                                                                      SYSDATE)
                           JOIN PICBI.VW_PATIENTS P
                               ON SP.PATIENT_CODE = P.CLIENTID
                     WHERE     UPPER (SP.FORM_NAME) IN
                                   ('ADULT ASSESSMENT SOC',
                                    'ADULT ASSESSMENT READMISSION',
                                    'ADULT ASSESSMENT - READMISSION')
                           AND SP.REMOVED = 'N'
                           AND SP.FORM_STATUS != 'Pending'
                           AND SUBSTR (C.MR_NUMBER, -3, 2) != 'KD'
                           AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN TO_DATE (
                                                                               '7/01/2020',
                                                                               'mm/dd/yyyy')
                                                                       AND SYSDATE)
                   den
                   LEFT JOIN
                   (  SELECT MIN (DAY_DATE)     AS MIN_DATE,
                             MAX (DAY_DATE)     AS MAX_DATE,
                             PATIENT_CODE,
                             VISIT_DATE,
                             SP_FORM_ID,
                             FORM_NAME,
                             FORM_ID,
                             Client_Receipt_of_Information_Received,
                             Client_Guarantor_Agreement_Received,
                             MedicareMedicaid_Information_Sheet_Received,
                             MLTC_Admission_Forms_Received
                        FROM (SELECT SP.PATIENT_CODE,
                                     LU_BUS_DAY.DAY_DATE,
                                     TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                                         AS VISIT_DATE,
                                     SP.FORM_ID
                                         AS SP_FORM_ID,
                                     SP.FORM_NAME,
                                     M.*,
                                     ROW_NUMBER ()
                                         OVER (
                                             PARTITION BY SP.PATIENT_CODE,
                                                          SP.VISIT_DATE
                                             ORDER BY DAY_DATE ASC)
                                         AS RN
                                FROM PIC.SPOC_FORM SP,
                                     (SELECT FORM_ID,
                                             MARK_NAME,
                                             NVL (
                                                 TO_DATE (MARK_EFFECTIVE_DATE,
                                                          'YYYYMMDD'),
                                                 TRUNC (MARK_DATE))    AS MARK_DATE
                                        FROM PIC.SPOC_FORM_MARKS)
                                     PIVOT (MIN (MARK_DATE)
                                           FOR MARK_NAME
                                           IN ('Client Receipt of Information Received' AS Client_Receipt_of_Information_Received,
                                              'Client Guarantor Agreement Received' AS Client_Guarantor_Agreement_Received,
                                              'MedicareMedicaid Information Sheet Received' AS MedicareMedicaid_Information_Sheet_Received,
                                              'MLTC Admission Forms Received' AS MLTC_Admission_Forms_Received)) M,
                                     (SELECT DAY_DATE,
                                             TO_CHAR (DAY_DATE, 'day')
                                                 AS NAME_DAY,
                                             MONTH_ID,
                                             YEAR_ID
                                        FROM MSTRSTG.LU_DAY@NEXUS2
                                       WHERE VNSNY_WORK_DAY = 1) LU_BUS_DAY --- gives business day (excludes weekends and holidays)
                               WHERE     SP.FORM_ID = M.FORM_ID
                                     AND LU_BUS_DAY.DAY_DATE >=
                                         TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                                     AND UPPER (SP.FORM_NAME) IN
                                             ('ADULT ASSESSMENT SOC',
                                              'ADULT ASSESSMENT READMISSION',
                                              'ADULT ASSESSMENT - READMISSION')
                                     AND SP.REMOVED = 'N'
                                     AND SP.FORM_STATUS != 'Pending') MARKS_LOG
                       WHERE RN <= 7 ---- gives 7 business dates from visit_date
                    GROUP BY PATIENT_CODE,
                             VISIT_DATE,
                             SP_FORM_ID,
                             FORM_NAME,
                             FORM_ID,
                             Client_Receipt_of_Information_Received,
                             Client_Guarantor_Agreement_Received,
                             MedicareMedicaid_Information_Sheet_Received,
                             MLTC_Admission_Forms_Received) num
                       ON den.FORM_ID = num.SP_FORM_ID);
