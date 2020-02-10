DROP MATERIALIZED VIEW CHOICEBI.MV_HOSPICE_UTILIZATION_DATA;

CREATE MATERIALIZED VIEW CHOICEBI.MV_HOSPICE_UTILIZATION_DATA 
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
WITH data_set AS
         (SELECT /*+ PARALLEL(2) */
                DISTINCT SUBSCRIBER_ID,
                         HIC_NUM,
                         MEDICARE_NUM,
                         HOSPICE_IND,
                         PAYMT_ADJUST_STARTDATE AS START_DATE,
                         PAYMT_ADJUST_ENDDATE AS END_DATE,
                         FILE_RUN_DATE
          FROM   DW_OWNER.CMS_MMR_DATAFILE A
                 JOIN fact_member_month B ON A.HIC_NUM = B.MEDICARE_NUM
          WHERE  HOSPICE_IND = 'Y'           
                                  ),
     grp_starts AS
         (SELECT SUBSCRIBER_ID,
                 HIC_NUM,
                 MEDICARE_NUM,
                 START_DATE,
                 END_DATE,
                 CASE
                     WHEN   LAG(
                                END_DATE)
                            OVER (PARTITION BY SUBSCRIBER_ID
                                  ORDER BY SUBSCRIBER_ID, FILE_RUN_DATE)
                          + 1 < START_DATE THEN
                         1
                     WHEN    START_DATE =
                                 LAG(
                                     END_DATE)
                                 OVER (PARTITION BY SUBSCRIBER_ID
                                       ORDER BY SUBSCRIBER_ID, FILE_RUN_DATE)
                          OR START_DATE =
                                   LAG(
                                       END_DATE)
                                   OVER (
                                       PARTITION BY SUBSCRIBER_ID
                                       ORDER BY SUBSCRIBER_ID, FILE_RUN_DATE)
                                 + 1
                          OR START_DATE >=
                                   LAG(
                                       END_DATE)
                                   OVER (
                                       PARTITION BY SUBSCRIBER_ID
                                       ORDER BY SUBSCRIBER_ID, FILE_RUN_DATE)
                                 + 1 THEN
                         0
                     ELSE
                         1
                 END
                     GRP_START
          FROM   DATA_SET),
     grps AS
         (SELECT SUBSCRIBER_ID,
                 HIC_NUM,
                 MEDICARE_NUM,
                 START_DATE,
                 END_DATE,
                 SUM(GRP_START) OVER (PARTITION BY SUBSCRIBER_ID ORDER BY SUBSCRIBER_ID, START_DATE, END_DATE) GRP
          FROM   GRP_STARTS),
     v_subscriber_conti_data AS
         (SELECT   SUBSCRIBER_ID,
                   MIN(START_DATE) START_DATE,
                   MAX(END_DATE) END_DATE
          FROM     GRPS
          GROUP BY SUBSCRIBER_ID, GRP)
/*create or replace view v_Hos_005 as
(
select distinct b.month_id, a.subscriber_id from v_subscriber_conti_data a, mstrstg.lu_month@nexus2  b
where b.month_id between to_number(to_char(start_date,'YYYYMM')) and to_number(to_char(end_date,'YYYYMM'))
)*/
SELECT hospice_mem.month_id,
       hospice_mem.lob_id,
       hospice_mem.product_id,
       hospice_mem.line_of_business,
       --hospice_mem.vns_plan_desc,
       hospice_mem.program,
       hospice_mem.subscriber_id,
       NVL(hospice_unit, 0) hospice_unit
--total_member,
--round(nvl(hospice_unit,0)/total_member * 12000,1) per1000
FROM   (SELECT   B.month_id,
                 a.lob_id,
                 a.line_of_business,
                 program,
                 a.PRODUCT_ID,
                 a.subscriber_id,
                 COUNT(1) hospice_unit
        FROM     fact_member_month a
                 JOIN
                 (SELECT DISTINCT b.month_id, a.subscriber_id
                  FROM   v_subscriber_conti_data a, mstrstg.lu_month b
                  WHERE  b.month_id BETWEEN TO_NUMBER(
                                                TO_CHAR(start_date, 'YYYYMM'))
                                        AND TO_NUMBER(
                                                TO_CHAR(end_date, 'YYYYMM'))) b
                     ON     a.subscriber_id = b.subscriber_id
                        AND A.MONTH_ID = B.MONTH_ID
        GROUP BY a.lob_id,
                 a.line_of_business,
                 program,
                 B.month_id,
                 a.PRODUCT_ID,
                 a.subscriber_id) hospice_mem;


COMMENT ON MATERIALIZED VIEW CHOICEBI.MV_HOSPICE_UTILIZATION_DATA IS 'snapshot table for snapshot CHOICEBI.MV_HOSPICE_UTILIZATION_DATA';

GRANT SELECT ON CHOICEBI.MV_HOSPICE_UTILIZATION_DATA TO MSTRSTG;

GRANT SELECT ON CHOICEBI.MV_HOSPICE_UTILIZATION_DATA TO DW_OWNER;

GRANT SELECT ON CHOICEBI.MV_HOSPICE_UTILIZATION_DATA TO LINKADM;
