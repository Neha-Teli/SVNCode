DROP VIEW CHOICEBI.V_FACT_MEMBER_ENROLLMENT;

CREATE OR REPLACE FORCE VIEW CHOICEBI.V_FACT_MEMBER_ENROLLMENT as 
WITH h AS
(
    SELECT /*+ materialize no_merge */ g.*,
                              ADD_MONTHS(enrollment_start_dt, -1)
                                  AS prev_month,
                              ADD_MONTHS(enrollment_end_dt, 1) AS post_month
                       FROM   (SELECT   f.*,
                                        MIN(
                                            enrollment_start_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.choice_pers,
                                                         f.member_enroll_seq_choice)
                                            AS start_dt_choice_pers,
                                        MAX(
                                            enrollment_end_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.choice_pers,
                                                         f.member_enroll_seq_choice)
                                            AS end_dt_choice_pers,
                                        MIN(
                                            enrollment_start_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_ma_pers,
                                                         f.member_enroll_seq_lob_ma)
                                            AS start_dt_ma_pers,
                                        MAX(
                                            enrollment_end_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_ma_pers,
                                                         f.member_enroll_seq_lob_ma)
                                            AS end_dt_ma_pers,
                                        MIN(
                                            enrollment_start_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_mltc_pers,
                                                         f.member_enroll_seq_lob_mltc)
                                            AS start_dt_mltc_pers,
                                        MAX(
                                            enrollment_end_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_mltc_pers,
                                                         f.member_enroll_seq_lob_mltc)
                                            AS end_dt_mltc_pers,
                                        MIN(
                                            enrollment_start_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_sh_pers,
                                                         f.member_enroll_seq_lob_sh)
                                            AS start_dt_sh_pers,
                                        MAX(
                                            enrollment_end_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.lob_sh_pers,
                                                         f.member_enroll_seq_lob_sh)
                                            AS end_dt_sh_pers,
                                        MIN(
                                            enrollment_start_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.product_pers,
                                                         f.member_enroll_seq_product)
                                            AS start_dt_product_pers,
                                        MAX(
                                            enrollment_end_dt)
                                        OVER (
                                            PARTITION BY f.member_id,
                                                         f.product_pers,
                                                         f.member_enroll_seq_product)
                                            AS end_dt_product_pers
                               FROM     (SELECT   e.*,
                                                  CASE
                                                      WHEN diff_choice IS NULL THEN
                                                          1
                                                      WHEN diff_choice <= 1 THEN
                                                          0
                                                      WHEN diff_choice > 1 THEN
                                                          1
                                                  END
                                                      newenroll_ind_choice /* new enrollment indicator of CHOICE */
                                                                          /* or */
                                                  ,
                                                  CASE
                                                      WHEN diff_start_choice = 0 THEN
                                                          1
                                                      ELSE
                                                          0
                                                  END
                                                      AS newenroll_ind_choice_v2 /* new enrollment indicator of LOB from MA perspective */
                                                                                ,
                                                  CASE
                                                      WHEN diff_ma IS NULL THEN 1
                                                      WHEN diff_ma <= 1 THEN 0
                                                      WHEN diff_ma > 1 THEN 1
                                                  END
                                                      AS newenroll_ind_lob_ma /* new enrollment indicator of LOB from MLTC perspective */
                                                                             ,
                                                  CASE
                                                      WHEN diff_mltc IS NULL THEN
                                                          1
                                                      WHEN diff_mltc <= 1 THEN
                                                          0
                                                      WHEN diff_mltc > 1 THEN
                                                          1
                                                  END
                                                      AS newenroll_ind_lob_mltc /* new enrollment indicator of LOB from SH perspective */
                                                                               ,
                                                  CASE
                                                      WHEN diff_sh IS NULL THEN 1
                                                      WHEN diff_sh <= 1 THEN 0
                                                      WHEN diff_sh > 1 THEN 1
                                                  END
                                                      AS newenroll_ind_lob_sh /* new enrollment indicator of product  */
                                                                             ,
                                                  CASE
                                                      WHEN diff_product IS NULL THEN
                                                          1
                                                      WHEN diff_product <= 1 THEN
                                                          0
                                                      WHEN diff_product > 1 THEN
                                                          1
                                                  END
                                                      AS newenroll_ind_product /* enrollment sequence of CHOICE */
                                                                              ,
                                                  SUM(
                                                      CASE
                                                          WHEN diff_choice
                                                                   IS NULL THEN
                                                              1
                                                          WHEN diff_choice <= 1 THEN
                                                              0
                                                          WHEN diff_choice > 1 THEN
                                                              1
                                                      END)
                                                  OVER (
                                                      PARTITION BY e.member_id,
                                                                   e.choice_pers
                                                      ORDER BY
                                                          enrollment_start_dt)
                                                      AS member_enroll_seq_choice /* enrollment sequence of LOB_MA_pers */
                                                                                 ,
                                                  SUM(
                                                      CASE
                                                          WHEN diff_ma IS NULL THEN
                                                              1
                                                          WHEN diff_ma <= 1 THEN
                                                              0
                                                          WHEN diff_ma > 1 THEN
                                                              1
                                                      END)
                                                  OVER (
                                                      PARTITION BY e.member_id,
                                                                   e.lob_ma_pers
                                                      ORDER BY
                                                          enrollment_start_dt)
                                                      AS member_enroll_seq_lob_ma /* enrollment sequence of LOB_mltc_pers */
                                                                                 ,
                                                  SUM(
                                                      CASE
                                                          WHEN diff_mltc IS NULL THEN
                                                              1
                                                          WHEN diff_mltc <= 1 THEN
                                                              0
                                                          WHEN diff_mltc > 1 THEN
                                                              1
                                                      END)
                                                  OVER (
                                                      PARTITION BY e.member_id,
                                                                   e.lob_mltc_pers
                                                      ORDER BY
                                                          enrollment_start_dt)
                                                      AS member_enroll_seq_lob_mltc /* enrollment sequence of LOB_sh_pers */
                                                                                   ,
                                                  SUM(
                                                      CASE
                                                          WHEN diff_sh IS NULL THEN
                                                              1
                                                          WHEN diff_sh <= 1 THEN
                                                              0
                                                          WHEN diff_sh > 1 THEN
                                                              1
                                                      END)
                                                  OVER (
                                                      PARTITION BY e.member_id,
                                                                   e.lob_sh_pers
                                                      ORDER BY
                                                          enrollment_start_dt)
                                                      AS member_enroll_seq_lob_sh /* enrollment sequence of product */
                                                                                 ,
                                                  SUM(
                                                      CASE
                                                          WHEN diff_product
                                                                   IS NULL THEN
                                                              1
                                                          WHEN diff_product <= 1 THEN
                                                              0
                                                          WHEN diff_product > 1 THEN
                                                              1
                                                      END)
                                                  OVER (
                                                      PARTITION BY e.member_id,
                                                                   e.product_pers
                                                      ORDER BY
                                                          enrollment_start_dt)
                                                      AS member_enroll_seq_product
                                         /* for indicator of transfer */
                                         --                                            ,case when diff_choice is null then 0 /* indicates start of a member */
                                         --                                                when diff_choice <=1 then 1 /* indicates a transfer */
                                         --                                                when diff_choice > 1 then 0 /* indicates a gap */
                                         --                                             end as transfer_start_ind
                                         FROM     (SELECT d.*,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  first_date_choice))
                                                              AS diff_start_choice,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  LAG(
                                                                      max_choice,
                                                                      1)
                                                                  OVER (
                                                                      PARTITION BY d.member_id,
                                                                                   d.choice_pers
                                                                      ORDER BY
                                                                          d.enrollment_start_dt,
                                                                          d.enrollment_end_dt)))
                                                              AS diff_choice,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  LAG(
                                                                      max_ma,
                                                                      1)
                                                                  OVER (
                                                                      PARTITION BY d.member_id,
                                                                                   d.lob_ma_pers
                                                                      ORDER BY
                                                                          d.enrollment_start_dt,
                                                                          d.enrollment_end_dt)))
                                                              AS diff_ma,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  LAG(
                                                                      max_mltc,
                                                                      1)
                                                                  OVER (
                                                                      PARTITION BY d.member_id,
                                                                                   d.lob_mltc_pers
                                                                      ORDER BY
                                                                          d.enrollment_start_dt,
                                                                          d.enrollment_end_dt)))
                                                              AS diff_mltc,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  LAG(
                                                                      max_sh,
                                                                      1)
                                                                  OVER (
                                                                      PARTITION BY d.member_id,
                                                                                   d.lob_sh_pers
                                                                      ORDER BY
                                                                          d.enrollment_start_dt,
                                                                          d.enrollment_end_dt)))
                                                              AS diff_sh,
                                                          MONTHS_BETWEEN(
                                                              LAST_DAY(
                                                                  enrollment_start_dt),
                                                              LAST_DAY(
                                                                  LAG(
                                                                      max_product,
                                                                      1)
                                                                  OVER (
                                                                      PARTITION BY d.member_id,
                                                                                   d.product_pers
                                                                      ORDER BY
                                                                          d.enrollment_start_dt,
                                                                          d.enrollment_end_dt)))
                                                              AS diff_product
                                                   FROM   (SELECT c.*,
                                                                  MIN(
                                                                      c.enrollment_start_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.choice_pers)
                                                                      AS first_date_choice,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.choice_pers)
                                                                      AS last_date_choice,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.choice_pers
                                                                      ORDER BY
                                                                          c.enrollment_start_dt,
                                                                          c.enrollment_end_dt)
                                                                      AS max_choice,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.lob_ma_pers
                                                                      ORDER BY
                                                                          c.enrollment_start_dt,
                                                                          c.enrollment_end_dt)
                                                                      AS max_ma,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.lob_mltc_pers
                                                                      ORDER BY
                                                                          c.enrollment_start_dt,
                                                                          c.enrollment_end_dt)
                                                                      AS max_mltc,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.lob_sh_pers
                                                                      ORDER BY
                                                                          c.enrollment_start_dt,
                                                                          c.enrollment_end_dt)
                                                                      AS max_sh,
                                                                  MAX(
                                                                      c.enrollment_end_dt)
                                                                  OVER (
                                                                      PARTITION BY c.member_id,
                                                                                   c.product_pers
                                                                      ORDER BY
                                                                          c.enrollment_start_dt,
                                                                          c.enrollment_end_dt)
                                                                      AS max_product
                                                           FROM   (SELECT /*+ materialize no_merge driving_site(a) */
                                                                         a.member_id /* unique key for each member */
                                                                                    ,
                                                                          a.subscriber_id,
                                                                          a.dl_enrl_sk,
                                                                          a.dl_enroll_id,
                                                                          'CHOICE'
                                                                              AS choice_pers,
                                                                          CASE
                                                                              WHEN a.lob IN
                                                                                       ('MA',
                                                                                        'MA AND MLTC',
                                                                                        'FIDA') THEN
                                                                                  'MA'
                                                                              WHEN a.lob IN
                                                                                       ('MLTC',
                                                                                        'SH') THEN
                                                                                  a.lob
                                                                          END
                                                                              AS lob_ma_pers,
                                                                          CASE
                                                                              WHEN a.lob IN
                                                                                       ('MLTC',
                                                                                        'MA AND MLTC',
                                                                                        'FIDA') THEN
                                                                                  'MLTC'
                                                                              WHEN a.lob IN
                                                                                       ('MA',
                                                                                        'SH') THEN
                                                                                  a.lob
                                                                          END
                                                                              AS lob_mltc_pers,
                                                                          CASE
                                                                              WHEN a.lob IN
                                                                                       ('MA AND MLTC') THEN
                                                                                  'TOTAL'
                                                                              WHEN a.lob IN
                                                                                       ('MA',
                                                                                        'MLTC',
                                                                                        'FIDA',
                                                                                        'SH') THEN
                                                                                  a.lob
                                                                          END
                                                                              AS lob_sh_pers,
                                                                          CASE
                                                                              WHEN a.lob IN
                                                                                       ('MLTC',
                                                                                        'SH',
                                                                                        'FIDA') THEN
                                                                                  a.lob
                                                                              WHEN a.lob IN
                                                                                       ('MA') THEN
                                                                                  CASE
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%MAXIMUM%' THEN
                                                                                          'MA MAXIMUM'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%CLASSIC%' THEN
                                                                                          'MA CLASSIC'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%ULTRA%' THEN
                                                                                          'MA ULTRA'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%PREFERRED%' THEN
                                                                                          'MA PREFERRED'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%ENHANCED%' THEN
                                                                                          'MA ENHANCED'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%OPTION 1%' THEN
                                                                                          'MA OPTION 1'
                                                                                      WHEN UPPER(
                                                                                               product_name) LIKE
                                                                                               '%OPTION 6%' THEN
                                                                                          'MA OPTION 6'
                                                                                      ELSE
                                                                                          'other'
                                                                                  END
                                                                              WHEN a.lob IN
                                                                                       ('MA AND MLTC') THEN
                                                                                  'MA TOTAL'
                                                                              ELSE
                                                                                  'other'
                                                                          END
                                                                              AS product_pers,
                                                                          a.dl_lob_id,
                                                                          a.product_id,
                                                                          b.product_name,
                                                                          a.enrollment_start_dt,
                                                                          a.enrollment_end_dt
                                                                   FROM   choice.dim_member_enrollment@dlake a
                                                                          LEFT JOIN
                                                                          choice.ref_plan@dlake b
                                                                              ON     a.product_id =
                                                                                         b.product_id
                                                                                 AND a.plan_id =
                                                                                         b.plan_id
                                                                                 AND a.dl_lob_id =
                                                                                         b.dl_lob_id
                                                                   WHERE  (    a.DL_ACTIVE_REC_IND =
                                                                                   'Y'
                                                                           AND a.ELIGIBILITY_IND =
                                                                                   'Y') --                                                                      and member_id in ( 7264)
                                                                                       ) c) d) e
                                         ORDER BY member_id,
                                                  enrollment_start_dt,
                                                  enrollment_end_dt) f
                               ORDER BY member_id,
                                        enrollment_start_dt,
                                        enrollment_end_dt
    ) g
)
, tr_from_product AS 
(
    SELECT  /*+ materialize no_merge */ h1.member_id,
                    h1.subscriber_id,
                    h1.dl_enrl_sk,
                    h1.dl_enroll_id,
                    h1.choice_pers,
                    h1.lob_ma_pers,
                    h1.lob_mltc_pers,
                    h1.lob_sh_pers,
                    h1.product_pers,
                    h1.dl_lob_id,
                    h1.product_id,
                    h1.product_name,
                    h1.enrollment_start_dt,
                    h1.enrollment_end_dt,
                    h1.newenroll_ind_choice,
                    h1.newenroll_ind_product,
                    SUM(
                        CASE
                            WHEN h2.product_pers IS NULL THEN 1
                            ELSE 0
                        END)
                        AS tr_from_new,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA PREFERRED' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_preferred,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA CLASSIC' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_classic,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA ULTRA' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_ultra,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA MAXIMUM' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_maximum,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA ENHANCED' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_enhanced,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA OPTION 1' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_option_1,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA OPTION 6' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_ma_option_6,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MA TOTAL' THEN
                                1
                            ELSE
                                0
                        END)
                        AS tr_from_lob_ma_total,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'MLTC' THEN 1
                            ELSE 0
                        END)
                        AS tr_from_lob_mltc,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'FIDA' THEN 1
                            ELSE 0
                        END)
                        AS tr_from_lob_fida,
                    SUM(
                        CASE
                            WHEN h2.product_pers = 'SH' THEN 1
                            ELSE 0
                        END)
                        AS tr_from_lob_sh,
                    SUM(
                        CASE
                            WHEN h1.product_pers = h2.product_pers THEN
                                1
                            ELSE
                                0
                        END)
                        AS from_same
           FROM     h h1
                    LEFT JOIN
                    h h2
                        ON     h1.member_id = h2.member_id
                           AND h1.prev_month BETWEEN TRUNC(
                                                         h2.enrollment_start_dt,
                                                         'month')
                                                 AND LAST_DAY(
                                                         h2.enrollment_end_dt)
           --                          and h1.newenroll_ind_product = 1
           --                      and h1.lob_v2 != h2.lob_v2 /* does not transfer from itself */
           GROUP BY h1.member_id,
                    h1.subscriber_id,
                    h1.dl_enrl_sk,
                    h1.dl_enroll_id,
                    h1.choice_pers,
                    h1.lob_ma_pers,
                    h1.lob_mltc_pers,
                    h1.lob_sh_pers,
                    h1.product_pers,
                    h1.dl_lob_id,
                    h1.product_id,
                    h1.product_name,
                    h1.enrollment_start_dt,
                    h1.enrollment_end_dt,
                    h1.newenroll_ind_choice,
                    h1.newenroll_ind_product
)                    
,tr_to_product AS
      (SELECT /*+ materialize no_merge */  h1.member_id,
                h1.subscriber_id,
                h1.dl_enrl_sk,
                h1.dl_enroll_id,
                h1.choice_pers,
                h1.lob_ma_pers,
                h1.lob_mltc_pers,
                h1.lob_sh_pers,
                h1.product_pers,
                h1.dl_lob_id,
                h1.product_id,
                h1.product_name,
                h1.enrollment_start_dt,
                h1.enrollment_end_dt,
                h1.newenroll_ind_choice,
                h1.newenroll_ind_product,
                SUM(
                    CASE
                        WHEN h2.product_pers IS NULL THEN 1
                        ELSE 0
                    END)
                    AS tr_to_break,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA PREFERRED' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_preferred,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA CLASSIC' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_classic,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA ULTRA' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_ultra,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA MAXIMUM' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_maximum,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA ENHANCED' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_enhanced,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA OPTION 1' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_option_1,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA OPTION 6' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_ma_option_6,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MA TOTAL' THEN
                            1
                        ELSE
                            0
                    END)
                    AS tr_to_lob_ma_total,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'MLTC' THEN 1
                        ELSE 0
                    END)
                    AS tr_to_lob_mltc,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'FIDA' THEN 1
                        ELSE 0
                    END)
                    AS tr_to_lob_fida,
                SUM(
                    CASE
                        WHEN h2.product_pers = 'SH' THEN 1
                        ELSE 0
                    END)
                    AS tr_to_lob_sh,
                SUM(
                    CASE
                        WHEN h1.product_pers = h2.product_pers THEN
                            1
                        ELSE
                            0
                    END)
                    AS to_same
       FROM     h h1
                LEFT JOIN
                h h2
                    ON     h1.member_id = h2.member_id
                       AND h1.post_month BETWEEN TRUNC(
                                                     h2.enrollment_start_dt,
                                                     'month')
                                             AND LAST_DAY(
                                                     h2.enrollment_end_dt)
       --                          and h1.newenroll_ind_product = 1
       --                      and h1.lob_v2 != h2.lob_v2 /* does not transfer from itself */
       GROUP BY h1.member_id,
                h1.subscriber_id,
                h1.dl_enrl_sk,
                h1.dl_enroll_id,
                h1.choice_pers,
                h1.lob_ma_pers,
                h1.lob_mltc_pers,
                h1.lob_sh_pers,
                h1.product_pers,
                h1.dl_lob_id,
                h1.product_id,
                h1.product_name,
                h1.enrollment_start_dt,
                h1.enrollment_end_dt,
                h1.newenroll_ind_choice,
                h1.newenroll_ind_product)
