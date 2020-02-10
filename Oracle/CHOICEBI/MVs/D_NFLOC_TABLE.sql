--NFLOC Table for Leakage Dashboard
--Active MLTC Members

DROP MATERIALIZED VIEW F_NFLOC_MEMBERS_CURRENT;

CREATE MATERIALIZED VIEW F_NFLOC_MEMBERS_CURRENT
BUILD IMMEDIATE
REFRESH FORCE 
ON DEMAND
AS
select 
    *
from
(
    select to_date(f.month_id, 'yyyymm') as Census_month, f.medicaid_num, f.mrn
            , u.levelofcarescore level_of_care_score, u.assessmentdate assessment_date
            , row_number () over (partition by f.medicaid_num, f.month_id order by u.assessmentdate desc, u.record_id desc) as seq 
     from fact_member_month@ms_owner_rcprod f
     left join dw_owner.uas_pat_assessments u on (u.medicaidnumber1=f.medicaid_num and u.assessmentdate<=(add_months(to_date(f.month_id, 'yyyymm'), 1)-1))
     where to_date(f.month_id, 'yyyymm') in
                            (
                            (select max(to_date(month_id, 'yyyymm')) from fact_member_month@ms_owner_rcprod where projected=0)                  --Current Month
                           ,(select add_months(max(to_date(month_id, 'yyyymm')),-1) from fact_member_month@ms_owner_rcprod where projected=0)   --Last Month 
                           ,(select to_date(max(to_char(to_number(substr(month_id,1,4))-1) ||'12'),'yyyymm') from fact_member_month@ms_owner_rcprod where projected=0)           --Last Month Previous Year 
                           )
           and line_of_business='MLTC'         
)
where seq=1


--drop table view F_NFLOC_REASSESSED_MEMBERS

CREATE MATERIALIZED VIEW F_NFLOC_REASSESSED_MEMBERS
BUILD IMMEDIATE
REFRESH FORCE 
ON DEMAND
AS
select 
      to_date(f.month_id, 'yyyymm') as Census_month
    , f.mrn  
    , f.medicaid_num
    , u.levelofcarescore level_of_care_score
    , u.assessment_date
    , u2.levelofcarescore as level_of_care_score2
    , u2.assessment_date as assessment_date2
from fact_member_month@ms_owner_rcprod f
left join (select medicaidnumber1, levelofcarescore, assessmentdate assessment_date
               , dense_rank () over (partition by medicaidnumber1 order by assessmentdate desc) as seq 
               , row_number() over (partition by medicaidnumber1, assessmentdate
                    order by record_id desc) as assessment_seq 
            from dw_owner.uas_pat_assessments) u on (u.seq=1 and u.assessment_seq=1 and u.medicaidnumber1=f.medicaid_num)
left join (select medicaidnumber1, levelofcarescore, assessmentdate assessment_date
               , dense_rank () over (partition by medicaidnumber1 order by assessmentdate desc) as seq 
               , row_number() over (partition by medicaidnumber1, assessmentdate
                    order by record_id desc) as assessment_seq                        
            from dw_owner.uas_pat_assessments) u2 on (u2.seq=2 and u2.assessment_seq=1 and u2.medicaidnumber1=f.medicaid_num)                    
where f.month_id=(select max(month_id) from fact_member_month@ms_owner_rcprod where projected=0)
and u.levelofcarescore is not null
and u2.levelofcarescore is not null
and u.assessment_date                 < (select add_months(max(to_date(month_id, 'yyyymm')),1) from fact_member_month@ms_owner_rcprod where projected=0)
and to_char(u.assessment_date, 'yyyy')= (select substr(max(month_id), 1,4) from fact_member_month@ms_owner_rcprod where projected=0)
and line_of_business='MLTC' 
