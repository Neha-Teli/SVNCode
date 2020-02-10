DROP VIEW V_UAS_QIP_REASSMENT_INCOMP;

CREATE OR REPLACE VIEW V_UAS_QIP_REASSMENT_INCOMP
 AS
    WITH m AS
             (SELECT   SUBSTR( a.month_id, 1, 4) || '0' || CASE WHEN SUBSTR( a.month_id, 5, 6) BETWEEN 1 AND 6 THEN 1 ELSE 2 END Period, TO_DATE( MIN(month_id), 'yyyymm') AS Period_start_Date, ADD_MONTHS( TO_DATE( MAX(month_id), 'yyyymm'), 1) - 1 AS Period_end_Date
              FROM     choicebi.fact_member_month a
              WHERE    month_id >= 201701
              GROUP BY SUBSTR( a.month_id, 1, 4) || '0' || CASE WHEN SUBSTR( a.month_id, 5, 6) BETWEEN 1 AND 6 THEN 1 ELSE 2 END),
         a AS
             (SELECT   a.member_id,
                       max(a.SUBSCRIBER_ID) SUBSCRIBER_ID,
                       a.dl_lob_id ---, a.DL_MEMBER_SK
                                  ,
                       max(a.DL_ENROLL_ID) DL_ENROLL_ID,
                       max(a.DL_PLAN_SK) DL_PLAN_SK,
                       max(a.PROGRAM) PROGRAM,
                       SUBSTR( a.month_id, 1, 4) || '0' || CASE WHEN SUBSTR( a.month_id, 5, 6) BETWEEN 1 AND 6 THEN 1 ELSE 2 END Period,
                       TO_DATE( MIN(month_id), 'yyyymm') AS Period_start_Date,
                       ADD_MONTHS( TO_DATE( MAX(month_id), 'yyyymm'), 1) - 1 AS Period_end_Date,
                       a.enrollment_date,
                       a.disenrollment_date,
                       m.Period_start_Date AS Period_start_Date2,
                       m.Period_end_Date AS Period_end_Date2
              FROM     choicebi.fact_member_month a LEFT JOIN m m ON (m.period = SUBSTR( a.month_id, 1, 4) || '0' || CASE WHEN SUBSTR( a.month_id, 5, 6) BETWEEN 1 AND 6 THEN 1 ELSE 2 END)
              WHERE    dl_lob_id IN (2, 4, 5) AND program IN ('MLTC', 'FIDA') AND month_id >= 201701
              group by a.member_id
                        , a.dl_lob_id
                        , substr(a.month_id, 1, 4) || '0' || case when substr(a.month_id, 5,6) between 1 and 6 then 1 else 2 end   
                        , a.referral_date
                        , a.enrollment_date
                        , a.disenrollment_date
                        , m.period_start_date
                        , m.period_end_date
        ),
         b AS
             (SELECT a.*,
                     CASE WHEN a.Period_start_Date = a.Period_start_Date2 AND a.Period_end_Date = a.Period_end_Date2 THEN 'Y' ELSE 'N' END AS eligible_ind,
                     b.dl_assess_sk AS dl_assess_sk_prior,
                     b.assessmentdate AS assessmentdate_prior,
                     CASE
                         WHEN b.assessmentdate IS NULL THEN TO_CHAR( period_start_date, 'yyyymm')
                         WHEN ADD_MONTHS( b.assessmentdate, 6) < period_start_date THEN TO_CHAR( period_start_date, 'yyyymm')
                         ELSE TO_CHAR( ADD_MONTHS( b.assessmentdate, 6), 'yyyymm')
                     END
                         AS DUE_MONTH,
                     ROW_NUMBER() OVER (PARTITION BY a.member_id, a.period ORDER BY b.assessmentdate DESC, b.dl_assess_sk DESC) AS assess_seq
              FROM   a a LEFT JOIN choice.dim_member_assessments@DLAKE b ON (a.member_id = b.member_id AND b.assessmentdate < a.Period_start_date)),
         c AS
             (SELECT b.*,
                     c.dl_assess_sk AS dl_assess_sk_mr,
                     c.assessmentdate AS assessmentdate_mr,
                     ROW_NUMBER() OVER (PARTITION BY b.member_id, b.period ORDER BY c.assessmentdate, c.dl_assess_sk DESC) AS assess_seq2
              FROM   b b LEFT JOIN choice.dim_member_assessments@DLAKE c ON (b.member_id = c.member_id AND c.assessmentdate BETWEEN b.period_start_date AND b.period_end_date)
              WHERE  assess_seq = 1),
         QIP_REASSESSMENT AS
             (SELECT C.SUBSCRIBER_ID,
                     C.MEMBER_ID,
                     C.DL_LOB_ID --, C.DL_MEMBER_SK
                                ,
                     C.DL_ENROLL_ID,
                     C.DL_PLAN_SK,
                     C.PROGRAM,
                     C.PERIOD,
                     C.PERIOD_START_DATE,
                     C.PERIOD_END_DATE,
                     C.ENROLLMENT_DATE,
                     C.DISENROLLMENT_DATE,
                     c.DL_ASSESS_SK_MR,
                     ELIGIBLE_IND,
                     ASSESSMENTDATE_PRIOR,
                     DUE_MONTH,
                     CASE WHEN SUBSTR( PERIOD, 6, 6) = 1 THEN SUBSTR( DUE_MONTH, 5, 6) + 0 ELSE SUBSTR( DUE_MONTH, 5, 6) - 6 END AS DUE_MONTH_OF_HALF,
                     ASSESSMENTDATE_MR,
                     CASE WHEN TO_CHAR( C.ASSESSMENTDATE_MR, 'yyyymm') <= DUE_MONTH THEN '1- timely' WHEN C.ASSESSMENTDATE_MR IS NOT NULL THEN '2- late' ELSE '3- not done' END AS ASSESSMENT_STATUS,
                     CASE WHEN DUE_MONTH >= TO_CHAR( SYSDATE, 'yyyymm') THEN 0 ELSE 1 END AS COMPLETE_MONTH_IND,
                     CASE WHEN C.PERIOD = SUBSTR( TO_CHAR( SYSDATE, 'yyyymm'), 1, 4) || '0' || CASE WHEN SUBSTR( TO_CHAR( SYSDATE, 'yyyymm'), 5, 6) BETWEEN 1 AND 6 THEN 1 ELSE 2 END THEN 1 ELSE 0 END
                         CURRENT_PERIOD_IND
              FROM   c
              WHERE  assess_seq2 = 1
         ),
         QIP AS
             (SELECT A.*,
                     B.MSR_ID,
                     B.MSR_TOKEN,
                     DECODE(ASSESSMENT_STATUS, '3- not done', 1, 0) NUMERATOR,
                     1 DENOMINATOR
              FROM   QIP_REASSESSMENT A, choicebi.DIM_QUALITY_MEASURES@odsdev B
              WHERE  (B.MSR_ID = 76) --notdone
              UNION ALL
              SELECT A.*,
                     B.MSR_ID,
                     B.MSR_TOKEN,
                     DECODE(ASSESSMENT_STATUS, '2- late', 1, 0) NUMERATOR,
                     1 DENOMINATOR
              FROM   QIP_REASSESSMENT A, choicebi.DIM_QUALITY_MEASURES@odsdev B
              WHERE  (B.MSR_ID = 77) -- late
              UNION ALL
              SELECT A.*,
                     B.MSR_ID,
                     B.MSR_TOKEN,
                     DECODE(ASSESSMENT_STATUS, '1- timely', 1, 0) NUMERATOR,
                     1 DENOMINATOR
              FROM   QIP_REASSESSMENT A, choicebi.DIM_QUALITY_MEASURES@odsdev B
              WHERE  (B.MSR_ID = 78) --timely
                                    )
    --select * from  qip where member_id = 6 and period = '201701'
    SELECT 'PREV' MSR_TYPE,
           MSR_ID,
           MSR_TOKEN,
           DUE_MONTH MONTH_ID,
           PERIOD REPORTING_PERIOD_ID,
           SUBSCRIBER_ID,
           NULL DL_MEMBER_SK,
           MEMBER_ID,
           DL_LOB_ID DL_LOB_GRP_ID,
           DL_LOB_ID,
           DL_ENROLL_ID,
           DL_PLAN_SK,
           ASSESSMENTDATE_MR ASSESSMENT_DATE1,
           ASSESSMENTDATE_PRIOR ASSESSMENT_DATE2,
           NULL ASSESSMENT_REASON1,
           NULL ASSESSMENT_REASON2,
           DL_ASSESS_SK_MR UAS_RECORD_ID1,
           NULL UAS_RECORD_ID2,
           NULL ASSESSMENT_MONTH,
           NULL NEXT_DUE,
           NULL NEXT_DUE_PERIOD,
           NULL VENDOR_ID,
           NULL ONURSEORGNAME,
           NULL ONURSENAME,
           NULL RISK,
           NULL RISK_NOTE,
           NULL SEQ,
           PROGRAM,
           NULL ONURSECOMPANY,
           NUMERATOR,
           DENOMINATOR,
           1 STATE_MSR_ELIG_FLAG
           ,ELIGIBLE_IND
    --FROM QIP
    FROM   QIP
    where ELIGIBLE_IND='Y'


GRANT SELECT ON V_UAS_QIP_REASSMENT_INCOMP TO ROC_RO;
