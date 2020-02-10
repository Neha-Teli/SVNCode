DROP MATERIALIZED VIEW CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM;

CREATE MATERIALIZED VIEW CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
SELECT /*+ driving_site(a) parallel(a 2) */
      DISTINCT TO_NUMBER(TO_CHAR(cdml_from_dt, 'YYYYMM')) month_id,
               A.CLCL_CL_TYPE,
               A.CLCL_CL_SUB_TYPE,
               A.meme_ck,
               B.CDML_CUR_STS,
               A.sbsb_ck,
               A.clcl_id,
               A.pdpd_id,
               A.CLCL_RECD_DT AS receivedt,
               A.CLCL_PAID_DT AS PaidDate,
               a.CLCL_TOT_PAYABLE,
               B.CDML_PAID_AMT,
               B.cdml_units,
               B.cdml_units_allow,
               B.sese_id,
               B.CDML_SEQ_NO,
               B.prpr_id,
               B.CDML_POS_IND,
               SUBSTR(B.ipcd_id, 1, 5) AS CPT,
               B.ipcd_id,
               B.cdml_from_dt AS claimfromdt,
               B.cdml_to_dt AS claimtodt,
               b.cdml_allow,
               SUBSTR(C.CLHP_FAC_TYPE, 2, 1) AS fac_type,
               --catt(CLHP_FAC_TYPE,CLHP_BILL_CLASS,CLHP_FREQUENCY) as billtype,
               CLHP_FAC_TYPE ||
               CLHP_BILL_CLASS ||
               CLHP_FREQUENCY
                   AS billtype,
               B.rcrc_id,
               B.pscd_id,
               C.agrg_id,
               C.clhp_input_agrg_id,
               D.sbsb_id,
               F.MEME_MEDCD_NO,
               F.MEME_BIRTH_DT AS DOB,
               SUBSTR(B.prpr_id, 1, 9) AS prpr_id2,
               G.prpr_name,
               G.prpr_mctr_type,
               G.prcf_mctr_spec,
               H.seds_desc,
               I.PSCD_DESC,
               UPPER(J.IPCD_DESC) AS IPCD_DESC1,
               a.cscs_id lob_id,
               a.pdpd_id PRODUCT_ID
FROM   tmg.cmc_clcl_claim@nexus2 A
       JOIN tmg.Cmc_cdml_cl_line@nexus2 B ON A.clcl_id = B.clcl_id
       LEFT JOIN tmg.cmc_clhp_hosp@nexus2 C ON A.clcl_id = C.clcl_id
       LEFT JOIN tmg.cmc_sbsb_subsc@nexus2 D ON A.sbsb_ck = D.sbsb_ck
       LEFT JOIN tmg.cmc_meme_member@nexus2 F ON A.meme_ck = F.meme_ck
       LEFT JOIN tmg.cmc_prpr_prov@nexus2 G ON B.prpr_id = G.prpr_id
       LEFT JOIN tmg.cmc_seds_se_desc@nexus2 H ON B.sese_id = H.sese_id
       LEFT JOIN tmg.Cmc_pscd_pos_desc@nexus2 I ON B.pscd_Id = I.pscd_id
       LEFT JOIN tmg.Cmc_ipcd_proc_cd@nexus2 J ON B.ipcd_id = J.ipcd_id
       --LEFT JOIN D_VNS_PLANS_PDPD_MAPPING k ON a.pdpd_id = k.PRODUCT_ID
WHERE      a.pdpd_id NOT IN ('HMD00002', 'HMD00003', 'MD000002', 'MD000003')
       AND '01jan2015' <= b.cdml_from_dt
       AND a.clcl_cur_sts = '02'
       AND b.cdml_allow > 0
UNION ALL
--create or replace view V_UTILIZATION_RPT_D02 as
SELECT DISTINCT /*+ driving_site(a) */
               TO_NUMBER(TO_CHAR(cdml_from_dt, 'YYYYMM')) month_id,
                A.CLCL_CL_TYPE,
                A.CLCL_CL_SUB_TYPE,
                A.meme_ck,
                B.CDML_CUR_STS,
                A.sbsb_ck,
                A.clcl_id,
                A.pdpd_id,
                A.CLCL_RECD_DT AS receivedt,
                A.CLCL_PAID_DT AS PaidDate,
                a.CLCL_TOT_PAYABLE,
                B.CDML_PAID_AMT,
                B.cdml_units,
                B.cdml_units_allow,
                B.sese_id,
                B.CDML_SEQ_NO,
                B.prpr_id,
                B.CDML_POS_IND,
                SUBSTR(B.ipcd_id, 1, 5) AS CPT,
                B.ipcd_id,
                B.cdml_from_dt AS claimfromdt,
                B.cdml_to_dt AS claimtodt,
                B.cdml_allow,
                SUBSTR(C.CLHP_FAC_TYPE, 2, 1) AS fac_type,
                --catt(CLHP_FAC_TYPE,CLHP_BILL_CLASS,CLHP_FREQUENCY) as billtype,
                CLHP_FAC_TYPE ||
                CLHP_BILL_CLASS ||
                CLHP_FREQUENCY
                    AS billtype,
                B.rcrc_id,
                B.pscd_id,
                C.agrg_id,
                C.clhp_input_agrg_id,
                D.sbsb_id,
                F.MEME_MEDCD_NO,
                F.MEME_BIRTH_DT AS DOB,
                SUBSTR(B.prpr_id, 1, 9) AS prpr_id2,
                G.prpr_name,
                G.prpr_mctr_type,
                G.prcf_mctr_spec,
                H.seds_desc,
                I.PSCD_DESC,
                UPPER(J.IPCD_DESC) AS IPCD_DESC1,
                cscs_id AS LOB_ID,
                pdpd_id AS Plan
FROM   tmg_fida.cmc_clcl_claim@nexus2 A
       JOIN tmg_fida.Cmc_cdml_cl_line@nexus2 B ON A.clcl_id = B.clcl_id
       LEFT JOIN tmg_fida.cmc_clhp_hosp@nexus2 C ON A.clcl_id = C.clcl_id
       LEFT JOIN tmg_fida.cmc_sbsb_subsc@nexus2 D ON A.sbsb_ck = D.sbsb_ck
       LEFT JOIN tmg_fida.cmc_meme_member@nexus2 F ON A.meme_ck = F.meme_ck
       LEFT JOIN tmg_fida.cmc_prpr_prov@nexus2 G ON B.prpr_id = G.prpr_id
       LEFT JOIN tmg_fida.cmc_seds_se_desc@nexus2 H ON B.sese_id = H.sese_id
       LEFT JOIN tmg_fida.Cmc_pscd_pos_desc@nexus2 I ON B.pscd_Id = I.pscd_id
       LEFT JOIN tmg_fida.Cmc_ipcd_proc_cd@nexus2 J ON B.ipcd_id = J.ipcd_id
WHERE      '01jan2015' <= b.cdml_from_dt
       AND a.clcl_cur_sts = '02'
       AND b.cdml_allow > 0;

COMMENT ON MATERIALIZED VIEW CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM IS 'snapshot table for snapshot CHOICEBI.V_CLAIM_IN_OUTPATIENT_FOR_LM';

GRANT SELECT ON CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM TO DW_OWNER;

GRANT SELECT ON CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM TO MSTRSTG;

GRANT SELECT ON CHOICEBI.MV_CLAIM_IN_OUTPATIENT_FOR_LM TO ROC_RO;