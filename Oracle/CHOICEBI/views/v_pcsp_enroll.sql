DROP VIEW V_PCSP_ENROLL;

CREATE OR REPLACE VIEW V_PCSP_ENROLL
(
    MEMBER_ID,
    SUBSCRIBER_ID,
    PRODUCT_NAME,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE,
    ACTIVE_IND,
    TEAM_MANAGER_NAME,
    CARE_MANAGER_NAME,
    PCSP_CATEGORY,
    DOCUMENT_ID,
    DOCUMENT,
    DOCUMENT_TYPE,
    PCSP_CREATED_BY,
    PCSP_CREATED_ON,
    PSP_BUSINESS_DAYS,
    PSP_DATE,
    PSP_CATEGORY,
    PSP_STATUS,
    DL_LOB_ID,
    DL_PLAN_SK
) AS
    SELECT "MEMBER_ID",
           "SUBSCRIBER_ID",
           "PRODUCT_NAME",
           "ENROLLMENT_DATE",
           "DISENROLLMENT_DATE",
           "ACTIVE_IND",
           TEAM_MANAGER_NAME,
           "CARE_MANAGER_NAME",
           "PCSP_CATEGORY",
           "DOCUMENT_ID",
           "DOCUMENT",
           "DOCUMENT_TYPE",
           "PCSP_CREATED_BY",
           "PCSP_CREATED_ON",
           "PSP_BUSINESS_DAYS",
           "PSP_DATE",
           "PSP_CATEGORY",
           PSP_STATUS,
           --"PCSP_SEQ",
           "DL_LOB_ID",
           DL_PLAN_SK
    FROM   (WITH ENROLL AS
                     (SELECT /* + materialize */
                            *
                      FROM   (SELECT A.*,
                                     UPPER(TRIM(c.first_name) || ' ' || TRIM(c.last_name)) AS care_manager_name,
                                     UPPER(TRIM(d.first_name) || ' ' || TRIM(d.last_name)) AS team_manager_name,
                                     g.dept_name,
                                     ROW_NUMBER()
                                     OVER (
                                         PARTITION BY a.subscriber_id, a.enrollment_date
                                         ORDER BY a.month_id DESC, CASE WHEN g.dept_name IN ('The EDDY', 'VNA of WNY', 'MLTC Social Work', 'MLTC Care Coord Managers', 'MLTC Care Coordinators') THEN 1 ELSE 0 END DESC)
                                         AS enroll_seq
                              FROM   CHOICEBI.FACT_MEMBER_MONTH A
                                     LEFT JOIN CHOICE.DIM_MEMBER_CARE_MANAGER@DLAKE B ON (A.CM_SK_ID = B.CM_SK_ID)
                                     LEFT JOIN CMGC.CARE_STAFF_DETAILS C ON (C.MEMBER_ID = B.CARE_MANAGER_ID)
                                     LEFT JOIN CMGC.CARE_STAFF_DETAILS D ON (D.MEMBER_ID = C.ASSIGNED_TO)
                                     LEFT JOIN cmgc.department g ON c.dept_id = g.dept_id
                                     LEFT JOIN cmgc.member_carestaff i ON c.member_id = i.member_id
                              WHERE  dl_lob_id IN (2, 4, 5) AND program IN ('MLTC', 'FIDA') /* added by Rachel on 7/13/2018 */
                                                                                           AND i.is_primary = 1 AND a.enrollment_date >= ADD_MONTHS( TRUNC( SYSDATE, 'month'), -12))
                      WHERE  ENROLL_SEQ = 1),
                 LAURAS_GC_PSP AS
                     (SELECT /* + no_merge materialize full(a) use_hash(a p a_desc y A3 A4 A5) */
                            A.SCRIPT_RUN_LOG_ID,
                             A.PATIENT_ID,
                             P.UNIQUE_ID,
                             A.STAFF_ID,
                             S.FIRST_NAME || ' ' || S.LAST_NAME STAFF_NAME,
                             A_DESC.VALUE AS SCPT_ACTIVITY_STATUS,
                             A4_DESC.STATUS_NAME AS SCPT_FORM_ACTIVITY_STATUS,
                             A.START_DATE,
                             A.END_DATE,
                             CASE WHEN LENGTH(TRANSLATE( TRIM(A4.APPROVED_UNITS), 'x0123456789', 'x')) IS NULL THEN TO_NUMBER(TRIM(A4.APPROVED_UNITS)) END AS PSP_APPROVED,
                             Y.PSP_TASKING_TOOL
                      FROM   CMGC.SCPT_PATIENT_SCRIPT_RUN_LOG A
                             LEFT JOIN CMGC.SCPT_SCRIPT_RUN_STATUS A_DESC ON (A.STATUS_ID = A_DESC.STATUS_ID)
                             JOIN (SELECT   A2.SCRIPT_RUN_LOG_ID, MAX(CASE WHEN A2.QUESTION_ID = 3365 THEN Q1.OPTION_VALUE ELSE NULL END) AS PSP_TASKING_TOOL
                                   FROM     CMGC.SCPT_PAT_SCRIPT_RUN_LOG_DET A2 JOIN CMGC.SCPT_QUESTION_RESPONSE Q1 ON (Q1.SCRIPT_RUN_LOG_DETAIL_ID = A2.SCRIPT_RUN_LOG_DETAIL_ID)
                                   WHERE    A2.SCRIPT_ID = 107
                                   GROUP BY A2.SCRIPT_RUN_LOG_ID) Y
                                 ON (A.SCRIPT_RUN_LOG_ID = Y.SCRIPT_RUN_LOG_ID)
                             LEFT JOIN (SELECT S.*, ROW_NUMBER() OVER (PARTITION BY S.PATIENT_ID, S.SCRIPT_RUN_LOG_ID ORDER BY S.CREATED_ON DESC) AS SEQ
                                        FROM   CMGC.SCPT_FORM_PATIENT_INFO S) A3
                                 ON (A.PATIENT_ID = A3.PATIENT_ID AND A.SCRIPT_RUN_LOG_ID = A3.SCRIPT_RUN_LOG_ID AND A3.SEQ = 1)
                             LEFT JOIN CMGC.SCPT_FORM_PAT_REVIEW_STATUS A4 ON (A3.SFPI_ID = A4.SFPI_ID)
                             LEFT JOIN CMGC.CM_MA_SERVICPLAN_SCRPTFORM_STS A4_DESC ON (A4.STATUS_ID = A4_DESC.SERVICEPLAN_SCRIPTFROM_ID)
                             JOIN CMGC.PATIENT_DETAILS P ON (A.PATIENT_ID = P.PATIENT_ID)
                             LEFT JOIN CMGC.CARE_STAFF_DETAILS S ON (S.MEMBER_ID = A.STAFF_ID)
                      WHERE  A.DELETED_BY IS NULL AND A.DELETED_ON IS NULL AND SUBSTR( P.UNIQUE_ID, 1, 1) = 'V'),
                 PCSP1 AS
                     (SELECT /* + materialize */
                            D.PATIENT_ID,
                             D.DOCUMENT_ID,
                             P.UNIQUE_ID,
                             D.ORIGINAL_NAME AS DOCUMENT,
                             T.DOCUMENT_TYPE,
                             UPPER(C.FIRST_NAME || ' ' || C.LAST_NAME) AS CREATED_BY,
                             D.CREATED_ON,
                             TO_CHAR( D.CREATED_ON, 'YYYYMM') AS CREATED_MONTH
                      FROM   CMGC.PATIENT_DOCUMENT_DETAILS D
                             JOIN CMGC.PATIENT_DETAILS P ON P.PATIENT_ID = D.PATIENT_ID
                             JOIN CMGC.PATIENT_DOCUMENT_TYPE T ON T.DOCUMENT_TYPE_ID = D.DOCUMENT_TYPE_ID
                             JOIN CMGC.CARE_STAFF_DETAILS C ON D.CREATED_BY = C.MEMBER_ID
                      WHERE  ((D.DOCUMENT_TYPE_ID = 12 AND UPPER(ORIGINAL_NAME) LIKE '%PCSP%.DOC%') OR (D.DOCUMENT_TYPE_ID in (25,42) AND UPPER(ORIGINAL_NAME) LIKE 'V%ICS%SERVICE%'))  AND D.DELETED_ON IS NULL AND P.DELETED_ON IS NULL
                             AND SUBSTR( P.UNIQUE_ID, 1, 1) = 'V'
                 ),
                 PCSP2 AS /*4551*/
                     (SELECT /* + materialize */
                            *
                      FROM   (SELECT A.MEMBER_ID,
                                     A.SUBSCRIBER_ID,
                                     a.first_name,
                                     a.last_name,
                                     A.DL_LOB_ID,
                                     A.DL_PLAN_SK,
                                     A.PRODUCT_NAME,
                                     A.ENROLLMENT_DATE,
                                     A.DISENROLLMENT_DATE,
                                     CASE WHEN A.DISENROLLMENT_DATE >= TRUNC(SYSDATE) THEN 1 ELSE 0 END AS ACTIVE_IND,
                                     a.team_manager_name, /*,STAFF.CARE_MANAGER_NAME*/
                                     A.CARE_MANAGER_NAME,
                                     A.DEPT_NAME,
                                     ROW_NUMBER() OVER (PARTITION BY A.SUBSCRIBER_ID, A.ENROLLMENT_DATE ORDER BY B.CREATED_ON ASC) AS PCSP_SEQ,
                                     CASE
                                         WHEN B.CREATED_ON BETWEEN TO_DATE( TO_CHAR( A.ENROLLMENT_DATE, 'YYYYMM'), 'YYYYMM') AND ADD_MONTHS( TO_DATE( TO_CHAR( A.ENROLLMENT_DATE, 'YYYYMM'), 'YYYYMM'), 1) THEN
                                             '1-TIMELY'
                                         WHEN A.ENROLLMENT_DATE IS NOT NULL AND B.CREATED_ON IS NOT NULL THEN
                                             '2-LATE'
                                         WHEN A.ENROLLMENT_DATE IS NOT NULL AND B.CREATED_ON IS NULL THEN
                                             '3-NOT DONE'
                                     END
                                         AS PCSP_CATEGORY,
                                     B.DOCUMENT_ID,
                                     UPPER(B.DOCUMENT) AS DOCUMENT,
                                     UPPER(B.DOCUMENT_TYPE) AS DOCUMENT_TYPE,
                                     B.CREATED_BY AS PCSP_CREATED_BY,
                                     TRUNC(B.CREATED_ON) AS PCSP_CREATED_ON
                              FROM   ENROLL A LEFT JOIN PCSP1 B ON B.UNIQUE_ID = A.SUBSCRIBER_ID AND B.CREATED_ON BETWEEN A.ENROLLMENT_DATE AND ADD_MONTHS( TRUNC( SYSDATE, 'month'), 3))
                      WHERE  PCSP_SEQ = 1),
                 PSP1 AS
                     (SELECT /* + materialize */
                            a.*, CASE WHEN psp_status = 'PENDING' THEN '0-Pending' /*'PSP NOT DONE (PENDING)'*/
                                                                                  WHEN psp_business_days BETWEEN -25 AND -3 THEN '1-Timely' /*'PSP COMPLETED PRIOR TO (2 BUSINESS DAYS PRIOR TO END OF MONTH)'*/
                                                                                                                                           WHEN psp_business_days BETWEEN -2 AND 60 THEN '2-Late' /*'PSP COMPLETED SUBSEQUENT TO (2 BUSINESS DAYS PRIOR TO END OF MONTH)'*/
                                                                                                                                                                                                 WHEN psp_business_days <= -26 THEN '3-Too Early' /*'PSP NOT DONE (WITHIN REASONABLE TIME FRAME)'*/
                                                                                                                                                                                                                                                 WHEN psp_business_days > 61 THEN '4-Too Late' /*'PSP NOT DONE (WITHIN REASONABLE TIME FRAME)'*/
                                                                                                                                                                                                                                                                                              ELSE '5-Not Done' /*'PSP NOT DONE'*/
                                                                                                                                                                                                                                                                                                               END AS psp_category
                      FROM   (SELECT A.*,
                                     UPPER(SCPT_ACTIVITY_STATUS) AS PSP_STATUS,
                                     CASE
                                         WHEN LAST_DAY(A.ENROLLMENT_DATE) < B.END_DATE THEN
                                             (TRUNC(B.END_DATE) - TRUNC(LAST_DAY(A.ENROLLMENT_DATE))) + 1 - ((((TRUNC( B.END_DATE, 'D')) - (TRUNC( LAST_DAY(A.ENROLLMENT_DATE), 'D'))) / 7) * 2) - (
                                             CASE
                                                 WHEN TO_CHAR                                                                                                                                       ( LAST_DAY(A.ENROLLMENT_DATE), 'DY', 'nls_date_language=english')
                                             = 'SUN' THEN
                                                 1
                                                 ELSE
                                                 0
                                             END) - (CASE WHEN TO_CHAR( B.END_DATE, 'DY', 'nls_date_language=english') = 'SAT' THEN 1 ELSE 0 END)
                                         WHEN LAST_DAY(A.ENROLLMENT_DATE) >= B.END_DATE THEN
                                             -((TRUNC(LAST_DAY(A.ENROLLMENT_DATE)) - TRUNC(TRUNC(B.END_DATE))) + 1 - ((((TRUNC( LAST_DAY(A.ENROLLMENT_DATE), 'D')) - (TRUNC( TRUNC(B.END_DATE), 'D')))
                                               / 7) * 2) - (CASE WHEN TO_CHAR( TRUNC(B.END_DATE), 'DY', 'nls_date_language=english') = 'SUN' THEN 1 ELSE 0 END) - (CASE
                                                   WHEN TO_CHAR                                                                                                    ( LAST_DAY(A.ENROLLMENT_DATE), 'DY', 'nls_date_language=english')
                                               = 'SAT' THEN
                                                   1
                                                   ELSE
                                                   0
                                               END))
                                         ELSE
                                             NULL
                                     END
                                         AS PSP_BUSINESS_DAYS,
                                     TRUNC(B.END_DATE) AS PSP_DATE
                              FROM   PCSP2 A LEFT JOIN GC_PSP B ON TRIM(A.SUBSCRIBER_ID) = TRIM(B.UNIQUE_ID) AND UPPER(B.SCPT_FORM_ACTIVITY_STATUS) = 'APPROVED') A),
                 PSP2 AS
                     (SELECT /* + materialize */
                            MEMBER_ID,
                             SUBSCRIBER_ID,
                             DL_LOB_ID,
                             DL_PLAN_SK,
                             PRODUCT_NAME,
                             ENROLLMENT_DATE,
                             DISENROLLMENT_DATE,
                             ACTIVE_IND,
                             TEAM_MANAGER_NAME,
                             CARE_MANAGER_NAME,
                             PCSP_CREATED_BY,
                             PSP_BUSINESS_DAYS,
                             PSP_CATEGORY,
                             PSP_STATUS,
                             PSP_DATE,
                             PCSP_CATEGORY,
                             PCSP_CREATED_ON,
                             DOCUMENT_ID,
                             DOCUMENT,
                             DOCUMENT_TYPE,
                             CASE WHEN psp_category IN ('1-Timely') THEN 1 WHEN psp_category IN ('2-Late') THEN 2 ELSE 0 END AS PSP_EASIER_INDEX
                      FROM   (SELECT a.*, ROW_NUMBER() OVER (PARTITION BY member_id, subscriber_id, dl_lob_id, enrollment_date, disenrollment_date ORDER BY CASE WHEN psp_category IN ('1-Timely') THEN 1 WHEN PSP_CATEGORY IN ('2-Late') THEN 2 ELSE 3 END ASC, ABS(psp_business_days) ASC) AS rn
                              FROM   PSP1 A)
                      WHERE  RN = 1)
            SELECT *
            FROM   PSP2);


GRANT SELECT ON V_PCSP_ENROLL TO MICHAEL_K;
