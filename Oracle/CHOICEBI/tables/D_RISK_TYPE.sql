DROP TABLE CHOICEBI.D_RISK_TYPE;

CREATE TABLE CHOICEBI.D_RISK_TYPE
(
  RISK_TYPE_ID            NUMBER,
  RISK_TYPE_NAME          VARCHAR2(400 BYTE),
  RISK_SCORE_VALUE        NUMBER,
  RISK_SCORE_CATEGORY     VARCHAR2(100 BYTE),
  RISK_SCORE_DESCRIPTION  VARCHAR2(4000 BYTE),
  RISK_SCORE_RULE         VARCHAR2(4000 BYTE)
);



Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.1, 'High', 'At least 3 ADMITS AND 1 ED in last 6mo', 
    'Inpatient admission>=3 in 6 months AND ED visit >=1 in 6 months');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.2, 'High', 'Dependent on Oxygen Use', 
    'O2 use');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.3, 'High', 'CHF or COPD or ESRD  and  at least 1 ADMIT  and  or ED visit last 6mo', 
    'If (1) and (2) apply: (1) at least one of the following CHF, COPD, ESRD and  (2)  inpt >= 1 in 6 months and/or ED visit >= 1 in 6 month');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.4, 'High', 'CHF or COPD or ESRD  and  on antipsychotic meds', 
    'If (1) and (2) apply: (1) at least one of the following CHF, COPD, ESRD and  (2) Antipsychotic meds');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.5, 'High', 'At least 1 ADMIT  and /or ED visit in last 6 months  and  CHHA service in last yr', 
    'CHHA admission >=1 in 12 months and (inpt >=1 in 6 months and/or ED>= 1 in 6 months)');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 1.6, 'High', 'On antipsychotic meds  and  least 1 ADMIT  and /or ED visit in last 6mo', 
    'Anti-psychotic meds and (inpt >=1 in 6 months and/or ED>=1 in 6 months)');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 2.1, 'Medium Rising', 'At least 1 ADMIT  and  3 ED visit in last yr', 
    'inpatient admission >=1 in 12 months and ED visit >=3 in 12 months');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 2.2, 'Medium Rising', 'DM  and  HTN  and /or CAD  and  at least 1 ADMIT and or ED visit in last 6mo', 
    '((DM and HTN) and/or CAD) and (inpt >=1 in 6 months and/or ED>=1 in 6 months)');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 2.3, 'Medium Rising', 'DM  and  HTN  and /or CAD  and  at least 1 CHHA admission in last yr', 
    '((HTN and DM) and/or CAD) and (>=1 CHHA admission in 12 months)');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 2.4, 'Medium Rising', 'CHF or COPD or ESRD  and  Polypharmacy', 
    'If (1) and (2) apply: (1) at least one of the following CHF, COPD, ESRD and  (2) greater than or equal to 8 meds');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 3.1, 'Medium', 'HTN  and  DM  and /or CAD', 
    '(HTN and DM) and/or CAD');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 3.2, 'Medium', 'CAD  and  at least 1 SNF ADMIT in last yr', 
    'CAD and SNF Admission >=1 in last 12 months');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY, RISK_SCORE_DESCRIPTION, 
    RISK_SCORE_RULE)
 Values
   (1, 'VNS Internal Calculation', 3.3, 'Medium', 'DM  and  HTN  and  at least 1 SNF ADMIT in last yr', 
    '(DM and HTN) and SNF admission >=1 in last 12 months');
Insert into D_RISK_TYPE
   (RISK_TYPE_ID, RISK_TYPE_NAME, RISK_SCORE_VALUE, RISK_SCORE_CATEGORY)
 Values
   (1, 'VNS Internal Calculation', 5, 'Low');
COMMIT;


GRANT SELECT ON CHOICEBI.D_RISK_TYPE TO DW_OWNER;

GRANT SELECT ON CHOICEBI.D_RISK_TYPE TO MSTRSTG;

GRANT SELECT ON CHOICEBI.D_RISK_TYPE TO ROC_RO;
