create or replace trigger ddl_trigger before create or alter or drop on SCHEMA 
declare 
    l_sysevent varchar2(25);
 
    tid       VARCHAR2 (32);
    vw       VARCHAR2 (300);
    v_ddl_sql  varchar2(200) := '';
    
BEGIN

    tid :=  'DDL_TRIGGER';
    choicebi.xutl.set_id(tid);
    choicebi.xutl.run_start (tid);
      
    select ora_sysevent into l_sysevent from dual;
     
    v_ddl_sql  := '';             
        
    v_ddl_sql := v_ddl_sql || sys_context('USERENV','OS_USER')  || ',';
    v_ddl_sql := v_ddl_sql || sys_context('USERENV','CURRENT_USER')  || ',';
    v_ddl_sql := v_ddl_sql || sys_context('USERENV','HOST')  || ',';
    v_ddl_sql := v_ddl_sql || sys_context('USERENV','TERMINAL')  || ',';
    v_ddl_sql := v_ddl_sql || ora_sysevent || ',';
    v_ddl_sql := v_ddl_sql || ora_dict_obj_type || ',' ;
    v_ddl_sql := v_ddl_sql || ora_dict_obj_owner  || ',' ; 
    v_ddl_sql := v_ddl_sql || ora_dict_obj_name; 
       
          
    choicebi.xutl.OUT (choicebi.xutl.rid,substr(v_ddl_sql,1,4000));
    
end; 
