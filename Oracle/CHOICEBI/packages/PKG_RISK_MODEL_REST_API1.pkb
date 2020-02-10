CREATE OR REPLACE package CHOICEBI.PKG_RISK_MODEL_REST_API1 AUTHID CURRENT_USER  
AS

    procedure f_process_risk_model_post_api_by_record_id;
    function f_process_risk_model_post_api_send_receive_production(p_mdl_sk number,p_mdl_vrsn_sk number default 2, p_in_production char,p_mdl_name varchar2, P_RECORD_JSON_BLOCK_SIZE number) return number;
    procedure f_process_risk_model_post_api_send_receive_history(p_mdl_sk number, p_in_production char, P_RECORD_JSON_BLOCK_SIZE number);
    procedure f_process_risk_model_post_api_update_strat_from_output;
end;
/


CREATE OR REPLACE package BODY CHOICEBI.PKG_RISK_MODEL_REST_API1
as
 
debug_flag boolean := true;

procedure f_process_risk_model_post_api_by_record_id is 
          
          v_mdl_version                     DIM_PRED_MDL_VRSN%rowtype;
          v_model_type_sk                   number; 
          v_d_prd_mdl_input_type_keep_history_ind                char;
          v_count_recs_to_be_processed      NUMBER;
          v_cnt_distinct_vrsn_thresh        NUMBER;
          x_last_vrsn_processed             number default null;
          v_count_mort_hist_processed       NUMBER;
          v_count_hosp_hist_processed       NUMBER;
          v_last_rec_set_processed          number;
          
          e_Model_Type_Error EXCEPTION;
          PRAGMA EXCEPTION_INIT( e_Model_Type_Error, -20001 );
          e_Version_Error    EXCEPTION;
          PRAGMA EXCEPTION_INIT( e_Version_Error,    -20002 );
          e_Thresh_Error     EXCEPTION;
          PRAGMA EXCEPTION_INIT( e_Thresh_Error,     -20003 );
            
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'pkg_risk.f_process_risk_model_post_api_by_record_id';
            v_num_rows_inserted number;
    begin
        
        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('begin f_process_risk_model_post_api_by_record_id proc :' || to_char(sysdate,'ddmmyyyy HH24:mi:ss'));

        -- Determine model type sk, keep history indicator
        --   (1) Verify that the UAS_Record_ID' model type is defined (if not, raise error and get out)
        --   (2) Verify that the keep_history_ind is 'N' or 'Y' (if not, raise error and get out)
        --     NOTE: if you use the special method of stopping this procedure (changing history_in to 'S' or 'C') 
        --           then this error will persist until you change back to a 'Y'  
        SELECT MDL_INPUT_TYPE_SK, KEEP_HISTORY_IND
        INTO v_model_type_sk, v_d_prd_mdl_input_type_keep_history_ind
        FROM DIM_PRED_MDL_INPUT_TYPE
        WHERE MDL_INPUT_TYPE_DESCR = 'UAS_Record_ID';
        
        CASE 
           WHEN v_model_type_sk is null or v_d_prd_mdl_input_type_keep_history_ind is null    THEN
                raise_application_error( -20001, 'Model Type SK must be >0 and Keep History Ind must be Y/N' );
           WHEN v_model_type_sk > 0 AND v_d_prd_mdl_input_type_keep_history_ind in ('N', 'Y') THEN
                if debug_flag then
                    xutl.OUT ('Model Type SK is ' || v_model_type_sk || ' Keep History Ind is ' || v_d_prd_mdl_input_type_keep_history_ind );
                end if;  
           ELSE 
                raise_application_error( -20001, 'Model Type SK must be >0 and Keep History Ind must be Y/N' );
        END CASE;
   
        for rec in (select * from DIM_PRED_MDL)
        loop 
            
            -- Check 'current_version' and 'last_version_processed' for MORTALITY model
            --    (if either one is null, then raise error and get out)
            begin
                select * into v_mdl_version from DIM_PRED_MDL_VRSN where mdl_sk = rec.mdl_sk and ACTIVE_IND = 'Y';
            exception
                when others then
                    xutl.out('Model ' || rec.mdl_name || ' cannot have more than one active version in DIM_PRED_MDL_VRSN table' || sqlerrm);
                    exit;
            end;
            IF  rec.CURRENT_MDL_VRSN is null or rec.LAST_VRSN_PROCESSED is null THEN
                raise_application_error( -20002, 'Current ' || rec.mdl_name || ' Version is invalid' );
            END IF;
                            
            if debug_flag then
                xutl.OUT ('Latest ' || rec.mdl_name || ' version processed is ' || rec.LAST_VRSN_PROCESSED || ' current ' || rec.mdl_name || ' version is ' || rec.CURRENT_MDL_VRSN );
            end if;
            
            -- Check that there is only one vrsn/thresh active for MORTALITY model
            --    (if there is more than one vrsn/thresh active, then raise error and get out)
            SELECT count(distinct(m3.mdl_thresh_vrsn))
            INTO v_cnt_distinct_vrsn_thresh
            FROM 
                   --DIM_PRED_MDL m1
            --INNER JOIN DIM_PRED_MDL_VRSN m2 on (m1.mdl_sk = m2.mdl_sk)
            --INNER JOIN DIM_PRED_MDL_THRESH_VRSN m3 on (m2.mdl_vrsn_sk = m3.mdl_vrsn_sk)
                DIM_PRED_MDL_THRESH_VRSN m3
            WHERE 
                --m2.ACTIVE_IND = 'Y'
                m3.mdl_vrsn_sk =  v_mdl_version.mdl_vrsn_sk
            AND m3.ACTIVE_IND = 'Y'
            --AND m1.mdl_sk = rec.mdl_sk;
                ;
                
            xutl.OUT ('Distinct Version / Thresh for ' || rec.mdl_name ||' (must be 1) =  ' || v_cnt_distinct_vrsn_thresh);
                
            IF  v_cnt_distinct_vrsn_thresh > 1 THEN
               raise_application_error( -20003, 'Cannot continue because there are multiple ' || rec.mdl_name ||' version/thresh ACTIVE at same time' );
               RETURN;
            END IF;

            -- The PRODUCTION loop 
            --    This is the loop that 
            --     (1) Determines if there are any new assessments to be processed that  
            --         HAVE NOT YET been processed (don't appear on the FACT_RISK_API_OUTPUT table yet) and
            --         HAVE VALID INFO on dw_owner.uas_communityhealth to be processed
            --     (2) Calls the procedure to do the HTTP send/receive for Production data
            v_count_recs_to_be_processed := 0;
            v_last_rec_set_processed := 0;
                
            LOOP
                    
                --- production selection criteria starts
                SELECT count(*) INTO v_count_recs_to_be_processed
                FROM choice.dim_member_assessments@dlake d
                WHERE dl_assess_sk not in (select mdl_input_id_numeric from FACT_RISK_API_OUTPUT where MDL_SK = rec.mdl_sk and mdl_vrsn_sk = v_mdl_version.mdl_vrsn_sk)  
                       AND EXISTS (SELECT record_id FROM dw_owner.uas_communityhealth a WHERE a.RECORD_ID = d.dl_assess_sk)
                       AND EXISTs (select 'X' from FACT_CCW_UAS f where d.dl_assess_sk = f.dl_assess_sk);
                                         
                 --Following check suggest if no reocrds to process or
                 --its same as previous run then break the loop and come out
                 if debug_flag then 
                    xutl.out(rec.mdl_name || ' - Records to be Processed :' || v_count_recs_to_be_processed  || ' - last records set processed :'  || v_last_rec_set_processed);
                 end if;
                 
                 if v_count_recs_to_be_processed = 0 or v_count_recs_to_be_processed = v_last_rec_set_processed then
                    xutl.OUT (rec.mdl_name || ' - Seem to be looping - sending same data to HTTP twice in a row' || v_count_recs_to_be_processed ||' - ' || v_last_rec_set_processed);
                    exit;
                 end if;    
                     
                --- production selection criteria ends
                ---  If any assessments remain to be processed, this will process the next 200 of them
                ---    (if more than 200 remain, then this loop will continue to process until done)
                 IF v_count_recs_to_be_processed > 0 THEN
                    if debug_flag then
                        xutl.OUT(rec.mdl_name || ' - Continuing to Process Production (Y), ' || v_count_recs_to_be_processed || ' more to go');
                    end if;
                    v_num_rows_inserted := f_process_risk_model_post_api_send_receive_production(rec.mdl_sk, v_mdl_version.mdl_vrsn_sk, 'Y', rec.mdl_name, rec.RECORD_JSON_BLOCK_SIZE);
                    --exit; --this is for test purpose to break after first run;                    
                 ELSE
                    xutl.OUT (rec.mdl_name || ' - No More Record IDs to Process for Production');   
                    EXIT; 
                 END IF;
                 v_last_rec_set_processed :=   v_count_recs_to_be_processed;

            END LOOP;    
                
            --  THIS LOOP IS THE LOOP FOR HISTORICALS (FOR HOSPITALIZATION ONLY) (which uses MODEL 6 in DIM_RISK_MODEL table):
            --  THIS WILL ONLY RUN IF THEY CHANGE THE VERSION for HOSPITALIZATION 
            --   (We would then be assessing the previously-assessed record ids, but now with 'N' in production column)
            --
            --    This is the loop that 
            --      Determines if we even WANT to keep history (keep_history_ind = 'Y') and 
            --         if we recognize that the model version they are running is new.
            --  
            --    The way we find them is to see if there are any assessments that are present with 'Y' in Production_ind
            --      for an older version that ARE NOT YET present with an 'N' in the indicator for the current version.
            --       
            --    Example:  To be eligible for process here, a record id would have already been processed as PRODUCTION (Y in Production Ind)
            --              in an earlier version, but does NOT YET have a corresponding HISTORY row ('N') for the current version.
            --
            --  Just like in the Production loop, first we determine if there ARE any record_ids to process
            --   If so, then this will loop and process 25 rows at a time until done
            --    by calling the procedure to do the HTTP send/receive for Historical data  (the 'H' parm is for HOSPITALIZATION)
            
            
            xutl.out(rec.mdl_name || ' - Checking for History data to process or not : ' || v_d_prd_mdl_input_type_keep_history_ind  || ' - ' || rec.CURRENT_MDL_VRSN || ' - ' || v_mdl_version.MDL_VRSN);
            v_count_hosp_hist_processed := 0;
            IF   v_d_prd_mdl_input_type_keep_history_ind = 'Y' and (rec.CURRENT_MDL_VRSN != v_mdl_version.MDL_VRSN) THEN
                  LOOP
                      SELECT count(*)
                        INTO v_count_recs_to_be_processed
                        FROM choice.dim_member_assessments@dlake d
                       WHERE dl_assess_sk in 
                         (
                          SELECT mdl_input_id_numeric
                            FROM FACT_RISK_API_OUTPUT a1 
                           inner join DIM_PRED_MDL_VRSN b1 on (a1.mdl_vrsn_sk = b1.mdl_vrsn_sk)
                           WHERE a1.prod_ind = 'Y' and a1.mdl_sk = rec.mdl_sk and MDL_INPUT_TYPE_SK = 1 and b1.mdl_vrsn < (SELECT CURRENT_MDL_VRSN FROM dim_pred_mdl a2 WHERE a2.mdl_sk = rec.mdl_sk)
                       MINUS
                          SELECT mdl_input_id_numeric
                            FROM FACT_RISK_API_OUTPUT a1
                            inner join DIM_PRED_MDL_VRSN b1 on (a1.mdl_vrsn_sk = b1.mdl_vrsn_sk)
                           WHERE a1.prod_ind = 'N' and a1.mdl_sk = rec.mdl_sk and MDL_INPUT_TYPE_SK = 1  and b1.mdl_vrsn = (SELECT CURRENT_MDL_VRSN  FROM dim_pred_mdl a2 WHERE a2.mdl_sk = rec.mdl_sk)
                          )     
                        ;  --and rownum <25;
                       IF v_count_recs_to_be_processed > 0 THEN
                           
                         if debug_flag then 
                            xutl.OUT (rec.mdl_name || ' - Continuing to Process History (N) for ' || rec.mdl_name  || ', ' || v_count_recs_to_be_processed || ' more to go');
                         end if;
                         --exit;-- This is test exit out so to prevent any history processing           
                         f_process_risk_model_post_api_send_receive_history(rec.mdl_sk, 'N', rec.RECORD_JSON_BLOCK_SIZE);
                         v_count_hosp_hist_processed := v_count_hosp_hist_processed + 1;
                       ELSE
                         xutl.OUT (rec.mdl_name || ' - No More Historical Record IDs to Process for '|| rec.mdl_name  || '');   
                         EXIT; 
                       END IF;              
                  END LOOP; 
           ELSE
              xutl.OUT (rec.mdl_name || ' - No Historical Record IDs to Process at this time for ' || rec.mdl_name  ||''); 
          END IF;
              
            --  If the MODEL HISTORICAL loop processed any data, 
            --    then update the DIM_PRED_MDL table with the 'LAST_VRSN_PROCESSED' for MODEL.
            if debug_flag then
                xutl.out(rec.mdl_name || ' - history records loop runs ' || v_count_hosp_hist_processed  || ' times');
            end if;
            
            if v_count_hosp_hist_processed > 0 THEN

                UPDATE DIM_PRED_MDL 
                SET    LAST_VRSN_PROCESSED = 
                (SELECT MAX(B.MDL_VRSN)
                    FROM  FACT_RISK_API_OUTPUT A
                    INNER JOIN  DIM_PRED_MDL_VRSN B ON (A.MDL_VRSN_SK = B.MDL_VRSN_SK)   
                    WHERE A.RUN_DT = 
                     (SELECT MAX(RUN_DT) 
                        FROM  FACT_RISK_API_OUTPUT 
                       WHERE  PROD_IND = 'N' 
                         AND A.mdl_sk = rec.mdl_sk)
                 )
                 WHERE mdl_sk = rec.mdl_sk;
                 
                 if debug_flag then
                    -- Display the updated info 
                    SELECT LAST_VRSN_PROCESSED INTO x_last_vrsn_processed FROM DIM_PRED_MDL WHERE MDL_NAME = rec.mdl_name;
                    xutl.out(rec.mdl_name || ' - last processed has been updated to: ' || x_last_vrsn_processed ); 
                 end if;
                     
            END IF;
        end loop;
        
       --  THE LAST PROCESS IS TO UPDATE THE STRAT ROWS 
       --   This will determine the appropiate version/thresh to calculate the PRED_STRAT from the PRED_VALUE    
        f_process_risk_model_post_api_update_strat_from_output; 
        commit;
 
EXCEPTION
    WHEN e_Model_Type_Error or e_Version_Error or e_Thresh_Error THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        RAISE;   
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

END; 

 
function f_process_risk_model_post_api_send_receive_production(p_mdl_sk number,p_mdl_vrsn_sk number, p_in_production char, p_mdl_name varchar2,P_RECORD_JSON_BLOCK_SIZE number) return number is 
 ----- CHUNKING the data written to HTTP and read back from HTTP
 ----- This will be called to send / receive data from HTTP for 'Y' Production runs (where we are scoring NEW)
 ----- It will send the same data (record ids) twice, once to get HOSPITALIZATION scores and once to get MORTALITY scores
 
        v_model_id                  number        DEFAULT NULL;
        v_in_production             char          DEFAULT NULL;
        v_model_req                 varchar2(100) DEFAULT NULL;
        
        TYPE ty_risk_model_tab IS TABLE OF DIM_PRED_MDL%ROWTYPE INDEX BY BINARY_INTEGER;
        v_model ty_risk_model_tab;
        
        V_MODEL_URL                 varchar2(4000) := '';
        --v_total_col_count           number;
        V_MODEL_SQL                 clob;
  
        TYPE CurTyp IS REF CURSOR;
        my_cv   CurTyp; 
        
        v_request                   utl_http.req;
        v_response                  utl_http.resp;
        v_content                   CLOB;
        v_response_content          CLOB;
        v_output_processing_sql     clob;
        v_model_name                varchar2(4000);
        
        V_write_buffer              VARCHAR2(32000);
        V_read_buffer               VARCHAR2(32767);
        V_buffers_of_data_cnt       number;
        V_buffers_written_cnt       number; 
        V_buffers_remain_cnt        number;
        V_num_chunks_in             number;        
        V_response_text             CLOB;
        eob                         boolean; 
        V_num_chars_to_clear        number;    
        
        v_output_details_seq        number; 
        v_model_type_sk             number; 
        v_last_run_input_parameter  CLOB;
  
        x_keep_history_ind  CHAR;
   
        x_current_mdl_vrsn         number default null;

        e_Safety_Rollback_Exit   EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_Safety_Rollback_Exit,   -20101 );
        e_Safety_NoRollback_Exit EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_Safety_NoRollback_Exit, -20102 );
        e_500_Error_Exit         EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_500_Error_Exit,         -20103 );
        e_Loop_Error             EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_Loop_Error,             -20104 );
        
        v_numrowprocessed number;
        
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'pkg_risk.f_process_risk_model_post_api_send_receive_production';

    begin
        
        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.out('begin f_process_risk_model_post_api_send_receive_production proc :' || to_char(sysdate,'ddmmyyyy HH24:mi:ss'));
        --v_MODEL_ID      := p_model_id;  
        v_in_production := p_in_production;  
        v_MODEL_type_sk := 1;  

        --DBMS_LOB.FREETEMPORARY(V_response_text);
        DBMS_LOB.CREATETEMPORARY(V_response_text, TRUE);        
   
        -- Read Model data
        SELECT a.* INTO V_MODEL(1) FROM DIM_PRED_MDL a WHERE mdl_sk = p_mdl_sk AND ROWNUM = 1;
        
        v_model_url             := V_MODEL(1).MODEL_URL;
        v_model_sql             := V_MODEL(1).MODEL_IN_SQL;
        v_output_processing_sql := V_MODEL(1).MODEL_OUT_SQL;
        
        OPEN  my_cv for  v_model_sql USING p_mdl_sk, P_RECORD_JSON_BLOCK_SIZE;
        FETCH my_cv INTO V_content;
        CLOSE MY_cv;
        
        --- As Per Rushabh
        V_content := replace(V_content,'null','""');
        
        if debug_flag then  
            xutl.out(V_content);
        end if;
         
        /*
        -- THIS WAS ADDED TO PREVENT RUNAWAY LOOPING
        --  If it recognizes that it is sending the same exact block as last time, then get out -- determine what the issue is -- and start over
        -- **  need to comment this out if running for the very first time (will get no 'previous' data to check against)  **
        SELECT INPUT_PARAMETER INTO v_last_run_input_parameter FROM FACT_RISK_API_OUTPUT_DETAILS WHERE OUTPUT_DETAILS_SK = 
            (SELECT MAX(OUTPUT_DETAILS_SK) FROM FACT_RISK_API_OUTPUT_DETAILS);
        IF  (v_last_run_input_parameter = V_content) AND (v_last_run_input_parameter is not null AND V_content is not null) THEN
             --raise_application_error( -20104, 'Seem to be looping - sending same data to HTTP twice in a row' );
             xutl.OUT ('Seem to be looping - sending same data to HTTP twice in a row' );
             return;
        END IF;    
        */

       ---  ****************************************************
       ---  WHAT FOLLOWS HERE IS FOR HOSPITALIZATION ONLY --
       ---  ****************************************************
        v_request := utl_http.begin_request(v_model_url, 'POST','HTTP/1.1');
        utl_http.set_header(v_request, 'user-agent', 'mozilla/4.0'); 
        utl_http.set_header(v_request, 'content-type', 'application/json'); 
        utl_http.set_header(v_request, 'Transfer-Encoding', 'chunked' );

        V_buffers_of_data_cnt := ceil(LENGTH(v_content) / 32000);
        V_buffers_remain_cnt  := V_buffers_of_data_cnt;
        V_buffers_written_cnt := 0;
        
         -- Loop thru writing in 'chunks' of 32000 bytes each
        WHILE V_buffers_remain_cnt > 0
        LOOP
             BEGIN
               V_write_buffer := (substr(V_content, ((V_buffers_written_cnt * 32000) + 1), 32000));
               UTL_HTTP.WRITE_TEXT(V_request, V_write_buffer);
               V_buffers_written_cnt := V_buffers_written_cnt + 1;
               V_buffers_remain_cnt  := V_buffers_remain_cnt - 1;
             END;
        END LOOP;
         
        v_response := utl_http.get_response(v_request);
        
        --Loop thru reading in 'chunks' of 32000 bytes each
        V_num_chunks_in := 0;
        eob := false;   

        WHILE NOT(eob)
        LOOP
            BEGIN
              UTL_HTTP.READ_TEXT(V_response, V_read_buffer, 32000);
              IF  v_read_buffer is not null and length(v_read_buffer)>0 then
                  DBMS_LOB.WRITEAPPEND(V_RESPONSE_TEXT,LENGTH(V_read_buffer),V_read_buffer);
                  V_num_chunks_in := V_num_chunks_in + 1;
              END IF;
            exception when UTL_HTTP.END_OF_BODY then
                eob := true;
            END;
        END LOOP;
        
        if debug_flag then 
            xutl.out(V_response_text);
        end if;
        
        V_response_content := V_response_text;

        -- end of response
        utl_http.end_response(v_response);

        --------------------------------------------------------     
        -- process the details table for HOSPITALIZATION PRODUCTION  
        --------------------------------------------------------          
         IF substr(v_response_content,1,14)  = '{"error":["500' THEN 
            raise_application_error( -20103, 'Getting Error 500 from HTTP Server for '||P_MDL_NAME );
            return -1;
         END IF;
        
        
        
        v_output_details_seq := strat_details_seq.nextval;        

        DELETE FROM gtt_risk_model;
        INSERT INTO gtt_risk_model values (v_response_content);
        v_numrowprocessed := sql%rowcount;             
        xutl.OUT ('gtt_risk_model records processed ' || v_numrowprocessed);
        
        
        EXECUTE IMMEDIATE v_output_processing_sql using  'Y', v_output_details_seq, v_model_type_sk;
        v_numrowprocessed := sql%rowcount;
        xutl.OUT ('records processed ' || v_numrowprocessed);
                        
        INSERT INTO FACT_RISK_API_OUTPUT_DETAILS
        VALUES (v_output_details_seq, v_MODEL_ID,  v_model_name, v_content, v_response_content, sys_context('USERENV', 'OS_USER'), SYSDATE, sys_context('USERENV', 'OS_USER'), SYSDATE);
                        
        -- update with current version processed for HOSP
        UPDATE DIM_PRED_MDL 
            SET CURRENT_MDL_VRSN = 
             (SELECT MAX(B.MDL_VRSN)
                FROM  FACT_RISK_API_OUTPUT A
                INNER JOIN  DIM_PRED_MDL_VRSN B ON (A.MDL_VRSN_SK = B.MDL_VRSN_SK)   
                WHERE A.RUN_DT = 
                 (SELECT MAX(RUN_DT) 
                    FROM  FACT_RISK_API_OUTPUT 
                   WHERE  PROD_IND = 'Y' 
                     AND A.MDL_SK = p_mdl_sk))
          WHERE mdl_sk = p_mdl_sk  ;
          
        COMMIT;

        if debug_flag then
            --- display updated data
             SELECT CURRENT_MDL_VRSN INTO x_current_mdl_vrsn FROM DIM_PRED_MDL WHERE mdl_sk = p_mdl_sk;           
             xutl.OUT (P_MDL_NAME || ' current version has been updated to: ' || x_current_mdl_vrsn );  
        end if;      
          ---Removed whole block

         --- ********************************************
         ---      SPECIAL safety valve exit
         --- ********************************************
         --     I added this so I could stop the flow with out 'canceling' and causing HTTP to lose its place and get too many open connections.
         --     If you update the KEEP_HISTORY ind for UAS_Record_ID on the DIM_PRED_MDL_INPUT_TYPE table to 'R' or 'C' it will recognize it 
         --      here and end smoothly
         --     Remember to re-update it to 'Y' before re-starting or it will catch the error at the beginning of the main procedure
         
        SELECT KEEP_HISTORY_IND
        INTO x_keep_history_ind
        FROM DIM_PRED_MDL_INPUT_TYPE
        WHERE MDL_INPUT_TYPE_DESCR = 'UAS_Record_ID';
        
        IF   x_keep_history_ind = 'R' THEN 
           raise_application_error( -20101, 'Safety/Rollback Exit has been Invoked - ROLLING BACK to last commit' );
        ELSIF x_keep_history_ind = 'C' THEN 
           raise_application_error( -20102, 'Safety/NoRollback Exit has been Invoked - NO ROLLBACK' );
        END IF;
   
        return v_numrowprocessed;
