DROP table VO_DISCH_CODE;
     
create table VO_DISCH_CODE 
(
CODE        VARCHAR2(100),    
VO_DESC        VARCHAR2(400),
MCTR_DESC   VARCHAR2(400)
);
insert into VO_DISCH_CODE values('A', 'AGAINST MEDICAL ADVICE','');
insert into VO_DISCH_CODE values('AW', 'AWOL','');
insert into VO_DISCH_CODE values('B', 'BEHAVIOR MANAGEMENT SERVICES','');
insert into VO_DISCH_CODE values('C', 'ADULT CORRECTIONAL FACILITY','');
insert into VO_DISCH_CODE values('D', 'DAY TREATMENT','');
insert into VO_DISCH_CODE values('E', 'LOST ELIGIBILITY','');
insert into VO_DISCH_CODE values('F', 'TREATMENT FOSTER CARE','');
insert into VO_DISCH_CODE values('G', 'GROUP HOME','');
insert into VO_DISCH_CODE values('H', 'HOME: OUT OF CARE','');
insert into VO_DISCH_CODE values('I', 'INPATIENT','');
insert into VO_DISCH_CODE values('J', 'JUVENILE DETENTION','');
insert into VO_DISCH_CODE values('L', 'SHELTER','');
insert into VO_DISCH_CODE values('M', 'HOMEBASED SERVICES','');
insert into VO_DISCH_CODE values('N', 'INTENSIVE OUTPATIENT','');
insert into VO_DISCH_CODE values('NT', 'NON COMPLIANT WITH TREATMENT','');
insert into VO_DISCH_CODE values('O', 'OUTPATIENT','');
insert into VO_DISCH_CODE values('P', 'PARTIAL HOSPITALIZATION','');
insert into VO_DISCH_CODE values('R', 'RESIDENTIAL','');
insert into VO_DISCH_CODE values('S', 'RESPITE','');
insert into VO_DISCH_CODE values('SA', 'SUBSTANCE ABUSE TREATMENT','');
insert into VO_DISCH_CODE values('SC', 'SUBACUTE','');
insert into VO_DISCH_CODE values('SH', 'STATE HOSPITAL','');
insert into VO_DISCH_CODE values('T', 'ALTERNATIVE TREATMENT UNIT','');
insert into VO_DISCH_CODE values('U', 'UNDETERMINED','');
insert into VO_DISCH_CODE values('VP', 'VIOLATED PROBATION/PENDING ARREST','');
insert into VO_DISCH_CODE values('Y', 'PSYCHOSOCIAL REHAB','');
insert into VO_DISCH_CODE values('1', 'DECEASED','Expired');
insert into VO_DISCH_CODE values('10', 'TRANSFERED TO NON-ACUTE UNIT','');
insert into VO_DISCH_CODE values('11', 'AUTOCLOSED CASE','');
insert into VO_DISCH_CODE values('12', 'CLINICAL D/C-DETERIORATED','');
insert into VO_DISCH_CODE values('13', 'CLINICAL D/C-IMPLOVED','');
insert into VO_DISCH_CODE values('14', 'CLINICAL D/C-SAME','');
insert into VO_DISCH_CODE values('15', 'NON-CLINICAL-ADMINISTRATIVE','');
insert into VO_DISCH_CODE values('16', 'NEVER ADMITTED','');
insert into VO_DISCH_CODE values('17', 'CLINICAL NON-CERT','');
insert into VO_DISCH_CODE values('18', 'UNKNOWN','');
insert into VO_DISCH_CODE values('2', 'TRANSFERED TO MEDICAL','');
insert into VO_DISCH_CODE values('3', 'TRANSFERED TO PSYCH FACILITY','');
insert into VO_DISCH_CODE values('30', 'CLINICALLY','');
insert into VO_DISCH_CODE values('33', 'BENEFIT MAX','');
insert into VO_DISCH_CODE values('36', 'NO RESPONSE','');
insert into VO_DISCH_CODE values('39', 'PT REMAINS IN TX','');
insert into VO_DISCH_CODE values('4', 'INDIVIDUAL CASE MANAGEMENT','');
insert into VO_DISCH_CODE values('43', 'AFTERCARE','');
insert into VO_DISCH_CODE values('44', 'READMITTED TO ACUTE','');
insert into VO_DISCH_CODE values('47', 'ADVERTED/PRECERT','');
insert into VO_DISCH_CODE values('48', 'ADMIN DENIAL','');
insert into VO_DISCH_CODE values('5', 'TRANSFERED TO JAIL','');
insert into VO_DISCH_CODE values('51', 'CONTRACT','');
insert into VO_DISCH_CODE values('53', 'NO REVIEW REQUIRED','');
insert into VO_DISCH_CODE values('57', 'CLINICALLY DISCHARGE','');
insert into VO_DISCH_CODE values('58', 'DROPOUT OF','');
insert into VO_DISCH_CODE values('6', 'TRANSFERED TO LONG TERM FACILITY','');
insert into VO_DISCH_CODE values('7', 'TRANSFERED TO NURSING HOME','');
insert into VO_DISCH_CODE values('78', 'NO REVIEW/SECOND','');
insert into VO_DISCH_CODE values('8', 'OTHER','');
insert into VO_DISCH_CODE values('82', 'XFER TO ACUTE','');
insert into VO_DISCH_CODE values('83', 'XFER TO HALFWAY','');
insert into VO_DISCH_CODE values('88', 'CUSTODIAL','');
insert into VO_DISCH_CODE values('9', 'SPECIAL TREATMENT FACILITY','');
insert into VO_DISCH_CODE values('90', 'XFER TO NETWORK','');
insert into VO_DISCH_CODE values('93', 'NEED OTR','');
insert into VO_DISCH_CODE values('94', 'PREMATURE OTR','');
insert into VO_DISCH_CODE values('96', 'MED ADMIT/CASE','');
insert into VO_DISCH_CODE values('97', 'ADM/CLOSE LATE QTR','');
insert into VO_DISCH_CODE values('98', 'TX MOD/TERMINATED','');
insert into VO_DISCH_CODE values('99', 'INELIGIBLE PROVIDER','');
commit;     
GRANT SELECT ON CHOICEBI.VO_DISCH_CODE TO DW_OWNER;

GRANT SELECT ON CHOICEBI.VO_DISCH_CODE TO MSTRSTG;

GRANT SELECT ON CHOICEBI.VO_DISCH_CODE TO ROC_RO;
