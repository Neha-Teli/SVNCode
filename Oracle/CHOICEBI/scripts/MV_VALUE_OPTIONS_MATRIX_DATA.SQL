insert into  MV_VALUE_OPTIONS_MATRIX_DATA
WITH VA_01 AS
         (SELECT                                            /*  materialize */
                CLAIMNO,
                 CLMREV,
                 LINENO,
                 BILCOD,
                 POSCOD,
                 MEMLST,
                 MEMFST,
                 SUBSTR(membno, 1, 9) SUBSCRIBER_ID,
                 HOSBEG,
                 HOSEND,
                 SVCDAT,
                 ENDDAT,
                 MXBDAT,
                 MXEDAT,
                 DIAGN1,
                 DIAGN2,
                 DIAGN3,
                 DIAGN4,
                 DIAGX1,
                 DIAGX2,
                 DIAGX3,
                 DIAGX4,
                 TYPCOD,
                 SVCCOD,
                 BTHDAT,
                 PAYCOD,
                 PATSTA,
                 DISTAT,
                 ALWUNT,
                 ALWAMT,
                 PADAMT,
                 TOTPAD,
                 PROVNO,
                 SVCVND,
                 SUBSTR(LINENO, 1, 3) ClaimLineNo,
                 PIDATE,
                 BENCOD,
                 ORIGPD,
                 orglin,
                 TO_NUMBER(TO_CHAR(svcdat, 'YYYYMM')) month_id
          FROM   VNS_CHOICE1.Value_options a
          WHERE      1 = 1
                 AND CLMREV != 'Y'
          UNION ALL
          SELECT                                             /* materialize */
                CLAIMNO,
                 CLMREV,
                 LINENO,
                 BILCOD,
                 POSCOD,
                 MEMLST,
                 MEMFST,
                 SUBSTR(membno, 1, 9) SUBSCRIBER_ID,
                 HOSBEG,
                 HOSEND,
                 SVCDAT,
                 ENDDAT,
                 MXBDAT,
                 MXEDAT,
                 DIAGN1,
                 DIAGN2,
                 DIAGN3,
                 DIAGN4,
                 DIAGX1,
                 DIAGX2,
                 DIAGX3,
                 DIAGX4,
                 TYPCOD,
                 SVCCOD,
                 BTHDAT,
                 PAYCOD,
                 PATSTA,
                 DISTAT,
                 ALWUNT,
                 ALWAMT,
                 PADAMT,
                 TOTPAD,
                 PROVNO,
                 SVCVND,
                 SUBSTR(LINENO, 1, 3) ClaimLineNo,
                 PIDATE,
                 BENCOD,
                 ORIGPD,
                 orglin,
                 TO_NUMBER(TO_CHAR(svcdat, 'YYYYMM')) month_id
          FROM   VNS_CHOICE1.Value_options_sh a
          WHERE  1 = 1
          UNION ALL
          SELECT                                             /* materialize */
                CLAIMNO,
                 CLMREV,
                 LINENO,
                 BILCOD,
                 POSCOD,
                 MEMLST,
                 MEMFST,
                 SUBSTR(membno, 1, 9) SUBSCRIBER_ID,
                 HOSBEG,
                 HOSEND,
                 SVCDAT,
                 ENDDAT,
                 MXBDAT,
                 MXEDAT,
                 DIAGN1,
                 DIAGN2,
                 DIAGN3,
                 DIAGN4,
                 DIAGX1,
                 DIAGX2,
                 DIAGX3,
                 DIAGX4,
                 TYPCOD,
                 SVCCOD,
                 BTHDAT,
                 PAYCOD,
                 PATSTA,
                 DISTAT,
                 ALWUNT,
                 ALWAMT,
                 PADAMT,
                 TOTPAD,
                 PROVNO,
                 SVCVND,
                 SUBSTR(LINENO, 1, 3) ClaimLineNo,
                 PIDATE,
                 BENCOD,
                 ORIGPD,
                 orglin,
                 TO_NUMBER(TO_CHAR(svcdat, 'YYYYMM')) month_id
          FROM   VNS_CHOICE1.Value_options_FIDA a
          WHERE  1 = 1),
     va_01a_REV AS
         (SELECT                                             /* materialize */
                *
          FROM   va_01
          WHERE  CLMREV = 'Y'),
     VA_01ca AS
         (SELECT /*+ materialize */
                DISTINCT
                 a.claimno,
                 a.svcdat,
                 a.enddat,
                 RANK()
                 OVER (PARTITION BY a.claimno
                       ORDER BY a.claimno, a.svcdat, a.enddat DESC)
                     seq
          FROM   Va_01 a JOIN va_01a_rev b ON a.claimno = b.claimno),
     VA_01c AS
         (SELECT /*+ materialize */
                *
          FROM   va_01ca
          WHERE  seq = 1),
     VA_01D AS
         (SELECT A.*
          FROM   VA_01 A
          WHERE  a.claimno NOT IN (SELECT DISTINCT claimno FROM VA_01C)),
     VA_02 AS
         (SELECT /*+ materialize */
                month_id,
                 SUBSCRIBER_ID,
                 SUBSCRIBER_ID memberid,
                 TRIM(Claimno) ClaimNumber,
                 ClaimLineNo ClaimLineNumber,
                 --'' AdjustmentSequenceNumber,
                 --'' ProductID,
                 PROVNO ||
                 svcvnd
                     ProviderId,
                 'VO' SourceID,
                 DECODE(BILCOD,
                        NULL, NULL,
                        '0' ||
                        BILCOD)
                     TypeBillCode,
                 POSCOD PlaceOfServiceCode,
                 DECODE(SUBSTR(BILCOD, 1, 2),
                        '11', 'I',
                        '12', 'I',
                        '21', 'I',
                        '71', 'I',
                        '81', 'I',
                        NULL)
                     ClaimTypeCode,
                 --'' DRGVersion,
                 --'' DRGCode,
                 'PATSTA' DischargeStatus,
                 CASE
                     WHEN BILCOD IS NOT NULL THEN 'F'
                     WHEN POSCOD = '81' THEN 'L'
                     ELSE 'M'
                 END
                     MedicalCLass,
                 DECODE(PAYCOD, 'P', 'N', 'Y') Denied,
                 --'' EpisodeOfIllness,
                 CASE
                     WHEN SUBSTR(BILCOD, 1, 2) IN
                              ('11', '12', '21', '71', '81') THEN
                         HOSBEG
                     ELSE
                         NULL
                 END
                     AdmitDate,
                 CASE
                     WHEN SUBSTR(BILCOD, 1, 2) IN
                              ('11', '12', '21', '71', '81') THEN
                         HOSEND
                     ELSE
                         NULL
                 END
                     DischargeDate,
                 CASE
                     WHEN SUBSTR(BILCOD, 1, 2) IN
                              ('11', '12', '21', '71', '81') THEN
                         'Inpatient'
                     ELSE
                         'Outpatient'
                 END
                     TypeofVisit,
                 SVCDAT FirstServiceDate,
                 ENDDAT LastServiceDate,
                 MXBDAT ClaimFromDate,
                 MXEDAT ClaimThroughDate,
                 PIDATE ClaimProcessedDate,
                 DIAGN1 PrimaryDiagnosis,
                 DIAGN2 SecondaryDiagnosis1,
                 DIAGN3 SecondaryDiagnosis2,
                 DIAGN4 SecondaryDiagnosis3,
                 DIAGX1 SecondaryDiagnosis4,
                 DIAGX2 SecondaryDiagnosis5,
                 DIAGX3 SecondaryDiagnosis6,
                 DIAGX4 SecondaryDiagnosis7,
                 CASE WHEN TYPCOD IN ('CP', 'HC') THEN SVCCOD ELSE NULL END
                     CPT,
                 DECODE(TYPCOD, 'RC', SVCCOD, NULL) revenuecode,
                 ALWUNT Units,
                 padamt,
                 RANK()
                 OVER (PARTITION BY TRIM(Claimno), ClaimLineNo, SUBSCRIBER_ID
                       ORDER BY TRIM(Claimno), ClaimLineNo, SUBSCRIBER_ID)
                     seq
          FROM   VA_01D
          WHERE  ENDDAT >= '01Jan2014'),
     VO_Final AS
         (SELECT LOB_ID,
                 LINE_OF_BUSINESS,
                 PRODUCT_ID,
                 --VNS_PLAN_DESC,
                 PROGRAM,
                 A.*
          FROM   (SELECT *
                  FROM   VA_02
                  WHERE  seq = 1) A
                 JOIN (SELECT A.LOB_ID,
                              A.PROGRAM,
                              A.LINE_OF_BUSINESS,
                              A.MONTH_ID,
                              a.PRODUCT_ID PRODUCT_ID,
                              --PRODUCT_NAME VNS_PLAN_DESC,
                              subscriber_id
                       FROM   fact_member_month A
                       --                         JOIN MSTRSTG.D_VNS_LOB_PRODUCT_MAPPING C ON     A.LOB_ID = C.DL_LOB_ID AND NVL(A.PROGRAM, C.PLAN_PACKAGE) = C.PLAN_PACKAGE
                       WHERE  LINE_OF_BUSINESS IN ('MA', 'FIDA', 'SH')) b
                     ON     a.SUBSCRIBER_ID = b.subscriber_id
                        AND a.month_id = b.month_id)
SELECT *
FROM   vo_final