EXCEPTION

    WHEN e_Safety_Rollback_Exit or e_Safety_NoRollback_Exit or e_500_Error_Exit or e_Loop_Error THEN 
        XUTL.OUT_E(sqlerrm);
        ROLLBACK;
        UTL_HTTP.END_RESPONSE(v_response); 
        RAISE;
        
    WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN 
         XUTL.OUT_E('getting out1 with end response  ') ;   
         UTL_HTTP.END_RESPONSE(v_response); 
         RAISE;
         
    WHEN UTL_HTTP.REQUEST_FAILED THEN
         XUTL.OUT_E('getting out2  with end response ') ;   
         UTL_HTTP.END_RESPONSE(v_response); 
         RAISE;
         
    WHEN OTHERS THEN
         XUTL.OUT_E(sqlerrm);
         utl_http.end_response(v_response);
         RAISE;
END; 

procedure f_process_risk_model_post_api_send_receive_history(p_mdl_sk number, p_in_production char, P_RECORD_JSON_BLOCK_SIZE number) is 
 ----- CHUNKING the data written to HTTP and read back from HTTP
 ----- This will be called to send / receive data from HTTP for 'Y' Production rus (where we are scoring NEW)
 ----- It will send the same data (record ids) twice, once to get HOSP and once to get MORT
 
        v_model_id                  number        DEFAULT NULL;
        v_in_production             char          DEFAULT NULL;
        --v_model_req                 varchar2(100) DEFAULT NULL;
        
        TYPE ty_risk_model_tab IS TABLE OF dim_pred_mdl%ROWTYPE INDEX BY BINARY_INTEGER;
        v_model ty_risk_model_tab;
        
        V_MODEL_URL                 varchar2(4000) := '';
        --v_total_col_count           number;
        V_MODEL_SQL                 clob;
  
        TYPE CurTyp IS REF CURSOR;
        my_cv   CurTyp; 
        
        v_request                   utl_http.req;
        v_response                  utl_http.resp;
        v_content                   CLOB;
        v_response_content          CLOB;
        v_output_processing_sql     clob;
        v_model_name                varchar2(4000);
        
        V_write_buffer              VARCHAR2(32000);
        V_read_buffer               VARCHAR2(32767);
        V_buffers_of_data_cnt       number;
        V_buffers_written_cnt       number; 
        V_buffers_remain_cnt        number;
        V_num_chunks_in             number;        
        V_response_text             CLOB;
        eob                         boolean; 
        
        v_output_details_seq        number; 
        v_model_type_sk             number; 
  
        x_keep_history_ind          CHAR;
        
        e_Safety_Rollback2_Exit EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_Safety_Rollback2_Exit, -20201 );
        e_Safety_NoRollback2_Exit EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_Safety_NoRollback2_Exit, -20202 );
        e_500_Error_Exit         EXCEPTION;
        PRAGMA EXCEPTION_INIT( e_500_Error_Exit,         -20203 );
  
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'pkg_risk.f_process_risk_model_post_api_send_receive_history';

    begin
        
        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.out('begin f_process_risk_model_post_api_send_receive_history proc :' || to_char(sysdate,'ddmmyyyy HH24:mi:ss'));
 
        v_in_production := p_in_production;  
        v_MODEL_type_sk := 1;  

        DBMS_LOB.CREATETEMPORARY(V_response_text, TRUE);
        xutl.out('begin send receive history :' || to_char(sysdate,'ddmmyyyy HH24:mi:ss'));

        -- Read Model data
        SELECT a.* INTO V_MODEL(1) FROM DIM_PRED_MDL a WHERE mdl_sk = p_mdl_sk;
                
        v_model_name            := V_MODEL(1).MDL_NAME;
        v_model_url             := V_MODEL(1).MODEL_URL;
        v_model_sql             := V_MODEL(1).MODEL_HIST_IN_SQL;
        v_output_processing_sql := V_MODEL(1).MODEL_HIST_OUT_SQL;
              
        OPEN  my_cv for  v_model_sql USING p_mdl_sk, p_mdl_sk, p_mdl_sk, p_mdl_sk, P_RECORD_JSON_BLOCK_SIZE;
                
        FETCH my_cv INTO V_content;
                
        CLOSE MY_cv;
                
        --- temporary test logic -- remove later!!!!
        V_content := replace(V_content,'null','""');

        if debug_flag then
            xutl.out(V_content); 
        end if;
        
        -- HISTORY for HOSP ONLY
        v_request := utl_http.begin_request(v_model_url, 'POST','HTTP/1.1');
        utl_http.set_header(v_request, 'user-agent', 'mozilla/4.0'); 
        utl_http.set_header(v_request, 'content-type', 'application/json'); 
        utl_http.set_header(v_request, 'Transfer-Encoding', 'chunked' );
                
        V_buffers_of_data_cnt := ceil(LENGTH(v_content) / 32000);
        V_buffers_remain_cnt  := V_buffers_of_data_cnt;
        V_buffers_written_cnt := 0;
        
        -- Loop thru writing in 'chunks'
        while V_buffers_remain_cnt > 0
        LOOP
            begin
                V_write_buffer := (substr(V_content, ((V_buffers_written_cnt * 32000) + 1), 32000));
                UTL_HTTP.WRITE_TEXT(V_request, V_write_buffer);             
                V_buffers_written_cnt := V_buffers_written_cnt + 1;
                V_buffers_remain_cnt  := V_buffers_remain_cnt - 1;
            end;
        END LOOP;
        v_response := utl_http.get_response(v_request);
       
         -- Loop thru reading in 'chunks'
         V_num_chunks_in := 0;
         eob := false;   
        
         while not(eob)
            LOOP
                begin
                    UTL_HTTP.READ_TEXT(V_response, V_read_buffer, 32000);
                  --  dbms_output.put_line('About to read text ' || LENGTH(V_read_buffer) );
                    if  v_read_buffer is not null and length(v_read_buffer)>0 then
                        DBMS_LOB.WRITEAPPEND(V_RESPONSE_TEXT,LENGTH(V_read_buffer),V_read_buffer);
                        --dbms_output.put(V_read_buffer );
                        V_num_chunks_in := V_num_chunks_in + 1;
                    end if;
                    exception when UTL_HTTP.END_OF_BODY then
                            eob := true;
                    end;
           END LOOP;
           --dbms_output.put_line('');
           
            if debug_flag then
                xutl.out(V_response_text); 
            end if;

           V_response_content := V_response_text;        
           utl_http.end_response(v_response);
               
           --------------------------------------------------------     
           -- process the API OUTPUT DETAILS table  
           -------------------------------------------------------- 
           IF substr(v_response_content,1,14)  = '{"error":["500' THEN 
              raise_application_error( -20203, 'Getting Error 500 from HTTP Server  for mdl_sk :' || p_mdl_sk );
           END IF; 
           IF substr(v_response_content,1,14)  <> '{"error":["500' THEN
                v_output_details_seq := strat_details_seq.nextval;        

                delete from gtt_risk_model;
                insert into gtt_risk_model values (v_response_content);

                execute immediate v_output_processing_sql using  v_in_production, v_output_details_seq, v_model_type_sk, p_mdl_sk ;

                insert into FACT_RISK_API_OUTPUT_DETAILS
                values (v_output_details_seq, v_MODEL_ID,  v_model_name, v_content, v_response_content, sys_context('USERENV', 'OS_USER'), SYSDATE, sys_context('USERENV', 'OS_USER'), SYSDATE
                );
        
               commit;
           END IF;
          
               
            --- ********************************************
            ---      SPECIAL safety valve exit
            --- ********************************************
            --     I added this so I could stop the flow with out 'canceling' and causing HTTP to lose its place and get too many open connections.
            --     If you update the KEEP_HISTORY ind for UAS_Record_ID on the DIM_PRED_MDL_INPUT_TYPE table to 'R' or 'C' it will recognize it 
            --      here and end smoothly
            --     Remember to re-update it to 'Y' before re-starting or it will catch the error at the beginning of the main procedure
            SELECT KEEP_HISTORY_IND
              INTO x_keep_history_ind
              FROM DIM_PRED_MDL_INPUT_TYPE
             WHERE MDL_INPUT_TYPE_DESCR = 'UAS_Record_ID' ;
             
             IF   x_keep_history_ind = 'R' THEN 
                  raise_application_error( -20201, 'Safety/Rollback Exit has been Invoked - ROLLING BACK to last commit' );
             ELSIF  x_keep_history_ind = 'C' THEN 
                  raise_application_error( -20202, 'Safety/NoRollback Exit has been Invoked - NO ROLLBACK' );
             END IF;     
         
