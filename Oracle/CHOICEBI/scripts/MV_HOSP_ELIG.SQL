INSERT INTO MV_HOSP_ELIG
(SELECT /*+ parallel(2) */
       DISTINCT
          g.sbsb_id AS Unique_Id,
          f.meme_ck,
          f.meme_record_no AS MRN,
          g.sbsb_last_name AS Last_Name,
          g.sbsb_first_name AS First_Name,
          f.meme_birth_dt AS DOB,
          f.meme_sex AS SEX,
          f.meme_mctr_lang AS Language,
          a.sbad_addr1 AS Member_address1,
          a.sbad_addr2 AS Member_address2,
          a.sbad_city AS Member_city,
          a.sbad_state AS Member_state,
          a.sbad_zip AS Member_zip,
          a.sbad_phone AS Member_phone,
          staff.CARE_MANAGER_NAME,
          K.pdpd_id AS Plan_ID,
          p.pdds_desc AS Plan_Description,
          k.MEPE_ELIG_IND AS Plan_Elig_Ind,
          k.mepe_eff_dt AS Effective_Date,
          k.mepe_term_dt AS Termination_Date                              --IP
                                            ,
          SUM(
              CASE
                  WHEN     FAC_IND = 'IP'
                       AND clhp_stament_fr_dt >= ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                      1
                  ELSE
                      0
              END)
              AS IP_Adm_6Mnts_N,
          SUM(
              CASE
                  WHEN     FAC_IND = 'IP'
                       AND clhp_stament_fr_dt >= ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                      LOS
                  ELSE
                      0
              END)
              AS IP_Adm_6Mnts_LOS,
          CASE
              WHEN SUM(
                       CASE
                           WHEN     FAC_IND = 'IP'
                                AND clhp_stament_fr_dt >=
                                        ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                               1
                           ELSE
                               0
                       END) >= 1 THEN
                  1
              ELSE
                  0
          END
              AS IP_Adm_1plus_6Mnts_Ind,
          CASE
              WHEN SUM(
                       CASE
                           WHEN     FAC_IND = 'IP'
                                AND clhp_stament_fr_dt >=
                                        ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                               1
                           ELSE
                               0
                       END) >= 3 THEN
                  1
              ELSE
                  0
          END
              AS IP_Adm_3plus_6Mnts_Ind,
          SUM(CASE WHEN FAC_IND = 'IP' THEN 1 ELSE 0 END) AS IP_Adm_12Mnts_N,
          SUM(CASE WHEN FAC_IND = 'IP' THEN LOS ELSE 0 END)
              AS IP_Adm_12Mnts_LOS,
          CASE
              WHEN SUM(CASE WHEN FAC_IND = 'IP' THEN 1 ELSE 0 END) >= 1 THEN 1
              ELSE 0
          END
              AS IP_Adm_1plus_12Mnts_Ind,
          CASE
              WHEN SUM(CASE WHEN FAC_IND = 'IP' THEN 1 ELSE 0 END) >= 3 THEN 1
              ELSE 0
          END
              AS IP_Adm_3plus_12Mnts_Ind                                 --SNF
                                        ,
          SUM(
              CASE
                  WHEN     FAC_IND = 'SNF'
                       AND clhp_stament_fr_dt >= ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                      1
                  ELSE
                      0
              END)
              AS SNF_Adm_6Mnts_N,
          SUM(
              CASE
                  WHEN     FAC_IND = 'SNF'
                       AND clhp_stament_fr_dt >= ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                      LOS
                  ELSE
                      0
              END)
              AS SNF_6Mnts_LOS,
          SUM(CASE WHEN FAC_IND = 'SNF' THEN 1 ELSE 0 END) AS SNF_Adm_12Mnts_N,
          SUM(CASE WHEN FAC_IND = 'SNF' THEN LOS ELSE 0 END) AS SNF_12Mnts_LOS,
          CASE
              WHEN SUM(CASE WHEN FAC_IND = 'SNF' THEN 1 ELSE 0 END) >= 1 THEN 1
              ELSE 0
          END
              AS SNF_Adm_1plus_12Mnts_Ind,
          SUM(
              CASE
                  WHEN     FAC_IND = 'ER'
                       AND clhp_stament_fr_dt >= ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                      1
                  ELSE
                      0
              END)
              AS ER_Visits_6Mnts_N,
          CASE
              WHEN SUM(
                       CASE
                           WHEN     FAC_IND = 'ER'
                                AND clhp_stament_fr_dt >=
                                        ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                               1
                           ELSE
                               0
                       END) >= 1 THEN
                  1
              ELSE
                  0
          END
              AS ER_Visits_1plus_6Mnts_Ind,
          CASE
              WHEN SUM(
                       CASE
                           WHEN     FAC_IND = 'ER'
                                AND clhp_stament_fr_dt >=
                                        ADD_MONTHS(TRUNC(SYSDATE), -7) THEN
                               1
                           ELSE
                               0
                       END) >= 3 THEN
                  1
              ELSE
                  0
          END
              AS ER_Visits_3plus_6Mnts_Ind,
          SUM(CASE WHEN FAC_IND = 'ER' THEN 1 ELSE 0 END) AS ER_Visits_12Mnts_N,
          CASE
              WHEN SUM(CASE WHEN FAC_IND = 'ER' THEN 1 ELSE 0 END) >= 1 THEN 1
              ELSE 0
          END
              AS ER_Visits_1plus_12Mnts_Ind,
          CASE
              WHEN SUM(CASE WHEN FAC_IND = 'ER' THEN 1 ELSE 0 END) >= 3 THEN 1
              ELSE 0
          END
              AS ER_Visits_3plus_12Mnts_Ind,
          MAX(CHHA_Adm_N) AS CHHA_Adm_12Mnts_N,
          CASE WHEN MAX(CHHA_Adm_N) >= 1 THEN 1 ELSE 0 END
              AS CHHA_Adm_1plus_12Mnts_Ind
 FROM     tmg1.Cmc_mepe_prcs_elig k
          JOIN tmg1.cmc_meme_member f ON (F.MEME_CK = K.MEME_CK)
          LEFT JOIN tmg1.cmc_sbsb_subsc g ON (f.sbsb_ck = g.sbsb_ck)
          LEFT JOIN tmg1.cmc_pdds_prod_desc p ON (p.pdpd_id = k.pdpd_id)
          LEFT JOIN tmg1.cmc_sbad_addr a
              ON (    f.sbsb_ck = a.sbsb_ck
                  AND a.sbad_type = 'H')
          /*Care Staff*/
          LEFT JOIN
          (SELECT DISTINCT a.unique_id,
                           b.member_id,
                           UPPER(c.first_name)||
                           ' ' ||
                           UPPER(c.last_name)
                               AS CARE_MANAGER_NAME
           FROM   cmgc.patient_details a
                  JOIN (SELECT patient_id,
                               member_id,
                               ROW_NUMBER()
                                   OVER (PARTITION BY patient_id
                                         ORDER BY
                                             is_primary DESC,
                                             IS_ACTIVE DESC,
                                             created_on DESC,
                                             member_carestaff_id DESC)
                                   AS seq
                        FROM   cmgc.member_carestaff) b
                      ON (    b.patient_id = a.patient_id
                          AND seq = 1)
                  JOIN CMGC.CARE_STAFF_DETAILS c ON (b.member_id = c.member_id)) staff
              ON (g.sbsb_id = staff.unique_id)
          LEFT JOIN
          (SELECT c.meme_ck,
                  CASE
                      WHEN     h.clhp_fac_type = '01'
                           AND h.clhp_bill_class IN ('1', '2') THEN
                          'IP'
                      WHEN     h.clhp_fac_type = '02'
                           AND h.clhp_bill_class IN ('1', '2')
                           AND snf1.clcl_id IS NOT NULL THEN
                          'SNF'
                      WHEN     h.clhp_fac_type = '01'
                           AND h.clhp_bill_class IN ('3', '4')
                           AND er1.clcl_id IS NOT NULL
                           AND p.PRPR_MCTR_TYPE IN
                                   ('URG', 'HSP', 'HOSP', 'OUT', 'GROU', 'GRP') THEN
                          'ER'
                  END
                      AS FAC_IND,
                  h.clhp_stament_fr_dt,
                  h.clhp_stament_to_dt,
                  h.clhp_stament_to_dt - h.clhp_stament_fr_dt AS LOS
           FROM   tmg1.Cmc_clcl_claim c
                  JOIN tmg1.Cmc_clhp_hosp h ON (h.clcl_id = c.clcl_id)
                  LEFT JOIN (SELECT DISTINCT clcl_id
                             FROM   tmg1.cmc_cdml_cl_line
                             WHERE  RCRC_ID = '0022') snf1
                      ON (c.clcl_id = snf1.clcl_id) /*this determines that this is the SNF stay*/
                  LEFT JOIN
                  (SELECT DISTINCT clcl_id
                   FROM   tmg1.cmc_cdml_cl_line
                   WHERE     rcrc_id BETWEEN '0450' AND '0452'
                          OR rcrc_id = '0459'
                          OR SUBSTR(ipcd_id, 1, 5) BETWEEN '99281' AND '99285') er1
                      ON (c.clcl_id = er1.clcl_id) /* this determines that this is ED Claim*/
                  LEFT JOIN tmg1.CMC_prpr_prov p ON (c.prpr_id = p.prpr_id)
           WHERE      1 = 1
                  AND h.clhp_fac_type IN ('01', '02')
                  AND h.clhp_bill_class IN ('1', '2', '3', '4')
                  AND c.clcl_cur_sts IN ('02')
                  AND c.clcl_tot_payable > 0
                  --and (h.clhp_stament_fr_dt between add_months(trunc(sysdate), -13) and trunc(sysdate) or h.clhp_stament_to_dt between add_months(trunc(sysdate), -13) and trunc(sysdate))
                  AND (   h.clhp_stament_fr_dt >
                              ADD_MONTHS(TRUNC(SYSDATE), -13)
                       OR h.clhp_stament_to_dt >
                              ADD_MONTHS(TRUNC(SYSDATE), -13))) hosp
              ON (hosp.meme_ck = f.meme_ck)
          LEFT JOIN
          (SELECT   mrn, COUNT(*) AS CHHA_Adm_N
           FROM     dw_owner.case_facts
           WHERE        company_code = 'VNS'
                    --and admission_date between add_months(trunc(sysdate), -13) and trunc(sysdate)
                    AND admission_date > ADD_MONTHS(TRUNC(SYSDATE), -13)
                    AND referral_type IN ('A', 'D')
                    AND payor_primary IN
                            ('MA3', 'MA6', 'MA7', 'MA8', 'MD1', 'MAC')
           GROUP BY mrn) cf
              ON (cf.mrn =
                      (CASE
                           WHEN TRANSLATE(TRIM(f.meme_record_no),
                                          'x0123456789',
                                          'x')
                                    IS NULL THEN
                               TO_NUMBER(TRIM(f.meme_record_no))
                       END))
 WHERE        SUBSTR(K.pdpd_id, 1, 2) = 'VN'
          AND f.meme_mctr_sts = 'ACTI'
          AND k.MEPE_ELIG_IND = 'Y'
          AND SYSDATE BETWEEN k.mepe_eff_dt AND k.mepe_term_dt
 GROUP BY g.sbsb_id,
          f.meme_ck,
          f.meme_record_no,
          g.sbsb_last_name,
          g.sbsb_first_name,
          f.meme_birth_dt,
          f.meme_sex,
          f.meme_mctr_lang,
          a.sbad_addr1,
          a.sbad_addr2,
          a.sbad_city,
          a.sbad_state,
          a.sbad_zip,
          a.sbad_phone,
          K.pdpd_id,
          p.pdds_desc,
          k.MEPE_ELIG_IND,
          k.mepe_eff_dt,
          k.mepe_term_dt,
          staff.CARE_MANAGER_NAME)