
create or replace view DIM_MEMBER_DETAILS_CURR
as 
select * from 
(
    select a.*, row_number() over (partition by  member_id order by DL_UPD_TS) seq 
    from choice.DIM_MEMBER_DETAIL@DLAKE a 
) 
where seq = 1


grant select on  DIM_MEMBER_DETAILS_CURR to mstrstg;


