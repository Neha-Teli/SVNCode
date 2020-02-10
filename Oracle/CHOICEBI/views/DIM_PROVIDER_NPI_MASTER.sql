create view DIM_PROVIDER_NPI_MASTER as
select
    distinct (NPI),
    MIN(NVL(PRACTICE_OFFICE_NAME, LEGAL_NAME)) PROIVDER_DSIPLAY_NAME
from
    CHOICEBI.DIM_PROVIDER  
group by
    NPI



grant select on DIM_PROVIDER_NPI_MASTER to MSTRSTG