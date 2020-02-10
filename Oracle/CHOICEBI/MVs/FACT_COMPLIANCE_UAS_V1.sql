DROP MATERIALIZED VIEW FACT_COMPLIANCE_UAS_V1

CREATE MATERIALIZED VIEW FACT_COMPLIANCE_UAS_V1
BUILD IMMEDIATE
REFRESH FORCE
NEXT TRUNC(SYSDATE) + 1    
WITH PRIMARY KEY
AS 
WITH enroll AS
         (SELECT   a.member_id,
                   a.subscriber_id,
                   DENSE_RANK() OVER (PARTITION BY a.member_id ORDER BY mltc_pers_start_dt) AS enroll_seq,
                   mltc_perspective,
                   mltc_pers_start_dt,
                   mltc_pers_end_dt,
                   MIN(COALESCE(cf.referral_date, b.referral_date))
                       OVER (PARTITION BY a.member_id, mltc_pers_start_dt)
                       AS mltc_pers_referral_date,
                   FIVE_lob_perspective,
                   FIVE_lob_start_dt,
                   FIVE_lob_end_dt,
                   COALESCE(cf.referral_date, b.referral_date) AS referral_date,
                   CASE
                       WHEN MIN(COALESCE(cf.referral_date, b.referral_date))
                            OVER (PARTITION BY a.member_id, mltc_pers_start_dt) =
                                COALESCE(cf.referral_date, b.referral_date) THEN
                           COALESCE(cf.referral_date, b.referral_date)
                       ELSE
                           FIVE_lob_start_dt
                   END
                       AS referral_date_v2                     ----TEMPORARY!!
                                          ,
                   CASE
                       WHEN     mltc_pers_start_dt >= '01jul2017'
                            AND FIVE_LOB_PERSPECTIVE = 'MLTC'
                            AND Sub90Rule.Subj90Rule = 'Y' THEN
                           'Y'
                       WHEN     mltc_pers_start_dt >= '01jul2017'
                            AND FIVE_LOB_PERSPECTIVE = 'MLTC'
                            AND Sub90Rule.Subj90Rule IS NULL THEN
                           'N'
                   END
                       AS subj90rule_ind,
                   B.DL_PLAN_SK,
                   B.program
          --    , subj90rule_ind
          FROM     CHOICEBI.FACT_MEMBER_ENROLL_DISENROLL a
                   LEFT JOIN choicebi.FACT_MEMBER_MONTH b
                       ON (a.dl_enroll_id = b.dl_enroll_id)
                   LEFT JOIN
                   (SELECT DISTINCT
                           a.case_num,
                           CASE
                               WHEN UPPER(b.split_text) LIKE '%*9*%' THEN 'Y'
                           END
                               AS subj90rule
                    FROM   dw_owner.choicepre_track_notes a
                           LEFT JOIN dw_owner.choicepre_track_notes_t b
                               ON (a.notes_id = b.notes_id)
                    WHERE  UPPER(split_text) LIKE '%*9*%') Sub90Rule
                       ON (b.case_nbr = Sub90Rule.case_num)
                   LEFT JOIN
                   (SELECT mrn,
                           admission_date,
                           referral_status,
                           referral_date,
                           CASE
                               WHEN program IN ('VCC', 'VCP', 'VCM', 'EVP') THEN
                                   2
                               WHEN program IN ('VCT') THEN
                                   5
                               WHEN program IN ('VCF') THEN
                                   4
                           END
                               AS dl_lob_id
                    FROM   dw_owner.case_facts
                    WHERE      referral_status IN ('A', 'D')
                           AND program IN
                                   ('VCC', 'VCP', 'VCM', 'EVP', 'VCT', 'VCF')) cf
                       ON (    cf.mrn = b.mrn
                           AND cf.admission_date = b.enrollment_date
                           AND cf.dl_lob_id = b.dl_lob_id)
          WHERE    MLTC_PERSPECTIVE = 'MLTC'
          GROUP BY a.member_id,
                   a.subscriber_id,
                   mltc_perspective,
                   mltc_pers_start_dt,
                   mltc_pers_end_dt,
                   FIVE_lob_perspective,
                   FIVE_lob_start_dt,
                   FIVE_lob_end_dt,
                   COALESCE(cf.referral_date, b.referral_date),
                   CASE
                       WHEN     mltc_pers_start_dt >= '01jul2017'
                            AND FIVE_LOB_PERSPECTIVE = 'MLTC'
                            AND Sub90Rule.Subj90Rule = 'Y' THEN
                           'Y'
                       WHEN     mltc_pers_start_dt >= '01jul2017'
                            AND FIVE_LOB_PERSPECTIVE = 'MLTC' THEN
                           'N'
                   END,
                   Sub90Rule.Subj90Rule,
                   B.DL_PLAN_SK,
                   B.PROGRAM),
     assess AS
         (SELECT   member_id,
                   assessmentdate,
                   MAX(dl_assess_sk) AS dl_assess_sk,
                   LAG(
                       TO_DATE(
                           TO_CHAR(ADD_MONTHS(assessmentdate, 6), 'yyyymm'),
                           'yyyymm'))
                   OVER (PARTITION BY member_id ORDER BY assessmentdate)
                       AS DUE_MONTH_FROM_PRIOR,
                   TO_DATE(TO_CHAR(ADD_MONTHS(assessmentdate, 6), 'yyyymm'),
                           'yyyymm')
                       AS NEXT_DUE
          FROM     choice.dim_member_assessments@dlake
          GROUP BY member_id, assessmentdate)
