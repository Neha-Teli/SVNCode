DROP VIEW CHOICEBI.FACT_IP_SNF_DATA;

CREATE OR REPLACE FORCE VIEW CHOICEBI.FACT_IP_SNF_DATA
AS
    WITH IN01 AS
             (SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) cardinality(c 400000) cardinality(d 400000) */
                    DISTINCT
                     g.sbsb_id,
                     a.clcl_id,
                     a.meme_ck,
                     a.CLHP_STAMENT_FR_DT AS CLHP_STAMENT_FR_DT,
                     a.CLHP_STAMENT_TO_DT AS CLHP_STAMENT_TO_DT,
                     b.CLCL_TOT_PAYABLE,
                     prpr_name,
                     d.idcd_id admin_dx, --compress(d.idcd_id,'N U W Y ') as admin_dx,
                     i.IDCD_DESC AS Ad_dx_desc,
                     e.idcd_id Prim_dx, --compress(e.idcd_id,'N U W Y ')as Prim_dx,
                     j.IDCD_DESC AS Prim_dx_desc,
                     K.pdpd_id,
                     CASE
                         WHEN SUBSTR(K.pdpd_id, 1, 2) = 'VN' THEN 'MA'
                         WHEN SUBSTR(k.pdpd_id, 1, 2) = 'MD' THEN 'SH'
                         ELSE ''
                     END
                         AS Plan,
                     a.CLHP_DC_STAT,
                     h.MCTR_DESC,
                     a.CLHP_STAMENT_FR_DT - 1 AS previous_dt,
                     a.CLHP_STAMENT_FR_DT + 1 AS after_dt,
                     CLHP_FAC_TYPE ||
                     CLHP_BILL_CLASS ||
                     CLHP_FREQUENCY
                         AS Billtype
              FROM   tmg.Cmc_clhp_hosp@nexus2 A
                     JOIN tmg.Cmc_clcl_claim@nexus2 b  ON a.clcl_id = b.clcl_id
                     JOIN tmg.cmc_cdml_cl_line b2 ON     b.clcl_id = b2.clcl_id AND RCRC_id = '0022' /* this determines that this is the SNF stay*/
                     LEFT JOIN TMG.CMC_prpr_prov@nexus2 C ON b.prpr_id = c.prpr_id
                     LEFT JOIN tmg.Cmc_clmd_diag@nexus2 D ON     a.clcl_id = D.clcl_id AND d.clmd_type = 'AD' /* this pulls the admitting dx*/
                     LEFT JOIN tmg.Cmc_clmd_diag@nexus2 E ON     a.clcl_id = e.clcl_id AND e.clmd_type = '01' /* this pulls the primary dx*/
                     LEFT JOIN tmg.cmc_meme_member@nexus2 F ON a.meme_ck = f.meme_ck
                     LEFT JOIN tmg.cmc_sbsb_subsc@nexus2 G ON f.sbsb_ck = g.sbsb_ck
                     LEFT JOIN tmg.Cmc_mctr_cd_trans@nexus2 H ON     a.CLHP_DC_STAT = h.mctr_value AND h.MCTR_TYPE = 'DCST'
                     LEFT JOIN tmg.Cmc_idcd_diag_cd@nexus2 I ON     d.idcd_id = i.idcd_id AND a.CLHP_STAMENT_FR_DT BETWEEN i.IDCD_EFF_DT AND i.IDCD_TERM_DT
                     LEFT JOIN tmg.Cmc_idcd_diag_cd@nexus2 j ON     e.idcd_id = j.idcd_id AND a.CLHP_STAMENT_FR_DT BETWEEN j.IDCD_EFF_DT AND j.IDCD_TERM_DT
                     JOIN TMG.Cmc_mepe_prcs_elig@nexus2 K ON     A.MEME_CK = K.MEME_CK AND a.CLHP_STAMENT_TO_DT BETWEEN MEPE_EFF_DT AND MEPE_TERM_DT
              WHERE      k.pdpd_id NOT IN ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                     AND b.clcl_cur_sts NOT IN ('99', '91')
                     AND CLHP_FAC_TYPE = '02'
                     AND CLHP_BILL_CLASS IN ('1', '2')
              UNION ALL
              SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) cardinality(c 400000) cardinality(d 400000) */
                    DISTINCT g.sbsb_id,
                             a.clcl_id,
                             a.meme_ck,
                             a.CLHP_STAMENT_FR_DT AS CLHP_STAMENT_FR_DT,
                             a.CLHP_STAMENT_TO_DT AS CLHP_STAMENT_TO_DT,
                             b.CLCL_TOT_PAYABLE,
                             prpr_name,
                             d.idcd_id admin_dx, --compress(d.idcd_id,'N U W Y ') as admin_dx,
                             i.IDCD_DESC AS Ad_dx_desc,
                             e.idcd_id Prim_dx, --compress(e.idcd_id,'N U W Y ')as Prim_dx,
                             j.IDCD_DESC AS Prim_dx_desc,
                             K.pdpd_id,
                             'FIDA' PLAN,
                             a.CLHP_DC_STAT,
                             h.MCTR_DESC,
                             a.CLHP_STAMENT_FR_DT - 1 previous_dt,
                             a.CLHP_STAMENT_FR_DT + 1 after_dt,
                             CLHP_FAC_TYPE ||
                             CLHP_BILL_CLASS ||
                             CLHP_FREQUENCY
                                 AS Billtype
              FROM   TMG_FIDA.Cmc_clhp_hosp@nexus2 A
                     JOIN TMG_FIDA.Cmc_clcl_claim@nexus2 b ON a.clcl_id = b.clcl_id
                     JOIN tmg_FIDA.cmc_cdml_cl_line b2 on b.clcl_id=b2.clcl_id and RCRC_id ='0022' /* this determines that this is the SNF stay*/
                     LEFT JOIN TMG_FIDA.CMC_prpr_prov@nexus2 C ON b.prpr_id = c.prpr_id
                     LEFT JOIN TMG_FIDA.Cmc_clmd_diag@nexus2 D ON     a.clcl_id = D.clcl_id AND d.clmd_type = 'AD' /* this pulls the admitting dx*/
                     LEFT JOIN TMG_FIDA.Cmc_clmd_diag@nexus2 E ON     a.clcl_id = e.clcl_id AND e.clmd_type = '01' /* this pulls the primary dx*/
                     LEFT JOIN TMG_FIDA.cmc_meme_member@nexus2 F ON a.meme_ck = f.meme_ck
                     LEFT JOIN TMG_FIDA.cmc_sbsb_subsc@nexus2 G ON f.sbsb_ck = g.sbsb_ck
                     LEFT JOIN TMG_FIDA.Cmc_mctr_cd_trans@nexus2 H ON     a.CLHP_DC_STAT = h.mctr_value AND h.MCTR_TYPE = 'DCST'
                     LEFT JOIN TMG_FIDA.Cmc_idcd_diag_cd@nexus2 I ON     d.idcd_id = i.idcd_id AND a.CLHP_STAMENT_FR_DT BETWEEN i.IDCD_EFF_DT AND i.IDCD_TERM_DT
                     LEFT JOIN TMG_FIDA.Cmc_idcd_diag_cd@nexus2 j ON     e.idcd_id = j.idcd_id AND a.CLHP_STAMENT_FR_DT BETWEEN j.IDCD_EFF_DT AND j.IDCD_TERM_DT
                     JOIN TMG_FIDA.Cmc_mepe_prcs_elig@nexus2 K ON     A.MEME_CK = K.MEME_CK AND a.CLHP_STAMENT_TO_DT BETWEEN MEPE_EFF_DT AND MEPE_TERM_DT
              WHERE      k.pdpd_id NOT IN ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                     AND b.clcl_cur_sts NOT IN ('99', '91')
                     AND (    CLHP_FAC_TYPE = '02' AND CLHP_BILL_CLASS IN ('1', '2'))
                     --AND CLCL_TOT_PAYABLE > 0 AND CLHP_STAMENT_FR_DT >= '01-NOV-2014'
     ),
         IN02 AS --datafile= '\\FPSM0206\CHOICEHealthPlan\Data_Share\Monthly Reports\Medicare -- Hospitalization\Lynda_Montella\VO_Disch_Code_DESC.xls'
                (SELECT * FROM VO_DISCH_CODE),
         IN03 AS
             (SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) */
                    DISTINCT b.sbsb_id,
                             (a.HOSBEG) AS CLHP_STAMENT_FR_DT,
                             a.HOSEND AS CLHP_STAMENT_TO_DT,
                             a.CLAIMNO AS clcl_id,
                             c.meme_ck,
                             a.DISTAT AS CLHP_DC_STAT,
                             --a.DESC as MCTR_DESC,
                             DIAGN1 AS Prim_dx,
                             e.IDCD_DESC AS Prim_dx_desc,
                             SVVLST ||
                             SVVFST
                                 AS PRPR_NAME,
                             'MA' AS Plan,
                             ALWAMT AS CLCL_TOT_PAYABLE
              FROM   VNS_CHOICE1.Value_options@nexus2 a
                     JOIN tmg.cmc_sbsb_subsc@nexus2 B ON SUBSTR(a.MEMBNO, 1, 9) = b.sbsb_id
                     JOIN tmg.cmc_meme_member@nexus2 C ON b.sbsb_ck = c.sbsb_ck
                     LEFT JOIN in02 D ON a.DISTAT = D.code
                     LEFT JOIN tmg.Cmc_idcd_diag_cd@nexus2 E ON DIAGN1 = e.idcd_id AND a.HOSBEG BETWEEN e.IDCD_EFF_DT AND e.IDCD_TERM_DT
              WHERE      LINENO = '001'
                     --AND ALWAMT > 0
                     AND (   BILCOD LIKE '21%' OR BILCOD LIKE '22%')
                     AND HOSEND >= '01-NOV-2014'
                     AND rcvdat <= SYSDATE - 2
              UNION ALL
              SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) */
                    DISTINCT b.sbsb_id,
                             a.HOSBEG AS CLHP_STAMENT_FR_DT,
                             a.HOSEND AS CLHP_STAMENT_TO_DT,
                             a.CLAIMNO AS clcl_id,
                             c.meme_ck,
                             a.DISTAT AS CLHP_DC_STAT,
                             --DESC as MCTR_DESC,
                             DIAGN1 Prim_dx,
                             e.IDCD_DESC AS Prim_dx_desc,
                             SVVLST ||
                             SVVFST
                                 AS PRPR_NAME,
                             'FIDA' AS Plan,
                             ALWAMT AS CLCL_TOT_PAYABLE
              FROM   VNS_choice1.VALUE_OPTIONS_FIDA@NEXUS2 a
                     JOIN TMG_FIDA.cmc_sbsb_subsc@NEXUS2 B ON SUBSTR(a.MEMBNO, 1, 9) = b.sbsb_id
                     JOIN TMG_FIDA.cmc_meme_member@NEXUS2 C ON b.sbsb_ck = c.sbsb_ck
                     LEFT JOIN in02 D ON a.DISTAT = D.code
                     LEFT JOIN TMG_FIDA.Cmc_idcd_diag_cd@NEXUS2 E ON     DIAGN1 = e.idcd_id AND a.HOSBEG BETWEEN e.IDCD_EFF_DT AND e.IDCD_TERM_DT
              WHERE      LINENO = '001'
