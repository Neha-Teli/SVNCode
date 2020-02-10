Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (24, 'Quality', 'Over-Time', '24', 'Locomotion Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in
locomotion', 'Members who remained stable or demonstrated improvement in moving between
locations on same floor', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_LOCOMOTION from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_LOCOMOTION', 'pot_locomotion');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (25, 'Quality', 'Over-Time', '25', 'Bathing Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in bathing', 'Members who remained stable or demonstrated improvement in taking a full-body
bath/shower', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_BATHING from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_BATHING', 'pot_bathing');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (26, 'Quality', 'Over-Time', '26', 'Toilet Transfer Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in toilet transfer', 'Members who remained stable or demonstrated improvement in moving on and off
the toilet or commode', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_TOILET_TRANSFER from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_TOILET_TRANSFER', 'pot_toilettransfer');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (27, 'Quality', 'Over-Time', '27', 'Dressing Upper Body Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in dressing upper body', 'Members who remained stable or demonstrated improvement in dressing and
undressing their upper body', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_DRESS_UPPER from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_DRESS_UPPER', 'pot_dressupper');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (28, 'Quality', 'Over-Time', '28', 'Dressing Lower Body Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in dressing lower body', 'Members who remained stable or demonstrated improvement in dressing and
undressing their lower body', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_DRESS_LOWER from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better', 'ADL_DRESS_LOWER', 'pot_dresslower');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (29, 'Quality', 'Over-Time', '29', 'Toilet Use Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in toilet use', 'Members who remained stable or demonstrated improvement in using the toilet room
(or commode, bedpan, urinal)', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_TOILET_USE from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_TOILET_USE', 'pot_toiletuse');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (30, 'Quality', 'Over-Time', '30', 'Eating Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in eating', 'Members who remained stable or demonstrated improvement in eating and drinking
(including intake of nutrition by other means)', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_EATING from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_EATING', 'pot_eating');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (31, 'Quality', 'Over-Time', '31', 'Urinary Continence Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in
urinary continence', 'Members who remained stable or demonstrated improvement in urinary continence', 
    'All members', 'Missing or “did not occur - no urine output from bladder in last 3 days” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: BLADDER_CONTINENCE from the most recent and previous assessments.
The same or a decrease in the level of incontinence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a response of “Incontinent – no control present” on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'BLADDER_CONTINENCE', 'pot_urinary');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (32, 'Quality', 'Over-Time', '32', 'Shortness of Breath Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in
shortness of breath', 'Members who remained stable or demonstrated improvement in shortness of breath', 
    'All members', 'Missing response on the most recent or previous assessment
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: DYSPNEA from the most recent and previous assessments.
The same or a decrease in the level of shortness of breath from the previous to most recent assessment is considered stable or improved
(numerator compliant). However, a response of Present at rest on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'DYSPNEA', 'pot_dyspnea');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (33, 'Quality', 'Over-Time', '33', 'Managing Medications Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in
managing medications', 'Members who remained stable or demonstrated improvement in managing
medications', 
    'All members', 'Missing or “activity did not occur” response on the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: IADL_PERFORMANCE_MEDS from the most recent and previous assessments.
The same or a decrease in the level of dependence from the previous to the most recent assessment is considered stable or improved
(numerator compliant). However, a maximum level of dependence on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better', 'IADL_PERFORMANCE_MEDS', 'pot_managemeds');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (15, 'Quality', 'Prevalence', '15', 'Influenza Vaccination', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who received an influenza vaccination in the last year', 'Members who received an influenza vaccine in the last year', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: TX_INFLUENZA.
A higher rate of performance is better.', 'TX_INFLUENZA', 'fluvax');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (16, 'Quality', 'Prevalence', '16', 'Talked About Appointing for Health Decisions', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who responded that a health plan representative talked to them about
appointing someone to make decisions about their health if they are unable to do so', 'Members who responded that, yes, a health plan representative talked to them
about appointing someone to make decisions about their health if they are unable to
do so', 
    'All members', 'Missing or “Not sure” response', '2014 Satisfaction Survey question used: 71 - Has anyone from the health plan talked to you about appointing someone to make decisions
about your health if you are unable to do so?
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (17, 'Quality', 'Over-Time', '17', 'ADL Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in ADL
function', 'Members who remained stable or demonstrated improvement in ADL function', 
    'All members', 'Missing or “activity did not occur” responses to any of the three variables on either the most recent or previous assessments
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: ADL_LOCOMOTION, ADL_HYGIENE, and ADL_BATHING from the most recent and previous assessments.
ADL Stable or Improved is based on the sum of ADL_LOCOMOTION, ADL_HYGIENE, and ADL_BATHING.
An increase of up to two, the same, or a decrease in the ADL composite from the previous to the most recent assessment is considered stable
or improved (numerator compliant). However, an ADL composite of 18 (maximum) on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'ADL_LOCOMOTION, ADL_HYGIENE, and ADL_BATHING', 'pot_adl');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (18, 'Quality', 'Over-Time', '18', 'IADL Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in IADL function', 'Members who remained stable or demonstrated improvement in IADL function', 
    'All members', 'Missing or “activity did not occur” responses to any of the five variables on the most recent or previous assessment
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: IADL_PERFORMANCE_MEALS, IADL_PERFORMANCE_HOUSEWORK, IADL_PERFORMANCE_MEDS,
IADL_PERFORMANCE_SHOPPING, and IADL_PERFORMANCE_TRANSPORT from the most recent and previous assessments.
IADL Stable or Improved is based on the sum of IADL_PERFORMANCE_MEALS, IADL_PERFORMANCE_HOUSEWORK,
IADL_PERFORMANCE_MEDS, IADL_PERFORMANCE_SHOPPING, and IADL_PERFORMANCE_TRANSPORT.
An increase of up to three, the same, or a decrease in the IADL composite from the previous to the most recent assessment is considered
stable or improved (numerator compliant). However, an IADL composite of 30 (maximum) on both assessments is not considered stable or
improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'IADL_PERFORMANCE_MEALS, IADL_PERFORMANCE_HOUSEWORK, IADL_PERFORMANCE_MEDS,
IADL_PERFORMANCE_SHOPPING, and IADL_PERFORMANCE_TRANSPORT', 'pot_iadl');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, MSR_TOKEN)
 Values
   (19, 'Quality', 'Over-Time', '19', 'Cognition Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in
cognition', 'Members who remained stable or demonstrated improvement in cognition', 
    'All members', 'Missing response on the most recent or previous assessment
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: CPS2 scale from the most recent and previous assessments.
The CPS2 is a composite measure of cognitive skills for daily decision making, short-term memory, procedural memory, making self understood,
and how eats and drinks.
See Appendix A for more information on the CPS2 algorithm.
The same or a decrease in the CPS2 score from the previous to the most recent assessment is considered stable or improved (numerator
compliant). However, a CPS2 score of 6 (maximum) on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'pot_cognitive');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (34, 'Satisfaction', 'Prevalence', '34', 'Rating of Health Plan', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated their managed long-term care plan as good or
excellent', 'Members who rated their managed long-term care plan as good or excellent', 
    'All members surveyed', 'Missing response', '2014 Satisfaction Survey question used: 15 - Overall, how would you rate your managed long-term care plan?
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (35, 'Satisfaction', 'Prevalence', '35', 'Rating of Dentist', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the quality of dental services within the last six
months as good or excellent', 'Members who rated the quality of dental services within the last six months as good
or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 17 - Quality of your Care Providers: Dentist.
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (1, 'Quality', 'Prevalence', '1', 'Hospital Admission or Emergency Room Visit', 
    TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who had at least one hospital admission or emergency room
visit in the last 90 days', 'Members who had at least one hospital admission or emergency room visit in the last
90 days', 
    'All members', 'Missing response for both variables
Initial assessments and nursing home residents', 'UAS Variables Used: TX_INPATIENT and TX_EMERGENCY.
A lower rate of performance is better.', 'TX_INPATIENT and TX_EMERGENCY', 'hosp_er');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (2, 'Quality', 'Prevalence', '2', 'Hospital Admissions', 
    TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who had at least one hospital admission in the last 90 days', 'Members who had at least one hospital admission in the last 90 days', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: TX_INPATIENT.
Assume 0 inpatient visits if TX_INPATIENT is missing.
A lower rate of performance is better.', 'TX_INPATIENT', 'inpatient');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (3, 'Quality', 'Prevalence', '3', 'No Emergency Room Visits', 
    TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who did not have an emergency room visit in the last 90 days', 'Members who did not have an emergency room visit in the last 90 days (or since last
assessment if less than 90 days)', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: TX_EMERGENCY.
Assume 0 ER visits if TX_EMERGENCY is missing.
A higher rate of performance is better.', 'TX_EMERGENCY', 'noER');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (4, 'Quality', 'Prevalence', '4', 'Nursing Home Admissions', 
    TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:21', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who used a nursing facility in the last 90 days', 'Members who used a nursing facility, for a reason other than respite, in the last 90', 
    'All members who did not reside in a nursing home on the current and prior assessment', 'Missing response for RESIDENCE_ASSESSMENT on the most recent or previous assessment
Nursing home response for RESIDENCE_ASSESSMENT on the most recent and previous assessment
Initial assessments and nursing home residents', 'UAS Variables Used: TX_NURSING and NH_RESPITE from the most recent assessment and RESIDENCE_ASSESSMENT from the most recent and
previous assessments.
A lower rate of performance is better.', 'TX_NURSING and NH_RESPITE,RESIDENCE_ASSESSMENT');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (5, 'Quality', 'Prevalence', '5', 'Falls', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who had any falls in the last 90 days', 'Members who had any falls in the last 90 days', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: FALLS.
A lower rate of performance is better.', 'FALLS.', 'falls');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (6, 'Quality', 'Prevalence', '6', 'No falls', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who did not have falls that required medical intervention in
the last 90 days', 'Members who did not have falls that required medical intervention in the last 90 days', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: FALLS_MEDICAL.
Assume 0 falls if FALLS_MEDICAL is missing.
A higher rate of performance is better.', 'FALLS_MEDICAL', 'nofalls');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (7, 'Quality', 'Prevalence', '7', 'Fracture', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who had a hip or other fracture in the last 30 days', 'Members who had a hip or other fracture in the last 30 days', 
    'All members', 'Missing responses for both items
Initial assessments and nursing home residents', 'UAS Variables Used: MUSCULOSKELETAL_HIP and MUSCULOSKELETAL_OTHER_FRACTURE.
A lower rate of performance is better.', 'MUSCULOSKELETAL_HIP and MUSCULOSKELETAL_OTHER_FRACTURE', 'fracture');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (8, 'Quality', 'Prevalence', '8', 'Impaired Locomotion No Device', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members with impaired locomotion who are not using an assistive device', 'Members who did not use an assistive device', 
    'Members with impaired locomotion on the previous assessment and not bedbound on
the current assessment', 'Bed-bound response on most recent assessment
Missing or “activity did not occur” response to ADL_LOCOMOTION on the previous assessment
Initial assessments and nursing home residents', 'UAS Variables Used: ADL_LOCOMOTION from the previous assessment and LOCOMOTION_INDOORS from the most recent assessment.
A lower rate of performance is better.', 'ADL_LOCOMOTION, OCOMOTION_INDOORS');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (9, 'Quality', 'Prevalence', '9', 'Did Not Go out but Used To', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who did not go out but used to', 'Members who did not go out in the last 3 days', 
    'Members who did go out or usually did go out over a 3-day period on the previous
assessment', 'Missing or “no days out” response on the previous assessment
Missing response on the most recent assessment
Initial assessments and nursing home residents', 'UAS Variables Used: DAYS_OUTDOORS from the most recent and previous assessments.
A lower rate of performance is better.', 'DAYS_OUTDOORS');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (10, 'Descriptive', 'Prevalence', '10', 'Medication Administration', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who managed their medications independently', 'Members who managed their medications independently', 
    'All members', 'Missing response', 'UAS Variables Used: IADL_PERFORMANCE_MEDS. A higher rate of performance indicates greater independence', 'IADL_PERFORMANCE_MEDS', 'adlmeds');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (11, 'Quality', 'Prevalence', '11', 'Pain Controlled', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who did not experience uncontrolled pain', 'Members who did not experience uncontrolled pain', 
    'All members', 'Missing response for either variable
Initial assessments and nursing home residents', 'UAS Variables Used: PAIN_FREQUENCY and PAIN_CONTROL.
Pain frequency indicating pain (1, 2, 3) with pain control indicating uncontrolled (3, 4, 5) are not numerator compliant.
A higher rate of performance is better.', 'PAIN_FREQUENCY and PAIN_CONTROL', 'paincontrol');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (12, 'Quality', 'Prevalence', '12', 'No Severe Daily Pain', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who did not experience severe or more intense pain daily', 'Members who did not experience severe or excruciating pain daily or on 1-2 days over
the last 3 days', 
    'All members', 'Missing response to both variables
Initial assessments and nursing home residents', 'UAS Variables Used: PAIN_FREQUENCY and PAIN_INTENSITY.
A higher rate of performance is better.', 'PAIN_FREQUENCY and PAIN_INTENSITY', 'noseverepain');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (13, 'Quality', 'Prevalence', '13', 'Not Lonely or Not Distressed', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who were not lonely or were not distressed', 'Members who were not lonely or did not experience any of the following: decline in
social activities, eight or more hours alone during the day, major life stressors, selfreported
depression, or withdrawal from activities', 
    'All members', 'Missing response to lonely variable
Initial assessments and nursing home residents', 'UAS Variables Used: LONELY, SOCIAL_CHANGE_ACTIVITIES, TIME_ALONE, LIFE_STRESSORS, MOOD_SAD, and WITHDRAWAL.
A higher rate of performance is better.', 'LONELY, SOCIAL_CHANGE_ACTIVITIES, TIME_ALONE, LIFE_STRESSORS, MOOD_SAD, and WITHDRAWAL', 'notlonely');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (14, 'Quality', 'Prevalence', '14', 'Weight Loss', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who had weight loss of 5% or more in last 30 days, or 10% or
more in last 180 days', 'Members who had weight loss of 5% or more in last 30 days, or 10% or more in last
180 days', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: WEIGHT_LOSS.
A lower rate of performance is better.', 'WEIGHT_LOSS', 'weightloss');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (20, 'Quality', 'Over-Time', '20', 'Communication Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who remained stable or demonstrated improvement in communication', 'Members who remained stable or demonstrated improvement in communication', 
    'All members', 'Missing response to either variable on the most recent or previous assessment
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: SELF_UNDERSTOOD and UNDERSTAND_OTHERS from the most recent and previous assessments.
The same or a decrease in the sum of self_understood and understand_others from the previous to the most recent assessment is considered
stable or improved (numerator compliant). However, a response of “Rarely or never understood” for self_understood and Rarely or never
understands for understand_others on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'SELF_UNDERSTOOD and UNDERSTAND_OTHERS', 'pot_understood');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, MSR_TOKEN)
 Values
   (21, 'Quality', 'Over-Time', '21', 'Pain Intensity Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in pain
intensity', 'Members who remained stable or demonstrated improvement in pain intensity', 
    'All members', 'Missing response for both variables on the most recent or previous assessment
Missing response for PAIN_INTENSITY and a response other than no pain for PAIN_FREQUENCY from the most recent or previous assessment
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'Separately for the most recent and previous assessment, construct the following pain scale: If pain_frequency or pain_intensity is “No pain”
then the pain scale is equal to 0. Otherwise, the pain scale is equal to pain_intensity.
The same or a decrease in pain scale from the previous to most recent assessment is considered stable or improved (numerator compliant).
However, a score of 4 (maximum) on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'pot_pain');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, MSR_TOKEN)
 Values
   (22, 'Quality', 'Over-Time', '22', 'Mood Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in mood', 'Members who remained stable or demonstrated improvement in mood', 
    'All members', 'Exclude if the most recent or previous assessment is:
Missing 3 or more of the assessed mood variables or missing all 10 of the assessed and self-reported mood variables
Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent', 'Separately for the most recent and previous assessment, construct the following:
a. Assessed mood scale: Recode negative_statements, persistent_anger, unreal_fears, health_complaints, anxious_complaints, sad_facial,
crying (0 = 0, 1 or 2 = 1, 3 = 2, 8 = missing), and sum recoded variables. Set values greater than 5 to 5, and set to missing if 3 or more of the 7
variables are missing.
b. Self-reported mood scale: Recode mood_interest, mood_anxious, mood_sad (0 = 0, 1 or 2 = 1, 3 = 2, 8 = missing) and sum recoded variables.
Set values greater than 3 to 3.
c. Mood scale: Set to the higher value of assessed mood scale or self-reported mood scale.
The same or a decrease in mood scale from the previous to most recent assessment is considered stable or improved (numerator compliant).
However, a score of 5 (maximum) on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'pot_mood');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (23, 'Quality', 'Over-Time', '23', 'Nursing Facility Level of Care Score Stable or Improved', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who remained stable or demonstrated improvement in NFLOC
score', 'Members who remained stable or demonstrated improvement in NFLOC score', 
    'All members', 'Initial assessments and nursing home residents on the most recent assessment
Members that did not have between 6-13 months of consecutive capitation payments to the same plan between the previous and most recent
assessment', 'UAS Variables Used: LEVEL_OF_CARE_SCORE from the most recent and previous assessments.
An increase of up to four, the same, or a decrease in the NFLOC from the previous to the most recent assessment is considered stable or
improved (numerator compliant). However, a NFLOC score of 48 (maximum) on both assessments is not considered stable or improved.
To create the cohort for over-time measures: (1) Use the most recent assessment in the current time period (e.g. January-June of the current
year); (2) Link back to the most recent assessment in the base-year time period (e.g. January-June of the prior year); (3) If an assessment is not
found in the base-year time period, look for the most recent assessment in the mid-year time period (e.g. July-December of the prior year).
A higher rate of performance is better.', 'EVEL_OF_CARE_SCORE', 'pot_nfloc');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (36, 'Satisfaction', 'Prevalence', '36', 'Rating of Care Manager', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the quality of care manager/case manager services
within the last six months as good or excellent', 'Members who rated the quality of care manager/case manager services within the last
six months as good or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 21 - Quality of your Care Providers: Care Manager/Case Manager (person who prepares your plan of
care).
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (37, 'Satisfaction', 'Prevalence', '37', 'Rating of Regular Visiting Nurse', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the quality of regular visiting nurse/registered
nurse services within the last six months as good or excellent', 'Members who rated the quality of regular visiting nurse/registered nurse services
within the last six months as good or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 22a - Quality of your Care Providers: Regular Visiting Nurse/Registered Nurse (comes to your house for
regular visits).
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (38, 'Satisfaction', 'Prevalence', '38', 'Rating of Home Health Aide', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the quality of home health aide/personal care
aide/personal assistant services within the last six months as good or excellent', 'Members who rated the quality of home health aide/personal care aide/personal
assistant services within the last six months as good or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 20a - Quality of your Care Providers: Home Health AIDE, Personal Care AIDE, Personal Assistant (aide
that comes to your house to take care of you).
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (39, 'Satisfaction', 'Prevalence', '39', 'Rating of Transportation Services', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the quality of transportation services within the last
six months as good or excellent', 'Members who rated the quality of transportation services within the last six months as
good or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 32 - Quality of your Care Providers: Transportation Services.
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (40, 'Satisfaction', 'Prevalence', '40', 'Timeliness of Home Health Aide', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who reported that within the last six months the home health
aide/personal care aide/personal assistant services were usually or always on time', 'Members who reported that within the last six months the home health aide/personal
care aide/personal assistant services were usually or always on time', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 36 - Timeliness: Home Health Aide, Personal Care Aide, Personal Assistant (aide that comes to your
house to take care of you).
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (41, 'Satisfaction', 'Prevalence', '41', 'Timeliness Composite', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who reported that within the last six months the home health
aide/personal care aide/personal assistant, care manager/case manager, regular visiting
nurse/registered nurse, or covering/on-call nurse services were usually or always on time', 'Members who reported that within the last six months the home health aide/personal
care aide/personal assistant, care manager/case manager, regular visiting
nurse/registered nurse, or covering/on-call nurse services were usually or always
on time', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey questions used:
36. Timeliness: Home Health Aide, Personal Care Aide, Personal Assistant (aide that comes to your house to take care of you).
37. Timeliness: Care Manager/Case Manager (person who prepares your plan of care).
38a. Timeliness: Regular Visiting Nurse/Registered Nurse (comes to your house for regular visits).
38b. Timeliness: Covering/On-call Nurse (comes to your house when your regular nurse cant come).
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (42, 'Quality', 'Prevalence', '42', 'Access to Routine Dental Care', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who reported that within the last six months they always got a routine
dental appointment as soon as they thought they needed', 'Members who reported that within the last six months they always got a routine
dental appointment as soon as they thought they needed', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 54 - Access, regular appointment: Dentist.
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (43, 'Quality', 'Prevalence', '43', 'Same Day Urgent Dental Care', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who reported that within the last six months they had same day access to
urgent dental care', 'Members who reported that within the last six months they had same day access to
urgent dental care', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 49 - Access, needed care right away: Dentist.
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (44, 'Quality', 'Prevalence', '44', 'Document Appointing for Health Decisions', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who responded that they have a legal document appointing someone to
make decisions about their health care if they are unable to do so', 'Members who responded that, yes, they have a legal document appointing someone
to make decisions about their health care if they are unable to do so', 
    'All members surveyed', 'Missing or “Not sure” response', '2014 Satisfaction Survey question used: 72 - Do you have a legal document appointing someone to make decisions about your health care if
you are unable to do so?
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (45, 'Quality', 'Prevalence', '45', 'Plan has Document Appointing for Health Decisions', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who responded that their health plan has a copy of their legal document
appointing someone to make decisions about their health care if they are unable to do so', 'Members who responded that, yes, their health plan has a copy of their legal
document appointing someone to make decisions about their health care if they are
unable to do so', 
    'All members surveyed who responded that, yes, they have a legal document
appointing someone to make decisions about their health care', 'Missing or “Not sure” response to either question', '2014 Satisfaction Survey questions used:
72 - Do you have a legal document appointing someone to make decisions about your health care
if you are unable to do so?
73 - Does the health plan have a copy of this document?
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (46, 'Satisfaction', 'Prevalence', '46', 'Involved in Decisions', 
    TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:22', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who responded that they are usually or always involved in
making decisions about their plan of care', 'Members who responded that they are usually or always involved in making
decisions about their plan of care', 
    'All members surveyed', 'Missing or “Don’t know or not sure” response', '2014 Satisfaction Survey question used: 4 - Are you involved in making decisions about your plan of care?
A higher rate of performance is better');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (60, 'Descriptive', 'Prevalence', '60', 'Living Alone', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who lived alone', 'Members who lived alone', 
    'All members', 'Missing response', 'UAS Variables Used: LIVING_ARRANGEMENT. A higher rate of performance indicates greater independence.', 'LIVING_ARRANGEMENT', 'livingarr');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (61, 'Descriptive', 'Prevalence', '61', 'No Anxious Feelings', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who reported no anxious, restless, or uneasy feelings', 'Members who reported no anxious, restless, or uneasy feelings', 
    'All members', 'Missing or person could not (would not) respond response', 'UAS Variables Used: MOOD_ANXIOUS. A higher rate of performance indicates less care need.', 'MOOD_ANXIOUS', 'anxious');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (62, 'Descriptive', 'Prevalence', '62', 'No Depressive Feelings', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who reported no sad, depressed, or hopeless feelings', 'Members who reported no sad, depressed, or hopeless feelings', 
    'All members', 'Missing or person could not (would not) respond response', 'UAS Variables Used: MOOD_SAD. A higher rate of performance indicates less care need.', 'MOOD_SAD', 'depressed');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (63, 'Descriptive', 'Prevalence', '63', 'Urinary Continence', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who were continent, had control with any catheter or ostomy, or were infrequently incontinent of urine', 'Members who were continent, had control with any catheter or ostomy, or were infrequently incontinent of urine over last 3 days', 
    'All members', 'Missing or did not occur - no urine output from bladder in last 3 days response', 'UAS Variables Used: BLADDER_CONTINENCE. A higher rate of performance indicates less care need.', 'BLADDER_CONTINENCE', 'urinary');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (64, 'Quality', 'Prevalence', '64', 'Dental Exam', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who received a dental exam in the last year', 'Members who received a dental exam in the last year', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: TX_DENTAL
A higher rate of performance is better.', 'TX_DENTAL', 'dental');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (65, 'Quality', 'Prevalence', '65', 'Eye Exam', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who received an eye exam in the last year', 'Members who received an eye exam in the last year', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: TX_EYE
A higher rate of performance is better.', 'TX_EYE', 'eye');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (66, 'Quality', 'Prevalence', '66', 'Hearing Exam', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who received a hearing exam in the last two years', 'Members who received a hearing exam in the last two years', 
    'All members', 'All membersMissing response
Initial assessments and nursing home residents', 'UAS Variables Used: TX_HEARING
A higher rate of performance is better.', 'TX_HEARING', 'hearing');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (67, 'Quality', 'Prevalence', '67', 'Mammogram', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of female members ages 50-74, who received a mammogram or breast exam in the last
two years', 'Female members ages 50-74 who received a mammogram or breast exam in the last 2
years', 
    'All female members ages 50-74', 'Missing response
Members below the age of 50 and above the age of 74
Initial assessments and nursing home residents', 'UAS Variables Used: TX_MAMMOGRAM
A higher rate of performance is better.', 'TX_MAMMOGRAM', 'mammogram');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (68, 'Quality', 'Prevalence', '68', 'No Shortness of Breath', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who did not experience shortness of breath', 'Members who did not experience shortness of breath', 
    'All members', 'Missing response
Initial assessments and nursing home residents', 'UAS Variables Used: DYSPNEA
A higher rate of performance is better.', 'DYSPNEA', 'dyspnea');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (69, 'Quality', 'Prevalence', '69', 'Pneumococcal Vaccination', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members age 65 or older, who received a pneumococcal vaccination in the last five
years or after age 65', 'Members age 65 or older who received a pneumococcal vaccine in the last 5 years or
after age 65', 
    'All members age 65 and over', 'Missing response
Members below the age of 65
Initial assessments and nursing home residents', 'UAS Variables Used: TX_PNEUMOVAX
A higher rate of performance is better.', 'TX_PNEUMOVAX', 'pneumovax');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (70, 'Quality', 'Prevalence', '70', 'Potentially Avoidable Hospitalizations', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted rate of potentially avoidable hospitalizations (PAH) that occur for each 10,000 member
days that a plan accumulates', 'Total number of potentially avoidable hospitalizations', 
    'Total number of member days', 'Nursing home residents
Members indicating an end stage disease on the UAS-NY assessment
Members enrolled in a MLTC plan for less than 4 continuous months', 'A PAH is considered any primary diagnoses of respiratory infection, urinary tract infection, congestive heart failure, anemia, sepsis, or
electrolyte imbalance.
A lower rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (71, 'Utilization', 'Statewide Prevalence', '71', 'Emergency Room Visits', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Count and percentage of members who had at least one emergency room visit within the last 90
days (or since last assessment if less than 90 days)', 'Members who had at least one emergency room visit within the last 90 days (or since
last assessment if less than 90 days)', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: TX_EMERGENCY.
Assume 0 ER visits if TX_EMERGENCY is missing.
Of those admitted the emergency room, the five most frequent reasons for the emergency room visit are presented.
A lower rate of performance is better.', 'TX_EMERGENCY');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (72, 'Utilization', 'Statewide Prevalence', '72', 'Hospital Admissions', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Count and percentage of members who had at least one hospital admission within the last 90 days
(or since last assessment if less than 90 days)', 'Members who had at least one hospital admission within the last 90 days (or since last
assessment if less than 90 days)', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: TX_INPATIENT.
Assume 0 hospital visits if TX_INPATIENT is missing.
Of those admitted to a hospital, the five most frequent reasons for the hospital admission are presented.
A lower rate of performance is better.', 'TX_INPATIENT');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE)
 Values
   (73, 'Utilization', 'Statewide Prevalence', '73', 'Nursing Home Admissions', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Count and percentage of members who had at least one nursing home admission within the last 90
days (or since last assessment if less than 90 days)', 'Members who had at least one nursing home admission within the last 90 days (or
since last assessment if less than 90 days)', 
    'All members', 'Initial assessments and nursing home residents', 'UAS Variables Used: TX_NURSING.
Assume 0 nursing home admissions if TX_NURSING is missing.
Of those admitted to a nursing home, the five most frequent reasons for the nursing home admission are presented.
A lower rate of performance is better.', 'TX_NURSING');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (47, 'Quality', 'Prevalence', '47', 'Plan Asked to See Medicines', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who responded that since they joined this health plan, someone from the
health plan asked to see all of the prescriptions and over the counter medicines they’ve been taking', 'Members who responded that, yes, since they joined this health plan, someone from
the health plan asked to see all of the prescriptions and over the counter medicines
they’ve been taking', 
    'All members surveyed', 'Missing or “Don’t know or not sure” response', '2014 Satisfaction Survey question used: 12 - Since you joined this health plan, did someone from the health plan ask to see all of the
prescriptions and over the counter medicines you have been taking?
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (48, 'Satisfaction', 'Prevalence', '48', 'Manage Illness', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Risk-adjusted percentage of members who rated the helpfulness of the plan in assisting them and
their family to manage their illnesses as good or excellent', 'Members who rated the helpfulness of the plan in assisting them and their family to
manage their illnesses as good or excellent', 
    'All members surveyed', 'Missing or “Not applicable” response', '2014 Satisfaction Survey question used: 14b. Please rate how helpful your plan has been in assisting you and your family with the following:
Manage your illnesses, such as high blood pressure or diabetes.
A higher rate of performance is better.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS)
 Values
   (49, 'Descriptive', 'Mean', '49', 'Nursing Facility Level of Care (NFLOC)', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Average NFLOC score', 'Sum of NFLOC score of all members', 
    'Count of all members', 'Missing NFLOC score', 'NFLOC scoring index is a composite measure of overall functioning that includes ADL functional status, continence, cognition, and behavior.
Average NFLOC score on a scale of 0-48 is presented. Zero represents the highest level of functioning.
A lower average indicates greater independence.');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (50, 'Descriptive', 'Prevalence', '50', 'ADL bathing', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who took a full-body bath/shower independently, with setup help, or under
supervision.', 'Members who took a full-body bath/shower independently, with setup help only, or
under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_BATHING
A higher rate of performance indicates greater independence.', 'ADL_BATHING', 'bathing');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (51, 'Descriptive', 'Prevalence', '51', 'ADL dress lower', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who dressed and undressed their lower body independently, with setup
help, or under supervision', 'Members who dressed and undressed their lower body independently, with setup help
only, or under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UASUAS Variables Used: ADL_DRESS_LOWER
A higher rate of performance indicates greater independence.', 'ADL_DRESS_LOWER', 'dresslower');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (52, 'Descriptive', 'Prevalence', '52', 'ADL dress upper', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who dressed and undressed their upper body independently, with setup
help, or under supervision', 'Members who dressed and undressed their upper body independently, with setup
help only, or under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_DRESS_UPPER
A higher rate of performance indicates greater independence', 'ADL_DRESS_UPPER', 'dressupper');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (53, 'Descriptive', 'Prevalence', '53', 'ADL eating', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who ate and drank (including intake of nutrition by other means)
independently or with setup help only', 'Members who ate and drank (including intake of nutrition by other means)
independently or with setup help only', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_EATING
A higher rate of performance indicates greater independence.', 'ADL_EATING', 'eating');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (54, 'Descriptive', 'Prevalence', '54', 'ADL locomotion', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who moved between locations on the same floor independently, with setup
help, or under supervision', 'Members who moved between locations on same floor independently, with setup help
only, or under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_LOCOMOTION
A higher rate of performance indicates greater independence.', 'ADL_LOCOMOTION', 'locomotion');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (55, 'Descriptive', 'Prevalence', '55', 'ADL toilet transfer', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who moved on and off the toilet or commode independently, with setup
help, or under supervision', 'Members who moved on and off the toilet or commode independently, with setup
help only, or under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_TOILET_TRANSFER
A higher rate of performance indicates greater independence.', 'ADL_TOILET_TRANSFER', 'toilettransfer');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (56, 'Descriptive', 'Prevalence', '56', 'ADL toilet use', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who used the toilet room (or commode, bedpan, urinal) independently, with
setup help, or under supervision', 'Members who used the toilet room (or commode, bedpan, urinal) independently, with
setup help only, or under supervision', 
    'All members', 'Missing or activity did not occur - during entire period response', 'UAS Variables Used: ADL_TOILET_USE
A higher rate of performance indicates greater independence.', 'ADL_TOILET_USE', 'toiletuse');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (57, 'Descriptive', 'Prevalence', '57', 'Behavior', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who did not have any behavior symptoms', 'Members who did not have any behavior symptoms (wandering, verbally abusive,
physically abusive, socially inappropriate/disruptive, inappropriate public sexual
behavior/disrobing, or resisting care)', 
    'All members', 'Missing response for all variables used', 'UAS Variables Used: BEHAVIOR_WANDERING, BEHAVIOR_VERBAL, BEHAVIOR_PHYSICAL, BEHAVIOR_DISRUPTIVE, BEHAVIOR_SEXUAL,
BEHAVIOR_RESISTS. A higher rate of performance indicates less care need.', 'BEHAVIOR_WANDERING, BEHAVIOR_VERBAL, BEHAVIOR_PHYSICAL, BEHAVIOR_DISRUPTIVE, BEHAVIOR_SEXUAL,
BEHAVIOR_RESISTS', 'behavioral');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (58, 'Descriptive', 'Prevalence', '58', 'Bowel Continence', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members who were continent, had bowel control with ostomy, or were infrequently
incontinent of feces', 'Members who were continent, had bowel control with ostomy, or were infrequently
incontinent of feces over last 3 days', 
    'All members', 'Missing or did not occur - no bowel movement in last 3 days response', 'UAS Variables Used: BOWEL_CONTINENCE
A higher rate of performance indicates less care need.', 'BOWEL_CONTINENCE', 'bowel');
Insert into DIM_QUALITY_MEASURES
   (MSR_ID, MSR_GRP_2, MSR_TYPE, MEASURE#, MEASURE_NAME, 
    EFF_START_DATE, EFF_END_DATE, SOURCE, DEFINATION, NUMERATOR, 
    DENOMINATOR, EXCLUSIONS, COMMENTS, UAS_VARIABLE, MSR_TOKEN)
 Values
   (59, 'Descriptive', 'Prevalence', '59', 'Cognitive Functioning', 
    TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('01/12/2017 11:57:23', 'MM/DD/YYYY HH24:MI:SS'), 'UAS-NY', 'Percentage of members whose Cognitive Performance Scale 2 (CPS2) indicated intact functioning', 'Members whose Cognitive Performance Scale 2 (CPS2) indicated intact functioning', 
    'All members', 'Missing response for any variable used', 'The CPS2 is a composite measure of cognitive skills for daily decision making, short-term memory, procedural memory, making self understood,', ' ', 'cognitive');
COMMIT;



Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (3, 'noER', 2015, 89.9, 89.9, 
    91.4, 93.3, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (6, 'nofalls', 2015, 93.9, 93.9, 
    95.1, 95.4, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (11, 'paincontrol', 2015, 81.5, 81.5, 
    84.8, 90.1, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (13, 'notlonely', 2015, 96.4, 96.4, 
    89.3, 91.2, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (15, 'fluvax', 2015, 78, 78, 
    81.5, 84.3, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (21, 'pot_pain', 2015, 82.1, 82.1, 
    84.9, 86.2, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (23, 'pot_nfloc', 2015, 83, 83, 
    86.7, 88.7, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (31, 'pot_urinary', 2015, 73.6, 73.6, 
    76.3, 77.4, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (32, 'pot_dyspnea', 2015, 85.1, 85.1, 
    87.9, 92, 1);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (3, 'noER', 2016, 91, 91, 
    93, 95.1, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (6, 'nofalls', 2016, 94, 94, 
    95, 96, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (11, 'paincontrol', 2016, 85, 85, 
    90, 95.2, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (13, 'notlonely', 2016, 90, 90, 
    92.5, 95.2, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (15, 'fluvax', 2016, 78, 78, 
    82, 85, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (21, 'pot_pain', 2016, 86, 86, 
    89, 90, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (23, 'pot_nfloc', 2016, 84.5, 84.5, 
    88, 90, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (31, 'pot_urinary', 2016, 75, 75, 
    78.25, 81, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (32, 'pot_dyspnea', 2016, 87.5, 87.5, 
    90.25, 93, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (3, 'noER', 2017, 91, 91, 
    93, 95.1, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (6, 'nofalls', 2017, 94, 94, 
    95, 96, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (11, 'paincontrol', 2017, 85, 85, 
    90, 95.2, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (13, 'notlonely', 2017, 90, 90, 
    92.5, 95.2, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (15, 'fluvax', 2017, 78, 78, 
    82, 85, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (21, 'pot_pain', 2017, 86, 86, 
    89, 90, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (23, 'pot_nfloc', 2017, 84.5, 84.5, 
    88, 90, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (31, 'pot_urinary', 2017, 75, 75, 
    78.25, 81, 0);
Insert into DIM_QUALITY_MEASURE_THRESHOLD
   (MSR_ID, MEASURE_SHORT, YEAR_ID, TARGET, PERCENTILE_50TH, 
    PERCENTILE_75TH, PERCENTILE_90TH, IS_FINAL)
 Values
   (32, 'pot_dyspnea', 2017, 87.5, 87.5, 
    90.25, 93, 0);
COMMIT;

Insert into DIM_QUALITY_MEASURE_CATEGORY
   (QUAL_CATEGORY_ID, QUAL_CATEGORY_DESC)
 Values
   (1, 'ALL QUALITY MEASURES');
Insert into DIM_QUALITY_MEASURE_CATEGORY
   (QUAL_CATEGORY_ID, QUAL_CATEGORY_DESC)
 Values
   (2, 'QIP QUALITY MEASURES');
Insert into DIM_QUALITY_MEASURE_CATEGORY
   (QUAL_CATEGORY_ID, QUAL_CATEGORY_DESC)
 Values
   (3, 'STARS QUALITY MEASURES');
COMMIT;


Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (2, 'inpatient', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (5, 'falls', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (7, 'fracture', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (10, 'adlmeds', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (14, 'weightloss', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (18, 'pot_iadl', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (19, 'pot_cognitive', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (20, 'pot_understood', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (22, 'pot_mood', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (24, 'pot_locomotion', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (25, 'pot_bathing', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (26, 'pot_toilettransfer', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (27, 'pot_dressupper', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (28, 'pot_dresslower', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (29, 'pot_toiletuse', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (30, 'pot_eating', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (33, 'pot_managemeds', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (50, 'bathing', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (51, 'dresslower', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (52, 'dressupper', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (53, 'eating', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (54, 'locomotion', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (55, 'toilettransfer', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (56, 'toiletuse', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (57, 'behavioral', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (58, 'bowel', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (59, 'cognitive', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (60, 'livingarr', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (61, 'anxious', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (62, 'depressed', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (63, 'urinary', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (68, 'dyspnea', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 1, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 2, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 2, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 2, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 2, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 2, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (68, 'dyspnea', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 3, 2014);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (2, 'inpatient', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (5, 'falls', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (7, 'fracture', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (10, 'adlmeds', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (14, 'weightloss', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (18, 'pot_iadl', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (19, 'pot_cognitive', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (20, 'pot_understood', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (22, 'pot_mood', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (24, 'pot_locomotion', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (25, 'pot_bathing', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (26, 'pot_toilettransfer', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (27, 'pot_dressupper', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (28, 'pot_dresslower', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (29, 'pot_toiletuse', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (30, 'pot_eating', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (33, 'pot_managemeds', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (50, 'bathing', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (51, 'dresslower', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (52, 'dressupper', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (53, 'eating', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (54, 'locomotion', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (55, 'toilettransfer', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (56, 'toiletuse', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (57, 'behavioral', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (58, 'bowel', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (59, 'cognitive', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (60, 'livingarr', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (61, 'anxious', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (62, 'depressed', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (63, 'urinary', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (68, 'dyspnea', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 1, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 2, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 3, 2015);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (2, 'inpatient', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (5, 'falls', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (7, 'fracture', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (10, 'adlmeds', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (14, 'weightloss', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (18, 'pot_iadl', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (19, 'pot_cognitive', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (20, 'pot_understood', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (22, 'pot_mood', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (24, 'pot_locomotion', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (25, 'pot_bathing', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (26, 'pot_toilettransfer', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (27, 'pot_dressupper', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (28, 'pot_dresslower', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (29, 'pot_toiletuse', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (30, 'pot_eating', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (33, 'pot_managemeds', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (50, 'bathing', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (51, 'dresslower', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (52, 'dressupper', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (53, 'eating', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (54, 'locomotion', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (55, 'toilettransfer', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (56, 'toiletuse', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (57, 'behavioral', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (58, 'bowel', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (59, 'cognitive', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (60, 'livingarr', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (61, 'anxious', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (62, 'depressed', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (63, 'urinary', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (68, 'dyspnea', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 1, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 2, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 3, 2016);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (2, 'inpatient', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (5, 'falls', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (7, 'fracture', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (10, 'adlmeds', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (12, 'noseverepain', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (14, 'weightloss', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (18, 'pot_iadl', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (19, 'pot_cognitive', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (20, 'pot_understood', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (22, 'pot_mood', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (24, 'pot_locomotion', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (25, 'pot_bathing', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (26, 'pot_toilettransfer', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (27, 'pot_dressupper', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (28, 'pot_dresslower', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (29, 'pot_toiletuse', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (30, 'pot_eating', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (33, 'pot_managemeds', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (50, 'bathing', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (51, 'dresslower', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (52, 'dressupper', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (53, 'eating', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (54, 'locomotion', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (55, 'toilettransfer', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (56, 'toiletuse', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (57, 'behavioral', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (58, 'bowel', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (59, 'cognitive', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (60, 'livingarr', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (61, 'anxious', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (62, 'depressed', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (63, 'urinary', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (68, 'dyspnea', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 1, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (11, 'paincontrol', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (23, 'pot_nfloc', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 2, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (3, 'noER', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (6, 'nofalls', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (13, 'notlonely', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (15, 'fluvax', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (17, 'pot_adl', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (21, 'pot_pain', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (31, 'pot_urinary', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (32, 'pot_dyspnea', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (64, 'dental', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (65, 'eye', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (66, 'hearing', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (67, 'mammogram', 3, 2017);
Insert into DIM_QUALITY_MEASURE_CAT_MAPING
   (MSR_ID, MSR_TOKEN, QUAL_CATEGORY_ID, YEAR_ID)
 Values
   (69, 'pneumovax', 3, 2017);
COMMIT;
