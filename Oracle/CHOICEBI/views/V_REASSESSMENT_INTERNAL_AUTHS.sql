DROP VIEW CHOICEBI.V_REASSESSMENT_INTERNAL_AUTHS;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_INTERNAL_AUTHS
AS
    (SELECT   reassessment_list_month,line_of_business,
                SUM(all_docs_nosnf)
              - SUM(
                    CASE
                        WHEN all_docs_nosnf = 1 THEN unavailable_ind_svc
                        ELSE 0
                    END)
                  AS available_for_svcplan,
              SUM(svcplan_created) AS svcplan_created_total,
              SUM(CASE WHEN all_docs_nosnf = 1 THEN svcplan_created ELSE 0 END)
                  AS alldocs_svcplan_created,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND svcplan_created = 1
                           AND baseline_hrs IS NULL THEN
                          1
                      ELSE
                          0
                  END)
                  AS nobaseOPS,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND svcplan_created = 1
                           AND umcat = '1-Reduced' THEN
                          1
                      ELSE
                          0
                  END)
                  AS um_decrease,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND svcplan_created = 1
                           AND umcat = '2-Same' THEN
                          1
                      ELSE
                          0
                  END)
                  AS um_same,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND svcplan_created = 1
                           AND umcat = '3-Increased' THEN
                          1
                      ELSE
                          0
                  END)
                  AS um_increase,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND svcplan_created = 1
                           AND baseline_hrs IS NOT NULL
                           AND psp_approved_units_num IS NOT NULL
                           AND endpoint_hrs IS NOT NULL THEN
                          1
                      ELSE
                          0
                  END)
                  AS complete_info
     FROM     F_REASSESSMENT_ORDER_HISTORY
     GROUP BY reassessment_list_month,line_of_business)
    UNION
    (SELECT reassessment_list_month,'MLTC' plan,
            available_for_svcplan,
            svcplan_created_total,
            alldocs_svcplan_created,
            nobaseOPS,
            um_decrease,
            um_same,
            um_increase,
            complete_info
     FROM   jan2016_counts);

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_INTERNAL_AUTHS TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_INTERNAL_AUTHS TO RIPUL_P ;
