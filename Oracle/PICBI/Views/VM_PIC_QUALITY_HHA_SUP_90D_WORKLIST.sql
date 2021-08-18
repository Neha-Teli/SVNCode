/* Formatted on 8/18/2021 2:53:41 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW VM_PIC_QUALITY_HHA_SUP_90D_WORKLIST
(
    MEASURE_ID,
    CLIENTID,
    FIRSTNAME,
    LASTNAME,
    ADDRESS,
    APTNO,
    CITY,
    STATE,
    ZIP,
    PHONE1,
    PHONE2,
    PHONE3,
    COMPANYID,
    FORM_NAME,
    FORM_STATUS,
    SOC,
    CURR_CERT_PERIOD_START_DATE,
    LAST_VISIT_DATE,
    THE_DATE,
    NUM_DAYS_LEFT,
    MONTH_ID,
    STAFF_ID
)
BEQUEATH DEFINER
AS
      SELECT DISTINCT '020'                    MEASURE_ID,
                      CLIENTID,
                      FIRSTNAME,
                      LASTNAME,
                      ADDRESS,
                      APTNO,
                      CITY,
                      STATE,
                      ZIP,
                      HOMEPHONE,
                      WORKPHONE,
                      MOBILEPHONE,
                      COMPANYID,
                      FORM_NAME,
                      FORM_STATUS,
                      SOC,
                      CURR_CERT_PERIOD_START_DATE,
                      LAST_VISIT_DATE,
                      NEXT_VISIT_DUE_DATE      AS THE_DATE,
                      NUM_DAYS_LEFT,
                      NEXT_VISIT_DUE_MONTH     AS MONTH_ID,
                      STAFF_ID
        FROM (SELECT den.CLIENTID,
                     den.CAREGIVER_CODE
                         AS STAFF_ID,
                     den.COMPANYID,
                     den.EOC,
                     den.SOC,
                     den.START_DATE
                         AS CURR_CERT_PERIOD_START_DATE,
                     den.MR_NUMBER,
                     den.CHARTID,
                     den.VISIT_DATE,
                     den.ASSESSMENT_DATE
                         AS LAST_VISIT_DATE,
                     den.FIRSTNAME,
                     den.LASTNAME,
                     den.ADDRESS,
                     den.APTNO,
                     den.CITY,
                     den.STATE,
                     den.ZIP,
                     den.HOMEPHONE,
                     den.WORKPHONE,
                     den.MOBILEPHONE,
                     den.FORM_ID,
                     num.FORM_ID,
                     den.FORM_NAME,
                     den.FORM_STATUS,
                     num.V_DATE,
                     den.ASSESSMENT_DATE + 91
                         AS NEXT_VISIT_DUE_DATE,
                     TO_CHAR (den.ASSESSMENT_DATE + 91, 'YYYYMM')
                         AS NEXT_VISIT_DUE_MONTH,
                     (den.ASSESSMENT_DATE + 91) - TRUNC (SYSDATE)
                         AS NUM_DAYS_LEFT,
                     num.PREV_V_DATE,
                     num.DAYS_DIFF,
                     num.SUP_TYPE,
                     num.SUP_VISIT,
                     num.SUP_PRE,
                     num.OTHER_CHK,
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
                     END
                         AS NUM,
                     ROW_NUMBER ()
                         OVER (PARTITION BY CLIENTID
                               ORDER BY ASSESSMENT_DATE DESC)
                         AS RN
                FROM (SELECT DISTINCT
                             C.MR_NUMBER,
                             C.CHART_NUMBER,
                             A.CLIENTID,
                             P.FIRSTNAME,
                             P.LASTNAME,
                             P.ADDRESS,
                             P.APTNO,
                             P.CITY,
                             P.STATE,
                             P.ZIP,
                             P.HOMEPHONE,
                             P.WORKPHONE,
                             P.MOBILEPHONE,
                             A.CHARTID,
                             SP.FORM_ID,
                             SP.CAREGIVER_CODE,
                             SP.FORM_NAME,
                             SP.FORM_STATUS,
                             TO_DATE (SP.VISIT_DATE, 'YYYYMMDD')
                                 VISIT_DATE,
                             TO_CHAR (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'),
                                      'YYYYMM')
                                 CURR_MONTH_ID,
                             A.SOC,
                             TO_DATE (PAT_CERT.START_DATE, 'YYYYMMDD')
                                 START_DATE,
                             A.EOC,
                             NVL (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'), SOC)
                                 AS ASSESSMENT_DATE,
                             SP.PATIENT_CODE,
                             A.COMPANYID
                        FROM PIC.PATIENT_ADMISSIONS A
                             JOIN PIC.ADMISSION_SERVICES PAD_ADM_SER
                                 ON A.ADMISSIONID = PAD_ADM_SER.ADMISSIONID
                             JOIN PIC.SPOC_PATIENT_CHART C
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
                                    --AND SP.FORM_STATUS != 'Pending'
                                    AND TO_DATE (SP.VISIT_DATE, 'YYYYMMDD') BETWEEN A.SOC
                                                                                AND NVL (
                                                                                        A.EOC,
                                                                                        SYSDATE)
                             LEFT JOIN
                             PIC.SPOC_PATIENT_CERTIFICATION_PERIOD PAT_CERT
                                 ON     PAT_CERT.PATIENT_CODE = A.clientid
                                    AND PAT_CERT.CERTIFICATION_NUMBER =
                                        SP.CERTIFICATION_NUMBER
                             JOIN
                             (SELECT DISTINCT
                                     CLIENTID,
                                     FIRSTNAME,
                                     LASTNAME,
                                     ADDRESS,
                                     APTNO,
                                     CITY,
                                     STATE,
                                     ZIP,
                                     HOMEPHONE,
                                     WORKPHONE,
                                     MOBILEPHONE,
                                     ROW_NUMBER ()
                                         OVER (
                                             PARTITION BY CLIENTID
                                             ORDER BY
                                                 CASE
                                                     WHEN UPPER (STATE) = 'NY'
                                                     THEN
                                                         1
                                                     ELSE
                                                         2
                                                 END)    RN
                                FROM PIC.PATIENTS) P
                                 ON A.CLIENTID = P.CLIENTID
                       WHERE     SUBSTR (A.CHARTID, -3, 2) != 'KD'
                             AND A.COMPANYID = 8
                             AND A.ADMISSIONSTATUS = '02'
                             AND NVL (TO_DATE (SP.VISIT_DATE, 'YYYYMMDD'), SOC) BETWEEN TO_DATE (
                                                                                            '20210101',
                                                                                            'YYYYMMDD')
                                                                                    AND SYSDATE
                             AND SERVICEID IN ('HHA', 'PCW', 'PCA')
                             AND P.RN = 1) den
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
       WHERE     RN = 1
             AND (   UPPER (FIRSTNAME) NOT LIKE 'TEST%'
                  OR UPPER (LASTNAME) NOT LIKE 'TEST%')
    ---NEXT_VISIT_DUE_DATE >= TRUNC (SYSDATE) AND RN = 1
    --and clientid = 3291355
    ORDER BY CLIENTID;
