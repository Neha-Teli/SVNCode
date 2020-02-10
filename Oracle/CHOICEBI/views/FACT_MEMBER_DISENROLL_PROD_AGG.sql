DROP VIEW FACT_MEMBER_DISENROLL_PROD_AGG;

CREATE OR REPLACE VIEW FACT_MEMBER_DISENROLL_PROD_AGG
AS
    (SELECT   a.DL_LOB_ID DL_LOB_ID_CEDL,
              CASE WHEN c.PROGRAM = 'MA' THEN 1 WHEN c.PROGRAM = 'MLTC' THEN 2 WHEN c.PROGRAM = 'SH' THEN 3 WHEN c.PROGRAM = 'FIDA' THEN 4 ELSE 0 END DL_LOB_ID,
              a.DL_PLAN_SK,
              a.MEMBER_ID,
              a.SUBSCRIBER_ID,
              a.PRODUCT_ID,
              a.PRODUCT_NAME,
              MIN(a.ENROLLMENT_END_DT) DISENROLLMENT_DATE,
              TO_NUMBER(TO_CHAR( a.ENROLLMENT_END_DT, 'YYYYMM')) DISENROLLMENT_MONTH_ID,
              LAST_DAY(a.ENROLLMENT_END_DT) + 1 EFFECT_DISENROLL_DATE,
              TO_NUMBER(TO_CHAR( LAST_DAY(a.ENROLLMENT_END_DT) + 1, 'YYYYMM')) EFFECT_DISENROLL_MONTH_ID,
              a.REASON_CF,
              NVL(a.VOLUNTARY_IND, 'Unknown') VOLUNTARY_IND,
              1 DISENROLLMENT_FLAG,
              a.REF_DISENROLLMENT_RSN_SK
     FROM     CHOICEBI.FACT_MEMBER_ENROLL_DISENROLL a, CHOICEBI.FACT_MEMBER_ENROLL_DISENROLL b, (SELECT /*+ no_merge materialize */
                                                                                                       * FROM MSTRSTG.D_REF_PLAN) c
     WHERE    a.SUBSCRIBER_ID = b.SUBSCRIBER_ID AND a.ENROLLMENT_END_DT = b.PRODUCT_END_DT AND A.DL_PLAN_SK = c.DL_PLAN_SK AND a.ENROLLMENT_END_DT < TO_DATE( '31-12-2199', 'dd-mm-yyyy')
     GROUP BY a.DL_LOB_ID,
              CASE WHEN c.PROGRAM = 'MA' THEN 1 WHEN c.PROGRAM = 'MLTC' THEN 2 WHEN c.PROGRAM = 'SH' THEN 3 WHEN c.PROGRAM = 'FIDA' THEN 4 ELSE 0 END,
              c.PROGRAM,
              a.DL_PLAN_SK,
              a.MEMBER_ID,
              a.SUBSCRIBER_ID,
              a.PRODUCT_ID,
              a.PRODUCT_NAME,
              TO_NUMBER(TO_CHAR( a.ENROLLMENT_END_DT, 'YYYYMM')),
              LAST_DAY(a.ENROLLMENT_END_DT) + 1,
              TO_NUMBER(TO_CHAR( LAST_DAY(a.ENROLLMENT_END_DT) + 1, 'YYYYMM')),
              a.REASON_CF,
              NVL(a.VOLUNTARY_IND, 'Unknown'),
              a.REF_DISENROLLMENT_RSN_SK
              )
              


GRANT SELECT ON FACT_MEMBER_DISENROLL_PROD_AGG TO MSTRSTG WITH GRANT OPTION;
