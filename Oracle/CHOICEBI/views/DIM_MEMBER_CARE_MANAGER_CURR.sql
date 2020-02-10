create view DIM_MEMBER_CARE_MANAGER_CURR as
select * from  
(select a.*,row_number() over (partition by MEMBER_ID  order by DL_UPD_TS desc) seq from mstrstg.DIM_MEMBER_CARE_MANAGER a)
where 
seq = 1;


grant select on DIM_MEMBER_CARE_MANAGER_CURR to mstrstg;