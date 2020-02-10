
CREATE OR REPLACE FORCE VIEW CHOICEBI.FACT_UAS_PAT_NFLOC_V
(
    MRN,
    MONTH_ID,
    ASSESSMENT_MONTH_ID,
    LEVELOFCARESCORE,
    AVG_LEVELOFCARESCORE,
    ASSESSMENT_DATE,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE
) AS
 SELECT CAST(fm.mrn AS VARCHAR2(32)) AS mrn,
           CAST(fm.month_id AS INTEGER) AS month_id,
           CAST(TO_CHAR(pa.assessmentdate, 'yyyymm') AS VARCHAR2(6 CHAR))
               AS assessment_month_id,
           CAST(levelofcarescore AS VARCHAR2(2 CHAR)) AS levelofcarescore,
           CAST(
               ROUND(AVG(levelofcarescore) OVER (PARTITION BY fm.mrn), 6) AS NUMBER)
               AS avg_levelofcarescore,
           CAST(pa.assessmentdate AS DATE) AS assessment_date,
           CAST(fm.enrollment_date AS DATE) AS enrollment_date,
           CAST(
               MAX(disenrollment_date)
                   OVER (PARTITION BY fm.mrn, enrollment_date) AS DATE)
               AS disenrollment_date
    FROM   mstrstg.fact_member_month fm
           JOIN
           --dw_owner.uas_pat_assessments@nexus2 pa
           dw_owner.uas_pat_assessments pa
               ON                                            --fm.mrn = pa.mrn
                 pa   .MEDICAIDNUMBER1 = Fm.MEDICAID_NUM
                  AND (TO_CHAR(pa.assessmentdate, 'yyyymmdd')||
                       pa.record_id) IN
                          (SELECT MAX(
                                      TO_CHAR(pa2.assessmentdate, 'yyyymmdd')||
                                      pa2.record_id)
                           FROM   dw_owner.uas_pat_assessments pa2
                           WHERE  pa2.MEDICAIDNUMBER1 = fm.MEDICAID_NUM AND TO_CHAR(pa2.assessmentdate, 'yyyymm') <= fm.month_id);
/

DROP VIEW CHOICEBI.FACT_UAS_PAT_NFLOC;

CREATE OR REPLACE FORCE VIEW CHOICEBI.FACT_UAS_PAT_NFLOC
(
    MRN,
    MONTH_ID,
    ASSESSMENT_MONTH_ID,
    LEVELOFCARESCORE,
    AVG_LEVELOFCARESCORE,
    ASSESSMENT_DATE,
    ENROLLMENT_DATE,
    DISENROLLMENT_DATE
) AS
    SELECT /*+ parallel(4) */
          "MRN",
           "MONTH_ID",
           "ASSESSMENT_MONTH_ID",
           "LEVELOFCARESCORE",
           "AVG_LEVELOFCARESCORE",
           "ASSESSMENT_DATE",
           "ENROLLMENT_DATE",
           "DISENROLLMENT_DATE"
    FROM   CHOICEBI.fact_uas_pat_nfloc_v v;

	/