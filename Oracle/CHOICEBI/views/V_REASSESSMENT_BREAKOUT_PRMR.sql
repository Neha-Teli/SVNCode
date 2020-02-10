DROP VIEW CHOICEBI.V_REASSESSMENT_BREAKOUT_PRMR;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_BREAKOUT_PRMR
(
    REASSESSMENT_LIST_MONTH,
    PRMR_DECR_MBRS,
    PRMR_SAME_MBRS,
    PRMR_INCR_MBRS,
    PRMR_DECR_PMPM,
    PRMR_SAME_PMPM,
    PRMR_INCR_PMPM,
    PRMR_DECR_PERCCHG,
    PRMR_SAME_PERCCHG,
    PRMR_INCR_PERCCHG
) AS
    SELECT   reassessment_list_month,
             prmr_decr_mbrs,
             prmr_same_mbrs,
             prmr_incr_mbrs,
             prmr_decr_hrs / prmr_decr_mbrs * 1.087 * 4 AS prmr_decr_pmpm,
             prmr_same_hrs / prmr_same_mbrs * 1.087 * 4 AS prmr_same_pmpm,
             prmr_incr_hrs / prmr_incr_mbrs * 1.087 * 4 AS prmr_incr_pmpm,
               (prmr_decr_hrs / prmr_decr_mbrs * 1.087 * 4)
             / (prmr_decr_base_hrs / prmr_decr_mbrs * 1.087 * 4)
                 AS prmr_decr_percchg,
               (prmr_same_hrs / prmr_same_mbrs * 1.087 * 4)
             / (prmr_same_base_hrs / prmr_same_mbrs * 1.087 * 4)
                 AS prmr_same_percchg,
               (prmr_incr_hrs / prmr_incr_mbrs * 1.087 * 4)
             / (prmr_incr_base_hrs / prmr_incr_mbrs * 1.087 * 4)
                 AS prmr_incr_percchg
    FROM     V_REASSESSMENT_SUM_HRS
    ORDER BY reassessment_list_month;


GRANT SELECT ON CHOICEBI.V_REASSESSMENT_BREAKOUT_PRMR TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_BREAKOUT_PRMR TO RIPUL_P ;