--                     AND ALWAMT > 0
                     AND (   BILCOD LIKE '21%' OR BILCOD LIKE '22%')
                     AND HOSEND >= '01-NOV-2014'
                     AND rcvdat <= SYSDATE - 2),
         IN04 AS
             (SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) */
                    DISTINCT b.sbsb_id,
                             a.HOSBEG AS CLHP_STAMENT_FR_DT,
                             a.HOSEND AS CLHP_STAMENT_TO_DT,
                             a.CLAIMNO AS clcl_id,
                             c.meme_ck,
                             a.DISTAT AS CLHP_DC_STAT,
                             --DESC as MCTR_DESC,
                             DIAGN1 AS Prim_dx,
                             e.IDCD_DESC AS Prim_dx_desc,
                             SVVLST ||
                             SVVFST
                                 AS PRPR_NAME,
                             'SH' AS Plan,
                             ALWAMT AS CLCL_TOT_PAYABLE
              FROM   VNS_choice1.Value_options_sh@nexus2 a
                     JOIN tmg.cmc_sbsb_subsc@nexus2 B ON SUBSTR(a.MEMBNO, 1, 9) = b.sbsb_id
                     JOIN tmg.cmc_meme_member@nexus2 C ON b.sbsb_ck = c.sbsb_ck
                     LEFT JOIN in02 D ON a.DISTAT = D.code
                     LEFT JOIN tmg.Cmc_idcd_diag_cd@nexus2 E ON     DIAGN1 = e.idcd_id AND (a.HOSBEG BETWEEN e.IDCD_EFF_DT AND e.IDCD_TERM_DT)
              WHERE      LINENO = '001'
