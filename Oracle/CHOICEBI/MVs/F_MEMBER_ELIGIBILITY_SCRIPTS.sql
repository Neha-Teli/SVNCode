DROP MATERIALIZED VIEW F_MEMBER_ELIGIBILITY_SCRIPTS

CREATE MATERIALIZED VIEW F_MEMBER_ELIGIBILITY_SCRIPTS
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
NEXT TRUNC(SYSDATE) + 1   
WITH PRIMARY KEY
AS 
WITH elig_scripts AS
         (SELECT /*+ parallel(2) */ p.patient_id,
                 p.unique_id subscriber_id,
                 a1.script_run_log_id,
                 a1.script_run_log_detail_id,
                 a1.created_on,
                 a.start_date,
                 a.end_date,
                 a1.script_id,
                 dim1.script_name,
                 a1.question_id,
                 dim2.question,
                 q.question_response_id,
                 q.question_option_id,
                 q.option_value,
                 q.sub_option_id,
                 q.sub_option_value,
                 CASE
                     WHEN dim2.question IN
                              ('Program Eligibility', 'Program Eligibility:') THEN
                         q.option_value
                     WHEN dim2.question IN ('MLTC Eligibility') THEN
                         'MLTC'
                 END
                     AS line_of_business,
                 ROW_NUMBER()
                 OVER (
                     PARTITION BY p.patient_id, TO_CHAR(a.end_date, 'yyyymm')
                     ORDER BY a.end_date DESC)
                     AS Elig_Script_Month_Seq,
                 CASE
                     WHEN q.question_option_id IN (7496, 7680) THEN
                         ROW_NUMBER()
                         OVER (
                             PARTITION BY p.patient_id,
                                          TO_CHAR(a.end_date, 'yyyymm'),
                                          CASE
                                              WHEN q.question_option_id IN
                                                       (7496, 7680) THEN
                                                  1
                                              ELSE
                                                  0
                                          END
                             ORDER BY a.end_date DESC)
                 END
                     AS Elig_Recv_Script_Month_Seq
          FROM   cmgc.scpt_patient_script_run_log a
                 JOIN (SELECT patient_id,
                              unique_id,
                              deleted_on,
                              deleted_by
                       FROM   CMGC.PATIENT_DETAILS) p
                     ON (p.patient_id = a.patient_id)
                 JOIN cmgc.scpt_pat_script_run_log_det a1
                     ON (a.script_run_log_id = a1.script_run_log_id)
                 LEFT JOIN
                 cmgc.scpt_question_response q
                     ON (q.script_run_log_detail_id =
                             a1.script_run_log_detail_id)
                 LEFT JOIN cmgc.scpt_admin_script dim1
                     ON (dim1.script_id = a1.script_id)
                 LEFT JOIN cmgc.scpt_admin_question dim2
                     ON (dim2.question_id = a1.question_id)
          WHERE      1 = 1
                 AND (   q.sub_option_id IN (6415, 6422, 6429)
                      OR q.question_option_id IN
                             (8666,
                              8667,
                              8668,
                              8909,
                              8910,
                              8911,
                              8889,
                              8890,
                              8891,
                              8869,
                              8870,
                              8871,
                              8846,
                              8847,
                              8848,
                              8646,
                              8647,
                              8648,
                              8586,
                              8587,
                              8588,
                              8566,
                              8567,
                              8568,
                              8606,
                              8607,
                              8608,
                              8826,
                              8827,
                              8828,
                              8806,
                              8807,
                              8808,
                              8786,
                              8787,
                              8788,
                              8766,
                              8767,
                              8768,
                              8746,
                              8747,
                              8748,
                              8546,
                              8547,
                              8548,
                              8626,
                              8627,
                              8628,
                              8726,
                              8727,
                              8728,
                              8706,
                              8707,
                              8708,
                              8526,
                              8527,
                              8528,
                              8506,
                              8507,
                              8508,
                              8686,
                              8687,
                              8688,
                              7496,
                              8486,
                              8487,
                              8488,
                              7636,
                              8466,
                              8467,
                              8468,
                              7680,
                              8446,
                              8447,
                              8448,
                              8220,
                              8221,
                              8222))
                 AND q.deleted_by IS NULL
                 AND q.deleted_on IS NULL
                 AND p.deleted_by IS NULL
                 AND p.deleted_on IS NULL
                 AND a.status_id = 1                               --completed
                                    )
SELECT MRN,
       NVL(s.MONTH_ID, f.month_id) month_id,
       f.lob_id,
       s.PATIENT_ID,
       NVL(s.SUBSCRIBER_ID, f.SUBSCRIBER_ID) SUBSCRIBER_ID,
       NVL(s.line_of_business, f.line_of_business) line_of_business,
       s.SCRIPT_RUN_LOG_ID,
       s.SCRIPT_RUN_LOG_DETAIL_ID,
       s.CREATED_ON,
       s.START_DATE,
       s.END_DATE,
       s.SCRIPT_ID,
       s.SCRIPT_NAME,
       s.QUESTION_ID,
       s.QUESTION,
       s.QUESTION_RESPONSE_ID,
       s.QUESTION_OPTION_ID,
       s.OPTION_VALUE,
       s.SUB_OPTION_ID,
       s.SUB_OPTION_VALUE,
       s.ELIG_SCRIPT_MONTH_SEQ,
       (CASE WHEN s.Elig_Scripts_N >= 1 THEN 1 ELSE 0 END) AS ELIG_SCRIPTS,
       Elig_Recv_Script_Month_Seq,
       DECODE(Elig_Recv_Script_Month_Seq, NULL, 0, 1) ELIG_RECV_SCRIPTS,
       SYSDATE SYS_UPD_TS,
       DL_PLAN_SK,
       PROGRAM
FROM   fact_member_month f
       LEFT JOIN
       (SELECT TO_CHAR(end_date, 'yyyymm') AS Month_Id,
               a.*,
               COUNT(*) OVER (PARTITION BY subscriber_id) Elig_Scripts_N
        FROM   elig_scripts a) s
           ON (    s.subscriber_id = f.subscriber_id
               AND f.month_id = s.month_id
               AND f.Line_of_business = s.line_of_business)
WHERE  f.month_id >= '201601'

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO CHOICEBI_RO;

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO DW_OWNER;

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO MSTRSTG;

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO RESEARCH;

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO ROC_RO;

GRANT SELECT ON F_MEMBER_ELIGIBILITY_SCRIPTS TO SF_CHOICE;
