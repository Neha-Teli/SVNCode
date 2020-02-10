DROP VIEW CHOICEBI.DIM_REPORTING_PERIOD;

CREATE OR REPLACE FORCE VIEW CHOICEBI.DIM_REPORTING_PERIOD
AS
    (SELECT MONTH_ID REPORTING_PERIOD_ID,
            MONTH_DATE MONTH_START_DATE,
            MONTH_END_DATE,
            PREV_MONTH_ID,
            PREV_MONTH_ID PRIORMONTH1,
            SUBSTR(A.MONTH_ID, 1, 4)||
            'H' ||
            CASE
                WHEN SUBSTR(A.MONTH_ID, 5, 2) IN (1, 2, 3, 4, 5, 6) THEN 1
                WHEN SUBSTR(A.MONTH_ID, 5, 2) IN (7, 8, 9, 10, 11, 12) THEN 2
            END
                AS REPORT_PERIOD,
              SUBSTR(A.MONTH_ID, 1, 4) * 100
            + (CASE
                   WHEN SUBSTR(A.MONTH_ID, 5, 2) IN (1, 2, 3, 4, 5, 6) THEN
                       1
                   WHEN SUBSTR(A.MONTH_ID, 5, 2) IN (7, 8, 9, 10, 11, 12) THEN
                       2
               END)
                AS REPORT_PERIOD2
     FROM   MSTRSTG.LU_MONTH A
     WHERE  MONTH_ID >= 201401);


GRANT SELECT ON CHOICEBI.DIM_REPORTING_PERIOD TO DW_OWNER;

GRANT SELECT ON CHOICEBI.DIM_REPORTING_PERIOD TO MSTRSTG;
