insert into FACT_IP_READMISSION_DATA
/******************* SQL for step1_a **********************/
select * 
from
(
    WITH step1_a AS
    (
        SELECT /*+ materialize no_merge */
            DISTINCT
            a.clcl_id,
            a.meme_ck,
            TRUNC(a.CLHP_STAMENT_FR_DT) AS CLHP_STAMENT_FR_DT,
            TRUNC(a.CLHP_STAMENT_TO_DT) AS CLHP_STAMENT_TO_DT,
            a.CLHP_DC_STAT,
            CLHP_ADM_TYP,
            clhp_Fac_type ||
            clhp_bill_class ||
            clhp_frequency AS billtype,                                    /* catt */
            c.CLCL_TOT_PAYABLE,
            c.prpr_id,
            prpr_name,
            REPLACE(REPLACE(REPLACE(REPLACE(e.idcd_id, 'N'), 'U'), 'W'), 'Y') AS idcd_id,
            idcd_desc,                                       /* compres */
            CASE
                WHEN CLOR_OR_VALUE = '' THEN CLHP_INPUT_AGRG_ID
                ELSE CLOR_OR_VALUE
            END AS grgr_id,
            TRUNC(a.CLHP_STAMENT_FR_DT) - 1 AS previous_dt,
            TRUNC(a.CLHP_STAMENT_FR_DT) + 1 AS after_dt
          FROM   
                tmg1.Cmc_clhp_hosp@nexus2 A
                JOIN tmg1.cmc_clcl_claim@nexus2 C ON a.clcl_id = c.clcl_id
                JOIN tmg1.cmc_prpr_prov@nexus2 D ON c.prpr_id = d.prpr_id
                LEFT JOIN tmg1.cmc_clmd_diag@nexus2 E ON c.clcl_id = e.clcl_id AND e.clmd_type = '01'
                LEFT JOIN tmg1.cmc_clor_cl_ovr@nexus2 F ON (a.clcl_id = f.clcl_id AND CLOR_OR_ID = 'GO')
                JOIN tmg1.Cmc_idcd_diag_cd@nexus2 G ON e.idcd_id = g.idcd_id AND TRUNC(a.CLHP_STAMENT_FR_DT) BETWEEN TRUNC(g.IDCD_EFF_DT) AND TRUNC(g.IDCD_TERM_DT)
          WHERE      
                    TRUNC(a.CLHP_STAMENT_TO_DT) BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR( SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1
                AND clcl_CUR_STS NOT IN ('91', '99')
                AND CLCL_TOT_PAYABLE > 0
                AND CLHP_FAC_TYPE = '01'
                AND CLHP_BILL_CLASS IN ('1', '2')
                AND CLCL_INPUT_DT <= TRUNC(SYSDATE)
                AND cscs_iD IN ('1000')
     )
     /******* Pulling Value Options inpatient Claims for Medicare ************************************/
     , step1_b AS
     (
        SELECT /*+ materialize no_merge */
                DISTINCT
                 CLMREV,
                 TRUNC(a.HOSBEG) AS CLHP_STAMENT_FR_DT,
                 TRUNC(a.HOSEND) AS CLHP_STAMENT_TO_DT,
                 a.CLAIMNO AS clcl_id,
                 c.meme_ck,
                 a.DISTAT AS CLHP_DC_STAT,
                 a.ALWAMT AS CLCL_TOT_PAYABLE,
                 '0' || BILCOD AS billtype,
                 PROVNO AS prpr_id,
                 SVVLST || SVVFST AS Prpr_name,
                 REPLACE(DIAGN1, '.') AS idcd_id,
                 IDCD_desc,
                 CASE WHEN TYPCOD = 'RC' THEN SVCCOD ELSE '' END AS grgr_id
          FROM   vns_choice1.Value_options@nexus2 a
                 JOIN tmg1.cmc_sbsb_subsc@nexus2 B ON SUBSTR(a.MEMBNO, 1, 9) = b.sbsb_id
                 JOIN tmg1.cmc_meme_member@nexus2 C ON b.sbsb_ck = c.sbsb_ck
                 LEFT JOIN tmg1.Cmc_idcd_diag_cd@nexus2 D ON     REPLACE(DIAGN1, '.', '') = REPLACE(D.IDCD_ID, ' ', '') AND TRUNC(a.HOSBEG) BETWEEN TRUNC(d.IDCD_EFF_DT) AND TRUNC(d.IDCD_TERM_DT)
          WHERE      ENDDAT BETWEEN '30-NOV-2015' AND SYSDATE
                 AND LINENO = '001'
                 AND ALWAMT > 0
                 AND (BILCOD LIKE '11%' OR BILCOD LIKE '12%')
                 AND RCVDAT <= TRUNC(SYSDATE)
     )
     /******************* SQL for step1_bb **********************/
     , step1_bb AS
     (
        SELECT /*+ materialize no_merge */
                DISTINCT
                 CLMREV,
                 TRUNC(a.HOSBEG) AS CLHP_STAMENT_FR_DT,
                 TRUNC(a.HOSEND) AS CLHP_STAMENT_TO_DT,
                 a.CLAIMNO AS clcl_id,
                 c.meme_ck,
                 a.DISTAT AS CLHP_DC_STAT,
                 a.ALWAMT AS CLCL_TOT_PAYABLE,
                 '0' || BILCOD AS billtype,
                 PROVNO AS prpr_id,
                 SVVLST || SVVFST AS Prpr_name,
                 REPLACE(DIAGN1, '.') AS idcd_id,
                 IDCD_desc,
                 CASE WHEN TYPCOD = 'RC' THEN SVCCOD ELSE '' END AS gsrgr_id
          FROM   vns_choice1.Value_options_sh@nexus2 a
                 JOIN tmg1.cmc_sbsb_subsc@nexus2 B ON SUBSTR(a.MEMBNO, 1, 9) = b.sbsb_id
                 JOIN tmg1.cmc_meme_member@nexus2 C ON b.sbsb_ck = c.sbsb_ck
                 LEFT JOIN tmg1.Cmc_idcd_diag_cd@nexus2 D ON     REPLACE(DIAGN1, '.') = REPLACE(D.IDCD_ID, ' ', '') AND TRUNC(a.HOSBEG) BETWEEN TRUNC(d.IDCD_EFF_DT) AND TRUNC(d.IDCD_TERM_DT)
          WHERE            
                   ENDDAT BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR(SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1
               AND LINENO = '001'
               AND ALWAMT > 0
               AND (BILCOD LIKE '11%' OR BILCOD LIKE '12%')
               AND RCVDAT <= TRUNC(SYSDATE)
     )
     /******************* SQL for step1_bbb, step1_b1, step1_b2 **********************/
     , step1_bbb AS
     (SELECT *
          FROM   step1_b outer
          UNION
          SELECT * FROM step1_bb)/** remove reversed claims***/
     , step1_b1 AS
     (SELECT *
          FROM   step1_bbb
          WHERE  CLMREV = 'Y')
     ,step1_b2 AS
     (SELECT A.*
          FROM   step1_bbb a LEFT JOIN step1_b1 b ON A.clcl_id = B.clcl_id
          WHERE  B.clcl_id IS NULL
          )
    /******************* SQL for step1_b4 **********************/
   /**************************************************************************************************************************************/
   /**************************************** Pulling ALL inpatient Auths ******************************************************************/
   /************** umit_sts not in (DS,CL,IN) deletes auths that were disallowed or voided or pend with errors ****************************/
   /***************************************************************************************************************************************/
     , step1_b4 AS
     (
        SELECT /*+ materialize no_merge */
                DISTINCT
                 a.UMUM_REF_ID AS clcl_id,
                 a.meme_ck,
                 TRUNC(a.UMIN_ACT_ADM_DT) AS CLHP_STAMENT_FR_DT,
                 UMIN_IDCD_ID_PRI AS idcd_id,
                 idcd_desc,
                 CASE
                     WHEN TRUNC(a.UMIN_DC_DTM) = TO_DATE('01jan1753') THEN
                         NULL
                     ELSE
                         TRUNC(a.UMIN_DC_DTM)
                 END
                     AS CLHP_STAMENT_TO_DT,
                 UMIN_PRPR_ID_FAC AS prpr_id,
                 prpr_name,
                 NULL grgr_id,
                 NULL CLHP_DC_STAT,
                 NULL CLCL_TOT_PAYABLE,
                 NULL BILLTYPE
          FROM   tmg1.Cmc_umin_inpatient@nexus2 A
                 JOIN tmg1.Cmc_mepe_prcs_elig@nexus2 B ON     a.meme_ck = b.meme_ck AND MEPE_ELIG_IND = 'Y' AND TRUNC(a.UMIN_ACT_ADM_DT) BETWEEN TRUNC( mepe_eff_dt) AND TRUNC( mepe_term_dt)
                 JOIN tmg1.cmc_meme_member@nexus2 C ON a.meme_ck = c.meme_ck
                 JOIN tmg1.cmc_sbsb_subsc@nexus2 D ON c.sbsb_ck = d.sbsb_ck
                 LEFT JOIN tmg1.cmc_prpr_prov@nexus2 E ON a.UMIN_PRPR_ID_FAC = E.prpr_id
                 LEFT JOIN tmg1.Cmc_idcd_diag_cd@nexus2 f ON     a.IDCD_ID_ADM_SUB = f.idcd_id AND TRUNC(a.UMIN_ACT_ADM_DT) BETWEEN TRUNC( f.IDCD_EFF_DT) AND TRUNC( f.IDCD_TERM_DT)
          WHERE      TRUNC(UMIN_ACT_ADM_DT) BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR(SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1
                 AND B.pdpd_id NOT IN ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')
                 AND TRUNC(UMIN_INPUT_DT) <= TRUNC(SYSDATE)
                 AND SUBSTR(umin_prpr_id_fac, 1, 4) = 'HOSP'
                 AND umit_sts NOT IN ('DS', 'CL', 'IN' )
     )
     /* umit_sts this deletes auths that were disallowed or voided or pend with errors*;*/
     , step1_b5 AS
     (
        SELECT *
        FROM   STEP1_B4
        WHERE  (MEME_CK, CLHP_STAMENT_FR_DT) NOT IN (SELECT /*+ no_merge */DISTINCT MEME_CK, CLHP_STAMENT_FR_DT FROM STEP1_A)
      )
      /*** Bacause some of the admin date in the auth data has a +/- 1 day as admin date.. Have to re-match to ensure that there is no claim for the auth with a +\- 1 day *****/
     , step1_b6 AS
     (
          SELECT 
                DISTINCT A.*
          FROM  STEP1_B5 A
                JOIN STEP1_A B ON A.MEME_CK = B.MEME_CK AND A.CLHP_STAMENT_FR_DT BETWEEN B.PREVIOUS_DT AND B.AFTER_DT
     )
     , step1_b7 AS
     (
        SELECT DISTINCT A.*
        FROM   STEP1_B5 A
             LEFT JOIN STEP1_B6 B ON  A.MEME_CK = B.MEME_CK AND A.CLHP_STAMENT_FR_DT = B.CLHP_STAMENT_FR_DT
        WHERE      B.MEME_CK IS NULL AND B.CLHP_STAMENT_FR_DT IS NULL
      )
     /*************** Merge claims, Auth & VO inpatient admissions****************************;*/
     , Step1_c AS
     (
        SELECT A.*,
             CASE
                 WHEN LENGTH(GRGR_ID) = 5 THEN SUBSTR(GRGR_ID, 3, 3)
                 WHEN LENGTH(GRGR_ID) = 4 THEN SUBSTR(GRGR_ID, 2, 3)
                 WHEN LENGTH(GRGR_ID) = 3 THEN GRGR_ID
                 WHEN LENGTH(GRGR_ID) > 1 THEN SUBSTR(GRGR_ID, 1, 3)
                 WHEN LENGTH(GRGR_ID) = 1 THEN SUBSTR(GRGR_ID, 1, 3)
             END AS DRG_CODE
        FROM   
        (
                SELECT
                         BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   STEP1_B2
                  UNION ALL
                  SELECT BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   STEP1_A
                  UNION ALL
                  SELECT BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   
                         STEP1_B7
          ) A
    )
     /******************* SQL for Step1_c end **********************/
     --*** Step2: Acute to acute transfers ***;
     --************************************************************************;
     --*** similar to laura's translation for in07_Ca in 07-IP_Admission_LW ***;
     --************************************************************************;
     /******************* SQL for acute_ips **********************/
    , acute_ips AS
     (SELECT c.*,
             MIN(CLHP_STAMENT_FR_DT) OVER (PARTITION BY meme_ck, member_adm_seq) AS new_adm_dt,
             MAX(CLHP_STAMENT_TO_DT) OVER (PARTITION BY meme_ck, member_adm_seq) AS new_dis_dt
       FROM   
       (
                SELECT b.*,
                           SUM(
                               CASE
                                   WHEN diff IS NULL THEN 0
                                   WHEN diff IN (1) THEN 0
                                   WHEN diff >= 2 THEN 1
                               END) OVER (PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT)  + 1 AS member_adm_seq
                  FROM   (
                            SELECT a.*,
                                 LAG(CLHP_STAMENT_FR_DT, 1) OVER ( ORDER BY meme_ck, CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS lag_adm_dt,
                                 LAG(CLHP_STAMENT_TO_DT, 1) OVER ( ORDER BY meme_ck, CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS lag_dis_dt,
                                 ROW_NUMBER() OVER ( PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS seq1,
                                 CLHP_STAMENT_FR_DT - LAG( CLHP_STAMENT_TO_DT, 1) OVER ( PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS diff
                            FROM   step1_c a
                          ) b 
          ) c
      )/******************* SQL for acute_ips end **********************/
     /******************* SQL for transfer_collapse **********************/
     , transfer_collapse AS
         (SELECT   meme_ck,
                   clcl_id,
                   prpr_id,
                   prpr_name,
                   new_adm_dt,
                   new_dis_dt,
                   CLHP_DC_STAT,
                   IDCD_id,
                   DRG_code
          FROM     acute_ips
          GROUP BY meme_ck,
                   new_adm_dt,
                   new_dis_dt,
                   clcl_id,
                   prpr_id,
                   prpr_name,
                   CLHP_DC_STAT,
                   IDCD_id,
                   DRG_code
    )
    /******************* SQL for transfer_collapse end  **********************/
    /******************* SQL for step3b **********************/
     , step3b AS
    (SELECT   c.meme_ck,
                   TRUNC(MIN(CLHP_STAMENT_FR_DT)) AS new_adm_dt,
                   TRUNC(MAX(CLHP_STAMENT_TO_DT)) AS new_dis_dt,
                   SUM(CLCL_TOT_PAYABLE) AS Tot_Paid
          FROM acute_ips c
          GROUP BY 
            meme_ck, 
            member_adm_seq
    )
    /******************* SQL for step3b end **********************/
    --****** Keep the original admission Date as the Index Admission Date, and the transfer's discharge date as the  Index Discharge Date *;
    /******************* SQL for step2 **********************/
     , step2 AS
         (SELECT *
          FROM   (SELECT meme_ck,
                         clcl_id,
                         prpr_id,
                         prpr_name,
                         new_adm_dt AS CLHP_STAMENT_FR_DT,
                         new_dis_dt AS CLHP_STAMENT_TO_DT,
                         clhp_dc_stat,
                         idcd_id,
                         drg_code,
                         ROW_NUMBER() OVER (PARTITION BY meme_ck, new_adm_dt ORDER BY new_dis_dt DESC) AS seq3
                  FROM   transfer_collapse a
              )
          WHERE  seq3 = 1
      )
      /******************* SQL for step2 end **********************/
     , step3 AS
     (
        SELECT * FROM   step2 WHERE   CLHP_STAMENT_TO_DT >= '01-jan-2016'
     )
    /**** step 5: Exclude pregnancy inpatient stay and deaths during confinements*****/
     , diag AS
         (SELECT DISTINCT a.*,
                          b.clmd_type,
                          b.idcd_id AS PregDX,
                          sbsb_last_name,
                          sbsb_first_name,
                          d.sbsb_id,
                          Tot_Paid
          FROM   step3 A
                 LEFT JOIN tmg1.cmc_clmd_diag@nexus2 b
                     ON b.clcl_id = a.clcl_id
                 JOIN tmg1.cmc_meme_member@nexus2 C ON a.meme_ck = c.meme_ck
                 JOIN tmg1.cmc_sbsb_subsc@nexus2 D ON c.sbsb_ck = d.sbsb_ck
                 LEFT JOIN step3b E
                     ON     a.meme_ck = e.meme_ck
                        AND a.CLHP_STAMENT_FR_DT = e.new_adm_dt
    ) 
    , step4_b AS
     (
         SELECT *
          FROM   
          (
               SELECT clcl_id,
                     clhp_dc_stat,
                     clhp_stament_fr_dt,
                     clhp_stament_to_dt,
                     drg_code,
                     idcd_id,
                     meme_ck,
                     prpr_id,
                     prpr_name,
                     sbsb_first_name,
                     sbsb_id,
                     sbsb_last_name,
                     tot_paid,
                     CASE
                         WHEN pregdx >= '630' AND pregdx < '680' AND clmd_type = '01' THEN 1
                         WHEN SUBSTR(PregDX, 1, 3) IN ('V22', 'V23', 'V28') AND CLMD_TYPE = '01' THEN 1
                         WHEN pregdx >= '760' AND pregdx < '780' THEN 1
                         WHEN pregdx >= 'V28' AND pregdx < 'V40' THEN 1
                         WHEN SUBSTR(idcd_id, 1, 3) = 'V21' THEN 1
                         ELSE 0
                     END AS matern_flg,
                     ROW_NUMBER() OVER (PARTITION BY clcl_id ORDER BY  clcl_id) AS seq2
              FROM   diag
          )
          WHERE  seq2 = 1
     )
, step4_c AS
(
    SELECT 
        a.*,
        1 AS denom,
        TO_NUMBER(TO_CHAR(CLHP_STAMENT_FR_DT, 'YYYYMM')) AS month_id
    FROM step4_b a
    WHERE
        CLHP_DC_STAT NOT IN ('20') OR CLHP_DC_STAT IS NULL AND matern_flg = 0
)
,step4_d AS (SELECT * FROM fact_member_month)
,step5 AS
(
    SELECT /*+ materializ no_merge */ 
            DISTINCT  a.*,MEMBER_ID,      
                      SUBSCRIBER_ID,      
                      DL_LOB_ID ,          
                      DL_PLAN_SK ,         
                      CM_SK_ID    ,        
                      DL_ASSESS_SK ,       
                      DL_MEMBER_ADDRESS_SK
    FROM step4_c A
    LEFT JOIN step4_d B ON a.sbsb_id = b.SUBSCRIBER_ID AND a.month_id = b.month_id
)
, step5b AS
(
    SELECT DISTINCT
         a.*,
         CASE
             WHEN CLHP_STAMENT_TO_DT IS NULL THEN CLHP_STAMENT_FR_DT
             ELSE CLHP_STAMENT_TO_DT
         END
             AS discharge_dt
    FROM   step5 A
)
/* step6 when discrepancy stick with SQL  */
, step6 AS
(
        SELECT a.* 
        FROM   
            (
                    SELECT a.*,
                         LAG(CLHP_STAMENT_TO_DT, 1) OVER (ORDER BY MEME_CK, CLHP_STAMENT_TO_DT) AS lag_dis_dt,
                         LAG(MEME_CK, 1) OVER (ORDER BY MEME_CK) AS lag_meme_ck
                    FROM   step5 a
            ) a
        WHERE      
            CLHP_STAMENT_FR_DT - lag_dis_dt <= 30
            AND lag_meme_ck = meme_ck
)
, step7 AS
(
    SELECT a.*,
         CASE
             WHEN a.clcl_id IS NOT NULL AND b.clcl_id IS NOT NULL THEN 1
             ELSE 0
         END readmit,
         a.CLHP_STAMENT_TO_DT - a.CLHP_STAMENT_FR_DT AS los
    FROM   step5 a LEFT JOIN Step6 b ON (a.clcl_id = b.clcl_id)
)
, step7b as
(
    select * from step7 where readmit=1 
)
SELECT
    'MA-SH' SRC,
    MONTH_ID,
    SUBSCRIBER_ID,
    MEMBER_ID           ,
    DL_LOB_ID           ,
    DL_PLAN_SK          ,
    CM_SK_ID            ,
    DL_ASSESS_SK        ,
    DL_MEMBER_ADDRESS_SK,
    CLHP_STAMENT_FR_DT,
    CLHP_STAMENT_TO_DT,
    TOT_PAID,
    MATERN_FLG,
    DENOM,
    READMIT,
    PRPR_ID,
    PRPR_NAME,
    LOS,
    sysdate
FROM  step7 a 
) tmg

union all
select * from
(
    WITH step1_a AS
    (
         SELECT /*+ materialize no_merge */
                DISTINCT
                 a.clcl_id,
                 a.meme_ck,
                 TRUNC(a.CLHP_STAMENT_FR_DT) AS CLHP_STAMENT_FR_DT,
                 TRUNC(a.CLHP_STAMENT_TO_DT) AS CLHP_STAMENT_TO_DT,
                 a.CLHP_DC_STAT,
                 CLHP_ADM_TYP,
                 clhp_Fac_type ||
                 clhp_bill_class ||
                 clhp_frequency AS billtype,
                 c.CLCL_TOT_PAYABLE,
                 c.prpr_id,
                 prpr_name,
                 REPLACE(REPLACE(REPLACE(REPLACE(e.idcd_id, 'N'), 'U'), 'W'), 'Y') AS idcd_id,
                 idcd_desc,                                       /* compres */
                 CASE
                     WHEN CLOR_OR_VALUE = '' THEN CLHP_INPUT_AGRG_ID
                     ELSE CLOR_OR_VALUE
                 END
                     AS grgr_id,
                 TRUNC(a.CLHP_STAMENT_FR_DT) - 1 AS previous_dt,
                 TRUNC(a.CLHP_STAMENT_FR_DT) + 1 AS after_dt
         from tmg_FIDA.Cmc_clhp_hosp@nexus2 A
             join tmg_FIDA.cmc_clcl_claim@nexus2 C on a.clcl_id=c.clcl_id
             join tmg_FIDA.cmc_prpr_prov@nexus2 D on c.prpr_id=d.prpr_id
             left join tmg_FIDA.cmc_clmd_diag@nexus2 E on c.clcl_id=e.clcl_id and e.clmd_type='01'
             left join tmg_FIDA.cmc_clor_cl_ovr@nexus2 F on ( a.clcl_id=f.clcl_id and CLOR_OR_ID='GO')
             join tmg_FIDA.Cmc_idcd_diag_cd@nexus2 G on e.idcd_id=g.idcd_id and  TRUNC(a.CLHP_STAMENT_FR_DT) BETWEEN TRUNC(g.IDCD_EFF_DT) AND TRUNC(g.IDCD_TERM_DT)
             where TRUNC(a.CLHP_STAMENT_TO_DT) BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR( SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1 
                   and clcl_CUR_STS not in ('91' , '99') 
                   and CLCL_TOT_PAYABLE>0 
                   and (CLHP_FAC_TYPE='01' and CLHP_BILL_CLASS in ('1','2'))
     )
     /******* Pulling Value Options inpatient Claims for Medicare ************************************/
     , step1_b AS
     (
        SELECT /*+ materialize no_merge */
                DISTINCT
                 CLMREV,
                 TRUNC(a.HOSBEG) AS CLHP_STAMENT_FR_DT,
                 TRUNC(a.HOSEND) AS CLHP_STAMENT_TO_DT,
                 a.CLAIMNO AS clcl_id,
                 c.meme_ck,
                 a.DISTAT AS CLHP_DC_STAT,
                 a.ALWAMT AS CLCL_TOT_PAYABLE,
                 '0' || BILCOD AS billtype,
                 PROVNO AS prpr_id,
                 SVVLST || SVVFST AS Prpr_name,
                 REPLACE(DIAGN1, '.') AS idcd_id,
                 IDCD_desc,
                 CASE WHEN TYPCOD = 'RC' THEN SVCCOD ELSE '' END AS grgr_id
             from VNS_CHOICE1.Value_options_fida@nexus2 a
             join tmg_FIDA.cmc_sbsb_subsc@nexus2 B on substr(a.MEMBNO,1,9)=b.sbsb_id
             join tmg_FIDA.cmc_meme_member@nexus2 C on b.sbsb_ck=c.sbsb_ck
             left join tmg_FIDA.Cmc_idcd_diag_cd@nexus2 D on  REPLACE(DIAGN1, '.', '') = REPLACE(D.IDCD_ID, ' ', '') AND TRUNC(a.HOSBEG) BETWEEN TRUNC(d.IDCD_EFF_DT) AND TRUNC(d.IDCD_TERM_DT)
             where  ENDDAT BETWEEN '30-NOV-2015' AND SYSDATE 
                    and  LINENO='001' 
                    and ALWAMT>0 
                    and (BILCOD like '11%' or BILCOD like '12%') and RCVDAT <= TRUNC(SYSDATE)                        
     )
     /******************* SQL for step1_bb **********************/
     , step1_bb AS
     (
        SELECT /*+ materialize no_merge */
                        DISTINCT
                         CLMREV,
                         TRUNC(a.HOSBEG) AS CLHP_STAMENT_FR_DT,
                         TRUNC(a.HOSEND) AS CLHP_STAMENT_TO_DT,
                         a.CLAIMNO AS clcl_id,
                         c.meme_ck,
                         a.DISTAT AS CLHP_DC_STAT,
                         a.ALWAMT AS CLCL_TOT_PAYABLE,
                         '0' || BILCOD AS billtype,
                         PROVNO AS prpr_id,
                         SVVLST || SVVFST AS Prpr_name,
                         REPLACE(DIAGN1, '.') AS idcd_id,
                         IDCD_desc,
                         CASE WHEN TYPCOD = 'RC' THEN SVCCOD ELSE '' END AS gsrgr_id                       
         from vns_choice1.Value_options_sh@nexus2 a
         join tmg_FIDA.cmc_sbsb_subsc@nexus2 B on substr(a.MEMBNO,1,9)=b.sbsb_id
         join tmg_FIDA.cmc_meme_member@nexus2 C on b.sbsb_ck=c.sbsb_ck
         left join tmg_FIDA.Cmc_idcd_diag_cd@nexus2 D ON     REPLACE(DIAGN1, '.') = REPLACE(D.IDCD_ID, ' ', '') AND TRUNC(a.HOSBEG) BETWEEN TRUNC(d.IDCD_EFF_DT) AND TRUNC(d.IDCD_TERM_DT)
         where  
                ENDDAT BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR(SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1
            AND LINENO='001' 
            AND ALWAMT>0 
            AND (BILCOD like '11%' or BILCOD like '12%') 
            AND RCVDAT <= TRUNC(SYSDATE)               
     )
     /******************* SQL for step1_bbb, step1_b1, step1_b2 **********************/
     , step1_bbb AS
     (SELECT *
          FROM   step1_b outer
          UNION
          SELECT * FROM step1_bb)/** remove reversed claims***/
     , step1_b1 AS
     (SELECT *
          FROM   step1_bbb
          WHERE  CLMREV = 'Y')
     ,step1_b2 AS
     (SELECT A.*
          FROM   step1_bbb a LEFT JOIN step1_b1 b ON A.clcl_id = B.clcl_id
          WHERE  B.clcl_id IS NULL
          )
    /******************* SQL for step1_b4 **********************/
   /**************************************************************************************************************************************/
   /**************************************** Pulling ALL inpatient Auths ******************************************************************/
   /************** umit_sts not in (DS,CL,IN) deletes auths that were disallowed or voided or pend with errors ****************************/
   /***************************************************************************************************************************************/
     , step1_b4 AS
     (
            SELECT /*+ materialize no_merge */
                 DISTINCT
                 A.UMUM_REF_ID AS CLCL_ID,
                 A.MEME_CK,
                 TRUNC(a.UMIN_ACT_ADM_DT) AS CLHP_STAMENT_FR_DT,
                 UMIN_IDCD_ID_PRI AS idcd_id,
                 IDCD_DESC,
                 CASE
                     WHEN TRUNC(a.UMIN_DC_DTM) = TO_DATE('01jan1753') THEN NULL
                     ELSE TRUNC(a.UMIN_DC_DTM)
                 END AS CLHP_STAMENT_TO_DT,
                 UMIN_PRPR_ID_FAC AS prpr_id,
                 PRPR_NAME,
                 NULL GRGR_ID,
                 NULL CLHP_DC_STAT,
                 NULL CLCL_TOT_PAYABLE,
                 NULL BILLTYPE          
            FROM TMG_FIDA.CMC_UMIN_INPATIENT A
                 JOIN TMG_FIDA.CMC_MEPE_PRCS_ELIG B ON A.MEME_CK=B.MEME_CK
                 JOIN TMG_FIDA.CMC_MEME_MEMBER C ON A.MEME_CK=C.MEME_CK
                 JOIN TMG_FIDA.CMC_SBSB_SUBSC D ON C.SBSB_CK=D.SBSB_CK
                 LEFT JOIN TMG_FIDA.CMC_PRPR_PROV E ON A.UMIN_PRPR_ID_FAC=E.PRPR_ID
                 LEFT JOIN TMG_FIDA.CMC_IDCD_DIAG_CD F ON A.IDCD_ID_ADM_SUB = F.IDCD_ID AND TRUNC(A.UMIN_ACT_ADM_DT) BETWEEN TRUNC( F.IDCD_EFF_DT) AND TRUNC( F.IDCD_TERM_DT)
            WHERE 
                 TRUNC(UMIN_ACT_ADM_DT) BETWEEN '30nov2015' AND   TO_DATE( TO_CHAR(SYSDATE, 'YYYYMM')|| '01', 'YYYYMMDD') - 1 
                 AND  B.PDPD_ID NOT IN ('MD000002', 'MD000003', 'MD000004', 'HMD00002', 'HMD00003')  
                 AND TRUNC(UMIN_INPUT_DT) <= TRUNC(SYSDATE)
                 AND SUBSTR(UMIN_PRPR_ID_FAC,1,4)='HOSP' 
                 AND  UMIT_STS NOT IN ('DS','CL','IN')          
     )
     /* umit_sts this deletes auths that were disallowed or voided or pend with errors*;*/
     , step1_b5 AS
     (
        SELECT *
        FROM   STEP1_B4
        WHERE  (MEME_CK, CLHP_STAMENT_FR_DT) NOT IN (SELECT /*+ no_merge */DISTINCT MEME_CK, CLHP_STAMENT_FR_DT FROM STEP1_A)
      )
      /*** Bacause some of the admin date in the auth data has a +/- 1 day as admin date.. Have to re-match to ensure that there is no claim for the auth with a +\- 1 day *****/
     , step1_b6 AS
     (
          SELECT 
                DISTINCT A.*
          FROM  STEP1_B5 A
                JOIN STEP1_A B ON A.MEME_CK = B.MEME_CK AND A.CLHP_STAMENT_FR_DT BETWEEN B.PREVIOUS_DT AND B.AFTER_DT
     )
     , step1_b7 AS
     (
        SELECT DISTINCT A.*
        FROM   STEP1_B5 A
             LEFT JOIN STEP1_B6 B ON  A.MEME_CK = B.MEME_CK AND A.CLHP_STAMENT_FR_DT = B.CLHP_STAMENT_FR_DT
        WHERE      B.MEME_CK IS NULL AND B.CLHP_STAMENT_FR_DT IS NULL
      )
     /*************** Merge claims, Auth & VO inpatient admissions****************************;*/
     , Step1_c AS
     (
        SELECT A.*,
             CASE
                 WHEN LENGTH(GRGR_ID) = 5 THEN SUBSTR(GRGR_ID, 3, 3)
                 WHEN LENGTH(GRGR_ID) = 4 THEN SUBSTR(GRGR_ID, 2, 3)
                 WHEN LENGTH(GRGR_ID) = 3 THEN GRGR_ID
                 WHEN LENGTH(GRGR_ID) > 1 THEN SUBSTR(GRGR_ID, 1, 3)
                 WHEN LENGTH(GRGR_ID) = 1 THEN SUBSTR(GRGR_ID, 1, 3)
             END AS DRG_CODE
        FROM   
        (
                SELECT
                         BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   STEP1_B2
                  UNION ALL
                  SELECT 
                         BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   STEP1_A
                  UNION ALL
                  SELECT 
                         BILLTYPE,
                         CLCL_ID,
                         CLCL_TOT_PAYABLE,
                         CLHP_DC_STAT,
                         CLHP_STAMENT_FR_DT,
                         CLHP_STAMENT_TO_DT,
                         GRGR_ID,
                         IDCD_DESC,
                         IDCD_ID,
                         MEME_CK,
                         PRPR_ID,
                         PRPR_NAME
                  FROM   
                         STEP1_B7
          ) A
    )
     /******************* SQL for Step1_c end **********************/
     --*** Step2: Acute to acute transfers ***;
     --************************************************************************;
     --*** similar to laura's translation for in07_Ca in 07-IP_Admission_LW ***;
     --************************************************************************;
     /******************* SQL for acute_ips **********************/
    , acute_ips AS
     (SELECT c.*,
             MIN(CLHP_STAMENT_FR_DT) OVER (PARTITION BY meme_ck, member_adm_seq) AS new_adm_dt,
             MAX(CLHP_STAMENT_TO_DT) OVER (PARTITION BY meme_ck, member_adm_seq) AS new_dis_dt
       FROM   
       (
                SELECT b.*,
                           SUM(
                               CASE
                                   WHEN diff IS NULL THEN 0
                                   WHEN diff IN (1) THEN 0
                                   WHEN diff >= 2 THEN 1
                               END) OVER (PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT)  + 1 AS member_adm_seq
                  FROM   (
                            SELECT a.*,
                                 LAG(CLHP_STAMENT_FR_DT, 1) OVER ( ORDER BY meme_ck, CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS lag_adm_dt,
                                 LAG(CLHP_STAMENT_TO_DT, 1) OVER ( ORDER BY meme_ck, CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS lag_dis_dt,
                                 ROW_NUMBER() OVER ( PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS seq1,
                                 CLHP_STAMENT_FR_DT - LAG( CLHP_STAMENT_TO_DT, 1) OVER ( PARTITION BY meme_ck ORDER BY CLHP_STAMENT_FR_DT, CLHP_STAMENT_TO_DT) AS diff
                            FROM   step1_c a
                          ) b 
          ) c
      )/******************* SQL for acute_ips end **********************/
     /******************* SQL for transfer_collapse **********************/
     , transfer_collapse AS
         (SELECT   meme_ck,
                   clcl_id,
                   prpr_id,
                   prpr_name,
                   new_adm_dt,
                   new_dis_dt,
                   CLHP_DC_STAT,
                   IDCD_id,
                   DRG_code
          FROM     acute_ips
          GROUP BY meme_ck,
                   new_adm_dt,
                   new_dis_dt,
                   clcl_id,
                   prpr_id,
                   prpr_name,
                   CLHP_DC_STAT,
                   IDCD_id,
                   DRG_code
    )
    /******************* SQL for transfer_collapse end  **********************/
    /******************* SQL for step3b **********************/
     , step3b AS
    (SELECT   c.meme_ck,
                   TRUNC(MIN(CLHP_STAMENT_FR_DT)) AS new_adm_dt,
                   TRUNC(MAX(CLHP_STAMENT_TO_DT)) AS new_dis_dt,
                   SUM(CLCL_TOT_PAYABLE) AS Tot_Paid
          FROM acute_ips c
          GROUP BY 
            meme_ck, 
            member_adm_seq
    )
    /******************* SQL for step3b end **********************/
    --****** Keep the original admission Date as the Index Admission Date, and the transfer's discharge date as the  Index Discharge Date *;
    /******************* SQL for step2 **********************/
     , step2 AS
         (SELECT *
          FROM   (SELECT meme_ck,
                         clcl_id,
                         prpr_id,
                         prpr_name,
                         new_adm_dt AS CLHP_STAMENT_FR_DT,
                         new_dis_dt AS CLHP_STAMENT_TO_DT,
                         clhp_dc_stat,
                         idcd_id,
                         drg_code,
                         ROW_NUMBER() OVER (PARTITION BY meme_ck, new_adm_dt ORDER BY new_dis_dt DESC) AS seq3
                  FROM   transfer_collapse a
              )
          WHERE  seq3 = 1
      )
      /******************* SQL for step2 end **********************/
     , step3 AS
     (
        SELECT * FROM   step2 WHERE   CLHP_STAMENT_TO_DT >= '01-jan-2016'
     )
    /**** step 5: Exclude pregnancy inpatient stay and deaths during confinements*****/
     , diag AS
         (select 
            distinct a.*, b.clmd_type,b.idcd_id as PregDX,sbsb_last_name,sbsb_first_name,d.sbsb_id,Tot_Paid
          from step3 A
            left join tmg_FIDA.cmc_clmd_diag b on b.clcl_id=a.clcl_id
            join tmg_FIDA.cmc_meme_member C on a.meme_ck=c.meme_ck
            join tmg_FIDA.cmc_sbsb_subsc D on c.sbsb_ck=d.sbsb_ck
            left join step3b E on a.meme_ck=e.meme_ck and a.CLHP_STAMENT_FR_DT=e.new_adm_dt
    ) 
    , step4_b AS
     (
         SELECT *
          FROM   
          (
               SELECT clcl_id,
                     clhp_dc_stat,
                     clhp_stament_fr_dt,
                     clhp_stament_to_dt,
                     drg_code,
                     idcd_id,
                     meme_ck,
                     prpr_id,
                     prpr_name,
                     sbsb_first_name,
                     sbsb_id,
                     sbsb_last_name,
                     tot_paid,
                     CASE
                         WHEN pregdx >= '630' AND pregdx < '680' AND clmd_type = '01' THEN 1
                         WHEN SUBSTR(PregDX, 1, 3) IN ('V22', 'V23', 'V28') AND CLMD_TYPE = '01' THEN 1
                         WHEN pregdx >= '760' AND pregdx < '780' THEN 1
                         WHEN pregdx >= 'V28' AND pregdx < 'V40' THEN 1
                         WHEN SUBSTR(idcd_id, 1, 3) = 'V21' THEN 1
                         ELSE 0
                     END AS matern_flg,
                     ROW_NUMBER() OVER (PARTITION BY clcl_id ORDER BY clcl_id) AS seq2
              FROM   diag
          )
          WHERE  seq2 = 1
     )
, step4_c AS
(
    SELECT 
        a.*,
        1 AS denom,
        TO_NUMBER(TO_CHAR(CLHP_STAMENT_FR_DT, 'YYYYMM')) AS month_id
    FROM step4_b a
    WHERE
        CLHP_DC_STAT NOT IN ('20') OR CLHP_DC_STAT IS NULL AND matern_flg = 0
)
,step4_d AS (SELECT * FROM fact_member_month)
,step5 AS
(
    SELECT /*+ materializ no_merge */ 
            DISTINCT  a.*,MEMBER_ID,      
                      SUBSCRIBER_ID,      
                      DL_LOB_ID ,          
                      DL_PLAN_SK ,         
                      CM_SK_ID    ,        
                      DL_ASSESS_SK ,       
                      DL_MEMBER_ADDRESS_SK
    FROM step4_c A
    LEFT JOIN step4_d B ON a.sbsb_id = b.SUBSCRIBER_ID AND a.month_id = b.month_id
)
, step5b AS
(
    SELECT DISTINCT
         a.*,
         CASE
             WHEN CLHP_STAMENT_TO_DT IS NULL THEN CLHP_STAMENT_FR_DT
             ELSE CLHP_STAMENT_TO_DT
         END
             AS discharge_dt
    FROM   step5 A
)
/* step6 when discrepancy stick with SQL  */
, step6 AS
(
        SELECT a.* 
        FROM   
            (
                    SELECT a.*,
                         LAG(CLHP_STAMENT_TO_DT, 1) OVER (ORDER BY MEME_CK, CLHP_STAMENT_TO_DT) AS lag_dis_dt,
                         LAG(MEME_CK, 1) OVER (ORDER BY MEME_CK) AS lag_meme_ck
                    FROM   step5 a
            ) a
        WHERE      
            CLHP_STAMENT_FR_DT - lag_dis_dt <= 30
            AND lag_meme_ck = meme_ck
)
, step7 AS
(
    SELECT a.*,
         CASE
             WHEN a.clcl_id IS NOT NULL AND b.clcl_id IS NOT NULL THEN 1
             ELSE 0
         END readmit,
         a.CLHP_STAMENT_TO_DT - a.CLHP_STAMENT_FR_DT AS los
    FROM   step5 a LEFT JOIN Step6 b ON (a.clcl_id = b.clcl_id)
)
, step7b as
(
    select * from step7 where readmit=1 
)
SELECT
    'FIDA' SRC, 
    MONTH_ID,
    SUBSCRIBER_ID,
    MEMBER_ID           ,
    DL_LOB_ID           ,
    DL_PLAN_SK          ,
    CM_SK_ID            ,
    DL_ASSESS_SK        ,
    DL_MEMBER_ADDRESS_SK,
    CLHP_STAMENT_FR_DT,
    CLHP_STAMENT_TO_DT,
    TOT_PAID,
    MATERN_FLG,
    DENOM,
    READMIT,
    PRPR_ID,
    PRPR_NAME,
    LOS,
    sysdate
FROM  step7 a
)
;

commit;


select * from FACT_IP_READMISSION_DATA where src = 'FIDA'