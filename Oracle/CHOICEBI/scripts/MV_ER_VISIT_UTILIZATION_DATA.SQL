insert into MV_ER_VISIT_UTILIZATION_DATA
SELECT                           /* driving_site(d) cardinality(d, 4000000) */
      DISTINCT
       A.*,
       PROVIDER_NAME,
       CASE WHEN enrolled = 1 THEN 'Y' ELSE 'N' END AS Active_OnDisch,
       RANK()
       OVER (PARTITION BY A.SUBSCRIBER_ID, A.CLAIMFROMDATE, A.prpr_id
             ORDER BY A.MONTH_ID)
           SEQ
FROM   ((SELECT /* driving_site(A) no_merge cardinality(a 40000000) cardinality(b 40000000) cardinality(c 40000000) cardinality(D 40000000)  */
               DISTINCT
                TO_NUMBER(TO_CHAR(CLCL_LOW_SVC_DT, 'YYYYMM')) month_id,
                dl_lob_id LOB_ID,
                product_id,
                product_name,
                d.sbsb_id SUBSCRIBER_ID,
                a.prpr_id,
                CLCL_LOW_SVC_DT AS CLAIMFROMDATE,
                CLCL_HIGH_SVC_DT AS CLAIMTODATE,
                CLHP_FAC_TYPE ||
                CLHP_BILL_CLASS
                    AS BILLTYPE,
                CLHP_ADM_TYP,
                CLHP_ADM_SOURCE,
                H.MCTR_DESC AS TYPE,
                CLHP_DC_STAT,
                G.MCTR_DESC AS DISC_STATUS,
                CLCL_ME_AGE AS AGE_DOS,
                CLCL_PRPR_ID_PCP AS PROVIDER_ID,
                CLCL_NTWK_IND,
                CLCL_TOT_PAYABLE,
                I.IDCD_ID AS PRIM_DX,
                IDCD_DESC AS DX_DESCRIPTION,
                'ER' CAT,
                1 serv
         FROM   tmg.cmc_clcl_claim A
                INNER JOIN tmg.cmc_cdml_cl_line B ON a.clcl_id = b.clcl_id
                INNER JOIN tmg.cmc_meme_member C ON A.meme_ck = C.meme_ck
                INNER JOIN tmg.cmc_sbsb_subsc D ON C.sbsb_ck = D.sbsb_ck
                INNER JOIN tmg.CMC_CLHP_HOSP F
                    ON     A.clcl_id = F.clcl_id
                       AND CLHP_DC_STAT != '20'
                LEFT JOIN TMG.CMC_PRPR_PROV I ON A.PRPR_ID = I.PRPR_ID
                LEFT JOIN TMG.CMC_MCTR_CD_TRANS G
                    ON     F.CLHP_DC_STAT = G.MCTR_VALUE
                       AND G.MCTR_TYPE = 'DCST'
                       AND G.MCTR_ENTITY = '!CLH'
                LEFT JOIN TMG.CMC_MCTR_CD_TRANS H
                    ON     F.CLHP_ADM_TYP = H.MCTR_VALUE
                       AND H.MCTR_TYPE = 'ADMT'
                       AND H.MCTR_ENTITY = '!CLH'
                LEFT JOIN TMG.CMC_CLMD_DIAG I
                    ON     A.CLCL_ID = I.CLCL_ID
                       AND CLMD_TYPE = '01'
                LEFT JOIN
                TMG.Cmc_idcd_diag_cd J
                    ON     I.IDCD_ID = J.IDCD_ID
                       AND a.CLCL_LOW_SVC_DT BETWEEN j.IDCD_EFF_DT
                                                 AND j.IDCD_TERM_DT
                LEFT JOIN mstrstg.D_VNS_LOB_PRODUCT_MAPPING z
                    ON z.product_id = a.pdpd_id
         WHERE      (    CLHP_FAC_TYPE = '01'
                     AND CLHP_BILL_CLASS IN ('3', '4')
                     AND PRPR_MCTR_TYPE IN
                             ('URG', 'HSP', 'HOSP', 'OUT', 'GROU', 'GRP'))
                AND (   (   (    '0450' <= rcrc_id
                             AND rcrc_id <= '0452')
                         OR (rcrc_id = '0459'))
                     OR (    '99281' <= SUBSTR(ipcd_id, 1, 5)
                         AND SUBSTR(ipcd_id, 1, 5) <= '99285'))
                AND (    a.pdpd_id NOT IN
                             ('HMD00002', 'HMD00003', 'MD000002', 'MD000003')
                     AND clcl_cur_sts NOT IN ('91', '99')))
        UNION ALL
        (SELECT /* parallel(2) driving_site(A) no_merge cardinality(a 40000000) cardinality(b 40000000) cardinality(c 40000000) cardinality(d 40000000) */
               DISTINCT
                TO_NUMBER(TO_CHAR(CLCL_LOW_SVC_DT, 'YYYYMM')) month_id,
                dl_lob_id LOB_ID,
                product_id,
                product_name,
                d.sbsb_id,
                a.prpr_id,
                CLCL_LOW_SVC_DT AS CLAIMFROMDATE,
                CLCL_HIGH_SVC_DT AS CLAIMTODATE,
                CLHP_FAC_TYPE ||
                CLHP_BILL_CLASS
                    AS BILLTYPE,
                CLHP_ADM_TYP,
                CLHP_ADM_SOURCE,
                H.MCTR_DESC AS TYPE,
                CLHP_DC_STAT,
                G.MCTR_DESC AS DISC_STATUS,
                CLCL_ME_AGE AS AGE_DOS,
                CLCL_PRPR_ID_PCP AS PROVIDER_ID,
                CLCL_NTWK_IND,
                CLCL_TOT_PAYABLE,
                I.IDCD_ID AS PRIM_DX,
                IDCD_DESC AS DX_DESCRIPTION,
                'ER' CAT,
                1 serv
         FROM   tmg_fida.cmc_clcl_claim A
                INNER JOIN tmg_fida.cmc_cdml_cl_line B
                    ON a.clcl_id = b.clcl_id
                INNER JOIN tmg_fida.cmc_meme_member C
                    ON A.meme_ck = C.meme_ck
                INNER JOIN tmg_fida.cmc_sbsb_subsc D ON C.sbsb_ck = D.sbsb_ck
                INNER JOIN tmg_fida.CMC_CLHP_HOSP F
                    ON     A.clcl_id = F.clcl_id
                       AND CLHP_DC_STAT != '20'
                INNER JOIN tmg_fida.CMC_PRPR_PROV I ON A.PRPR_ID = I.PRPR_ID
                LEFT JOIN tmg_fida.CMC_MCTR_CD_TRANS G
                    ON     F.CLHP_DC_STAT = G.MCTR_VALUE
                       AND G.MCTR_TYPE = 'DCST'
                       AND G.MCTR_ENTITY = '!CLH'
                LEFT JOIN tmg_fida.CMC_MCTR_CD_TRANS H
                    ON     F.CLHP_ADM_TYP = H.MCTR_VALUE
                       AND H.MCTR_TYPE = 'ADMT'
                       AND H.MCTR_ENTITY = '!CLH'
                LEFT JOIN tmg_fida.CMC_CLMD_DIAG I
                    ON     A.CLCL_ID = I.CLCL_ID
                       AND CLMD_TYPE = '01'
                LEFT JOIN
                tmg_fida.Cmc_idcd_diag_cd J
                    ON     I.IDCD_ID = J.IDCD_ID
                       AND a.CLCL_LOW_SVC_DT BETWEEN j.IDCD_EFF_DT
                                                 AND j.IDCD_TERM_DT
                --LEFT JOIN d_vns_plans_pdpd_mapping z ON z.pdpd_id = a.pdpd_id
                LEFT JOIN mstrstg.D_VNS_LOB_PRODUCT_MAPPING z
                    ON z.product_id = a.pdpd_id
         WHERE      (    CLHP_FAC_TYPE = '01'
                     AND CLHP_BILL_CLASS IN ('3', '4')
                     AND PRPR_MCTR_TYPE IN
                             ('URG', 'HSP', 'HOSP', 'OUT', 'GROU', 'GRP'))
                AND (   (   (    '0450' <= rcrc_id
                             AND rcrc_id <= '0452')
                         OR (rcrc_id = '0459'))
                     OR (    '99281' <= SUBSTR(ipcd_id, 1, 5)
                         AND SUBSTR(ipcd_id, 1, 5) <= '99285'))
                AND (    a.pdpd_id NOT IN
                             ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                     AND clcl_cur_sts NOT IN ('91', '99')))) A
       LEFT JOIN
       (SELECT *
        FROM   (SELECT /* no_merge */
                      a.*,
                       1 enrolled,
                       DENSE_RANK()
                       OVER (
                           PARTITION BY a.lob_id, a.PRODUCT_ID, subscriber_id
                           ORDER BY month_id DESC)
                           seq
                FROM   fact_member_month a)
        WHERE  seq = 1) B
           ON     A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
              AND A.lob_id = B.lob_id
              AND a.product_id = b.product_id
       LEFT JOIN tmg.cmc_prpr_prov D ON a.prpr_id = d.prpr_id