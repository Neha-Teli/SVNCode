DROP MATERIALIZED VIEW  mv_pic_stafF

create materialized view mv_pic_staff as 
select STAFFID, FIRSTNAME, LASTNAME, SOE, EOE, REHIREDATE, POSITION, STATUS from PIC.STAFF where staffid in (select distinct staffid from v_pic_staff_client_mvmt)

GRANT SELECT ON mv_pic_staff TO ROC_RO

SELECT * FROM mv_pic_staff

select * From V_PIC_STAFF_CLIENT_MVMT

create or replace view V_PIC_STAFF_CLIENT_MVMT 
as 
select 
    month_id,
    A.vpin,
    staffid,
    sum(HHA_HOURS) HHA_HOURS,
    min(scheduledate) min_scheduledate,
    max(scheduledate) max_scheduledate
from mv_pic_staff_client a
group by 
    month_id,
    A.vpin,
    staffid
    
GRANT SELECT ON V_PIC_STAFF_CLIENT_MVMT TO ROC_RO
    

drop materialized view mv_pic_staff_client 

create materialized view mv_pic_staff_client as select * from v_pic_staff_client_data

create or replace view v_pic_staff_client_data as 
SELECT /*+ materialize no_merge  */ 
    TO_CHAR(B1.SCHEDULEDATE,'YYYYMM') MONTH_ID,
    B1.SCHEDULEDATE,
    B1.SCHEDULEID,
    d.clientid,
    d.admissionid,
    E.VPIN,
    A.STAFFID,
    B1S.DESCRIPTION SCHEDULE_STATUS_DESC,
    BS.DESCRIPTION  STAFF_STATUS_DESC,
    B1.STATUS   SCHEDULE_STATUS,
    B.STATUS    STAFF_STATUS,
    min(b1.scheduledate) min_schdule_date,
    max(b1.scheduledate) max_schdule_date,
    SUM(
    NVL2(LIVEIN_EVVDURATION, NONLIVEIN_EVVDURATION, B1.EVVDURATION)
    ) HHA_HOURS
    --A.EOE, A.REHIREDATE,  C.ADMISSIONID, CHARTID, D.CLIENTID,
FROM     PIC.STAFF A
    JOIN PIC.SCHEDULES_STAFF B ON (A.STAFFID = B.STAFFID)
    JOIN PIC.SCHEDULES B1 ON (B.SCHEDULEID = B1.SCHEDULEID)
    JOIN PIC.SCHEDULES_CLIENTS C ON (B.SCHEDULEID = C.SCHEDULEID)
    JOIN PIC.PATIENT_ADMISSIONS D ON (D.ADMISSIONID = C.ADMISSIONID)
    JOIN PIC.PATIENTS E ON (D.CLIENTID = E.CLIENTID)
    join HHAX.PATIENT_DEMOGRAPHICS_CHOICE HHAXCHOICE ON (HHAXCHOICE.VPIN = e.VPIN)
    LEFT JOIN PICBI.VW_SCHEDULE_LIVEIN F ON (B1.SCHEDULEID  = F.SCHEDULEID AND B1.SCHEDULEDATE = F.SCHEDULEDATE)
    LEFT JOIN PICBI.VW_SCHEDULE_NON_LIVEIN F1 ON (B1.SCHEDULEID  = F1.SCHEDULEID AND B1.SCHEDULEDATE = F1.SCHEDULEDATE)
    left join V_PIC_SCHEDULE_HEAD_STATUS b1s on (b1s.status = b1.status)
    left join V_PIC_SCHEDULE_STAFF_STATUS bs on (bs.status = b.status)
WHERE A.EOE BETWEEN '01jan2016' AND SYSDATE
AND B1.STATUS  IN ('02','03','04')  --02 Confirmed, 03 - In Process, 04 - Closed
AND B.STATUS IN ('02','03','04','05') -- 02 confirmed, 03 Billable, 04 Billed, 05 Paid
and position not in ('OFC','MGR','TRN')
GROUP BY 
    TO_CHAR(B1.SCHEDULEDATE,'YYYYYMM'),
    B1.SCHEDULEDATE,
    B1.SCHEDULEID,
    d.clientid,
    d.admissionid,
    E.VPIN,
    A.STAFFID,
    B.STATUS ,
    bs.description,
    B1.STATUS,
    B1S.DESCRIPTION
ORDER BY 
    MONTH_ID DESC, 
    VPIN