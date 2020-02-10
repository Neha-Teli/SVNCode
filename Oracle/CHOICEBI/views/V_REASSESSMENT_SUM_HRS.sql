DROP VIEW CHOICEBI.V_REASSESSMENT_SUM_HRS;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_SUM_HRS
AS
    (SELECT   reassessment_list_month,
              COUNT(1) AS members,
              SUM(baseline_hrs) AS baseline_hrs,
              SUM(prmr_reduction_hrs) AS prmr_reduction_hrs,
              SUM(um_reduction_hrs) AS um_reduction_hrs,
              SUM(endpoint_hrs) AS endpoint_hrs,
              SUM(CASE WHEN prmrcat = '1-Reduced' THEN 1 ELSE 0 END)
                  AS prmr_decr_mbrs,
              SUM(CASE WHEN prmrcat = '2-Same' THEN 1 ELSE 0 END)
                  AS prmr_same_mbrs,
              SUM(CASE WHEN prmrcat = '3-Increased' THEN 1 ELSE 0 END)
                  AS prmr_incr_mbrs,
              SUM(
                  CASE
                      WHEN prmrcat = '1-Reduced' THEN prmr_reduction_hrs
                      ELSE 0
                  END)
                  AS prmr_decr_hrs,
              SUM(
                  CASE
                      WHEN prmrcat = '2-Same' THEN prmr_reduction_hrs
                      ELSE 0
                  END)
                  AS prmr_same_hrs,
              SUM(
                  CASE
                      WHEN prmrcat = '3-Increased' THEN prmr_reduction_hrs
                      ELSE 0
                  END)
                  AS prmr_incr_hrs,
              SUM(CASE WHEN prmrcat = '1-Reduced' THEN baseline_hrs ELSE 0 END)
                  AS prmr_decr_base_hrs,
              SUM(CASE WHEN prmrcat = '2-Same' THEN baseline_hrs ELSE 0 END)
                  AS prmr_same_base_hrs,
              SUM(
                  CASE
                      WHEN prmrcat = '3-Increased' THEN baseline_hrs
                      ELSE 0
                  END)
                  AS prmr_incr_base_hrs,
              SUM(CASE WHEN umcat = '1-Reduced' THEN 1 ELSE 0 END)
                  AS um_decr_mbrs,
              SUM(CASE WHEN umcat = '2-Same' THEN 1 ELSE 0 END) AS um_same_mbrs,
              SUM(CASE WHEN umcat = '3-Increased' THEN 1 ELSE 0 END)
                  AS um_incr_mbrs,
              SUM(
                  CASE
                      WHEN umcat = '1-Reduced' THEN um_reduction_hrs
                      ELSE 0
                  END)
                  AS um_decr_hrs,
              SUM(CASE WHEN umcat = '2-Same' THEN um_reduction_hrs ELSE 0 END)
                  AS um_same_hrs,
              SUM(
                  CASE
                      WHEN umcat = '3-Increased' THEN um_reduction_hrs
                      ELSE 0
                  END)
                  AS um_incr_hrs,
              SUM(CASE WHEN umcat = '1-Reduced' THEN baseline_hrs ELSE 0 END)
                  AS um_decr_base_hrs,
              SUM(CASE WHEN umcat = '2-Same' THEN baseline_hrs ELSE 0 END)
                  AS um_same_base_hrs,
              SUM(CASE WHEN umcat = '3-Increased' THEN baseline_hrs ELSE 0 END)
                  AS um_incr_base_hrs
     FROM     F_REASSESSMENT_ORDER_HISTORY
     WHERE        1 = 1
              AND all_docs_nosnf = 1 --and svcplan_created=1 and baseline_hrs is not null
              AND psp_approved_units_num IS NOT NULL
              AND endpoint_hrs IS NOT NULL
     GROUP BY reassessment_list_month)
    UNION
    (SELECT reassessment_list_month,
            members,
            baseline_hrs,
            prmr_reduction_hrs,
            um_reduction_hrs,
            endpoint_hrs,
            prmr_decr_mbrs,
            prmr_same_mbrs,
            prmr_incr_mbrs,
            prmr_decr_hrs,
            prmr_same_hrs,
            prmr_incr_hrs,
            prmr_decr_base_hrs,
            prmr_same_base_hrs,
            prmr_incr_base_hrs,
            um_decr_mbrs,
            um_same_mbrs,
            um_incr_mbrs,
            um_decr_hrs,
            um_same_hrs,
            um_incr_hrs,
            um_decr_base_hrs,
            um_same_base_hrs,
            um_incr_base_hrs
     FROM   jan2016_hrs)
    ORDER BY reassessment_list_month;

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_SUM_HRS TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_SUM_HRS TO RIPUL_P ;
