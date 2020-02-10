create or replace view v_auth_decision_document_mrg as
select
*  
from 
(
select
    row_number() over (partition by auth_no, decision_id order by  DOCUMENT_ID asc) seq,
    a.*, b.DOCUMENT_ID, b.LEVEL_ID,DOCUMENT_NAME, DOCUMENT_DESC,DOCUMENT_PATH,LETTER_PRINTED_DATE,LETTER_QUEUE_ID , b.CREATED_BY doc_created_by,b.created_on doc_create_date  
from 
    CMGC.UM_DECISION a
    --join  CMGC.UM_NOTE b on (auth_no = NOTE_REF_ID and b.created_on > AUTH_NOTI_DATE)
    join  (select * from CMGC.UM_DOCUMENT a14 where 1=1
                         and a14.DOCUMENT_TYPE_ID in (1002)
                         and a14.DOCUMENT_NAME not like '%Extension%'
                         and a14.DOCUMENT_NAME not like '%Test%'
          ) 
         b on (auth_no = DOCUMENT_REF_ID and b.created_on > AUTH_NOTI_DATE)
)
where 1=1
and AUTH_NOTI_DATE >= To_Date('01-01-2018', 'dd-mm-yyyy') 
order by 2, document_id asc

grant select on v_auth_decision_document_mrg to mstrstg




select * from v_auth_decision_document_mrg 
where auth_no = 315108 
--and seq = 1


select * from CMGC.UM_DECISION a