--                     AND ALWAMT > 0
                     AND (   BILCOD LIKE '21%' OR BILCOD LIKE '22%')
                     AND HOSEND >= '01-nov-2014'
                     AND rcvdat <= SYSDATE - 2),
         IN01_b AS
             (SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) */
                    DISTINCT d.sbsb_id,
                             a.meme_ck,
                             (a.UMIN_ACT_ADM_DT) AS CLHP_STAMENT_FR_DT,
                             (a.UMIN_DC_DTM) AS CLHP_STAMENT_TO_DT,
                             prpr_name,
                             B.PDPD_ID,
                             --                             cast(null as varchar2(10)) AS admin_dx,
                             --                             cast(null as varchar2(10)) AS Ad_dx_desc,
                             a.IDCD_ID_ADM_SUB Prim_dx, --compress(a.IDCD_ID_ADM_SUB,'N U W Y ')as Prim_dx,
                             f.IDCD_DESC AS Prim_dx_desc,
                             a.UMIN_ACT_ADM_DT AS M_DOS
              --                             NULL CLCL_TOT_PAYABLE
              FROM   tmg.Cmc_umin_inpatient@nexus2 A
                     JOIN tmg.Cmc_mepe_prcs_elig@nexus2 B ON     a.meme_ck = b.meme_ck AND (UMIN_ACT_ADM_DT BETWEEN MEPE_EFF_DT AND MEPE_TERM_DT)
                     JOIN tmg.cmc_meme_member@nexus2 C ON a.meme_ck = c.meme_ck
                     JOIN tmg.cmc_sbsb_subsc@nexus2 D ON c.sbsb_ck = d.sbsb_ck
                     LEFT JOIN tmg.cmc_prpr_prov@nexus2 E ON a.UMIN_PRPR_ID_FAC = E.prpr_id
                     LEFT JOIN tmg.Cmc_idcd_diag_cd@nexus2 f ON (    a.IDCD_ID_ADM_SUB = f.idcd_id AND a.UMIN_ACT_ADM_DT BETWEEN f.IDCD_EFF_DT AND f.IDCD_TERM_DT)
              WHERE      B.pdpd_id NOT IN ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                     AND SUBSTR(umin_prpr_id_fac, 1, 3) = 'SNF'
                     AND umit_sts NOT IN ('DS', 'CL', 'IN')
                     AND TRUNC(a.UMIN_ACT_ADM_DT) >= '01-NOV-2014'
                     AND UMIN_INPUT_DT <= TRUNC(SYSDATE) - 2
              UNION ALL
              SELECT /*+ materialized driving_site(a) cardinality(a 400000) cardinality(b 400000) */
                    DISTINCT d.sbsb_id,
                             a.meme_ck,
                             a.UMIN_ACT_ADM_DT CLHP_STAMENT_FR_DT,
                             a.UMIN_DC_DTM CLHP_STAMENT_TO_DT,
                             prpr_name,
                             B.PDPD_ID,
                             --                             cast(null as varchar2(10)) AS admin_dx,
                             --                             cast(null as varchar2(10)) AS Ad_dx_desc,
                             a.IDCD_ID_ADM_SUB Prim_dx, --compress(a.IDCD_ID_ADM_SUB,'N U W Y ')as Prim_dx,
                             f.IDCD_DESC AS Prim_dx_desc,
                             UMIN_ACT_ADM_DT M_DOS
              --                             NULL CLCL_TOT_PAYABLE
              FROM   TMG_FIDA.Cmc_umin_inpatient@nexus2 A
                     JOIN
                     TMG_FIDA.Cmc_mepe_prcs_elig@nexus2 B
                         ON     a.meme_ck = b.meme_ck
                            AND UMIN_ACT_ADM_DT BETWEEN MEPE_EFF_DT
                                                    AND MEPE_TERM_DT
                     JOIN TMG_FIDA.cmc_meme_member@nexus2 C
                         ON a.meme_ck = c.meme_ck
                     JOIN TMG_FIDA.cmc_sbsb_subsc@nexus2 D
                         ON c.sbsb_ck = d.sbsb_ck
                     LEFT JOIN TMG_FIDA.cmc_prpr_prov@nexus2 E
                         ON a.UMIN_PRPR_ID_FAC = E.prpr_id
                     LEFT JOIN
                     TMG_FIDA.Cmc_idcd_diag_cd@nexus2 f
                         ON     a.IDCD_ID_ADM_SUB = f.idcd_id
                            AND a.UMIN_ACT_ADM_DT BETWEEN f.IDCD_EFF_DT
                                                      AND f.IDCD_TERM_DT
              WHERE      B.pdpd_id NOT IN ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                     AND /* umit_sts this deletes auths that were disallowed or voided or pend with errors*/
                        SUBSTR(umin_prpr_id_fac, 1, 3) = 'SNF'
                     AND umit_sts NOT IN ('DS', 'CL', 'IN')
                     AND TRUNC(UMIN_ACT_ADM_DT) >= '01-NOV-2014'
                     AND UMIN_INPUT_DT <= TRUNC(SYSDATE) - 2),
         IN01_c AS
             (SELECT *
              FROM   IN01_b a
              WHERE  (meme_ck, TRUNC(CLHP_STAMENT_FR_DT)) NOT IN
                         (SELECT meme_ck, TRUNC(CLHP_STAMENT_FR_DT)
                          FROM   IN01 b)),
         IN01_d AS
             (SELECT DISTINCT a.*
              FROM   IN01_c A
                     JOIN
                     in01 B
                         ON     a.meme_ck = b.meme_ck
                            AND a.CLHP_STAMENT_FR_DT BETWEEN b.previous_dt
                                                         AND b.after_dt),
         IN01_e AS
             (SELECT DISTINCT A.*, 'AUTH' AS SOURCE
              FROM   IN01_c A
                     LEFT JOIN IN01_d B
                         ON     A.SBSB_ID = B.SBSB_ID
                            AND A.CLHP_STAMENT_FR_DT = B.CLHP_STAMENT_FR_DT
              WHERE      B.SBSB_ID IS NULL
                     AND B.CLHP_STAMENT_FR_DT IS NULL),
         in05 AS
             (SELECT SBSB_ID,
                     CLHP_STAMENT_FR_DT,
                     CLHP_STAMENT_TO_DT,
                     CLCL_ID,
                     MEME_CK,
                     CLHP_DC_STAT,
                     PRIM_DX,
                     PRIM_DX_DESC,
                     PLAN,
                     CLCL_TOT_PAYABLE
              FROM   IN04
              UNION ALL
              SELECT SBSB_ID,
                     CLHP_STAMENT_FR_DT,
                     CLHP_STAMENT_TO_DT,
                     CLCL_ID,
                     MEME_CK,
                     CLHP_DC_STAT,
                     PRIM_DX,
                     PRIM_DX_DESC,
                     PLAN,
                     CLCL_TOT_PAYABLE
              FROM   IN03
              UNION ALL
              SELECT SBSB_ID,
                     CLHP_STAMENT_FR_DT,
                     CLHP_STAMENT_TO_DT,
                     CLCL_ID,
                     MEME_CK,
                     CLHP_DC_STAT,
                     PRIM_DX,
                     PRIM_DX_DESC,
                     PLAN,
                     CLCL_TOT_PAYABLE
              FROM   IN01
              UNION ALL
              SELECT SBSB_ID,
                     CLHP_STAMENT_FR_DT,
                     CLHP_STAMENT_TO_DT,
                     NULL CLCL_ID,
                     MEME_CK,
                     NULL CLHP_DC_STAT,
                     NULL PRIM_DX,
                     NULL PRIM_DX_DESC,
                     NULL PLAN,
                     NULL CLCL_TOT_PAYABLE
              FROM   IN01_e),
         in06 AS
             (SELECT   DISTINCT sbsb_id,
                                CLHP_STAMENT_FR_DT,
                                CLHP_STAMENT_TO_DT,
                                Plan,
                                SUM(CLCL_TOT_PAYABLE) AS Tot_Paid
              FROM     in05
              GROUP BY sbsb_id,
                       CLHP_STAMENT_FR_DT,
                       CLHP_STAMENT_TO_DT,
                       Plan),
         in07_Ca AS
             (SELECT sbsb_id,
                     (CLHP_STAMENT_FR_DT) AS CLHP_STAMENT_FR_DT,
                     (CLHP_STAMENT_TO_DT) AS CLHP_STAMENT_TO_DT,
                     totpd
              FROM   (SELECT   c.sbsb_id,
                               MIN(CLHP_STAMENT_FR_DT) AS CLHP_STAMENT_FR_DT,
                               MAX(CLHP_STAMENT_TO_DT) AS CLHP_STAMENT_TO_DT,
                               SUM(tot_paid) AS totpd
                      FROM     (SELECT b.*,
                                         SUM(
                                             CASE
                                                 WHEN diff IS NULL THEN 0
                                                 WHEN diff IN (1) THEN 0
                                                 WHEN diff >= 2 THEN 1
                                             END)
                                         OVER (PARTITION BY sbsb_id
                                               ORDER BY CLHP_STAMENT_FR_DT)
                                       + 1
                                           AS member_adm_seq
                                FROM   (SELECT a.*,
                                               LAG(
                                                   CLHP_STAMENT_FR_DT,
                                                   1)
                                               OVER (
                                                   PARTITION BY sbsb_id
                                                   ORDER BY
                                                       CLHP_STAMENT_FR_DT,
                                                       CLHP_STAMENT_TO_DT)
                                                   AS lag_adm_dt,
                                               LAG(
                                                   CLHP_STAMENT_TO_DT,
                                                   1)
                                               OVER (
                                                   PARTITION BY sbsb_id
                                                   ORDER BY
                                                       CLHP_STAMENT_FR_DT,
                                                       CLHP_STAMENT_TO_DT)
                                                   AS lag_dis_dt,
                                               ROW_NUMBER()
                                               OVER (
                                                   PARTITION BY sbsb_id
                                                   ORDER BY
                                                       CLHP_STAMENT_FR_DT,
                                                       CLHP_STAMENT_TO_DT)
                                                   AS seq,
                                                 CLHP_STAMENT_FR_DT
                                               - LAG(
                                                     CLHP_STAMENT_TO_DT,
                                                     1)
                                                 OVER (
                                                     PARTITION BY sbsb_id
                                                     ORDER BY
                                                         CLHP_STAMENT_FR_DT,
                                                         CLHP_STAMENT_TO_DT)
                                                   AS diff
                                        FROM   in06 a) b) c
                      GROUP BY sbsb_id, member_adm_seq)),
         in07_d AS
             (SELECT DISTINCT
                     c.sbsb_id,
                     meme_last_name,
                     meme_first_name,
                     (MEPE_EFF_DT) AS Eff_dt,
                     (MEPE_TERM_DT) AS term_date,
                     PDPD_id,
                     CASE
                         WHEN PDPD_id IN
                                  ('VNSNY007',
                                   'VNS02007',
                                   'VNS020A7',
                                   'VNS03007',
                                   'VNS030A7',
                                   'VNS04007',
                                   'VNS040A7',
                                   'VNS040B7',
                                   'VNS06007',
                                   'VNS08007',
                                   'VNS080A7',
                                   'VNS080B7',
                                   'VNS09007',
                                   'VNS090A7',
                                   'VNS090B7') THEN
                             'MA'
                         WHEN PDPD_id IN ('MD000004', 'MD000008') THEN
                             'SH'
                     END
                         AS LOB,
                     --
                     CASE
                         WHEN PDPD_id IN ('VNSNY007', 'VNS02007', 'VNS020A7') THEN
                             'MA-Preferred'
                         WHEN PDPD_id IN ('VNS03007', 'VNS030A7') THEN
                             'MA-Total'
                         WHEN PDPD_id IN ('VNS04007', 'VNS040A7', 'VNS040B7') THEN
                             'MA-Enhanced'
                         WHEN PDPD_id IN ('VNS06007') THEN
                             'MA-Maximum'
                         WHEN PDPD_id IN ('VNS08007', 'VNS080A7', 'VNS080B7') THEN
                             'MA-Classic'
                         WHEN PDPD_id IN ('VNS09007', 'VNS090A7', 'VNS090B7') THEN
                             'MA-Ultra'
                         WHEN PDPD_id IN ('MD000004', 'MD000008') THEN
                             'HIV-SNP'
                     END
                         AS Plan
              FROM   tmg.Cmc_mepe_prcs_elig@nexus2 A
                     JOIN tmg.cmc_meme_member@nexus2 B
                         ON a.meme_ck = b.meme_ck
                     JOIN tmg.cmc_sbsb_subsc@nexus2 C
                         ON b.sbsb_ck = c.sbsb_ck
              WHERE      MEPE_ELIG_IND = 'Y'
                     AND PDPD_id IN
                             ('VNSNY007',
                              'VNS02007',
                              'VNS020A7',
                              'VNS03007',
                              'VNS030A7',
                              'VNS04007',
                              'VNS040A7',
                              'VNS040B7',
                              'VNS06007',
                              'MD000004',
                              'VNS08007',
                              'VNS080A7',
                              'VNS080B7',
                              'VNS09007',
                              'VNS090A7',
                              'VNS090B7',
                              'MD000008')
              UNION ALL
              SELECT DISTINCT c.sbsb_id,
                              meme_last_name,
                              meme_first_name,
                              MEPE_EFF_DT AS Eff_dt,
                              MEPE_TERM_DT AS term_date,
                              PDPD_id,
                              'FIDA' AS LOB,
                              'FIDA' AS Plan
              FROM   TMG_FIDA.Cmc_mepe_prcs_elig@NEXUS2 A
                     JOIN TMG_FIDA.cmc_meme_member@NEXUS2 B
                         ON a.meme_ck = b.meme_ck
                     JOIN TMG_FIDA.cmc_sbsb_subsc@NEXUS2 C
                         ON b.sbsb_ck = c.sbsb_ck
              WHERE  MEPE_ELIG_IND = 'Y'),
         in07_e AS
     (
            SELECT c.* --       ,c.sbsb_id, c.meme_last_name, meme_first_name, eff_dt, term_date
                                                            --       , min(eff_dt) as new_adm_dt, max(term_date) as new_dis_dt
                                                         ,
                                                         MIN(eff_dt) OVER ( PARTITION BY sbsb_id, member_adm_seq ORDER BY eff_dt, term_date) AS new_adm_dt,
                                                         MAX( term_date) OVER (PARTITION BY sbsb_id, member_adm_seq ORDER BY eff_dt, term_date) AS new_dis_dt
                      FROM     (SELECT b.*,
                                         SUM(
                                             CASE
                                                 WHEN diff IS NULL THEN 0
                                                 WHEN diff IN (1) THEN 0
                                                 WHEN diff >= 2 THEN 1
                                             END)
                                         OVER (PARTITION BY sbsb_id ORDER BY Eff_dt) + 1 AS member_adm_seq
                                FROM   (SELECT a.*,
                                               LAG( Eff_dt, 1) OVER ( PARTITION BY sbsb_id ORDER BY Eff_dt, term_date) AS lag_adm_dt,
                                                                         LAG( term_date, 1) OVER ( PARTITION BY sbsb_id ORDER BY eff_dt, term_date) AS lag_dis_dt --                       , row_number() over (partition by sbsb_id order by eff_dt, term_date) as seq
                                                                                          ,
                                                 Eff_dt - LAG( term_date, 1) OVER ( PARTITION BY sbsb_id ORDER BY Eff_dt, term_date) AS diff
                                        FROM   in07_d a
                     ) b 
        ) c
    ),
         in07_f AS
         (
                                              /*  in07_f  */
                              SELECT sbsb_id,
                                     meme_last_name,
                                     meme_first_name,
                       Eff_dt,
                       term_date,
                                     new_adm_dt,
                                     new_dis_dt,
                                     lob,
                                     plan
                              FROM  in07_e
          )
         ,
         /*  in07_h  */
         in07_h AS
         (SELECT *
          FROM
              (SELECT sbsb_id,
                             new_adm_dt AS eff_dt,
                             new_dis_dt AS term_date,
                             ROW_NUMBER() OVER (PARTITION BY sbsb_id ORDER BY term_date DESC) AS seq
                      FROM   (select * from in07_f)
            )
            where seq = 1
        ),
         in08 AS
             (SELECT DISTINCT
                     a.*,
                     c.CLHP_DC_STAT,
                     b.CLCL_TOT_PAYABLE,
                     e.Eff_dt,
                     e.term_date,
                     e.LOB,
                     e.plan,
                     PDPD_id,
                     CASE
                         WHEN a.CLHP_STAMENT_FR_DT BETWEEN e.eff_dt
                                                       AND e.term_date THEN
                             1
                         ELSE
                             0
                     END
                         AS active,
                     ROW_NUMBER()
                     OVER (PARTITION BY a.sbsb_id, a.CLHP_STAMENT_TO_DT ORDER BY b.clcl_tot_payable DESC) seq
              FROM   in07_ca A
                     LEFT JOIN in05 B
                         ON     a.sbsb_id = b.sbsb_id
                            AND a.CLHP_STAMENT_FR_DT = b.CLHP_STAMENT_FR_DT
                     LEFT JOIN in05 C
                         ON     a.sbsb_id = c.sbsb_id
                            AND a.CLHP_STAMENT_TO_DT = c.CLHP_STAMENT_TO_DT
                     --LEFT JOIN in07_h D ON a.sbsb_id = d.sbsb_id
                     LEFT JOIN
                     in07_d E
                         ON     a.sbsb_id = e.sbsb_id
                            AND a.CLHP_STAMENT_FR_DT BETWEEN e.Eff_dt
                                                         AND e.term_date), /* Because there are duplicates based on DOS, eliminated those where the disc status is either blank or the lowest number */
         in08a AS
             (SELECT * FROM   in08 WHERE  seq = 1),
         in08b AS
             (SELECT a.*, TO_DATE(TO_CHAR(CLHP_STAMENT_TO_DT, 'YYYYMM')|| '01', 'YYYYMMDD') AS mos2
              FROM   in08a a WHERE  active = 1),
         in09 AS
             (
         SELECT *
              FROM   (SELECT a.*,
                             TO_DATE(TO_CHAR(CLHP_STAMENT_FR_DT, 'YYYYMM')||
                                     '01',
                                     'YYYYMMDD')
                                 AS month_id,
                             1 AS COUNT,
                             CASE
                                 WHEN CLHP_STAMENT_TO_DT > SYSDATE THEN
                                     NULL
                                 WHEN CLHP_STAMENT_TO_DT = '01-JAN-1753' THEN
                                     NULL
                                 WHEN CLHP_STAMENT_FR_DT = CLHP_STAMENT_TO_DT THEN
                                     1
                                 WHEN CLHP_STAMENT_TO_DT < CLHP_STAMENT_FR_DT THEN
                                     NULL
                                 ELSE
                                     CLHP_STAMENT_TO_DT - CLHP_STAMENT_FR_DT
                             END
                                 AS LOS
                      FROM   in08a a WHERE  active = 1)
              WHERE      month_id >= TO_DATE('01jan2015')
                     AND month_id <=   TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1          /* last day of last month */
)
SELECT a.MONTH_ID,
       SBSB_ID SUBSCRIBER_ID,
       MEMBER_ID,
       DL_LOB_ID,
       DL_PLAN_SK,
       CM_SK_ID,
       DL_ASSESS_SK,
       DL_MEMBER_ADDRESS_SK,
       CLHP_STAMENT_FR_DT,
       CLHP_STAMENT_TO_DT,
       TOTPD,
       CLHP_DC_STAT,
       CLCL_TOT_PAYABLE,
       EFF_DT,
       TERM_DATE,
       PLAN_ID,
       --PDPD_ID,
       a.ACTIVE,
       SEQ,
       LOS
FROM   in09 a
       LEFT JOIN FACT_MEMBER_MONTH B ON (    A.SBSB_ID = B.SUBSCRIBER_ID AND TO_CHAR(A.MONTH_ID, 'YYYYMM') = b.month_id);
           
GRANT SELECT ON CHOICEBI.FACT_IP_SNF_DATA TO DW_OWNER;

GRANT SELECT ON CHOICEBI.FACT_IP_SNF_DATA TO MSTRSTG;
