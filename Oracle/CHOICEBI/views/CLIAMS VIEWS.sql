-----
create or replace view FCT_CLAIM_DIAGNOSIS    as select * from choice.FCT_CLAIM_DIAGNOSIS@dlake;
create or replace view FCT_CLAIM_FACETS      as select * from  choice.FCT_CLAIM_FACETS@dlake;
create or replace view FCT_CLAIM_HOSP_PROCEDURE    as select * from    choice.FCT_CLAIM_HOSP_PROCEDURE@dlake;
create or replace view FCT_CLAIM_LINE_DISALLOW_REASON    as select * from    choice.FCT_CLAIM_LINE_DISALLOW_REASON@dlake;
create or replace view FCT_CLAIM_LINE_FACETS    as select * from    choice.FCT_CLAIM_LINE_FACETS@dlake;
create or replace view FCT_CLAIM_LINE_UNIVERSE    as select * from    choice.FCT_CLAIM_LINE_UNIVERSE@dlake;
create or replace view FCT_CLAIM_PAYMENT    as select * from    choice.FCT_CLAIM_PAYMENT@dlake;
create or replace view FCT_CLAIM_UNIVERSE    as select * from    choice.FCT_CLAIM_UNIVERSE@dlake;
create or replace view FCT_CLAIM_VO     as select * from   choice.FCT_CLAIM_VO@dlake;
create or replace view FCT_CLAIM_LINE_VO    as select * from    choice.FCT_CLAIM_LINE_VO@dlake;
create or replace view FCT_CLAIM_HP     as select * from   choice.FCT_CLAIM_HP@dlake;
create or replace view FCT_CLAIM_LINE_HP    as select * from     choice.FCT_CLAIM_LINE_HP@dlake;
------
create or replace view REF_CLAIM_STATUS as select * from choice.REF_CLAIM_STATUS@dlake;
create or replace view REF_SERVICE_RULE as select * from choice.REF_SERVICE_RULE@dlake;
create or replace view REF_DIAGNOSIS_CODE as select * from choice.REF_DIAGNOSIS_CODE@dlake;
create or replace view REF_DISALLOW_REASON_CODE as select * from choice.REF_DISALLOW_REASON_CODE@dlake;
create or replace view REF_PROCEDURE_CODE as select * from choice.REF_PROCEDURE_CODE@dlake;
------
grant select on REF_CLAIM_STATUS  to mstrstg;
grant select on REF_SERVICE_RULE  to mstrstg;
grant select on REF_DIAGNOSIS_CODE  to mstrstg;
grant select on REF_DISALLOW_REASON_CODE to mstrstg;
grant select on REF_PROCEDURE_CODE to mstrstg;
grant select on FCT_CLAIM_DIAGNOSIS to mstrstg;
grant select on FCT_CLAIM_FACETS  to mstrstg;
grant select on FCT_CLAIM_HOSP_PROCEDURE to mstrstg;
grant select on FCT_CLAIM_LINE_DISALLOW_REASON to mstrstg;
grant select on FCT_CLAIM_LINE_FACETS to mstrstg;
grant select on FCT_CLAIM_LINE_UNIVERSE to mstrstg;
grant select on FCT_CLAIM_PAYMENT to mstrstg;
grant select on FCT_CLAIM_UNIVERSE to mstrstg;
grant select on FCT_CLAIM_VO to mstrstg;
grant select on FCT_CLAIM_LINE_VO to mstrstg;
grant select on FCT_CLAIM_HP to mstrstg;
grant select on FCT_CLAIM_LINE_HP to mstrstg;
------

create view REF_PLACE_OF_SERVICE as select * from choice.REF_PLACE_OF_SERVICE@dlake;

grant select on REF_PLACE_OF_SERVICE to mstrstg;

create view REF_REVENUE_CODE as select * from choice.REF_REVENUE_CODE@dlake;

grant select on REF_REVENUE_CODE to mstrstg;