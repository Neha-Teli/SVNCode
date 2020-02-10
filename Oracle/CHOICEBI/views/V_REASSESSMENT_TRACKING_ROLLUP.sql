DROP VIEW CHOICEBI.V_REASSESSMENT_TRACKING_ROLLUP;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_TRACKING_ROLLUP AS 
    SELECT   Reassessment_list_month,
             CASE
                 WHEN SUBSTR(subscriber_id, 1, 2) = 'V6' THEN 'FIDA'
                 ELSE 'CHOICE'
             END
                 AS Plan,
             COUNT(*) AS Assigned_to_Premier          /*--Measures for Elina*/
                                            ,
               SUM(
                   CASE
                       WHEN attempt1_date < Reassessment_list_month THEN 1
                       ELSE 0
                   END)
             / COUNT(*)
                 AS M1_Attempt1_Timely,
             SUM(Unavailable_ind) / COUNT(*) AS M2_Unavailable,
               SUM(
                   CASE
                       WHEN     unavailable_ind = 0
                            AND assessmentdate <
                                    ADD_MONTHS(Reassessment_list_month, 1) THEN
                           1
                       ELSE
                           0
                   END)
             / SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END)
                 AS M3_UAS_Complete_Timely,
               SUM(CASE
                       WHEN     unavailable_ind = 0
                            AND onursedate = assessmentdate THEN
                           1
                       ELSE
                           0
                   END)
             / SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END)
                 AS M4_UAS_Finalized_Timely,
               SUM(CASE
                       WHEN     unavailable_ind = 0
                            AND (  (  TRUNC(atsp_date)
                                    - TRUNC(assessmentdate)
                                    + 1)
                                 - (  (  (  (TRUNC(atsp_date, 'D'))
                                          - (TRUNC(assessmentdate, 'D')))
                                       / 7)
                                    * 2)
                                 - (CASE
                                        WHEN TO_CHAR(
                                                 assessmentdate,
                                                 'DY',
                                                 'nls_date_language=english') =
                                                 'SUN' THEN
                                            1
                                        ELSE
                                            0
                                    END)
                                 - (CASE
                                        WHEN TO_CHAR(
                                                 atsp_date,
                                                 'DY',
                                                 'nls_date_language=english') =
                                                 'SAT' THEN
                                            1
                                        ELSE
                                            0
                                    END) <= 5) THEN
                           1
                       ELSE
                           0
                   END)
             / SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END)
                 AS M5_ATSP_Timely,
               SUM(CASE
                       WHEN     unavailable_ind = 0
                            AND psp_scpt_activity_status = 'Completed'
                            AND psp_scpt_form_activity_status = 'Approved'
                            AND (  (  TRUNC(psp_end_date)
                                    - TRUNC(assessmentdate)
                                    + 1)
                                 - (  (  (  (TRUNC(psp_end_date, 'D'))
                                          - (TRUNC(assessmentdate, 'D')))
                                       / 7)
                                    * 2)
                                 - (CASE
                                        WHEN TO_CHAR(
                                                 assessmentdate,
                                                 'DY',
                                                 'nls_date_language=english') =
                                                 'SUN' THEN
                                            1
                                        ELSE
                                            0
                                    END)
                                 - (CASE
                                        WHEN TO_CHAR(
                                                 psp_end_date,
                                                 'DY',
                                                 'nls_date_language=english') =
                                                 'SAT' THEN
                                            1
                                        ELSE
                                            0
                                    END) <= 5) THEN
                           1
                       ELSE
                           0
                   END)
             / SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END)
                 AS M6_PSP_Approved_Timely,
               SUM(
                   CASE
                       WHEN     unavailable_ind = 0
                            AND (    assessmentdate IS NOT NULL
                                 AND PSP_Scpt_Form_Activity_Status = 'Approved'
                                 AND ATSP_Date IS NOT NULL)
                            AND (    onursedate <
                                         ADD_MONTHS(Reassessment_list_month, 1)
                                 AND psp_end_date <
                                         ADD_MONTHS(Reassessment_list_month, 1)
                                 AND ATSP_Date <
                                         ADD_MONTHS(Reassessment_list_month, 1)) THEN
                           1
                       ELSE
                           0
                   END)
             / SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END)
                 AS M7_All_Docs_Timely                          /*--Attempts*/
                                      ,
             SUM(CASE WHEN attempt1_date IS NULL THEN 1 ELSE 0 END)
                 AS Attempt1_None,
             SUM(
                 CASE
                     WHEN attempt1_date < Reassessment_list_month THEN 1
                     ELSE 0
                 END)
                 AS Attempt1_Timely,
             SUM(
                 CASE
                     WHEN attempt1_date >= Reassessment_list_month THEN 1
                     ELSE 0
                 END)
                 AS Attempt1_Late                            /*--Unavailable*/
                                 ,
             SUM(Unavailable_ind) AS Unavailable,
             SUM(CASE WHEN unavailable_ind = 0 THEN 1 ELSE 0 END) AS Available /*--UAS Completed*/
                                                                              ,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND assessmentdate IS NULL THEN
                         1
                     ELSE
                         0
                 END)
                 AS UAS_None,
             SUM(
                 CASE
                     WHEN     unavailable_ind = 0
                          AND assessmentdate <
                                  ADD_MONTHS(Reassessment_list_month, 1) THEN
                         1
                     ELSE
                         0
                 END)
                 AS UAS_Complete_Timely,
             SUM(
                 CASE
                     WHEN     unavailable_ind = 0
                          AND assessmentdate >=
                                  ADD_MONTHS(Reassessment_list_month, 1) THEN
                         1
                     ELSE
                         0
                 END)
                 AS UAS_Complete_Late /*--UAS Finalization - same day definition*/
                                     ,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND onursedate = assessmentdate THEN
                         1
                     ELSE
                         0
                 END)
                 AS UAS_Finalized_Timely,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND onursedate > assessmentdate THEN
                         1
                     ELSE
                         0
                 END)
                 AS UAS_Finalized_Late /*--UAS Finalization (OLD Defintion) - 1 business day
                                       --    , sum(case when unavailable_ind=0 and
                                       --             ((TRUNC(onursedate) - TRUNC(assessmentdate) +1) -
                                       --              ((((TRUNC(onursedate,'D'))-(TRUNC(assessmentdate,'D')))/7)*2) -
                                       --              (CASE WHEN TO_CHAR(assessmentdate,'DY','nls_date_language=english')='SUN' THEN 1 ELSE 0 END) -
                                       --              (CASE WHEN TO_CHAR(onursedate,'DY','nls_date_language=english')='SAT' THEN 1 ELSE 0 END) <=1)
                                       --          then 1 else 0 end) as UAS_Finalized_Timely
                                       --ATSP*/
                                      ,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND atsp_date IS NULL THEN
                         1
                     ELSE
                         0
                 END)
                 AS ATSP_None,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND (  (TRUNC(atsp_date) - TRUNC(assessmentdate) + 1)
                               - (  (  (  (TRUNC(atsp_date, 'D'))
                                        - (TRUNC(assessmentdate, 'D')))
                                     / 7)
                                  * 2)
                               - (CASE
                                      WHEN TO_CHAR(assessmentdate,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SUN' THEN
                                          1
                                      ELSE
                                          0
                                  END)
                               - (CASE
                                      WHEN TO_CHAR(atsp_date,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SAT' THEN
                                          1
                                      ELSE
                                          0
                                  END) <= 5) THEN
                         1
                     ELSE
                         0
                 END)
                 AS ATSP_Timely,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND (  (TRUNC(atsp_date) - TRUNC(assessmentdate) + 1)
                               - (  (  (  (TRUNC(atsp_date, 'D'))
                                        - (TRUNC(assessmentdate, 'D')))
                                     / 7)
                                  * 2)
                               - (CASE
                                      WHEN TO_CHAR(assessmentdate,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SUN' THEN
                                          1
                                      ELSE
                                          0
                                  END)
                               - (CASE
                                      WHEN TO_CHAR(atsp_date,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SAT' THEN
                                          1
                                      ELSE
                                          0
                                  END) > 5) THEN
                         1
                     ELSE
                         0
                 END)
                 AS ATSP_Late                                        /*--PSP*/
                             ,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND psp_scpt_activity_status IS NULL THEN
                         1
                     ELSE
                         0
                 END)
                 AS PSP_None,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND psp_scpt_activity_status = 'Pending' THEN
                         1
                     ELSE
                         0
                 END)
                 AS PSP_Pending,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND psp_scpt_activity_status = 'Completed'
                          AND psp_scpt_form_activity_status = 'Denied' THEN
                         1
                     ELSE
                         0
                 END)
                 AS PSP_Denied,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND psp_scpt_activity_status = 'Completed'
                          AND psp_scpt_form_activity_status = 'Approved'
                          AND (  (  TRUNC(psp_end_date)
                                  - TRUNC(assessmentdate)
                                  + 1)
                               - (  (  (  (TRUNC(psp_end_date, 'D'))
                                        - (TRUNC(assessmentdate, 'D')))
                                     / 7)
                                  * 2)
                               - (CASE
                                      WHEN TO_CHAR(assessmentdate,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SUN' THEN
                                          1
                                      ELSE
                                          0
                                  END)
                               - (CASE
                                      WHEN TO_CHAR(psp_end_date,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SAT' THEN
                                          1
                                      ELSE
                                          0
                                  END) <= 5) THEN
                         1
                     ELSE
                         0
                 END)
                 AS PSP_Approved_Timely,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND psp_scpt_activity_status = 'Completed'
                          AND psp_scpt_form_activity_status = 'Approved'
                          AND (  (  TRUNC(psp_end_date)
                                  - TRUNC(assessmentdate)
                                  + 1)
                               - (  (  (  (TRUNC(psp_end_date, 'D'))
                                        - (TRUNC(assessmentdate, 'D')))
                                     / 7)
                                  * 2)
                               - (CASE
                                      WHEN TO_CHAR(assessmentdate,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SUN' THEN
                                          1
                                      ELSE
                                          0
                                  END)
                               - (CASE
                                      WHEN TO_CHAR(psp_end_date,
                                                   'DY',
                                                   'nls_date_language=english') =
                                               'SAT' THEN
                                          1
                                      ELSE
                                          0
                                  END) > 5) THEN
                         1
                     ELSE
                         0
                 END)
                 AS PSP_Approved_Late                          /*-- All Docs*/
                                     ,
             SUM(CASE
                     WHEN     unavailable_ind = 0
                          AND (    assessmentdate IS NOT NULL
                               AND PSP_Scpt_Form_Activity_Status = 'Approved'
                               AND ATSP_Date IS NOT NULL) THEN
                         1
                     ELSE
                         0
                 END)
                 AS All_Docs_Completed,
             SUM(
                 CASE
                     WHEN     unavailable_ind = 0
                          AND (    assessmentdate IS NOT NULL
                               AND PSP_Scpt_Form_Activity_Status = 'Approved'
                               AND ATSP_Date IS NOT NULL)
                          AND (    onursedate <
                                       ADD_MONTHS(Reassessment_list_month, 1)
                               AND psp_end_date <
                                       ADD_MONTHS(Reassessment_list_month, 1)
                               AND ATSP_Date <
                                       ADD_MONTHS(Reassessment_list_month, 1)) THEN
                         1
                     ELSE
                         0
                 END)
                 AS All_Docs_Timely,
             SUM(
                 CASE
                     WHEN     unavailable_ind = 0
                          AND (    assessmentdate IS NOT NULL
                               AND PSP_Scpt_Form_Activity_Status = 'Approved'
                               AND ATSP_Date IS NOT NULL)
                          AND (   onursedate >=
                                      ADD_MONTHS(Reassessment_list_month, 1)
                               OR psp_end_date >=
                                      ADD_MONTHS(Reassessment_list_month, 1)
                               OR ATSP_Date >=
                                      ADD_MONTHS(Reassessment_list_month, 1)) THEN
                         1
                     ELSE
                         0
                 END)
                 AS All_Docs_Late
    FROM     F_REASSESSMENT_TRACKING
    GROUP BY CASE
                 WHEN SUBSTR(subscriber_id, 1, 2) = 'V6' THEN 'FIDA'
                 ELSE 'CHOICE'
             END,
             Reassessment_list_month
    ORDER BY CASE
                 WHEN SUBSTR(subscriber_id, 1, 2) = 'V6' THEN 'FIDA'
                 ELSE 'CHOICE'
             END,
             Reassessment_list_month;

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_TRACKING_ROLLUP TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_TRACKING_ROLLUP TO RIPUL_P ;
