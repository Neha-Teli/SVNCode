DROP VIEW CHOICEBI.FACT_COMPLIANCE_UAS_INITIALS;

CREATE TABLE CHOICEBI.FACT_COMPLIANCE_UAS_INITIALS
AS
    SELECT   MEMBER_ID,
             ENROLL_SEQ,
             SUBJ90RULE_IND,
             MLTC_PERS_REFERRAL_DATE,
             MLTC_PERS_START_DT,
             MLTC_PERS_END_DT,
             REFERRAL_DATE_V2 AS REFERRAL_DATE,
             FIVE_LOB_PERSPECTIVE,
             FIVE_LOB_START_DT,
             FIVE_LOB_END_DT,
             NEXT_DUE_V5 AS NEXT_DUE,
             ASSESSMENT_TYPE,
             DUE_FROM,
             DUE_TO,
             ASSESSMENTDATE,
             CASE
                 WHEN ASSESSMENTDATE < DUE_FROM THEN 'EARLY'
                 WHEN ASSESSMENTDATE BETWEEN DUE_FROM AND DUE_TO THEN 'TIMELY'
                 WHEN ASSESSMENTDATE > DUE_TO THEN 'LATE'
                 WHEN ASSESSMENTDATE IS NOT NULL THEN 'UNK'
                 ELSE 'NOT DONE'
             END
                 TIMELY_IND,
             DL_ASSESS_SK,
             ASSESS_ENROLL_SEQ,
             ASSESS_ENROLL_SEQ_V1,
             ASSESS_ENROLL_SEQ_DESC,
             ROW_NUMBER()
             OVER (
                 PARTITION BY MEMBER_ID,
                              MLTC_PERS_START_DT,
                              ASSESSMENT_TYPE,
                              DUE_FROM,
                              DUE_TO
                 ORDER BY ASSESSMENTDATE, FIVE_LOB_START_DT DESC)
                 AS METRIC_SEQ,
             ROW_NUMBER()
             OVER (PARTITION BY MEMBER_ID, MLTC_PERS_START_DT, NEXT_DUE_V5
                   ORDER BY FIVE_LOB_START_DT DESC)
                 AS METRIC_REASSESS_SEQ,
           1 flag,
           sysdate SYS_UPD_TS
    FROM     FACT_COMPLIANCE_UAS_V2 a
    ORDER BY member_id,
             mltc_pers_start_dt,
             FIVE_lob_start_dt,
             assessmentdate;

grant select on FACT_COMPLIANCE_UAS_INITIALS to mstrstg