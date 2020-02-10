DROP VIEW V_MEMBER_RISK_CURR_PERIOD;

CREATE OR REPLACE VIEW V_MEMBER_RISK_CURR_PERIOD
(
    MEDICAID_NUM,
    SUBSCRIBER_ID,
    NUM_SCIC_PAST_YR,
    TOTAL_NUM_RISK,
    FLUVAX_RISK,
    NOER_RISK,
    NOFALLSINJ_RISK,
    NOTLONELY_RISK,
    POT_NFLOC_RISK,
    PAINCONTROL_RISK,
    POT_PAIN_RISK,
    POT_DYSPNEA_RISK,
    POT_URINARY_RISK,
    ASSESSMENT_DATE,
    NEXT_DUE,
    MEM_AT_RISK
) AS
    WITH mbr_month_id AS
             (SELECT /*+ no_merge materialize*/
                    reporting_period_id month_id,
                     (SELECT MAX(CURRENT_PERIOD)
                      FROM   choicebi.fact_quality_risk_measures
                      WHERE  CURRENT_PERIOD = a.report_period2)
                         NEXT_DUE_PERIOD
              --REPORT_PERIOD2 NEXT_DUE_PERIOD
              FROM   CHOICEBI.DIM_REPORTING_PERIOD a
              WHERE  reporting_period_id = (SELECT /*+ no_merge materialize */
                                                  MAX(month_id) AS month_id FROM choicebi.fact_member_month)),
         active_member AS
             (SELECT /*+no_merge materialize*/
                    a.*
              FROM   CHOICEBI.FACT_MEMBER_MONTH a JOIN mbr_month_id b ON (a.month_id = b.month_id)),
         outcome_msr AS
             (SELECT /*+no_merge materialize */
                    msr_token,
                     subscriber_id,
                     assessment_date1,
                     assessment_date2,
                     uas_record_id1,
                     uas_record_id2,
                     assessment_reason1,
                     numerator,
                     denominator,
                     dl_lob_id,
                     1 AS fact_quality_measures
              FROM   choicebi.fact_quality_measures a JOIN mbr_month_id b ON (a.reporting_period_id = b.NEXT_DUE_PERIOD)
              WHERE  msr_token IN ('noER', 'fluvax', 'nofallsinj', 'pot_nfloc', 'notlonely', 'paincontrol', 'pot_pain', 'pot_dyspnea', 'pot_urinary', 'pot_adl', 'pneumovax') AND dl_lob_id IN (2, 4,
                     5) AND STATE_MSR_ELIG_FLAG = 1),
         risk_msr AS
             (SELECT /*+no_merge materialize */
                    *
              FROM   (SELECT /*+no_merge materialize */
                            ROW_NUMBER() OVER (PARTITION BY a.subscriber_id, msr_token ORDER BY outcome DESC, next_due DESC) AS seq, 1 AS fact_quality_risk, a.*
                      FROM   choicebi.fact_quality_risk_measures a JOIN mbr_month_id b ON (a.next_due_period >= b.next_due_period)
                      --where msr_token in ('pneumovax')
                      WHERE  msr_token IN ('noER', 'fluvax', 'nofallsinj', 'pot_nfloc', 'notlonely', 'paincontrol', 'pot_pain', 'pot_dyspnea', 'pot_urinary', 'pot_adl', 'pneumovax') AND dl_lob_id IN
                             (2, 4, 5))
              WHERE  seq = 1),
         Integrate_msr AS
             (SELECT NVL(o.msr_token, r.msr_token) msr_token,
                     --nvl(o.medicaid_num,r.msr_token) msr_token,
                     CASE
                         WHEN o.denominator = 0 AND r.desired_outcome = 'n/a' THEN '2. Not in denominator'
                         WHEN o.denominator = 0 AND r.risk IS NULL THEN '2. Not in denominator'
                         WHEN o.denominator IS NULL AND r.desired_outcome <> 'not yet assessed' THEN '2. Not in denominator'
                         WHEN r.desired_outcome = 'not yet assessed' AND (o.denominator = 0 OR o.denominator IS NULL) THEN '0. Not yet assessed'
                         WHEN o.denominator = 1 AND o.numerator = 0 THEN '1. Assessed - outcome not favorable'
                         WHEN o.denominator = 1 AND o.numerator = 1 THEN '1. Assessed - outcome favorable'
                     END
                         AS status,
                     CASE
                         WHEN r.desired_outcome = 'not yet assessed' AND r.risk = 0 AND (o.denominator = 0 OR o.denominator IS NULL) THEN 'No'
                         WHEN r.desired_outcome = 'not yet assessed' AND r.risk = 1 AND (o.denominator = 0 OR o.denominator IS NULL) THEN 'Yes'
                         WHEN o.denominator = 1 AND o.numerator = 0 AND risk = 0 THEN 'No'
                         WHEN o.denominator = 1 AND o.numerator = 0 AND risk = 1 THEN 'Yes'
                         WHEN o.denominator = 1 AND o.numerator = 0 AND risk IS NULL THEN 'n/a'
                         WHEN o.denominator = 1 AND o.numerator = 1 AND risk = 0 THEN 'No'
                         WHEN o.denominator = 1 AND o.numerator = 1 AND risk = 1 THEN 'Yes'
                         WHEN o.denominator = 1 AND o.numerator = 1 AND risk IS NULL THEN 'n/a'
                     END
                         AS risk_flag_status,
                     CASE
                         WHEN o.denominator = 0 AND r.desired_outcome = 'n/a' THEN 1
                         WHEN o.denominator = 0 AND r.risk IS NULL THEN 1
                         WHEN o.denominator IS NULL AND r.desired_outcome <> 'not yet assessed' THEN 1
                         ELSE 0
                     END
                         AS not_in_denominator,
                     CASE WHEN r.desired_outcome = 'not yet assessed' AND (o.denominator = 0 OR o.denominator IS NULL) THEN 1 ELSE 0 END AS not_yet_assessed,
                     CASE WHEN o.denominator = 1 AND o.numerator = 1 THEN 1 ELSE 0 END AS assessed_outcome_favorable,
                     CASE WHEN o.denominator = 1 AND o.numerator = 0 THEN 1 ELSE 0 END AS assessed_outcome_unfavorable,
                     CASE WHEN r.desired_outcome = 'not yet assessed' AND r.risk = 1 AND (o.denominator = 0 OR o.denominator IS NULL) THEN 1 ELSE 0 END AS at_risk_not_yet_assessed,
                     COALESCE( o.msr_token, r.msr_token) AS measure_short,
                     COALESCE( o.subscriber_id, r.subscriber_id) AS subscriber_id,
                     COALESCE( o.dl_lob_id, r.dl_lob_id) AS dl_lob_id /*        , o.uas_record_id1, o.uas_record_id2*/
                                                                      /*        , o.assessment_reason1*/
                     ,
                     o.numerator,
                     o.denominator,
                     o.fact_quality_measures,
                     r.vendor_id AS onurseorg,
                     r.onurseorgname,
                     r.onursename,
                     r.uas_record_id1,
                     r.uas_record_id2 /*        , r.uas_record_id3*/
                                     ,
                     r.assessmenT_date1,
                     r.assessment_date2 /*        , r.assessment_date3 */
                                       ,
                     r.assessment_reason1,
                     r.assessment_reason2 /*        , r.assessment_reason3*/
                                         ,
                     r.next_due,
                     r.next_due_period,
                     r.risk,
                     r.risk_note,
                     r.outcome,
                     r.desired_outcome
              FROM --outcome_flu o
                  outcome_msr o
                     FULL OUTER JOIN (SELECT a.*
                                      FROM   risk_msr a JOIN mbr_month_id b ON (a.next_due_period = b.NEXT_DUE_PERIOD)) r
                         ON (o.subscriber_id = r.subscriber_id AND o.msr_token = r.msr_token)),
         integrate_clean AS
             (SELECT /*+no_merge materialize*/
                    *
              FROM   (SELECT CASE WHEN m.month_id IS NULL AND i.desired_outcome = 'not yet assessed' THEN 1 ELSE 0 END AS exclude,
                             m.medicaid_num,
                             m.last_name,
                             m.first_name,
                             i.*,
                             m.month_id
                      FROM   integrate_msr i LEFT JOIN active_member m ON (i.subscriber_id = m.subscriber_id))
              WHERE  exclude = 0),
         risklists AS
             (SELECT /*+no_merge materialize*/
                    a.*
              FROM   integrate_clean a
              WHERE  at_risk_not_yet_assessed = 1),
         scic AS
             (SELECT   z.medicaid_num, COUNT(1) AS num_SCIC_past_yr
              FROM     (SELECT DISTINCT medicaid_num FROM active_member) z JOIN dw_owner.uas_communityhealth a ON (z.medicaid_num = a.medicaidnumber1)
              WHERE    a.assessmentdate < SYSDATE AND a.assessmentdate > SYSDATE - 365 AND a.assessmentreason = 4
              GROUP BY z.medicaid_num),
         risklists_scic AS
             (SELECT r.*, COALESCE( s.num_SCIC_past_yr, 0) AS num_SCIC_past_yr
              FROM   risklists r LEFT JOIN scic s ON (r.medicaid_num = s.medicaid_num)),
         nextdue_targetmonth1 AS
             (SELECT DISTINCT
                     proj.uas_record_id1,
                     proj.uas_record_id2,
                     proj.medicaid_num,
                     proj.subscriber_id,
                     proj.last_name,
                     proj.first_name,
                     proj.month_id,
                     CASE
                         WHEN SUBSTR( proj.subscriber_id, 1, 2) = 'V8' THEN 'MLTC Partial'
                         WHEN SUBSTR( proj.subscriber_id, 1, 2) = 'V7' THEN 'MAP'
                         WHEN SUBSTR( proj.subscriber_id, 1, 2) = 'V6' THEN 'FIDA'
                     END
                         AS choiceprogram,
                     proj.dl_lob_id AS lob_id,
                     proj.next_due,
                     proj.onurseorg,
                     proj.onurseorgname,
                     proj.onursename,
                     proj.num_SCIC_past_yr,
                     proj.assessment_date1,
                     proj.assessment_date2,
                     proj.assessment_reason1,
                     proj.assessment_reason2,
                     proj.measure_short,
                     CASE WHEN proj.measure_short = 'pot_nfloc' THEN 1 ELSE 0 END AS pot_nfloc_risk,
                     CASE WHEN proj.measure_short = 'pot_urinary' THEN 1 ELSE 0 END AS pot_urinary_risk,
                     CASE WHEN proj.measure_short = 'pot_pain' THEN 1 ELSE 0 END AS pot_pain_risk,
                     CASE WHEN proj.measure_short = 'pot_dyspnea' THEN 1 ELSE 0 END AS pot_dyspnea_risk,
                     CASE WHEN proj.measure_short = 'pot_adl' THEN 1 ELSE 0 END AS pot_adl_risk,
                     CASE WHEN proj.measure_short = 'fluvax' THEN 1 ELSE 0 END AS fluvax_risk /*, case when measure_short='nofalls' then 1 else 0 end as nofalls_risk*/
                                                                                             ,
                     CASE WHEN proj.measure_short = 'nofallsinj' THEN 1 ELSE 0 END AS nofallsinj_risk,
                     CASE WHEN proj.measure_short = 'noER' THEN 1 ELSE 0 END AS noER_risk,
                     CASE WHEN proj.measure_short = 'paincontrol' THEN 1 ELSE 0 END AS paincontrol_risk,
                     CASE WHEN proj.measure_short = 'notlonely' THEN 1 ELSE 0 END AS notlonely_risk,
                     CASE WHEN proj.measure_short = 'dental' THEN 1 ELSE 0 END AS dental_risk,
                     CASE WHEN proj.measure_short = 'eye' THEN 1 ELSE 0 END AS eye_risk,
                     CASE WHEN proj.measure_short = 'hearing' THEN 1 ELSE 0 END AS hearing_risk,
                     CASE WHEN proj.measure_short = 'mammogram' THEN 1 ELSE 0 END AS mammogram_risk,
                     CASE WHEN proj.measure_short = 'pneumovax' THEN 1 ELSE 0 END AS pneumovax_risk,
                     proj.risk,
                     proj.risk_note,
                     proj.outcome,
                     proj.desired_outcome,
                     DECODE(proj.at_risk_not_yet_assessed, 1, 'Yes', 'No') MEM_AT_RISK
              FROM   risklists_scic proj LEFT JOIN CHOICEBI.FACT_MEMBER_MONTH ci ON (proj.subscriber_id = ci.subscriber_id AND proj.dl_lob_id = ci.lob_id AND proj.month_id = ci.month_id)),
         mbrs_at_risk_targetmonth1 AS
             (SELECT DISTINCT a.medicaid_num,
                              a.subscriber_id,
                              a.last_name,
                              a.first_name,
                              a.choiceprogram,
                              a.next_due,
                              a.month_id,
                              a.onurseorg,
                              a.onurseorgname,
                              a.onursename,
                              a.num_SCIC_past_yr,
                              a.MEM_AT_RISK,
                              a.total_num_risk,
                              a.fluvax_risk,
                              a.nofallsinj_risk,
                              a.noER_risk,
                              a.paincontrol_risk,
                              a.notlonely_risk,
                              a.pot_nfloc_risk,
                              a.pot_urinary_risk,
                              a.pot_pain_risk,
                              a.pot_dyspnea_risk
              FROM   (SELECT   medicaid_num,
                               subscriber_id,
                               last_name,
                               first_name,
                               choiceprogram,
                               next_due,
                               onurseorg,
                               onurseorgname,
                               onursename,
                               month_id,
                               lob_id,
                               num_SCIC_past_yr,
                               MAX(MEM_AT_RISK) MEM_AT_RISK,
                               MAX(fluvax_risk) AS fluvax_risk,
                               MAX(nofallsinj_risk) AS nofallsinj_risk,
                               MAX(noER_risk) AS noER_risk,
                               MAX(paincontrol_risk) AS paincontrol_risk,
                               MAX(notlonely_risk) AS notlonely_risk,
                               MAX(pot_nfloc_risk) AS pot_nfloc_risk,
                               MAX(pot_urinary_risk) AS pot_urinary_risk,
                               MAX(pot_pain_risk) AS pot_pain_risk,
                               MAX(pot_dyspnea_risk) AS pot_dyspnea_risk,
                               MAX(fluvax_risk) + MAX(nofallsinj_risk) + MAX(noER_risk) + MAX(paincontrol_risk) + MAX(notlonely_risk) + MAX(pot_nfloc_risk) + MAX(pot_urinary_risk) + MAX(pot_pain_risk)
                               + MAX(pot_dyspnea_risk)
                                   AS total_num_risk
                      FROM     nextdue_targetmonth1
                      GROUP BY medicaid_num,
                               subscriber_id,
                               last_name,
                               first_name,
                               choiceprogram,
                               next_due,
                               onurseorg,
                               onurseorgname,
                               onursename,
                               lob_id,
                               num_SCIC_past_yr,
                               month_id) a
                     LEFT JOIN CHOICEBI.FACT_MEMBER_MONTH i ON (a.subscriber_id = i.subscriber_id AND a.lob_id = i.lob_id AND a.month_id = i.month_id)),
         member_risk AS
             (SELECT DISTINCT a.*,
                              b.assessment_date1,
                              b.assessment_date2,
                              CASE WHEN b.assessment_date1 < b.assessment_date2 THEN b.assessment_date2 ELSE b.assessment_date1 END AS assessment_date
              FROM   mbrs_at_risk_targetmonth1 a LEFT JOIN nextdue_targetmonth1 b ON a.medicaid_num = b.medicaid_num)
    SELECT /*+ no_merge materialize */
          DISTINCT medicaid_num,
                   subscriber_id,
                   num_scic_past_yr,
                   total_num_risk,
                   fluvax_risk,
                   noER_risk,
                   nofallsinj_risk,
                   notlonely_risk,
                   pot_nfloc_risk,
                   paincontrol_risk,
                   pot_pain_risk,
                   pot_dyspnea_risk,
                   pot_urinary_risk,
                   assessment_date,
                   next_due,
                   MEM_AT_RISK
    FROM   member_risk;


GRANT SELECT ON V_MEMBER_RISK_CURR_PERIOD TO PICBI WITH GRANT OPTION
