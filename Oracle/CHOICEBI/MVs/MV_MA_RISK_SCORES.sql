DROP MATERIALIZED VIEW CHOICEBI.MV_MA_RISK_SCORES;

CREATE MATERIALIZED VIEW CHOICEBI.MV_MA_RISK_SCORES 
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
WITH RISK_CODE AS
         (SELECT /* materialize no_merge  */
                TRIM(code) code,
                 CODE_TYPE,
                 CODE_DESCRIPTION,
                 INDICATOR
          FROM   choicebi.ma_risk_score_codes),
     ndc AS
         (SELECT /*+ no_merge  */
                NM1_MEMB_NUM,
                   COUNT(*) AS Meds_N,
                   CASE WHEN COUNT(*) >= 8 THEN 1 ELSE 0 END AS Meds_8plus_Ind,
                   CASE
                       WHEN SUM(
                                CASE
                                    WHEN INDICATOR = 'Antipsychotic' THEN N
                                    ELSE 0
                                END) >= 1 THEN
                           1
                       ELSE
                           0
                   END
                       AS RX_Antipsychotic_Ind,
                   SUM(CASE WHEN INDICATOR = 'Antipsychotic' THEN N ELSE 0 END)
                       AS RX_Antipsychotic_Clms_N
          FROM     (SELECT   NM1_MEMB_NUM,
                             mi.nd0_prodname,
                             mi.nd0_prodid,
                             ndc.INDICATOR,
                             COUNT(*) AS N
                    FROM     (SELECT /*+ no_merge  */
                                    SUBSTR(mi.NM1_MEMB_NUM, 1, 9) NM1_MEMB_NUM,
                                     nd0_prodname,
                                     TRIM(mi.nd0_prodid) nd0_prodid
                              FROM   vns_choice1.claims_mi mi
                              WHERE  clm_service_dt >
                                         ADD_MONTHS(TRUNC(SYSDATE), -24)) mi
                             LEFT JOIN RISK_CODE ndc
                                 ON (    mi.nd0_prodid = ndc.code
                                     AND ndc.code_type = 'NDC')
                    --where  clm_service_dt between add_months(trunc(sysdate), -24) and trunc(sysdate)
                    GROUP BY mi.NM1_MEMB_NUM,
                             mi.nd0_prodname,
                             mi.nd0_prodid,
                             ndc.INDICATOR)
          GROUP BY NM1_MEMB_NUM),
     cpt AS
         (SELECT /*+ no_merge materialize */
                meme_ck,
                   CASE
                       WHEN SUM(
                                CASE
                                    WHEN INDICATOR = 'Oxygen Use' THEN N
                                    ELSE 0
                                END) >= 1 THEN
                           1
                       ELSE
                           0
                   END
                       AS CPT_Oxygen_Use_Ind,
                   SUM(CASE WHEN INDICATOR = 'Oxygen Use' THEN N ELSE 0 END)
                       AS CPT_Oxygen_Use_Clms_N
          FROM     (SELECT /*+ no_merge ordered  */
                          cpt.meme_ck,
                             substr_ipcd_cd,
                             cpt2.ipcd_desc,
                             cpt_c.INDICATOR,
                             COUNT(*) AS N
                    FROM     (SELECT /*+ no_merge */
                                    meme_ck,
                                     SUBSTR(UPPER(cpt.ipcd_id), 1, 5)
                                         substr_ipcd_cd,
                                     TRIM(cpt.ipcd_id) ipcd_id
                              FROM   TMG.CMC_CDML_CL_LINE cpt
                              WHERE  (   cpt.cdml_from_dt BETWEEN ADD_MONTHS(
                                                                      TRUNC(
                                                                          SYSDATE),
                                                                      -24)
                                                              AND TRUNC(SYSDATE)
                                      OR cpt.cdml_to_dt BETWEEN ADD_MONTHS(
                                                                    TRUNC(
                                                                        SYSDATE),
                                                                    -24)
                                                            AND TRUNC(SYSDATE))) cpt
                             LEFT JOIN tmg.cmc_ipcd_proc_cd cpt2
                                 ON (    cpt.ipcd_id = TRIM(cpt2.ipcd_id)
                                     AND TRIM(cpt2.ipcd_id) IS NOT NULL)
                             LEFT JOIN RISK_CODE cpt_c
                                 ON (    substr_ipcd_cd = cpt_c.code
                                     AND code_type = 'CPT')
                    GROUP BY cpt_c.INDICATOR,
                             cpt.meme_ck,
                             cpt.ipcd_id,
                             substr_ipcd_cd,
                             cpt2.ipcd_desc)
          GROUP BY meme_ck),
     dx AS
         (SELECT /*+ no_merge materialize  */
                meme_ck,
                   CASE
                       WHEN SUM(CASE WHEN INDICATOR = 'ESRD' THEN N ELSE 0 END) >=
                                1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_ESRD_Ind,
                   SUM(CASE WHEN INDICATOR = 'ESRD' THEN N ELSE 0 END)
                       AS DX_ESRD_Clms_N,
                   CASE
                       WHEN SUM(
                                CASE
                                    WHEN INDICATOR = 'Diabetes' THEN N
                                    ELSE 0
                                END) >= 1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_Diabetes_Ind,
                   SUM(CASE WHEN INDICATOR = 'Diabetes' THEN N ELSE 0 END)
                       AS DX_Diabetes_Clms_N,
                   CASE
                       WHEN SUM(CASE WHEN INDICATOR = 'COPD' THEN N ELSE 0 END) >=
                                1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_COPD_Ind,
                   SUM(CASE WHEN INDICATOR = 'COPD' THEN N ELSE 0 END)
                       AS DX_COPD_Clms_N,
                   CASE
                       WHEN SUM(CASE WHEN INDICATOR = 'CHF' THEN N ELSE 0 END) >=
                                1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_CHF_Ind,
                   SUM(CASE WHEN INDICATOR = 'CHF' THEN N ELSE 0 END)
                       AS DX_CHF_Clms_N,
                   CASE
                       WHEN SUM(CASE WHEN INDICATOR = 'CAD' THEN N ELSE 0 END) >=
                                1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_CAD_Ind,
                   SUM(CASE WHEN INDICATOR = 'CAD' THEN N ELSE 0 END)
                       AS DX_CAD_Clms_N,
                   CASE
                       WHEN SUM(
                                CASE
                                    WHEN INDICATOR = 'Hypertension' THEN N
                                    ELSE 0
                                END) >= 1 THEN
                           1
                       ELSE
                           0
                   END
                       AS DX_Hypertension_Ind,
                   SUM(CASE WHEN INDICATOR = 'Hypertension' THEN N ELSE 0 END)
                       AS DX_Hypertension_Clms_N
          FROM     (SELECT   a.meme_ck,
                             d.idcd_id,
                             dx.INDICATOR,
                             COUNT(*) AS N
                    FROM     (SELECT /*+ no_merge */
                                    meme_ck, clcl_id
                              FROM   tmg.Cmc_clcl_claim
                              WHERE  (   clcl_low_svc_dt BETWEEN ADD_MONTHS(
                                                                     TRUNC(
                                                                         SYSDATE),
                                                                     -24)
                                                             AND TRUNC(SYSDATE)
                                      OR clcl_high_svc_dt BETWEEN ADD_MONTHS(
                                                                      TRUNC(
                                                                          SYSDATE),
                                                                      -24)
                                                              AND TRUNC(SYSDATE))) a
                             JOIN tmg.Cmc_clmd_diag D
                                 ON (    a.meme_ck = d.meme_ck
                                     AND a.clcl_id = D.clcl_id)
                             LEFT JOIN
                             RISK_CODE dx
                                 ON (    TRIM(d.idcd_id) =
                                             REPLACE(TRIM(dx.code), '.', '')
                                     AND dx.code_type = 'ICD10')
                    GROUP BY a.meme_ck, d.idcd_id, dx.INDICATOR)
          GROUP BY meme_ck)
