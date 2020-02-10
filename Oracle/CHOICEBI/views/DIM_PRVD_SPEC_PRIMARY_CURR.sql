create or replace view DIM_PRVD_SPEC_PRIMARY_CURR  as
with  DS_SUB1 as 
(
    select
        PROVIDER_ID,
        SRC_SYS,
        MIN(SPECIALITY_TYPE) SPECIALITY_TYPE
    from
        CHOICEBI.DIM_PROVIDER_SPECIALITY
    where
        DL_ACTIVE_REC_IND = 'Y' --506,863
        --and SPECIALITY_CODE is not null --484,313
    group by
        PROVIDER_ID,
        SRC_SYS
)
--Then we get the data for each record from the main table 
, DS2 as (
select
    DL_SPECIALITY_SK,
    b.PROVIDER_ID,
    b.SRC_SYS,
    NPI,
    ADDR_ID,
    b.SPECIALITY_TYPE,
    SPECIALITY_CODE,
    SPECIALITY_DESCRIPTION,
    TAXONOMY_CODE,
    DL_ACTIVE_REC_IND,
    DL_EFF_DT,
    DL_END_DT,
    DL_JOB_RUN_ID,
    DL_CRT_TS,
    DL_UPD_TS
from
    CHOICEBI.DIM_PROVIDER_SPECIALITY a,
    DS_SUB1 b
where
    a.DL_ACTIVE_REC_IND = 'Y' --506,863
    and a.PROVIDER_ID = b.PROVIDER_ID
    and a.SRC_SYS = b.SRC_SYS
    and a.SPECIALITY_TYPE = b.SPECIALITY_TYPE
)
select * from ds2;

grant select on DIM_PRVD_SPEC_PRIMARY_CURR  to mstrstg
