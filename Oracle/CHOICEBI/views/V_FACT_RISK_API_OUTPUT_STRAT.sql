create or replace view V_FACT_RISK_API_OUTPUT_STRAT as 
SELECT 
    C.MDL_NAME,  
    E.MDL_INPUT_TYPE_DESCR,  
    A.MDL_INPUT_ID,
    h.first_name,
    h.last_name,
    h.medicaid_number,
    g.MEMBER_ID,
    g.ASSESSMENTDATE,
    g.ASSESSMENTTYPE,
    g.LEVELOFCARESCORE,
    A.PRED_VALUE, 
    A.MDL_PRED_STRAT,
    E.KEEP_HISTORY_IND, 
    F.THRESH_VRSN_START_DATE, 
    F.THRESH_VRSN_END_DATE, 
    f.RANGE_LOW, 
    f.range_high, 
    f.pred_strat ,
    C.MDL_SK,
    B.MDL_VRSN_SK,
    F.MDL_THRESH_SK, 
    d.MDL_INPUT_TYPE_SK
FROM 
    FACT_RISK_API_OUTPUT_STRAT A
    join FACT_RISK_API_OUTPUT D on (a.mdl_input_id = d.mdl_input_id and A.MDL_VRSN_SK  = D.MDL_VRSN_SK)
    join DIM_PRED_MDL_INPUT_TYPE E on (d.MDL_INPUT_TYPE_SK = e.MDL_INPUT_TYPE_SK)
    join DIM_PRED_MDL_THRESH_VRSN F on (A.MDL_THRESH_SK = F.MDL_THRESH_SK)
    join DIM_PRED_MDL_VRSN B  on (B.MDL_VRSN_SK = A.MDL_VRSN_SK)
    join DIM_PRED_MDL C on (B.MDL_SK = C.MDL_SK)
    left join choice.dim_member_assessments@dlake g on ( a.mdl_input_id = g.dl_assess_sk and MDL_INPUT_TYPE_DESCR = 'UAS_Record_ID')
    left join choice.dim_member@dlake h on (g.member_id = h.member_id and h.DL_ACTIVE_REC_IND = 'Y') 
    
