DROP VIEW CHOICEBI.V_REASSESSMENT_INTERNAL_PRMR;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_INTERNAL_PRMR
AS
    (SELECT   reassessment_list_month,line_of_business,
              COUNT(1) AS total_mbrs,
              COUNT(1) - SUM(unavailable_ind) AS available_for_reassess,
              SUM(all_docs_completed) AS all_docs_completed,
              SUM(CASE WHEN all_docs_nosnf = 1 THEN 1 ELSE 0 END)
                  AS all_docs_no_SNF,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND (   baseline_hrs IS NULL
                                OR psp_approved_units_num IS NULL) THEN
                          1
                      ELSE
                          0
                  END)
                  AS nobaseOPS_PSPinvalid,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND baseline_hrs IS NOT NULL
                           AND prmrcat = '1-Reduced' THEN
                          1
                      ELSE
                          0
                  END)
                  AS prmr_rec_decrease,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND baseline_hrs IS NOT NULL
                           AND prmrcat = '2-Same' THEN
                          1
                      ELSE
                          0
                  END)
                  AS prmr_rec_same,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND baseline_hrs IS NOT NULL
                           AND prmrcat = '3-Increased' THEN
                          1
                      ELSE
                          0
                  END)
                  AS prmr_rec_increase,
              SUM(CASE
                      WHEN     all_docs_nosnf = 1
                           AND psp_approved_units_num IS NULL THEN
                          1
                      ELSE
                          0
                  END)
                  AS invalid_PSP_hrs
     FROM     F_REASSESSMENT_ORDER_HISTORY
     GROUP BY reassessment_list_month, line_of_business)
    UNION
    (SELECT reassessment_list_month, 'MLTC' PLAN,
            total_mbrs,
            available_for_reassess,
            all_docs_completed,
            all_docs_no_SNF,
            nobaseOPS_PSPinvalid,
            prmr_rec_decrease,
            prmr_rec_same,
            prmr_rec_increase,
            invalid_PSP_hrs
     FROM   jan2016_counts)
    ORDER BY reassessment_list_month;

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_INTERNAL_PRMR TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_INTERNAL_PRMR TO RIPUL_P ;
