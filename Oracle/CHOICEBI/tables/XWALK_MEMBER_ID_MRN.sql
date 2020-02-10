
DROP TABLE VIEW CHOICEBI.XWALK_MEMBER_ID_MRN;

create table CHOICEBI.XWALK_MEMBER_ID_MRN as  
/* Formatted on 9/27/2017 3:20:16 PM (QP5 v5.240.12305.39446) */
WITH mrn1
     AS (  SELECT a.*,
                  c.mrn AS MRN_MF_medcd,
                  d.mrn AS MRN_MF_hicn,
                  COALESCE (a.mrn, c.mrn, d.mrn) AS MRN_FIN
             FROM (  SELECT DISTINCT member_id,
                                     medicaid_number,
                                     hicn,
                                     MAX (mrn) AS MRN
                       FROM choice.DIM_MEMBER_DETAIL@DLAKE
                   GROUP BY member_id, medicaid_number, hicn
                   ORDER BY member_id, medicaid_number, hicn) a
                  LEFT JOIN (SELECT medicaid_num, MAX (MRN) mrn FROM DW_OWNER.TPCLN_PATIENT WHERE     medicaid_num IS NOT NULL AND medicaid_num NOT IN ('AB12345C') GROUP BY medicaid_num) c 
                   ON (c.medicaid_num = a.medicaid_number)
                  LEFT JOIN (  SELECT medicare_num, MAX (MRN) mrn FROM DW_OWNER.TPCLN_PATIENT WHERE medicare_num IS NOT NULL GROUP BY medicare_num) d
                     ON (d.medicare_num = a.hicn)
         ORDER BY a.member_id),
     mrn2
     AS (
        SELECT member_id,
                  MRN,
                  MRN_SRC,
                  ROW_NUMBER () OVER (PARTITION BY member_id, mrn ORDER BY mrn_src) AS mrn_seq
             FROM mrn1 UNPIVOT (MRN
                       FOR MRN_SRC
                       IN  (
                           MRN AS '1-DM',
                           MRN_MF_MEDCD AS '2-MEDCD',
                           MRN_MF_HICN AS '3-HICN'))
         ORDER BY member_id
        ),
     mrn3
     AS (SELECT a.MEMBER_ID,
                MRN,
                MRN_SRC,
                ROW_NUMBER () OVER (PARTITION BY member_id ORDER BY mrn_src)
                   AS member_seq,
                COUNT (*) OVER (PARTITION BY member_id) AS Member_N_MRNs
           FROM mrn2 a
          WHERE mrn_seq = 1)
SELECT a.*  FROM mrn3 a

GRANT SELECT ON CHOICEBI.XWALK_MEMBER_ID_MRN TO SF_CHOICE;

lu_sql