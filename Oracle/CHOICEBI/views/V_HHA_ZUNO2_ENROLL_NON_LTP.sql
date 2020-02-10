DROP VIEW V_HHA_ZUNO2_ENROLL_NON_LTP;

CREATE OR REPLACE VIEW V_HHA_ZUNO2_ENROLL_NON_LTP
(
    MONTH_ID,
    LOB,
    REGION,
    COUNTY,
    N_MBRS,
    RISK_SCORE,
    ORDER_AUTH_HRS,
    PAID_HRS,
    N_MBRS_NEW_ENROLLEES1,
    RISK_SCORE_NEW_ENROLLEES1,
    ORDER_AUTH_HRS_NEW_ENROLLEES1,
    PAID_HRS_NEW_ENROLLEES1,
    N_MBRS_ALL_OTHERS,
    RISK_SCORE_ALL_OTHERS1,
    ORDER_AUTH_HRS_ALL_OTHERS1,
    PAID_HRS_ALL_OTHERS1,
    N_MBRS_NEW_ENROLLEES3,
    RISK_SCORE_NEW_ENROLLEES3,
    ORDER_AUTH_HRS_NEW_ENROLLEES3,
    PAID_HRS_NEW_ENROLLEES3,
    N_MBRS_ALL_OTHERS3,
    RISK_SCORE_ALL_OTHERS3,
    ORDER_AUTH_HRS_ALL_OTHERS3,
    PAID_HRS_ALL_OTHERS3
) AS
with months as
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
    (SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              '1-OVERALL' AS region,
              '1-OVERALL' AS county,
              sum(a.flag) AS N_Mbrs --    , sum(ltp_ind)/count(*) as prop_ltp
                                ,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
     --FROM     v_hha_zuno2_raw_enroll
     --WHERE    ltp_ind != 1 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id
     )
    UNION
    (SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              m.region,
              '1-OVERALL' AS county,
              sum(a.flag) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
--     FROM     v_hha_zuno2_raw_enroll
--     WHERE    1 = 1 AND ltp_ind != 1 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id, m.region
     )
    UNION
    (SELECT   m.month_id,
              m.LOB,
              '1-OVERALL' AS region,
              '1-OVERALL' AS county,
              sum(a.flag) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
     --FROM     v_hha_zuno2_raw_enroll
     --WHERE    1 = 1 AND ltp_ind != 1 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id, m.LOB
     )
    UNION
    (SELECT   m.month_id,
              m.LOB,
              m.region,
              '1-OVERALL' AS county,
              sum(a.flag) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
     --FROM     v_hha_zuno2_raw_enroll
     --WHERE    1 = 1 AND ltp_ind != 1 AND dl_lob_id = 2 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id, m.LOB, m.region)
    UNION
    (SELECT   m.month_id,
              '1-OVERALL' AS LOB,
              m.region,
              m.county,
              sum(a.flag) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
     --FROM     v_hha_zuno2_raw_enroll
     --WHERE    1 = 1 AND ltp_ind != 1 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id, m.county, m.region)
    UNION
    (SELECT   m.month_id,
              m.LOB,
              m.region,
              m.county,
              sum(a.flag) AS N_Mbrs,
              ROUND( AVG(Risk_score), 3) AS Risk_score,
              ROUND( AVG(ordered_authed_hrs_month), 1) AS order_auth_hrs --    , round(avg(authed_hrs_month),1) as auth_hrs
                                                                        ,
              ROUND( AVG(paid_hrs_month), 1) AS paid_hrs --New Enrollee this month
                                                        ,
              ROUND( SUM(CASE WHEN enrolled_flag = 1 THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN Risk_score END), 3) AS Risk_score_New_Enrollees1,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees1 --    , round(avg(case when enrolled_flag=1 then authed_hrs_month end),1) as auth_hrs_New_Enrollees1
                                                                                                                            ,
              ROUND( AVG(CASE WHEN enrolled_flag = 1 THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees1,
              ROUND( SUM(CASE WHEN enrolled_flag = 0 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN Risk_score END), 3) AS Risk_score_All_Others1,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others1 --    , round(avg(case when enrolled_flag=0 then authed_hrs_month end),1) as auth_hrs_All_Others1
                                                                                                                         ,
              ROUND( AVG(CASE WHEN enrolled_flag = 0 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others1 --New enrollee in past 3 months
                                                                                                         ,
              ROUND( SUM(CASE WHEN months_enrolled IN (1, 2, 3) THEN 1 ELSE 0 END), 0) AS N_Mbrs_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN Risk_score END), 3) AS Risk_score_New_Enrollees3,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_New_Enrollees3 --    , round(avg(case when months_enrolled in(1,2,3) then authed_hrs_month end),1) as auth_hrs_New_Enrollees3
                                                                                                                                       ,
              ROUND( AVG(CASE WHEN months_enrolled IN (1, 2, 3) THEN paid_hrs_month END), 1) AS paid_hrs_New_Enrollees3,
              ROUND( SUM(CASE WHEN months_enrolled > 3 THEN 1 ELSE 0 END), 0) AS N_Mbrs_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN Risk_score END), 3) AS Risk_score_All_Others3,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN ordered_authed_hrs_month END), 1) AS order_auth_hrs_All_Others3 --    , round(avg(case when months_enrolled >3 then authed_hrs_month end),1) as auth_hrs_All_Others3
                                                                                                                           ,
              ROUND( AVG(CASE WHEN months_enrolled > 3 THEN paid_hrs_month END), 1) AS paid_hrs_All_Others3
     --FROM     v_hha_zuno2_raw_enroll
     --WHERE    1 = 1 AND ltp_ind != 1 AND month_id >= 201701
     FROM     months m left join (select * from v_hha_zuno2_raw_enroll where ltp_ind = 0 AND month_id >= 201701) a on (a.month_id  = m.month_id and A.LOB = m.lob and nvl(A.REGION,'NA') = nvl(m.region,'NA') and a.county = m.county)
     GROUP BY m.month_id,
              m.LOB,
              m.county,
              m.region
      )
    ORDER BY LOB,
             region,
             county,
             month_id;
