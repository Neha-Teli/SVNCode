DROP MATERIALIZED VIEW CHOICEBI.D_MRN_MEDICAID_MAPPING;

CREATE MATERIALIZED VIEW CHOICEBI.D_MRN_MEDICAID_MAPPING
TABLESPACE CHOICEBI_DATA
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
    SELECT F.MRN,
                   P.POLICY_NO AS MEDICAID_NUM,
                   MIN (COVERAGE_START_DATE) AS MIN_COVERAGE_START_DATE,
                   MAX (COVERAGE_END_DATE) AS MAX_COVERAGE_END_DATE,
                   ROW_NUMBER ()
                   OVER (PARTITION BY F.MRN
                         ORDER BY MIN(COVERAGE_START_DATE) DESC,  P.POLICY_NO
                         )
                   AS MEDICAID_NUM_SEQ,
                   ROW_NUMBER ()                   
                   OVER (PARTITION BY P.POLICY_NO
                         ORDER BY MIN(COVERAGE_START_DATE) DESC, f.MRN
                         )
                   AS MRN_SEQ                   
              FROM DW_OWNER.FISCAL P
              LEFT JOIN DW_OWNER.CASE_FACTS F ON (F.CASE_NUM = P.CASE_NUM AND F.REFERRAL_STATUS in('A','D'))
              WHERE     (CASE
                           WHEN     TRIM (SUBSTR (P.POLICY_NO, 1, 1)) IN
                                       ('A',
                                        'B',
                                        'C',
                                        'D',
                                        'E',
                                        'F',
                                        'G',
                                        'H',
                                        'I',
                                        'J',
                                        'K',
                                        'L',
                                        'M',
                                        'N',
                                        'O',
                                        'P',
                                        'Q',
                                        'R',
                                        'S',
                                        'T',
                                        'U',
                                        'V',
                                        'W',
                                        'X',
                                        'Y',
                                        'Z')
                                AND TRIM (SUBSTR (P.POLICY_NO, 2, 1)) IN
                                       ('A',
                                        'B',
                                        'C',
                                        'D',
                                        'E',
                                        'F',
                                        'G',
                                        'H',
                                        'I',
                                        'J',
                                        'K',
                                        'L',
                                        'M',
                                        'N',
                                        'O',
                                        'P',
                                        'Q',
                                        'R',
                                        'S',
                                        'T',
                                        'U',
                                        'V',
                                        'W',
                                        'X',
                                        'Y',
                                        'Z')
                                AND TRIM (SUBSTR (P.POLICY_NO, 3, 1)) IN
                                       ('0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9')
                                AND TRIM (SUBSTR (P.POLICY_NO, 4, 1)) IN
                                       ('0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9')
                                AND TRIM (SUBSTR (P.POLICY_NO, 5, 1)) IN
                                       ('0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9')
                                AND TRIM (SUBSTR (P.POLICY_NO, 6, 1)) IN
                                       ('0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9')
                                AND TRIM (SUBSTR (P.POLICY_NO, 7, 1)) IN
                                       ('0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9')
                                AND TRIM (SUBSTR (P.POLICY_NO, 8, 1)) IN
                                       ('A',
                                        'B',
                                        'C',
                                        'D',
                                        'E',
                                        'F',
                                        'G',
                                        'H',
                                        'I',
                                        'J',
                                        'K',
                                        'L',
                                        'M',
                                        'N',
                                        'O',
                                        'P',
                                        'Q',
                                        'R',
                                        'S',
                                        'T',
                                        'U',
                                        'V',
                                        'W',
                                        'X',
                                        'Y',
                                        'Z')
                                AND TRIM (P.POLICY_NO) NOT IN ('N/A', 'NA')
                           THEN
                              UPPER (P.POLICY_NO)
                           ELSE
                              NULL
                        END)
                          IS NOT NULL
                   AND F.MRN IS NOT NULL
                   AND VERIFICATION_STATUS != 'D'             --exclude denied
          GROUP BY F.MRN, P.POLICY_NO
          ORDER BY F.MRN, P.POLICY_NO;

COMMENT ON MATERIALIZED VIEW CHOICEBI.D_MRN_MEDICAID_MAPPING IS 'snapshot table for snapshot CHOICEBI.D_MRN_MEDICAID_MAPPING';


GRANT SELECT ON CHOICEBI.D_MRN_MEDICAID_MAPPING TO CHOICEBI_RO;

GRANT SELECT ON CHOICEBI.D_MRN_MEDICAID_MAPPING TO DW_OWNER;

GRANT SELECT ON CHOICEBI.D_MRN_MEDICAID_MAPPING TO MSTRSTG;

GRANT SELECT ON CHOICEBI.D_MRN_MEDICAID_MAPPING TO ROC_RO;