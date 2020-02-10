DROP MATERIALIZED VIEW MV_HHA_CLAIM_DETAILS;

CREATE MATERIALIZED VIEW MV_HHA_CLAIM_DETAILS
BUILD IMMEDIATE
REFRESH FORCE
--START WITH TO_DATE('18-Jan-2100','dd-mon-yyyy')
NEXT TRUNC(SYSDATE) + 5000
WITH PRIMARY KEY
AS 
WITH zzz_claim AS
         (SELECT /*+ no_merge driving_site(c) */
                DISTINCT
                 c.member_id,
                 c.subscriber_id,
                 c.LOB,
                 c.product_id,
                 c.src_sys,
                 c.claim_id,
                 c.claim_modifier,
                 c.claim_id_base,
                 c.claim_status,
                 c.paid_dt,
                 c.paid_amt,
                 l.claim_line_seq_num,
                 l.service_id,
                 l.service_from_dt,
                 l.service_to_dt,
                 l.service_provider_id,
                 p.first_name,
                 l.charge_amt,
                 l.allowed_amt,
                 l.paid_amt AS line_paid_amt,
                 l.proc_cd,
                 l.units_allow,
                 (CASE
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1019') AND l.units_allow >= 800 THEN l.units_allow / 400 --15 minute code, for the special case caught
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1019') THEN l.units_allow / 4 --15 minute code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1020') AND l.units_allow <= 1 THEN l.units_allow * 13 -- per diem code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1020') AND l.units_allow > 1 THEN l.units_allow -- per diem code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1021') AND l.paid_amt / (NULLIF( l.units_allow / 4, 0)) BETWEEN 15 AND 30 THEN NULLIF( l.units_allow / 4, 0) --per visit code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1021') AND l.paid_amt / NULLIF( l.units_allow, 0) BETWEEN 15 AND 30 THEN NULLIF( l.units_allow, 0) --per visit code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('T1021') AND l.paid_amt / (NULLIF( l.units_allow * 13, 0)) BETWEEN 15 AND 30 THEN NULLIF( l.units_allow * 13, 0) --per visit code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('S9122') AND l.units_allow > 500 THEN l.units_allow / 100 -- per hour code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('S9122') THEN l.units_allow -- per hour code
                      WHEN SUBSTR( l.proc_cd, 1, 5) IN ('S5130') THEN l.units_allow / 4 --15 minute code
                      ELSE l.units_allow
                  END)
                     AS hours_allow,
                 c.dl_plan_sk,
                 d.program
          FROM   choice.fct_claim_universe@dlake c
                 /*claim line level tables start here*/
                 LEFT JOIN choice.fct_claim_line_universe@dlake l ON (c.claim_id = l.claim_id AND c.member_id = l.member_id)
                 LEFT JOIN (SELECT *
                            FROM   (SELECT provider_id,
                                           npi,
                                           first_name,
                                           ROW_NUMBER() OVER (PARTITION BY provider_id ORDER BY provider_id, npi, first_name) AS seq_key
                                    FROM   choice.dim_provider@dlake)
                            WHERE  seq_key = 1) p
                     ON (l.service_provider_id = p.provider_id)
                 JOIN CHOICE.REF_PLAN@dlake d ON (c.dl_plan_sk = d.dl_plan_sk)
          WHERE  1 = 1 AND c.claim_status IN ('02', 'P') AND c.claim_adjusted_to IS NULL -- latest version of the '02' claim
                                                                                        AND c.paid_amt > 0 /*claim not denied*/
                                                                                                          AND c.allowed_amt > 0 AND SUBSTR( l.proc_cd, 1, 5) IN ('T1019', 'T1020', 'T1021', 'S9122')
                 AND c.lob IN ('MLTC', 'FIDA', 'MA AND MLTC', 'MAP') AND l.service_from_dt >= '01jan2015' AND (l.paid_amt > 0 OR l.units_allow > 0)),
     zzz_hha_claim_details AS
         (SELECT   subscriber_id,
                   product_id,
                   service_from_dt,
                   SUM(CASE WHEN SUBSTR( proc_cd, 1, 5) IN ('T1021', 'S9122') THEN hours_allow ELSE 0 END) AS TMG_HHA,
                   SUM(CASE WHEN SUBSTR( proc_cd, 1, 5) IN ('T1019', 'T1020') THEN hours_allow ELSE 0 END) AS TMG_PCA,
                   SUM(hours_allow) AS TMG_Hours,
                   paid_amt AS claim_paid_amt_total,
                   line_paid_amt,
                   service_provider_id,
                   first_name,
                   dl_plan_sk,
                   program
          FROM     zzz_claim
          GROUP BY subscriber_id,
                   product_id,
                   service_from_dt,
                   paid_amt,
                   line_paid_amt,
                   service_provider_id,
                   first_name,
                   dl_plan_sk,
                   program)
SELECT a.*,
       SYS_CONTEXT( 'USERENV', 'OS_USER') CRTE_USR_ID,
       SYSDATE CRTE_TS,
       SYS_CONTEXT( 'USERENV', 'OS_USER') UPDT_USR_ID,
       SYSDATE UPDT_TS
FROM   zzz_hha_claim_details a;

GRANT SELECT ON MV_HHA_CLAIM_DETAILS TO CHOICEBI_RO;

GRANT SELECT ON MV_HHA_CLAIM_DETAILS TO MICHAEL_K;

GRANT SELECT ON MV_HHA_CLAIM_DETAILS TO RESEARCH;
