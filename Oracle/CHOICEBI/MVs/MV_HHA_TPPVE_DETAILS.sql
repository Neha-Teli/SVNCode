CREATE MATERIALIZED VIEW MV_HHA_TPPVE_DETAILS 
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('23-Feb-2018','dd-mon-yyyy')
NEXT TRUNC(SYSDATE) + 1   
WITH PRIMARY KEY
AS
with zzz_lhcsa as 
 (
    select  /*+ no_merge materialize */
            a.*
          , row_number() over (partition by vendor_npi order by vendor_name asc) as  name_seq 
    from (
                select distinct to_char(vendor_npi) as vendor_npi, vendor_name 
                from dw_owner.dimension_vendorNPI_address
                UNION 
                select distinct npi as vendor_npi, first_name as vendor_name  from choice.dim_provider@dlake
              ) a 
)
select /*+ no_merge materialize */
    mrn, member_id
    , pay_visit_date
    , sum(case when agy_rep_type='VX0' then Total_Hours else 0 end) as TPPVE_HHA
    , sum(case when agy_rep_type ='VXP' then Total_Hours else 0 end) as TPPVE_PCA
    , sum(case when agy_rep_type ='VXC' then Total_Hours else 0 end) as TPPVE_CDPAS
    , sum(case when agy_rep_type ='VXH' then Total_Hours else 0 end) as TPPVE_HSK
    , sum(case when agy_rep_type ='VXT' then Total_Hours else 0 end) as TPPVE_TRA -- what is 'TRA'
    , sum(Total_hours) as TPPVE_Hours
    , Total_Pay_Amount
    , pay_id_no
    , vendor_name
    , vendor_npi
from (
    SELECT /*+ full(r) */b.mrn
        , coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id
        , t1.pay_patient_id
        , t1.pay_id_no
        , coalesce(vn.vendor_name, v2.rep_lnam) as vendor_name
        , vd.vendor_npi
        , r.agy_rep_type --Agency Type gives information about service type (VX0=HHA, VXP=PCA, VXC=CDPAS, VXH=HSK)
        , t1.pay_visit_date
        , t1.pay_case_no
        , t1.pay_co_code
        , sum(t1.pay_amount) as Total_Pay_Amount
        , sum(CASE 
                WHEN t1.PAY_TYPE_PAYMENT ='A' THEN 0 
                WHEN t1.PAY_TYPE_PAYMENT='T' THEN  -1*(t1.PAY_HOURS+PAY_MINUTES/60) 
                ELSE (t1.PAY_HOURS+PAY_MINUTES/60)  
              END) as Total_Hours
    from dw_owner.TPPVE_PAYMENT t1 
    join dw_owner.case_facts b on (t1.pay_case_no = b.case_num) --CASE_FACTS needed to pick up MRN and Program
    left join dw_owner.tpcln_agy_rep r on(r.agy_rep_id=t1.pay_id_no)
    left join dw_owner.dimension_vendorNPI_address vd on (substr(t1.pay_id_no, 4,5) = vd.vendor_code)
    left join zzz_lhcsa vn on (to_char(vd.vendor_npi) = vn.vendor_npi and vn.name_seq = 1)
    left join (select distinct REP_ID, REP_LNAM from res_owner.agency_rep_all@ms_owner_rcprod) v2 on (v2.rep_id = t1.pay_id_no)
    left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b1 on (to_char(b.mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
    left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b2 on (to_char(b.mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
    left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b3 on (to_char(b.mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)    
    WHERE 1=1
      AND t1.pay_visit_date >= '01jan2015' --choose time-frame of interest
      AND t1.PAY_CO_CODE IN ('00110','00107') -- no dimension table available...
      AND t1.pay_id_no like 'V%' -- to get para-professional services
      AND b.program in ('VCP','VCM','VCC','VCT','EVP','VCF') --MLTC, MAP and FIDA only 
    group by b.mrn,  coalesce(b1.member_id, b2.member_id, b3.member_id)
        , t1.pay_patient_id
        , t1.pay_id_no
        , coalesce(vn.vendor_name, v2.rep_lnam)
        , vd.vendor_npi
--        , coalesce(v.dsp_vendor_name, v2.rep_lnam)
        , r.agy_rep_type
        , t1.pay_visit_date
        , t1.pay_case_no
        , t1.pay_co_code
    having sum(t1.pay_amount) > 0 ---Was not in original queries; thought this might be useful to filter out payments that are declined
    and  sum(CASE 
                WHEN PAY_TYPE_PAYMENT ='A' THEN 0 
                WHEN PAY_TYPE_PAYMENT='T' THEN  -1*(PAY_HOURS+PAY_MINUTES/60) 
                ELSE (PAY_HOURS+PAY_MINUTES/60)  
              END) !=0 --drop visits where Total Hours=0 after adjustments/take-backs
    )
having sum(Total_hours) > 0 ---Was not in original queries; thought this might be useful to filter out payments that are declined
group by mrn, member_id
, pay_visit_date, Total_Pay_Amount, pay_id_no,  vendor_name, vendor_npi
