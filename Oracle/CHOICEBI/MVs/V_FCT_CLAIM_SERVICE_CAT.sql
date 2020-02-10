drop view V_FCT_CLAIM_SERVICE_CAT1

CREATE MATERIALIZED VIEW V_FCT_CLAIM_SERVICE_CAT1
BUILD IMMEDIATE
REFRESH FORCE
--NEXT TRUNC(SYSDATE) + 1.27 
WITH PRIMARY KEY
AS 
SELECT *FROM V_SERVICE_CAT;


create or replace view V_FCT_CLAIM_SERVICE_CAT as 
select 
    CASE
       WHEN a.src_sys = 'BV' THEN
           'VISION'
       WHEN a.src_sys = 'MI' THEN
           'PHARMACY'
       WHEN a.src_sys = 'VO' THEN
           'MENTAL HEALTH'
       WHEN a.src_sys = 'HP' THEN
           'DENTAL'
       WHEN a.src_sys = 'NMN' THEN
           'TRANSPORTATION'
       WHEN a.src_sys = 'TR' THEN
           'CHIROPRACTIC'
       WHEN SUBSTR( proc_cd, 1, 5) IN
                ('H0002',
                 'H0004',
                 'H0020',
                 'H0031',
                 'H0032',
                 'H0035',
                 'H0036',
                 'H0037',
                 'H0038',
                 'H0044',
                 'H0045',
                 'H0046',
                 'H2021',
                 'H2012',
                 'H2013',
                 'H2014',
                 'H2017',
                 'H2018',
                 'H2019',
                 'H2020',
                 'H2023',
                 'H2025',
                 'J0401',
                 'J2358',
                 'J2426',
                 'J2794',
                 'H0040',
                 '90791',
                 'S9484',
                 'S9485',
                 'T1015',
                 'T2013',
                 'T2015',
                 '99510') THEN
           'MENTAL HEALTH'
       WHEN facility_type = '01' AND bill_class IN (1, 2) THEN --AND prpr_mctr_type IN ('HOSP', 'HSP')
           'INPATIENT'
       WHEN facility_type = '08' AND bill_class IN ('1', '2') AND SUBSTR( revenue_cd, 1, 4) IN ('0655', '0656', '0658', '0651', '0101') THEN
           'HOSPICE'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('S5100', 'S5101', 'S5102', 'S5105') THEN
           'DC'
       WHEN (facility_type IN ('02') AND bill_class IN ('1')) AND ((SUBSTR( revenue_cd, 1, 4) BETWEEN '0180' AND '0185') OR (SUBSTR( revenue_cd, 1, 4) BETWEEN '0189' AND '0199') OR (
            SUBSTR                                                                                                                                                                            ( revenue_cd
            , 1, 4) BETWEEN '0100'
                        AND '0169') OR (SUBSTR                         ( revenue_cd, 1, 4) BETWEEN '0420' AND '0444') OR SUBSTR( revenue_cd, 1, 4) = '0022' OR (SUBSTR( revenue_cd, 1, 4) IN
            ('0012', '0024', '0229', '0240', '0260', '0270', '0279', '0410', '0419', '0460', '0480', '3836') AND service_id IN ('CAIH', 'IAN', 'IFIH', 'NHCA', 'PUIH', 'RHPP', 'RSIH', 'SNPP',
            'SPIH')) OR (lob = 'MLTC' AND SUBSTR                       ( revenue_cd, 1, 5) = '0655') OR (lob = 'MLTC' AND service_id IN ('NHRG', 'NHOT', 'NHVB', 'NHRS'))) THEN
           'SNF'
       WHEN ((facility_type IN ('01') AND bill_class IN ('4', '3')) OR revenue_cd IN ('HSP', 'HOSP', 'OUT', 'GROU', 'GRP')) AND (SUBSTR( proc_cd, 1, 5) BETWEEN '99281' AND '99285' OR
            SUBSTR                                                                                                                                                                             ( revenue_cd
            , 1, 4) IN
                ('0450', '0451', '0452', '0459')) THEN
           'ER'
       WHEN SPECIALTY_CODE IN ('HSP', 'HOSP', 'OUT', 'GROU', 'GRP', 'ASC', 'DTC') AND SUBSTR( revenue_cd, 1, 4) BETWEEN '0490' AND '0499' THEN
           'AMB SURG' ---  better
       WHEN SUBSTR( proc_cd, 1, 5) IN ('11720', '11721', '11730', '11750', '97597', '17110') OR SPECIALTY_CODE IN ('778', '918') THEN
           'PODIATRY'
       WHEN (SUBSTR( proc_cd, 1, 5) = 'G0176' AND SUBSTR( revenue_cd, 1, 4) BETWEEN '0560' AND '0569') OR SUBSTR( proc_cd, 1, 5) = 'S9127' THEN
           'MED SOCIAL SERVICES'
       WHEN (SUBSTR( proc_cd, 1, 5) BETWEEN '99500' AND '99507') OR (SUBSTR( proc_cd, 1, 5) IN ('99511', '99512') OR (SUBSTR( proc_cd, 1, 5) IN ('99600')) OR (SUBSTR( proc_cd, 1, 5) IN (
            'T1001', 'T1023', 'T1028', 'T1030', 'T1031', 'S9123', 'S9124', 'S9802', 'T1000', 'T1003')) OR (SUBSTR( revenue_cd, 1, 4) BETWEEN '0550' AND '0559')) THEN
           'PROF_NUR' --- these two include PCS, Home Health (Nursing)
       WHEN SUBSTR( proc_cd, 1, 5) IN ('T1019', 'T1020', 'T1021', 'S9122', 'S5130', 'S5131', 'S5125', 'S5126', 'G0156') OR SUBSTR( revenue_cd, 1, 4) BETWEEN '0570' AND '0590' THEN
           'PARAPROF' --- see below
       WHEN SUBSTR( proc_cd, 1, 5) IN ('G0151', 'S9131') OR (pos_id = '12' AND SPECIALTY_CODE = '300') OR (service_id IN ('HHPN', 'HHPV', 'PTO', 'PTOM') AND pos_id = '12') THEN
           'PROF_PT'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('G0152', 'S9129') OR (service_id IN ('HHON', 'OTO', 'HHOV') AND pos_id = '12') THEN
           'PROF_OT'
       WHEN (SUBSTR( proc_cd, 1, 5) IN ('G0237', 'G0238') AND revenue_cd BETWEEN '0580' AND '0589') OR (SUBSTR( proc_cd, 1, 5) = 'S5181' AND pos_id = '12') THEN
           'PROF_RT'
       WHEN SUBSTR( proc_cd, 1, 5) = 'S9128' OR (service_id IN ('HHSN') AND pos_id = '12') THEN
           'HHC_ST'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('T1028', 'S5165') OR SPECIALTY_CODE = '661' THEN
           'PROF_SES'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('S9452', 'S9470') THEN
           'PROF_NUT' --- embodies all other home health services that are not covered under HHA/CDPAS + PDN (TBD)
       WHEN SPECIALTY_CODE IN ('050', '055', '056', '058', '060', '089', '092', '150', '182', '184', '254', '306', '324', '601', '602', '620', '621', '776', '779', '782', '904', '905', '908',
            '909', '914', '936', '990', '991', '249', '303', '308') OR revenue_cd IN ('0514', '0515', '0517', '0523') OR revenue_cd BETWEEN '0770' AND '0779' OR SPECIALTY_CODE = 'URG' OR (
            (facility_type IN ('01') AND bill_class IN ('3')) AND SUBSTR                                                                                                                      ( proc_cd, 1, 5)
            IN ('G0438', 'G0439') AND SUBSTR                                                                                                                                                      ( revenue_cd, 1, 4)
            IN ('0510', '0519')) OR SUBSTR( proc_cd, 1, 5) IN ('99406', '99407', 'G0436', 'G9016', 'G0437', 'G0447', '99386', '99391', '99396', '99401', '99402') OR SPECIALTY_CODE IN ('NP',
            'PA') OR (SUBSTR( proc_cd, 1, 5) = 'G0463' AND SUBSTR( revenue_cd, 1, 4) IN ('0510', '0519', '0456', '0516', '0521') AND service_id IN ('UROH', 'OVOH', 'OVUR', 'OVRO')) OR (SPECIALTY_CODE = 'FQHC' AND service_id = 'OVRC' AND SUBSTR                                                                                                                       ( revenue_cd, 1, 4)
            IN ('0521', '0510')) OR (SUBSTR( revenue_cd, 1, 4) = '0456' AND service_id = 'UROH') OR service_id IN ('ANHS', 'OER') OR (proc_cd = 'G0463' AND (facility_type IN ('01') AND
            bill_class IN
                ('3'))) OR (lob = 'FIDA' AND service_id IN ('OVOH', 'OVOP', 'OVRO') AND proc_cd = '992') THEN
           'PRI CARE'
       --WHEN SPECIALTY_CODE IN
       WHEN SPECIALTY_CODE IN
                ('010',
                 '100',
                 '101',
                 '110',
                 '111',
                 '112',
                 '113',
                 '114',
                 '120',
                 '121',
                 '137',
                 '141',
                 '143',
                 '149',
                 '151',
                 '152',
                 '153',
                 '154',
                 '155',
                 '156',
                 '157',
                 '161',
                 '163',
                 '164',
                 '165',
                 '166',
                 '167',
                 '170',
                 '186',
                 '188',
                 '190',
                 '193',
                 '194',
                 '199',
                 '020',
                 '210',
                 '211',
                 '220',
                 '230',
                 '231',
                 '241',
                 '242',
                 '245',
                 '250',
                 '030',
                 '305',
                 '321',
                 '325',
                 '332',
                 '355',
                 '356',
                 '358',
                 '040',
                 '041',
                 '059',
                 '600',
                 '603',
                 '061',
                 '062',
                 '063',
                 '630',
                 '064',
                 '065',
                 '650',
                 '651',
                 '652',
                 '066',
                 '067',
                 '068',
                 '069',
                 '070',
                 '071',
                 '072',
                 '073',
                 '730',
                 '741',
                 '075',
                 '076',
                 '775',
                 '799',
                 '811',
                 '902',
                 '903',
                 '915',
                 '916',
                 '917',
                 '925',
                 '926',
                 '927',
                 '928',
                 '929',
                 '093',
                 '930',
                 '931',
                 '932',
                 '933',
                 '934',
                 '935',
                 '937',
                 '938',
                 '939',
                 '940',
                 '941',
                 '942',
                 '943',
                 '944',
                 '095',
                 '950',
                 '951',
                 '952',
                 '953',
                 '954',
                 '955',
                 '956',
                 '958',
                 '960',
                 '961',
                 '962',
                 '965',
                 '966',
                 '977',
                 '979',
                 '980',
                 '981',
                 '983',
                 '995',
                 '996',
                 '240',
                 '144',
                 '083',
                 '084',
                 '243',
                 '653') THEN
           'SPECIALIST CARE'
       WHEN SPECIALTY_CODE IN ('074', '080', '081', '127', '128', '129', '130', '131', '135', '136', '138', '139', '140', '142', '146', '148', '189', '200', '201', '202', '205', '206', '207',
            '208', '244', '246', '411', '412', '413', '414', '415', '416', '419', '420', '421', '422', '423', '427', '430', '431', '432', '435', '436', '438', '439', '440', '441', '442', '450',
            '451', '460', '463', '470', '481', '482', '483', '484', '485', '486', '491', '510', '511', '512', '513', '514', '515', '516', '518', '521', '523', '524', '531', '540', '550', '551',
            '552', '553', '560', '571', '572', '573', '599', '994', '998') OR (SUBSTR( proc_cd, 1, 5) IN ('36400', '36410', '36415', '59000', '59012', '59015', '74741') OR (SUBSTR( proc_cd, 1, 5)
            BETWEEN '70000'
                AND '74739') OR (SUBSTR                                        ( proc_cd, 1, 5) BETWEEN '74743' AND '76840') OR (SUBSTR( proc_cd, 1, 5) BETWEEN '76842' AND '76856') OR (SUBSTR( proc_cd, 1, 5)
            BETWEEN '76858'
                AND '79999') OR (SUBSTR                                        ( proc_cd, 1, 5) BETWEEN '80002' AND '89309') OR (SUBSTR( proc_cd, 1, 5) BETWEEN '89311' AND '89399') OR (SUBSTR( proc_cd, 1, 5)
            BETWEEN 'P0001'
                AND 'P9999') OR (SUBSTR                                        ( proc_cd, 1, 5) BETWEEN 'R0001' AND 'R5999') OR (SUBSTR( revenue_cd, 1, 4) BETWEEN '0300' AND '0329') OR (
            SUBSTR                                                                                                                                                                            ( revenue_cd
            , 1, 4) BETWEEN '0350'
                        AND '0359') OR (SUBSTR                                 ( revenue_cd, 1, 4) BETWEEN '0400' AND '0409') OR (SUBSTR( revenue_cd, 1, 4) BETWEEN '0730' AND '0749') OR (
            SUBSTR                                                                                                                                                                             ( revenue_cd
            , 1, 4) BETWEEN '0920'
                        --AND '0929')) OR (prpr_mctr_type IN ('LAB', 'LABO')) OR (service_desc LIKE '%DIAGNOSTI%') --- cardiography procedures
            AND '0929')) OR (SPECIALTY_CODE IN ('LAB', 'LABO')) OR (service_desc LIKE '%DIAGNOSTI%') --- cardiography procedures
                                                                                                        THEN
           'DIAG/LAB' --- needs to be tested with the logic here --- it's good now
       WHEN SUBSTR( proc_cd, 1, 5) IN ('S5160', 'S5161') THEN
           'PERS' --- it's the same
       WHEN SUBSTR( proc_cd, 1, 5) != 'V5010' AND (SUBSTR( proc_cd, 1, 5) IN ('V5009', 'K0452') OR SUBSTR( proc_cd, 1, 5) BETWEEN 'A4000' AND 'A9999' OR SUBSTR( proc_cd, 1, 5) BETWEEN
            'B4034'
                                                                                                                                                                                            AND
            'B5200' OR SUBSTR                        ( proc_cd, 1, 5) BETWEEN 'L0000' AND 'L9900' OR SUBSTR( proc_cd, 1, 5) BETWEEN 'E0100' AND 'E9999' OR SUBSTR( proc_cd, 1, 5) BETWEEN
            'V5000'
                                                                                                                                                                                            AND
            'V5007' OR SUBSTR                        ( proc_cd, 1, 5) BETWEEN 'V5012' AND 'V5019' OR SUBSTR( proc_cd, 1, 5) BETWEEN 'V5021' AND 'V5336' OR SUBSTR( proc_cd, 1, 5) BETWEEN
            'K0001'
                                                                                                                                                                                            AND
            'K0108' OR SUBSTR                        ( revenue_cd, 1, 4) BETWEEN '0290' AND '0299') OR (UPPER(SUBSTR( service_desc, 1, 21)) IN ('DURABLE MEDICAL EQUIP') OR UPPER(
            service_desc) LIKE
                '%DME%' OR UPPER                                                                          (service_desc) LIKE '%HEARING AID%' OR UPPER(service_desc) LIKE '%CAPPED RENTAL%' OR
            UPPER
            (service_desc) LIKE
                '%SUPPLIES%') THEN
           'DMEPOS' --- combine what we have for this category (mainly move 'OTHER'), but watch out for V5010
       --WHEN SUBSTR( proc_cd, 1, 5) IN ('V5008', 'V5010', 'V5011', 'V5020') OR SUBSTR( revenue_cd, 1, 4) BETWEEN '0470' AND '0479' OR SPECIALTY_CODE = '640' THEN
       WHEN SUBSTR( proc_cd, 1, 5) IN ('V5008', 'V5010', 'V5011', 'V5020') OR SUBSTR( revenue_cd, 1, 4) BETWEEN '0470' AND '0479' OR SPECIALTY_CODE = '640' THEN
           'AUDIO/HEAR' --- few exist tho
       WHEN SUBSTR( proc_cd, 1, 5) IN ('A0021', 'A0225') OR SUBSTR( proc_cd, 1, 5) BETWEEN 'T2001' AND 'T2005' OR SUBSTR( proc_cd, 1, 5) BETWEEN 'A0080' AND 'A0214' OR SUBSTR( proc_cd, 1, 5)
            BETWEEN 'A0420'
                AND 'A0999' OR SUBSTR( revenue_cd, 1, 4) BETWEEN '0540' AND '0549' OR SUBSTR( proc_cd, 1, 5) IN ('S0209', 'S0215') THEN
           'TRANS' --- it's a better way here
       --WHEN SUBSTR( proc_cd, 1, 5) IN ('S5170', 'S9977') OR SPECIALTY_CODE = '667' THEN
       WHEN SUBSTR( proc_cd, 1, 5) IN ('S5170', 'S9977') OR SPECIALTY_CODE = '667' THEN
           'MEALS' --- same
       WHEN SUBSTR( proc_cd, 1, 5) BETWEEN '97001' AND '97799' OR (SUBSTR( proc_cd, 1, 5) = 'G0283' AND service_desc LIKE '%OUTPATIENT%') OR SUBSTR( revenue_cd, 1, 3) = '042' --- PT
                                                                                                                                                                                      OR SUBSTR( revenue_cd, 1, 3)
            = '043' --- OT
                   OR SUBSTR( revenue_cd, 1, 3) = '044' --- SLP
                                                         OR SUBSTR( revenue_cd, 1, 3) = '093' --- MR
                                                                                               OR SUBSTR( revenue_cd, 1, 3) = '094' --- Drug Rehab
                                                                                                                                     OR SUBSTR( revenue_cd, 1, 3) = '095' --- Alcohol Rehab
                                                                                                                                                                           THEN
           'OP REHAB'
       --WHEN SUBSTR( proc_cd, 1, 5) BETWEEN 'V2000' AND 'V2999' OR SPECIALTY_CODE IN ('714', '715', '716', '851', '919') OR service_desc LIKE '%VISION%' THEN
       WHEN SUBSTR( proc_cd, 1, 5) BETWEEN 'V2000' AND 'V2999' OR SPECIALTY_CODE IN ('714', '715', '716', '851', '919') OR service_desc LIKE '%VISION%' THEN
           'VISION'
       --WHEN SPECIALTY_CODE = '913' OR (SUBSTR( proc_cd, 1, 5) = '90999' AND SUBSTR( revenue_cd, 1, 4) = '0821') THEN
       WHEN SPECIALTY_CODE = '913' OR (SUBSTR( proc_cd, 1, 5) = '90999' AND SUBSTR( revenue_cd, 1, 4) = '0821') THEN
           'DIALYSIS'
       WHEN SUBSTR( proc_cd, 1, 5) BETWEEN '99201' AND '99205' OR SUBSTR( proc_cd, 1, 5) BETWEEN '99211' AND '99215' OR service_desc LIKE '%PRACTITIONER VISIT%' THEN
           'PRAC VISITS' --- ???
       WHEN service_desc LIKE '%INJECTION%' OR service_desc LIKE '%VACCINE%' THEN
           'INJECTION'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('T2030', 'T2031') OR SUBSTR( proc_cd, 1, 5) BETWEEN '99324' AND '99328' OR SUBSTR( proc_cd, 1, 5) BETWEEN '99334' AND '99337' OR SUBSTR( proc_cd, 1, 5)
            BETWEEN '99339'
                AND '99345' THEN
           'ASSISTED LIVING'
       WHEN SUBSTR( proc_cd, 1, 5) BETWEEN '99341' AND '99345' OR SUBSTR( proc_cd, 1, 5) BETWEEN '99347' AND '99350' OR SUBSTR( proc_cd, 1, 5) BETWEEN '99500' AND '99507' OR SUBSTR( proc_cd, 1, 5)
            IN ('99509', '99511', '99512') THEN
           'HV FIDA' --- 28 FIDA members in 99342
       WHEN SUBSTR( proc_cd, 1, 5) BETWEEN '99605' AND '99607' OR SUBSTR( proc_cd, 1, 5) BETWEEN '97802' AND '97804' OR SUBSTR( proc_cd, 1, 5) IN ('G2070', 'G2071', 'S9470', 'G8427',
            '1111F', '1159F', '1160F') THEN
           'MED THER'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('T1014', 'Q3014') THEN
           'TELEHEALTH'
       WHEN SUBSTR( proc_cd, 1, 5) IN ('G0447', 'G0436', 'G9016', 'G0437', '99406', '99407') THEN
           'PRI CARE FIDA'
       ELSE
           'OTHER'
    END
       AS service_type
from
    V_FCT_CLAIM_SERVICE_CAT1 a
    LEFT JOIN choice.DIM_PROVIDER_SPECIALTY@dlake d ON (d.PROVIDER_ID = a.service_provider_id AND a.src_sys = d.src_sys)
    
    
SELECT COUNT(*) FROM V_FCT_CLAIM_SERVICE_CAT1    