/* Formatted on 3/11/2021 9:24:54 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW VW_SCHEDULES
(
    SCHEDULEID,
    SCHEDULEDATE,
    EVVDURATION_ORG,
    EVVDURATION,
    COMPANY,
    COMPANYID,
    STATUS,
    STAFFID,
    CLIENTID,
    AUTHORIZATIONID,
    AUTH_FLAG,
    CNT,
    LIVEIN_FLAG,
    VISIT_FLAG
)
BEQUEATH DEFINER
AS
      SELECT scheduleid,
             scheduledate,
             CASE
                 WHEN livein_flag = 1 THEN SUM (EVVDURATION) * 13 / 24 -- livein_evvduation_org
                 ELSE SUM (EVVDURATION)           -- NONLIVEIN_EVVDURATION_ORG
             END                                     AS EVVDURATION_ORG,
             CASE
                 WHEN livein_flag = 1
                 THEN
                     CASE
                         WHEN (SUM (EVVDURATION) * 13 / 24) > 13 THEN 13
                         ELSE SUM (EVVDURATION) * 13 / 24
                     END                               ---- LIVEIN_EVVDURATION
                 -- when livein_flag = 0 then
                 ELSE
                     CASE
                         WHEN SUM (EVVDURATION) > 24 THEN 24
                         ELSE SUM (EVVDURATION)
                     END                            ---- NONLIVEIN_EVVDURATION
             END                                     AS EVVDURATION,
             COMPANY,
             COMPANYID,
             status,
             NVL (staffid, -9999)                    STAFFID,
             clientid,
             AUTHORIZATIONID,
             DECODE (AUTHORIZATIONID, NULL, 0, 1)    auth_flag,
             COUNT (*)                               CNT,
             livein_flag,
             1                                       AS visit_flag
        FROM (SELECT /*+ no_merge use_hash(s sc ss) */
                     DISTINCT s.scheduleid,
                              scheduledate,
                              CASE
                                  WHEN sc.eventid IN ('MU', 'MMR', 'ML')
                                  THEN
                                      s.EVVDURATION / 2
                                  ELSE
                                      s.EVVDURATION
                              END    AS EVVDURATION,
                              COMPANY,
                              s.COMPANYID,
                              s.status,
                              SS.STAFFID,
                              sc.clientid,
                              sc.AUTHORIZATIONID,
                              sc.eventid,
                              CASE
                                  WHEN sc.eventid IN ('LI',
                                                      'MLI',
                                                      'CLI',
                                                      'ML')
                                  THEN
                                      1
                                  ELSE
                                      DECODE (sc.eventid, NULL, -99, 0)
                              END    AS livein_flag
                FROM PIC.SCHEDULES s
                     JOIN
                     (SELECT DISTINCT SCHEDULEID,
                                      CLIENTID,
                                      AUTHORIZATIONID,
                                      eventid
                        FROM PIC.SCHEDULES_CLIENTS C
                             JOIN PIC.PATIENT_ADMISSIONS P
                                 ON C.ADMISSIONID = P.ADMISSIONID --WHERE AUTHORIZATIONID IS NOT NULL
                                                                 ) sc
                         ON s.scheduleid = sc.scheduleid
                     LEFT JOIN PIC.SCHEDULES_STAFF SS
                         ON S.SCHEDULEID = SS.SCHEDULEID
               WHERE     s.status IN ('02',
                                      '03',
                                      '04',
                                      '01',
                                      '09')
                     AND s.serviceid IN ('HHA',
                                         'PCA',
                                         'PCW',
                                         'HSK'))
    GROUP BY SCHEDULEID,
             scheduledate,
             COMPANY,
             COMPANYID,
             status,
             staffid,
             clientid,
             AUTHORIZATIONID,
             livein_flag;
