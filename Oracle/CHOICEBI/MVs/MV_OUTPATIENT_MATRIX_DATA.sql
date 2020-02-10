DROP MATERIALIZED VIEW CHOICEBI.MV_OUTPATIENT_MATRIX_DATA;
CREATE MATERIALIZED VIEW CHOICEBI.MV_OUTPATIENT_MATRIX_DATA (MONTH_ID,LOB_ID,PRODUCT_ID,SUBSCRIBER_ID,CLCL_ID,PRPR_ID,CLAIMFROMDT,CDML_PAID_AMT,CDML_UNITS_ALLOW,CAT,SEQ,CREATED_ON)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
WITH A011_B AS
         (SELECT DISTINCT
                 TO_NUMBER(TO_CHAR(a.PERIOD_COVERED_DATE, 'YYYYMM')) month_id,
                 SUBSTR(A.TRANSACTION_NO, 1, 9) AS CLCL_ID,
                 A.MEMBER_NO AS SBSB_ID,
                 '' PRPR_ID,
                 A.PERIOD_COVERED_DATE claimfromdt,
                 A.TRANSACTION_AMOUNT * -1 AS CDML_PAID_AMT,
                 1 AS CDML_UNITS_ALLOW,
                 'OTC' AS cat,
                 a.TRANSACTION_DATE
          FROM   OTC A
                 LEFT JOIN (SELECT *
                            FROM   otc
                            WHERE  TRANSACTION_TYPE = 'Purchase Reversal') B
                     ON     A.MEMBER_NO = B.MEMBER_NO
                        AND A.TRANSACTION_DATE = B.TRANSACTION_DATE
          WHERE      B.MEMBER_NO IS NULL
                 AND B.TRANSACTION_DATE IS NULL),
     otc_data AS
         (SELECT                                             /* materialize */
                DISTINCT month_id,
                         dl_lob_id dl_lob_id,
                         PRODUCT_ID PRODUCT_ID,
                         a.sbsb_id,
                         CLCL_ID,
                         prpr_id,
                         claimfromdt,
                         A.CDML_PAID_AMT,
                         A.CDML_UNITS_ALLOW,
                         A.cat,
                         1 seq
          FROM   A011_B a
                 JOIN TMG.CMC_SBSB_SUBSC B ON A.SBSB_ID = B.SBSB_ID
                 JOIN TMG.CMC_MEME_MEMBER c ON B.SBSB_CK = C.SBSB_CK
                 JOIN
                 TMG.CMC_MEPE_PRCS_ELIG D
                     ON     C.MEME_CK = D.MEME_CK
                        AND TRANSACTION_DATE BETWEEN MEPE_EFF_DT
                                                 AND MEPE_TERM_DT
                        AND MEPE_ELIG_IND = 'Y'
                 LEFT JOIN MSTRSTG.D_VNS_LOB_PRODUCT_MAPPING e
                     ON (d.pdpd_id = e.PRODUCT_ID)),
     tmgfida_otc_data AS
         (SELECT                                           /* first_rows(1) */
                DISTINCT month_id,
                         dl_lob_id,
                         PRODUCT_ID PRODUCT_ID,
                         A.SBSB_ID,
                         A.CLCL_ID,
                         A.PRPR_ID,
                         A.claimfromdt,
                         A.CDML_PAID_AMT,
                         A.CDML_UNITS_ALLOW,
                         A.cat,
                         1 seq
          FROM   A011_B a
                 JOIN tmg_FIDA.CMC_SBSB_SUBSC B ON A.SBSB_ID = B.SBSB_ID
                 JOIN tmg_FIDA.CMC_MEME_MEMBER c ON B.SBSB_CK = C.SBSB_CK
                 JOIN
                 tmg_FIDA.CMC_MEPE_PRCS_ELIG D
                     ON     C.MEME_CK = D.MEME_CK
                        AND TRANSACTION_DATE BETWEEN MEPE_EFF_DT
                                                 AND MEPE_TERM_DT
                        AND MEPE_ELIG_IND = 'Y'
                 LEFT JOIN MSTRSTG.D_VNS_LOB_PRODUCT_MAPPING e
                     ON (d.pdpd_id = e.PRODUCT_ID)),
     A009 AS
         (SELECT                                    /* materialize no_merge */
                a.*,
                 CASE
                     WHEN (   INSTR(ipcd_desc1, 'MILEAGE') > 0
                           OR INSTR(ipcd_desc1, 'PARKING FEE') > 0) THEN
                         0
                     WHEN SUBSTR(ipcd_id, 6, 2) = 'WT' THEN
                         0
                     WHEN     CPT = 'A0170'
                          AND SUBSTR(ipcd_id, 6, 2) != 'WT' THEN
                         0
                     WHEN cpt = 'A0425' THEN
                         0
                     ELSE
                         a.CDML_UNITS_ALLOW
                 END
                     AS CDML_UNITS_ALLOW_A,
                 SUBSTR(ipcd_id, 6, 2) ipcd_mod,
                 DECODE(cpt, 'A0425', 'Y', 'N') mile,
                 CASE
                     WHEN (UPPER(prcf_mctr_spec) IN ('670')) THEN
                         'TRANS-ER'
                     WHEN (   CPT IN ('A0021', 'A0225')
                           OR (CPT BETWEEN 'A0420' AND 'A0427')
                           OR (CPT BETWEEN 'A0429' AND 'A0999')
                           OR (RCRC_ID BETWEEN '0540' AND '0549')) THEN
                         'TRANS-ER'
                     WHEN INSTR(UPPER(seds_desc), 'NON ER TRANS') > 0 THEN
                         'TRANS-NON-ER'
                     WHEN INSTR(UPPER(seds_desc),
                                'NON EMERGENCY TRANSPORTATION') > 0 THEN
                         'TRANS-NON-ER'
                     WHEN (   (    'T2001' <= CPT
                               AND CPT <= 'T2005')
                           OR (    'A0080' <= CPT
                               AND CPT <= 'A0214')
                           OR CPT IN
                                  ('A0428',
                                   'S0215',
                                   'S0209',
                                   'T2049',
                                   'A0428')) THEN
                         'TRANS-NON-ER'
                     WHEN UPPER(prcf_mctr_spec) IN ('671', '740') THEN
                         'TRANS-NON-ER'
                     ELSE
                         NULL
                 END
                     AS CAT
          FROM   mv_Claim_In_Outpatient_For_LM a
          WHERE      CDML_UNITS_ALLOW > 0
                 AND cdml_allow > 0),
     A009_h AS
         (SELECT NVL(a.clcl_id, b.clcl_id) clcl_id,
                 a.trans_er,
                 b.non_trans_er
          FROM   (SELECT   clcl_id, 'TRANS-ER' CAT, COUNT(1) trans_er
                  FROM     A009
                  WHERE    cat = 'TRANS-ER'
                  GROUP BY clcl_id) a
                 FULL JOIN
                 (SELECT   clcl_id, 'TRANS-ER' CAT, COUNT(1) non_trans_er
                  FROM     A009
                  WHERE    cat = 'TRANS-NON-ER'
                  GROUP BY clcl_id) b
                     ON (a.clcl_id = b.clcl_id))
