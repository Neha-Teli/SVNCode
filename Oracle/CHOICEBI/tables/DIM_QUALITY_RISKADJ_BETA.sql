DROP TABLE DIM_QUALITY_RISKADJ_B

create table DIM_QUALITY_RISKADJ_B
(
    RA_MODEL_YEAR           NUMBER,
    MSR_ID                  NUMBER,
    MSR_TOKEN               VARCHAR2 (50),
    OUTCOME_TYPE            VARCHAR2 (50),
    OUTCOME_MEASURE         VARCHAR2 (50),
    RISK_FACTOR             VARCHAR2 (50),
    RISK_FACTOR_BETA_VAL    NUMBER
)



insert into DIM_QUALITY_RISKADJ_B 
select  
RA_YEAR RSKADJ_MODEL_YEAR  
,MSR_ID             
,MSR_TOKEN        
,OUTCOME_TYPE  
,OUTCOME_MEASURE    
,RISK_FAC           
,BETA_VALUE         
from KEN_K.CHOICE_QUAL_RSKADJ_BETA@MS_OWNER_RCPROD


select * from DIM_QUALITY_RISKADJ_B

drop view V_FACT_QUALITY_RA_RISKFCTR

CREATE OR REPLACE VIEW V_FACT_QUALITY_RA_RISKFCTR
AS
    SELECT A.RECORD_ID,
           1 AS intercept,
           CASE
               WHEN a.assessmentdate IS NOT NULL AND a.dateofbirth IS NOT NULL AND NVL( B.VALUE, FLOOR( (a.assessmentdate - a.dateofbirth) / 365.25)) BETWEEN 0 AND 55 THEN 1
               ELSE 0
           END AS age_lte54,
           CASE
               WHEN a.assessmentdate IS NOT NULL AND a.dateofbirth IS NOT NULL AND NVL(B.VALUE, FLOOR( (a.assessmentdate - a.dateofbirth) / 365.25)) BETWEEN 55 AND 64 THEN 1
               ELSE 0
           END
               AS age_55_64,
           CASE
               WHEN a.assessmentdate IS NOT NULL AND a.dateofbirth IS NOT NULL AND NVL( B.VALUE, FLOOR( (a.assessmentdate - a.dateofbirth) / 365.25)) BETWEEN 65 AND 74 THEN 1
               ELSE 0
           END AS age_65_74,
           CASE
               WHEN a.assessmentdate IS NOT NULL AND a.dateofbirth IS NOT NULL AND NVL(B.VALUE, FLOOR( (a.assessmentdate - a.dateofbirth) / 365.25)) BETWEEN 75 AND 84 THEN 1
               ELSE 0
           END
               AS age_75_84,
           CASE
               WHEN a.assessmentdate IS NOT NULL AND a.dateofbirth IS NOT NULL AND NVL(B.VALUE,FLOOR((a.assessmentdate - a.dateofbirth) / 365.25)) >= 85 THEN 1
               ELSE 0
           END AS age_85,
           CASE
               WHEN A.dateofbirth IS NULL OR a.assessmentdate IS NULL THEN 1
               ELSE 0
           END AS age_missing,
           CASE
               WHEN NVL(A.adlstatus, 0) = 2 THEN 1
               WHEN NVL(A.adlstatus, 0) IN (0, 1, 8) THEN 0
           END AS badldecline,
           CASE WHEN b1.VALUE BETWEEN 2 AND 6 THEN 1 ELSE 0 END AS badlh2,
           CASE WHEN b1.VALUE BETWEEN 3 AND 6 THEN 1 ELSE 0 END AS badlh3,
           CASE WHEN b1.VALUE BETWEEN 4 AND 6 THEN 1 ELSE 0 END AS badlh4,
           CASE
               WHEN NVL(A.ADLBATHING, 0) IN (1, 2, 3, 4, 5, 6) THEN 1 -- according to email response, everything except 0 and 8 should be counted
               WHEN NVL(a.adlbathing, 0) IN (0, 8) THEN 0
           END AS bbathing,
           CASE WHEN NVL(A.CARDIACFAILURE, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS bchf,
           CASE WHEN NVL(A.INSTABILITYPATTERNS, 0) = 1 THEN 1 ELSE 0 END AS bconditions,
           CASE
               WHEN NVL(A.COGNITIVESKILLS, 0) IN (1, 2, 3, 4, 5) THEN 1
               ELSE 0
           END AS bdecsn, -- according to email response, count everything except 0
           CASE
               WHEN NVL(B2.VALUE, 0) BETWEEN 0 AND 2 THEN 0
               WHEN NVL(b2.VALUE, 0) >= 3 THEN 1
           END AS bdeprate,
           CASE WHEN NVL(A.OTHERDIABETES, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS bdiabetes,
           CASE WHEN NVL(A.DYSPNEA, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS bdyspnea,
           CASE WHEN NVL(C.INSTABILITYENDSTAGE, 0) = 1 THEN 1 ELSE 0 END AS bendstage,
           CASE WHEN NVL(A.FALLS, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS bfalls,
           CASE
               WHEN NVL(A.ADLLOCOMOTION, 0) IN (2, 3, 4, 5, 6) THEN 1
               WHEN NVL(A.ADLLOCOMOTION, 0) IN (0, 1, 8) THEN 0
           END AS bloco,
           CASE
               WHEN NVL(A.ADLLOCOMOTION, 0) IN (4, 5, 6) THEN 1
               WHEN NVL(a.adllocomotion, 0) IN (0, 1, 2, 3, 8) THEN 0
           END
               AS blocomot,
           CASE WHEN A.DAYSOUTDOORS IN (0, 1) THEN 1 ELSE 0 END AS boutside,
           CASE WHEN NVL(A.PAINFREQUENCY, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS bpain,
           CASE
               WHEN NVL(A.NEGATIVESTATEMENTS, 0) IN (0, 1) THEN 0
               WHEN NVL(A.NEGATIVESTATEMENTS, 0) IN (2, 3) THEN 1
           END AS bsadness,
           CASE
               WHEN NVL(A.NEUROLOGICALSTROKE, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS bstroke,
           CASE
               WHEN NVL(A.UNDERSTANDOTHERS, 0) IN (1, 2, 3, 4) THEN 1
               ELSE 0
           END AS bunstand,
           CASE
               WHEN NVL(A.PROBLEMUNSTEADYGAIT, 0) IN (1, 2, 3, 4) THEN 1
               ELSE 0
           END AS bunsteadygait,
           CASE
               WHEN NVL(A.LOCOMOTIONINDOORS, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS bwalkass,
           CASE
               WHEN NVL(A.COGNITIVESKILLS, 0) IN (2, 3, 4, 5) THEN 1
               WHEN NVL(A.COGNITIVESKILLS, 0) IN (0, 1) THEN 0
           END AS cogntv_2,
           CASE
               WHEN NVL(A.CARDIACPULMONARY, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS copd_2,
           CASE
               WHEN NVL(A.CARDIACHEARTDISEASE, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS cvd_2,
           CASE
               WHEN NVL(A.PROBLEMDIZZINESS, 0) IN (1, 2, 3, 4) THEN 1
               ELSE 0
           END AS dizzy_2,
           CASE WHEN NVL(d.gender, 0) = 1 THEN 1 ELSE 0 END AS gender_2, -- 1 is for male and 0 is for female
           CASE
               WHEN NVL(A.LIFESTYLEALCOHOL, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS lifestyle_alcohol_cd,
           CASE
               WHEN NVL(A.IADLPERFORMANCEMEDS, 0) IN (0, 1, 8) THEN 0
               WHEN NVL(A.IADLPERFORMANCEMEDS, 0) IN (2, 3, 4, 5, 6) THEN 1
           END AS med_manag_2,
           CASE
               WHEN NVL(A.MUSCULOSKELETALHIP, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS musculoskeletal_hip_cd,
           CASE
               WHEN NVL(A.MUSCULOSKELETALOTHERFRACTURE, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS musculoskeletal_othr_fract_cd,
           CASE WHEN NVL(d.levelofcarescore, 0) >= 34 THEN 1 ELSE 0 END AS nfloc_bad,
           CASE WHEN NVL(A.OTHERCANCER, 0) IN (1, 2, 3) THEN 1 ELSE 0 END AS other_cancer_cd,
           CASE WHEN NVL(A.PAINFREQUENCY, 0) = 3 THEN 1 ELSE 0 END AS pain_daily_2, -- used 3 as its the only option for daily pain but feel like 2 should be too since its 1-2 days out of 3
           CASE WHEN NVL(b3.VALUE, 0) >= 3 THEN 1 ELSE 0 END AS pain_intensity_bad,
           CASE
               WHEN (   NVL(A.NEUROLOGICALALZHEIMERS, 0) IN (1, 2, 3) OR NVL(A.NEUROLOGICALDEMENTIA, 0) IN (1, 2, 3)) THEN 1
               ELSE 0
           END AS pialzoth,
           CASE
               WHEN NVL(A.SELFRATEDHEALTH, 0) = 3 THEN 1
               WHEN NVL(A.SELFRATEDHEALTH, 0) IN (0, 1, 2, 8) THEN 0
           END AS poorhealth_2,
           CASE
               WHEN NVL(A.PSYCHIATRICANXIETY, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS psychiatric_anxiety_cd,
           CASE
               WHEN NVL(A.PSYCHIATRICBIPOLAR, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS psychiatric_bipolar_cd,
           CASE
               WHEN NVL(A.PSYCHIATRICSCHIZOPHRENIA, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END AS psychiatric_schizophrenia_cd,
           CASE
               WHEN NVL(A.MOODSAD, 0) IN (2, 3) THEN 1
               WHEN NVL(A.MOODSAD, 0) IN (0, 1, 8) THEN 0
           END AS sad_2, -- did not include 1 becasue it asking for reported or not
           CASE
               WHEN NVL(A.DYSPNEA, 0) IN (2, 3) THEN 1
               WHEN NVL(A.DYSPNEA, 0) IN (0, 1) THEN 0
           END AS short_of_breath_bad,
           CASE
               WHEN NVL(A.BLADDERCONTINENCE, 0) IN (0, 1, 2, 3, 4, 8) THEN 0
               WHEN NVL(A.BLADDERCONTINENCE, 0) = 5 THEN 1
           END AS urinary_cont_bad, -- according to email response, its value 5 against all others
           CASE
               WHEN (    A.ADLLOCOMOTION = 6
                     AND A.ADLHYGIENE = 6
                     AND A.ADLBATHING = 6) THEN
                   1
               ELSE
                   0
           END AS adl_bad,
           CASE
               WHEN NVL(A.NEUROLOGICALALZHEIMERS, 0) IN (1, 2, 3) THEN 1 ELSE 0
           END
               AS balz,
           CASE
               WHEN NVL(A.BEHAVIORDISRUPTIVE, 0) IN (1, 2, 3) THEN 1 ELSE 0
           END
               AS behav_disrpt_2,
           CASE
               WHEN NVL(A.NEUROLOGICALDEMENTIA, 0) IN (1, 2, 3) THEN 1
               ELSE 0
           END
               AS bothdem,
           CASE WHEN NVL(A.MEMORYRECALLSHORT, 0) = 1 THEN 1 ELSE 0 END
               AS bshortterm,
           CASE WHEN NVL(B4.VALUE, 0) >= 5 THEN 1 ELSE 0 END AS cognition_bad,
           CASE WHEN NVL(A.ADLLOCOMOTION, 0) = 6 THEN 1 ELSE 0 END
               AS locomotion_bad,
           CASE WHEN NVL(A.IADLPERFORMANCEMEDS, 0) = 6 THEN 1 ELSE 0 END
               AS managing_meds_bad,
           CASE
               WHEN NVL(
                        (CASE
                             WHEN (NVL2(a.negativestatements, 0, 1) + NVL2(a.persistentanger, 0, 1) + NVL2(a.unrealfears, 0, 1) 
                                  + NVL2(a.healthcomplaints, 0, 1) + NVL2(a.anxiouscomplaints, 0, 1) + NVL2(a.sadfacial, 0, 1) + NVL2(a.crying, 0, 1)) < 3
                                  AND NVL(a.moodinterest, 8) = 8 AND NVL(a.moodanxious, 8) = 8 AND NVL(a.moodsad, 8) = 8 THEN
                                  (CASE
                                      WHEN (  (CASE
                                                   WHEN a.negativestatements = 0 THEN 0
                                                   WHEN a.negativestatements IN (1, 2) THEN 1
                                                   WHEN a.negativestatements = 3 THEN 2
                                                   ELSE 0
                                               END)
                                            + (CASE
                                                   WHEN a.persistentanger = 0 THEN 0
                                                   WHEN a.persistentanger IN (1, 2) THEN 1
                                                   WHEN a.persistentanger = 3 THEN 2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.unrealfears = 0 THEN 0
                                                   WHEN a.unrealfears IN (1, 2) THEN 1
                                                   WHEN a.unrealfears = 3 THEN 2
                                                   ELSE 0
                                               END)
                                            + (CASE
                                                   WHEN a.healthcomplaints = 0 THEN 0
                                                   WHEN a.healthcomplaints IN (1, 2) THEN 1
                                                   WHEN a.healthcomplaints = 3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.anxiouscomplaints = 0 THEN 0
                                                   WHEN a.anxiouscomplaints IN (1, 2) THEN 1
                                                   WHEN a.anxiouscomplaints = 3 THEN 2
                                                   ELSE 0
                                               END)
                                            + (CASE
                                                   WHEN a.sadfacial = 0 THEN 0
                                                   WHEN a.sadfacial IN (1, 2) THEN 1
                                                   WHEN a.sadfacial = 3 THEN 2
                                                   ELSE 0
                                               END)
                                            + (CASE
                                                   WHEN a.crying = 0 THEN 0
                                                   WHEN a.crying IN (1, 2) THEN 1
                                                   WHEN a.crying = 3 THEN 2
                                                   ELSE 0
                                               END)) > 5 THEN
                                          5
                                      WHEN (  (CASE
                                                   WHEN a.negativestatements = 0 THEN 0
                                                   WHEN a.negativestatements IN (1, 2) THEN 1
                                                   WHEN a.negativestatements = 3 THEN 2
                                                   ELSE 0
                                               END)
                                            + (CASE
                                                   WHEN a.persistentanger = 0 THEN
                                                       0
                                                   WHEN a.persistentanger IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.persistentanger = 3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.unrealfears = 0 THEN
                                                       0
                                                   WHEN a.unrealfears IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.unrealfears = 3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.healthcomplaints =
                                                            0 THEN
                                                       0
                                                   WHEN a.healthcomplaints IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.healthcomplaints =
                                                            3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.anxiouscomplaints =
                                                            0 THEN
                                                       0
                                                   WHEN a.anxiouscomplaints IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.anxiouscomplaints =
                                                            3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.sadfacial = 0 THEN
                                                       0
                                                   WHEN a.sadfacial IN (1, 2) THEN
                                                       1
                                                   WHEN a.sadfacial = 3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.crying = 0 THEN
                                                       0
                                                   WHEN a.crying IN (1, 2) THEN
                                                       1
                                                   WHEN a.crying = 3 THEN
                                                       2
                                                   ELSE
                                                       0
                                               END)) BETWEEN 0
                                                         AND 5 THEN
                                          (  (CASE
                                                  WHEN a.negativestatements =
                                                           0 THEN
                                                      0
                                                  WHEN a.negativestatements IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.negativestatements =
                                                           3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.persistentanger = 0 THEN
                                                      0
                                                  WHEN a.persistentanger IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.persistentanger = 3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.unrealfears = 0 THEN
                                                      0
                                                  WHEN a.unrealfears IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.unrealfears = 3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.healthcomplaints = 0 THEN
                                                      0
                                                  WHEN a.healthcomplaints IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.healthcomplaints = 3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.anxiouscomplaints =
                                                           0 THEN
                                                      0
                                                  WHEN a.anxiouscomplaints IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.anxiouscomplaints =
                                                           3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.sadfacial = 0 THEN
                                                      0
                                                  WHEN a.sadfacial IN (1, 2) THEN
                                                      1
                                                  WHEN a.sadfacial = 3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.crying = 0 THEN
                                                      0
                                                  WHEN a.crying IN (1, 2) THEN
                                                      1
                                                  WHEN a.crying = 3 THEN
                                                      2
                                                  ELSE
                                                      0
                                              END))
                                      ELSE
                                          NULL
                                  END)
                             WHEN (  NVL2(a.negativestatements, 0, 1)
                                       + NVL2(a.persistentanger, 0, 1)
                                       + NVL2(a.unrealfears, 0, 1)
                                       + NVL2(a.healthcomplaints, 0, 1)
                                       + NVL2(a.anxiouscomplaints, 0, 1)
                                       + NVL2(a.sadfacial, 0, 1)
                                       + NVL2(a.crying, 0, 1)) >= 3
                                  AND (NVL(a.moodinterest, 8) <> 8 OR NVL(a.moodanxious, 8) <> 8 OR NVL(a.moodsad, 8) <> 8) THEN
                                        (CASE
                                      WHEN (  (CASE
                                                   WHEN a.moodinterest = 0 THEN
                                                       0
                                                   WHEN a.moodinterest IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.moodinterest = 3 THEN
                                                       2
                                                   WHEN a.moodinterest = 8 THEN
                                                       0
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.moodanxious = 0 THEN
                                                       0
                                                   WHEN a.moodanxious IN
                                                            (1, 2) THEN
                                                       1
                                                   WHEN a.moodanxious = 3 THEN
                                                       2
                                                   WHEN a.moodanxious = 8 THEN
                                                       0
                                                   ELSE
                                                       0
                                               END)
                                            + (CASE
                                                   WHEN a.moodsad = 0 THEN
                                                       0
                                                   WHEN a.moodsad IN (1, 2) THEN
                                                       1
                                                   WHEN a.moodsad = 3 THEN
                                                       2
                                                   WHEN a.moodsad = 8 THEN
                                                       0
                                                   ELSE
                                                       0
                                               END)) > 3 THEN
                                          3
                                      ELSE
                                          (  (CASE
                                                  WHEN a.moodinterest = 0 THEN
                                                      0
                                                  WHEN a.moodinterest IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.moodinterest = 3 THEN
                                                      2
                                                  WHEN a.moodinterest = 8 THEN
                                                      0
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.moodanxious = 0 THEN
                                                      0
                                                  WHEN a.moodanxious IN
                                                           (1, 2) THEN
                                                      1
                                                  WHEN a.moodanxious = 3 THEN
                                                      2
                                                  WHEN a.moodanxious = 8 THEN
                                                      0
                                                  ELSE
                                                      0
                                              END)
                                           + (CASE
                                                  WHEN a.moodsad = 0 THEN
                                                      0
                                                  WHEN a.moodsad IN (1, 2) THEN
                                                      1
                                                  WHEN a.moodsad = 3 THEN
                                                      2
                                                  WHEN a.moodsad = 8 THEN
                                                      0
                                                  ELSE
                                                      0
                                              END))
                                  END)
                             WHEN (NVL2(a.negativestatements, 0, 1) + NVL2(a.persistentanger, 0, 1) + NVL2(a.unrealfears, 0, 1) + NVL2(a.healthcomplaints, 0, 1)
                                  + NVL2(a.anxiouscomplaints, 0, 1) + NVL2(a.sadfacial, 0, 1) + NVL2(a.crying, 0, 1)) < 3
                                  AND (NVL(a.moodinterest, 8) <> 8 OR NVL(a.moodanxious, 8) <> 8 OR NVL(a.moodsad, 8) <> 8) THEN
                                    GREATEST(
                                     (CASE
                                          WHEN (  (CASE
                                                       WHEN a.negativestatements =
                                                                0 THEN
                                                           0
                                                       WHEN a.negativestatements IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.negativestatements =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.persistentanger =
                                                                0 THEN
                                                           0
                                                       WHEN a.persistentanger IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.persistentanger =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.unrealfears = 0 THEN
                                                           0
                                                       WHEN a.unrealfears IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.unrealfears = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.healthcomplaints =
                                                                0 THEN
                                                           0
                                                       WHEN a.healthcomplaints IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.healthcomplaints =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.anxiouscomplaints =
                                                                0 THEN
                                                           0
                                                       WHEN a.anxiouscomplaints IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.anxiouscomplaints =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.sadfacial = 0 THEN
                                                           0
                                                       WHEN a.sadfacial IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.sadfacial = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.crying = 0 THEN
                                                           0
                                                       WHEN a.crying IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.crying = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)) > 5 THEN
                                              5
                                          WHEN (  (CASE
                                                       WHEN a.negativestatements =
                                                                0 THEN
                                                           0
                                                       WHEN a.negativestatements IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.negativestatements =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.persistentanger =
                                                                0 THEN
                                                           0
                                                       WHEN a.persistentanger IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.persistentanger =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.unrealfears = 0 THEN
                                                           0
                                                       WHEN a.unrealfears IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.unrealfears = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.healthcomplaints =
                                                                0 THEN
                                                           0
                                                       WHEN a.healthcomplaints IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.healthcomplaints =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.anxiouscomplaints =
                                                                0 THEN
                                                           0
                                                       WHEN a.anxiouscomplaints IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.anxiouscomplaints =
                                                                3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.sadfacial = 0 THEN
                                                           0
                                                       WHEN a.sadfacial IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.sadfacial = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.crying = 0 THEN
                                                           0
                                                       WHEN a.crying IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.crying = 3 THEN
                                                           2
                                                       ELSE
                                                           0
                                                   END)) BETWEEN 0
                                                             AND 5 THEN
                                              (  (CASE
                                                      WHEN a.negativestatements =
                                                               0 THEN
                                                          0
                                                      WHEN a.negativestatements IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.negativestatements =
                                                               3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.persistentanger =
                                                               0 THEN
                                                          0
                                                      WHEN a.persistentanger IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.persistentanger =
                                                               3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.unrealfears = 0 THEN
                                                          0
                                                      WHEN a.unrealfears IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.unrealfears = 3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.healthcomplaints =
                                                               0 THEN
                                                          0
                                                      WHEN a.healthcomplaints IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.healthcomplaints =
                                                               3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.anxiouscomplaints =
                                                               0 THEN
                                                          0
                                                      WHEN a.anxiouscomplaints IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.anxiouscomplaints =
                                                               3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.sadfacial = 0 THEN
                                                          0
                                                      WHEN a.sadfacial IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.sadfacial = 3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.crying = 0 THEN
                                                          0
                                                      WHEN a.crying IN (1, 2) THEN
                                                          1
                                                      WHEN a.crying = 3 THEN
                                                          2
                                                      ELSE
                                                          0
                                                  END))
                                          ELSE
                                              NULL
                                      END),
                                     (CASE
                                          WHEN (  (CASE
                                                       WHEN a.moodinterest =
                                                                0 THEN
                                                           0
                                                       WHEN a.moodinterest IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.moodinterest =
                                                                3 THEN
                                                           2
                                                       WHEN a.moodinterest =
                                                                8 THEN
                                                           0
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.moodanxious = 0 THEN
                                                           0
                                                       WHEN a.moodanxious IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.moodanxious = 3 THEN
                                                           2
                                                       WHEN a.moodanxious = 8 THEN
                                                           0
                                                       ELSE
                                                           0
                                                   END)
                                                + (CASE
                                                       WHEN a.moodsad = 0 THEN
                                                           0
                                                       WHEN a.moodsad IN
                                                                (1, 2) THEN
                                                           1
                                                       WHEN a.moodsad = 3 THEN
                                                           2
                                                       WHEN a.moodsad = 8 THEN
                                                           0
                                                       ELSE
                                                           0
                                                   END)) > 3 THEN
                                              3
                                          ELSE
                                              (  (CASE
                                                      WHEN a.moodinterest = 0 THEN
                                                          0
                                                      WHEN a.moodinterest IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.moodinterest = 3 THEN
                                                          2
                                                      WHEN a.moodinterest = 8 THEN
                                                          0
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.moodanxious = 0 THEN
                                                          0
                                                      WHEN a.moodanxious IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.moodanxious = 3 THEN
                                                          2
                                                      WHEN a.moodanxious = 8 THEN
                                                          0
                                                      ELSE
                                                          0
                                                  END)
                                               + (CASE
                                                      WHEN a.moodsad = 0 THEN
                                                          0
                                                      WHEN a.moodsad IN
                                                               (1, 2) THEN
                                                          1
                                                      WHEN a.moodsad = 3 THEN
                                                          2
                                                      WHEN a.moodsad = 8 THEN
                                                          0
                                                      ELSE
                                                          0
                                                  END))
                                      END))
                             ELSE
                                 NULL
                         END),
                        0) >= 4 THEN
                   1
               ELSE
                   0
           END
               AS mood_bad
    FROM   DW_OWNER.UAS_COMMUNITYHEALTH a
           LEFT JOIN dw_owner.uas_scale b  ON (a.RECORD_ID = b.RECORD_ID AND B.NAME IN ('Age Scale'))
           LEFT JOIN dw_owner.uas_scale b1 ON (a.RECORD_ID = b1.RECORD_ID AND B1.NAME IN ('ADL Hierarchy Scale'))
           LEFT JOIN dw_owner.uas_scale b2 ON (a.RECORD_ID = b2.RECORD_ID AND B2.NAME IN ('Depression Rating Scale'))
           LEFT JOIN dw_owner.uas_scale b3 ON (a.RECORD_ID = b3.RECORD_ID AND b3.name IN ('Pain Scale'))
           LEFT JOIN dw_owner.uas_scale b4 ON (A.RECORD_ID = B4.RECORD_ID AND B4.NAME IN ('Cognitive Performance Scale 2'))
           LEFT JOIN dw_owner.uas_chasupplement c ON (A.RECORD_ID = C.RECORD_ID)
           LEFT JOIN dw_owner.uas_pat_assessments d ON (a.record_id = d.record_id)
           
;
/

drop view V_FACT_QUALITY_RA_RISKFCTR_LONG;

CREATE or replace VIEW V_FACT_QUALITY_RA_RISKFCTR_LONG 
(
    RECORD_ID,
    RISK_FACTOR,
    RISK_FACTOR_VAL
) AS
    WITH datasource AS (SELECT * FROM V_FACT_QUALITY_RA_RISKFCTR)
    SELECT record_id, LOWER(RISK_FACTOR) AS RISK_FACTOR, RISK_FACTOR_VAL
    FROM   datasource UNPIVOT 
            (risk_factor_val FOR RISK_FACTOR IN  
                        ( intercept,
                          age_lte54,
                          age_55_64,
                          age_65_74,
                          age_75_84,
                          age_85,
                          age_missing,
                          badldecline,
                          badlh2,
                          badlh3,
                          badlh4,
                          bbathing,
                          bchf,
                          bconditions,
                          bdecsn,
                          bdeprate,
                          bdiabetes,
                          bdyspnea,
                          bendstage,
                          bfalls,
                          bloco,
                          blocomot,
                          boutside,
                          bpain,
                          bsadness,
                          bstroke,
                          bunstand,
                          bunsteadygait,
                          bwalkass,
                          cogntv_2,
                          copd_2,
                          cvd_2,
                          dizzy_2,
                          gender_2,
                          lifestyle_alcohol_cd,
                          med_manag_2,
                          musculoskeletal_hip_cd,
                          musculoskeletal_othr_fract_cd,
                          nfloc_bad,
                          other_cancer_cd,
                          pain_daily_2,
                          pain_intensity_bad,
                          pialzoth,
                          poorhealth_2,
                          psychiatric_anxiety_cd,
                          psychiatric_bipolar_cd,
                          psychiatric_schizophrenia_cd,
                          sad_2,
                          short_of_breath_bad,
                          urinary_cont_bad,
                          adl_bad,
                          balz,
                          behav_disrpt_2,
                          bothdem,
                          bshortterm,
                          cognition_bad,
                          locomotion_bad,
                          managing_meds_bad,
                          mood_bad
                  )
            )
;
   
/

CREATE MATERIALIZED VIEW FACT_QUALITY_RA_XB 
BUILD IMMEDIATE
REFRESH FORCE
NEXT TRUNC(SYSDATE) + 1     
WITH PRIMARY KEY
AS 
with prev_msr as
(
    select distinct a.subscriber_id, a.uas_record_id1, a.assessment_date1, a.reporting_period_id
            , curr.enrollment_date, curr.qip_month_id, curr.lob_id
            , base.record_id as record_id_ra
            , base.assessmentdate as assessment_date_ra
            , months_between(curr.assessmonth, base.assessmonth) as month_bt_assess
    from CHOICEBI.FACT_QUALITY_MEASURES a
    /*find the "current" assessment*/
    left join (select * from CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS where qip_flag=1) curr on (a.subscriber_id=curr.subscriber_id
                                                                                                        and a.uas_record_id1=curr.record_id
                                                                                                        and a.reporting_period_id=curr.qip_period)
    /*baseline for risk adjustment: attempt to find latest assessment from previous year (previous year, same semi-year period)*/  
    /*e.g. current 201601, baseline 201501*/
    left join (select * from CHOICEBI.MV_QUALITY_MEASURE_ALL_ASSESS where qip_flag=1) base on (curr.subscriber_id=base.subscriber_id
                                                                                                      and curr.enrollment_date=base.enrollment_date
                                                                                                      and curr.record_id<>base.record_id
                                                                                                      and curr.qip_period - base.qip_period = 100      
                                                                                                      )                                                       
    where a.msr_type='PREV'
) 
,ra_uas as
(
    select a.msr_id, a.msr_token, a.reporting_period_id, a.subscriber_id, a.assessment_date1, a.assessment_date2, a.uas_record_id1, a.uas_record_id2
        , case when a.msr_type='PREV' then b.record_id_ra
               when a.msr_type='POT'  then a.uas_record_id1 end as uas_record_id_ra
        , case when a.msr_type='PREV' then b.assessment_date_ra
               when a.msr_type='POT'  then a.assessment_date1 end as assessment_date_ra
        , case when a.msr_type='PREV' then b.month_bt_assess
               when a.msr_type='POT' then months_between(trunc(a.assessment_date2,'MM') , trunc(a.assessment_date1,'MM')) end as month_bt_assess
    from CHOICEBI.FACT_QUALITY_MEASURES a
    left join prev_msr b on (a.subscriber_id=b.subscriber_id 
                            and a.uas_record_id1=b.uas_record_id1
                            and a.reporting_period_id=b.reporting_period_id
                            and a.msr_type='PREV')       
    where b.record_id_ra is not null or a.msr_type='POT'
)
,xb as
(
    --risk factors for instances where UAS_RECORD_ID_RA is defined
    select 
        a.msr_id, a.msr_token, a.reporting_period_id, a.subscriber_id, a.assessment_date1, a.assessment_date2, a.uas_record_id1, a.uas_record_id2, a.uas_record_id_ra
        , x.RISK_FACTOR, x.RISK_FACTOR_VAL
        , b.ra_model_year, b.RISK_FACTOR_BETA_VAL
        , x.RISK_FACTOR_VAL* b.RISK_FACTOR_BETA_VAL as xb
    from ra_uas a
    join V_FACT_QUALITY_RA_RISKFCTR_LONG x on (a.uas_record_id_ra=x.record_id)
    left join DIM_QUALITY_RISKADJ_B b on (a.msr_id=b.msr_id
                                and lower(x.RISK_FACTOR)=lower(B.RISK_FACTOR))
    where b.RISK_FACTOR_BETA_VAL is not null
    union
    --only the MONTH_BT_ASSESS risk factor
    select a.msr_id, a.msr_token, a.reporting_period_id, a.subscriber_id, a.assessment_date1, a.assessment_date2, a.uas_record_id1, a.uas_record_id2, a.uas_record_id_ra 
        , 'MONTH_BT_ASSESS' as RISK_FACTOR, a.month_bt_assess as RISK_FACTOR_VAL
        , b.ra_model_year, b.RISK_FACTOR_BETA_VAL
        , a.month_bt_assess* b.RISK_FACTOR_BETA_VAL as xb
    from ra_uas a
    join V_FACT_QUALITY_RA_RISKFCTR_LONG x on (a.uas_record_id_ra=x.record_id)
    left join DIM_QUALITY_RISKADJ_B b on (a.msr_id=b.msr_id
                                and lower(B.RISK_FACTOR)='month_bt_assess')
    where b.RISK_FACTOR_BETA_VAL is not null
    union
    --risk factors for prevalence measure where there is no prior assessment in past year to use for risk adjustment (set all risk factors to 0 exception for intercept)
    select 
        b.msr_id, b.msr_token, a.reporting_period_id, a.subscriber_id, a.assessment_date1, null as assessment_date2, a.uas_record_id1, null as uas_record_id2, null as uas_record_id_ra 
        , b.RISK_FACTOR, case when lower(b.RISK_FACTOR)='intercept' then 1 else 0 end as factor_val
        , b.ra_model_year, b.RISK_FACTOR_BETA_VAL
        , (case when lower(b.RISK_FACTOR)='intercept' then 1 else 0 end)*b.RISK_FACTOR_BETA_VAL as xb
    from (select * from prev_msr where record_id_ra is null) a 
    ,  DIM_QUALITY_RISKADJ_B b
    where b.RISK_FACTOR_BETA_VAL is not null
    and b.outcome_type = 'Quality - Prevalence'
)
select * from xb 

;
