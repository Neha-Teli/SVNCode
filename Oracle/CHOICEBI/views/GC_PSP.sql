create or replace view GC_PSP as 
(
    SELECT a.script_run_log_id ,
           a.patient_id ,
           p.unique_id ,
           a.staff_id ,
           s.first_name || ' ' || s.last_name Staff_name ,
           a_desc.value AS Scpt_Activity_Status ,
           a4_desc.status_name AS Scpt_Form_Activity_Status ,
           a.start_date ,
           a.end_date ,
           (CASE
                WHEN LENGTH(TRANSLATE(trim(a4.approved_units), 'x0123456789', 'x')) IS NULL THEN to_number(trim(a4.approved_units))
            END) AS PSP_Approved ,
           y.PSP_Tasking_Tool --    , row_number () over (partition by a.patient_id order by a.start_date desc ) AS psp_seq
    FROM cmgc.scpt_patient_script_run_log a
    LEFT JOIN cmgc.scpt_script_run_status a_desc on(a.status_id=a_desc.status_id)
    JOIN
      (SELECT a2.script_run_log_id ,
              max(CASE WHEN a2.question_id=3365 THEN q1.option_value ELSE NULL end) AS PSP_Tasking_Tool
       FROM cmgc.scpt_pat_script_run_log_det a2
       JOIN cmgc.scpt_question_response q1 ON (q1.script_run_log_detail_id=a2.script_run_log_detail_id)
       WHERE a2.script_id=107
       GROUP BY a2.script_run_log_id ) y ON (a.script_run_log_id = y.script_run_log_id)
    LEFT JOIN
      (SELECT s.*,
              row_number () over (partition BY s.patient_id, s.script_run_log_id
                                  ORDER BY s.created_on DESC) AS seq
       FROM cmgc.scpt_form_patient_info s) a3 on(a.patient_id=a3.patient_id
                                                        AND a.script_run_log_id=a3.script_run_log_id
                                                        AND a3.seq=1)
    LEFT JOIN cmgc.scpt_form_pat_review_status a4 on(a3.sfpi_id=a4.sfpi_id)
    LEFT JOIN CMGC.CM_MA_SERVICPLAN_SCRPTFORM_STS a4_desc on(a4.status_id=a4_desc.serviceplan_scriptfrom_id)
    JOIN cmgc.patient_details p on(a.patient_id=p.patient_id)
    LEFT JOIN cmgc.care_staff_details s on(s.member_id=a.staff_id)
    WHERE a.DELETED_BY IS NULL
      AND a.DELETED_ON IS NULL
      AND substr(p.unique_id,1,1)='V'
)