SELECT a.member_id,
       a.subscriber_id,
       enroll_seq,
       mltc_perspective,
       mltc_pers_referral_date,
       mltc_pers_start_dt,
       mltc_pers_end_dt,
       referral_date,
       referral_date_v2,
       FIVE_lob_perspective,
       FIVE_lob_start_dt,
       FIVE_lob_end_dt,
       subj90rule_ind,
       b.assessmentdate,
       b.dl_assess_sk                                     --    , b.assess_seq
                     ,
       b.DUE_MONTH_FROM_PRIOR,
       CASE
           WHEN b.DUE_MONTH_FROM_PRIOR IS NULL THEN
               LAST_VALUE(
                   b.DUE_MONTH_FROM_PRIOR IGNORE NULLS)
               OVER (PARTITION BY a.member_id
                     ORDER BY five_lob_start_dt, assessmentdate)
           ELSE
               b.DUE_MONTH_FROM_PRIOR
       END
           AS DUE_MONTH_FROM_PRIOR_V1,
       b.NEXT_DUE,
       CASE
           WHEN b.next_due IS NULL THEN
               LAST_VALUE(
                   b.next_due IGNORE NULLS)
               OVER (PARTITION BY a.member_id
                     ORDER BY five_lob_start_dt, assessmentdate)
           ELSE
               b.NEXT_DUE
       END
           AS NEXT_DUE_V1,
       ROW_NUMBER()
       OVER (PARTITION BY a.member_id, mltc_pers_start_dt
             ORDER BY five_lob_start_dt, assessmentdate)
           AS assess_enroll_seq,
       ROW_NUMBER()
       OVER (PARTITION BY a.member_id, mltc_pers_start_dt
             ORDER BY five_lob_start_dt, assessmentdate DESC)
           AS assess_enroll_seq_desc,
       DENSE_RANK()
       OVER (PARTITION BY a.member_id, mltc_pers_start_dt
             ORDER BY assessmentdate)
           AS assess_enroll_seq_v1,
       dl_plan_sk,
       PROGRAM           
FROM   enroll a
       LEFT JOIN assess b
           ON (    a.member_id = b.member_id
               AND assessmentdate >= referral_date_v2
               AND assessmentdate <= five_lob_end_dt)
WHERE  mltc_pers_end_dt > '01jan2016'

GRANT SELECT ON FACT_COMPLIANCE_UAS_V1 TO CHOICEBI_RO;

GRANT SELECT ON FACT_COMPLIANCE_UAS_V1 TO RESEARCH;
