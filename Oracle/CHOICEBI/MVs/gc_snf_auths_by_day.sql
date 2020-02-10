DROP MATERIALIZED VIEW GC_SNF_AUTHS_BY_DAY

CREATE MATERIALIZED VIEW GC_SNF_AUTHS_BY_DAY
BUILD IMMEDIATE
REFRESH FORCE
NEXT TRUNC(SYSDATE) + 1.25 
WITH PRIMARY KEY
AS 
WITH zzz_auths1 AS
         (SELECT unique_id,
                 auth_id,
                 auth_status_id,
                 auth_type_name,
                 provider_name,
                 auth_created_on,
                 auth_updated_on,
                 auth_created_by_name,
                 unit_type,
                 auth_code_ref_id,
                 TRUNC(service_from_date) AS service_from_date,
                 TRUNC(service_to_date) AS service_to_date,
                 TRUNC(service_to_date) - TRUNC(service_from_date) + 1 AS Days_of_Service,
                 current_requested
          FROM   choicebi.v_auth_data svc
          WHERE  auth_type_id IN (2, 3) -- 2-Inpatient - SNF, 3-Inpatient - Long Term Care Facility
           AND UPPER(SUBSTR( unique_id, 1, 1)) = 'V' -- get rid of test id
           AND AUTH_CODE_TYPE_ID = 1 -- 1-Procedure Code -- This is different from the auth for HHA, as I want to exclude medication and service category code for transp -- removes 26 records
           AND auth_status_id IN (1, 2, 6, 7) -- 1-Open, 2-Closed, 6- Closed and Adjusted, 7-ReOpen
           AND decision_status = 3 -- 3-Approved
                                                                                                                                                                  AND auth_created_on >= '01jan2015' --        and unit_type in('Hours', 'Days', 'Units')
                 AND unique_id IS NOT NULL),
     zzz_auths2 AS
         (SELECT   unique_id,
                   auth_id,
                   auth_status_id,
                   auth_type_name,
                   provider_name,
                   auth_created_on,
                   auth_created_by_name,
                   service_from_date,
                   service_to_date,
                   Days_of_Service,
                   COUNT(*) AS N_lines
          FROM     zzz_auths1
          GROUP BY unique_id,
                   auth_id,
                   auth_status_id,
                   auth_type_name,
                   provider_name,
                   auth_created_on,
                   auth_created_by_name,
                   service_from_date,
                   service_to_date,
                   Days_of_Service),
     zzz_auths3 AS
         (SELECT   day_date,
                   choice_week_id,
                   TO_CHAR( day_date, 'yyyymm') AS Month_id,
                   quarter_id,
                   unique_id,
                   auth_id,
                   auth_status_id,
                   auth_type_name,
                   provider_name,
                   auth_created_on,
                   auth_created_by_name,
                   service_from_date,
                   service_to_date,
                   days_of_service,
                   ROW_NUMBER() OVER (PARTITION BY unique_id ORDER BY day_date DESC) AS auth_day_seq_desc,
                   ROW_NUMBER() OVER (PARTITION BY unique_id, day_date ORDER BY auth_created_on DESC, service_from_date DESC) AS auth_seq_desc,
                   ROW_NUMBER() OVER (PARTITION BY unique_id, day_date, auth_type_name ORDER BY auth_created_on DESC, service_from_date DESC) AS auth_type_seq_desc
          FROM     zzz_auths2 a LEFT JOIN mstrstg.lu_day d ON (d.day_date BETWEEN service_from_date AND service_to_date)
          ORDER BY unique_id,
                   --auth_status_id,
                   day_date,
                   auth_created_on,
                   auth_created_by_name)
SELECT day_date,
       choice_week_id,
       Month_id,
       quarter_id,
       unique_id,
       auth_id,
       auth_status_id,
       auth_type_name,
       provider_name,
       auth_created_on,
       auth_created_by_name,
       service_to_date,
       service_from_date,
       days_of_service,
       auth_day_seq_desc
FROM   zzz_auths3
WHERE  auth_seq_desc = 1

GRANT SELECT ON GC_SNF_AUTHS_BY_DAY TO CHOICEBI_RO;

GRANT SELECT ON GC_SNF_AUTHS_BY_DAY TO MICHAEL_K;

GRANT SELECT ON GC_SNF_AUTHS_BY_DAY TO RESEARCH;

GRANT SELECT ON GC_SNF_AUTHS_BY_DAY TO ROC_RO;
