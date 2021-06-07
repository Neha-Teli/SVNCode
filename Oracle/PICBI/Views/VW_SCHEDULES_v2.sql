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
                     JOIN (SELECT * FROM 
                            (SELECT C1.SCHEDULEID,CLIENTID,C1.eventid,C1.AUTHORIZATIONID,
								ROW_NUMBER () OVER (PARTITION BY C1.SCHEDULEID,CLIENTID,C1.eventid ORDER BY NVL (C1.AUTHORIZATIONID, -1) DESC)    AS RN
								FROM
								(SELECT SCHEDULEID,ADMISSIONID, MAX(CLIENTSCHEDDTLID ) AS MAX_CLIENTSCHEDDTLID
									FROM PIC.SCHEDULES_CLIENTS WHERE STATUS IN ('02','03','04')
									GROUP BY SCHEDULEID, ADMISSIONID) C --Added to pick record with latest EVENTID 
								JOIN PIC.SCHEDULES_CLIENTS C1
								ON C.SCHEDULEID =C1.SCHEDULEID
								AND C.MAX_CLIENTSCHEDDTLID = C1.CLIENTSCHEDDTLID
								JOIN PIC.PATIENT_ADMISSIONS P
								ON C.ADMISSIONID = P.ADMISSIONID 
								GROUP BY C1.SCHEDULEID,
										CLIENTID,
										C1.eventid,
										C1.AUTHORIZATIONID)
                          WHERE  RN  =1  --- ADDED TO PICK VALID AUTH ID WHEN TWO RECORDS
                          ) sc
                    ON s.scheduleid = sc.scheduleid
                     LEFT JOIN (SELECT SCHEDULEID, STAFFID FROM (SELECT SCHEDULEID, STAFFID, ROW_NUMBER() OVER (PARTITION BY SCHEDULEID ORDER BY SYS_UPD_TS DESC) AS SCHEDSTAFF_RN 
                                FROM PIC.SCHEDULES_STAFF WHERE STAFFSCHEDDTLID <> -99
								) A
                                WHERE A.SCHEDSTAFF_RN = 1 -- added RN to pick latest record
								)SS
                         ON S.SCHEDULEID = SS.SCHEDULEID
               WHERE     s.status IN ('02',
                                      '03',
                                      '04'
                                      --'01', '09'  REMOVING PENDING AND ON HOLD STATUS
                                      )
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
