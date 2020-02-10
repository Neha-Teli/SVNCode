CREATE OR REPLACE package CHOICEBI.xutl as
--
-- xlog logging package spec for VNS, by Patrick T Wolfert, 02/15/2008.
--
    id varchar2(400);
    tid number;
 rid pls_integer;
    procedure set_id(id varchar2);
    procedure set_tid(tid number);
    procedure xout(rc number, stat varchar2, msg varchar2);
    procedure out(rc number, msg varchar2);
    procedure out(msg varchar2);
    procedure out_w(rc number, msg varchar2);
    procedure out_w(msg varchar2);
    procedure out_e(rc number, msg varchar2);
    procedure out_e(msg varchar2);
 procedure run_start(msg varchar2); 
 procedure run_end; 
end xutl;
/


CREATE OR REPLACE package body CHOICEBI.xutl as
--
-- xlog logging package spec for VNS, by Patrick T Wolfert, 02/15/2008.
--
    procedure set_id(id varchar2) is
    begin
        xutl.id := id;
    end;
    --
    procedure set_tid(tid number) is
    begin
        xutl.tid := tid;
    end;
    --
    procedure xout(rc number, stat varchar2, msg varchar2) is
        pragma AUTONOMOUS_TRANSACTION;
    begin
        insert into xlog (
            ts, id, tid, rc, sev, msg, rid
        ) values (
            systimestamp, xutl.id, xutl.tid, rc, stat, msg, xutl.rid
        );
        commit;
    end;
    --
    procedure out(rc number, msg varchar2) is
    begin
        xutl.xout(rc, 'normal', msg);
    end;
    --
    procedure out(msg varchar2) is
    begin
        xutl.xout(null, 'normal', msg);
    end;
    --
    procedure out_w(rc number, msg varchar2) is
    begin
        xutl.xout(rc, 'warning', msg);
    end;
    --
    procedure out_w(msg varchar2) is
    begin
        xutl.xout(null, 'warning', msg);
    end;
    --
    procedure out_e(rc number, msg varchar2) is
    begin
        xutl.xout(rc, 'error', msg);
    end;
    --
    procedure out_e(msg varchar2) is
    begin
        xutl.xout(null, 'error', msg);
    end;
 --
 procedure run_start(msg varchar2) is
        pragma AUTONOMOUS_TRANSACTION;  
    begin
     select xlog_seq.nextval into xutl.rid from dual;
        insert into xrun (
             rid, start_dtm, msg
        ) values (
            xutl.rid, sysdate, msg
        );
        commit;
    end;
 --
 procedure run_end is
        pragma AUTONOMOUS_TRANSACTION;  
    begin     
        update xrun 
  set end_dtm = sysdate
  where rid = xutl.rid;
        commit;
    end;
begin
  -- session specific initialization
  xutl.id := null;
  xutl.tid := null;
  xutl.rid := null;
end xutl;
/


GRANT EXECUTE ON CHOICEBI.xutl TO MSTRSTG;