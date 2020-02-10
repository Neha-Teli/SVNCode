DROP TABLE CHOICEBI.FACT_CARE_MANAGER_MONTHLY_CALL;

CREATE TABLE CHOICEBI.FACT_CARE_MANAGER_MONTHLY_CALL
(
    SUBSCRIBER_ID            VARCHAR2 (9),
    DL_LOB_ID                NUMBER ,
    COUNTY                   VARCHAR2 (20),
    MONTH_ID                 NUMBER ,
    DL_MEMBER_SK             NUMBER ,
    MEMBER_ID                NUMBER ,
    DL_PLAN_SK               NUMBER ,
    UNIQUE_ID                VARCHAR2 (200),
    SCRIPT_RUN_LOG_ID        NUMBER (19),
    SCRIPT_RUN_LOG_DETAIL_ID NUMBER (19),
    CREATED_ON               DATE,
    START_DATE               DATE,
    END_DATE                 DATE,
    CM_MONTH_ID              VARCHAR2 (6),
    SCRIPT_ID                NUMBER (19),
    SCRIPT_NAME              VARCHAR2 (4000),
    QUESTION_ID              NUMBER (19),
    QUESTION                 VARCHAR2 (4000),
    QUESTION_RESPONSE_ID     NUMBER (19),
    QUESTION_OPTION_ID       NUMBER (19),
    OPTION_VALUE             VARCHAR2 (4000),
    SUB_OPTION_ID            NUMBER (19),
    SUB_OPTION_VALUE         VARCHAR2 (4000),
    SUCCESSFUL_IND           NUMBER,
    ELIG_SCRIPT_MONTH_SEQ    NUMBER ,
    CONTACTED_N              NUMBER ,
    CONTACTED_SUCCESSFUL_N   NUMBER ,
    CONTACTED_UNSUCCESSFUL_N NUMBER ,
    NOTCONTACTED_N           NUMBER 
) 

insert into FACT_CARE_MANAGER_MONTHLY_CALL
    WITH cm_scripts AS
             (                                       --1) pull scripts details
              SELECT /*+ no_merge materialize driving_site(a) */
                                                               --p.patient_id,
                    p.unique_id,
                    a1.script_run_log_id,
                    a1.script_run_log_detail_id,
                    a1.created_on,
                    a.start_date,
                    a.end_date,
                    TO_CHAR(a.end_date, 'yyyymm') AS cm_month_id,
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
                        WHEN q.question_option_id IN
                                 (4610, 4864, 5109, 5374, 7413, 7497, 7637, 6624 /*FIDA*/
                                                                                ) THEN
                            1
                        ELSE
                            0
                    END
                        AS successful_ind,
                    ROW_NUMBER()
                    OVER (
                        PARTITION BY p.patient_id, TO_CHAR(a.end_date, 'yyyymm')
                        ORDER BY
                            CASE
                                WHEN q.question_option_id IN
                                         (4610,
                                          4864,
                                          5109,
                                          5374,
                                          7413,
                                          7497,
                                          7637,
                                          6624                        /*FIDA*/
                                              ) THEN
                                    1
                                ELSE
                                    0
                            END DESC,
                            a.end_date)
                        AS Elig_Script_Month_Seq --order by successful indicator
              FROM  cmgc.scpt_patient_script_run_log@nexus2 a
                    JOIN (SELECT patient_id,
                                 unique_id,
                                 deleted_on,
                                 deleted_by
                          FROM   CMGC.PATIENT_DETAILS@nexus2) p
                        ON (p.patient_id = a.patient_id)
                    JOIN cmgc.scpt_pat_script_run_log_det@nexus2 a1
                        ON (a.script_run_log_id = a1.script_run_log_id)
                    LEFT JOIN
                    cmgc.scpt_question_response@nexus2 q
                        ON (q.script_run_log_detail_id =
                                a1.script_run_log_detail_id)
                    LEFT JOIN cmgc.scpt_admin_script@nexus2 dim1
                        ON (dim1.script_id = a1.script_id)
                    LEFT JOIN cmgc.scpt_admin_question@nexus2 dim2
                        ON (dim2.question_id = a1.question_id)
              WHERE     1 = 1
                    AND a1.script_id IN (64, 69, 111, 112, 113, 102   /*FIDA*/
                                                                   )
                    AND a1.question_id IN
                            (2192, 2306, 2389, 2505, 3185, 3212, 3251, 2929 /*FIDA*/
                                                                           )
                    AND q.deleted_by IS NULL
                    AND q.deleted_on IS NULL
                    AND p.deleted_by IS NULL
                    AND p.deleted_on IS NULL
                    AND a.status_id = 1),
         fmm_cm_scripts AS
             ( --2) Join Script details with Fact Member Month at the member-month-level
              SELECT m.subscriber_id,
                     m.dl_lob_id,
                     m.county,
                     m.month_id,
                     M.DL_MEMBER_SK,
                     M.MEMBER_ID,
                     M.DL_PLAN_SK,
                     cm.*
              FROM   choicebi.fact_member_month m
                     LEFT JOIN cm_scripts cm
                         ON (    cm.unique_id = m.subscriber_id
                             AND m.month_id = cm.cm_month_id
                             AND cm.Elig_Script_Month_Seq = 1)
              --If there are multiple scripts in the month, keep successful ones first
              WHERE  m.dl_lob_id IN (2, 5) --and substr(m.month_id,1,4)='2017'
                                          )
    SELECT   a."SUBSCRIBER_ID",
             a."DL_LOB_ID",
             a."COUNTY",
             a."MONTH_ID",
             a."DL_MEMBER_SK",
             a."MEMBER_ID",
             a."DL_PLAN_SK",
             a."UNIQUE_ID",
             a."SCRIPT_RUN_LOG_ID",
             a."SCRIPT_RUN_LOG_DETAIL_ID",
             a."CREATED_ON",
             a."START_DATE",
             a."END_DATE",
             a."CM_MONTH_ID",
             a."SCRIPT_ID",
             a."SCRIPT_NAME",
             a."QUESTION_ID",
             a."QUESTION",
             a."QUESTION_RESPONSE_ID",
             a."QUESTION_OPTION_ID",
             a."OPTION_VALUE",
             a."SUB_OPTION_ID",
             a."SUB_OPTION_VALUE",
             a."SUCCESSFUL_IND",
             a."ELIG_SCRIPT_MONTH_SEQ",
             CASE WHEN script_run_log_id IS NOT NULL THEN 1 ELSE 0 END
                 AS Contacted_N,
             successful_ind AS Contacted_Successful_N,
             CASE WHEN successful_ind = 0 THEN 1 ELSE 0 END
                 AS Contacted_Unsuccessful_N,
             CASE WHEN script_run_log_id IS NULL THEN 1 ELSE 0 END
                 AS Notcontacted_N
    --, successful_ind)/count(*) as Contacted_Successful_Prcnt
    --, case when successful_ind=0 then 1 else 0 end)/count(*) as Contacted_Unsuccessful_Prcnt
    --, case when script_run_log_id is null then 1 else 0 end)/count(*) as Notcontacted_Prcnt
FROM     fmm_cm_scripts a
ORDER BY 
    dl_lob_id, 
    county,         /* comment out to get overall metric */
    month_id;