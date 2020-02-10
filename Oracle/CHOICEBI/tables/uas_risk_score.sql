drop table   choicebi.uas_risk_score;
/

create table choicebi.uas_risk_score (RECORD_ID number, RISK_GROUP number, RISK_SCORE number, CREATED_ON date, LAST_UPDATE_DATE date);
/

alter table choicebi.uas_risk_score add constraint pk_uas_risk_score primary key (RECORD_ID);
/

GRANT SELECT ON CHOICEBI.uas_risk_score TO RIPUL_P;
GRANT SELECT ON CHOICEBI.uas_risk_score TO MSTRSTG;
/