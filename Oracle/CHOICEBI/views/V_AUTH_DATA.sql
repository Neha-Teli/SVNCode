DROP VIEW V_AUTH_DATA;

CREATE OR REPLACE VIEW V_AUTH_DATA
(
    PATIENT_ID,
    UNIQUE_ID,
    AUTH_ID,
    AUTH_NO,
    LOB_BEN_ID,
    LOB_NAME,
    AUTH_TYPE_ID,
    AUTH_TYPE_NAME,
    AUTH_PRIORITY_ID,
    AUTH_PRIORITY,
    AUTH_NOTI_DATE,
    PHYSICIAN_ID,
    PROVIDER_NAME,
    AUTH_ACT_OWNER,
    AUTH_ACT_OWNER_NAME,
    AUTH_CUR_OWNER,
    AUTH_CUR_OWNER_NAME,
    AUTH_STATUS_ID,
    AUTH_STATUS,
    AUTH_STATUS_REASON_ID,
    AUTH_STATUS_REASON_NAME,
    AUTH_CREATED_BY,
    AUTH_CREATED_BY_NAME,
    AUTH_CREATED_ON,
    AUTH_UPDATED_BY,
    AUTH_UPDATED_BY_NAME,
    AUTH_UPDATED_ON,
    AUTH_CODE_ID,
    AUTH_CODE_TYPE_ID,
    AUTH_CODE_DESC,
    AUTH_CODE_REF_ID,
    AUTH_CODE_REF_NAME,
    UNIT_TYPE_ID,
    SERVICE_DECISION_MODIFIER,
    UNIT_TYPE,
    AUTH_CODE_CREATED_BY,
    AUTH_CODE_CREATED_BY_NAME,
    AUTH_CODE_CREATED_ON,
    AUTH_CODE_UPDATED_BY,
    AUTH_CODE_UPDATED_BY_NAME,
    AUTH_CODE_UPDATED_ON,
    ALTERNATE_SERVICE_ID,
    HOURS,
    DAYS,
    HOURS_X_DAYS,
    WEEKS,
    ADDITIONAL_DAYS,
    ATSP_HOURS,
    DECISION_ID,
    DECISION_NO,
    DECISION_DATE,
    DECISION_BY,
    DECISION_BY_NAME,
    DECISION_STATUS,
    DECISION_STATUS_DESC,
    DECISION_STATUS_CODE_ID,
    DECISION_STATUS_CODE_DESC,
    TREATMENT_TYPE_ID,
    SERVICE_FROM_DATE,
    SERVICE_TO_DATE,
    EFFECTIVE_DATE,
    CURRENT_REQUESTED,
    CURRENT_APPROVED,
    MEMBER_SERVICE_PLAN_ID,
    MAX_HRS_PER_VISIT,
    MAX_VISITS_PER_WK
) AS
    SELECT c.patient_id,
           p.unique_id,
           c.auth_id,
           c.auth_no,
           c.lob_ben_id,
           auth_dim1_1.lob_name,
           c.auth_type_id,
           auth_dim2.auth_type_name,
           c.auth_priority_id,
           auth_dim2_1.auth_priority,
           c.auth_noti_date,
           auth_dim3.physician_id,
           auth_dim3.provider_name,
           c.auth_act_owner,
           (staff1.first_name || ' ' || staff1.last_name) AS auth_act_owner_Name,
           c.auth_cur_owner,
           (staff2.first_name || ' ' || staff2.last_name) AS auth_cur_owner_Name,
           c.auth_status_id,
           auth_dim5.auth_status,
           c.auth_status_reason_id,
           auth_dim7.auth_status_reason_name,
           c.CREATED_BY AS auth_created_by,
           (staff3.first_name || ' ' || staff3.last_name) AS auth_created_by_Name,
           c.CREATED_ON AS auth_created_on,
           c.UPDATED_BY AS auth_updated_by,
           (staff4.first_name || ' ' || staff4.last_name) AS auth_updated_by_Name,
           c.UPDATED_ON AS auth_updated_on,
           code.auth_code_id,
           CODE.AUTH_CODE_TYPE_ID,
           auth_dim6.auth_code_desc,
           code.auth_code_ref_id,
           COALESCE(auth_dim10.proc_description,
                    auth_dim11.service_category_label,
                    auth_dim12.diag_desc,
                    auth_dim12_1.diag_desc,
                    auth_dim13.diag_desc,
                    auth_dim13_1.diag_desc,
                    auth_dim14.medication_desc)
               AS auth_code_ref_name,
           code.unit_type_id,
           code.SERVICE_DECISION_MODIFIER,
           auth_dim4.unit_type,
           code.CREATED_BY AS auth_code_created_by,
           (staff5.first_name || ' ' || staff5.last_name) AS auth_code_Created_by_Name,
           code.CREATED_ON AS auth_code_created_on,
           code.UPDATED_BY AS auth_code_updated_by,
           (staff6.first_name || ' ' || staff6.last_name) AS auth_code_updated_by_Name,
           code.UPDATED_ON AS auth_code_updated_on,
           code.alternate_service_id,
           code.hours,
           code.days,
           code.hours * code.days AS hours_x_days,
           code.weeks,
           code.additional_days,
           code.atsp_hours,
           d.decision_id,
           d.decision_no,
           d.replied_date AS decision_date,
           d.Decision_by,
           (staff7.first_name || ' ' || staff7.last_name) AS Decision_By_name,
           d.decision_status,
           auth_dim8.decision_status AS decision_status_desc,
           d.decision_status_code_id,
           auth_dim9.decision_status_code_desc,
           d.treatment_type_id,
           d.service_from_date,
           d.service_to_date,
           d.effective_date,
           d.current_requested,
           d.current_approved,
           d.MEMBER_SERVICE_PLAN_ID,
           c.auth_cost_savings as max_hrs_per_visit,
           auth_ch.auth_standard as max_visits_per_wk          
    FROM   cmgc.um_auth c
           JOIN cmgc.um_auth_code code ON (c.auth_no = code.auth_no)
           LEFT JOIN cmgc.um_decision d ON (code.auth_code_id = d.auth_code_id AND c.auth_no = d.auth_no)
           JOIN cmgc.patient_details p ON (p.patient_id = c.patient_id)
           LEFT JOIN cmgc.care_staff_details staff1 ON (c.auth_act_owner = staff1.member_id)
           LEFT JOIN cmgc.care_staff_details staff2 ON (c.auth_cur_owner = staff2.member_id)
           LEFT JOIN cmgc.care_staff_details staff3 ON (c.CREATED_BY = staff3.member_id)
           LEFT JOIN cmgc.care_staff_details staff4 ON (c.UPDATED_BY = staff4.member_id)
           LEFT JOIN cmgc.care_staff_details staff5 ON (code.CREATED_BY = staff5.member_id)
           LEFT JOIN cmgc.care_staff_details staff6 ON (code.UPDATED_by = staff6.member_id)
           LEFT JOIN cmgc.care_staff_details staff7 ON (d.decision_by = staff7.member_id)
           LEFT JOIN CMGC.LOB_BENF_PLAN auth_dim1 ON (c.LOB_BEN_id = auth_dim1.LOB_BEN_ID) --dim table
           LEFT JOIN CMGC.LOB auth_dim1_1 ON (auth_dim1.LOB_id = auth_dim1_1.LOB_ID) --dim table
           LEFT JOIN CMGC.UM_MA_AUTH_TYPE auth_dim2 ON (c.auth_type_id = auth_dim2.AUTH_TYPE_ID) --dim table
           LEFT JOIN cmgc.um_ma_auth_tat_priority auth_dim2_1 ON (c.auth_priority_id = auth_dim2_1.auth_priority_id)
           LEFT JOIN (SELECT auth_no,
                             provider_name,
                             physician_id,
                             ROW_NUMBER() OVER (PARTITION BY auth_no ORDER BY created_on DESC) AS seq
                      FROM   CMGC.um_auth_provider
                      WHERE  provider_type_id = 4 AND deleted_on IS NULL) auth_dim3
               ON (c.auth_no = auth_dim3.AUTH_no AND seq = 1) --dim table
           LEFT JOIN CMGC.um_ma_unit_type auth_dim4 ON (code.unit_type_id = auth_dim4.unit_type_id) --dim table
           LEFT JOIN cmgc.um_ma_auth_status auth_dim5 ON (c.auth_status_id = auth_dim5.AUTH_STATUS_ID) --dim table
           LEFT JOIN cmgc.um_ma_auth_code_type auth_dim6 ON (code.AUTH_CODE_TYPE_ID = auth_dim6.AUTH_CODE_TYPE_ID) --dim table
           LEFT JOIN cmgc.um_ma_auth_status_reason auth_dim7 ON (C.AUTH_STATUS_REASON_ID = auth_dim7.auth_status_reason_id) --dim table
           LEFT JOIN cmgc.um_ma_decision_status auth_dim8 ON (d.decision_status = auth_dim8.DECISION_STATUS_ID) --dim table
           LEFT JOIN cmgc.um_ma_decision_status_codes auth_dim9 ON (d.decision_status_code_id = auth_dim9.DECISION_STATUS_code_ID) --dim table
           LEFT JOIN cmgc.um_ma_procedure_codes auth_dim10 ON (code.auth_code_ref_id = auth_dim10.proc_code AND code.AUTH_CODE_TYPE_ID = 1) --dim table
           LEFT JOIN cmgc.service_plan auth_dim11 ON (code.auth_code_ref_id = TO_CHAR(auth_dim11.service_id) AND code.AUTH_CODE_TYPE_ID = 5) --dim table
           LEFT JOIN cmgc.icd10_code auth_dim12 ON (TRIM(code.auth_code_ref_id) = TRIM(auth_dim12.diagnosis_code) AND code.AUTH_CODE_TYPE_ID = 2) --dim table
           LEFT JOIN cmgc.icd_code auth_dim12_1 ON (TRIM(code.auth_code_ref_id) = TRIM(auth_dim12_1.diagnosis_code) AND code.AUTH_CODE_TYPE_ID = 2) --dim table
           LEFT JOIN cmgc.icd10_code auth_dim13 ON (code.auth_code_ref_id = auth_dim13.diagnosis_code AND code.AUTH_CODE_TYPE_ID = 3) --dim table
           LEFT JOIN cmgc.icd10_code auth_dim13_1 ON (code.auth_code_ref_id = auth_dim13_1.diagnosis_code AND code.AUTH_CODE_TYPE_ID = 3) --dim table
           LEFT JOIN cmgc.patient_medication_code auth_dim14 ON (code.auth_code_ref_id = auth_dim14.medication_code AND code.AUTH_CODE_TYPE_ID = 4) --dim table
           LEFT JOIN cmgc.um_auth_charge auth_ch on(c.auth_no=auth_ch.auth_no)
    WHERE  1 = 1 AND c.deleted_by IS NULL AND c.deleted_on IS NULL AND code.deleted_on IS NULL AND code.deleted_by IS NULL AND d.deleted_on IS NULL AND d.deleted_by IS NULL AND p.deleted_by IS NULL
           AND UPPER(SUBSTR( p.UNIQUE_ID, 1, 1)) = 'V';


GRANT SELECT ON V_AUTH_DATA TO MSTRSTG;

GRANT SELECT ON V_AUTH_DATA TO ROC_RO;

GRANT SELECT ON V_AUTH_DATA TO SF_CHOICE;
