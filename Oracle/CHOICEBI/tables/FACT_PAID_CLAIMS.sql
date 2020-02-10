create table FACT_PAID_CLAIMS
( 
SBSB_ID                VARCHAR2 (9),
CLCL_ID                VARCHAR2 (12),
CLCL_LOW_SVC_DT        DATE,
CLAIM_BASE             VARCHAR2 (11),
CLAIM_SEQ              VARCHAR2 (1),
CLCL_ID_ADJ_FROM       VARCHAR2 (12),
CLCL_ID_ADJ_TO         VARCHAR2 (12),
CLCL_PAID_DT           DATE,
CLCL_HIGH_SVC_DT       DATE,
CLCL_INPUT_DT          DATE,
CLCL_CUR_STS           VARCHAR2 (2),
CLCL_TOT_PAYABLE       NUMBER ,
CLCL_TOT_CHG           NUMBER ,
PRIOR_CLCL_CUR_STS     VARCHAR2 (2),
PRIOR_CLCL_TOT_PAYABLE NUMBER ,
FINAL_CLCL_TOT_PAYABLE NUMBER ,
FINAL_NET_AMOUNT       NUMBER ,
final_net_amount2      NUMBER ,
PRPR_NAME              VARCHAR2 (55),
PRPR_MCTR_TYPE         VARCHAR2 (4),
CDML_CHG_AMT           NUMBER ,
CDML_DISALL_AMT        NUMBER ,
CDML_ALLOW             NUMBER ,
CDML_PAID_AMT          NUMBER ,
CKPY_REF_ID            VARCHAR2 (16),
CKPY_PAY_DT            DATE,
CLCK_ALLOW             NUMBER ,
CLCK_ORIG_AMT          NUMBER ,
CLCK_PRIOR_PD          NUMBER ,
CLCK_INT_AMT           NUMBER ,
CLCK_NET_AMT           NUMBER ,
CLCK_COMB_IND          VARCHAR2 (1),
CKCK_CK_NO             NUMBER (10),
CKCK_CURR_STS          VARCHAR2 (12),
CKCK_PRINTED_DT        DATE,
CKCK_REISS_DT          DATE,
CKCK_REISS_DT1         VARCHAR2 (9),
CKCK_PAYEE_NAME        VARCHAR2 (50),
PYPY_ID                VARCHAR2 (18),
CKCK_SEQ_NO            NUMBER ,
CKST_STS               VARCHAR2 (12),
CKST_STS_DT            DATE,
CKPY_PAYEE_PR_ID       VARCHAR2 (22),
CKPY_TYPE              VARCHAR2 (12),
CKPY_PYMT_TYPE         VARCHAR2 (12),
CKPY_PER_END_DT        DATE,
CKPY_ORIG_AMT          NUMBER,
CKPY_DEDUCT_AMT        NUMBER,
CKPY_NET_AMT           NUMBER,
PDPD_ID                VARCHAR2 (10),
SYS_UPD_TS             DATE,
MEMBER_ID              NUMBER,
DL_LOB_ID              NUMBER,
PRODUCT_NAME           VARCHAR2 (100),
DL_PLAN_SK             NUMBER
)

