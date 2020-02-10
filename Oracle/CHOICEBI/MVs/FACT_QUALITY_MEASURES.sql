DROP MATERIALIZED VIEW CHOICEBI.FACT_QUALITY_MEASURES;

CREATE MATERIALIZED VIEW CHOICEBI.FACT_QUALITY_MEASURES 
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
with fqm as
(
SELECT distinct a.*, SYSDATE SYS_UPD_TS
FROM   (SELECT 'PREV' MSR_TYPE,
               B.MSR_ID,
               A.MSR_TOKEN MSR_TOKEN,
               A.QIP_MONTH_ID MONTH_ID,
               A.QIP_PERIOD REPORTING_PERIOD_ID,
               A.SUBSCRIBER_ID,
               A.DL_MEMBER_SK,
               A.MEMBER_ID,
               A.DL_LOB_GRP_ID,
               A.ASSESSMENTDATE ASSESSMENT_DATE1,
               NULL ASSESSMENT_DATE2,
               A.ASSESSMENTREASON ASSESSMENT_REASON1,
               NULL ASSESSMENT_REASON2,
               A.RECORD_ID UAS_RECORD_ID1,
               NULL UAS_RECORD_ID2,
               A.ASSESSMONTH ASSESSMENT_MONTH,
               A.NEXT_DUE,
               A.NEXT_DUE_PERIOD,
               A.ONURSEORG VENDOR_ID,
               A.NUMERATOR,
               A.DENOMINATOR,
               A.DL_LOB_ID,
               A.DL_ENROLL_ID,
               --A.DL_ASSESS_SK,
               --A.DL_PROV_SK,
               --A.PROVIDER_ID,
               A.DL_PLAN_SK,
               A.ONURSEORGNAME,
               A.ONURSENAME
        FROM   V_QUALITY_PREVALENCE_MSR_LONG A
               JOIN DIM_QUALITY_MEASURES B
                   ON (UPPER(A.MSR_TOKEN) = UPPER(B.MSR_TOKEN))
        UNION ALL
        SELECT 'POT' MSR_TYPE,
               B.MSR_ID,
               A.MSR_TOKEN MSR_TOKEN,
               A.QIP_MONTH_ID MONTH_ID,
               A.QIP_PERIOD REPORTING_PERIOD_ID,
               A.SUBSCRIBER_ID,
               A.DL_MEMBER_SK,
               A.MEMBER_ID,
               A.DL_LOB_GRP_ID,
               A.ASSESSMENTDATE1 ASSESSMENT_DATE1,
               A.ASSESSMENTDATE2 ASSESSMENT_DATE2,
               A.ASSESSMENTREASON1 ASSESSMENT_REASON1,
               A.ASSESSMENTREASON2 ASSESSMENT_REASON2,
               A.RECORD_ID1 UAS_RECORD_ID1,
               A.RECORD_ID2 UAS_RECORD_ID2,
               A.ASSESSMONTH ASSESSMENT_MONTH,
               A.NEXT_DUE,
               A.NEXT_DUE_PERIOD,
               A.ONURSEORG VENDOR_ID,
               A.NUMERATOR,
               A.DENOMINATOR,
               A.DL_LOB_ID,
               A.DL_ENROLL_ID,
               --A.DL_ASSESS_SK,
               --A.DL_PROV_SK,
               --A.PROVIDER_ID,
               A.DL_PLAN_SK,
               A.ONURSEORGNAME,
               A.ONURSENAME
        FROM   V_QUALITY_POT_MSR_LONG A
               JOIN DIM_QUALITY_MEASURES B ON (UPPER(A.MSR_TOKEN) = UPPER(B.MSR_TOKEN))) A
) 
select a.*, b.risk, b.risk_note,  1 as seq
    from fqm a
    left join choicebi.fact_quality_risk_measures b on (a.dl_member_sk=b.dl_member_sk
                                                    and a.dl_plan_sk=b.dl_plan_sk
                                                    and a.dl_lob_id = b.dl_lob_id
                                                    and a.msr_id=b.msr_id
                                                    and a.uas_record_id1 = b.uas_record_id2
                                                    and a.denominator=1
                                                    )
    where a.msr_type='PREV'
union all
select * from 
   (select a.*, b.risk, b.risk_note
   , row_number() over (partition by a.dl_member_sk, a.dl_plan_sk, a.dl_lob_id, a.msr_id, a.uas_record_id2 order by b.uas_record_id2 desc nulls last) as seq
    from fqm a
    left join choicebi.fact_quality_risk_measures b on (a.dl_member_sk=b.dl_member_sk
                                                    and a.dl_plan_sk=b.dl_plan_sk
                                                    and a.dl_lob_id = b.dl_lob_id
                                                    and a.msr_id=b.msr_id
                                                    and a.uas_record_id2 = b.uas_record_id3
                                                    and a.denominator=1
                                                    )
    where a.msr_type='POT')
where seq=1
    ;



COMMENT ON MATERIALIZED VIEW CHOICEBI.FACT_QUALITY_MEASURES IS 'snapshot table for snapshot CHOICEBI.FACT_QUALITY_MEASURES';

GRANT SELECT ON CHOICEBI.FACT_QUALITY_MEASURES TO MSTRSTG WITH GRANT OPTION;
