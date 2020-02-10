DROP VIEW V_HHA_HOURS_MONTHS_ENROLLMENT;

CREATE OR REPLACE VIEW V_HHA_HOURS_MONTHS_ENROLLMENT
(
    MONTHS_ENROLLED_CHAR,
    LOB,
    REGION,
    N_MBRS,
    RISK_SCORE,
    ORDER_AUTH_HRS,
    PAID_HRS
) AS
    (SELECT   CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END AS Months_enrolled,
              '1-OVERALL' AS LOB,
              '1-OVERALL' AS region --    , '1-OVERALL' as county
                                   ,
              COUNT(*) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month_std30), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                              ,
              ROUND( AVG(paid_hrs_month_std30), 1) AS paid_hrs
     FROM     v_hha_zuno2_raw_enroll
     WHERE    1 = 1 AND product_id IN ('MD000002', 'MD000005', 'V6000000') AND month_id >= 201701
     GROUP BY CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END)
    UNION
    (SELECT   CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END AS Months_enrolled,
              LOB,
              '1-OVERALL' AS region --    , '1-OVERALL' as county
                                   ,
              COUNT(*) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month_std30), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                              ,
              ROUND( AVG(paid_hrs_month_std30), 1) AS paid_hrs
     FROM     v_hha_zuno2_raw_enroll
     WHERE    1 = 1 AND product_id IN ('MD000002', 'MD000005', 'V6000000') AND month_id >= 201701
     GROUP BY lob, CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END)
    UNION
    (SELECT   CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END AS Months_enrolled,
              LOB,
              region --    , '1-OVERALL' as county
                    ,
              COUNT(*) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month_std30), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                              ,
              ROUND( AVG(paid_hrs_month_std30), 1) AS paid_hrs
     FROM     v_hha_zuno2_raw_enroll
     WHERE    1 = 1 AND product_id IN ('MD000002') AND month_id >= 201701
     GROUP BY lob, region, CASE WHEN months_enrolled > 6 THEN '6+' ELSE TO_CHAR(months_enrolled) END)
    ORDER BY 2, 3, 1;


GRANT SELECT ON V_HHA_HOURS_MONTHS_ENROLLMENT TO MICHAEL_K;

GRANT SELECT ON V_HHA_HOURS_MONTHS_ENROLLMENT TO ROC_RO;

GRANT SELECT ON V_HHA_HOURS_MONTHS_ENROLLMENT TO ROC_RO2;