insert into FACT_PAID_CLAIMS
WITH tmg1 AS
(
    SELECT /*+ no_merge materialize  */
        G.SBSB_ID,
        M.CLCL_ID,
        M.CLCL_LOW_SVC_DT,
        SUBSTR(M.CLCL_ID, 1, 11) AS CLAIM_BASE,
        SUBSTR(M.CLCL_ID, 12, 13) AS CLAIM_SEQ,
        M.CLCL_ID_ADJ_FROM,
        M.CLCL_ID_ADJ_TO,
        M.CLCL_PAID_DT,
        M.CLCL_HIGH_SVC_DT,
        M.CLCL_INPUT_DT,
        M.CLCL_CUR_STS,
        M.CLCL_TOT_PAYABLE,
        M.CLCL_TOT_CHG,
        P.CLCL_CUR_STS AS PRIOR_CLCL_CUR_STS,
        P.CLCL_TOT_PAYABLE AS PRIOR_CLCL_TOT_PAYABLE,
        NVL(M.CLCL_TOT_PAYABLE, 0) - NVL(P.CLCL_TOT_PAYABLE, 0) AS FINAL_CLCL_TOT_PAYABLE,
        NVL((NVL(M.CLCL_TOT_PAYABLE, 0)  - NVL(P.CLCL_TOT_PAYABLE, 0)), 0) + NVL(O.CLCK_INT_AMT, 0) AS FINAL_NET_AMOUNT,
        nvl((nvl(m.clcl_tot_payable, 0)-nvl(clck_prior_pd, 0)),0)+nvl(clck_int_amt, 0) as final_net_amount2,
        Q.PRPR_NAME,
        Q.PRPR_MCTR_TYPE,                                      --
        L.CDML_CHG_AMT,
        L.CDML_DISALL_AMT,
        L.CDML_ALLOW,
        L.CDML_PAID_AMT,                                        --
        O.CKPY_REF_ID,
        O.CKPY_PAY_DT,
        O.CLCK_ALLOW,
        O.CLCK_ORIG_AMT,
        O.CLCK_PRIOR_PD,
        O.CLCK_INT_AMT,
        O.CLCK_NET_AMT,
        O.CLCK_COMB_IND,
        A.CKCK_CK_NO,
        A.CKCK_CURR_STS,
        A.CKCK_PRINTED_DT,
        A.CKCK_REISS_DT,
        DECODE(TRUNC(A.CKCK_REISS_DT), TO_DATE('01Jan1753'), NULL, TRUNC(A.CKCK_REISS_DT)) AS CKCK_REISS_DT1,
        A.CKCK_PAYEE_NAME,
        A.PYPY_ID,
        C.CKCK_SEQ_NO,
        C.CKST_STS,
        C.CKST_STS_DT,
        B.CKPY_PAYEE_PR_ID,
        B.CKPY_TYPE,
        B.CKPY_PYMT_TYPE,
        B.CKPY_PER_END_DT,
        B.CKPY_ORIG_AMT,
        B.CKPY_DEDUCT_AMT,
        B.CKPY_NET_AMT,
        m.PDPD_ID
    FROM   TMG1.CMC_CLCL_CLAIM M
        LEFT JOIN TMG1.CMC_CLCL_CLAIM P ON (P.CLCL_ID = M.CLCL_ID_ADJ_FROM)
        LEFT JOIN TMG1.CMC_MEME_MEMBER F ON M.MEME_CK=F.MEME_CK
        LEFT JOIN TMG1.CMC_SBSB_SUBSC G ON F.SBSB_CK=G.SBSB_CK                     
        LEFT JOIN TMG1.CMC_PRPR_PROV Q ON Q.PRPR_ID = M.PRPR_ID
        LEFT JOIN TMG1.CMC_CLCK_CLM_CHECK O ON (M.CLCL_ID = O.CLCL_ID)
        LEFT JOIN (SELECT   CLCL_ID,
                       SUM(CDML_CHG_AMT) AS CDML_CHG_AMT,
                       SUM(CDML_ALLOW) AS CDML_ALLOW,
                       SUM(CDML_PAID_AMT) AS CDML_PAID_AMT,
                       SUM(CDML_DISALL_AMT) AS CDML_DISALL_AMT
                      FROM     TMG1.CMC_CDML_CL_LINE
                      GROUP BY CLCL_ID) L ON (L.CLCL_ID = M.CLCL_ID)
         LEFT JOIN TMG1.CMC_CKCK_CHECK A ON (A.CKPY_REF_ID = O.CKPY_REF_ID)
         LEFT JOIN TMG1.CMC_CKST_STATUS C ON (O.CKPY_REF_ID = C.CKPY_REF_ID AND O.CKPY_PAY_DT = C.CKST_STS_DT)
         LEFT JOIN TMG1.CMC_CKPY_PAYEE_SUM B ON (    O.CKPY_REF_ID = B.CKPY_REF_ID AND CKPY_TYPE = 'CL')
    WHERE      1 = 1
         AND (m.clcl_low_svc_dt > '01jan2014' OR m.clcl_paid_dt > '01jan2014')
         AND M.CLCL_CUR_STS IN ('02', '91')
),
fida1 AS
(
    SELECT /*+ no_merge materialize */
            G.SBSB_ID,
            M.CLCL_ID,
            M.CLCL_LOW_SVC_DT,
            SUBSTR(M.CLCL_ID, 1, 11) AS CLAIM_BASE,
            SUBSTR(M.CLCL_ID, 12, 13) AS CLAIM_SEQ,
            M.CLCL_ID_ADJ_FROM,
            M.CLCL_ID_ADJ_TO,
            M.CLCL_PAID_DT,
            M.CLCL_HIGH_SVC_DT,
            M.CLCL_INPUT_DT,
            M.CLCL_CUR_STS,
            M.CLCL_TOT_PAYABLE,
            M.CLCL_TOT_CHG,
            P.CLCL_CUR_STS AS PRIOR_CLCL_CUR_STS,
            P.CLCL_TOT_PAYABLE AS PRIOR_CLCL_TOT_PAYABLE,
            NVL(M.CLCL_TOT_PAYABLE, 0) - NVL(P.CLCL_TOT_PAYABLE, 0) AS FINAL_CLCL_TOT_PAYABLE,
            NVL((  NVL(M.CLCL_TOT_PAYABLE, 0) - NVL(P.CLCL_TOT_PAYABLE, 0)),  0) + NVL(O.CLCK_INT_AMT, 0) AS FINAL_NET_AMOUNT,
            nvl((nvl(m.clcl_tot_payable, 0)-nvl(clck_prior_pd, 0)),0)+nvl(clck_int_amt, 0) as final_net_amount2  ,
            Q.PRPR_NAME,
            Q.PRPR_MCTR_TYPE,
            L.CDML_CHG_AMT,
            L.CDML_DISALL_AMT,
            L.CDML_ALLOW,
            L.CDML_PAID_AMT,
            O.CKPY_REF_ID,
            O.CKPY_PAY_DT,
            O.CLCK_ALLOW,
            O.CLCK_ORIG_AMT,
            O.CLCK_PRIOR_PD,
            O.CLCK_INT_AMT,
            O.CLCK_NET_AMT,
            O.CLCK_COMB_IND,
            A.CKCK_CK_NO,
            A.CKCK_CURR_STS,
            A.CKCK_PRINTED_DT,
            A.CKCK_REISS_DT,
            DECODE(TRUNC(A.CKCK_REISS_DT),
            TO_DATE('01Jan1753'), NULL,
            TRUNC(A.CKCK_REISS_DT))
            AS CKCK_REISS_DT1,
            A.CKCK_PAYEE_NAME,
            A.PYPY_ID                                              --
            ,
            C.CKCK_SEQ_NO,
            C.CKST_STS,
            C.CKST_STS_DT,
            B.CKPY_PAYEE_PR_ID,
            B.CKPY_TYPE,
            B.CKPY_PYMT_TYPE,
            B.CKPY_PER_END_DT,
            B.CKPY_ORIG_AMT,
            B.CKPY_DEDUCT_AMT,
            B.CKPY_NET_AMT,
            m.PDPD_ID
      FROM   tmg_fida.Cmc_clcl_claim m
                LEFT JOIN tmg_fida.CMC_MEME_MEMBER F ON M.MEME_CK=F.MEME_CK
                LEFT JOIN tmg_fida.CMC_SBSB_SUBSC G ON F.SBSB_CK=G.SBSB_CK                     
                LEFT JOIN tmg_fida.Cmc_clcl_claim p ON (p.clcl_id = m.clcl_id_adj_from)
                LEFT JOIN tmg_fida.CMC_prpr_prov q ON q.prpr_id = m.prpr_id
                LEFT JOIN tmg_fida.cmc_clck_clm_check o ON (m.clcl_id = o.clcl_id)
                LEFT JOIN (SELECT   clcl_id,
                                   SUM(cdml_chg_amt) AS cdml_chg_amt,
                                   SUM(cdml_allow) AS cdml_allow,
                                   SUM(cdml_paid_amt) AS cdml_paid_amt,
                                   SUM(cdml_disall_amt) AS cdml_disall_amt
                          FROM     tmg_fida.CMC_CDML_CL_LINE
                          GROUP BY clcl_id) l ON (l.clcl_id = m.clcl_id)
                LEFT JOIN tmg_fida.cmc_ckck_check a ON (a.ckpy_ref_id = o.ckpy_ref_id)
                LEFT JOIN tmg_fida.cmc_ckst_status c ON (    o.ckpy_ref_id = c.ckpy_ref_id AND o.ckpy_pay_dt = c.ckst_sts_dt)
                LEFT JOIN tmg_fida.cmc_ckpy_payee_sum b ON (    o.ckpy_ref_id = b.ckpy_ref_id AND ckpy_type = 'CL')
              WHERE      1 = 1
                     AND (m.clcl_low_svc_dt > '01jan2014' OR m.clcl_paid_dt > '01jan2014')
                     AND m.clcl_cur_sts IN ('02', '91')
),src as
(
    SELECT  a.*, sysdate SYS_UPD_TS FROM   tmg1 A
    UNION ALL
    SELECT A.*, sysdate SYS_UPD_TS FROM   fida1 A
)
SELECT 
    SRC.*, MEM.MEMBER_ID,  DL_LOB_ID,  PRODUCT_NAME, DL_PLAN_SK
FROM 
    SRC
    LEFT JOIN (SELECT /*+ no_merge materialize */  MEM.*,  ROW_NUMBER() OVER (PARTITION BY SBSB_ID ORDER BY SBSB_ID DESC) SEQ FROM CHOICE.DIM_MEMBER_DETAIL@DLAKE mem) MEM ON (SRC.SBSB_ID =MEM.SBSB_ID AND SEQ = 1)      
    LEFT JOIN (SELECT  /*+ no_merge materialize */  DL_LOB_ID,
                         PRODUCT_ID,
                         CLASS_ID,
                         GRGR_CK,
                         MAX(PRODUCT_NAME) PRODUCT_NAME,
                         MAX(DL_PLAN_SK) DL_PLAN_SK
                FROM     CHOICE.REF_PLAN@DLAKE
                GROUP BY DL_LOB_ID,
                         PRODUCT_ID,
                         CLASS_ID,
                         GRGR_CK) REFPLAN ON (src.PDPD_ID = REFPLAN.PRODUCT_ID)
    
    
    




lu_sql


begin
ETL.P_REFRESH_MV('CHOICEBI.FACT_PAID_CLAIMS');
end;