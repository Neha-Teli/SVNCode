DROP VIEW FACT_COMPLIANCE_UAS_V2;

CREATE OR REPLACE VIEW FACT_COMPLIANCE_UAS_V2
(
    MEMBER_ID,
    SUBSCRIBER_ID,
    ENROLL_SEQ,
    SUBJ90RULE_IND,
    MLTC_PERS_REFERRAL_DATE,
    MLTC_PERS_START_DT,
    MLTC_PERS_END_DT,
    REFERRAL_DATE,
    REFERRAL_DATE_V2,
    FIVE_LOB_PERSPECTIVE,
    FIVE_LOB_START_DT,
    FIVE_LOB_END_DT,
    DL_ASSESS_SK,
    DUE_MONTH_FROM_PRIOR,
    DUE_MONTH_FROM_PRIOR_V1,
    NEXT_DUE,
    NEXT_DUE_V1,
    NEXT_DUE_V5,
    ASSESS_ENROLL_SEQ,
    ASSESS_ENROLL_SEQ_V1,
    ASSESS_ENROLL_SEQ_DESC,
    DUE_FROM,
    DUE_TO,
    ASSESSMENT_TYPE,
    ASSESSMENTDATE,
    DL_PLAN_SK,
    PROGRAM    
) AS
    WITH a AS
             (SELECT b.*,
                     CASE
                         WHEN     next_due_v1 IS NOT NULL
                              AND next_due_v1 < mltc_pers_end_dt THEN
                             next_due_v1
                     END
                         AS next_due_v5
              FROM   FACT_COMPLIANCE_UAS_V1 b)
    SELECT member_id,
           SUBSCRIBER_ID,
           enroll_seq                                 --    , mltc_perspective
                     ,
           subj90rule_ind,
           mltc_pers_referral_date,
           mltc_pers_start_dt,
           mltc_pers_end_dt,
           referral_date,
           referral_date_v2,
           FIVE_lob_perspective,
           FIVE_lob_start_dt,
           FIVE_lob_end_dt,
           dl_assess_sk,
           DUE_MONTH_FROM_PRIOR,
           DUE_MONTH_FROM_PRIOR_v1,
           NEXT_DUE,
           NEXT_DUE_V1,
           NEXT_DUE_V5,
           assess_enroll_seq,
           assess_enroll_seq_v1,
           assess_enroll_seq_desc,
           CASE
               WHEN     assess_enroll_seq_v1 = 1
                    AND mltc_pers_start_dt < '01OCT2013' THEN
                   NULL
               WHEN     assess_enroll_seq_v1 = 1
                    AND GREATEST(NVL(DUE_MONTH_FROM_PRIOR_v1, '01jan1099'),
                                 mltc_pers_referral_date) =
                            mltc_pers_referral_date
                    AND (   subj90rule_ind = 'N'
                         OR subj90rule_ind IS NULL) THEN
                   mltc_pers_referral_date
               WHEN     assess_enroll_seq_v1 = 1
                    AND GREATEST(NVL(DUE_MONTH_FROM_PRIOR_v1, '01jan1099'),
                                 mltc_pers_referral_date) =
                            mltc_pers_referral_date
                    AND subj90rule_ind = 'Y' THEN
                   mltc_pers_start_dt
               ELSE
                   DUE_MONTH_FROM_PRIOR_v1
           END
               AS DUE_FROM,
           CASE
               WHEN     assess_enroll_seq_v1 = 1
                    AND mltc_pers_start_dt < '01OCT2013' THEN
                   NULL
               WHEN     assess_enroll_seq_v1 = 1
                    AND GREATEST(NVL(DUE_MONTH_FROM_PRIOR_v1, '01jan1099'),
                                 mltc_pers_referral_date) =
                            mltc_pers_referral_date
                    AND (   subj90rule_ind = 'N'
                         OR subj90rule_ind IS NULL) THEN
                   mltc_pers_referral_date + 30
               WHEN     assess_enroll_seq_v1 = 1
                    AND GREATEST(NVL(DUE_MONTH_FROM_PRIOR_v1, '01jan1099'),
                                 mltc_pers_referral_date) =
                            mltc_pers_referral_date
                    AND subj90rule_ind = 'Y' THEN
                   mltc_pers_start_dt + 30
               ELSE
                     ADD_MONTHS(
                         (CASE
                              WHEN assess_enroll_seq_v1 = 1 THEN
                                  GREATEST(
                                      NVL(DUE_MONTH_FROM_PRIOR, '01jan1099'),
                                      mltc_pers_referral_date)
                              ELSE
                                  DUE_MONTH_FROM_PRIOR_v1
                          END),
                         1)
                   - 1
           END
               AS DUE_TO,
           CASE
               WHEN     mltc_pers_start_dt > '01OCT2013'
                    AND assess_enroll_seq_v1 = 1
                    --            and nvl(DUE_MONTH_FROM_PRIOR_v1,'01jan1099') != mltc_pers_referral_date
                    AND GREATEST(NVL(DUE_MONTH_FROM_PRIOR_v1, '01jan1099'),
                                 mltc_pers_referral_date) =
                            mltc_pers_referral_date THEN
                   'INITIAL'
               ELSE
                   'REASSESSMENT'
           END
               AS Assessment_type,
           assessmentdate,
           dl_PLAN_SK,
           PROGRAM           
    FROM   a
