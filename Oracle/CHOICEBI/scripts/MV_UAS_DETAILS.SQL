INSERT INTO MV_UAS_DETAILS
SELECT /*+ driving_site(A) */A.RECORD_ID
                , C.GENDER
                , TO_NUMBER(C.LEVELOFCARESCORE) AS LEVELOFCARESCORE
                , A.ASSESSMENTTYPE, A.ASSESSMENTREASON, A.RESIDENCEASSESSMENT
                , A.LIVINGARRANGEMENT
                , A.COGNITIVESKILLS, A.MEMORYRECALLSHORT, A.MEMORYRECALLPROCEDURAL, A.IMPAIREDDECISION
                , A.SELFUNDERSTOOD, A.UNDERSTANDOTHERS, A.HEARING, A.VISION
                , A.NEGATIVESTATEMENTS, A.PERSISTENTANGER, A.UNREALFEARS, A.HEALTHCOMPLAINTS, A.ANXIOUSCOMPLAINTS
                , A.SADFACIAL, A.CRYING, A.WITHDRAWAL, A.REDUCEDSOCIAL
                , A.BEHAVIORWANDERING, A.BEHAVIORVERBAL, A.BEHAVIORPHYSICAL, A.BEHAVIORDISRUPTIVE
                , A.BEHAVIORSEXUAL, A.BEHAVIORRESISTS, A.MOODINTEREST, A.MOODANXIOUS, A.MOODSAD
                , A.SOCIALPARTICIPATION, A.SOCIALVISIT, A.SOCIALOTHERINTERACTION, A.SOCIALEXPRESSANGER, A.SOCIALFEARFUL
                , A.SOCIALNEGLECTED, A.LONELY, A.TIMEALONE, A.SOCIALCHANGEACTIVITIES, A.LIFESTRESSORS
                , A.IADLPERFORMANCEMEALS, A.IADLPERFORMANCEHOUSEWORK, A.IADLPERFORMANCEFINANCES, A.IADLPERFORMANCEMEDS
                , A.IADLPERFORMANCEPHONE, A.IADLPERFORMANCESTAIRS, A.IADLPERFORMANCESHOPPING, A.IADLPERFORMANCETRANSPORT, A.IADLPERFORMANCEEQUIP
                , A.IADLCAPACITYMEALS, A.IADLCAPACITYHOUSEWORK, A.IADLCAPACITYFINANCES, A.IADLCAPACITYMEDS
                , A.IADLCAPACITYPHONE, A.IADLCAPACITYSTAIRS, A.IADLCAPACITYSHOPPING, A.IADLCAPACITYTRANSPORT, A.IADLCAPACITYEQUIP 
                , A.ADLBATHING, A.ADLHYGIENE, A.ADLDRESSUPPER, A.ADLDRESSLOWER, A.ADLLOCOMOTION, A.ADLTOILETTRANSFER, A.ADLTOILETUSE
                , A.ADLBED, A.ADLEATING
                , A.LOCOMOTIONINDOORS, A.HOURSEXERCISE, A.DAYSOUTDOORS, A.ADLSTATUS, A.ADLSTATUSSELFSUFF
                , A.DRIVINGDROVECAR, A.DRIVINGLIMITSTOP, A.IADLTRANSPORTATION
                , A.BLADDERCONTINENCE, A.BOWELCONTINENCE
                , A.MUSCULOSKELETALHIP, A.MUSCULOSKELETALOTHERFRACTURE, A.NEUROLOGICALALZHEIMERS, A.NEUROLOGICALDEMENTIA, A.NEUROLOGICALSTROKE
                , A.CARDIACHEARTDISEASE, A.CARDIACPULMONARY, A.CARDIACFAILURE
                , A.PSYCHIATRICANXIETY, A.PSYCHIATRICBIPOLAR, A.PSYCHIATRICSCHIZOPHRENIA, A.OTHERCANCER, A.OTHERDIABETES
                , A.FALLS, A.RECENTFALLS, A.FALLSMEDICAL, A.PROBLEMDIZZINESS, A.PROBLEMUNSTEADYGAIT, A.PROBLEMCHESTPAIN, A.PROBLEMABNORMALTHOUGHT
                , A.PROBLEMDELUSIONS, A.PROBLEMHALLUCINATIONS, A.PROBLEMACIDREFLUX, A.PROBLEMDIARRHEA, A.PROBLEMVOMITING
                , A.PROBLEMDIFFICULTSLEEP, A.PROBLEMEXCESSSLEEP
                , A.DYSPNEA, A.FATIGUE, A.PAINFREQUENCY, A.PAININTENSITY, A.PAINCONSISTENCY, A.PAINBREAKTHROUGH, A.PAINCONTROL
                , A.INSTABILITYPATTERNS, A.INSTABILITYACUTE, A.SELFRATEDHEALTH
                , A.LIFESTYLESMOKES, A.LIFESTYLESMOKESSAFELY, A.LIFESTYLECHEWSTOBACCO, A.LIFESTYLEALCOHOL
                , A.LIFESTYLESUBSTANCE, A.LIFESTYLESUBCRITICISM, A.LIFESTYLESUBGUILT, A.LIFESTYLESUBMORNING, A.LIFESTYLESUBSOCIAL
                , A.WEIGHTLOSS, A.DEHYDRATED, A.FLUIDINTAKE, A.FLUIDOUTPUT, A.NUTRITIONALINTAKE
                , A.MEDSREQUIREDMEDS, A.DRUGALLERGY
                , A.TXBLOODPRESSURE, A.TXCOLONOSCOPY, A.TXDENTAL, A.TXEYE, A.TXHEARING, A.TXINFLUENZA, A.TXMAMMOGRAM, A.TXPNEUMOVAX
                , A.TXINPATIENT, A.TXEMERGENCY, A.TXPHYSICIAN, A.TXNURSING
                , A.CLINICIMPROPER, A.CLINICINJURY, A.CLINICRESPIRATORY, A.CLINICWOUND, A.CLINICHYPO, A.CLINICGI, A.CLINICEXACERBATION
                , A.CLINICMYOCARDIAL, A.CLINICCHEMOTHERAPY, A.CLINICSCHEDULED, A.CLINICURINARY, A.CLINICIV
                , A.CLINICTHROMBOSIS, A.CLINICUNCONTROLLEDPAIN, A.CLINICPSYCHOTIC, A.CLINICOTHER, A.CLINICUNKNOWN
                , A.ERIMPROPER, A.ERNAUSEA, A.ERINJURY, A.ERRESPIRATORY, A.ERWOUND, A.ERCARDIAC, A.ERHYPO, A.EROTHER, A.ERUNKNOWN, A.ERGI
                , A.NHTHERAPY, A.NHRESPITE, A.NHENDOFLIFE, A.NHPLACEMENT, A.NHUNSAFE, A.NHOTHER, A.NHUNKNOWN
                , A.FAMILYRELATIONSHIP, A.FINANCES 
                , B.FUNCTIONALDATE, B.INSTABILITYENDSTAGE /*this is from functional supplement*/
                , CPS.VALUE AS CPS_SCALE
                , CPS2.VALUE AS CPS2_SCALE
                , DRS.VALUE AS DEPR_SCALE
                , ADLHS.VALUE AS ADL_SCALE
                , AGE.VALUE AS AGE
                /*exclude if missing 3 or more of assessed mood variables or missing all 10 of assessed and self-reported mood variables*/
                , (CASE WHEN  (
                                (CASE WHEN NEGATIVESTATEMENTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN PERSISTENTANGER IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN UNREALFEARS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN HEALTHCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN ANXIOUSCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN SADFACIAL IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN CRYING IS NULL THEN 1 ELSE 0 END)
                              ) >=3 
                    OR
                        (NEGATIVESTATEMENTS IS NULL 
                            AND PERSISTENTANGER IS NULL 
                            AND UNREALFEARS IS NULL 
                            AND HEALTHCOMPLAINTS IS NULL 
                            AND ANXIOUSCOMPLAINTS IS NULL 
                            AND SADFACIAL IS NULL 
                            AND CRYING IS NULL 
                            AND (MOODINTEREST IS NULL OR MOODINTEREST=8) 
                            AND (MOODANXIOUS IS NULL OR MOODANXIOUS=8) 
                            AND (MOODSAD IS NULL OR MOODSAD=8)
                        ) 
                    THEN 1 ELSE 0 END) AS EXCLUDE_MOOD
                , (CASE WHEN 
                            (
                                (CASE WHEN NEGATIVESTATEMENTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN PERSISTENTANGER IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN UNREALFEARS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN HEALTHCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN ANXIOUSCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN SADFACIAL IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN CRYING IS NULL THEN 1 ELSE 0 END)
                            ) < 3 
                            AND (MOODINTEREST IS NULL OR MOODINTEREST=8) 
                            AND (MOODANXIOUS IS NULL OR MOODANXIOUS=8) 
                            AND (MOODSAD IS NULL OR MOODSAD=8)
                            THEN 
                                (CASE WHEN (
                                            (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                    WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                    WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                    WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                    WHEN PERSISTENTANGER =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                    WHEN UNREALFEARS IN (1,2) THEN 1
                                                    WHEN UNREALFEARS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                    WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                    WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                    WHEN SADFACIAL IN (1,2) THEN 1
                                                    WHEN SADFACIAL =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN CRYING=0 THEN 0 
                                                    WHEN CRYING IN (1,2) THEN 1
                                                    WHEN CRYING =3 THEN 2 
                                                    ELSE 0 END)
                                        ) > 5 THEN 5 
                                    WHEN (
                                            (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                    WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                    WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                    WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                    WHEN PERSISTENTANGER =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                    WHEN UNREALFEARS IN (1,2) THEN 1
                                                    WHEN UNREALFEARS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                    WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                    WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                    WHEN SADFACIAL IN (1,2) THEN 1
                                                    WHEN SADFACIAL =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN CRYING=0 THEN 0 
                                                    WHEN CRYING IN (1,2) THEN 1
                                                    WHEN CRYING =3 THEN 2 
                                                    ELSE 0 END)
                                        ) BETWEEN 0 AND 5 
                                    THEN (
                                            (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                    WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                    WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                    WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                    WHEN PERSISTENTANGER =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                    WHEN UNREALFEARS IN (1,2) THEN 1
                                                    WHEN UNREALFEARS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                    WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                    ELSE 0 END)
                                            +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                    WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                    WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                    WHEN SADFACIAL IN (1,2) THEN 1
                                                    WHEN SADFACIAL =3 THEN 2 
                                                    ELSE 0 END)
                                            +(CASE     WHEN CRYING=0 THEN 0 
                                                    WHEN CRYING IN (1,2) THEN 1
                                                    WHEN CRYING =3 THEN 2 
                                                    ELSE 0 END)
                                        ) 
                                ELSE NULL END)
                        WHEN 
                            (
                                (CASE WHEN NEGATIVESTATEMENTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN PERSISTENTANGER IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN UNREALFEARS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN HEALTHCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN ANXIOUSCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN SADFACIAL IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN CRYING IS NULL THEN 1 ELSE 0 END)
                            ) >= 3  
                            AND (MOODINTEREST IS NOT NULL OR MOODINTEREST<>8 
                                OR MOODANXIOUS IS NOT NULL OR MOODANXIOUS<>8 
                                OR MOODSAD IS NOT NULL OR MOODSAD<>8) 
                            THEN 
                                (CASE WHEN (
                                        (CASE     WHEN MOODINTEREST=0 THEN 0
                                                WHEN MOODINTEREST IN (1,2) THEN 1
                                                WHEN MOODINTEREST =3 THEN 2
                                                WHEN MOODINTEREST=8 THEN 0 
                                                ELSE 0 END)
                                        +(CASE     WHEN MOODANXIOUS=0 THEN 0
                                                WHEN MOODANXIOUS IN (1,2) THEN 1
                                                WHEN MOODANXIOUS =3 THEN 2
                                                WHEN MOODANXIOUS=8 THEN 0 
                                                ELSE 0 END) 
                                        +(CASE     WHEN MOODSAD=0 THEN 0
                                                WHEN MOODSAD IN (1,2) THEN 1
                                                WHEN MOODSAD =3 THEN 2
                                                WHEN MOODSAD=8 THEN 0 
                                                ELSE 0 END) 
                                    )>3 THEN 3
                                ELSE (
                                        (CASE     WHEN MOODINTEREST=0 THEN 0
                                                WHEN MOODINTEREST IN (1,2) THEN 1
                                                WHEN MOODINTEREST =3 THEN 2
                                                WHEN MOODINTEREST=8 THEN 0 
                                                ELSE 0 END) 
                                        +(CASE     WHEN MOODANXIOUS=0 THEN 0
                                                WHEN MOODANXIOUS IN (1,2) THEN 1
                                                WHEN MOODANXIOUS =3 THEN 2
                                                WHEN MOODANXIOUS=8 THEN 0 
                                                ELSE 0 END) 
                                        +(CASE     WHEN MOODSAD=0 THEN 0
                                                WHEN MOODSAD IN (1,2) THEN 1
                                                WHEN MOODSAD =3 THEN 2
                                                WHEN MOODSAD=8 THEN 0 
                                                ELSE 0 END)
                                        )
                            END) 
                        WHEN 
                            (
                                (CASE WHEN NEGATIVESTATEMENTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN PERSISTENTANGER IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN UNREALFEARS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN HEALTHCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN ANXIOUSCOMPLAINTS IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN SADFACIAL IS NULL THEN 1 ELSE 0 END)
                                +(CASE WHEN CRYING IS NULL THEN 1 ELSE 0 END)
                            ) < 3 
                            AND (MOODINTEREST IS NOT NULL OR MOODINTEREST<>8 
                                OR MOODANXIOUS IS NOT NULL OR MOODANXIOUS<>8 
                                OR MOODSAD IS NOT NULL OR MOODSAD<>8) 
                            THEN 
                            GREATEST( 
                                        (CASE WHEN (
                                                    (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                            WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                            WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                            WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                            WHEN PERSISTENTANGER =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                            WHEN UNREALFEARS IN (1,2) THEN 1
                                                            WHEN UNREALFEARS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                            WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                            WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                            WHEN SADFACIAL IN (1,2) THEN 1
                                                            WHEN SADFACIAL =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN CRYING=0 THEN 0 
                                                            WHEN CRYING IN (1,2) THEN 1
                                                            WHEN CRYING =3 THEN 2 
                                                            ELSE 0 END)
                                                ) > 5 THEN 5 
                                            WHEN (
                                                    (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                            WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                            WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                            WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                            WHEN PERSISTENTANGER =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                            WHEN UNREALFEARS IN (1,2) THEN 1
                                                            WHEN UNREALFEARS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                            WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                            WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                            WHEN SADFACIAL IN (1,2) THEN 1
                                                            WHEN SADFACIAL =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN CRYING=0 THEN 0 
                                                            WHEN CRYING IN (1,2) THEN 1
                                                            WHEN CRYING =3 THEN 2 
                                                            ELSE 0 END)
                                                ) BETWEEN 0 AND 5 
                                            THEN (
                                                    (CASE     WHEN NEGATIVESTATEMENTS=0 THEN 0
                                                            WHEN NEGATIVESTATEMENTS IN (1,2) THEN 1
                                                            WHEN NEGATIVESTATEMENTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN PERSISTENTANGER=0 THEN 0 
                                                            WHEN PERSISTENTANGER IN (1,2) THEN 1
                                                            WHEN PERSISTENTANGER =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN UNREALFEARS=0 THEN 0 
                                                            WHEN UNREALFEARS IN (1,2) THEN 1
                                                            WHEN UNREALFEARS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN HEALTHCOMPLAINTS=0 THEN 0 
                                                            WHEN HEALTHCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN HEALTHCOMPLAINTS =3 THEN 2
                                                            ELSE 0 END)
                                                    +(CASE     WHEN ANXIOUSCOMPLAINTS=0 THEN 0 
                                                            WHEN ANXIOUSCOMPLAINTS IN (1,2) THEN 1
                                                            WHEN ANXIOUSCOMPLAINTS =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN SADFACIAL=0 THEN 0 
                                                            WHEN SADFACIAL IN (1,2) THEN 1
                                                            WHEN SADFACIAL =3 THEN 2 
                                                            ELSE 0 END)
                                                    +(CASE     WHEN CRYING=0 THEN 0 
                                                            WHEN CRYING IN (1,2) THEN 1
                                                            WHEN CRYING =3 THEN 2 
                                                            ELSE 0 END)
                                                ) 
                                        ELSE NULL END)
                                    , 
                                        (CASE WHEN (
                                                (CASE     WHEN MOODINTEREST=0 THEN 0
                                                        WHEN MOODINTEREST IN (1,2) THEN 1
                                                        WHEN MOODINTEREST =3 THEN 2
                                                        WHEN MOODINTEREST=8 THEN 0 
                                                        ELSE 0 END)
                                                +(CASE     WHEN MOODANXIOUS=0 THEN 0
                                                        WHEN MOODANXIOUS IN (1,2) THEN 1
                                                        WHEN MOODANXIOUS =3 THEN 2
                                                        WHEN MOODANXIOUS=8 THEN 0 
                                                        ELSE 0 END) 
                                                +(CASE     WHEN MOODSAD=0 THEN 0
                                                        WHEN MOODSAD IN (1,2) THEN 1
                                                        WHEN MOODSAD =3 THEN 2
                                                        WHEN MOODSAD=8 THEN 0 
                                                        ELSE 0 END) 
                                            )>3 THEN 3
                                        ELSE (
                                                (CASE     WHEN MOODINTEREST=0 THEN 0
                                                        WHEN MOODINTEREST IN (1,2) THEN 1
                                                        WHEN MOODINTEREST =3 THEN 2
                                                        WHEN MOODINTEREST=8 THEN 0 
                                                        ELSE 0 END) 
                                                +(CASE     WHEN MOODANXIOUS=0 THEN 0
                                                        WHEN MOODANXIOUS IN (1,2) THEN 1
                                                        WHEN MOODANXIOUS =3 THEN 2
                                                        WHEN MOODANXIOUS=8 THEN 0 
                                                        ELSE 0 END) 
                                                +(CASE     WHEN MOODSAD=0 THEN 0
                                                        WHEN MOODSAD IN (1,2) THEN 1
                                                        WHEN MOODSAD =3 THEN 2
                                                        WHEN MOODSAD=8 THEN 0 
                                                        ELSE 0 END)
                                                )
                                    END) 
                                )
                        ELSE NULL END) AS MOODSCALE 
        FROM DW_OWNER.UAS_COMMUNITYHEALTH A
        LEFT JOIN DW_OWNER.UAS_CHASUPPLEMENT B ON(A.RECORD_ID=B.RECORD_ID)
        LEFT JOIN DW_OWNER.UAS_PAT_ASSESSMENTS C ON (A.RECORD_ID=C.RECORD_ID) 
        LEFT JOIN DW_OWNER.UAS_SCALE CPS ON (A.RECORD_ID=CPS.RECORD_ID AND TRIM(CPS.NAME)='Cognitive Performance Scale')
        LEFT JOIN DW_OWNER.UAS_SCALE CPS2 ON (A.RECORD_ID=CPS2.RECORD_ID AND TRIM(CPS2.NAME)='Cognitive Performance Scale 2')
        LEFT JOIN DW_OWNER.UAS_SCALE DRS ON (A.RECORD_ID=DRS.RECORD_ID AND TRIM(DRS.NAME)='Depression Rating Scale')
        LEFT JOIN DW_OWNER.UAS_SCALE ADLHS ON (A.RECORD_ID=ADLHS.RECORD_ID AND TRIM(ADLHS.NAME)='ADL Hierarchy Scale')
        LEFT JOIN DW_OWNER.UAS_SCALE AGE ON (A.RECORD_ID=AGE.RECORD_ID AND TRIM(AGE.NAME)='Age Scale')
        WHERE A.RECORD_ID IS NOT NULL
        AND A.MEDICAIDNUMBER1 IS NOT NULL