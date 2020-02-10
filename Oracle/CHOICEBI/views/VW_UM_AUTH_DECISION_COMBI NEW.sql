DROP VIEW VW_UM_AUTH_DECISION_COMBI;

CREATE OR REPLACE VIEW VW_UM_AUTH_DECISION_COMBI
(
    DECISION_ID,
    DECISION_NO,
    AUTH_NO,
    PATIENT_ID,
    UNIQUE_ID,
    AUTH_NOTI_DATE,
    SERVICE_FROM_DATE,
    SERVICE_TO_DATE
) AS
/*
    SELECT DECISION_ID,
           DECISION_NO,
           b.AUTH_NO,
           b.PATIENT_ID,
           c.UNIQUE_ID,
           TRUNC(b.AUTH_NOTI_DATE) AUTH_NOTI_DATE,
           TRUNC(SERVICE_FROM_DATE) SERVICE_FROM_DATE,
           TRUNC(SERVICE_TO_DATE) SERVICE_TO_DATE
    FROM   CMGC.UM_AUTH b
           LEFT OUTER JOIN CMGC.UM_DECISION a ON (a.AUTH_NO = b.AUTH_NO)
           JOIN CMGC.PATIENT_DETAILS c ON (b.PATIENT_ID = c.PATIENT_ID)*/
    select decision_id,
           decision_no,
           b.auth_no,
           b.patient_id,
           b.subscriber_id unique_id,
           trunc(b.auth_noti_date) auth_noti_date,
           trunc(service_from_date) service_from_date,
           trunc(service_to_date) service_to_date
    from   
           --CMGC.UM_AUTH b
           --LEFT OUTER JOIN CMGC.UM_DECISION a ON (a.AUTH_NO = b.AUTH_NO)
           choice.fct_um_auth@dlake b
           left join choice.fct_um_decision@dlake a on (a.dl_um_auth_sk = b.dl_um_auth_sk);
--           join choice.dim_member@dlake c on (c.dl_member_sk = b.dl_member_sk)
    --CMGC.UM_DECISION b
    --WHERE a.AUTH_NO = b.AUTH_NO
      --     JOIN CMGC.PATIENT_DETAILS c ON (b.PATIENT_ID = c.PATIENT_ID);

GRANT SELECT ON VW_UM_AUTH_DECISION_COMBI TO MICHAEL_K;

GRANT SELECT ON VW_UM_AUTH_DECISION_COMBI TO MSTRSTG;

GRANT SELECT ON VW_UM_AUTH_DECISION_COMBI TO MSTRSTG2;