SELECT A.*, SYSDATE CREATED_ON
FROM   (SELECT *
        FROM   (                                                     /* A001*/
                SELECT                             /* push_pred(a) no_merge */
                      DISTINCT month_id,
                               dl_lob_id lob_id,
                               PRODUCT_ID,
                               sbsb_id subscriber_id,
                               clcl_id,
                               prpr_id,
                               claimfromdt AS claimfromdt,
                               SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                               1 AS CDML_UNITS_ALLOW,
                               'AMB-SURG' AS CAT,
                               1 seq
                FROM     mv_Claim_In_Outpatient_For_LM a
                WHERE        (   pscd_id = '24'
                              OR (    '0831' <= billtype
                                  AND billtype <= '0834'))
                         AND cdml_allow > 0
                GROUP BY month_id,
                         dl_lob_id,
                         PRODUCT_ID,
                         sbsb_id,
                         clcl_id,
                         prpr_id,
                         claimfromdt)
        UNION ALL
        (                                                            /*A002 */
         SELECT                                                 /* no_merge */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        clcl_id,
                        a.prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        1 AS CDML_UNITS_ALLOW,
                        'PCP' AS CAT,
                        1 seq
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        PRCF_MCTR_SPEC IN
                          ('08',
                           '01',
                           '38',
                           '27',
                           '038',
                           '621',
                           '11',
                           '058',
                           '70',
                           '50',
                           '97',
                           '249',
                           '249P',
                           '303',
                           '303P',
                           '779W',
                           '779F',
                           '779R')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  clcl_id,
                  claimfromdt,
                  a.prpr_id)
        UNION ALL
        (                                                            /*A003 */
         SELECT /*+ no_merge  */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        clcl_id,
                        A.prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        1 AS CDML_UNITS_ALLOW,
                        'SPEC' AS CAT,
                        1 seq
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        a.PRCF_MCTR_SPEC NOT IN
                          ('08',
                           '01',
                           '38',
                           '27',
                           '038',
                           '621',
                           '11',
                           '058',
                           '70',
                           '50',
                           '97',
                           '249',
                           '249P',
                           '303',
                           '303P',
                           '779W',
                           '779F',
                           '779R',
                           '54')
                  AND CLCL_CL_SUB_TYPE = 'M'
                  AND a.PRPR_MCTR_TYPE NOT IN
                          ('AMB',
                           'AMBL',
                           'AMC',
                           'CARS',
                           'GRP',
                           'HSP',
                           'LAB',
                           'MOW',
                           'MDS')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  clcl_id,
                  claimfromdt,
                  a.prpr_id)
        UNION ALL
        (                                                            /*A004 */
         SELECT /*+ no_merge  */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        CLCL_ID,
                        prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        SUM(CDML_UNITS_ALLOW) AS CDML_UNITS_ALLOW,
                        'RADIO-DIAG' AS CAT,
                        1 seq
         FROM     mv_Claim_In_Outpatient_For_LM
         WHERE        sese_id IN
                          ('CAOP',
                           'CAOS',
                           'CATS',
                           'NCAO',
                           'CARO',
                           'PCAO',
                           'PCRO',
                           'CAOF',
                           'CATF',
                           'NCAF',
                           'NCTF',
                           'NCPF',
                           'NCRF',
                           'PCAF',
                           'PCPF',
                           'PCRF',
                           'PCTF',
                           'CDCF',
                           'CARD',
                           'CCPT',
                           'CCAT',
                           'CAR',
                           'CAPF',
                           'CASP',
                           'CAPI',
                           'CDCO',
                           'CDCF',
                           'CDCI',
                           'CDCO',
                           'RDO',
                           'RTO',
                           'RDOH',
                           'RPO',
                           'EEOP',
                           'EEPP',
                           'EETP',
                           '8DTO',
                           '8DXO',
                           '9DTO',
                           '9DXO',
                           'EEGO',
                           'EEOS',
                           'EEPT',
                           'EETS',
                           'OMP',
                           'PDTO',
                           'PDTP',
                           'PDXO',
                           'PDXP',
                           'EEOF',
                           'OMP',
                           'EETF',
                           'PDTF',
                           'PDXF',
                           'EEGH',
                           'EEGI',
                           'EEPI',
                           'EETI',
                           'ECPS',
                           'EEPF',
                           'NDPF',
                           'NDPI',
                           'NDPO',
                           'PDPF',
                           'PDPI',
                           'PDPO',
                           'PDPP',
                           'PDPS',
                           '8DPO',
                           '9DPO',
                           'CEEI',
                           'CEEO',
                           'EKGH',
                           'EKGI',
                           'RDO',
                           'OMP',
                           'GIO',
                           'RPO',
                           'RPI',
                           'CDNO',
                           'CGGO',
                           'CGGI',
                           'DXOP',
                           'DXTP',
                           '8DXO',
                           '8DTO',
                           '9DXO',
                           '9DTO',
                           'DXOS',
                           'DXTS',
                           'NDXO',
                           'NDTO',
                           'PDXO',
                           'PDTO',
                           'DXOF',
                           'NDXF',
                           'NDTF',
                           'PDTP',
                           'PDXF',
                           'PDXP',
                           'PDTF',
                           'OMP',
                           'OAN',
                           'DXPP',
                           'DXPS',
                           '8DPO',
                           'NDPO',
                           'NDPF',
                           '9DPO',
                           'PDPO',
                           'PDPF',
                           'PDPP',
                           'CDDO',
                           'CDCP',
                           'CDDI',
                           'CODI',
                           'CODO',
                           'CDNO',
                           'PULO',
                           'PUOS',
                           'PUTS',
                           'PUPI',
                           'PUPS',
                           'RDO',
                           'RTO',
                           'OMP',
                           'RDXH',
                           'RPO',
                           'CSOP',
                           'CSPF',
                           'CSPP',
                           'CSPS',
                           'CSOS',
                           'CSTP',
                           'CSTS',
                           'ULTR',
                           'VAOP',
                           'VATP',
                           'VAOS',
                           'VATS',
                           'VASO',
                           'VASF',
                           'VATF',
                           'VAPP',
                           'VAPS',
                           'VAPF')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  CLCL_ID,
                  claimfromdt,
                  prpr_id)
        UNION ALL
        (                                                            /* 005 */
         SELECT /*+  no_merge */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        CLCL_ID,
                        prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        SUM(CDML_UNITS_ALLOW) AS CDML_UNITS_ALLOW,
                        'RADIO-THERA' AS CAT,
                        1 seq
         --max(PRPR_STS) PRPR_STS,
         --max(b.PRPR_ENTITY) PRPR_ENTITY,
         --max(b.PRPR_MCTR_TYPE) PRPR_MCTR_TYPE,
         --max(b.PRCF_MCTR_SPEC) PRCF_MCTR_SPEC
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        sese_id IN
                          ('RXOS',
                           'RTXO',
                           'RXOH',
                           'RXIH',
                           'CDNO',
                           'CDDO',
                           'NYRO',
                           'PDTO',
                           'RDO',
                           'CDDF',
                           'NYRF',
                           'PYRF',
                           'PYRP',
                           'RTO',
                           'RDXH',
                           'RDIH',
                           'NYPF',
                           'NYPO',
                           'PYPF',
                           'PYPO',
                           'PYPP',
                           'RPO',
                           'CDFP',
                           'CDOP',
                           'RDO',
                           'RPO',
                           'RTO',
                           'CTO',
                           'CTOP',
                           'CTOT',
                           'CTOH',
                           'MRO',
                           'MPO',
                           'MTO',
                           'MROH',
                           'NMO',
                           'NPO',
                           'NTO',
                           'NUCL',
                           'RDO',
                           'RPO',
                           'RTO',
                           'RDIH')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  CLCL_ID,
                  claimfromdt,
                  prpr_id)
        UNION ALL
        (                                                           /* A006 */
         SELECT /*+  no_merge  */
               DISTINCT
                  month_id,
                  dl_lob_id lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  CLCL_ID,
                  prpr_id,
                  claimfromdt,
                  SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                  SUM(CDML_UNITS_ALLOW) AS CDML_UNITS_ALLOW,
                  CASE
                      WHEN sese_id IN
                               ('DCPR',
                                'DCAP',
                                'DCKJ',
                                'CAP1',
                                'DCP1',
                                'DCK1',
                                'DMO',
                                'DMOH',
                                'TNSR',
                                'OXYG',
                                'IXQE',
                                'IXQF',
                                'IXQG',
                                'OXMS',
                                'OXNU',
                                'OCNT',
                                'OCNT',
                                'OXQE',
                                'OXQF',
                                'OXQG',
                                'PENO',
                                'DMO',
                                'DMO',
                                'CDME',
                                'CXYG',
                                'USPO',
                                'USPO',
                                'CMN') THEN
                          'DME'
                      WHEN sese_id IN ('SPO', 'SPOH', 'CSPO') THEN
                          'SUPPLIES'
                      WHEN sese_id IN
                               ('ORD', 'PR', 'NIOL', 'CDME', 'USOP', 'USPO') THEN
                          'PROSTHETICS/ORTHO'
                  END
                      AS CAT,
                  1 seq
         --max(PRPR_STS) PRPR_STS,
         --max(b.PRPR_ENTITY) PRPR_ENTITY,
         --max(b.PRPR_MCTR_TYPE) PRPR_MCTR_TYPE,
         --max(b.PRCF_MCTR_SPEC) PRCF_MCTR_SPEC
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        sese_id IN
                          ('DCPR',
                           'DCAP',
                           'DCKJ',
                           'CAP1',
                           'DCP1',
                           'DCK1',
                           'DMO',
                           'DMOH',
                           'TNSR',
                           'OXYG',
                           'IXQE',
                           'IXQF',
                           'IXQG',
                           'OXMS',
                           'OXNU',
                           'OCNT',
                           'OCNT',
                           'OXQE',
                           'OXQF',
                           'OXQG',
                           'PENO',
                           'DMO',
                           'DMO',
                           'CDME',
                           'CXYG',
                           'USPO',
                           'USPO',
                           'CMN',
                           'SPO',
                           'SPOH',
                           'CSPO',
                           'ORD',
                           'PR',
                           'NIOL',
                           'CDME',
                           'USOP',
                           'USPO')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  CLCL_ID,
                  claimfromdt,
                  prpr_id,
                  sese_id)
        UNION ALL
        (                                                           /* A007 */
         SELECT /*+ no_merge  */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        CLCL_ID,
                        prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        1 AS CDML_UNITS_ALLOW,
                        'OT/PT/ST' AS CAT,
                        1 seq
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        SESE_ID IN
                          ('COTO',
                           'OTO',
                           'COTN',
                           'OTON',
                           'OTOP',
                           'OTNH',
                           'COTI',
                           'OTI',
                           'CPTO',
                           'PTO',
                           'CPTF',
                           'PTON',
                           'CPTN',
                           'PTNH',
                           'PTOH',
                           'CPTI',
                           'PTI',
                           'CSTO',
                           'STO',
                           'CSTF',
                           'STON',
                           'CSTN',
                           'STNH',
                           'STOP',
                           'CSTI',
                           'STI')
                  AND cdml_allow > 0
         GROUP BY month_id,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  prpr_id,
                  CLCL_ID,
                  claimfromdt)
        UNION ALL
        (                                                            /*A008 */
         SELECT /*+ no_merge */
               DISTINCT month_id,
                        dl_lob_id lob_id,
                        PRODUCT_ID,
                        sbsb_id,
                        CLCL_ID,
                        prpr_id,
                        claimfromdt,
                        SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                        SUM(CDML_UNITS_ALLOW) AS CDML_UNITS_ALLOW,
                        'HH' AS CAT,
                        1 seq
         FROM     mv_Claim_In_Outpatient_For_LM A
         WHERE        SUBSTR(billtype, 1, 3) IN
                          ('032', '033', '034', '035', '036', '037')
                  AND (   CPT IN
                              ('G0156',
                               'S5125',
                               'S5126',
                               'S5130',
                               'S5181',
                               'S9122',
                               'S9123',
                               'S9124',
                               'S9802',
                               'S9127',
                               'G0176',
                               'T1001',
                               'T1019',
                               'T1023',
                               'T1028',
                               'T1030',
                               'T1031',
                               'G0152',
                               'S9129',
                               'G0151',
                               'S9131',
                               'G0237',
                               'G0238',
                               'S9128',
                               'S9452',
                               'S9470',
                               '99500',
                               '99501',
                               '99502',
                               '99503',
                               '99504',
                               '99505',
                               '99506',
                               '99507',
                               '99511',
                               '99512',
                               '99600')
                       OR rcrc_id IN
                              ('0022',
                               '0023',
                               '0024',
                               '0570',
                               '0572',
                               '0579',
                               '0580',
                               '0581',
                               '0582',
                               '0583',
                               '0589'))
         GROUP BY month_id,
                  CLCL_ID,
                  dl_lob_id,
                  PRODUCT_ID,
                  sbsb_id,
                  prpr_id,
                  claimfromdt)
        --) A
        UNION ALL
        (SELECT /*+ no_merge  */
               month_id,
                dl_lob_id lob_id,
                PRODUCT_ID,
                sbsb_id,
                CLCL_ID,
                prpr_id,
                claimfromdt,
                CDML_PAID_AMT,
                CDML_UNITS_ALLOW,
                CASE
                    WHEN     non_emg IS NOT NULL
                         AND cat = 'TRANS-ER' THEN
                        'TRANS-NON-ER'
                    ELSE
                        CAT
                END
                    CAT,
                1 seq
         FROM   (SELECT /*+ no_merge  */
                       DISTINCT a.*, b.clcl_id AS non_emg
                 FROM   A009 a
                        LEFT JOIN (A009_h) b
                            ON (    a.clcl_id = b.clcl_id
                                AND trans_er IS NOT NULL
                                AND non_trans_er IS NOT NULL))) --UNION ALL SELECT * FROM otc_data
                                                               ) A;


COMMENT ON MATERIALIZED VIEW CHOICEBI.MV_OUTPATIENT_MATRIX_DATA IS 'snapshot table for snapshot CHOICEBI.MV_OUTPATIENT_MATRIX_DATA';

GRANT SELECT ON CHOICEBI.MV_OUTPATIENT_MATRIX_DATA TO DW_OWNER;

GRANT SELECT ON CHOICEBI.MV_OUTPATIENT_MATRIX_DATA TO MSTRSTG;

GRANT SELECT ON CHOICEBI.MV_OUTPATIENT_MATRIX_DATA TO ROC_RO;
