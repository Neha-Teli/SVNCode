DROP MATERIALIZED VIEW CHOICEBI.F_ASSESSMENT_TIMELINESS;

CREATE MATERIALIZED VIEW CHOICEBI.F_ASSESSMENT_TIMELINESS 
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
WITH compliance_measure AS
(
    SELECT f.line_of_business,
                 f.lob_id,
                 f.mrn,
                 f.subscriber_id,
                 f.medicaid_num,
                 f.referral_date,
                 f.enrollment_date,
                 f.disenrollment_date,
                 f.dl_member_sk,
                 f.member_id,
                 f.dl_enroll_id,
                 f.dl_enrl_sk,                           
                 NVL(m.mandatory_enrollment, 'N') mandatory_enrollment,
                 u.assessmentdate,
                 u.record_id,
                 --ROW_NUMBER() OVER (PARTITION BY f.mrn, f.subscriber_id, f.enrollment_date ORDER BY u.assessmentdate) AS assess_seq,
                 --ROW_NUMBER() OVER (PARTITION BY f.mrn, f.subscriber_id, f.enrollment_date ORDER BY u.assessmentdate DESC) AS assess_seq_desc,
                 ROW_NUMBER() OVER (PARTITION BY f.member_id, f.enrollment_date ORDER BY u.assessmentdate) AS assess_seq,
                 ROW_NUMBER() OVER (PARTITION BY f.member_id, f.enrollment_date ORDER BY u.assessmentdate DESC) AS assess_seq_desc,
                 CASE
                     WHEN     u.assessmentdate IS NULL AND f.enrollment_date >= '01OCT2013' AND ADD_MONTHS(enrollment_date, 6) <= f.disenrollment_date THEN
                         ADD_MONTHS(enrollment_date, 6) --assuming next due is 6 months from enrollment??
                     WHEN     u.assessmentdate IS NULL AND f.enrollment_date >= '01OCT2013' AND ADD_MONTHS(enrollment_date, 6) > f.disenrollment_date THEN
                         NULL
                     WHEN     u.assessmentdate IS NULL AND f.enrollment_date < '01OCT2013' THEN
                         NULL
                     WHEN TO_DATE( TO_CHAR(ADD_MONTHS(assessmentdate, 6), 'yyyymm'), 'yyyymm') <= f.disenrollment_date THEN
                          TO_DATE( TO_CHAR(ADD_MONTHS(assessmentdate, 6), 'yyyymm'), 'yyyymm')
                     WHEN TO_DATE( TO_CHAR(ADD_MONTHS(assessmentdate, 6), 'yyyymm'), 'yyyymm') > f.disenrollment_date THEN
                         NULL
                 END AS NEXT_DUE
          FROM   (SELECT   mrn,
                           subscriber_id,
                           medicaid_num,
                           enrollment_date,
                           DISENROLLMENT_DATE,
                           referral_date,
                           case_nbr case_num,
                           line_of_business,
                           dl_lob_id lob_id,
                           dl_member_sk,
                           member_id,
                           dl_enroll_id,
                           dl_enrl_sk,                           
                           MAX(month_id) AS Month_id
                  FROM     v_fact_member_month_exp
                  WHERE    LINE_OF_BUSINESS IN ('MLTC', 'FIDA')
                  GROUP BY mrn,
                           subscriber_id,
                           medicaid_num,
                           enrollment_date,
                           DISENROLLMENT_DATE,
                           referral_date,
                           case_nbr,
                           dl_lob_id,
                           line_of_business,
                           dl_member_sk,
                           member_id,
                           dl_enroll_id,
                           dl_enrl_sk) f
                 LEFT JOIN
                 (SELECT medicaidnumber1,
                         assessmentdate,
                         record_id,
                         ROW_NUMBER()
                         OVER (PARTITION BY medicaidnumber1, assessmentdate
                               ORDER BY record_id DESC)
                             AS assess_seq
                  FROM   dw_owner.uas_pat_assessments) u
                     ON (    u.medicaidnumber1 = f.medicaid_num
                         AND u.assessmentdate BETWEEN f.referral_date
                                                  AND f.disenrollment_date
                         AND u.assess_seq = 1)
                 LEFT JOIN
                 (SELECT  /*+ cardinality(a11 4000000) */ a13.LABEL_TEXT LABEL_TEXT,
                           a13.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                           a13.ITEM_VALUE ITEM_VALUE,
                           a11.CASE_NUM CASE_NUM,
                           SUM(a11.FLAG) WJXBFS1,
                           'Y' mandatory_enrollment
                  FROM     MS_OWNER.FACT_CASE_REFERRAL@MS_OWNER_RCPROD a11
                           JOIN
                           (SELECT CASE_NUM CASE_NUM, CONTACT_SOURCE ITEM_VALUE
                            FROM   DW_OWNER.CHOICEPRE_CASE_LVL_INFO) a12
                               ON (a11.CASE_NUM = a12.CASE_NUM)
                           JOIN
                           (SELECT a01.LABEL_TEXT LABEL_TEXT,
                                   a01.LOOKUP_ITEM_ID LOOKUP_ITEM_ID,
                                   a01.ITEM_VALUE ITEM_VALUE
                            FROM   (SELECT LOOKUP_ITEM_ID,
                                           ITEM_VALUE,
                                           LABEL_TEXT,
                                           LOOKUP_GROUP_ID
                                    FROM   DW_OWNER.CHOICEPRE_LOOKUP_ITEM
                                    WHERE  LOOKUP_GROUP_ID IN (50, 51, 52)) a01
                            WHERE  UPPER(label_text) LIKE '%MAND%') a13
                               ON (a12.ITEM_VALUE = a13.ITEM_VALUE)
                  GROUP BY a13.LABEL_TEXT,
                           a13.LOOKUP_ITEM_ID,
                           a13.ITEM_VALUE,
                           a11.CASE_NUM) m
                     ON (m.case_num = f.case_num))
