DROP VIEW CHOICEBI.FACT_COMPLIANCE_UAS_V1;

CREATE OR REPLACE FORCE VIEW CHOICEBI.FACT_COMPLIANCE_UAS_V1
(
    MEMBER_ID,
    ENROLL_SEQ,
    MLTC_PERSPECTIVE,
    MLTC_PERS_REFERRAL_DATE,
    MLTC_PERS_START_DT,
    MLTC_PERS_END_DT,
    REFERRAL_DATE,
    REFERRAL_DATE_V2,
    FIVE_LOB_PERSPECTIVE,
    FIVE_LOB_START_DT,
    FIVE_LOB_END_DT,
    SUBJ90RULE_IND,
    ASSESSMENTDATE,
    DL_ASSESS_SK,
    DUE_MONTH_FROM_PRIOR,
    DUE_MONTH_FROM_PRIOR_V1,
    NEXT_DUE,
    NEXT_DUE_V1,
    ASSESS_ENROLL_SEQ,
    ASSESS_ENROLL_SEQ_DESC,
    ASSESS_ENROLL_SEQ_V1
) AS
with enroll as
(
select a.member_id
    , dense_rank () over (partition by a.member_id  order by mltc_pers_start_dt) as enroll_seq
    , mltc_perspective, mltc_pers_start_dt, mltc_pers_end_dt
    , min(coalesce(cf.referral_date, b.referral_date)) over (partition by a.member_id, mltc_pers_start_dt) as mltc_pers_referral_date
    , FIVE_lob_perspective, FIVE_lob_start_dt, FIVE_lob_end_dt
    , coalesce(cf.referral_date, b.referral_date) as referral_date
    , case when  min(coalesce(cf.referral_date, b.referral_date)) 
                    over (partition by a.member_id, mltc_pers_start_dt)=coalesce(cf.referral_date, b.referral_date) then coalesce(cf.referral_date, b.referral_date)
           else FIVE_lob_start_dt
      end as referral_date_v2
----TEMPORARY!!
    , case when b.mrn in(1529321,
                        1887701,
                        3086834,
                        3077866,
                        3086495,
                        1612665,
                        3005355,
                        908715,
                        3084879,
                        1693121,
                        1912068,
                        1432251,
                        3094318,
                        3082040,
                        3090277,
                        3087995)
                and mltc_pers_start_dt>='01jul2017' 
                and FIVE_LOB_PERSPECTIVE ='MLTC' then 'Y'
           when mltc_pers_start_dt>='01jul2017' and FIVE_LOB_PERSPECTIVE='MLTC' then 'N'
      end as subj90rule_ind
--    , subj90rule_ind
from CHOICEBI.FACT_MEMBER_ENROLL_DISENROLL  a
left join choicebi.fact_member_month b on(a.dl_enroll_id=b.dl_enroll_id)
left join (select mrn, admission_date, referral_status, referral_date
                , case when program in('VCC', 'VCP','VCM', 'EVP') then 2
                       when program in('VCT') then 5
                       when program in('VCF') then 4
                  end as dl_lob_id               
           from dw_owner.case_facts
           where referral_status in('A','D')
            and program in('VCC', 'VCP','VCM', 'EVP', 'VCT', 'VCF')
           ) cf on(cf.mrn=b.mrn 
                     and cf.admission_date=b.enrollment_date
                     and cf.dl_lob_id=b.dl_lob_id
                  )
where MLTC_PERSPECTIVE='MLTC'
group by a.member_id, mltc_perspective, mltc_pers_start_dt, mltc_pers_end_dt
    , FIVE_lob_perspective, FIVE_lob_start_dt, FIVE_lob_end_dt, coalesce(cf.referral_date, b.referral_date)
    , case when b.mrn in(1529321,
                        1887701,
                        3086834,
                        3077866,
                        3086495,
                        1612665,
                        3005355,
                        908715,
                        3084879,
                        1693121,
                        1912068,
                        1432251,
                        3094318,
                        3082040,
                        3090277,
                        3087995)
                and mltc_pers_start_dt>='01jul2017' 
                and FIVE_LOB_PERSPECTIVE ='MLTC' then 'Y'
           when mltc_pers_start_dt>='01jul2017' and FIVE_LOB_PERSPECTIVE='MLTC' then 'N'
      end
order by a.member_id, mltc_pers_start_dt, mltc_pers_end_dt
    , FIVE_lob_start_dt, FIVE_lob_end_dt, coalesce(cf.referral_date, b.referral_date)
)
, assess as 
(
SELECT member_id
    , assessmentdate
    , max(dl_assess_sk) as dl_assess_sk
--    , ROW_NUMBER () OVER (PARTITION BY member_id
--                      ORDER BY assessmentdate)
--                   AS assess_seq
    , lag(TO_DATE(TO_CHAR (ADD_MONTHS (assessmentdate, 6), 'yyyymm'), 'yyyymm')) over (partition by member_id order by assessmentdate) as DUE_MONTH_FROM_PRIOR
    , TO_DATE(TO_CHAR (ADD_MONTHS (assessmentdate, 6), 'yyyymm'), 'yyyymm') as NEXT_DUE
FROM choice.dim_member_assessments@dlake
GROUP BY member_id,
    assessmentdate    
)
select a.member_id
    , enroll_seq
    , mltc_perspective
    , mltc_pers_referral_date, mltc_pers_start_dt, mltc_pers_end_dt
    , referral_date, referral_date_v2
    , FIVE_lob_perspective, FIVE_lob_start_dt, FIVE_lob_end_dt
    , subj90rule_ind    
    , b.assessmentdate
    , b.dl_assess_sk
--    , b.assess_seq
    , b.DUE_MONTH_FROM_PRIOR
    , case when b.DUE_MONTH_FROM_PRIOR is null then last_value(b.DUE_MONTH_FROM_PRIOR ignore nulls)  over 
                                                       (partition by a.member_id order by five_lob_start_dt, assessmentdate)
           else b.DUE_MONTH_FROM_PRIOR 
      end as DUE_MONTH_FROM_PRIOR_V1
    , b.NEXT_DUE 
    , case when b.next_due is null then last_value(b.next_due ignore nulls)  over (partition by a.member_id order by five_lob_start_dt, assessmentdate)
           else b.NEXT_DUE 
      end as NEXT_DUE_V1
    , ROW_NUMBER () OVER (PARTITION BY a.member_id, mltc_pers_start_dt ORDER BY five_lob_start_dt, assessmentdate) AS assess_enroll_seq  
    , ROW_NUMBER () OVER (PARTITION BY a.member_id, mltc_pers_start_dt ORDER BY five_lob_start_dt, assessmentdate desc) AS assess_enroll_seq_desc 
    , DENSE_RANK () OVER (PARTITION BY a.member_id, mltc_pers_start_dt ORDER BY assessmentdate) AS assess_enroll_seq_v1                       
from enroll a
left join assess b on(a.member_id=b.member_id
                       and assessmentdate>=referral_date_v2
                       and assessmentdate<=five_lob_end_dt)
where mltc_pers_end_dt>'01jan2016'
order by a.member_id, mltc_pers_start_dt, five_lob_start_dt, assessmentdate, referral_date
