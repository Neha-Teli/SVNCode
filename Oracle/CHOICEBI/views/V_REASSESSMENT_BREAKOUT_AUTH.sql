DROP VIEW CHOICEBI.V_REASSESSMENT_BREAKOUT_AUTH;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_REASSESSMENT_BREAKOUT_AUTH
(
    REASSESSMENT_LIST_MONTH,
    UM_DECR_MBRS,
    UM_SAME_MBRS,
    UM_INCR_MBRS,
    UM_DECR_PMPM,
    UM_SAME_PMPM,
    UM_INCR_PMPM,
    UM_DECR_PERCCHG,
    UM_SAME_PERCCHG,
    UM_INCR_PERCCHG
) AS
    SELECT   reassessment_list_month,
             um_decr_mbrs,
             um_same_mbrs,
             um_incr_mbrs,
             um_decr_hrs / um_decr_mbrs * 1.087 * 4 AS um_decr_pmpm,
             um_same_hrs / um_same_mbrs * 1.087 * 4 AS um_same_pmpm,
             um_incr_hrs / um_incr_mbrs * 1.087 * 4 AS um_incr_pmpm,
               (um_decr_hrs / um_decr_mbrs * 1.087 * 4)
             / (um_decr_base_hrs / um_decr_mbrs * 1.087 * 4)
                 AS um_decr_percchg,
               (um_same_hrs / um_same_mbrs * 1.087 * 4)
             / (um_same_base_hrs / um_same_mbrs * 1.087 * 4)
                 AS um_same_percchg,
               (um_incr_hrs / um_incr_mbrs * 1.087 * 4)
             / (um_incr_base_hrs / um_incr_mbrs * 1.087 * 4)
                 AS um_incr_percchg
    FROM     V_REASSESSMENT_SUM_HRS
    ORDER BY reassessment_list_month;

GRANT SELECT ON CHOICEBI.V_REASSESSMENT_BREAKOUT_AUTH TO CHOICEBI ;
GRANT SELECT ON CHOICEBI.V_REASSESSMENT_BREAKOUT_AUTH TO RIPUL_P ;