SELECT a.*,
       CASE
           WHEN     enrollment_date >= '01OCT2013'
                AND (   assessmentdate IS NULL
                     OR assess_seq = 1) THEN
               'INITIAL'
           WHEN     enrollment_date < '01OCT2013'
                AND assess_seq = 1 THEN
               'REASSESSMENT' --Do we want to identify non-initial first assessments?
           ELSE
               'REASSESSMENT'
       END
           AS Assessment_Type,
       CASE
           WHEN assessmentdate IS NULL THEN
               NULL
           WHEN assess_seq_desc = 1 THEN
               'Most Recent'
           WHEN assess_seq = 1 THEN
               'First'
           ELSE
               'Prior ' ||
               TO_CHAR(assess_seq_desc - 1)
       END
           AS Assessment_Seq,
       CASE
           WHEN     assess_seq = 1
                AND enrollment_date >= '01OCT2013'
                AND mandatory_enrollment = 'Y' THEN
               enrollment_date --for mandatories - due date based on enrollment date
           WHEN     assess_seq = 1
                AND enrollment_date >= '01OCT2013' THEN
               referral_date --for non-mandatories - due date based on referral
           WHEN     assess_seq = 1
                AND enrollment_date < '01OCT2013' THEN
               NULL
           --WHEN TO_DATE(TO_CHAR(ADD_MONTHS( LAG( assessmentdate) OVER ( PARTITION BY mrn, subscriber_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm') <= disenrollment_date THEN
           WHEN TO_DATE(TO_CHAR(ADD_MONTHS( LAG( assessmentdate) OVER ( PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm') <= disenrollment_date THEN
                        TO_DATE( TO_CHAR( ADD_MONTHS( LAG( assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm')
           WHEN TO_DATE(
                    TO_CHAR(
                        ADD_MONTHS(
                            LAG(
                                assessmentdate)
                            OVER (
                                PARTITION BY member_id,
                                             enrollment_date
                                ORDER BY assessmentdate),
                            6),
                        'yyyymm'),
                    'yyyymm') > disenrollment_date THEN
               NULL
       END
           AS Due_Date_From,
       CASE
           WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' AND mandatory_enrollment = 'Y' THEN
               enrollment_date + 30 --for mandatories - due date based on enrollment date
           WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' THEN
               referral_date + 30 --for non-mandatories - due date based on referral
           WHEN     assess_seq = 1 AND enrollment_date < '01OCT2013' THEN
               NULL
           WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm') <= disenrollment_date THEN
                TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 7), 'yyyymm'), 'yyyymm') - 1
           WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm') > disenrollment_date THEN
               NULL
       END
           AS Due_Date_To,
         assessmentdate
       - (CASE
              WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' AND mandatory_enrollment = 'Y' THEN
                  enrollment_date --for mandatories - due date based on enrollment date
              WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' THEN
                  referral_date --for non-mandatories - due date based on referral
              WHEN     assess_seq = 1 AND enrollment_date < '01OCT2013' THEN
                  NULL
              WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id,enrollment_date ORDER BY assessmentdate),6),'yyyymm'), 'yyyymm') <= disenrollment_date THEN
                   TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id,enrollment_date ORDER BY assessmentdate),6),'yyyymm'), 'yyyymm')
              WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id,enrollment_date ORDER BY assessmentdate),6),'yyyymm'), 'yyyymm') > disenrollment_date THEN
                   NULL
          END)
           AS days_from_due,
       CASE
           WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6), 'yyyymm'), 'yyyymm') > disenrollment_date THEN
               NULL
           WHEN   assessmentdate
                - (CASE
                       WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' AND mandatory_enrollment = 'Y' THEN
                           enrollment_date --for mandatories - due date based on enrollment date
                       WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' THEN
                           referral_date --for non-mandatories - due date based on referral
                       WHEN     assess_seq = 1 AND enrollment_date < '01OCT2013' THEN
                           NULL
                       ELSE
                           TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6),'yyyymm'),'yyyymm')
                   END) < 0 THEN
               'EARLY'
           WHEN assessmentdate BETWEEN (CASE
                                            WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' AND mandatory_enrollment = 'Y' THEN
                                                enrollment_date --for mandatories - due date based on enrollment date
                                            WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' THEN 
                                                referral_date --for non-mandatories - due date based on referral
                                            WHEN     assess_seq = 1 AND enrollment_date < '01OCT2013' THEN
                                                NULL
                                            ELSE
                                                TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate) OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 6),'yyyymm'),'yyyymm')
                                        END)
                                   AND (CASE
                                            WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' AND mandatory_enrollment = 'Y' THEN
                                                enrollment_date + 30 --for mandatories - due date based on enrollment date
                                            WHEN     assess_seq = 1 AND enrollment_date >= '01OCT2013' THEN
                                                referral_date + 30 --for non-mandatories - due date based on referral
                                            WHEN     assess_seq = 1 AND enrollment_date < '01OCT2013' THEN
                                                NULL
                                            ELSE 
                                                TO_DATE(TO_CHAR(ADD_MONTHS(LAG(assessmentdate)OVER (PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 7), 'yyyymm'), 'yyyymm') - 1
                                        END) THEN
               'TIMELY'
           WHEN assessmentdate >
                    (CASE
                         WHEN     assess_seq = 1
                              AND enrollment_date >= '01OCT2013'
                              AND mandatory_enrollment = 'Y' THEN
                             enrollment_date + 30 --for mandatories - due date based on enrollment date
                         WHEN     assess_seq = 1
                              AND enrollment_date >= '01OCT2013' THEN
                             referral_date + 30 --for non-mandatories - due date based on referral
                         WHEN     assess_seq = 1
                              AND enrollment_date < '01OCT2013' THEN
                             NULL
                         ELSE
                               TO_DATE(TO_CHAR(ADD_MONTHS(LAG( assessmentdate) OVER ( PARTITION BY member_id, enrollment_date ORDER BY assessmentdate), 7), 'yyyymm'), 'yyyymm') - 1
                     END) THEN
               'LATE'
       END
           AS Timely_Ind,
       1 flag,
       SYSDATE SYS_UPD_TS
FROM   
    compliance_measure a;

COMMENT ON MATERIALIZED VIEW CHOICEBI.F_ASSESSMENT_TIMELINESS IS 'snapshot table for snapshot CHOICEBI.F_ASSESSMENT_TIMELINESS';

GRANT SELECT ON CHOICEBI.F_ASSESSMENT_TIMELINESS TO DW_OWNER;

GRANT SELECT ON CHOICEBI.F_ASSESSMENT_TIMELINESS TO MSTRSTG;
