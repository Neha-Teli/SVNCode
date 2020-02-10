DROP VIEW CHOICEBI.V_REASSESSMENT_AGG_COUNTS;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_AGG_COUNTS
AS
    SELECT   reassessment_list_month,
             LINE_OF_BUSINESS,
             COUNT(1) AS assigned_to_premier,
             COUNT(1) - SUM(unavailable_ind) AS available_prmr,
             SUM(psp_approved_units_invalid) AS PSP_hrs_invalid,
             SUM(all_docs_completed) AS all_docs_completed,
             SUM(all_docs_nosnf) AS all_docs_no_SNF,
               SUM(all_docs_nosnf)
             - SUM(
                   CASE
                       WHEN all_docs_nosnf = 1 THEN unavailable_ind_svc
                       ELSE 0
                   END)
                 AS available_for_svcplan,
             SUM(svcplan_created) AS svcplan_created,
             SUM(svcplan_closed) AS svcplan_closed,
             SUM(svcplan_created_prmr_complete)
                 AS svcplan_created_prmr_complete,
             SUM(svcplan_closed_prmr_complete) AS svcplan_closed_prmr_complete,
             SUM(hha_variance_activity) AS hha_variance_activity,
             SUM(contractadmin_req_activity) AS contractadmin_req_activity,
             SUM(ops_updated_activity) AS ops_updated_activity
    FROM     F_REASSESSMENT_TRACKING
    GROUP BY reassessment_list_month, LINE_OF_BUSINESS
    ORDER BY reassessment_list_month;

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_AGG_COUNTS TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_AGG_COUNTS TO RIPUL_P ;
