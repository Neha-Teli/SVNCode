/* Formatted on 4/15/2021 10:34:10 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW VW_ACTIVE_CLIENT
(
    CLIENTID,
    COMPANYID,
    FLAG,
    ADMISSIONID
)
BEQUEATH DEFINER
AS
    SELECT DISTINCT clientid,
                    SCHED_TABLE.companyid,
                    1     AS flag,
                    PAT_ADM.ADMISSIONID
      FROM PIC.SCHEDULES  SCHED_TABLE
           JOIN PIC.SCHEDULES_CLIENTS SCHED_CLIENT_TABLE
               ON (    SCHED_TABLE.SCHEDULEID = SCHED_CLIENT_TABLE.SCHEDULEID
                   AND SCHED_TABLE.status IN ('02', '03', '04')
                   AND SCHED_TABLE.EVVDURATION > 0
                   AND SCHED_TABLE.scheduledate BETWEEN TRUNC (SYSDATE) - 30
                                                    AND TRUNC (SYSDATE) + 14)
           LEFT JOIN PIC.PATIENT_ADMISSIONS PAT_ADM
               ON (SCHED_CLIENT_TABLE.ADMISSIONID = PAT_ADM.ADMISSIONID);