,fact_enroll_disenroll as
(   SELECT /*+ materialize no_merge */  h.member_id,
              h.subscriber_id,
              h.dl_enrl_sk,
              h.dl_enroll_id,
              h.dl_lob_id,
              h.product_id,
              h.product_name,
              h.enrollment_start_dt,
              h.enrollment_end_dt,
              h.choice_pers AS choice_perspective,
              h.start_dt_choice_pers AS choice_pers_start_dt,
              h.end_dt_choice_pers AS choice_pers_end_dt,
              h.lob_ma_pers AS ma_perspective,
              h.start_dt_ma_pers AS ma_pers_start_dt,
              h.end_dt_ma_pers AS ma_pers_end_dt,
              h.lob_mltc_pers AS mltc_perspective,
              h.start_dt_mltc_pers AS mltc_pers_start_dt,
              h.end_dt_mltc_pers AS mltc_pers_end_dt,
              h.lob_sh_pers AS five_lob_perspective,
              h.start_dt_sh_pers AS five_lob_start_dt,
              h.end_dt_sh_pers AS five_lob_end_dt,
              h.product_pers AS product_perspective,
              h.start_dt_product_pers AS product_start_dt,
              h.end_dt_product_pers AS product_end_dt --        , h.newenroll_ind_choice, h.newenroll_ind_product
                                                     ,
              TRIM(
                  ',' FROM TRIM(
                               ' ' FROM (CASE
                                             WHEN h.newenroll_ind_choice_v2 =
                                                      1 THEN
                                                 'new to CHOICE'
                                             WHEN tr_from_product.tr_from_new >
                                                      0 THEN
                                                 'return to CHOICE'
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_preferred >
                                                      0 THEN
                                                 'MA PREFERRED, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_classic >
                                                      0 THEN
                                                 'MA CLASSIC, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_ultra >
                                                      0 THEN
                                                 'MA ULTRA, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_maximum >
                                                      0 THEN
                                                 'MA MAXIMUM, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_enhanced >
                                                      0 THEN
                                                 'MA ENHANCED, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_option_1 >
                                                      0 THEN
                                                 'MA OPTION 1, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_ma_option_6 >
                                                      0 THEN
                                                 'MA OPTION 6, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_lob_ma_total >
                                                      0 THEN
                                                 'MA TOTAL, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_lob_mltc >
                                                      0 THEN
                                                 'MLTC, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_lob_fida >
                                                      0 THEN
                                                 'FIDA, '
                                             ELSE
                                                 NULL
                                         END)||
                                        (CASE
                                             WHEN tr_from_product.tr_from_lob_sh >
                                                      0 THEN
                                                 'SH, '
                                             ELSE
                                                 NULL
                                         END)))
                  AS transfer_from,
              TRIM(
                  ',' FROM TRIM(
                               ' ' FROM CASE
                                            WHEN h.enrollment_end_dt >
                                                     SYSDATE THEN
                                                NULL
                                            WHEN LAST_DAY(
                                                     h.enrollment_end_dt) =
                                                     LAST_DAY(
                                                         last_date_choice) THEN
                                                'left CHOICE' /* same month */
                                            ELSE
                                                (CASE
                                                     WHEN tr_to_product.tr_to_break >
                                                              0 THEN
                                                         'break from CHOICE'
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_preferred >
                                                              0 THEN
                                                         'MA PREFERRED, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_classic >
                                                              0 THEN
                                                         'MA CLASSIC, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_ultra >
                                                              0 THEN
                                                         'MA ULTRA, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_maximum >
                                                              0 THEN
                                                         'MA MAXIMUM, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_enhanced >
                                                              0 THEN
                                                         'MA ENHANCED, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_option_1 >
                                                              0 THEN
                                                         'MA OPTION 1, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_ma_option_6 >
                                                              0 THEN
                                                         'MA OPTION 6, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_lob_ma_total >
                                                              0 THEN
                                                         'MA TOTAL, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_lob_mltc >
                                                              0 THEN
                                                         'MLTC, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_lob_fida >
                                                              0 THEN
                                                         'FIDA, '
                                                     ELSE
                                                         NULL
                                                 END)||
                                                (CASE
                                                     WHEN tr_to_product.tr_to_lob_sh >
                                                              0 THEN
                                                         'SH, '
                                                     ELSE
                                                         NULL
                                                 END)
                                        END))
                  AS transfer_to --       ,case when h.newenroll_ind_choice_v2 = 1 or tr_from_product.tr_from_new>0 then 1 else 0 end as transfer_new_ind
                                ,
              from_same,
              to_same
     FROM     h
              LEFT JOIN tr_from_product
                  ON h.dl_enrl_sk = tr_from_product.dl_enrl_sk
              LEFT JOIN tr_to_product
                  ON h.dl_enrl_sk = tr_to_product.dl_enrl_sk
     ORDER BY member_id, enrollment_start_dt, enrollment_end_dt
)
,FME AS 
(  
    SELECT * 
    FROM( 
            SELECT /*+ materialize no_merge */ MAX(PERIOD_END_DL_ENRL_SK) AS PERIOD_END_DL_ENRL_SK, MEMBER_ID, SUBSCRIBER_ID, DL_LOB_ID, MAX(PLAN_DESC_TEMP) AS PLAN_DESC_TEMP 
                   , FIVE_LOB_PERSPECTIVE, FIVE_LOB_START_DT, FIVE_LOB_END_DT, LAST_DAY(FIVE_LOB_END_DT)+1 AS DISENROLLMENT_MONTH
                   , MAX(FIVE_LOB_TRANSFER_FROM) AS FIVE_LOB_TRANSFER_FROM, MAX(FIVE_LOB_TRANSFER_TO) FIVE_LOB_TRANSFER_TO
                   , MAX(PLAN_DESC) AS PLAN_DESC
                   , MAX(MEMBER_STATUS) AS MEMBER_STATUS
            FROM (
                    SELECT A.*
                           , CASE WHEN SEQ_ASC = 1 THEN TRANSFER_FROM ELSE NULL END AS FIVE_LOB_TRANSFER_FROM
                           , CASE WHEN SEQ_DESC = 1 THEN TRANSFER_TO ELSE NULL END AS FIVE_LOB_TRANSFER_TO
                           , CASE WHEN SEQ_DESC = 1 THEN PLAN_DESC_TEMP ELSE NULL END AS PLAN_DESC
                           , CASE WHEN SEQ_DESC = 1 THEN DL_ENRL_SK ELSE NULL END AS PERIOD_END_DL_ENRL_SK
                    from ( 
                            SELECT MEMBER_ID, SUBSCRIBER_ID, DL_ENRL_SK, DL_LOB_ID
                                   , CASE WHEN PRODUCT_ID IN ('HMD00002', 'MD000002') THEN 'VNSNY CHOICE MLTC NOT LTP'
                                          WHEN PRODUCT_ID IN ('HMD00003', 'MD000003') THEN 'VNSNY CHOICE MLTC LTP'
                                     END AS PLAN_DESC_TEMP
                                   , FIVE_LOB_PERSPECTIVE, FIVE_LOB_START_DT, FIVE_LOB_END_DT, TRANSFER_FROM, TRANSFER_TO
                                   , ROW_NUMBER() OVER (PARTITION BY MEMBER_ID, FIVE_LOB_PERSPECTIVE, FIVE_LOB_START_DT, FIVE_LOB_END_DT ORDER BY ENROLLMENT_START_DT, ENROLLMENT_END_DT) AS SEQ_ASC
                                   , ROW_NUMBER() OVER (PARTITION BY MEMBER_ID, FIVE_LOB_PERSPECTIVE, FIVE_LOB_START_DT, FIVE_LOB_END_DT ORDER BY ENROLLMENT_END_DT DESC, ENROLLMENT_START_DT DESC) AS SEQ_DESC
                                   , DEATH.SBSB_MCTR_STS AS MEMBER_STATUS
                            FROM fact_enroll_disenroll A
                            LEFT JOIN (SELECT SBSB_ID, SBSB_MCTR_STS FROM TMG1.CMC_SBSB_SUBSC@NEXUS2 WHERE SBSB_MCTR_STS = 'DECE') DEATH ON A.SUBSCRIBER_ID = DEATH.SBSB_ID
                            WHERE FIVE_LOB_PERSPECTIVE = 'MLTC'
                         ) a
                  ) 
            GROUP BY MEMBER_ID, SUBSCRIBER_ID, DL_LOB_ID, FIVE_LOB_PERSPECTIVE, FIVE_LOB_START_DT, FIVE_LOB_END_DT
        ) 
        WHERE FIVE_LOB_TRANSFER_TO NOT IN ('FIDA', 'MA TOTAL')
)
,DC_REASON AS 
(
    SELECT /*+ driving_site (D) */A.PERIOD_END_DL_ENRL_SK, A.MEMBER_ID, A.SUBSCRIBER_ID
          ,A.MEMBER_STATUS, A.FIVE_LOB_START_DT,A.FIVE_LOB_END_DT
          ,A.DISENROLLMENT_MONTH, A.FIVE_LOB_TRANSFER_TO,B.CASE_NBR, D.ENR_TERM_REASON
          ,DME.MRN AS MRN_DME, CF.MRN AS MRN_CF, CF.CASE_NUM AS CASE_NUM_CF , PEB.ENR_TERM_REASON AS REASON_CF 
          ,CASE WHEN A.MEMBER_STATUS = 'DECE' AND A.FIVE_LOB_TRANSFER_TO = 'left CHOICE' THEN 'Died'
                WHEN A.FIVE_LOB_END_DT != '31dec2199' THEN 
                                                      CASE WHEN UPPER(NVL(D.ENR_TERM_REASON, PEB.ENR_TERM_REASON)) LIKE 'I%' THEN 'Involuntary'
                                                           WHEN UPPER(NVL(D.ENR_TERM_REASON, PEB.ENR_TERM_REASON)) LIKE 'V%' THEN 'Voluntary'
                                                           WHEN UPPER(NVL(D.ENR_TERM_REASON, PEB.ENR_TERM_REASON)) LIKE 'D%' THEN 'Died'
                                                           WHEN D.ENR_TERM_REASON IS NULL THEN 'Unknown'
                                                      END
           END AS VOLUNTARY_IND
          ,CF.PROGRAM
    FROM FME A
    LEFT JOIN (SELECT
                    FME.PERIOD_END_DL_ENRL_SK,
                    MAX(DME.CASE_NBR) AS CASE_NBR
                FROM FME
                LEFT JOIN CHOICE.DIM_MEMBER_ENROLLMENT@DLAKE DME ON (LOB = 'MLTC' AND FME.MEMBER_ID = DME.MEMBER_ID AND FME.FIVE_LOB_START_DT <= DME.ENROLLMENT_START_DT AND FME.FIVE_LOB_END_DT >= DME.ENROLLMENT_END_DT)
                GROUP BY FME.PERIOD_END_DL_ENRL_SK
              ) B ON (A.PERIOD_END_DL_ENRL_SK = B.PERIOD_END_DL_ENRL_SK)
    LEFT JOIN DW_OWNER.CHOICEPRE_TRACK@NEXUS2 D ON (B.CASE_NBR = D.CASE_NUM)
    LEFT JOIN CHOICE.DIM_MEMBER_ENROLLMENT@DLAKE DME ON (A.PERIOD_END_DL_ENRL_SK = DME.DL_ENRL_SK)
    LEFT JOIN DW_OWNER.CASE_FACTS@NEXUS2 CF ON (DME.MRN = CF.MRN AND A.FIVE_LOB_START_DT = CF.ADMISSION_DATE AND A.FIVE_LOB_END_DT = CF.DISCHARGE_DATE AND CF.PROGRAM IN ('VCC', 'VCT', 'VCP','VCM', 'EVP'))
    LEFT JOIN DW_OWNER.CHOICEPRE_TRACK@NEXUS2 PEB ON (CF.CASE_NUM = PEB.CASE_NUM)    
--    WHERE EXTRACT(YEAR FROM A.DISENROLLMENT_MONTH) = 2017 
)
SELECT
    A.*,
    CASE_NBR,
    ENR_TERM_REASON,
    MRN_DME,
    MRN_CF,
    CASE_NUM_CF,
    REASON_CF,
    VOLUNTARY_IND,
    PROGRAM
FROM
    fact_enroll_disenroll A
    LEFT JOIN DC_REASON B  ON (A.MEMBER_ID = B.MEMBER_ID AND A.DL_ENRL_SK = B.PERIOD_END_DL_ENRL_SK);
    
GRANT SELECT ON CHOICEBI.V_FACT_MEMBER_ENROLLMENT TO MSTRSTG;
