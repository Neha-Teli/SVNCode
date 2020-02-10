DROP TABLE CHOICEBI.XLOG CASCADE CONSTRAINTS;

CREATE TABLE CHOICEBI.XLOG
(
  TS   TIMESTAMP(6),
  ID   VARCHAR2(400 BYTE),
  TID  NUMBER,
  RC   NUMBER,
  SEV  VARCHAR2(16 BYTE),
  MSG  VARCHAR2(4000 BYTE),
  RID  NUMBER
)
RESULT_CACHE (MODE DEFAULT)
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX CHOICEBI.XLOG_MSG ON CHOICEBI.XLOG
(MSG)
NOLOGGING
NOPARALLEL;


/*
CREATE OR REPLACE TRIGGER CHOICEBI.error_shout
after INSERT
   ON CHOICEBI.XLOG
DECLARE

   v_max_ts   timestamp(6);
   v_errors varchar2(512);
   v_jobid  varchar2(20) ;
   v_ts     timestamp(6);
  l_mail_host  varchar2(50) := 'xcgcasw0301.vnsny.org';
  l_from       varchar2(50) := 'rc_owner@vnsny.org';
  l_to         varchar2(50) := 'Ripul.Patel@vnsny.org';



BEGIN

 select max(ts) into v_max_ts
 from xlog  ;



select id,msg into v_jobid,v_errors
    from xlog
    where msg like 'ORA-%'
    and trunc(ts) = trunc(sysdate)
    and ts = v_max_ts ;
if v_errors not like 'ORA-02081%' AND v_errors not like 'ORA-06512%'
then
    if f_check_blackout(v_jobid) = 0 then

          utl_mail.send(sender    => l_from,
                recipients => l_to,
                subject    => v_jobid,
                message    => v_errors||' Please check Job '||v_jobid||' an error occured at: '||v_max_ts );
    else null;
    end if;
end if ;
exception
         when others
         then null;


END;
/
*/

GRANT SELECT ON CHOICEBI.XLOG TO KUNLE_G;

DROP SEQUENCE CHOICEBI.XLOG_SEQ;

CREATE SEQUENCE CHOICEBI.XLOG_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON CHOICEBI.XLOG TO RIPUL_P;
GRANT SELECT ON CHOICEBI.XLOG TO MSTRSTG;
