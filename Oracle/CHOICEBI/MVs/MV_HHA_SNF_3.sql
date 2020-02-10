CREATE MATERIALIZED VIEW MV_HHA_SNF_3 
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('23-Feb-2018','dd-mon-yyyy')
NEXT TRUNC(SYSDATE) + 1   
WITH PRIMARY KEY
AS
with zzz_snf as 
(
    select
          /*+ no_merge materialize driving_site(c) */ 
          distinct
          c.member_id
        , c.subscriber_id 
        , c.LOB
        , c.src_sys
        , c.claim_id
        , c.claim_modifier
        , c.claim_id_base
        , c.claim_status
        , c.paid_dt 
        , c.paid_amt
        , c.product_id
        , l.claim_line_seq_num
        , l.service_id
        , l.service_from_dt
        , l.service_to_dt
        , l.charge_amt, l.allowed_amt, l.paid_amt as line_paid_amt
        , l.units_allow
     from choice.fct_claim_universe@dlake c
     /*claim line level tables start here*/
     left join choice.fct_claim_line_universe@dlake l on (c.claim_id=l.claim_id and c.member_id = l.member_id and l.claim_status in ('02', 'P') )
     where 1=1
            and c.claim_status in ('02', 'P')
            and c.claim_adjusted_to is null
            and c.paid_amt>0 /*claim not denied*/
            and c.allowed_amt > 0
            and c.facility_type in  ('02')
            and c.bill_class in ('1')
            and ((l.revenue_cd  between '0180' and '0185') 
            or     (l.revenue_cd  between '0189' and '0199') 
            or     (l.revenue_cd  between '0100' and '0169')
            or     (l.revenue_cd  between '0420' and '0444') ) 
            and c.lob in ('MLTC', 'FIDA' ,'MA AND MLTC')
            and l.service_from_dt >='01jan2015'
            and (l.paid_amt >0 or l.units_allow>0)
)
, zzz_snf2 as 
(
    select /*+ no_merge materialize */
           b.subscriber_id,
           d.day_date, 
           b.service_from_dt,  
           b.snf_allow, 
           b.claim_paid_amt,
           b.avg_day_cost_los,
           b.avg_day_cost_allow, 
           b.snf_hours,
           f.product_id,
           b.use_units_allow
from (
            select /*+ no_merge materialize full(d) */ 
                a.* ,
                case when snf_paid_amt <> claim_paid_amt then 1 else 0 end as diff_claim_line_ind,
                case when diff_avg_los_allow <> 0 then 1 else 0 end as diff_los_allow_ind,
                case when diff_days_los_allow <> 0   and avg_day_cost_allow >= 100 and avg_day_cost_allow <= 1500 and (avg_day_cost_los < 100 or avg_day_cost_los > 2000) 
                        then 1
                        else  0 end as use_units_allow
            from (
                        select subscriber_id, claim_id, product_id, service_from_dt, service_to_dt,
                            paid_amt as claim_paid_amt,
                            sum(line_paid_amt) over (partition by claim_id, member_id) as snf_paid_amt,
                            sum(units_allow) over (partition by claim_id, member_id) as snf_allow,
                            service_to_dt - service_from_dt + 1 as claim_los,
                            (service_to_dt - service_from_dt + 1) - (sum(units_allow) over (partition by claim_id, member_id)) as diff_days_los_allow,
                            paid_amt /  (sum(units_allow) over (partition by claim_id, member_id)) as avg_day_cost_allow,
                            paid_amt / (service_to_dt - service_from_dt + 1) as avg_day_cost_los,
                            (paid_amt / (service_to_dt - service_from_dt + 1)) - (paid_amt / (sum(units_allow) over (partition by claim_id, member_id))) as diff_avg_los_allow,
                            (paid_amt /  (sum(units_allow) over (partition by claim_id, member_id)))/19 as snf_hours
                        from zzz_snf
                    ) a
                group by subscriber_id, claim_id, product_id, service_from_dt, service_to_dt, snf_paid_amt, claim_paid_amt, snf_allow, claim_los, diff_days_los_allow, avg_day_cost_allow, avg_day_cost_los, diff_avg_los_allow, snf_hours
            ) b
        join mstrstg.lu_day d on(d.day_date between trunc(b.service_from_dt) and case when use_units_allow = 1 then trunc(b.service_from_dt) + snf_allow -1 else trunc(b.service_to_dt) end) -- when calculation of day cost depends on whether we follow the units allow or service from-to date
        left join choicebi.fact_member_month f on (b.subscriber_id = f.subscriber_id and to_char(b.service_from_dt, 'YYYYMM') = f.month_id)
)
, ZZZ_HHA_SNF_3 as 
(
    select * 
    from 
    (
        select 
            a.subscriber_id
                    , a.day_date
                    , a.claim_paid_amt_total
                    , a.claim_paid_amt_day
                    , a.snf_hours
                    , a.product_id
        from 
        (
            select 
                         subscriber_id
                        , day_date
                        , sum(claim_paid_amt) over (partition by subscriber_id, day_date) as claim_paid_amt_total
                        , sum(case when use_units_allow = 1 then avg_day_cost_allow else avg_day_cost_los end) over (partition by subscriber_id, day_date) as claim_paid_amt_day
                        , sum(snf_hours) over (partition by subscriber_id, day_date) as snf_hours
                        , case when (sum(case when product_id in ('HMD00006', 'VNS030A7','MD000003','HMD00003') then 1 else 0 end) over (partition by subscriber_id, day_date)) >= 1 then 1 else 0 end  as LTP_IND_pdt -- if members have 2 LTP sts on same day take ltp
                        , product_id
            from zzz_snf2 
        ) a
        group by  a.subscriber_id
                    , a.day_date
                    , a.claim_paid_amt_total
                    , a.claim_paid_amt_day
                    , a.snf_hours
                    , a.product_id
    )
)
select * from ZZZ_HHA_SNF_3;