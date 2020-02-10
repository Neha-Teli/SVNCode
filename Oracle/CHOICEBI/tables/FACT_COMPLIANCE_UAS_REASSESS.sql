DROP VIEW CHOICEBI.FACT_COMPLIANCE_UAS_REASSESS;

CREATE TABLE CHOICEBI.FACT_COMPLIANCE_UAS_REASSESS
 AS
    WITH reassess_list AS
             (SELECT member_id,
                     mltc_pers_start_dt,
                     mltc_pers_end_dt,
                     FIVE_lob_perspective,
                     FIVE_lob_start_dt,
                     FIVE_lob_end_dt,
                     next_due
              FROM   fact_compliance_uas_initials
              WHERE      next_due IS NOT NULL
                     AND metric_reassess_seq = 1),
         reassess2 AS
             (SELECT member_id,
                     due_from,
                     due_to,
                     assessmentdate,
                     timely_ind
              FROM   fact_compliance_uas_initials
              WHERE  metric_seq = 1)
    SELECT a."MEMBER_ID",
           a."MLTC_PERS_START_DT",
           a."MLTC_PERS_END_DT",
           a."FIVE_LOB_PERSPECTIVE",
           a."FIVE_LOB_START_DT",
           a."FIVE_LOB_END_DT",
           a."NEXT_DUE",
           due_from,
           due_to,
           assessmentdate,
           NVL(b.timely_ind, 'NOT DONE') AS timely_ind,
           1 flag,
           sysdate SYS_UPD_TS
    FROM   reassess_list a
           LEFT JOIN reassess2 b
               ON (    a.member_id = b.member_id
                   AND a.next_due = b.due_from);

grant select on FACT_COMPLIANCE_UAS_REASSESS to mstrstg