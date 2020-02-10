with fme as 
(  -- at member - MLTC(no MAP or FIDA) enrollment level, higher level than fact_member_enrollment
    select * 
    from( 
            select max(period_end_dl_enrl_sk) as period_end_dl_enrl_sk, member_id, subscriber_id, dl_lob_id, max(plan_desc_temp) as plan_desc_temp 
                   , five_lob_perspective, five_lob_start_dt, five_lob_end_dt, last_day(five_lob_end_dt)+1 as disenrollment_month
                   , max(five_lob_transfer_from) as five_lob_transfer_from, max(five_lob_transfer_to) five_lob_transfer_to
                   , max(plan_desc) as plan_desc
                   , max(member_status) as member_status
        --           , add_months(trunc(last_day(decode(five_lob_end_dt, to_date('31dec2199'), sysdate, five_lob_end_dt))), -2) as analysis_start_month
        --           , add_months(trunc(last_day(decode(five_lob_end_dt, to_date('31dec2199'), sysdate, five_lob_end_dt))), -1) as analysis_end_month
            from (
                    select a.*
                           , case when seq_asc = 1 then transfer_from else null end as five_lob_transfer_from
                           , case when seq_desc = 1 then transfer_to else null end as five_lob_transfer_to
                           , case when seq_desc = 1 then plan_desc_temp else null end as plan_desc
                           , case when seq_desc = 1 then dl_enrl_sk else null end as period_end_dl_enrl_sk
                    from ( 
                            select member_id, subscriber_id, dl_enrl_sk, dl_lob_id
                                   , case when product_id in ('HMD00002', 'MD000002') then 'VNSNY CHOICE MLTC NOT LTP'
                                          when product_id in ('HMD00003', 'MD000003') then 'VNSNY CHOICE MLTC LTP'
                                     end as plan_desc_temp
                                   , five_lob_perspective, five_lob_start_dt, five_lob_end_dt, transfer_from, transfer_to
                                   , row_number() over (partition by member_id, five_lob_perspective, five_lob_start_dt, five_lob_end_dt order by enrollment_start_dt, enrollment_end_dt) as seq_asc
                                   , row_number() over (partition by member_id, five_lob_perspective, five_lob_start_dt, five_lob_end_dt order by enrollment_end_dt desc, enrollment_start_dt desc) as seq_desc
                                   , death.sbsb_mctr_sts as member_status
                            from rachel_l.fact_member_enrollment
                            left join (select sbsb_id, sbsb_mctr_sts from tmg1.cmc_sbsb_subsc@nexus2 where sbsb_mctr_sts = 'DECE') death on fact_member_enrollment.subscriber_id = death.sbsb_id
                            where five_lob_perspective = 'MLTC'
                         ) a
                  ) 
            group by member_id, subscriber_id, dl_lob_id, five_lob_perspective, five_lob_start_dt, five_lob_end_dt
            order by member_id, subscriber_id, dl_lob_id, five_lob_perspective, five_lob_start_dt, five_lob_end_dt
        ) 
        where five_lob_transfer_to not in ('FIDA', 'MA TOTAL')
)
, dc_reason as (
    select a.period_end_dl_enrl_sk, a.member_id, a.subscriber_id
           , a.member_status, a.five_lob_start_dt,a.five_lob_end_dt, a.disenrollment_month, a.five_lob_transfer_to
           , b.case_nbr, d.enr_term_reason
           , dme.mrn as mrn_dme, cf.mrn as mrn_cf, cf.case_num as case_num_cf , peb.enr_term_reason as reason_cf 
           , case when a.member_status = 'DECE' and a.five_lob_transfer_to = 'left CHOICE' then 'Died'
                  when a.five_lob_end_dt != '31dec2199' then 
                                                         case when upper(nvl(d.enr_term_reason, peb.enr_term_reason)) like 'I%' then 'Involuntary'
                                                              when upper(nvl(d.enr_term_reason, peb.enr_term_reason)) like 'V%' then 'Voluntary'
                                                              when upper(nvl(d.enr_term_reason, peb.enr_term_reason)) like 'D%' then 'Died'
                                                              when d.enr_term_reason is null then 'Unknown'
                                                         end 
             end as voluntary_ind
           , cf.program
    from fme a
    left join (select fme.period_end_dl_enrl_sk, max(dme.case_nbr) as case_nbr
                from fme
                left join choice.dim_member_enrollment@dlake dme on lob = 'MLTC'
                                                                 and fme.member_id = dme.member_id
                                                                 and fme.five_lob_start_dt <= dme.enrollment_start_dt
                                                                 and fme.five_lob_end_dt >= dme.enrollment_end_dt
                group by fme.period_end_dl_enrl_sk
               ) b on a.period_end_dl_enrl_sk = b.period_end_dl_enrl_sk
    left join dw_owner.choicepre_track@nexus d on b.case_nbr = d.case_num
--    left join dw_owner.CHOICEpre_lookup_item@nexus h on d.enr_term_reason = h.item_value and h.lookup_group_id in (38, 40)
    -- get case numbers from case_facts
    left join choice.dim_member_enrollment@dlake dme on a.period_end_dl_enrl_sk = dme.dl_enrl_sk
    left join dw_owner.case_facts@nexus2 cf on dme.mrn = cf.mrn
                                            and a.five_lob_start_dt = cf.admission_date
                                            and a.five_lob_end_dt = cf.discharge_date
                                            and cf.program in ('VCC', 'VCT', 'VCP','VCM', 'EVP')
    left join dw_owner.choicepre_track@nexus peb on cf.case_num = peb.case_num    
    where extract(year from a.disenrollment_month) = 2017 
)
select *from dc_reason ;