EXCEPTION
    WHEN e_Safety_Rollback2_Exit or e_Safety_NoRollback2_Exit or e_500_Error_Exit THEN 
        XUTL.OUT_E(sqlerrm);
        ROLLBACK;
        utl_http.end_response(v_response);
        RAISE;
        
    WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN 
         XUTL.OUT_E('getting out1 with end response  ') ;   
         UTL_HTTP.END_RESPONSE(v_response);
         RAISE;
         
    WHEN UTL_HTTP.REQUEST_FAILED THEN
         XUTL.OUT_E('getting out2  with end response ') ;   
         UTL_HTTP.END_RESPONSE(v_response);
         RAISE;
         
    WHEN OTHERS THEN 
         XUTL.OUT_E(sqlerrm);
         utl_http.end_response(v_response);
         RAISE;
END; 

procedure f_process_risk_model_post_api_update_strat_from_output is 


     x_count_output_rows   number;
     e_No_Rows_to_Strat EXCEPTION;
     PRAGMA EXCEPTION_INIT( e_No_Rows_to_Strat, -20301 );
        
BEGIN
-- The last step (resolve the strats)  
      
         SELECT count(*)
               into x_count_output_rows
               FROM FACT_RISK_API_OUTPUT a    
               where a.prod_ind = 'Y';     
         IF   x_count_output_rows = 0 THEN
             raise_application_error( -20301, 'No Rows found in OUTPUT table to be STRAT-Updated' );
         END IF;   
        
        EXECUTE IMMEDIATE 'TRUNCATE TABLE FACT_RISK_API_OUTPUT_STRAT';
        INSERT INTO FACT_RISK_API_OUTPUT_STRAT (MDL_INPUT_ID, MDL_PRED_STRAT, MDL_SK, MDL_VRSN_SK, MDL_THRESH_SK, PRED_VALUE, UPDT_USR_ID, UPDT_TS, CRTE_USR_ID, CRTE_TS, MDL_INPUT_ID_NUMERIC) 
       
        SELECT 
               a.MDL_INPUT_ID,
               null,
               a.MDL_SK,
               a.mdl_vrsn_sk,
               null,
               a.PRED_VALUE,
               sys_context('USERENV', 'OS_USER'),
               SYSDATE,
                sys_context('USERENV', 'OS_USER'),
               SYSDATE,
               a.mdl_input_id_numeric
               FROM FACT_RISK_API_OUTPUT a       
               WHERE a.prod_ind = 'Y';
          
          
        update FACT_RISK_API_OUTPUT_STRAT A
            set (A.MDL_PRED_STRAT, A.MDL_THRESH_SK) = 
               (select  x.PRED_STRAT, x.MDL_THRESH_SK
                  from   DIM_PRED_MDL_THRESH_VRSN x
                 WHERE  x.mdl_vrsn_sk = A.mdl_vrsn_sk
                   and x.ACTIVE_IND = 'Y'
                   and A.pred_value between x.range_low and x.range_high
                )
                WHERE exists             
                     (select 1
                        from   DIM_PRED_MDL_THRESH_VRSN x
                       WHERE  x.mdl_vrsn_sk = A.mdl_vrsn_sk
                      ); 
                     
EXCEPTION
     WHEN e_No_Rows_to_Strat THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        ROLLBACK;
        RAISE;
         
    WHEN OTHERS THEN 
         ROLLBACK;
         RAISE;
END;                       

END;
/