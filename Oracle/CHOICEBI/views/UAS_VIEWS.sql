
SELECT 
    b.MEDICAIDNUMBER1,
    b.ASSESSMENTTYPE || ' - ' || c.description ASSESSMENTTYPE,
    b.RESIDENCEASSESSMENT  || ' - ' ||  d.description RESIDENCEASSESSMENT,
    b.LIVINGARRANGEMENT || ' - ' || e.description LIVINGARRANGEMENT,
    b.TXINFLUENZA,
    b.TXEMERGENCY,
    b.TXINPATIENT,
    b.LONELY,
    b.MOODSAD,
    b.SOCIALCHANGEACTIVITIES,
    b.TIMEALONE,
    b.LIFESTRESSORS,
    b.WITHDRAWAL,
    b.TIMEALONE,
    b.PAINCONTROL,
    b.PAINFREQUENCY,
    b.PAININTENSITY,
    b.DYSPNEA,
    b.BLADDERCONTINENCE,
    b.FALLS,
    b.FALLSNOINJ,
    b.FALLSMINORINJ,
    b.FALLSMAJORINJ,
    b.TXDENTAL,
    b.TXEYE,
    b.TXHEARING,
    b.TXMAMMOGRAM,
    b.TXPNEUMOVAX,
    b.LOCOMOTIONINDOORS,
    b.ADLLOCOMOTION,
    b.ADLBATHING,
    b.ADLHYGIENE
FROM      DW_OWNER.UAS_PAT_ASSESSMENTS A 
     join DW_OWNER.UAS_COMMUNITYHEALTH b on (a.record_id = b.record_id)
left join DIM_UAS_ASSESSMENT_REASON c on (b.ASSESSMENTTYPE = c.ASSESSMENTTYPE)
left join DIM_UAS_RESIDENCE_ASSESSMENT d on (b.RESIDENCEASSESSMENT = d.RESIDENCEASSESSMENT)
left join DIM_UAS_LIVING_ARRANGEMENT e  on (b.LIVINGARRANGEMENT = e.LIVINGARRANGEMENT)
WHERE  
    A.MEDICAIDNUMBER1 = 'DG33634A' AND A.RECORD_ID = 210129;


CREATE OR REPLACE VIEW DIM_UAS_ASSESSMENT_REASON AS
SELECT * FROM 
(
    SELECT 2 ASSESSMENTTYPE, 'Routine reassessment' DESCRIPTION FROM DUAL UNION ALL
    SELECT 1 , 'First assessment' DISCRIPTION FROM DUAL UNION ALL
    SELECT 4 , 'Significant change in status reassessment' DISCRIPTION FROM DUAL UNION ALL
    SELECT 3 , 'Return assessment' DISCRIPTION FROM DUAL
);


CREATE OR REPLACE VIEW DIM_UAS_RESIDENCE_ASSESSMENT AS 
SELECT * FROM 
(
    SELECT 1 RESIDENCEASSESSMENT, 'Private home / apartment / rented room' DESCRIPTION FROM DUAL UNION ALL
    SELECT 12,'Homeless (with or without shelter)' DESCRIPTION FROM DUAL UNION ALL
    SELECT 3,'Adult care facility with assisted living services' DESCRIPTION FROM DUAL UNION ALL
    SELECT 13,'Other' DESCRIPTION FROM DUAL UNION ALL
    SELECT 7,'Nursing home' DESCRIPTION FROM DUAL 
)


create or replace view DIM_UAS_LIVING_ARRANGEMENT as
select * from 
(
    select 4 LIVINGARRANGEMENT, 'With child (not spouse/partner)' description from dual union all
    select 7, 'With other relatives' description from dual union all
    select 1, 'Alone' description from dual union all
    select 2, 'With spouse/partner only' description from dual union all
    select 6, 'With sibling(s)' description from dual union all
    select 3, 'With spouse/partner and other(s)' description from dual union all
    select 5, 'With parent(s) or guardian(s)' description from dual union all
    select 8, 'With non-relative(s)' description from dual
)