SELECT hosp.*        /*hosp.Unique_Id needed for File Load into Guiding Care*/
             ,
       cpt.CPT_Oxygen_Use_Clms_N,
       cpt.CPT_Oxygen_Use_Ind,
       dx.DX_ESRD_Clms_N,
       dx.DX_ESRD_Ind,
       dx.DX_Diabetes_Clms_N,
       dx.DX_Diabetes_Ind,
       dx.DX_CHF_Clms_N,
       dx.DX_CHF_Ind,
       dx.DX_COPD_Clms_N,
       dx.DX_COPD_Ind,
       dx.DX_CAD_Clms_N,
       dx.DX_CAD_Ind,
       dx.DX_Hypertension_Clms_N,
       dx.DX_Hypertension_Ind,
       rx.RX_Antipsychotic_Clms_N,
       rx.RX_Antipsychotic_Ind,
       rx.Meds_N,
       rx.Meds_8plus_Ind,
         IP_Adm_1plus_12Mnts_Ind
       + SNF_Adm_1plus_12Mnts_Ind
       + ER_Visits_1plus_12Mnts_Ind
       + CHHA_Adm_1plus_12Mnts_Ind
       + CPT_Oxygen_Use_Ind
       + DX_ESRD_Ind
       + DX_Diabetes_Ind
       + DX_CHF_Ind
       + DX_COPD_Ind
       + DX_CAD_Ind
       + DX_Hypertension_Ind
       + RX_Antipsychotic_Ind
       + Meds_8plus_Ind
           AS Total_Num_Indicators /* intervention driven groupers as of: 2016/09/23*/
                                  /*HIGH*/
       ,
       CASE
           WHEN     IP_Adm_3plus_6Mnts_Ind = 1
                AND ER_Visits_1plus_6Mnts_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS High1_Ind,
       CASE WHEN CPT_Oxygen_Use_Ind = 1 THEN 1 ELSE 0 END AS High2_Ind,
       CASE
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1
           ELSE
               0
       END
           AS High3_Ind,
       CASE
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND RX_Antipsychotic_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS High4_Ind,
       CASE
           WHEN     CHHA_Adm_1plus_12Mnts_Ind = 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1
           ELSE
               0
       END
           AS High5_Ind,
       CASE
           WHEN     RX_Antipsychotic_Ind = 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1
           ELSE
               0
       END
           AS High6_Ind                                    --/*MEDIUM RISING*/
                       ,
       CASE
           WHEN     IP_Adm_1plus_12Mnts_Ind = 1
                AND ER_Visits_3plus_12Mnts_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS MedR1_Ind,
       CASE
           WHEN     (   (    DX_Diabetes_Ind = 1
                         AND DX_Hypertension_Ind = 1)
                     OR DX_CAD_Ind = 1)
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1
           ELSE
               0
       END
           AS MedR2_Ind,
       CASE
           WHEN     (   (    DX_Diabetes_Ind = 1
                         AND DX_Hypertension_Ind = 1)
                     OR DX_CAD_Ind = 1)
                AND CHHA_Adm_1plus_12Mnts_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS MedR3_Ind,
       CASE
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND Meds_8plus_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS MedR4_Ind                                           --/*MEDIUM*/
                       ,
       CASE
           WHEN (   (    DX_Diabetes_Ind = 1
                     AND DX_Hypertension_Ind = 1)
                 OR DX_CAD_Ind = 1) THEN
               1
           ELSE
               0
       END
           AS Med1_Ind,
       CASE
           WHEN     DX_CAD_Ind = 1
                AND SNF_Adm_1plus_12Mnts_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS Med2_Ind,
       CASE
           WHEN     (    DX_Diabetes_Ind = 1
                     AND DX_Hypertension_Ind = 1)
                AND SNF_Adm_1plus_12Mnts_Ind = 1 THEN
               1
           ELSE
               0
       END
           AS Med3_Ind                     /*For File Load into Guiding Care*/
                      /*Risk_type_id=1=VNS Internal Calculation*/
       ,
       1 AS Risk_type_id            /*Needed for File Load into Guiding Care*/
                        /*Member Risk Score*/
       ,
       CASE
           WHEN     IP_Adm_3plus_6Mnts_Ind = 1
                AND ER_Visits_1plus_6Mnts_Ind = 1 THEN
               1.1
           WHEN CPT_Oxygen_Use_Ind = 1 THEN
               1.2
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1.3
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND RX_Antipsychotic_Ind = 1 THEN
               1.4
           WHEN     CHHA_Adm_1plus_12Mnts_Ind = 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1.5
           WHEN     RX_Antipsychotic_Ind = 1
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               1.6
           WHEN     IP_Adm_1plus_12Mnts_Ind = 1
                AND ER_Visits_3plus_12Mnts_Ind = 1 THEN
               2.1
           WHEN     (   (    DX_Diabetes_Ind = 1
                         AND DX_Hypertension_Ind = 1)
                     OR DX_CAD_Ind = 1)
                AND (   IP_Adm_1plus_6Mnts_Ind = 1
                     OR ER_Visits_1plus_6Mnts_Ind = 1) THEN
               2.2
           WHEN     (   (    DX_Diabetes_Ind = 1
                         AND DX_Hypertension_Ind = 1)
                     OR DX_CAD_Ind = 1)
                AND CHHA_Adm_1plus_12Mnts_Ind = 1 THEN
               2.3
           WHEN       NVL(DX_ESRD_Ind, 0)
                    + NVL(DX_CHF_Ind, 0)
                    + NVL(DX_COPD_Ind, 0) >= 1
                AND Meds_8plus_Ind = 1 THEN
               2.4
           WHEN (   (    DX_Diabetes_Ind = 1
                     AND DX_Hypertension_Ind = 1)
                 OR DX_CAD_Ind = 1) THEN
               3.1
           WHEN     DX_CAD_Ind = 1
                AND SNF_Adm_1plus_12Mnts_Ind = 1 THEN
               3.2
           WHEN     (    DX_Diabetes_Ind = 1
                     AND DX_Hypertension_Ind = 1)
                AND SNF_Adm_1plus_12Mnts_Ind = 1 THEN
               3.3
           ELSE
               5.0
       END
           AS Risk_Score_Value      /*Needed for File Load into Guiding Care*/
                              ,
       TRUNC(SYSDATE) AS Created_On /*Needed for File Load into Guiding Care*/
                                   ,
       1 FLAG
FROM   MV_HOSP_ELIG hosp
       LEFT JOIN cpt ON (hosp.meme_ck = cpt.meme_ck)
       LEFT JOIN dx ON (hosp.meme_ck = dx.meme_ck)
       LEFT JOIN ndc rx ON (hosp.Unique_Id = rx.NM1_MEMB_NUM);


COMMENT ON MATERIALIZED VIEW CHOICEBI.MV_MA_RISK_SCORES IS 'snapshot table for snapshot CHOICEBI.MV_MA_RISK_SCORES';

GRANT SELECT ON CHOICEBI.MV_MA_RISK_SCORES TO CHOICEBI_RO;

GRANT SELECT ON CHOICEBI.MV_MA_RISK_SCORES TO DW_OWNER;

GRANT SELECT ON CHOICEBI.MV_MA_RISK_SCORES TO MSTRSTG;

GRANT SELECT ON CHOICEBI.MV_MA_RISK_SCORES TO ROC_RO;