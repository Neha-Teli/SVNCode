create view V_UAS_RISK_SCORE_LATEST as 
select * from uas_risk_score where mercer_doc_year = (select max(mercer_doc_year) from uas_risk_score)

grant select on V_UAS_RISK_SCORE_LATEST to mstrstg