/***********************************************************
****05-ER_Visit_no_IP_20160914.sas
*************************/

DROP MATERIALIZED VIEW CHOICEBI.MV_ER_VISIT_UTILIZATION_DATA ;

CREATE MATERIALIZED VIEW CHOICEBI.MV_ER_VISIT_UTILIZATION_DATA  AS
SELECT /*+ driving_site(a) */ 
    DISTINCT 
    A.*,
    PROVIDER_NAME,
    --prpr_name,
    case when enrolled=1 then 'Y' else 'N' 
    end as Active_OnDisch ,
    RANK() OVER (PARTITION BY A.SUBSCRIBER_ID, A.CLAIMFROMDATE, A.prpr_id ORDER BY A.MONTH_ID) SEQ
FROM 
    (
        select /*+ parallel(2) driving_site(A) no_merge */
            distinct to_number(to_char(CLCL_LOW_SVC_DT,'YYYYMM')) month_id,
            CSCS_ID LOB_ID,
            pdpd_id PRODUCT_ID,   
            VNS_PLAN_SHORT_NAME VNS_PLAN_DESC,          
            d.sbsb_id SUBSCRIBER_ID,
            a.prpr_id,
            CLCL_LOW_SVC_DT AS CLAIMFROMDATE ,
            CLCL_HIGH_SVC_DT AS CLAIMTODATE ,
            CLHP_FAC_TYPE||CLHP_BILL_CLASS AS BILLTYPE,CLHP_ADM_TYP,CLHP_ADM_SOURCE,H.MCTR_DESC AS TYPE,
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
        From tmg.cmc_clcl_claim@nexus2 A
            inner join tmg.cmc_cdml_cl_line@nexus2 B on a.clcl_id=b.clcl_id
            inner join tmg.cmc_meme_member@nexus2 C on A.meme_ck=C.meme_ck
            inner join tmg.cmc_sbsb_subsc@nexus2 D on C.sbsb_ck=D.sbsb_ck
            inner join tmg.CMC_CLHP_HOSP@nexus2 F on A.clcl_id=F.clcl_id AND CLHP_DC_STAT != '20' 
            left JOIN TMG.CMC_PRPR_PROV@nexus2 I ON A.PRPR_ID=I.PRPR_ID  
            LEFT JOIN TMG.CMC_MCTR_CD_TRANS@nexus2 G ON F.CLHP_DC_STAT=G.MCTR_VALUE AND G.MCTR_TYPE='DCST' AND G.MCTR_ENTITY='!CLH'
            LEFT JOIN TMG.CMC_MCTR_CD_TRANS@nexus2 H ON F.CLHP_ADM_TYP=H.MCTR_VALUE AND H.MCTR_TYPE='ADMT' AND H.MCTR_ENTITY='!CLH'
            LEFT join TMG.CMC_CLMD_DIAG@nexus2 I ON A.CLCL_ID=I.CLCL_ID AND CLMD_TYPE='01'
            LEFT JOIN TMG.Cmc_idcd_diag_cd@nexus2 J ON I.IDCD_ID=J.IDCD_ID and  a.CLCL_LOW_SVC_DT between j.IDCD_EFF_DT and j.IDCD_TERM_DT
            --LEFT join D_VNS_PLANS_PDPD_MAPPING z on z.pdpd_id =  a.pdpd_id
        where 
            (CLHP_FAC_TYPE='01' AND CLHP_BILL_CLASS IN ('3','4') and PRPR_MCTR_TYPE IN ('URG', 'HSP', 'HOSP', 'OUT', 'GROU', 'GRP')) and
            ((('0450'<=rcrc_id and rcrc_id <='0452') or (rcrc_id='0459')) or ('99281'<= Substr(ipcd_id,1,5) and Substr(ipcd_id,1,5) <='99285')) and
            (a.pdpd_id not in ('HMD00002','HMD00003','MD000002','MD000003')  
            and clcl_cur_sts   NOT IN ('91', '99'))
        UNION ALL
        select /*+ parallel(2) driving_site(A) no_merge */ distinct 
            to_number(to_char(CLCL_LOW_SVC_DT,'YYYYMM')) month_id, 
            CSCS_ID LOB_ID,
            PDPD_ID PRODUCT_ID,
            VNS_PLAN_SHORT_NAME VNS_PLAN_DESC,             
            d.sbsb_id,
            a.prpr_id,
            CLCL_LOW_SVC_DT AS CLAIMFROMDATE ,CLCL_HIGH_SVC_DT AS CLAIMTODATE ,
            CLHP_FAC_TYPE || CLHP_BILL_CLASS AS BILLTYPE,CLHP_ADM_TYP,CLHP_ADM_SOURCE,H.MCTR_DESC AS TYPE,CLHP_DC_STAT,
            G.MCTR_DESC AS DISC_STATUS,CLCL_ME_AGE AS AGE_DOS,
            CLCL_PRPR_ID_PCP AS PROVIDER_ID,
            CLCL_NTWK_IND,
            CLCL_TOT_PAYABLE,
            I.IDCD_ID AS PRIM_DX, 
            IDCD_DESC AS DX_DESCRIPTION,
            'ER' CAT, 
            1 serv
        From 
                       tmg_fida.cmc_clcl_claim@nexus2 A
            inner join tmg_fida.cmc_cdml_cl_line@nexus2 B on a.clcl_id=b.clcl_id
            inner join tmg_fida.cmc_meme_member@nexus2 C on A.meme_ck=C.meme_ck
            inner join tmg_fida.cmc_sbsb_subsc@nexus2 D on C.sbsb_ck=D.sbsb_ck
            inner join tmg_fida.CMC_CLHP_HOSP@nexus2 F on A.clcl_id=F.clcl_id AND CLHP_DC_STAT != '20' 
            INNER JOIN tmg_fida.CMC_PRPR_PROV@nexus2 I ON A.PRPR_ID=I.PRPR_ID  
            LEFT JOIN  tmg_fida.CMC_MCTR_CD_TRANS@nexus2 G ON F.CLHP_DC_STAT=G.MCTR_VALUE AND G.MCTR_TYPE='DCST' AND G.MCTR_ENTITY='!CLH'
            LEFT JOIN  tmg_fida.CMC_MCTR_CD_TRANS@nexus2 H ON F.CLHP_ADM_TYP=H.MCTR_VALUE AND H.MCTR_TYPE='ADMT' AND H.MCTR_ENTITY='!CLH'
            LEFT join  tmg_fida.CMC_CLMD_DIAG@nexus2 I ON A.CLCL_ID=I.CLCL_ID AND CLMD_TYPE='01'
            LEFT JOIN  tmg_fida.Cmc_idcd_diag_cd@nexus2 J ON I.IDCD_ID=J.IDCD_ID and   a.CLCL_LOW_SVC_DT between j.IDCD_EFF_DT and j.IDCD_TERM_DT
            --LEFT join d_vns_plans_pdpd_mapping z on z.pdpd_id =  a.pdpd_id
        where 
            (CLHP_FAC_TYPE='01' AND CLHP_BILL_CLASS IN ('3','4') and PRPR_MCTR_TYPE IN ('URG', 'HSP', 'HOSP', 'OUT', 'GROU', 'GRP')) and
            ((('0450'<=rcrc_id and rcrc_id <='0452') or (rcrc_id='0459')) or ('99281'<= Substr(ipcd_id,1,5) and Substr(ipcd_id,1,5) <='99285')) and
            (a.pdpd_id not in ('MD000002', 'MD000003', 'HMD00002', 'HMD00003')  
            and clcl_cur_sts NOT IN ('91', '99'))
    ) 
A      
LEFT JOIN 
(
    select * from 
    (
        select /*+ driving_site(a) materialize no_merge */ a.*, 1 enrolled, c.vns_plan_id, C.VNS_PLAN_DESC , dense_rank() over (partition by a.lob_id,vns_plan_id,subscriber_id order by month_id desc) seq 
        from MS_OWNER.XCHG_MEMBER_MONTH@MS_OWNER_RCPROD a
        join d_vns_plans_pdpd_mapping c on a.lob_id = c.lob_id and nvl(a.program,c.pbp_id) = c.pbp_id
    )
    where seq = 1
) B ON A.SUBSCRIBER_ID=B.SUBSCRIBER_ID AND A.lob_id = B.lob_id and a.vns_plan_id = b.vns_plan_id
LEFT JOIN tmg.cmc_prpr_prov@nexus2 D on a.prpr_id=d.prpr_id
;

GRANT SELECT ON CHOICEBI.MV_ER_VISIT_UTILIZATION_DATA TO DW_OWNER;

GRANT SELECT ON CHOICEBI.MV_ER_VISIT_UTILIZATION_DATA TO MSTRSTG;

GRANT SELECT ON CHOICEBI.MV_ER_VISIT_UTILIZATION_DATA TO ROC_RO;


