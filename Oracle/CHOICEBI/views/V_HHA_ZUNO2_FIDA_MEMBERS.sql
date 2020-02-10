    
CREATE OR REPLACE VIEW V_HHA_ZUNO2_FIDA_MEMBERS
as     
    SELECT   E.Line_Of_Business,
             SUBSCRIBER_ID,
             E.MEMBER_ID,
             'FIDA' CARRIER_NAME,
             ENROLLMENT_DATE
    FROM     CHOICEBI.FACT_MEMBER_MONTH E
    WHERE    DL_LOB_ID = 4 and month_id = 201912 and disenrolled_flag = 1
    ORDER BY ENROLLMENT_DATE DESC
    