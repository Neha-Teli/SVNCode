
--Build fact PCRS table for HHA, PCS and CDPAS services only
--drop table fact_pcrs_hha_claims

create table FACT_PCRS_HHA_CLAIMS as 
--create table zzz_claims_pcrs as
with pcrs1 as
(
select 
        /*+ driving_site(a) no_merge*/
      a.src_sys
    , case when substr(a.claim_id_base,1,1)='C' then 'TPCHG_CHARGE'
           when substr(a.claim_id_base,1,1)='P' then 'TPPVE_PAYMENT'
      end as pcrs_table
    , a.member_id
    , a.subscriber_id
    , c.mrn
    , c.case_no
    , c.lob    
    , e.npi
    , a.service_provider_id 
    , e.first_name as provider_name
    , a.service_from_dt 
    , min(a.received_dt) as received_dt
    , min(a.paid_dt) as paid_dt
    , case when a.claim_sub_type = 'VX0' then 'HHA' --Home Health Aide
           when a.claim_sub_type = 'VXC' then 'CDPAS' --Consumer Directed Personal AIde Services
           when a.claim_sub_type = 'VXP' then 'PCA' --Personal Care Aide
           when a.claim_sub_type = 'VXH' then 'HSK' --House Keeping
      end as service_type
    , case when a.claim_sub_type = 'VX0' then 'HHA' --Home Health Aide
           when a.claim_sub_type = 'VXC' then 'CDPAS' --Consumer Directed Personal AIde Services
           when a.claim_sub_type = 'VXP' then 'PCA II' --Personal Care Aide
           when a.claim_sub_type = 'VXH' then 'PCA I' --House Keeping
      end as service_type_desc
    , a.claim_sub_type
--    , b.proc_cd
    , 1 as unit_hr
    , sum(b.units_allow) as units_allow
    , sum(b.paid_amt) as paid_amt_clm
from choice.fct_claim_universe_curr@dlake a 
join choice.fct_claim_line_universe_curr@dlake b on (a.dl_claim_univ_sk=b.dl_claim_univ_sk and a.src_sys=b.src_sys)
join choice.fct_claim_pcrs@dlake c on(a.dl_claim_fct_sk=c.dl_claim_fct_sk and a.src_sys=c.src_sys)
left join choice.dim_provider@dlake e on (e.src_sys = a.src_sys
                                            and trim(a.service_provider_id) = trim(e.provider_id)
                                            and e.dl_active_rec_ind='Y')
--left join (select distinct proc_cd, unit_hr from choicebi.dim_cpt_codes@nexus2) p on(substr(b.proc_cd,1,5) = substr(p.proc_cd,1,5))                                            
where a.src_sys='PCRS'
and a.dl_active_rec_ind='Y'
and a.claim_sub_type in('VX0', 'VXC', 'VXP', 'VXH')
and a.service_from_dt>='01jan2016'
group by a.src_sys
    , case when substr(a.claim_id_base,1,1)='C' then 'TPCHG_CHARGE'
           when substr(a.claim_id_base,1,1)='P' then 'TPPVE_PAYMENT'
      end 
    , a.member_id
    , a.subscriber_id
    , c.mrn
    , c.case_no
    , c.lob    
    , e.npi
    , a.service_provider_id 
    , e.first_name 
    , a.service_from_dt 
    , b.proc_cd
    , a.claim_sub_type
)
--Add out of system FLSA/MW payments
, flsamw as
(
select
    /*+ driving_site(a) */ 
    mrn, npi, pay_case_no, visit_date, ipcd_id_name
    , sum(amount_owed_claim) as paid_amt_flsamw --amount paid to provider in out of system payments
from cedlap.tmg_tppve_packets_part4@dlake a
where 1=1
    and adjustment_paid_date is not null --make sure the payment was made to the provider
    and source='TPPVE'
group by mrn, npi, pay_case_no, visit_date, ipcd_id_name
having sum(amount_owed_claim)>0
)
select p.src_sys
    , p.pcrs_table
    , p.member_id
    , p.subscriber_id
    , p.mrn
    , p.case_no
    , p.lob    
    , p.npi
    , p.service_provider_id 
    , p.provider_name
    , p.service_from_dt 
    , p.received_dt
    , p.paid_dt
    , case when nvl(p.paid_amt_clm,0) + nvl(f.paid_amt_flsamw, 0)=0 then 'DENIED' else 'PAID' end as claim_status_desc
    , p.service_type
    , p.service_type_desc
    , p.claim_sub_type
--    , p.proc_cd
    , p.unit_hr
    , p.units_allow
    , p.paid_amt_clm
    , nvl(f.paid_amt_flsamw, 0) as paid_amt_flsamw
    , nvl(p.paid_amt_clm,0) + nvl(f.paid_amt_flsamw, 0) as paid_amt
    , round(case when p.units_allow != 0 
                then (nvl(p.paid_amt_clm,0) + nvl(f.paid_amt_flsamw, 0))/p.units_allow
      end, 3) as rate_per_hour 
from pcrs1 p 
left join flsamw f on(p.mrn=f.mrn 
                        and p.service_from_dt=f.visit_date
                        and p.case_no=f.pay_case_no 
                        and trim(p.npi)=trim(f.npi)
                        and trim(p.service_type)=trim(f.ipcd_id_name))
order by p.member_id, p.service_from_dt, p.npi ;
    
    

----CHECKS
--select count(*)
--from FACT_PCRS_HHA_CLAIMS a
----11046112
--
--select *
--from fact_pcrs_hha_claims a

--GRANT ACCESS
grant all on FACT_PCRS_HHA_CLAIMS to mstrstg, roc_ro, roc_ro2, linkadm, linkadm2, SF_CHOICE;