DROP VIEW FACT_MEMBER_DISENRL_CHOICE_AGG;

CREATE OR REPLACE VIEW FACT_MEMBER_DISENRL_CHOICE_AGG
(
    DL_LOB_ID_CEDL,
    DL_LOB_ID,
    DL_PLAN_SK,
    MEMBER_ID,
    SUBSCRIBER_ID,
    PRODUCT_ID,
    PRODUCT_NAME,
    DISENROLLMENT_DATE,
    DISENROLLMENT_MONTH_ID,
    EFFECT_DISENROLL_DATE,
    EFFECT_DISENROLL_MONTH_ID,
    REASON_CF,
    VOLUNTARY_IND,
    DISENROLLMENT_FLAG
) AS
    SELECT a.DL_LOB_ID DL_LOB_ID_CEDL,
           a.DL_LOB_ID,
           a.DL_PLAN_SK,
           a.MEMBER_ID,
           a.SUBSCRIBER_ID,
           a.PRODUCT_ID,
           a.PRODUCT_NAME,
           a.DISENROLLMENT_DATE,
           a.DISENROLLMENT_MONTH_ID,
           a.EFFECT_DISENROLL_DATE,
           a.EFFECT_DISENROLL_MONTH_ID,
           a.REASON_CF,
           a.VOLUNTARY_IND,
           1 DISENROLLMENT_FLAG
    FROM   FACT_MEMBER_DISENROLL_PROD_AGG a,
           (SELECT   CASE
                         WHEN b.PROGRAM = 'MA' THEN 1
                         WHEN b.PROGRAM = 'MLTC' THEN 2
                         WHEN b.PROGRAM = 'SH' THEN 3
                         WHEN b.PROGRAM = 'FIDA' THEN 4
                         ELSE 0
                     END
                         DL_LOB_ID,
                     a.SUBSCRIBER_ID,
                     a.CHOICE_PERS_END_DT,
                     MIN(a.CHOICE_PERS_END_DT) MIN_CHOICE_PERS_END_DT
            FROM     CHOICEBI.FACT_MEMBER_ENROLL_DISENROLL a,
                     MSTRSTG.D_REF_PLAN b
            WHERE        a.DL_PLAN_SK = b.DL_PLAN_SK
                     AND a.CHOICE_PERS_END_DT <
                             TO_DATE('31-12-2199', 'dd-mm-yyyy')
            GROUP BY CASE
                         WHEN b.PROGRAM = 'MA' THEN 1
                         WHEN b.PROGRAM = 'MLTC' THEN 2
                         WHEN b.PROGRAM = 'SH' THEN 3
                         WHEN b.PROGRAM = 'FIDA' THEN 4
                         ELSE 0
                     END,
                     a.SUBSCRIBER_ID,
                     a.CHOICE_PERS_END_DT) b
    WHERE      a.DL_LOB_ID = b.DL_LOB_ID
           AND a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
           AND a.DISENROLLMENT_DATE = b.CHOICE_PERS_END_DT


GRANT SELECT ON FACT_MEMBER_DISENRL_CHOICE_AGG TO MSTRSTG
