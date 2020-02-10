DROP VIEW V_HHA_ZUNO2_DISENROLL_NON_LTP;

CREATE OR REPLACE VIEW V_HHA_ZUNO2_DISENROLL_NON_LTP
(
    MONTH_ID,
    LOB,
    REGION,
    COUNTY,
    N_MBRS_DISENROLLEES1,
    RISK_SCORE_DISENROLLEES1,
    ORDER_AUTH_HRS_DISENROLLEES1,
    PAID_HRS_DISENROLLEES1,
    N_MBRS_DISENROLLEES3,
    RISK_SCORE_DISENROLLEES3,
    ORDER_AUTH_HRS_DISENROLLEES3,
    PAID_HRS_DISENROLLEES3
) AS
 WITH PREV_MONTH_DISENROLL AS
             (SELECT /*+ NO_MERGE MATERIALIZE */
                    MONTH_ID,
                       LOB,
                       REGION,
                       COUNTY,
                       COUNT(*) N_Mbrs_PREV,
                       SUM(RISK_SCORE) RISK_SCORE,
                       SUM(ordered_authed_hrs_month) ordered_authed_hrs_month,
                       SUM(paid_hrs_month) AS paid_hrs
              FROM     v_hha_zuno2_raw_disenroll
              WHERE    ltp_ind != 1 AND MONTHS_DISENROLLED = 1 AND month_id >= 201701 AND disenrolled_flag = 1
              GROUP BY MONTH_ID,
                       LOB,
                       REGION,
                       COUNTY)
    , months as
    (                       
        SELECT /*+ materialize no_merge */
            distinct
               a.month_id,
               a.dl_lob_id,
               CASE
                   WHEN a.product_name = 'VNSNY CHOICE MLTC' THEN '2-MLTC'
                   WHEN a.product_name = 'VNSNY CHOICE FIDA COMPLETE (MEDICARE-MEDICAID PLAN)' THEN '4-FIDA'
                   WHEN a.product_name = 'VNSNY CHOICE TOTAL (HMO SNP)' THEN '3-MAP'
               END
                   AS LOB,
               a.region_name,
               CASE
                   WHEN a.region_name = 'NEW YORK METRO' THEN '2-REGION 1-NYC'
                   WHEN a.region_name = 'MID-HUDSON/NORTHERN' THEN '3-REGION 2-MH/N'
                   WHEN a.region_name = 'NORTHEAST/WESTERN' THEN '4-REGION 3-NE/W'
                   WHEN a.region_name = 'REST OF NY STATE' THEN '5-REGION 4-ROS'
               END
                   AS region,
               a.county
        FROM   CHOICEBI.FACT_MEMBER_MONTH a
        WHERE  a.dl_lob_id IN (2, 4, 5) AND a.program IN ('MLTC', 'FIDA') AND a.month_id >= 201501
    )        
    (
    SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              '1-OVERALL' AS region,
              '1-OVERALL' AS county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID)
                  AS N_Mbrs_disenrollees3,
              (SELECT SUM(Risk_score) / SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID))
                  AS Risk_score_disenrollees3,
              (SELECT SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID)
                  AS order_auth_hrs_disenrollees3,
              (SELECT SUM(paid_hrs) / SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID))
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     --WHERE    ltp_ind != 1 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701
     GROUP BY m.month_id
    )
    UNION ALL
    (SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              m.region,
              '1-OVERALL' AS county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.region = m.region)
                  AS N_Mbrs_disenrollees3,
              (SELECT ROUND( SUM(Risk_score) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.region = m.region)
                  AS Risk_score_disenrollees3,
              (SELECT ROUND( SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.region = m.region)
                  AS order_auth_hrs_disenrollees3,
              (SELECT ROUND( SUM(paid_hrs) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.region = m.region)
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     --WHERE    ltp_ind = 0 AND MONTHS_DISENROLLED = 1
     GROUP BY m.month_id, m.region
    )
    UNION ALL
    (SELECT   m.month_id,
              m.LOB,
              '1-OVERALL' AS region,
              '1-OVERALL' AS county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB)
                  AS N_Mbrs_disenrollees3,
              (SELECT ROUND( SUM(Risk_score) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB)
                  AS Risk_score_disenrollees3,
              (SELECT ROUND( SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB)
                  AS order_auth_hrs_disenrollees3,
              (SELECT ROUND( SUM(paid_hrs) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB)
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
--     WHERE    ltp_ind = 0 AND MONTHS_DISENROLLED = 1
     GROUP BY m.month_id, m.LOB
     )
    UNION ALL
    ( 
        SELECT   
              m.month_id,
              m.LOB,
              m.region,
              '1-OVERALL' AS county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB)
                  AS N_Mbrs_disenrollees3,
              (SELECT ROUND( SUM(Risk_score) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND m.region = b.region)
                  AS Risk_score_disenrollees3,
              (SELECT ROUND( SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND m.region = b.region)
                  AS order_auth_hrs_disenrollees3,
              (SELECT ROUND( SUM(paid_hrs) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND m.region = b.region)
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)     
--     WHERE    ltp_ind = 0 AND MONTHS_DISENROLLED = 1
     GROUP BY m.month_id, m.LOB, m.region
    )
    UNION ALL
    (SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              m.region,
              m.county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.county = m.county AND m.region = b.region)
                  AS N_Mbrs_disenrollees3,
              (SELECT ROUND( SUM(Risk_score) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.county = m.county AND m.region = b.region)
                  AS Risk_score_disenrollees3,
              (SELECT ROUND( SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.county = m.county AND m.region = b.region)
                  AS order_auth_hrs_disenrollees3,
              (SELECT ROUND( SUM(paid_hrs) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.county = m.county AND m.region = b.region)
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
--     WHERE    ltp_ind = 0 AND MONTHS_DISENROLLED = 1
     GROUP BY m.month_id, m.county, m.region
     )
    UNION ALL
    (SELECT   m.month_id,
              m.LOB,
              m.region,
              m.county,
              ROUND( SUM(CASE WHEN disenrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_disenrollees1,
              ROUND( AVG(CASE WHEN disenrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_disenrollees1,
              (SELECT SUM(N_Mbrs_PREV)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND b.county = m.county AND m.region = b.region)
                  AS N_Mbrs_disenrollees3,
              (SELECT ROUND( SUM(Risk_score) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.county = m.county AND m.region = b.region)
                  AS Risk_score_disenrollees3,
              (SELECT ROUND( SUM(ordered_authed_hrs_month) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND b.county = m.county AND m.region = b.region)
                  AS order_auth_hrs_disenrollees3,
              (SELECT ROUND( SUM(paid_hrs) / SUM(N_Mbrs_PREV), 3)
               FROM   PREV_MONTH_DISENROLL B
               WHERE  (B.MONTH_ID BETWEEN TO_CHAR( ADD_MONTHS( TO_DATE( m.MONTH_ID, 'YYYYMM'), -2), 'YYYYMM') AND m.MONTH_ID) AND b.LOB = m.LOB AND b.county = m.county AND m.region = b.region)
                  AS paid_hrs_disenrollees3
     --FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and A.REGION = m.region and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
     FROM     months m left join v_hha_zuno2_raw_disenroll a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county and ltp_ind = 0 AND MONTHS_DISENROLLED = 1 AND m.month_id >= 201701)
--     WHERE    ltp_ind = 0 AND MONTHS_DISENROLLED = 1
     GROUP BY m.month_id,
              m.LOB,
              m.county,
              m.region
    );
