CREATE OR REPLACE PACKAGE CHOICEBI.ETL
AUTHID CURRENT_USER  
AS
   /******************************************************************************
      NAME:       etl
      PURPOSE:    update selected tables in ms_owner schema

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        5/26/2016   Ripul Patel         1. Created this package.
   ******************************************************************************/

   --constants
   x_null_date   DATE := '1-JAN-0001';
   x_last_date   DATE := '31-DEC-9999';
   x_zero        PLS_INTEGER := 0;
   x_one         PLS_INTEGER := 1;
   x_uk          PLS_INTEGER := -1;
   x_na          PLS_INTEGER := -2;

    procedure P_uat_risk_score;
    procedure p_mltc_member_paid_hrs_by_day ;
    procedure p_fida_member_paid_hrs_by_day;
    procedure p_reassessment_tracking ;
    PROCEDURE p_refresh_mv (p_in_mv_name VARCHAR2);  
    procedure ValidateBatchLoad;
    procedure p_hha_ltp_data;

END ETL;
/


CREATE OR REPLACE PACKAGE BODY CHOICEBI.ETL
AS
    --***************************************************************************
    --* Package: ETL_CASE_INFO                                                  *
    --*                                                                         *
    --* Arguments  None -                                                       *
    --*                                                                         *
    --* SYNOPSIS:
    --*                      `                                                   *
    --*                                                                         *
    --* Revision:  1.00                               Revision Date: 05/24/2016 *
    --*                                                                         *
    --* Programmer                 Date        Description                      *
    --*--------------------------- ---------- ----------------------------------*
    --* Ripul Patel         1.0    05/26/2016 Created Package                   *
    --* Ripul Patel         1.1    06/14/2016 Modified procedure for FIDA       *
    --***************************************************************************

   -- ************************
   -- * Version Number Info  *
   -- ************************
   version_process_title_g varchar2(15)    := 'etl';
   version_no_g            NUMBER          :=  1.01;
   version_date_g          varchar2(12)    := '26-MAY-2016';


   --*************************
   --* DEBUG_MODE_FLAG       *
   --*-----------------------*
   --* 0 = off               *
   --* 1 = on                *
   --*************************
   DEBUG_MODE_FLAG_g       PLS_INTEGER := 0;

   --updates
   first_date_c            DATE := '1-JAN-2001';
   last_date_c             DATE := '31-DEC-9999';

   -- x_nexus VARCHAR2(30) := 'nexus';
    Procedure cleanupTempTables as
    begin
           xutl.OUT ('Truncating temp tables for populate_mem_paid_hrs_by_day_fida  ...');
           BEGIN
              FOR rec
              IN (SELECT owner, table_name
                  FROM all_tables
                  WHERE owner = 'CHOICEBI'
                        AND table_name IN
                                 (
                                    'TEMP_ORDERED',
                                    'TEMP_PARA_ORDER_DAY2',
                                    'TEMP_PARA_ORDER_MBR2',
                                    'TEMP_PARA_ORDER_MBR'
                                    ))
              LOOP
                 BEGIN
                    EXECUTE IMMEDIATE   'TRUNCATE TABLE '
                                     || rec.owner
                                     || '.'
                                     || rec.table_name
                                     ;
                   DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', rec.table_name, '', 10);
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       BEGIN
                        xutl.OUT (DBMS_UTILITY.format_error_backtrace
                                    || CHR (13)
                                    || CHR (10)
                                    || DBMS_UTILITY.FORMAT_CALL_STACK );
                                            xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                       END;
                 END;
              END LOOP;
           END;
           xutl.OUT ('Truncate complete for temp tables populate_mem_paid_hrs_by_day_fida ...');
    end;
    procedure get_year_dates(v_year in number, v_choice_year in out varchar2, v_jan1_dt in out varchar2,  v_dec31_dt in out varchar2, v_begdt in out varchar2, v_enddt in out varchar2) as
    begin
     /*
        --get year begin and end date for given choice year
        */

        select
            to_number(substr(to_char(choice_week_id),1,4)) as choice_year,
            to_number(to_char(to_number(substr(to_char(choice_week_id),1,4))) || '0101') as jan1_dt,
            to_number(to_char(to_number(substr(to_char(choice_week_id),1,4))) || '1231') as dec31_dt,
            to_number(to_char(min(day_date),'yyyymmdd')) as begdt,
            to_number(to_char(max(day_date),'yyyymmdd')) as enddt
            into v_choice_year, v_jan1_dt, v_dec31_dt, v_begdt, v_enddt
        from mstrstg.lu_day a
        where to_number(substr(to_char(choice_week_id),1,4))=v_year
            and
                   (
                    to_number(substr(to_char(choice_week_id),5,2)) =    (
                                                                            select max(to_number(substr(to_char(choice_week_id),5,2))) as week_id
                                                                            from mstrstg.lu_day
                                                                            where to_number(substr(to_char(choice_week_id),1,4))= to_number(substr(to_char(a.choice_week_id),1,4))
                                                                            group by to_number(substr(to_char(choice_week_id),1,4))
                                                                        )
                    OR
                    to_number(substr(to_char(choice_week_id),5,2))=1
                   )
        group by to_number(substr(to_char(choice_week_id),1,4));
    end;


    procedure p_member_paid_hrs_by_day_mltc (v_choice_year in varchar2, v_jan1_dt in varchar2,  v_dec31_dt in varchar2, v_begdt in varchar2, v_enddt in varchar2) as

        v_year varchar2(4);
        v_TEMP_PARA_ORDER_MBR number;
        v_divisor number :=10000;
        v_recnt_per_thread number:=0;
        v_start number:=0;
        v_end number:=0;

        ex_misc         EXCEPTION;
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'p_member_paid_hrs_by_day_mltc';
        v_lob_id       number;
        v_lob_name      varchar2(400);

    begin


        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('started');

        xutl.OUT ('Truncating temp tables for p_member_paid_hrs_by_day_mltc for MLTC ...');

        BEGIN
          FOR rec
          IN (SELECT owner, table_name
              FROM all_tables
              WHERE owner = 'CHOICEBI'
                    AND table_name IN
                             (  'TEMP_AUTHS_MBR',
                                'TEMP_ORDERED',
                                'TEMP_PARA_ORDER_DAY2',
                                'TEMP_PARA_ORDER_MBR2',
                                'TEMP_PARA_ORDER_MBR'
                                ))
          LOOP
             BEGIN

                EXECUTE IMMEDIATE   'TRUNCATE TABLE '
                                 || rec.owner
                                 || '.'
                                 || rec.table_name
                                 ;
               DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', rec.table_name, '', 10);

             EXCEPTION
                WHEN OTHERS
                THEN
                   BEGIN
                    xutl.OUT (DBMS_UTILITY.format_error_backtrace
                                || CHR (13)
                                || CHR (10)
                                || DBMS_UTILITY.FORMAT_CALL_STACK );
                                        xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   END;
             END;
          END LOOP;

        EXCEPTION
          WHEN OTHERS
          THEN
             BEGIN
                   xutl.OUT (DBMS_UTILITY.format_error_backtrace
                || CHR (13)
                || CHR (10)
                || DBMS_UTILITY.FORMAT_CALL_STACK );
                   xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   null;
             END;
        END;

        xutl.OUT ('Truncate complete for temp tables p_member_paid_hrs_by_day_mltc ...');

        --select lob_id, LOB_NAME into v_lob_id , v_lob_name from MSTRSTG.D_LINE_OF_BUSINESS where LOB_NAME = 'MLTC' and rownum = 1;
        select dl_LOB_GRP_id lob_id,LOB_GRP_DESC LOB_NAME into v_lob_id , v_lob_name from MSTRSTG.D_LOB_GROUP where LOB_GRP_DESC = 'MLTC' and rownum = 1;

        xutl.OUT(v_choice_year || '|' || v_jan1_dt || '|' ||v_dec31_dt || '|' ||v_begdt || '|' || v_enddt);

        insert into TEMP_PARA_ORDER_MBR
        with allmbrmonth as
        (
            select
                mrn
                ,subscriber_id
                ,month_id
                ,to_date(month_id, 'yyyymm') as mbrmonth_start
                ,trunc(add_months(to_date(month_id, 'yyyymm'),1),'mm')-1 as mbrmonth_end
            from
                --choicebi.fact_member_month a
                CHOICEBI.FACT_MEMBER_MONTH a
            where program = v_lob_name and dl_lob_id in (2,5) and      --EO7 Related changes
                to_date(a.month_id, 'yyyymm') between to_date(v_jan1_dt, 'yyyymmdd') and to_date(v_dec31_dt, 'yyyymmdd')
        )
        select *
        from
        (
                select
                    para_ord_mrn,
                    para_case_nbr,
                    para_case_seq,
                    para_ord_prog,
                    para_ord_choice,
                    para_ord_fida,
                    para_ord_mltc,
                    para_ord_status,
                    para_ord_service,
                    (para_ord_entry_dte) as para_ord_entry_dte,
                    (para_req_start_dte) as para_req_start_dte ,
                    (order_end) as order_end  ,
                    (sched_wk_beg_date) as sched_wk_beg_date,
                    (sched_wk_end_date) as sched_wk_end_date ,
                    seq_no_desc,
                    sumhours_lv_wk,
                    sched_saturday_lv,
                    sched_sunday_lv,
                    sched_monday_lv,
                    sched_tuesday_lv,
                    sched_wednesday_lv,
                    sched_thursday_lv,
                    sched_friday_lv
                    ,null meber_id
                from
                (
                    select z.*
                    from
                        (
                            select /*+ use_hash(a b) */
                                distinct a.para_ord_mrn, a.para_case_nbr, a.para_case_seq
                                , a.para_ord_prog
                                , (case when substr(a.para_ord_prog,1,1)='V' then 1 else 0 end) as para_ord_choice
                                , (case when a.para_ord_prog='VCF' then 1 else 0 end) as para_ord_fida
                                , (case when a.para_ord_prog like 'V%' and a.para_ord_prog <> 'VCF' then 1 else 0 end) as para_ord_mltc
                                , a.para_ord_status, a.para_ord_service
                                , to_date(decode(a.para_ord_entry_dte,0,null, a.para_ord_entry_dte), 'yyyymmdd') as para_ord_entry_dte
                                , to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd') as para_req_start_dte
                                , to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd')  as order_end
                                , to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') as sched_wk_end_date
                                , (case when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 > to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                then to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 <= to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is null
                                then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                end) as sched_wk_beg_date
                                , row_number() over (partition by a.para_ord_mrn, a.para_case_nbr, a.para_case_seq order by b.sched_wk_end_date desc) as seq_no_desc
                                , row_number() over
                                (partition by a.para_ord_mrn
                                , a.para_case_nbr
                                , a.para_ord_service
                                , (case when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 > to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                then to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 <= to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is null
                                then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                end)
                                order by a.para_ord_entry_dte desc, b.sched_wk_end_date desc) as sort_seq
                                /*Recalculate hours for live-in days*/
                                /*Live in should be 13 hours per day, but is represented as 24 hours per day in OPS*/
                                ,(
                                (case when b.sched_lv_in_flag2='Y' then 13 else b.sched_saturday end)
                                +(case when b.sched_lv_in_flag3='Y' then 13 else b.sched_sunday end)
                                +(case when b.sched_lv_in_flag4='Y' then 13 else b.sched_monday end)
                                +(case when b.sched_lv_in_flag5='Y' then 13 else b.sched_tuesday end)
                                +(case when b.sched_lv_in_flag6='Y' then 13 else b.sched_wednesday end)
                                +(case when b.sched_lv_in_flag7='Y' then 13 else b.sched_thursday end)
                                +(case when b.sched_lv_in_flag8='Y' then 13 else b.sched_friday end)
                                ) as sumhours_lv_wk
                                , (case when sched_lv_in_flag2='Y' then 13 else sched_saturday end) as sched_saturday_lv
                                , (case when sched_lv_in_flag3='Y' then 13 else sched_sunday end) as sched_sunday_lv
                                , (case when sched_lv_in_flag4='Y' then 13 else sched_monday end) as sched_monday_lv
                                , (case when sched_lv_in_flag5='Y' then 13 else sched_tuesday end) as sched_tuesday_lv
                                , (case when sched_lv_in_flag6='Y' then 13 else sched_wednesday end) as sched_wednesday_lv
                                , (case when sched_lv_in_flag7='Y' then 13 else sched_thursday end) as sched_thursday_lv
                                , (case when sched_lv_in_flag8='Y' then 13 else sched_friday end) as sched_friday_lv
                            from
                                    dw_owner.tpopsd_para_order a,
                                    dw_owner.tpopsd_para_sche b,
                                    (select distinct mrn from allmbrmonth) mrndist
                                where
                                a.para_ord_mrn   = mrndist.mrn and
                                a.para_case_nbr=b.sched_case_nbr and
                                a.para_case_seq = b.sched_case_seq and
                                (a.para_ord_status in ('AA', 'AC', 'DP', 'DD') or (a.para_ord_status='CC' and a.para_ord_service=6))
                                and a.para_ord_prog<>'VCF' /*do not include FIDA*/
                                and substr(a.para_ord_prog,1,1) <> 'K' /*exclude Partners - private pay, plus typos in dates*/
                                and decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0, 99991231, greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds))>= a.para_req_start_dte /*order end dt >= order start dt*/
                                /*    limit orders to applicable to dates*/
                                and decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0, 99991231, greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)) >= v_begdt /*order end dt >= beg of year*/
                                and a.para_req_Start_dte <= v_enddt /*order start dt <= end of year*/
                                and a.para_req_start_dte > 991231 /*don't include these old orders from before year 2000*/
                                /* exclude schedules where sched_wk_beg_dt occurs after the order end dt*/
                                and (case when (to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd') is not null
                                and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                and to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd')
                                < to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                ) then 1 else 0 end) = 0
                        ) z
                    where z.sort_seq=1
                )
            ) para_order_mbr;
        xutl.out('TEMP_PARA_ORDER_MBR -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_MBR', '', 10);

        Insert into TEMP_PARA_ORDER_DAY2
        with allmbrmonth as
        (
            select /*+ MATERIALIZE no_merge*/
                 mrn
                ,month_id
                ,to_date(month_id, 'yyyymm') as mbrmonth_start
                ,trunc(add_months(to_date(month_id, 'yyyymm'),1),'mm')-1 as mbrmonth_end
            from
                --choicebi.fact_member_month a
                CHOICEBI.FACT_MEMBER_MONTH a
            where program = v_lob_name and dl_lob_id in (2,5) and      --EO7 File changes 
                to_date(a.month_id, 'yyyymm') between to_date(v_jan1_dt, 'yyyymmdd') and to_date(v_dec31_dt, 'yyyymmdd')
        )
        ,para_order_mbr2 as
         (
            SELECT  /*+  no_merge */
                 para_ord_mrn
               , para_case_nbr
               , para_case_seq
               , para_ord_prog
               , para_ord_choice
               , para_ord_fida
               , para_ord_mltc
               , para_ord_status
               , para_ord_service
               , (para_ord_entry_dte) as para_ord_entry_dte
               , (para_req_Start_dte) as para_req_Start_dte
               , (order_end) as order_end
               , (sched_wk_beg_date) as sched_wk_beg_date
               , (sched_wk_end_date) as sched_wk_end_date
               , seq_no_desc
               , sumhours_lv_wk
               , (sched_beg) as sched_beg
               , (sched_end) as sched_end
               , sched_saturday_lv
               , sched_sunday_lv
               , sched_monday_lv
               , sched_tuesday_lv
               , sched_wednesday_lv
               , sched_thursday_lv
               , sched_friday_lv
               , null meber_id

            from
            (
            SELECT z.para_ord_mrn
           , z.para_case_nbr
           , z.para_case_seq
           , z.para_ord_prog
           , z.para_ord_choice
           , z.para_ord_fida
           , z.para_ord_mltc
           , z.para_ord_status
           , z.para_ord_service
           , z.para_ord_entry_dte
           , z.para_req_Start_dte
           , z.order_end
           , z.sched_wk_beg_date
           , z.sched_wk_end_date
           , z.seq_no_desc
           , z.sumhours_lv_wk
           , z.sched_beg
           , z.sched_end
           , z.sched_saturday_lv
           , z.sched_sunday_lv
           , z.sched_monday_lv
           , z.sched_tuesday_lv
           , z.sched_wednesday_lv
           , z.sched_thursday_lv
           , z.sched_friday_lv
        FROM
        (SELECT
                x.*
                , x.sched_wk_beg_date AS sched_beg
                ,(CASE WHEN (x.offset_date <> x.sched_wk_beg_date
                              AND (x.offset_date <> to_Date('31-DEC-9999') OR NVL (x.seq_no_desc, 0) <> 1)
                              AND (x.offset_date <> x.order_end OR NVL (x.seq_no_desc, 0) <> 1))
                 THEN x.offset_date - 1
                 ELSE x.offset_date
                 END) AS sched_end
         FROM
             (SELECT a.*
                      ,(CASE WHEN b.fst_para_ord_entry_dt IS NOT NULL
                        THEN
                             (CASE WHEN a.order_end IS NOT NULL THEN a.order_end
                                   WHEN a.order_end IS NULL THEN to_date('31-DEC-9999')
                              END)
                        ELSE a.lagdate
                        END) AS offset_date
               FROM
                    (SELECT c.*
                            ,LAG (sched_wk_beg_date, 1) OVER (ORDER BY para_ord_mrn, para_case_nbr, para_ord_service, para_ord_entry_dte, sched_wk_beg_date DESC, sched_wk_end_date) AS lagdate
                            FROM TEMP_PARA_ORDER_MBR c
                    ) a
                       LEFT JOIN
                   (SELECT para_ord_mrn, para_case_nbr, para_ord_service, sched_wk_beg_date
                                , sched_wk_end_date
                                , para_ord_entry_dte AS fst_para_ord_entry_dt
                                , seq_no_desc
                     FROM TEMP_PARA_ORDER_MBR WHERE seq_no_desc=1) b
                     ON (b.para_ord_mrn = a.para_ord_mrn
                         AND b.para_case_nbr = a.para_case_nbr
                         AND b.para_ord_service=a.para_ord_service
                         AND b.fst_para_ord_entry_dt = a.para_ord_entry_dte
                         AND b.sched_wk_beg_date = a.sched_wk_beg_date
                         AND NVL (b.sched_wk_end_date, '01-JAN-0001') = NVL (a.sched_wk_end_date, '01-JAN-0001'))
              ) x
         ) z
        ORDER BY
            z.para_ord_mrn,
            z.para_case_nbr,
            z.para_ord_service,
            z.sched_beg
        )
        )
        ,para_order_day as
        (
        select /*+ no_merge */
          para_ord_mrn
        , para_case_nbr
        , para_case_seq
        , para_ord_prog
        , para_ord_choice
        , para_ord_fida
        , para_ord_mltc
        , para_ord_status
        , para_ord_service
        , (para_ord_entry_dte) as para_ord_entry_dte
        , (para_req_Start_dte) as para_req_Start_dte
        , (order_end) as order_end
        , (sched_wk_beg_date) as sched_wk_beg_date
        , (sched_wk_end_date) as sched_wk_end_date
        , seq_no_desc
        , sumhours_lv_wk
        , (sched_beg) as sched_beg
        , (sched_end) as sched_end
        , (the_date) as the_date
        , orderhrs_lv_day
        , dow
        , sched_saturday_lv
        , sched_sunday_lv
        , sched_monday_lv
        , sched_tuesday_lv
        , sched_wednesday_lv
        , sched_thursday_lv
        , sched_friday_lv
        , null meber_id
        from
        (
        select para_ord_mrn, para_case_nbr, para_case_seq, para_ord_prog
        , para_ord_choice, para_ord_fida, para_ord_mltc, para_ord_status, para_ord_service
        , para_ord_entry_Dte, para_req_start_dte, order_end, sched_wk_beg_date, sched_wk_end_date, seq_no_desc
        , sumhours_lv_wk, sched_beg, sched_end, the_date, orderhrs_lv_day, dow
        , sched_saturday_lv, sched_sunday_lv, sched_monday_lv, sched_tuesday_lv, sched_wednesday_lv, sched_thursday_lv, sched_friday_lv
        from
        (select y.*, ROW_NUMBER() OVER (PARTITION BY y.para_ord_mrn, y.the_date ORDER BY y.para_ord_choice desc, y.para_ord_entry_dte desc) AS cob_disc_sort_seq
        from
        (select * from
        (select x.*, ROW_NUMBER() OVER (PARTITION BY x.para_ord_mrn, x.para_ord_service, x.the_date ORDER BY x.para_ord_choice desc) AS cob_sort_seq
        from
            (select *
            from
                (select
                         z.*
                    , b.day_date as the_date
                    , to_char(b.day_Date,'DY','nls_date_language=english') as dow
                    , (case when to_char(b.day_Date,'DY','nls_date_language=english')='SUN' then sched_sunday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='MON' then sched_monday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='TUE' then sched_tuesday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='WED' then sched_wednesday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='THU' then sched_thursday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='FRI' then sched_friday_lv
                            when to_char(b.day_Date,'DY','nls_date_language=english')='SAT' then sched_saturday_lv
                       end) as orderhrs_lv_day
                    , row_number() over (partition by z.para_ord_mrn, z.para_ord_prog, z.para_ord_service, b.day_date order by z.para_req_start_dte desc) as sort_seq
                    from para_order_mbr2 z , mstrstg.lu_day b
                    where
                        B.DAY_DATE between z.sched_beg and decode(z.sched_end,'31DEC9999',to_Date(v_enddt,'yyyymmdd'),z.sched_end)
                        and b.day_date between to_date(v_begdt,'yyyymmdd') and to_date(v_enddt, 'yyyymmdd')
                )
            where sort_seq=1 /*dedupe where the order_end is same date as req_start_dte for same para_ord_prog and para_ord_service*/
            ) x
        )
        where cob_sort_seq=1 /*dedupe where there is COB split between CHHA and CHOICE for the same discipline - take the CHOICE instance for a given day/mrn */
        ) y
        )
        where cob_disc_sort_seq=1 /*dedupe where 2 CHOICE orders for same date but different disciplines (should not occur, take more recent entry date),*/
                     /*or situations where CHOICE/CHHA occurs for same date with different disciplines (take the CHOICE instance to represent correct COB)*/
        order by para_ord_mrn, the_date
        )
        )
        select /*+ first_rows(10) */ to_char(the_date,'YYYYMM') month_id, a.*
        from para_order_day a;
        --join allmbrmonth b on (a.para_ord_mrn = b.mrn and a.the_date between b.mbrmonth_start and b.mbrmonth_end);
        xutl.out('TEMP_PARA_ORDER_DAY2 -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_DAY2', '', 10);

        insert into temp_auths_mbr
        with allmbrmonth as
        (
            select /*+ materialize  */ mrn
                ,subscriber_id
                ,month_id
                ,to_date(month_id, 'yyyymm') as mbrmonth_start
                ,trunc(add_months(to_date(month_id, 'yyyymm'),1),'mm')-1 as mbrmonth_end
                ,(case when month_id=max_month_id then 1 else 0 end) as active
            from
                --choicebi.fact_member_month a,
                CHOICEBI.FACT_MEMBER_MONTH a,
                (select max(month_id) max_month_id from CHOICEBI.FACT_MEMBER_MONTH WHERE program = v_lob_name and dl_lob_id in (2,5) ) b
            where program = v_lob_name and dl_lob_id in (2,5) and  --EO7 File changes
                to_date(a.month_id, 'yyyymm') between to_date(v_jan1_dt, 'yyyymmdd') and to_date(v_dec31_dt, 'yyyymmdd')
        ),
        auths_mbr as
        (
            select /*+ parallel(2)  no_merge */
                  a.mrn
                , b.sbsb_id
                , d.umum_ref_id
                , d.umsv_input_usid
                , d.umsv_input_dt
                , d.umsv_prpr_id_req
                , d.umsv_recd_dt
                , d.umsv_from_dt
                , d.umsv_to_dt
                , d.ipcd_id
                , d.umsv_units_allow
                , (to_date(to_char(umsv_to_dt,'DD-MON-YYYY'))-to_date(to_char(umsv_from_dt,'DD-MON-YYYY'))+1) as auth_days
                , (umsv_units_allow)/(to_date(to_char(umsv_to_dt,'DD-MON-YYYY'))-to_date(to_char(umsv_from_dt,'DD-MON-YYYY'))+1) as auth_units_day
                , (case when substr(ipcd_id,1,5) in ('T1019', 'S5130','G0154', 'G0156', 'S5125' ) then (umsv_units_allow*15/60)
                    else umsv_units_allow end) as auth_units_HE
                , (case when substr(ipcd_id,1,5) in ('T1019', 'S5130','G0154', 'G0156', 'S5125' ) then (umsv_units_allow*15/60)/ (to_date(to_char(umsv_to_dt,'DD-MON-YYYY'))-to_date(to_char(umsv_from_dt,'DD-MON-YYYY'))+1)
                    else umsv_units_allow/(to_date(to_char(umsv_to_dt,'DD-MON-YYYY'))-to_date(to_char(umsv_from_dt,'DD-MON-YYYY'))+1) end) as auth_units_day_HE        from
            tmg.cmc_sbsb_subsc b,
            tmg.CMC_MEME_MEMBER c,
            tmg.CMC_UMSV_SERVICES d,
            TMG.Cmc_mepe_prcs_elig K,
            (select distinct mrn, subscriber_id from allmbrmonth)   a
            --left join tmg.CMC_MEME_MEMBER    c    on  (b.sbsb_ck = c.sbsb_ck)
            --join tmg.CMC_UMSV_SERVICES d on (c.meme_ck = d.meme_ck)
            --JOIN TMG.Cmc_mepe_prcs_elig K ON (d.MEME_CK=K.MEME_CK AND d.umsv_from_dt between k.MEPE_EFF_DT and k.MEPE_TERM_DT)
        where  (b.sbsb_ck = c.sbsb_ck(+))
         and a.subscriber_id = b.sbsb_id
         and (c.meme_ck = d.meme_ck)
         and (d.MEME_CK=K.MEME_CK  AND d.umsv_from_dt between k.MEPE_EFF_DT and k.MEPE_TERM_DT)
         and substr(d.ipcd_id,1,5) in ('S5125', 'T1019', 'S9122','S5126', 'G0156', 'S5185', 'G0154', 'T1020', 'T1021', 'S5130', 'S5131')
                and k.pdpd_id in ( 'HMD00002', 'HMD00003', 'MD000002','MD000003')
                and k.mepe_elig_ind = 'Y'
                and d.umsv_from_dt <= to_date(v_enddt, 'yyyymmdd')
                and d.umsv_to_dt >= to_date(v_begdt, 'yyyymmdd')
                and d.umvt_sts in ('CO') /*complete, approved*/
                and d.umsv_units_req not in (999,9999)
                and d.umsv_units_allow <> 0
        )
            select 
                mrn,
                sbsb_id,
                umum_ref_id,
                umsv_input_usid
                ,(umsv_input_dt) as umsv_input_dt
                ,umsv_prpr_id_req
                ,(umsv_recd_dt) as umsv_recd_dt
                ,(umsv_from_dt) as umsv_from_dt
                ,(umsv_to_dt) as umsv_to_dt
                ,ipcd_id, umsv_units_allow, auth_days, auth_units_day, auth_units_he
                ,auth_units_day_he
                ,(the_date) as the_date
                ,dow
            from
                (
                    select  /*+ parallel(2) use_hash(auths_mbr, lu_day) */  z.*
                             , b.day_date as the_date
                            , to_char(b.day_Date,'DY','nls_date_language=english') as dow
                            , row_number() over (partition by z.mrn, b.day_date, z.ipcd_id order by z.umsv_prpr_id_req desc, z.umsv_recd_dt desc, z.auth_units_day desc) as sort_seq
                    from auths_mbr z, mstrstg.lu_day b
                    where (B.DAY_DATE between z.umsv_from_dt and z.umsv_to_dt)
                        and b.day_date between to_date(v_begdt,'yyyymmdd') and to_date(v_enddt, 'yyyymmdd')
                )
            where sort_seq=1
        ;
        xutl.out('temp_auths_mbr -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_AUTHS_MBR', '', 10);

        INSERT INTO temp_ordered            --FACT_OPS_PARA
        select
          Y.MONTH_ID
        , coalesce(y.mrn, z.mrn) as mrn
        , coalesce(y.the_date, z.the_date) as the_date
        , y.orderhrs_lv_day
        , z.auth_units_day
        , z.auth_units_day_HE
        , cpt_T1019
        ,cpt_S5130
        , (case when y.orderhrs_lv_day is not null then y.orderhrs_lv_day
                when y.orderhrs_lv_day is null and z.auth_units_day is not null then z.auth_units_day
                else 0 end) as ordered_day
        , (case when y.orderhrs_lv_day is not null then y.orderhrs_lv_day
                when y.orderhrs_lv_day is null and z.auth_units_day_HE is not null then z.auth_units_day_HE
                else 0 end) as ordered_day_HE
        , coalesce(y.SOURCE, z.SOURCE) as SOURCE
        , null meber_id
    from
        (
            select
                para_ord_mrn as mrn
                , the_Date
                , coalesce(orderhrs_lv_day,0) as orderhrs_lv_day
                , MONTH_ID
                , 'OPSHRS' SOURCE
            from
                temp_para_order_day2
        ) y
    full join
        (select mrn
                , the_date
                /*sum up the hours per day for different IPCD codes*/
                , sum(case when ipcd_id='T1019' then 1 else 0 end) as cpt_T1019
                , sum(case when ipcd_id='S5130' then 1 else 0 end) as cpt_S5130
                , sum(coalesce(auth_units_day,0)) as auth_units_day
                , sum(coalesce(auth_units_day_HE,0)) as auth_units_day_HE
                , 'AUTHHRS' SOURCE
        from TEMP_AUTHS_MBR
        group by mrn, the_date
        ) z
        on
        (y.mrn=z.mrn and y.the_date=z.the_date );
        xutl.out('temp_ordered -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_ORDERED', '', 10);

        Insert into F_PAID_HRS_BY_SOURCE
        select /*+ noparallel  */
              v_lob_id    LOB_ID
             ,v_lob_name LINE_OF_BUSINESS
            ,a.CLAIM_SOURCE
            ,a.MONTH_ID
            ,a.MRN
            ,a.SUBSCRIBER_ID
            ,a.CASE_NUM
            ,a.SERVICE_DATE
            ,a.PAY_DATE
            ,a.INVOICE_NO
            ,a.PAY_TWICE_DAILY
            ,a.PAY_SEQUENCE
            ,a.PAY_CYCLE_ID
            ,a.PAY_PROVIDER_ID
            ,a.PAY_TYPE_PAYMENT
            ,a.PAID_HOURS
            ,a.PAID_HOURS_HE
            ,a.PAY_AMOUNT
            ,a.PRPR_NAME
            ,a.PRPR_MCTR_TYPE
            ,a.SESE_ID
            ,a.SEDS_DESC
            ,a.IS_ACTIVE
            ,a.COUNTY_CODE
            ,a.BOROUGH
            ,a.JOB_RUN_ID
            ,a.SYS_UPD_TS
            , null member_id
        from
        (
            (
                select
                     'TMGCLAIM' CLAIM_SOURCE
                    , MONTH_ID
                    , CAST(COALESCE(A.MRN, B.MRN) AS VARCHAR2(100)) MRN
                    , nvl(a.SUBSCRIBER_ID, b.SUBSCRIBER_ID) SUBSCRIBER_ID
                    , CASE_NUM
                    , SERVICE_DATE
                    , PAY_DATE
                    , NULL INVOICE_NO
                    , NULL PAY_TWICE_DAILY
                    , PAY_SEQUENCE
                    , NULL PAY_CYCLE_ID
                    , NULL PAY_PROVIDER_ID
                    , NULL PAY_TYPE_PAYMENT
                    , PAID_HOURS
                    , PAID_HOURS_HE
                    , PAY_AMOUNT
                    , PRPR_NAME
                    , PRPR_MCTR_TYPE
                    , SESE_ID
                    , SEDS_DESC
                    , IS_ACTIVE
                    , a.COUNTY_CODE
                    , a.BOROUGH
                    , null JOB_RUN_ID
                    , sysdate SYS_UPD_TS
                from
                (
                    select a.*,b.month_id, b.mrn , b.county_code, b.borough, decode(b.mrn, null, 0, 1) IS_ACTIVE
                    from
                    (
                        select/*+ no_merge */
                              sbsb_id SUBSCRIBER_ID
                            , clcl_id case_num
                            , service_date as service_date
                            , pay_date as pay_Date
                            , cdml_seq_no PAY_SEQUENCE
                            , PAID_HOURS
                            , PAID_HOURS_HE
                            , cdml_paid_amt PAY_AMOUNT
                            , prpr_name
                            , prpr_mctr_type
                            , sese_id
                            , seds_desc
                        from
                        (
                            select  /*+ use_hash(b b2 seds ipcd c F G K)  */
                                distinct
                                  g.sbsb_id
                                , b.clcl_id
                                , b.clcl_cur_sts
                                , b.clcl_paid_dt as pay_date
                                , b.CLCL_TOT_PAYABLE
                                , c.prpr_name
                                , c.prpr_mctr_type
                                , b2.cdml_seq_no
                                , b2.sese_id, seds.seds_desc
                                , b2.cdml_from_dt as service_date
                                , b2.cdml_chg_amt
                                , b2.cdml_allow
                                , b2.cdml_paid_amt
                                , b2.ipcd_id
                                , ipcd.ipcd_desc
                                , b2.cdml_units_allow as PAID_HOURS
                                /*unit conversion used by Health Economics*/
                                , (case when substr(b2.ipcd_id,1,5) in ('T1019', 'S5130','G0154', 'G0156', 'S5125') then b2.cdml_units_allow*15/60
                                                                            else b2.cdml_units_allow end) as PAID_HOURS_HE
                            from tmg.Cmc_clcl_claim b
                            --
                                 /*claim line level tables start here*/
                                 left join tmg.cmc_cdml_cl_line b2 on (b.clcl_id=b2.clcl_id    )
                                 left join tmg.cmc_seds_se_desc seds on (b2.sese_id=seds.sese_id)
                                 left join tmg.cmc_ipcd_proc_cd ipcd on (b2.ipcd_id=ipcd.ipcd_id)
                            --
                                 /*member and provider info*/
                                 left join TMG.CMC_prpr_prov C on b.prpr_id=c.prpr_id
                                 left join tmg.cmc_meme_member F on b.meme_ck=f.meme_ck
                                 left join tmg.cmc_sbsb_subsc G on f.sbsb_ck=g.sbsb_ck
                                 JOIN TMG.Cmc_mepe_prcs_elig K ON (b.MEME_CK=K.MEME_CK
                                                                AND b.clcl_low_svc_dt between k.MEPE_EFF_DT and k.MEPE_TERM_DT)
                             where 1=1
                                    and b2.cdml_from_dt between to_date(v_begdt, 'yyyymmdd') and to_Date(v_enddt,'yyyymmdd')
                                    AND b.clcl_cur_sts not in ('99', '91')
                                    and b.CLCL_TOT_PAYABLE>0 /*claim not denied*/
                                        and substr(b2.ipcd_id,1,5) in   ('S5125', 'T1019', 'S9122','S5126', 'G0156', 'S5185', 'G0154', 'T1020', 'T1021', 'S5130', 'S5131')
                            --
                                        and k.pdpd_id in ( 'HMD00002', 'HMD00003', 'MD000002','MD000003')  /*MLTC*/
                                        and k.mepe_elig_ind='Y'
                        )
                    ) a,
                    (SELECT /*+ materialize no_merge full(b) */ mrn, month_id, subscriber_id, COUNTY_CODE,BOROUGH 
                    FROM  
                        --choicebi.FACT_MEMBER_MONTH b
                        CHOICEBI.FACT_MEMBER_MONTH b 
                    WHERE program = v_lob_name  --EO7 File changes
                    and dl_lob_id in (2,5)
                    ) B
                    where
                    a.SUBSCRIBER_ID = b.SUBSCRIBER_ID(+) and
                    to_char(a.service_Date,'yyyymm') = b.month_id(+)
                ) a ,
                (       /* get data for null MRN which can be populated by looking back at FMM with matching subscriber id and getting max monthid's MRN to populate */
                    select subscriber_id, mrn from
                    (
                      (
                          select /*+ full(a) */ a.*, ROW_NUMBER() OVER (PARTITION BY a.subscriber_id ORDER BY month_id desc) AS seq
                          from 
                            CHOICEBI.FACT_MEMBER_MONTH a 
                          where program = v_lob_name    --EO7 File changes
                          and dl_lob_id in (2,5)
                      ) fmm
                    ) where seq = 1
                ) b
                where a.SUBSCRIBER_ID = b.subscriber_id(+)
            )
        ) a;
        xutl.out('F_PAID_HRS_BY_SOURCE - TMGCLAIM -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_PAID_HRS_BY_SOURCE', '', 10);

        Insert into F_PAID_HRS_BY_SOURCE
        select /*+ noparallel  */
              v_lob_id    LOB_ID
             ,v_lob_name LINE_OF_BUSINESS
            ,a.CLAIM_SOURCE
            ,a.MONTH_ID
            ,a.MRN
            ,a.SUBSCRIBER_ID
            ,a.CASE_NUM
            ,a.SERVICE_DATE
            ,a.PAY_DATE
            ,a.INVOICE_NO
            ,a.PAY_TWICE_DAILY
            ,a.PAY_SEQUENCE
            ,a.PAY_CYCLE_ID
            ,a.PAY_PROVIDER_ID
            ,a.PAY_TYPE_PAYMENT
            ,a.PAID_HOURS
            ,a.PAID_HOURS_HE
            ,a.PAY_AMOUNT
            ,a.PRPR_NAME
            ,a.PRPR_MCTR_TYPE
            ,a.SESE_ID
            ,a.SEDS_DESC
            ,a.IS_ACTIVE
            ,a.COUNTY_CODE
            ,a.BOROUGH
            ,a.JOB_RUN_ID
            ,a.SYS_UPD_TS
            , null member_id
        from
        (
            (
                select /*+ no_merge */
                     'TPPVE' CLAIM_SOURCE
                    ,B.MONTH_ID
                    ,A.MRN
                    ,B.SUBSCRIBER_ID
                    ,CASE_NUM
                    ,SERVICE_DATE
                    ,PAY_DATE
                    ,INVOICE_NO
                    ,PAY_TWICE_DAILY
                    ,PAY_SEQUENCE
                    ,PAY_CYCLE_ID
                    ,PAY_PROVIDER_ID
                    ,PAY_TYPE_PAYMENT
                    ,PAID_HOURS
                    ,PAID_HOURS PAID_HOURS_HE
                    ,PAY_AMOUNT
                    ,NULL PRPR_NAME
                    ,NULL PRPR_MCTR_TYPE
                    ,NULL SESE_ID
                    ,NULL SEDS_DESC
                    ,DECODE(B.MONTH_ID,NULL,0,1)  IS_ACTIVE
                    ,B.COUNTY_CODE
                    ,B.BOROUGH
                    ,NULL JOB_RUN_ID
                    ,SYSDATE SYS_UPD_TS
                From
                (
                    with case_fct as
                    (SELECT /* materialize */ MRN, CASE_NUM FROM DW_OWNER.CASE_FACTS WHERE PROGRAM IN ('VCP', 'VCM', 'VCC', 'VCT', 'EVP'))
                    SELECT  /*+ noparallel ordered */
                         cast(B.MRN as varchar2(100)) MRN
                        ,null subscriber_id
                        ,cast(B.CASE_NUM as varchar2(100)) CASE_NUM
                        ,T1.PAY_VISIT_DATE AS SERVICE_DATE
                        ,T1.PAY_PROCESS_DATE AS PAY_DATE
                        ,T1.PAY_ID_NO   INVOICE_NO
                        ,T1.PAY_TWICE_DAILY
                        ,T1.PAY_SEQUENCE
                        ,T1.PAY_CYCLE_ID
                        ,T1.PAY_PROVIDER_ID
                        ,T1.PAY_TYPE_PAYMENT
                        ,((CASE     WHEN T1.PAY_TYPE_PAYMENT ='A' THEN 0
                            WHEN  T1.PAY_TYPE_PAYMENT='T' THEN  -1*( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                            ELSE ( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                         END)) AS PAID_HOURS
                        ,((CASE     WHEN T1.PAY_TYPE_PAYMENT ='A' THEN 0
                            WHEN  T1.PAY_TYPE_PAYMENT='T' THEN  -1*( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                            ELSE ( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                         END)) PAID_HOURS_HE
                        ,T1.PAY_AMOUNT
                    FROM DW_OWNER.TPPVE_PAYMENT T1, case_fct B
                    WHERE (T1.PAY_CASE_NO = B.CASE_NUM)
                        AND T1.PAY_VISIT_DATE BETWEEN TO_DATE(V_BEGDT, 'yyyymmdd') AND TO_DATE(V_ENDDT,'yyyymmdd')
                        AND T1.PAY_CO_CODE IN ('00110','00107')
                        AND T1.PAY_ID_NO LIKE 'V%'
                ) a,
                (SELECT /*+ materialize no_merge full(b) */  MONTH_ID, MRN, SUBSCRIBER_ID, BOROUGH, COUNTY_CODE 
                FROM  
                    --choicebi.FACT_MEMBER_MONTH b
                    CHOICEBI.FACT_MEMBER_MONTH b 
                WHERE program = v_lob_name and dl_lob_id in (2,5)) B
                where
                    a.mrn = b.mrn(+) and
                    to_char(a.service_Date,'yyyymm') = b.month_id(+)
            )
        ) a;

        xutl.out('F_PAID_HRS_BY_SOURCE - TPPVE -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_PAID_HRS_BY_SOURCE', '', 10);

        Insert into F_PAID_HRS_BY_SOURCE
        select /*+ noparallel NOREWRITE */
              v_lob_id    LOB_ID
             ,v_lob_name LINE_OF_BUSINESS
            ,a.CLAIM_SOURCE
            ,a.MONTH_ID
            ,a.MRN
            ,a.SUBSCRIBER_ID
            ,a.CASE_NUM
            ,a.SERVICE_DATE
            ,a.PAY_DATE
            ,a.INVOICE_NO
            ,a.PAY_TWICE_DAILY
            ,a.PAY_SEQUENCE
            ,a.PAY_CYCLE_ID
            ,a.PAY_PROVIDER_ID
            ,a.PAY_TYPE_PAYMENT
            ,a.PAID_HOURS
            ,a.PAID_HOURS_HE
            ,a.PAY_AMOUNT
            ,a.PRPR_NAME
            ,a.PRPR_MCTR_TYPE
            ,a.SESE_ID
            ,a.SEDS_DESC
            ,a.IS_ACTIVE
            ,a.COUNTY_CODE
            ,a.BOROUGH
            ,a.JOB_RUN_ID
            ,a.SYS_UPD_TS
            , null member_id
        from
        (
           (
                SELECT /*+ no_merge */
                     'TPCHG' CLAIM_SOURCE
                    ,B.MONTH_ID
                    ,A.MRN
                    ,B.SUBSCRIBER_ID
                    ,CASE_NUM
                    ,SERVICE_DATE
                    ,PAY_DATE
                    ,INVOICE_NO
                    ,PAY_TWICE_DAILY
                    ,NULL PAY_SEQUENCE
                    ,NULL PAY_CYCLE_ID
                    ,NULL PAY_PROVIDER_ID
                    ,NULL PAY_TYPE_PAYMENT
                    ,PAID_HOURS
                    ,PAID_HOURS PAID_HOURS_HE
                    ,PAY_AMOUNT
                    ,NULL PRPR_NAME
                    ,NULL PRPR_MCTR_TYPE
                    ,NULL SESE_ID
                    ,NULL SEDS_DESC
                    ,DECODE(B.MONTH_ID,NULL,0,1)  IS_ACTIVE
                    ,B.COUNTY_CODE
                    ,B.BOROUGH
                    ,NULL JOB_RUN_ID
                    ,SYSDATE SYS_UPD_TS
                FROM
                (
                    SELECT /*+ leading(t1,b, t2) use_hash(t1 t2 b) */
                         cast(B.MRN as varchar2(100)) MRN
                        ,cast(t1.case_no as varchar2(100)) CASE_NUM
                        ,t1.visit_dte as service_date
                        ,t2.inv_dte as pay_date
                        ,t2.inv_no  INVOICE_NO
                        ,TWICE_DAILY_SEQ_NO PAY_TWICE_DAILY
                        ,t1.no_of_hours as PAID_HOURS
                        ,t1.chge_amt PAY_AMOUNT
                    from  (select /* no_merge index(t, TPCHG_CHARGE_IX_PYR) */ case_no,no_of_hours,chg_boro,visit_dte,inv_no,payor_code,STAFF_ID,CHGE_STTS,CHGE_AMT,TWICE_DAILY_SEQ_NO from dw_owner.TPCHG_CHARGE where payor_code in ('VCP','VCM', 'VCC', 'VCT','EVP')) t1,
                        dw_owner.open_invoice t2,
                        dw_owner.case_facts b
                    where 1=1
                        and t1.case_no=b.case_num
                        and t1.inv_no=t2.inv_no
                        and to_char(t1.visit_dte, 'yyyymmdd') between v_begdt and v_enddt
                        and t1.inv_no is not null
                        and t2.inv_dte is not null
                        and t1.payor_code in ('VCP','VCM', 'VCC', 'VCT','EVP')
                        and t1.STAFF_ID like 'V%'
                        and t1.CHGE_STTS NOT IN ('DEL','CHD','NBT','NBV','AWO','NBS')
                ) a,
                (SELECT /*+ full(b) */ mrn, month_id, subscriber_id, COUNTY_CODE,BOROUGH  
                FROM  
                    --choicebi.FACT_MEMBER_MONTH b
                    CHOICEBI.FACT_MEMBER_MONTH b 
                WHERE program = v_lob_name and dl_lob_id in (2,5)) B
                where
                    a.mrn = b.mrn(+) and
                    to_char(a.service_Date,'yyyymm') = b.month_id(+)
            )
        ) a;
        xutl.out('F_PAID_HRS_BY_SOURCE - TPCHG -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_PAID_HRS_BY_SOURCE', '', 10);

        insert into FACT_MEMBER_PAID_HRS_BY_DAY
        (
            THE_DATE,
            MONTH_ID,
            MRN,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE,
            ORDERED_DAY,ORDERED_DAY_HE,PAID_HOURS,PAID_HOURS_HE,
            OPS_HRS_DAY,
            AUTH_HRS_DAY,
            AUTH_HRS_DAY_HE,
            LINE_OF_BUSINESS,
            lob_id,
            tppve_hrs_day,
            chg_hrs_day,
            tmg_hrs_day,
            tmg_hrs_day_he,
            SYS_UPD_TS
            , member_id
        )
        select
            THE_DATE,
            MONTH_ID,
            MRN,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE,
            sum(ORDERED_DAY) ORDERED_DAY,
            sum(ORDERED_DAY_HE) ORDERED_DAY_HE,
            sum(PAID_HOURS) PAID_HOURS,
            sum(PAID_HOURS_HE) PAID_HOURS_HE,
            sum(ops_hrs_day) ops_hrs_day,
            sum(auth_hrs_day) auth_hrs_day,
            sum(auth_hrs_day_he) auth_hrs_day_he,
            v_lob_name LINE_OF_BUSINESS  ,
            v_lob_id lob_id,
            sum(tppve_hrs_day) tppve_hrs_day,
            sum(chg_hrs_day) chg_hrs_day,
            sum(tmg_hrs_day) tmg_hrs_day,
            sum(tmg_hrs_day_he) tmg_hrs_day_he,
            sysdate
            , null member_id
        from
        (
                select
                     coalesce(p.service_date, o.the_date) as the_date
                    ,nvl(p.month_id,o.month_id) month_id
                    ,nvl(p.MRN, o.mrn) mrn
                    ,nvl(p.SUBSCRIBER_ID , o.SUBSCRIBER_ID) SUBSCRIBER_ID
                    ,coalesce(o.ordered_day, 0) as ordered_day
                    ,coalesce(o.ordered_day_HE,0) as ordered_day_HE
                    ,coalesce(p.paid_hours,0) as paid_hours
                    ,coalesce(p.paid_hours_HE,0) as paid_hours_HE
                    ,nvl(p.COUNTY_CODE, o.COUNTY_CODE) COUNTY_CODE
                    ,nvl(p.BOROUGH, o.BOROUGH) BOROUGH
                    ,nvl(p.IS_ACTIVE, o.IS_ACTIVE) IS_ACTIVE
                    ,ops_hrs_day, auth_hrs_day, auth_hrs_day_he
                    ,tppve_hrs_day
                    ,chg_hrs_day
                    ,tmg_hrs_day
                    ,tmg_hrs_day_he
                from
                /*ordered by date*/
                (
                    select
                         the_date,b.month_id month_id, a.mrn,subscriber_id, county_code, borough,  decode(b.month_id,null,0,1) is_active
                        ,sum(ordered_day) as ordered_day
                        ,sum(ordered_day_HE) as ordered_day_HE, max(SOURCE) source
                        ,sum(ORDERHRS_LV_DAY) ops_hrs_day
                        ,sum(AUTH_UNITS_DAY) auth_hrs_day
                        ,sum(AUTH_UNITS_DAY_he) auth_hrs_day_he
                    from temp_ordered a,(SELECT * FROM  
                                          --choicebi.FACT_MEMBER_MONTH b
                                          CHOICEBI.FACT_MEMBER_MONTH b 
                                          WHERE dl_lob_id in (2,5) and program = v_lob_name) B
                    where
                        a.mrn = b.mrn(+) and
                        to_char(a.the_date,'yyyymm') = b.month_id(+)
                    group by
                        the_date,b.month_id, a.mrn,subscriber_id, county_code, borough
                ) o
                full join
                /*paid by date*/
                (
                    select service_date,
                            month_id, mrn,subscriber_id, county_code, borough, is_active,
                            sum(paid_hours) as paid_hours,
                            sum(paid_hours_HE) as paid_hours_HE
                            ,sum(decode(CLAIM_SOURCE, 'TPPVE', paid_hours,null))  tppve_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TPCHG', paid_hours,null))    chg_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TMGCLAIM', paid_hours,null))    tmg_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TMGCLAIM', paid_hours_he,null)) tmg_hrs_day_he
                    from
                    (
                      select * from F_PAID_HRS_BY_SOURCE where line_of_business = v_lob_name and SERVICE_DATE between to_date(v_begdt, 'yyyymmdd') and to_Date(v_enddt, 'yyyymmdd')
                    )
                    group by
                        service_date, month_id, mrn,subscriber_id,county_code, borough,  is_active
                ) p
                on (o.the_date = p.service_date and
                    o.month_id = p.month_id  and
                    o.mrn  = p.mrn and
                    o.subscriber_id = p.subscriber_id
                    )
        )
        group by
            THE_DATE,
            MONTH_ID,
            MRN,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE;

        xutl.out('FACT_MEMBER_PAID_HRS_BY_DAY -> ' || sql%rowcount);
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'FACT_MEMBER_PAID_HRS_BY_DAY', '', 10);
        COMMIT;

        xutl.OUT ('ended');
        xutl.run_end;
    EXCEPTION
        WHEN OTHERS
        THEN
            xutl.out_e (-20156, tid || ' ' || SUBSTR (SQLERRM, 1, 500));
            ROLLBACK;
            RAISE;
    end p_member_paid_hrs_by_day_mltc;

    procedure p_member_paid_hrs_by_day_fida (p_year in number default null ) as
        v_year varchar2(4);
        v_choice_year varchar2(5);
        v_jan1_dt varchar2(10);
        v_dec31_dt varchar2(10);
        v_begdt varchar2(10);
        v_enddt varchar2(10);

        v_recnt_per_thread number:=0;
        v_start number:=0;
        v_end number:=0;

        ex_misc         EXCEPTION;
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'p_member_paid_hrs_by_day_fida';

        v_lob_id       number;
        v_lob_name      varchar2(400);

    begin
        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('started');

        if (p_year is null) then
            v_year := to_char(sysdate,'YYYY');
        else
            v_year := p_year;
        end if;
       xutl.OUT ('Truncating temp tables for p_member_paid_hrs_by_day_mltc for FIDA ...');

       BEGIN
          FOR rec
          IN (SELECT owner, table_name
              FROM all_tables
              WHERE owner = 'CHOICEBI'
                    AND table_name IN
                             (  'TEMP_AUTHS_MBR',
                                'TEMP_ORDERED',
                                'TEMP_PARA_ORDER_DAY2',
                                'TEMP_PARA_ORDER_MBR2',
                                'TEMP_PARA_ORDER_MBR'
                                ))
          LOOP
             BEGIN

                EXECUTE IMMEDIATE   'TRUNCATE TABLE '
                                 || rec.owner
                                 || '.'
                                 || rec.table_name
                                 ;
               DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', rec.table_name, '', 10);

             EXCEPTION
                WHEN OTHERS
                THEN
                   BEGIN
                    xutl.OUT (DBMS_UTILITY.format_error_backtrace
                                || CHR (13)
                                || CHR (10)
                                || DBMS_UTILITY.FORMAT_CALL_STACK );
                                        xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   END;
             END;
          END LOOP;

       EXCEPTION
          WHEN OTHERS
          THEN
             BEGIN
                   xutl.OUT (DBMS_UTILITY.format_error_backtrace
                || CHR (13)
                || CHR (10)
                || DBMS_UTILITY.FORMAT_CALL_STACK );
                   xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   null;
             END;
       END;
       xutl.OUT ('Truncate complete for temp tables p_member_paid_hrs_by_day_fida ...');
      --select lob_id, LOB_NAME into v_lob_id , v_lob_name from MSTRSTG.D_LINE_OF_BUSINESS where LOB_NAME = 'FIDA' and rownum = 1;
      select dl_LOB_GRP_id lob_id, LOB_GRP_DESC LOB_NAME into v_lob_id , v_lob_name from MSTRSTG.D_LOB_GROUP where LOB_GRP_DESC = 'FIDA' and rownum = 1;
        /*
        --get year begin and end date for given choice year
        */

        select
            to_number(substr(to_char(choice_week_id),1,4)) as choice_year,
            to_number(to_char(to_number(substr(to_char(choice_week_id),1,4))) || '0101') as jan1_dt,
            to_number(to_char(to_number(substr(to_char(choice_week_id),1,4))) || '1231') as dec31_dt,
            to_number(to_char(min(day_date),'yyyymmdd')) as begdt,
            to_number(to_char(max(day_date),'yyyymmdd')) as enddt
            into v_choice_year, v_jan1_dt, v_dec31_dt, v_begdt, v_enddt
        from mstrstg.lu_day a
        where to_number(substr(to_char(choice_week_id),1,4))=v_year
            and
                   (
                    to_number(substr(to_char(choice_week_id),5,2)) =    (
                                                                            select max(to_number(substr(to_char(choice_week_id),5,2))) as week_id
                                                                            from mstrstg.lu_day
                                                                            where to_number(substr(to_char(choice_week_id),1,4))= to_number(substr(to_char(a.choice_week_id),1,4))
                                                                            group by to_number(substr(to_char(choice_week_id),1,4))
                                                                        )
                    OR
                    to_number(substr(to_char(choice_week_id),5,2))=1
                   )
        group by to_number(substr(to_char(choice_week_id),1,4));


        xutl.OUT(v_choice_year || '|' || v_jan1_dt || '|' ||v_dec31_dt || '|' ||v_begdt || '|' || v_enddt);

        insert into TEMP_PARA_ORDER_MBR
        with allmbrmonth as
        (
                select
                    mrn
                    ,subscriber_id
                    , member_id 
                    ,month_id
                    ,to_date(month_id, 'yyyymm') as mbrmonth_start
                    ,trunc(add_months(to_date(month_id, 'yyyymm'),1),'mm')-1 as mbrmonth_end
                from
                    --choicebi.fact_member_month a
                    CHOICEBI.FACT_MEMBER_MONTH a
                where
                    program = v_lob_name and
                    to_date(a.month_id, 'yyyymm') between to_date(v_jan1_dt, 'yyyymmdd') and to_date(v_dec31_dt, 'yyyymmdd')
        )
        select *
        from
        (
            select para_ord_mrn, para_case_nbr, para_case_seq
                , para_ord_prog
                , para_ord_choice
                , para_ord_fida
                , para_ord_mltc
                , para_ord_status, para_ord_service
                , (para_ord_entry_dte) as para_ord_entry_dte
                , (para_req_start_dte) as para_req_start_dte
                , (order_end) as order_end
                , (sched_wk_beg_date) as sched_wk_beg_date
                , (sched_wk_end_date) as sched_wk_end_date
                , seq_no_desc
                , sumhours_lv_wk
                , sched_saturday_lv
                , sched_sunday_lv
                , sched_monday_lv
                , sched_tuesday_lv
                , sched_wednesday_lv
                , sched_thursday_lv
                , sched_friday_lv
                , member_id
            from
            (select z.*
             from
                (select /*+ USE_MERGE(A,MRNDIST) */
                        distinct a.member_id, a.para_ord_mrn, a.para_case_nbr, a.para_case_seq
                        , a.para_ord_prog
                        , (case when substr(a.para_ord_prog,1,1)='V' then 1 else 0 end) as para_ord_choice
                        , (case when a.para_ord_prog='VCF' then 1 else 0 end) as para_ord_fida
                        , (case when a.para_ord_prog like 'V%' and a.para_ord_prog <> 'VCF' then 1 else 0 end) as para_ord_mltc
                        , a.para_ord_status, a.para_ord_service
                        , to_date(decode(a.para_ord_entry_dte,0,null, a.para_ord_entry_dte), 'yyyymmdd') as para_ord_entry_dte
                        , to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd') as para_req_start_dte
                        , to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd')  as order_end
                        , to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') as sched_wk_end_date
                        , (case when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                 and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 > to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                 then to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                 and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 <= to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                 then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is null
                                 then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                            end) as sched_wk_beg_date
                        , row_number() over (partition by a.para_ord_mrn, a.para_case_nbr, a.para_case_seq order by b.sched_wk_end_date desc) as seq_no_desc
                       , row_number() over
                            (partition by a.para_ord_mrn
                                , a.para_case_nbr
                                , a.para_ord_service
                                , (case when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                 and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 > to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                 then to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                 and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6 <= to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                 then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                when to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is null
                                 then to_date(decode(a.para_req_start_dte,0,null, a.para_req_Start_dte), 'yyyymmdd')
                                end)
                               order by a.para_ord_entry_dte desc, b.sched_wk_end_date desc) as sort_seq
                        ,(
                          (case when b.sched_lv_in_flag2='Y' then 13 else b.sched_saturday end)
                           +(case when b.sched_lv_in_flag3='Y' then 13 else b.sched_sunday end)
                           +(case when b.sched_lv_in_flag4='Y' then 13 else b.sched_monday end)
                           +(case when b.sched_lv_in_flag5='Y' then 13 else b.sched_tuesday end)
                           +(case when b.sched_lv_in_flag6='Y' then 13 else b.sched_wednesday end)
                           +(case when b.sched_lv_in_flag7='Y' then 13 else b.sched_thursday end)
                           +(case when b.sched_lv_in_flag8='Y' then 13 else b.sched_friday end)
                        ) as sumhours_lv_wk
                        , (case when sched_lv_in_flag2='Y' then 13 else sched_saturday end) as sched_saturday_lv
                        , (case when sched_lv_in_flag3='Y' then 13 else sched_sunday end) as sched_sunday_lv
                        , (case when sched_lv_in_flag4='Y' then 13 else sched_monday end) as sched_monday_lv
                        , (case when sched_lv_in_flag5='Y' then 13 else sched_tuesday end) as sched_tuesday_lv
                        , (case when sched_lv_in_flag6='Y' then 13 else sched_wednesday end) as sched_wednesday_lv
                        , (case when sched_lv_in_flag7='Y' then 13 else sched_thursday end) as sched_thursday_lv
                        , (case when sched_lv_in_flag8='Y' then 13 else sched_friday end) as sched_friday_lv
                    from 
                        --dw_owner.tpopsd_para_order a                        
                    (
                        select /*+ MATERIALIZE */ 
                        distinct coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id, b.*
                        from dw_owner.tpopsd_para_order b
                        left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b1 on (to_char(b.para_ord_mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
                        left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b2 on (to_char(b.para_ord_mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
                        left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b3 on (to_char(b.para_ord_mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)  
                    ) a                        
                    join dw_owner.tpopsd_para_sche b on (a.para_case_nbr=b.sched_case_nbr and a.para_case_seq = b.sched_case_seq)
                    --join (select distinct mrn from allmbrmonth) mrndist   on (mrndist.mrn=A.para_ord_mrn)
                    join (select distinct member_id from allmbrmonth) mrndist   on (mrndist.member_id=A.member_id)
                    where (a.para_ord_status in ('AA', 'AC', 'DP', 'DD') or (a.para_ord_status='CC' and a.para_ord_service=6))
                    and (case when substr(a.para_ord_prog,1,1)='V' and a.para_ord_prog<>'VCF' then 1 else 0 end) <> 1 /*do not include MLTC*/
                    and substr(a.para_ord_prog,1,1) <> 'K' /*exclude Partners - private pay, plus typos in dates*/
                    and decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0, 99991231, greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds))>= a.para_req_start_dte /*order end dt >= order start dt*/
                    /*    limit orders to applicable to dates*/
                    and decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0, 99991231, greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)) >= v_begdt /*order end dt >= beg of year*/
                    and a.para_req_Start_dte <= v_enddt /*order start dt <= end of year*/
                    and a.para_req_start_dte > 991231 /*don't include these old orders from before year 2000*/
                    /* exclude schedules where sched_wk_beg_dt occurs after the order end dt*/
                    and (case when (to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd') is not null
                                 and to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd') is not null
                                 and to_date(decode(greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds),0,null,greatest(a.para_canc_disc_dte, a.para_ci_dte_ord_ds)), 'yyyymmdd')
                                 < to_date(decode(b.sched_wk_end_date,0,null, b.sched_wk_end_date), 'yyyymmdd')-6
                                ) then 1 else 0 end) = 0
                    order by a.para_ord_mrn, a.para_case_nbr, a.para_case_seq, seq_no_desc desc
                ) z
                where z.sort_seq=1
                )
            ) para_order_mbr;
        xutl.out('TEMP_PARA_ORDER_MBR -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_MBR', '', 10);

        Insert into TEMP_PARA_ORDER_DAY2
        with para_order_mbr2 as
         (
                    select
                        /*+ MATERIALIZE  */
                        para_ord_mrn
                       , para_case_nbr
                       , para_case_seq
                       , para_ord_prog
                       , para_ord_choice
                       , para_ord_fida
                       , para_ord_mltc
                       , para_ord_status
                       , para_ord_service
                       , (para_ord_entry_dte) as para_ord_entry_dte
                       , (para_req_Start_dte) as para_req_Start_dte
                       , (order_end) as order_end
                       , (sched_wk_beg_date) as sched_wk_beg_date
                       , (sched_wk_end_date) as sched_wk_end_date
                       , seq_no_desc
                       , sumhours_lv_wk
                       , (sched_beg) as sched_beg
                       , (sched_end) as sched_end
                       , sched_saturday_lv
                       , sched_sunday_lv
                       , sched_monday_lv
                       , sched_tuesday_lv
                       , sched_wednesday_lv
                       , sched_thursday_lv
                       , sched_friday_lv
                       , member_id
                    from
                    (
                    SELECT z.para_ord_mrn
                       , z.para_case_nbr
                       , z.para_case_seq
                       , z.para_ord_prog
                       , z.para_ord_choice
                       , z.para_ord_fida
                       , z.para_ord_mltc
                       , z.para_ord_status
                       , z.para_ord_service
                       , z.para_ord_entry_dte
                       , z.para_req_Start_dte
                       , z.order_end
                       , z.sched_wk_beg_date
                       , z.sched_wk_end_date
                       , z.seq_no_desc
                       , z.sumhours_lv_wk
                       , z.sched_beg
                       , z.sched_end
                       , z.sched_saturday_lv
                       , z.sched_sunday_lv
                       , z.sched_monday_lv
                       , z.sched_tuesday_lv
                       , z.sched_wednesday_lv
                       , z.sched_thursday_lv
                       , z.sched_friday_lv
                       , z.member_id
                  FROM
                    (SELECT x.*
                            , x.sched_wk_beg_date AS sched_beg
                            ,(CASE WHEN (x.offset_date <> x.sched_wk_beg_date
                                          AND (x.offset_date <> to_Date('31-DEC-9999') OR NVL (x.seq_no_desc, 0) <> 1)
                                          AND (x.offset_date <> x.order_end OR NVL (x.seq_no_desc, 0) <> 1))
                             THEN x.offset_date - 1
                             ELSE x.offset_date
                             END) AS sched_end
                     FROM
                        ( SELECT a.*
                                  ,(CASE WHEN b.fst_para_ord_entry_dt IS NOT NULL
                                    THEN
                                         (CASE WHEN a.order_end IS NOT NULL THEN a.order_end
                                               WHEN a.order_end IS NULL THEN to_date('31-DEC-9999')
                                          END)
                                    ELSE a.lagdate
                                    END) AS offset_date
                           FROM
                                (SELECT c.*
                                        ,LAG (sched_wk_beg_date, 1) OVER (ORDER BY para_ord_mrn, para_case_nbr, para_ord_service, para_ord_entry_dte, sched_wk_beg_date DESC, sched_wk_end_date) AS lagdate
                                FROM TEMP_PARA_ORDER_MBR c) a
                                   LEFT JOIN
                               (SELECT para_ord_mrn, para_case_nbr, para_ord_service, sched_wk_beg_date
                                            , sched_wk_end_date
                                            , para_ord_entry_dte AS fst_para_ord_entry_dt
                                            , seq_no_desc
                                 FROM TEMP_PARA_ORDER_MBR
                                 WHERE seq_no_desc=1) b
                                 ON (b.para_ord_mrn = a.para_ord_mrn
                                     AND b.para_case_nbr = a.para_case_nbr
                                     AND b.para_ord_service=a.para_ord_service
                                     AND b.fst_para_ord_entry_dt = a.para_ord_entry_dte
                                     AND b.sched_wk_beg_date = a.sched_wk_beg_date
                                     AND NVL (b.sched_wk_end_date, '01-JAN-0001') = NVL (a.sched_wk_end_date, '01-JAN-0001'))
                          ) x
                     ) z
--                ORDER BY z.para_ord_mrn, z.para_case_nbr, z.para_ord_service, z.sched_beg
                )
        )
        ,para_order_day as
        (
                    select para_ord_mrn
                    , para_case_nbr
                    , para_case_seq
                    , para_ord_prog
                    , para_ord_choice
                    , para_ord_fida
                    , para_ord_mltc
                    , para_ord_status
                    , para_ord_service
                   , (para_ord_entry_dte) as para_ord_entry_dte
                   , (para_req_Start_dte) as para_req_Start_dte
                   , (order_end) as order_end
                   , (sched_wk_beg_date) as sched_wk_beg_date
                   , (sched_wk_end_date) as sched_wk_end_date
                   , seq_no_desc
                   , sumhours_lv_wk
                   , (sched_beg) as sched_beg
                   , (sched_end) as sched_end
                   , (the_date) as the_date
                   , orderhrs_lv_day
                   , dow
                   , sched_saturday_lv
                   , sched_sunday_lv
                   , sched_monday_lv
                   , sched_tuesday_lv
                   , sched_wednesday_lv
                   , sched_thursday_lv
                   , sched_friday_lv
                   , member_id
            from
            (
         select para_ord_mrn, para_case_nbr, para_case_seq, para_ord_prog
                , para_ord_choice, para_ord_fida, para_ord_mltc, para_ord_status, para_ord_service
                , para_ord_entry_Dte, para_req_start_dte, order_end, sched_wk_beg_date, sched_wk_end_date, seq_no_desc
                , sumhours_lv_wk, sched_beg, sched_end, the_date, orderhrs_lv_day, dow
                , sched_saturday_lv, sched_sunday_lv, sched_monday_lv, sched_tuesday_lv, sched_wednesday_lv, sched_thursday_lv, sched_friday_lv, member_id
        from
            (select y.*, ROW_NUMBER() OVER (PARTITION BY y.para_ord_mrn, y.the_date ORDER BY y.para_ord_choice desc, y.para_ord_entry_dte desc) AS cob_disc_sort_seq
            from
                (select * from
                    (select x.*, ROW_NUMBER() OVER (PARTITION BY x.para_ord_mrn, x.para_ord_service, x.the_date ORDER BY x.para_ord_choice desc) AS cob_sort_seq
                    from
                        (select *
                        from
                            (select z.*
                                , b.day_date as the_date
                                , to_char(b.day_Date,'DY','nls_date_language=english') as dow
                                , (case when to_char(b.day_Date,'DY','nls_date_language=english')='SUN' then sched_sunday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='MON' then sched_monday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='TUE' then sched_tuesday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='WED' then sched_wednesday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='THU' then sched_thursday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='FRI' then sched_friday_lv
                                        when to_char(b.day_Date,'DY','nls_date_language=english')='SAT' then sched_saturday_lv
                                   end) as orderhrs_lv_day
                                , row_number() over (partition by z.para_ord_mrn, z.para_ord_prog, z.para_ord_service, b.day_date order by z.para_req_start_dte desc) as sort_seq
                                from para_order_mbr2 z
                                join mstrstg.lu_day b on (B.DAY_DATE between z.sched_beg and decode(z.sched_end,'31DEC9999',to_Date(v_enddt,'yyyymmdd'),z.sched_end))
                            where  b.day_date between to_date(v_begdt,'yyyymmdd') and to_date(v_enddt, 'yyyymmdd')
                            )
                        where sort_seq=1 /*dedupe where the order_end is same date as req_start_dte for same para_ord_prog and para_ord_service*/
                        ) x
                    )
                where cob_sort_seq=1 /*dedupe where there is COB split between CHHA and CHOICE for the same discipline - take the CHOICE instance for a given day/mrn*/
                ) y
            )
        where cob_disc_sort_seq=1 /*dedupe where 2 CHOICE orders for same date but different disciplines (should not occur, take more recent entry date),*/
                                 /*or situations where CHOICE/CHHA occurs for same date with different disciplines (take the CHOICE instance to represent correct COB)*/
--        order by para_ord_mrn, the_date
            )
        )
        select /*+ first_rows(10) */ to_char(the_date,'YYYYMM') month_id, a.*
        from para_order_day a;

        xutl.out('TEMP_PARA_ORDER_DAY2 -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_DAY2', '', 10);

        INSERT INTO temp_ordered            --FACT_OPS_PARA
        (
            MRN,
            THE_DATE,
            ORDERHRS_LV_DAY,
            ORDERED_DAY,
            member_id
        )
        select y.mrn
            , y.the_date
            , y.orderhrs_lv_day
            , (case when y.orderhrs_lv_day is not null then y.orderhrs_lv_day
                    else 0 end) as ordered_day
            , member_id                    
        from
            (select para_ord_mrn as mrn
                    , the_Date
                    , coalesce(orderhrs_lv_day,0) as orderhrs_lv_day
                    , member_id
            from TEMP_para_order_day2
            ) y ;

        xutl.out('temp_ordered -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_ORDERED', '', 10);

        insert into F_PAID_HRS_BY_SOURCE
        select /*+ NOREWRITE*/
              v_lob_id  LOB_ID
            , v_lob_name LINE_OF_BUSINESS
            ,a.CLAIM_SOURCE
            ,a.MONTH_ID
            ,a.MRN
            ,a.SUBSCRIBER_ID
            ,a.CASE_NUM
            ,a.SERVICE_DATE
            ,a.PAY_DATE
            ,a.INVOICE_NO
            ,a.PAY_TWICE_DAILY
            ,a.PAY_SEQUENCE
            ,a.PAY_CYCLE_ID
            ,a.PAY_PROVIDER_ID
            ,a.PAY_TYPE_PAYMENT
            ,a.PAID_HOURS
            ,a.PAID_HOURS_HE
            ,a.PAY_AMOUNT
            ,a.PRPR_NAME
            ,a.PRPR_MCTR_TYPE
            ,a.SESE_ID
            ,a.SEDS_DESC
            ,a.IS_ACTIVE
            ,a.COUNTY_CODE
            ,a.BOROUGH
            ,a.JOB_RUN_ID
            ,a.SYS_UPD_TS
            ,a.MEMBER_ID
         from
         (
             (
                SELECT
                    'TPPVE' CLAIM_SOURCE
                    ,B.MONTH_ID
                    ,A.MRN
                    ,B.SUBSCRIBER_ID
                    ,A.CASE_NUM
                    ,SERVICE_DATE
                    ,PAY_DATE
                    ,INVOICE_NO
                    ,PAY_TWICE_DAILY
                    ,PAY_SEQUENCE
                    ,PAY_CYCLE_ID
                    ,PAY_PROVIDER_ID
                    ,PAY_TYPE_PAYMENT
                    ,PAID_HOURS
                    ,PAID_HOURS PAID_HOURS_HE
                    ,PAY_AMOUNT
                    ,NULL PRPR_NAME
                    ,NULL PRPR_MCTR_TYPE
                    ,NULL SESE_ID
                    ,NULL SEDS_DESC
                    ,DECODE(B.MONTH_ID,NULL,0,1)  IS_ACTIVE
                    ,B.COUNTY_CODE
                    ,B.BOROUGH
                    ,NULL JOB_RUN_ID
                    ,SYSDATE SYS_UPD_TS
                    ,A.MEMBER_ID
                FROM
                    (
                        --with case_fct as
                        --(SELECT /*+ materialize  */ mrn, case_num FROM DW_OWNER.CASE_FACTS WHERE PROGRAM IN ('VCF'))
                        SELECT /*+ noparallel  leading(b, t1)*/
                             cast(B.MRN as varchar2(100)) MRN
                            ,null subscriber_id
                            ,coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id
                            ,cast(B.CASE_NUM as varchar2(100)) CASE_NUM
                            ,T1.PAY_VISIT_DATE AS SERVICE_DATE
                            ,T1.PAY_PROCESS_DATE AS PAY_DATE
                            ,T1.PAY_ID_NO   INVOICE_NO
                            ,T1.PAY_TWICE_DAILY
                            ,T1.PAY_SEQUENCE
                            ,T1.PAY_CYCLE_ID
                            ,T1.PAY_PROVIDER_ID
                            ,T1.PAY_TYPE_PAYMENT
                            ,((CASE     WHEN T1.PAY_TYPE_PAYMENT ='A' THEN 0
                                WHEN  T1.PAY_TYPE_PAYMENT='T' THEN  -1*( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                                ELSE ( T1.PAY_HOURS+T1.PAY_MINUTES/60)
                             END)) AS PAID_HOURS
                            ,T1.PAY_AMOUNT
                          FROM  DW_OWNER.CASE_FACTS b
                                join dw_owner.TPPVE_PAYMENT t1 on (t1.pay_case_no = b.case_num) 
                                left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b1 on (to_char(b.mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
                                left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b2 on (to_char(b.mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
                                left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b3 on (to_char(b.mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)  
                          where 
                                  PROGRAM IN ('VCF')
                              and t1.pay_visit_date between to_date(v_begdt, 'yyyymmdd') and to_date(v_enddt,'yyyymmdd')
                              AND t1.PAY_CO_CODE IN ('00110','00107')
                              AND t1.pay_id_no like 'V%'
                    ) a, (SELECT * FROM CHOICEBI.FACT_MEMBER_MONTH b WHERE program = v_lob_name) B
                where
                    a.member_id = b.member_id(+) and
                    to_char(a.service_Date,'yyyymm') = b.month_id(+)
             )
        ) A;
        xutl.out('F_PAID_HRS_BY_SOURCE - TPPVE -> ' || sql%rowcount);
        commit;

        insert into F_PAID_HRS_BY_SOURCE
        select /*+ NOREWRITE*/
              v_lob_id  LOB_ID
            , v_lob_name LINE_OF_BUSINESS
            ,a.CLAIM_SOURCE
            ,a.MONTH_ID
            ,a.MRN
            ,a.SUBSCRIBER_ID
            ,a.CASE_NUM
            ,a.SERVICE_DATE
            ,a.PAY_DATE
            ,a.INVOICE_NO
            ,a.PAY_TWICE_DAILY
            ,a.PAY_SEQUENCE
            ,a.PAY_CYCLE_ID
            ,a.PAY_PROVIDER_ID
            ,a.PAY_TYPE_PAYMENT
            ,a.PAID_HOURS
            ,a.PAID_HOURS_HE
            ,a.PAY_AMOUNT
            ,a.PRPR_NAME
            ,a.PRPR_MCTR_TYPE
            ,a.SESE_ID
            ,a.SEDS_DESC
            ,a.IS_ACTIVE
            ,a.COUNTY_CODE
            ,a.BOROUGH
            ,a.JOB_RUN_ID
            ,a.SYS_UPD_TS
            ,a.member_id
         from
         (
                select
                    /*+ no_merge */
                    'TPCHG' CLAIM_SOURCE
                    ,B.MONTH_ID
                    ,A.MRN
                    ,B.SUBSCRIBER_ID
                    ,A.CASE_NUM
                    ,SERVICE_DATE
                    ,PAY_DATE
                    ,INVOICE_NO
                    ,PAY_TWICE_DAILY
                    ,NULL PAY_SEQUENCE
                    ,NULL PAY_CYCLE_ID
                    ,NULL PAY_PROVIDER_ID
                    ,NULL PAY_TYPE_PAYMENT
                    ,PAID_HOURS
                    ,PAID_HOURS PAID_HOURS_HE
                    ,PAY_AMOUNT
                    ,NULL PRPR_NAME
                    ,NULL PRPR_MCTR_TYPE
                    ,NULL SESE_ID
                    ,NULL SEDS_DESC
                    ,DECODE(B.MONTH_ID,NULL,0,1)  IS_ACTIVE
                    ,B.COUNTY_CODE
                    ,B.BOROUGH
                    ,NULL JOB_RUN_ID
                    ,SYSDATE SYS_UPD_TS
                    ,A.MEMBER_ID
                from
                    (
                        select /*+ noparallel leading(t1,b, t2) use_hash(t1,t2,b) */
                             cast(B.MRN as varchar2(100)) MRN
                            ,cast(t1.case_no as varchar2(100)) CASE_NUM
                            ,t1.visit_dte as service_date
                            ,t2.inv_dte as pay_date
                            ,t2.inv_no  INVOICE_NO
                            ,TWICE_DAILY_SEQ_NO PAY_TWICE_DAILY
                            ,t1.no_of_hours as PAID_HOURS
                            ,t1.chge_amt PAY_AMOUNT
                            ,coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id
                        from  
                                 (select /*+  materialize   */ case_no,no_of_hours,chg_boro,visit_dte,inv_no,payor_code,STAFF_ID,CHGE_STTS,CHGE_AMT,TWICE_DAILY_SEQ_NO from dw_owner.TPCHG_CHARGE where payor_code in ('VCF')) t1
                            JOIN dw_owner.open_invoice t2  ON (t1.inv_no=t2.inv_no)
                            JOIN dw_owner.case_facts b ON (t1.case_no=b.case_num) 
                            left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b1 on (to_char(b.mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
                            left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b2 on (to_char(b.mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
                            left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from choicebi.xwalk_member_id_mrn x) b3 on (to_char(b.mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)  
                        where
                                t1.visit_dte between to_date(v_begdt, 'yyyymmdd') and to_Date(v_enddt, 'yyyymmdd')
                            and t1.inv_no is not null
                            and t2.inv_dte is not null
                            and t1.payor_code in ('VCF')
                            and t1.STAFF_ID like 'V%'
                            and t1.CHGE_STTS NOT IN ('DEL','CHD','NBT','NBV','AWO','NBS')
                    ) a,
                    (SELECT * FROM CHOICEBI.FACT_MEMBER_MONTH b WHERE program = v_lob_name) B
                where
                    a.member_id = b.member_id(+) and
                    to_char(a.service_Date,'yyyymm') = b.month_id(+)
        ) A;
        xutl.out('F_PAID_HRS_BY_SOURCE - TPCHG -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_PAID_HRS_BY_SOURCE', '', 10);

        insert into FACT_MEMBER_PAID_HRS_BY_DAY
        (
            THE_DATE,
            MONTH_ID,
            MRN,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE,
            ORDERED_DAY,ORDERED_DAY_HE,PAID_HOURS,PAID_HOURS_HE,
            OPS_HRS_DAY,
            AUTH_HRS_DAY,
            AUTH_HRS_DAY_HE,
            LINE_OF_BUSINESS,
            lob_id,
            tppve_hrs_day,
            chg_hrs_day,
            tmg_hrs_day,
            tmg_hrs_day_he,
            SYS_UPD_TS
            ,member_id
        )
        SELECT
            THE_DATE,
            MONTH_ID,
            MRN,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE,
            sum(ORDERED_DAY) ORDERED_DAY,
            sum(ORDERED_DAY_HE) ORDERED_DAY_HE,
            sum(PAID_HOURS) PAID_HOURS,
            sum(PAID_HOURS_HE) PAID_HOURS_HE,
            sum(ops_hrs_day) ops_hrs_day,
            sum(auth_hrs_day) auth_hrs_day,
            sum(auth_hrs_day_he) auth_hrs_day_he,
            v_lob_name  LINE_OF_BUSINESS,
            v_lob_id    LOB_ID,
            sum(tppve_hrs_day) tppve_hrs_day,
            sum(chg_hrs_day) chg_hrs_day,
            sum(tmg_hrs_day) tmg_hrs_day,
            sum(tmg_hrs_day_he) tmg_hrs_day_he,
            sysdate,
            member_id
        from
        (
                select
                     coalesce(p.service_date, o.the_date) as the_date
                    ,nvl(p.month_id,o.month_id) month_id
                    ,nvl(p.MRN, o.mrn) mrn
                    ,nvl(p.SUBSCRIBER_ID , o.SUBSCRIBER_ID) SUBSCRIBER_ID
                    ,coalesce(o.ordered_day, 0) as ordered_day
                    ,coalesce(o.ordered_day_HE,0) as ordered_day_HE
                    ,coalesce(p.paid_hours,0) as paid_hours
                    ,coalesce(p.paid_hours_HE,0) as paid_hours_HE
                    ,nvl(p.COUNTY_CODE, o.COUNTY_CODE) COUNTY_CODE
                    ,nvl(p.BOROUGH, o.BOROUGH) BOROUGH
                    ,nvl(p.IS_ACTIVE, o.IS_ACTIVE) IS_ACTIVE
                    , ops_hrs_day, auth_hrs_day, auth_hrs_day_he
                    ,tppve_hrs_day
                    ,chg_hrs_day
                    ,tmg_hrs_day
                    ,tmg_hrs_day_he
                    ,nvl(p.member_id, o.member_id) member_id
                from
                /*ordered by date*/
                (
                    select
                         the_date,a.member_id, b.month_id month_id, a.mrn,subscriber_id, county_code, borough,  decode(b.month_id,null,0,1) is_active
                        ,sum(ordered_day) as ordered_day
                        ,sum(ordered_day_HE) as ordered_day_HE
                        ,sum(ORDERHRS_LV_DAY) ops_hrs_day
                        ,sum(AUTH_UNITS_DAY) auth_hrs_day
                        ,sum(AUTH_UNITS_DAY_he) auth_hrs_day_he
                    from temp_ordered a, (SELECT * FROM  
                                            --    choicebi.FACT_MEMBER_MONTH b
                                            CHOICEBI.FACT_MEMBER_MONTH b 
                                            WHERE program = v_lob_name) B
                    where
                        a.member_id = b.member_id(+) and
                        to_char(a.the_date,'yyyymm') = b.month_id(+)
                    group by
                        the_date,b.month_id, a.member_id, a.mrn,subscriber_id, county_code, borough
                ) o
                full join
                /*paid by date*/
                (
                    select service_date,
                            month_id, member_id, mrn,subscriber_id, county_code, borough, is_active,
                            sum(paid_hours) as paid_hours,
                            sum(paid_hours_HE) as paid_hours_HE
                            ,sum(decode(CLAIM_SOURCE, 'TPPVE', paid_hours,null))  tppve_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TPCHG', paid_hours,null))    chg_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TMGCLAIM', paid_hours,null))    tmg_hrs_day
                            ,sum(decode(CLAIM_SOURCE, 'TMGCLAIM', paid_hours_he,null)) tmg_hrs_day_he
                    from
                        (
                          select * from F_PAID_HRS_BY_SOURCE where line_of_business = v_lob_name and SERVICE_DATE between to_date(v_begdt, 'yyyymmdd') and to_Date(v_enddt, 'yyyymmdd')
                        )
                    group by
                        service_date, month_id, member_id, mrn,subscriber_id, county_code, borough, is_active
                ) p
                on (o.the_date = p.service_date and
                    o.month_id = p.month_id  and
                    o.member_id  = p.member_id and
                    o.subscriber_id = p.subscriber_id
                    )
        )
        group by
            THE_DATE,
            MONTH_ID,
            MRN,
            MEMBER_ID,
            SUBSCRIBER_ID,
            COUNTY_CODE,
            BOROUGH,
            IS_ACTIVE;
        xutl.out('FACT_MEMBER_PAID_HRS_BY_DAY -> ' || sql%rowcount);
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'FACT_MEMBER_PAID_HRS_BY_DAY', '', 10);
        COMMIT;


        xutl.OUT ('ended');
        xutl.run_end;
    EXCEPTION
        WHEN OTHERS
        THEN
            xutl.out_e (-20156, tid || ' ' || SUBSTR (SQLERRM, 1, 500));
            ROLLBACK;
            RAISE;
    end p_member_paid_hrs_by_day_fida;



    procedure P_uat_risk_score as

        ex_misc         EXCEPTION;
        msg_v          VARCHAR2 (255) := 'starting';
        tid            VARCHAR2 (16) := 'uat_risk_score';

    begin

        xutl.set_id (tid);
        -- xutl.out ('starting...');
        xutl.run_start (tid);
        xutl.OUT ('started');

        xutl.OUT ('merging uat risk score ...');

        merge into uas_risk_score tgt
        using
        (
            (
                select  
                    MERCER_DOC_YEAR , 
                    b.record_id
                    , b.risk_group
                -- From Table 6.7 in Mercer Documentation
                    , case 
                        when risk_group between 0 and 0 then 0.311
                        when risk_group between 1 and 1 then 0.318
                        when risk_group between 2 and 3 then 0.3795
                        when risk_group between 4 and 4 then 0.4102
                        when risk_group between 5 and 5 then 0.4122
                        when risk_group between 6 and 6 then 0.4358
                        when risk_group between 7 and 7 then 0.4366
                        when risk_group between 8 and 8 then 0.4545
                        when risk_group between 9 and 9 then 0.4688
                        when risk_group between 10 and 10 then 0.4927
                        when risk_group between 11 and 11 then 0.4967
                        when risk_group between 12 and 12 then 0.5346
                        when risk_group between 13 and 13 then 0.5673
                        when risk_group between 14 and 14 then 0.5883
                        when risk_group between 15 and 15 then 0.6253
                        when risk_group between 16 and 16 then 0.649
                        when risk_group between 17 and 17 then 0.6644
                        when risk_group between 18 and 18 then 0.6951
                        when risk_group between 19 and 19 then 0.7284
                        when risk_group between 20 and 20 then 0.7669
                        when risk_group between 21 and 21 then 0.7944
                        when risk_group between 22 and 22 then 0.8255
                        when risk_group between 23 and 23 then 0.8592
                        when risk_group between 24 and 24 then 0.8759
                        when risk_group between 25 and 25 then 0.9115
                        when risk_group between 26 and 26 then 0.9352
                        when risk_group between 27 and 27 then 0.9887
                        when risk_group between 28 and 28 then 1.0048
                        when risk_group between 29 and 29 then 1.014
                        when risk_group between 30 and 30 then 1.0654
                        when risk_group between 31 and 31 then 1.1067
                        when risk_group between 32 and 32 then 1.1302
                        when risk_group between 33 and 33 then 1.1574
                        when risk_group between 34 and 34 then 1.1962
                        when risk_group between 35 and 36 then 1.2299
                        when risk_group between 37 and 37 then 1.2903
                        when risk_group between 38 and 38 then 1.3255
                        when risk_group between 39 and 39 then 1.3728
                        when risk_group between 40 and 40 then 1.4214
                        when risk_group between 41 and 41 then 1.4265
                        when risk_group between 42 and 42 then 1.4403
                        when risk_group between 43 and 43 then 1.5123
                        when risk_group between 44 and 44 then 1.5501
                        when risk_group between 45 and 46 then 1.5684
                        when risk_group between 47 and 47 then 1.6431
                        when risk_group between 48 and 48 then 1.6687
                        when risk_group between 49 and 50 then 1.674
                        when risk_group between 51 and 51 then 1.694
                        when risk_group between 52 and 54 then 1.7447
                        when risk_group between 55 and 55 then 1.7743
                        when risk_group between 56 and 56 then 1.8101
                        when risk_group between 57 and 58 then 1.8711
                        when risk_group between 59 and 60 then 1.8858
                        when risk_group between 61 and 61 then 1.942
                        when risk_group between 62 and 63 then 1.9862
                        when risk_group between 64 and 67 then 2.1061
                        when risk_group between 68 and 69 then 2.1477
                        when risk_group between 70 and 74 then 2.3906
                        when risk_group between 75 and 82 then 2.5829
                        when risk_group between 83 and 104 then 2.8941
                      end as risk_score
                from
                    (
                    select 2017 MERCER_DOC_YEAR , a.RECORD_ID
                        , ADLBATHING_SC + ADLBED_SC + ADLDRESSCOMB_SC + ADLTOILETTRANSFER_SC + 
                            ADLWALKING_SC + ADLHIERARCHYSCALE_SC + BLADDERCONTINENCE_SC + BOWELCONTINENCE_SC + 
                            CARDIACFAILURE_SC + FOOTPROBLEMS_SC + IADLCAPACITYMEALS_SC + IADLCAPACITYMEDS_SC + 
                            IADLCAPACITYPHONE_SC + IADLCAPACITYSTAIRS_SC + IADLCAPACITYTRANSPORT_SC + 
                            LOCOMOTIONINDOORS_SC + NEUROLOGICALALZDEM_SC + NEUROLOGICALPLEGIA_SC + 
                            NEUROLOGICPARKMS_SC + PROBLEMSTANDING_SC + VISION_SC + FEMALE_SC + AGED80PLUS_SC + 
                            BEHAVIORWANDERING_SC + COGNITIVESKILLS_SC + QUADBOWEL_SC + ALZDEMTOILET_SC  
                          as risk_group
                    FROM 
                (
                select coalesce(a.record_id, b.record_id, c.record_id) as record_id
                -- From Table 6.6 in Mercer Documentation        
                 , CASE ADLBATHING WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 0 WHEN 5 THEN 0 WHEN 6 THEN 2 WHEN 8 THEN 2 ELSE  NULL END AS ADLBATHING_SC
                 , CASE ADLBED WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 5 WHEN 5 THEN 5 WHEN 6 THEN 9 WHEN 8 THEN 0 ELSE  NULL END AS ADLBED_SC
                 , CASE case when ADLDRESSLOWER in(1,2,3) and ADLDRESSUPPER in(1,2,3,4,5) then 1
                           when ADLDRESSLOWER in(4,5) and ADLDRESSUPPER in(1,2,3) then 2
                           when ADLDRESSLOWER in(4,5) and ADLDRESSUPPER in(4,5) then 3
                           when ADLDRESSUPPER in(6,8) or (ADLDRESSLOWER in(6,8) and ADLDRESSUPPER in(0,1,2,3,4,5)) then 4
                           else 0
                        end WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 5 WHEN 3 THEN 9 WHEN 4 THEN 11 WHEN 5 THEN 0 WHEN 6 THEN 0 WHEN 8 THEN 0 ELSE  NULL END AS ADLDRESSCOMB_SC
                 , CASE ADLTOILETTRANSFER WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 6 WHEN 5 THEN 6 WHEN 6 THEN 6 WHEN 8 THEN 6 ELSE  NULL END AS ADLTOILETTRANSFER_SC
                 , CASE ADLWALKING WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN 1 ELSE  NULL END AS ADLWALKING_SC
                 , CASE S.value WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 2 WHEN 3 THEN 3 WHEN 4 THEN 4 WHEN 5 THEN 5 WHEN 6 THEN 6 WHEN 8 THEN NULL ELSE  NULL END AS ADLHIERARCHYSCALE_SC
                 , CASE BLADDERCONTINENCE WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN 3 WHEN 6 THEN NULL WHEN 8 THEN 3 ELSE  NULL END AS BLADDERCONTINENCE_SC
                 , CASE BOWELCONTINENCE WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN 3 WHEN 6 THEN NULL WHEN 8 THEN 0 ELSE  NULL END AS BOWELCONTINENCE_SC
                 , CASE CARDIACFAILURE WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 1 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS CARDIACFAILURE_SC
                 , CASE FOOTPROBLEMS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 2 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS FOOTPROBLEMS_SC
                 , CASE IADLCAPACITYMEALS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 4 WHEN 5 THEN 4 WHEN 6 THEN 4 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYMEALS_SC
                 , CASE IADLCAPACITYMEDS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYMEDS_SC
                 , CASE IADLCAPACITYPHONE WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 2 WHEN 5 THEN 2 WHEN 6 THEN 2 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYPHONE_SC
                 , CASE IADLCAPACITYSTAIRS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYSTAIRS_SC
                 , CASE IADLCAPACITYTRANSPORT WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYTRANSPORT_SC
                 , CASE LOCOMOTIONINDOORS WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 3 WHEN 3 THEN 5 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS LOCOMOTIONINDOORS_SC
                 , CASE case when greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)>=1 then greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)
                             when (greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)<1 
                                    or NEUROLOGICALALZHEIMERS is null 
                                    or NEUROLOGICALDEMENTIA is null) then 0 
                        end WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN 3 WHEN 3 THEN 3 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICALALZDEM_SC
                 , CASE case when NEUROLOGICALQUADRAPLEGIA>=1 then 3
                             when NEUROLOGICALPARAPLEGIA>=1 then 2
                             when NEUROLOGICALHEMIPLEGIA>=1 then 1
                             when (greatest(NEUROLOGICALHEMIPLEGIA, NEUROLOGICALPARAPLEGIA, NEUROLOGICALQUADRAPLEGIA)=0 
                                    or NEUROLOGICALHEMIPLEGIA is null or NEUROLOGICALPARAPLEGIA is null
                                    or NEUROLOGICALQUADRAPLEGIA is null) then 0 
                        end WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 3 WHEN 3 THEN 26 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICALPLEGIA_SC
                 , CASE case when greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)>=1 then greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)
                             when (greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)<1 or NEUROLOGICALPARKINSONS is null 
                                        or NEUROLOGICALMS is null) then 0 
                        end WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN 3 WHEN 3 THEN 3 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICPARKMS_SC
                 , CASE PROBLEMSTANDING WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS PROBLEMSTANDING_SC
                 , CASE VISION WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS VISION_SC
                 , CASE case when c.gender='1' then 0 when c.gender='2' then 1 else null end WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS FEMALE_SC
                 , CASE case when trunc(months_between(a.assessmentdate, c.dateofbirth)/12)>=80 then 1 else 0 end WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS AGED80PLUS_SC
                 , CASE BEHAVIORWANDERING WHEN 0 THEN 0 WHEN 1 THEN 4 WHEN 2 THEN 4 WHEN 3 THEN 4 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS BEHAVIORWANDERING_SC
                 , CASE COGNITIVESKILLS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 2 WHEN 5 THEN 2 WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS COGNITIVESKILLS_SC
                 , CASE case when BOWELCONTINENCE in(1,3,4,5) and NEUROLOGICALQUADRAPLEGIA in (1,2,3) then 1
                        else 0
                      end WHEN 0 THEN 0 WHEN 1 THEN 9 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS QUADBOWEL_SC
                 , CASE case when (NEUROLOGICALALZHEIMERS in(1,2,3) or NEUROLOGICALDEMENTIA in(1,2,3)) and ADLTOILETTRANSFER in (1,2,3) then 1 
                           else 0
                       end WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS ALZDEMTOILET_SC
                from dw_owner.UAS_COMMUNITYHEALTH a 
                full join dw_owner.UAS_CHASUPPLEMENT b on(a.record_id=b.record_id)
                full join dw_owner.UAS_PAT_ASSESSMENTS c on (a.record_id=c.record_id)
                left join dw_owner.uas_scale s on(s.record_id=a.record_id and name='ADL Hierarchy Scale')
                where coalesce(a.record_id, b.record_id, c.record_id) is not null
                        ) a
                    ) b            
            )            
            union all        
            (
            select
            2016 mercer_doc_year  
            , b.record_id
            , b.risk_group
            , c.cac_value as risk_score
            from
            (
                select a.RECORD_ID
                    , ADLBED_SC + ADLDRESSUPPER_SC + ADLTOILETUSE_SC + ADLWALKING_SC + ADLHIERARCHYSCALE_SC +
                        BLADDERCONTINENCE_SC + BOWELCONTINENCE_SC + CARDIACFAILURE_SC + FOOTPROBLEMS_SC +
                        IADLCAPACITYMEALS_SC + IADLCAPACITYMEDS_SC + IADLCAPACITYPHONE_SC + IADLCAPACITYSTAIRS_SC +
                        LOCOMOTIONINDOORS_SC + MEMORYRECALLPROCEDURAL_SC + NEUROLOGICALALZDEM_SC + NEUROLOGICALPLEGIA_SC +
                        NEUROLOGICPARKMS_SC + NEUROLOGICALSTROKE_SC + PROBLEMSTANDING_SC + VISION_SC + DISEASEADL_SC +
                        FEMALE_SC + AGED80PLUS_SC  as risk_group
                FROM
                    (
                        select coalesce(a.record_id, b.record_id, c.record_id) as record_id
                        -- From Table 6.6 in Mercer Documentation
                        , CASE ADLBED WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 5 WHEN 5 THEN 5 WHEN 6 THEN 7 WHEN 8 THEN 0 ELSE  NULL END AS ADLBED_SC
                        , CASE ADLDRESSUPPER WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 6 WHEN 5 THEN 6 WHEN 6 THEN 9 WHEN 8 THEN 9 ELSE  NULL END AS ADLDRESSUPPER_SC
                        , CASE ADLTOILETUSE WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 8 WHEN 5 THEN 8 WHEN 6 THEN 9 WHEN 8 THEN 9 ELSE  NULL END AS ADLTOILETUSE_SC
                        , CASE ADLWALKING WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN 3 WHEN 5 THEN 3 WHEN 6 THEN 3 WHEN 8 THEN 3 ELSE  NULL END AS ADLWALKING_SC
                        , CASE S.VALUE WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 2 WHEN 3 THEN 3 WHEN 4 THEN 4 WHEN 5 THEN 5 WHEN 6 THEN 6 WHEN 8 THEN NULL ELSE  NULL END AS ADLHIERARCHYSCALE_SC
                        , CASE BLADDERCONTINENCE WHEN 0 THEN 0 WHEN 1 THEN 4 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN 3 WHEN 6 THEN NULL WHEN 8 THEN 3 ELSE  NULL END AS BLADDERCONTINENCE_SC
                        , CASE BOWELCONTINENCE WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN 3 WHEN 6 THEN NULL WHEN 8 THEN 0 ELSE  NULL END AS BOWELCONTINENCE_SC
                        , CASE CARDIACFAILURE WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 1 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS CARDIACFAILURE_SC
                        , CASE FOOTPROBLEMS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 2 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS FOOTPROBLEMS_SC
                        , CASE IADLCAPACITYMEALS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 5 WHEN 5 THEN 5 WHEN 6 THEN 5 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYMEALS_SC
                        , CASE IADLCAPACITYMEDS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYMEDS_SC
                        , CASE IADLCAPACITYPHONE WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 6 THEN 1 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYPHONE_SC
                        , CASE IADLCAPACITYSTAIRS WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 2 WHEN 5 THEN 2 WHEN 6 THEN 2 WHEN 8 THEN NULL ELSE  NULL END AS IADLCAPACITYSTAIRS_SC
                        , CASE LOCOMOTIONINDOORS WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 5 WHEN 3 THEN 5 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS LOCOMOTIONINDOORS_SC
                        , CASE MEMORYRECALLPROCEDURAL WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE NULL END AS MEMORYRECALLPROCEDURAL_SC
                        , CASE case when greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)>=1 then greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)
                                     when (greatest(NEUROLOGICALALZHEIMERS, NEUROLOGICALDEMENTIA)<1
                                            or NEUROLOGICALALZHEIMERS is null
                                            or NEUROLOGICALDEMENTIA is null) then 0
                          end WHEN 0 THEN 0 WHEN 1 THEN 6 WHEN 2 THEN 6 WHEN 3 THEN 6 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE 0 END AS NEUROLOGICALALZDEM_SC
                        , CASE case when NEUROLOGICALQUADRAPLEGIA>=1 then 3
                                     when NEUROLOGICALPARAPLEGIA>=1 then 2
                                     when NEUROLOGICALHEMIPLEGIA>=1 then 1
                                     when (greatest(NEUROLOGICALHEMIPLEGIA, NEUROLOGICALPARAPLEGIA, NEUROLOGICALQUADRAPLEGIA)=0
                                            or NEUROLOGICALHEMIPLEGIA is null or NEUROLOGICALPARAPLEGIA is null
                                            or NEUROLOGICALQUADRAPLEGIA is null) then 0
                          end WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 5 WHEN 3 THEN 18 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICALPLEGIA_SC
                        , CASE case when greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)>=1 then greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)
                                      when (greatest(NEUROLOGICALPARKINSONS, NEUROLOGICALMS)<1 or NEUROLOGICALPARKINSONS is null
                                                or NEUROLOGICALMS is null) then 0
                          end WHEN 0 THEN 0 WHEN 1 THEN 2 WHEN 2 THEN 2 WHEN 3 THEN 2 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICPARKMS_SC
                        , CASE NEUROLOGICALSTROKE WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 1 WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS NEUROLOGICALSTROKE_SC
                        , CASE PROBLEMSTANDING WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 0 WHEN 4 THEN 1 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS PROBLEMSTANDING_SC
                        , CASE VISION WHEN 0 THEN 0 WHEN 1 THEN 0 WHEN 2 THEN 0 WHEN 3 THEN 3 WHEN 4 THEN 3 WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  0 END AS VISION_SC
                        , CASE case when ADLBED=6 and NEUROLOGICALQUADRAPLEGIA>=1 then 1 else 0 end WHEN 0 THEN 0 WHEN 1 THEN 17 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS DISEASEADL_SC
                        , CASE case when c.gender='1' then 0 when c.gender='2' then 1 else null end WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS FEMALE_SC
                        , CASE case when trunc(months_between(a.assessmentdate, c.dateofbirth)/12)>=80 then 1 else 0 end WHEN 0 THEN 0 WHEN 1 THEN 3 WHEN 2 THEN NULL WHEN 3 THEN NULL WHEN 4 THEN NULL WHEN 5 THEN NULL WHEN 6 THEN NULL WHEN 8 THEN NULL ELSE  NULL END AS AGED80PLUS_SC
                    from dw_owner.UAS_COMMUNITYHEALTH a
                    full join dw_owner.UAS_CHASUPPLEMENT b on(a.record_id=b.record_id)
                    full join dw_owner.UAS_PAT_ASSESSMENTS c on (a.record_id=c.record_id)
                    left join dw_owner.uas_scale s on(s.record_id=a.record_id and name='ADL Hierarchy Scale')
                   where coalesce(a.record_id, b.record_id, c.record_id) is not null
                    ) a
                ) b
            left join (select * from MSTRSTG.CHOICE_APP_CONFIG where cac_token = 'uas_risk_group') c
            on  b.risk_group between c.lower_bound and upper_bound
            )
        ) src
        ON (src.record_id = tgt.record_id and src.mercer_doc_year = tgt.mercer_doc_year)
        WHEN MATCHED THEN
        UPDATE
           SET
                tgt.RISK_GROUP = src.RISK_GROUP,
                tgt.RISK_SCORE = src.RISK_SCORE,
                tgt.LAST_UPDATE_DATE = sysdate
        WHEN NOT MATCHED THEN
            INSERT (RECORD_ID, RISK_GROUP, RISK_SCORE, CREATED_ON, LAST_UPDATE_DATE, mercer_doc_year)
            VALUES (src.RECORD_ID, SRC.RISK_GROUP, SRC.RISK_SCORE ,sysdate, sysdate, src.mercer_doc_year);

        xutl.OUT ('done merging');

        DBMS_STATS.gather_table_stats (ownname => 'CHOICEBI',tabname => 'uas_risk_score', cascade => TRUE, estimate_percent => dbms_stats.auto_sample_size, degree=>4);
        COMMIT;

        xutl.OUT ('ended');
        xutl.run_end;
    EXCEPTION
        WHEN ex_misc
        THEN
            xutl.out_e (-20154, tid || ' ' || msg_v);
            RAISE;
        WHEN OTHERS
        THEN
            xutl.out_e (-20156, tid || ' ' || SUBSTR (SQLERRM, 1, 500));
            ROLLBACK;
            RAISE;
    end;

    procedure p_mltc_member_paid_hrs_by_day  as
        ex_misc         EXCEPTION;
        msg_v          VARCHAR2 (255) := 'starting';
        tid            VARCHAR2 (400) := 'p_fact_member_paid_hrs_by_day';
        v_year         number;
        v_choice_year varchar2(5);
        v_jan1_dt varchar2(10);
        v_dec31_dt varchar2(10);
        v_begdt varchar2(10);
        v_enddt varchar2(10);

    begin

        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('started');

        xutl.OUT ('Deleting FACT_MEMBER_PAID_HRS_BY_DAY for MLTC data...');
        v_year := to_char(sysdate,'YYYY');

       BEGIN
          --Truncate FIDA partition will clear both Years data quickly then delete
          execute immediate 'ALTER TABLE FACT_MEMBER_PAID_HRS_BY_DAY TRUNCATE PARTITION SOURCE_MLTC';
          execute immediate 'ALTER TABLE F_PAID_HRS_BY_SOURCE TRUNCATE PARTITION SOURCE_MLTC';
          commit;

       EXCEPTION
          WHEN OTHERS
          THEN
             BEGIN
                   xutl.OUT (DBMS_UTILITY.format_error_backtrace
                || CHR (13)
                || CHR (10)
                || DBMS_UTILITY.FORMAT_CALL_STACK );
                   xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   null;
                   RAISE;
             END;
       END;
        xutl.OUT ('Delete complete for FACT_MEMBER_PAID_HRS_BY_DAY for MLTC Data ...');
        get_year_dates(v_year-2, v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt );
        p_member_paid_hrs_by_day_mltc(v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt);
        commit;

        get_year_dates(v_year-1, v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt );
        p_member_paid_hrs_by_day_mltc(v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt);
        commit;

        get_year_dates(v_year, v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt );
        p_member_paid_hrs_by_day_mltc(v_choice_year, v_jan1_dt , v_dec31_dt , v_begdt , v_enddt);
        commit;
    EXCEPTION
        WHEN ex_misc
        THEN
            xutl.out_e (-20154, tid || ' ' || msg_v);
            RAISE;
        WHEN OTHERS
        THEN
            xutl.out_e (-20156, tid || ' ' || SUBSTR (SQLERRM, 1, 500));
            ROLLBACK;
            RAISE;        
    end p_mltc_member_paid_hrs_by_day;

    procedure p_fida_member_paid_hrs_by_day  as
        ex_misc         EXCEPTION;
        msg_v          VARCHAR2 (255) := 'starting';
        tid            VARCHAR2 (400) := 'p_fida_member_paid_hrs_by_day';
        v_year number;
        v_choice_year varchar2(5);
        v_jan1_dt varchar2(10);
        v_dec31_dt varchar2(10);
        v_begdt varchar2(10);
        v_enddt varchar2(10);
    begin

        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('started');

        xutl.OUT ('deleting FACT_MEMBER_PAID_HRS_BY_DAY for FIDA data...');
        v_year := to_char(sysdate,'YYYY');

        BEGIN
         --Truncate FIDA partition will clear both Years data quickly then delete
          execute immediate 'ALTER TABLE FACT_MEMBER_PAID_HRS_BY_DAY TRUNCATE PARTITION SOURCE_FIDA';
          execute immediate 'ALTER TABLE F_PAID_HRS_BY_SOURCE TRUNCATE PARTITION SOURCE_FIDA';
          commit;
        EXCEPTION
          WHEN OTHERS
          THEN
             BEGIN
                   xutl.OUT (DBMS_UTILITY.format_error_backtrace
                || CHR (13)
                || CHR (10)
                || DBMS_UTILITY.FORMAT_CALL_STACK );
                   xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   null;
             END;
        END;

        xutl.OUT ('Delete complete for FACT_MEMBER_PAID_HRS_BY_DAY for FIDA...');

        p_member_paid_hrs_by_day_fida(v_year-2);
        commit;
        p_member_paid_hrs_by_day_fida(v_year-1);
        commit;
        p_member_paid_hrs_by_day_fida(v_year);
        commit;
    end p_fida_member_paid_hrs_by_day;
    
   function  f_get_version_info(v_arg_string_i   VARCHAR2)   RETURN VARCHAR2
   IS
   -- ***********************************************************
   -- * Function f_get_version_info                             *
   -- *                                                         *
   -- * Arguments: v_arg_string_i   type: CHAR                  *
   -- *            'V' = returns    string of version_no_g      *
   -- *            'D' = returns    string of version_date_g    *
   -- *            '*' = returns    string of version_no and    *
   -- *                             version_date_g              *
   -- * Returns:   a string in forma;t dd-mpon-yyyy             *
   -- *                                                         *
   -- ***********************************************************
   v_retval   varchar2(200);
   BEGIN
         CASE
             WHEN v_arg_string_i = 'V'            -- Return version_no
             THEN
                  v_retval :=  to_char(version_no_g);
             WHEN v_arg_string_i = 'D'            -- Return version_date
             THEN
                  v_retval :=  version_date_g;
             ELSE                                 -- Return version_no and  Date
                  v_retval := version_process_title_g || ': ' ||to_char(version_no_g) || ' ' || version_date_g;
         END CASE;

         RETURN v_retval;
   end f_get_version_info;

   procedure p_set_debug_switch(arg_switch_position_i   VARCHAR2)
IS
-- ******************************************************************
-- * PROCEDURE: p_set_debug_switch                                  *
-- *                                                                *
-- * Arguments: debug_switch_position_i   on - DEBUG MODE ON        *
-- *                                      off  DEBUG MODE OFF       *
-- *                                                                *
-- * This procedure simply sets the global variable                 *
-- * DEBUG_MODE_FLAG_g to 1 or 0 depending upon the switch position *
-- * passed.  Valid Values:   'on' or 'off'                         *
-- *                                                                *
-- ******************************************************************
BEGIN

   if upper(arg_switch_position_i) = 'ON'
   then
         DEBUG_MODE_FLAG_g := 1;
         xutl.OUT ('etl_unit_cost: Running in DEBUG Mode.');
   else
         DEBUG_MODE_FLAG_g := 0;
   end if;


end p_set_debug_switch;


    procedure p_reassessment_tracking as

        v_start number:=0;
        v_end number:=0;

        ex_misc         EXCEPTION;
        msg_v          VARCHAR2(255) := 'starting';
        tid            VARCHAR2 (400)  := 'p_reassessment_tracking';

    begin

        xutl.set_id (tid);
        xutl.run_start (tid);
        xutl.OUT ('started');

        xutl.OUT ('Truncating tables for reassessment tracking...');
        BEGIN
          FOR rec
          IN (SELECT owner, table_name
              FROM all_tables
              WHERE owner = 'CHOICEBI'
                    AND table_name IN
                             (  'TEMP_AUTHS_MBR',
                                'TEMP_ORDERED',
                                'TEMP_PARA_ORDER_DAY2',
                                'TEMP_PARA_ORDER_MBR2',
                                'TEMP_PARA_ORDER_MBR',
                                'TEMP_LEAKAGE_PARA_ORDER_MBR',
                                'F_REASSESSMENT_TRACKING',
                                'F_REASSESSMENT_ORDER_HISTORY'
                                ))
          LOOP
             BEGIN

                EXECUTE IMMEDIATE   'TRUNCATE TABLE '
                                 || rec.owner
                                 || '.'
                                 || rec.table_name
                                 ;
               DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', rec.table_name, '', 10);

             EXCEPTION
                WHEN OTHERS
                THEN
                   BEGIN
                    xutl.OUT (DBMS_UTILITY.format_error_backtrace
                                || CHR (13)
                                || CHR (10)
                                || DBMS_UTILITY.FORMAT_CALL_STACK );
                                        xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   END;
             END;
          END LOOP;

        EXCEPTION
          WHEN OTHERS
          THEN
             BEGIN
                   xutl.OUT (DBMS_UTILITY.format_error_backtrace
                || CHR (13)
                || CHR (10)
                || DBMS_UTILITY.FORMAT_CALL_STACK );
                   xutl.out_e (SQLCODE, SUBSTR (SQLERRM, 1, 100));
                   null;
             END;
        END;
        xutl.OUT ('Truncate table complete for reassessment tracking ...');


        insert into CHOICEBI.F_REASSESSMENT_TRACKING
        Select distinct * from
        (
        with patient_assessment as
        (
            select /*+ no_merge materialize */ l.VENDOR_NAME,l.CREATED_ON,l.ASSESSMENT_DUE_MONTH, l.CLIENT_PATIENT_ID, l.assessment_type, p.patient_id, p.unique_id, p.deleted_on from  cmgc.assessment_data l, cmgc.patient_details p
            where l.client_patient_id=p.unique_id
        ),
        patient_idx as
        (
            select  /*+ materialize */ patient_id, index_id, created_on, index_value
                , row_number() over (partition BY patient_id,index_id ORDER BY created_on DESC) AS created_seq
            from (  select patient_id, index_id, index_value, max(created_on) as created_on from cmgc.patient_index
                    where index_id in (30, 28)
                    group by patient_id, index_id, index_value
                 )
        )
        , attempts as
        (
            select /*+ materialize use_hash(a l p) */ a.patient_id, a.created_date
                , a.comments
                , a.care_activity_type_id
                , row_number () over (partition by a.patient_id, a.care_activity_type_id, l.created_on order by a.created_date) as seq
                , l.created_on, l.vendor_name
            from cmgc.patient_followup a
        --    join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details where DELETED_ON is null) p on (a.patient_id=p.patient_id)
        --    join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
            join patient_assessment l on (a.patient_id=l.patient_id)
            where a.care_activity_type_id in (50,57,58)
                and a.created_date>=trunc(l.created_on) /*-- Attempts made on or after reassessment list loaded into GC*/
                and a.created_date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), 6) /*-- Attempts made within 5 months of reassessment list month  */
        )
        , attempt_script as
        (
            select /*+ materialize NO_MERGE USE_HASH(A Q1 Q2 Q3) */ a.patient_id, a.staff_id, a.script_run_log_id, a.status_id, a.end_date
                , q1.created_on
                , to_number(rtrim(q1.option_value, 'Attempt thstndrd')) as Attempt_Number
                , q2.option_value as Outcome
                , q3.option_value as Comments
            from  cmgc.scpt_patient_script_run_log a
            inner join (select /*+USE_HASH(A2 Q)*/ a2.script_run_log_id, a2.created_on,  q.*
                        from cmgc.scpt_pat_script_run_log_det a2
                        left join cmgc.scpt_question_response q on (q.script_run_log_detail_id=a2.script_run_log_detail_id)
                        where a2.script_id=116 /*Attempt Script*/
                            and a2.question_id=3366 /*Attempt script - Attempt number*/) q1 on(a.script_run_log_id=q1.script_run_log_id )
            LEFT join (select /*+USE_HASH(A2 Q)*/  a2.script_run_log_id, a2.created_on, q.*
                        from cmgc.scpt_pat_script_run_log_det a2
                        left join cmgc.scpt_question_response q on (q.script_run_log_detail_id=a2.script_run_log_detail_id)
                        where a2.script_id=116 /*Attempt Script*/
                            and a2.question_id=3369 /*Attempt script -Outcome*/) q2 on(a.script_run_log_id=q2.script_run_log_id )
            LEFT join (select /*+USE_HASH(A2 Q)*/  a2.script_run_log_id, a2.created_on, q.*
                        from cmgc.scpt_pat_script_run_log_det a2
                        left join cmgc.scpt_question_response q on (q.script_run_log_detail_id=a2.script_run_log_detail_id)
                        where a2.script_id=116 /*Attempt Script*/
                            and a2.question_id=3370 /*Attempt script -Comments*/) q3 on(a.script_run_log_id=q3.script_run_log_id)
        ),
        activity as
        (
            select /*+ no_merge materialize */ a.patient_id, l.created_on, l.vendor_name
                    , b.care_activity_type_name
                    , a.created_date
                    , a.comments
                    , a.care_activity_type_id
                    , trunc(sp.CREATED_ON) as svc_created_on
                    , trunc(sp.from_Date) as svc_from_Date
                    , row_number () over (partition by a.patient_id, a.care_activity_type_id, l.created_on, sp.from_date, sp.created_on order by a.created_date) as seq
                    , row_number () over (partition by a.patient_id, l.created_on, sp.from_date, sp.created_on order by a.created_date desc) as seq2
            from cmgc.patient_followup a
            left outer join cmgc.care_activity_type b on (a.care_activity_type_id=B.CARE_ACTIVITY_TYPE_ID)
            join cmgc.cpl_member_Service_plan sp on (a.patient_id=sp.member_id)
            join cmgc.um_auth c on (sp.auth_no=c.auth_no)
            --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
            --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
            join patient_assessment l on (a.patient_id=l.patient_id)
            where a.care_activity_type_id in (49,52,53,56,62)
                    and (c.auth_type_id=29 ) /*PCS services*/
                    and l.deleted_on is null
                    and sp.unit_type_id=2 /*unit type is hours*/
                    and sp.deleted_by is null
                    and sp.deleted_on is null
                    and sp.service_status_id=3 /*approved service plans only*/
                   and sp.weeks in (26,27) /*service plan is for 26 weeks (also include 27 weeks for auth_end glitch*/
                    and (
                               (a.care_activity_type_id =56 and a.created_date between sp.created_on and sp.created_on+1) /*activity occurred on or 1 day after svcplan was created*/
                            OR (a.care_activity_type_id in (52,53) and a.created_date between sp.created_on and sp.created_on+15) /*variance approve/deny activity occurred on or up to 15 days after svcplan was created*/
                            OR (a.care_activity_type_id in (62) and a.created_date between sp.created_on and sp.created_on+15) /*CA req activity occurred on or up to 15 days after svcplan was created*/
                            OR (a.care_activity_type_id in (49) and a.created_date between sp.created_on and sp.created_on+22) /*OPS update activity occurred on or up to 22 days after svcplan was created*/
                        )
        ),
        ass_data as
            (
                select /*+  materialize ordered */ a.member_id,a.start_date, a.end_date, l.created_on, l.vendor_name, a.LOB_BEN_ID, a.mem_benf_plan_id
                from    --cmgc.assessment_data l, (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p,
                        patient_assessment l,
                        cmgc.mem_benf_plan a
                    where a.DELETED_BY is null
                        and a.DELETED_ON is null
                        and a.is_visible=1
                        and (a.member_id=l.patient_id)
                        --and l.client_patient_id=p.unique_id
                        and a.end_date>to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm')+14 /*-- plan ended after 15th of month prior to reassessment list*/
                        and a.start_date<to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm')+14
                        ),
        plan as
        (
            select /*+ leading(a) no_merge  */ a.member_id
                        , C.PLAN_DESC, c.plan_name
                        , a.start_date as plan_start_date
                        , a.end_date as plan_end_date
                        , g3.program_name
                        , g.start_date as program_start_date
                        , g.end_date as program_end_date
                        , a.created_on
                        , a.vendor_name
                        , row_number () over (partition by a.member_id, a.created_on order by a.mem_benf_plan_id desc
                                                                , a.end_date desc, g.end_date desc, g.start_date) as seq
                from
                ass_data a
                left join CMGC.LOB_BENF_PLAN b on(B.LOB_BEN_ID=A.LOB_BEN_ID)
                join cmgc.benefit_plan c on(B.BENEFIT_PLAN_ID=C.BENEFIT_PLAN_ID)
                left join cmgc.mem_benf_prog g on(a.member_id=g.member_id
                            and a.mem_benf_plan_id=g.mem_benf_plan_id
                            and g.deleted_by is null
                            and g.deleted_on is null)
                left join cmgc.benf_plan_prog g2 on(g.ben_plan_prog_id=g2.ben_plan_prog_id
                            and c.benefit_plan_id=g2.benefit_plan_id
                            and g2.deleted_by is null
                            and g2.deleted_on is null)
                left join cmgc.benefit_program g3 on(g2.benefit_program_id=g3.benefit_program_id
                            and g3.deleted_by is null
                            and g3.deleted_on is null)
                where
                    c.plan_name in('VNS03007','MD000003','MD000002', 'V6000000')
        ),
        svcpre as
        (
        select /*+ no_merge materialize */ det.created_on
                        , det.vendor_name
                        , det.member_id
                        , det.svc_from_date
                        , det.svc_to_date
                        , (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                else null end) as auth_closed_seq1
                        , (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.max_auth_closed
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                else null end) as auth_closed_seq2
                         , (case when
                                (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                               = (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.max_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                                then
                                (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                                else 0.5 end) as auth_closed
                        , row_number () over (partition by det.member_id, det.created_on, det.vendor_name, det.svc_from_date
                                        order by det.auth_closed DESC) as authseq
                        , (case when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then 1 else 0 end) as auths_summed
                        , det.lob_id
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.req_units
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_req_units
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_req_units
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.approved_units
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_approved_units
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_approved_units
                        , det.unit_type_id
                        , det.service_status_id
                        , det.service_status
                        , det.svc_created_on
                        , det.svcstaff_first_name, det.svcstaff_last_name
                        , det.auth_no
                        , det.auth_class_id
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.hours
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_hours
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_hours
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.days
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_days
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_days
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.hrs_x_days
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_hrs_x_days
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_hrs_x_days
                        , det.weeks
                        , det.pcw_app_units
                        , det.pcw_rec_units
                        , det.pcw_cur_units
                        , det.auth_id
                        , det.auth_priority_id
                        , det.auth_priority
                        , det.auth_noti_date
                        , det.auth_from_date
                        , det.auth_status_id
                        , det.auth_Status
                        , det.auth_status_reason_id
                        , det.auth_status_reason_name
                        , det.auth_created_on
                        , det.decision_status
                       , det.decision_auth_noti_date
                        , det.decision_created_on
                        , det.decision_updated_on
                from
                    (
                        select l.created_on, l.vendor_name
                                        , row_number () over (partition by a.member_id, l.created_on
                                                order by (case when c.auth_status_id in (2,6) then 1 else 0 end) DESC
                                                        , trunc(a.created_on) DESC) as seq
                                        , a.member_id, trunc(a.from_Date) as svc_from_date, trunc(to_Date) as svc_to_date
                         , (case when c.auth_status_id in (2,6) then 1 else 0 end) as auth_closed
                                        , a.lob_id
                                        , (a.req_units)
                                        , (a.approved_units)
                                        , a.unit_type_id
                                        , a.service_status_id, b.decision_status as service_status
                                        , trunc(a.created_on) as svc_created_on
                                        , staff.first_name as svcstaff_first_name, staff.last_name as svcstaff_last_name
                                        , a.auth_no, a.auth_class_id
                                        , (a.hours)
                                        , (a.days)
                                        , (a.hours * a.days) as hrs_x_days
                                        , a.weeks
                                        , a.pcw_app_units
                                        , a.pcw_rec_units, a.pcw_cur_units
                                        , c.auth_id
                                        , c.auth_priority_id, authprty.auth_priority
                                        , trunc(c.auth_noti_date) as auth_noti_date
                                        , trunc(c.auth_from_Date) as auth_from_Date
                                        , c.auth_status_id, authsts.auth_status
                                        , c.auth_status_reason_id, authrsn.auth_status_reason_name
                                        , trunc(c.created_on) as auth_created_on /*tends to be very close to svc_created_on*/
                                        , d.decision_no
                                        , d.decision_Status as decision_status_id, dsnsts.decision_status
                                        , trunc(d.auth_noti_date) as decision_auth_noti_date /*same as decision_Created_on*/
                                        , trunc(d.created_on) as decision_created_on
                                        , trunc(d.updated_on) as decision_updated_on
                                from cmgc.cpl_member_service_plan a
                                left join CMGC.UM_MA_DECISION_STATUS b on (a.service_Status_id=B.DECISION_STATUS_ID)
                                join cmgc.um_auth c on (a.auth_no=c.auth_no)
                                left join cmgc.um_ma_auth_tat_priority authprty on (c.auth_priority_id=authprty.auth_priority_id)
                                left join cmgc.um_ma_auth_status authsts on (c.auth_status_id=authsts.AUTH_STATUS_ID)
                                left join cmgc.um_ma_auth_status_reason authrsn on (C.AUTH_STATUS_REASON_ID = authrsn.auth_status_reason_id)
                                join cmgc.um_auth_code code on (a.auth_no=code.auth_no
                                                                  and a.unit_type_id=code.unit_type_id
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  and trunc(a.from_Date)=trunc(code.auth_code_from_date)
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  )
                                left join cmgc.um_decision d on (code.auth_code_id=d.auth_code_id
                                                                    and c.auth_no=d.auth_no
                                                                    and d.deleted_by is null and d.deleted_on is null
                                                                    )
                                left join cmgc.um_ma_decision_status dsnsts on (d.decision_status=DSNSTS.DECISION_STATUS_ID)
                                left join cmgc.care_staff_details staff on (A.CREATED_BY=staff.member_id)
                                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.member_id=p.patient_id)
                                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id
                                join patient_assessment l on (l.patient_id=a.member_id
                                                                    /*svc_plan_from_date is equal to first day of month in the month after assessment due month*/
                                                                    and trunc(a.from_Date) = add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2)                                         )
                                where (c.auth_type_id=29 ) /*PCS services*/
                                    and a.unit_type_id=2 /*unit type is hours*/
                                    and a.deleted_by is null
                                    and a.deleted_on is null
                                    and c.deleted_by is null
                                    and c.deleted_on is null
                                    and l.deleted_on is null
                                    and code.deleted_on is null
                                    and code.deleted_by is null
                                    and d.deleted_on is null
                                    and d.deleted_by is null
                                    and CODE.AUTH_CODE_TYPE_ID <> 2 /*don't include auth codes specific to diagnosis codes, as they don't contain any auth units*/
                                    and a.service_status_id = 3 /*approved service plans only*/
                                    and c.auth_status_id in (2,6, 1,7) /*auth status is closed or closed and adjusted*/
                                    and a.weeks in (26,27) /*service plan is for 26 weeks (also include 27 weeks for auth_end glitch*/
                                    and d.decision_status = 3 /*only include auths where decision status of auth line is approved*/
                )  det
                left join
                (
                        select l.created_on, l.vendor_name
                                        , a.member_id, trunc(a.from_Date) as svc_from_date
                                        , min(a.hours * a.days) as min_hrs_x_days
                                        , max (a.hours * a.days) as max_hrs_x_days
                                        , sum(a.req_units) as sum_req_units
                                        , sum(a.approved_units) as sum_approved_units
                                        , sum(a.hours) as sum_hours
                                        , sum(a.days) as sum_days
                                        , sum(a.hours * a.days) as sum_hrs_x_days
                                        , min( (case when c.auth_status_id in (2,6) then 1 else 0 end)) as min_auth_closed
                                        , max( (case when c.auth_status_id in (2,6) then 1 else 0 end)) as max_auth_closed
                                from cmgc.cpl_member_service_plan a
                                left join CMGC.UM_MA_DECISION_STATUS b on (a.service_Status_id=B.DECISION_STATUS_ID)
                                join cmgc.um_auth c on (a.auth_no=c.auth_no)
                                left join cmgc.um_ma_auth_tat_priority authprty on (c.auth_priority_id=authprty.auth_priority_id)
                                left join cmgc.um_ma_auth_status authsts on (c.auth_status_id=authsts.AUTH_STATUS_ID)
                                left join cmgc.um_ma_auth_status_reason authrsn on (C.AUTH_STATUS_REASON_ID = authrsn.auth_status_reason_id)
                                join cmgc.um_auth_code code on (a.auth_no=code.auth_no
                                                                  and a.unit_type_id=code.unit_type_id
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  and trunc(a.from_Date)=trunc(code.auth_code_from_date)
                                                                  and a.approved_units=code.auth_code_app_units
                                                                )
                                left outer join cmgc.um_decision d on (code.auth_code_id=d.auth_code_id
                                                                    and c.auth_no=d.auth_no
                                                                    and d.deleted_by is null and d.deleted_on is null
                                                                    )
                                left outer join cmgc.um_ma_decision_status dsnsts on (d.decision_status=DSNSTS.DECISION_STATUS_ID)
                                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.member_id=p.patient_id)
                                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id
                                join patient_assessment l on (l.patient_id=a.member_id
                                                                    /*svc_plan_from_date is equal to first day of month in the month after assessment due month*/
                                                                    and trunc(a.from_Date) = add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2)                                         )
                                where (c.auth_type_id=29 ) /*PCS services*/
                                    and a.unit_type_id=2 /*unit type is hours*/
                                    and a.deleted_by is null
                                    and a.deleted_on is null
                                    and c.deleted_by is null
                                    and c.deleted_on is null
                                    and l.deleted_on is null
                                    and code.deleted_on is null
                                    and code.deleted_by is null
                                    and d.deleted_on is null
                                    and d.deleted_by is null
                                    and CODE.AUTH_CODE_TYPE_ID <> 2 /*don't include auth codes specific to diagnosis codes, as they don't contain any auth units*/
                                    and a.service_status_id = 3 /*approved service plans only*/
                                    and c.auth_status_id in (2,6, 1,7) /*auth status is closed or closed and adjusted*/
                                    and a.weeks in (26,27) /*service plan is for 26 weeks (also include 27 weeks for auth_end glitch*/
                                    and d.decision_status = 3 /*only include auths where decision status of auth line is approved*/
                            group by l.created_on
                                        , l.vendor_name
                                        , a.member_id
                                        , trunc(a.from_Date)
                ) agg on (det.created_on=agg.created_on
                            and det.vendor_name=agg.vendor_name
                            and det.member_id=agg.member_id
                            and det.svc_from_date=agg.svc_from_date
                            )
                where ((agg.min_hrs_x_days=agg.max_hrs_x_days and det.seq=1)
                        or
                      (agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1))
            ),
        svc as
            (select /*+ no_merge materialize */ det.created_on
                        , det.vendor_name
                        , det.member_id
                        , det.svc_from_date
                        , det.svc_to_date
                        , (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                else null end) as auth_closed_seq1
                        , (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.max_auth_closed
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                else null end) as auth_closed_seq2
                         , (case when
                                (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                               = (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.max_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                                then
                                (case when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq=1 then det.auth_closed
                                    when agg.min_hrs_x_days = agg.max_hrs_x_days and det.seq <> 1 then null
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.min_auth_closed
                                    when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                                    else null end)
                                else 0.5 end) as auth_closed
                        , row_number () over (partition by det.member_id, det.created_on, det.vendor_name, det.svc_from_date
                                        order by det.auth_closed DESC) as authseq
                        , (case when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then 1 else 0 end) as auths_summed
                        , det.lob_id
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.req_units
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_req_units
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_req_units
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.approved_units
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_approved_units
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_approved_units
                        , det.unit_type_id
                        , det.service_status_id
                        , det.service_status
                        , det.svc_created_on
                        , det.svcstaff_first_name, det.svcstaff_last_name
                        , det.auth_no
                        , det.auth_class_id
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.hours
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_hours
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_hours
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.days
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_days
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_days
                        , (case when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq=1 then det.hrs_x_days
                                when agg.min_hrs_x_days =  agg.max_hrs_x_days and det.seq <>1 then null
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1 then agg.sum_hrs_x_days
                                when agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq <> 1 then null
                            else null end) as sum_hrs_x_days
                        , det.weeks
                       , det.pcw_app_units
                        , det.pcw_rec_units
                        , det.pcw_cur_units
                        , det.auth_id
                        , det.auth_priority_id
                        , det.auth_priority
                        , det.auth_noti_date
                        , det.auth_from_date
                        , det.auth_status_id
                        , det.auth_Status
                        , det.auth_status_reason_id
                        , det.auth_status_reason_name
                        , det.auth_created_on
                        , det.decision_status
                        , det.decision_auth_noti_date
                        , det.decision_created_on
                        , det.decision_updated_on
                from
                    (
                        select l.created_on, l.vendor_name
                                        , row_number () over (partition by a.member_id, l.created_on
                                                order by (case when c.auth_status_id in (2,6) then 1 else 0 end) DESC
                                                        , trunc(a.created_on) DESC) as seq
                                        , a.member_id, trunc(a.from_Date) as svc_from_date, trunc(to_Date) as svc_to_date
                         , (case when c.auth_status_id in (2,6) then 1 else 0 end) as auth_closed
                                        , a.lob_id
                                        , (a.req_units)
                                        , (a.approved_units)
                                        , a.unit_type_id
                                        , a.service_status_id, b.decision_status as service_status
                                        , trunc(a.created_on) as svc_created_on
                                        , staff.first_name as svcstaff_first_name, staff.last_name as svcstaff_last_name
                                        , a.auth_no
                                        , a.auth_class_id
                                        , (a.hours) , (a.days)
                                        , (a.hours * a.days) as hrs_x_days
                                        , a.weeks
                                        , a.pcw_app_units
                                        , a.pcw_rec_units, a.pcw_cur_units
                                        , c.auth_id
                                        , c.auth_priority_id, authprty.auth_priority
                                        , trunc(c.auth_noti_date) as auth_noti_date
                                        , trunc(c.auth_from_Date) as auth_from_Date
                                        , c.auth_status_id, authsts.auth_status
                                        , c.auth_status_reason_id, authrsn.auth_status_reason_name
                                        , trunc(c.created_on) as auth_created_on /*tends to be very close to svc_created_on*/
                                        , d.decision_no
                                        , d.decision_Status as decision_status_id, dsnsts.decision_status
                                        , trunc(d.auth_noti_date) as decision_auth_noti_date /*same as decision_Created_on*/
                                        , trunc(d.created_on) as decision_created_on
                                        , trunc(d.updated_on) as decision_updated_on
                                from cmgc.cpl_member_service_plan a
                                left join CMGC.UM_MA_DECISION_STATUS b on (a.service_Status_id=B.DECISION_STATUS_ID)
                                join cmgc.um_auth c on (a.auth_no=c.auth_no)
                                left join cmgc.um_ma_auth_tat_priority authprty on (c.auth_priority_id=authprty.auth_priority_id)
                                left join cmgc.um_ma_auth_status authsts on (c.auth_status_id=authsts.AUTH_STATUS_ID)
                                left join cmgc.um_ma_auth_status_reason authrsn on (C.AUTH_STATUS_REASON_ID = authrsn.auth_status_reason_id)
                                join cmgc.um_auth_code code on (a.auth_no=code.auth_no
                                                                  and a.unit_type_id=code.unit_type_id
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  and trunc(a.from_Date)=trunc(code.auth_code_from_date)
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  )
                                left outer join cmgc.um_decision d on (code.auth_code_id=d.auth_code_id
                                                                    and c.auth_no=d.auth_no
                                                                    and d.deleted_by is null and d.deleted_on is null
                                                                    )
                                left outer join cmgc.um_ma_decision_status dsnsts on (d.decision_status=DSNSTS.DECISION_STATUS_ID)
                                left join cmgc.care_staff_details staff on (A.CREATED_BY=staff.member_id)
                                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.member_id=p.patient_id)
                                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id
                                join patient_assessment l on (l.patient_id=a.member_id
                                                                /*svc_plan_from_date is later than first day of month in the month after assessment due month*/
                                                                    and trunc(a.from_Date) > add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2)   )
                                where (c.auth_type_id=29 ) /*PCS services*/
                                    and a.unit_type_id=2 /*unit type is hours*/
                                    and a.deleted_by is null
                                    and a.deleted_on is null
                                    and c.deleted_by is null
                                    and c.deleted_on is null
                                    and l.deleted_on is null
                                    and code.deleted_on is null
                                    and code.deleted_by is null
                                    and d.deleted_on is null
                                    and d.deleted_by is null
                                    and CODE.AUTH_CODE_TYPE_ID <> 2 /*don't include auth codes specific to diagnosis codes, as they don't contain any auth units*/
                                    and a.service_status_id = 3 /*approved service plans only*/
                                    and c.auth_status_id in (2,6, 1,7) /*auth status is closed or closed and adjusted*/
                                    and a.weeks in (26,27) /*service plan is for 26 weeks (also include 27 weeks for auth_end glitch*/
                                    and d.decision_status = 3 /*only include auths where decision status of auth line is approved*/
                            order by a.member_id, l.created_on
                            , (case when c.auth_status_id in (2,6) then 1 else 0 end) DESC
                            , trunc(a.created_on) DESC
                )
                det
                left join
                (
                        select l.created_on, l.vendor_name
                                        , a.member_id, trunc(a.from_Date) as svc_from_date
                                        , min(a.hours * a.days) as min_hrs_x_days
                                        , max (a.hours * a.days) as max_hrs_x_days
                                        , sum(a.req_units) as sum_req_units
                                        , sum(a.approved_units) as sum_approved_units
                                        , sum(a.hours) as sum_hours
                                        , sum(a.days) as sum_days
                                        , sum(a.hours * a.days) as sum_hrs_x_days
                                        , min( (case when c.auth_status_id in (2,6) then 1 else 0 end)) as min_auth_closed
                                        , max( (case when c.auth_status_id in (2,6) then 1 else 0 end)) as max_auth_closed
                                from cmgc.cpl_member_service_plan a
                                left join CMGC.UM_MA_DECISION_STATUS b on (a.service_Status_id=B.DECISION_STATUS_ID)
                                join cmgc.um_auth c on (a.auth_no=c.auth_no)
                                left join cmgc.um_ma_auth_tat_priority authprty on (c.auth_priority_id=authprty.auth_priority_id)
                                left join cmgc.um_ma_auth_status authsts on (c.auth_status_id=authsts.AUTH_STATUS_ID)
                                left join cmgc.um_ma_auth_status_reason authrsn on (C.AUTH_STATUS_REASON_ID = authrsn.auth_status_reason_id)
                                join cmgc.um_auth_code code on (a.auth_no=code.auth_no
                                                                  and a.unit_type_id=code.unit_type_id
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  and trunc(a.from_Date)=trunc(code.auth_code_from_date)
                                                                  and a.approved_units=code.auth_code_app_units
                                                                  )
                                left outer join cmgc.um_decision d on (code.auth_code_id=d.auth_code_id
                                                                    and c.auth_no=d.auth_no
                                                                    and d.deleted_by is null and d.deleted_on is null
                                                                    )
                                left outer join cmgc.um_ma_decision_status dsnsts on (d.decision_status=DSNSTS.DECISION_STATUS_ID)
                                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.member_id=p.patient_id)
                                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id
                                join patient_assessment l on (l.patient_id=a.member_id
                                                                 /*svc_plan_from_date is later than first day of month in the month after assessment due month*/
                                                                    and trunc(a.from_Date) > add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2)   )
                                where (c.auth_type_id=29 ) /*PCS services*/
                                    and a.unit_type_id=2 /*unit type is hours*/
                                    and a.deleted_by is null
                                    and a.deleted_on is null
                                    and c.deleted_by is null
                                    and c.deleted_on is null
                                    and l.deleted_on is null
                                    and code.deleted_on is null
                                    and code.deleted_by is null
                                    and d.deleted_on is null
                                    and d.deleted_by is null
                                    and CODE.AUTH_CODE_TYPE_ID <> 2 /*don't include auth codes specific to diagnosis codes, as they don't contain any auth units*/
                                    and a.service_status_id = 3 /*approved service plans only*/
                                    and c.auth_status_id in (2,6, 1,7) /*auth status is closed or closed and adjusted*/
                                    and a.weeks in (26,27) /*service plan is for 26 weeks (also include 27 weeks for auth_end glitch*/
                                    and d.decision_status = 3 /*only include auths where decision status of auth line is approved*/
                            group by l.created_on
                                        , l.vendor_name
                                        , a.member_id
                                        , trunc(a.from_Date)
                )
                agg on (det.created_on=agg.created_on
                            and det.vendor_name=agg.vendor_name
                            and det.member_id=agg.member_id
                            and det.svc_from_date=agg.svc_from_date
                           )
                where ((agg.min_hrs_x_days=agg.max_hrs_x_days and det.seq=1)
                         or
                         (agg.min_hrs_x_days <> agg.max_hrs_x_days and det.seq=1))
        )
        select
                      l.patient_id,
                      l.client_patient_id as Subscriber_id
                    , (case when substr(l.client_patient_id, 1,2)='V6' then 'FIDA' else 'MLTC' end) as LINE_OF_BUSINESS
                    , (select DL_LOB_ID from mstrstg.d_line_of_business where upper(lob_name) = (case when substr(l.client_patient_id, 1,2)='V6' then 'FIDA' else 'MLTC' end) ) lob_id
                    , d1.index_value as medicaid_num1
                    , d2.index_value as medicaid_num2
                    , d3.index_value as mrntext
                    , (case when LENGTH(TRANSLATE(trim(d3.index_value), 'x0123456789', 'x')) IS  NULL
                        then to_number(trim(d3.index_value)) end) as mrn
                    , carestaff.first_name as current_staff_first_name
                    , carestaff.last_name as current_staff_last_name
                    , upper(l.vendor_name) as Vendor_Name
                    , trunc(l.created_on) as assigned_to_vendor_on
                    , trunc(l.assessment_due_month) as Reassessment_list_month
                    , plan.plan_desc, plan.plan_name, trunc(plan.plan_start_date) as Plan_Start_Date, trunc(plan.plan_End_date) as Plan_End_Date
                    , plan.program_name
                    , trunc(plan.program_start_date) as program_start_date
                    , trunc(plan.program_end_date) as program_end_date
                   /*New Version of attempts (6/23/2016)- picking up activities and scripts, pick the earliest*/
                    , case when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))='01jan2199' then null
                        else least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))
                      end as Attempt1_Date
                    , case when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199') then a_sc1.Outcome
                      end as Attempt1_Outcome
                    , case when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199') then a_sc1.comments
                            when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a1.created_date),'01jan2199') then a1.comments
                      end as Attempt1_Comments
                    , case when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))='01jan2199' then null
                        else least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))
                      end as Attempt2_Date
                    , case when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199') then a_sc2.Outcome
                      end as Attempt2_Outcome
                    , case when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199') then a_sc2.comments
                            when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a2.created_date),'01jan2199') then a2.comments
                      end as Attempt2_Comments
                    , case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))='01jan2199' then null
                        else least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))
                      end as Attempt3_Date
                    , case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199') then a_sc3.Outcome
                      end as Attempt3_Outcome
                    , case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199') then a_sc3.comments
                            when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a3.created_date),'01jan2199') then a3.comments
                      end as Attempt3_Comments
                    , u.assessmentdate, u.onursedate, upper(u.onursename) as ONURSENAME
                    , u2.assessmentdate as Previous_assessmentdate, u2.onursedate as Previous_onursedate
                    , upper(u2.onursename) as Previous_ONURSENAME, upper(u2.onurseorgname) as Previous_ONURSEORGNAME
                    , psp.value as PSP_Scpt_Activity_Status
                    , psp.status_name as PSP_Scpt_Form_Activity_Status
                    , trunc(psp.start_date) as PSP_Start_Date
                    , trunc(psp.end_date) as PSP_End_Date
                    , psp.approved_units as PSP_Approved_Units
                    , psp.approved_units_num as PSP_approved_units_num
                    , (case when psp.approved_units is not null and psp.approved_units_num is null then 1 else 0 end) as psp_approved_units_invalid
                    , psp.PSP_ATSP_Tool_Total_Per_Week
                    , trunc(atsp.atsp_created_on) as ATSP_Date
                    , (case when
                        ((u.assessmentdate is null)
                            and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                        or
                        (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                            and u2.assessmentdate<trunc(l.created_on))
                        or
                        (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                         end) in('Successful -- Deferred visit scheduled due to member request'
                                ,'Successful -- Competed by other RN'
                                ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                ,'Unsuccessful - Out of Area'
                                ,'Unsuccessful - Expired'
                                ,'Unsuccessful - Disenrolled'
                                ,'Unsuccessful - Vacation'
                                ,'Unsuccessful - Refused'
                                ,'Unsuccessful - Hospitalized')
                      then 1 else 0 end) as Unavailable_ind
                    /*all docs*/
                    , (case when
                      (case when
                        ((u.assessmentdate is null)
                            and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                        or
                        (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                            and u2.assessmentdate<trunc(l.created_on))
                        or
                        (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                         end) in('Successful -- Deferred visit scheduled due to member request'
                                ,'Successful -- Competed by other RN'
                                ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                ,'Unsuccessful - Out of Area'
                                ,'Unsuccessful - Expired'
                                ,'Unsuccessful - Disenrolled'
                                ,'Unsuccessful - Vacation'
                                ,'Unsuccessful - Refused'
                                ,'Unsuccessful - Hospitalized')
                      then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    then 1 else 0 end) as all_docs_completed
                    /*all docs and not in SNF*/
                    , (case when
                      (case when
                        ((u.assessmentdate is null)
                            and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                        or
                        (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                            and u2.assessmentdate<trunc(l.created_on))
                        or
                        (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                         end) in('Successful -- Deferred visit scheduled due to member request'
                                ,'Successful -- Competed by other RN'
                                ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                ,'Unsuccessful - Out of Area'
                                ,'Unsuccessful - Expired'
                                ,'Unsuccessful - Disenrolled'
                                ,'Unsuccessful - Vacation'
                                ,'Unsuccessful - Refused'
                                ,'Unsuccessful - Hospitalized')
                      then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and (psp.approved_units is not null and (psp.approved_units_num is null or psp.approved_units_num <> 0 ))
                    then 1 else 0 end) as all_docs_noSNF
                    /*unavailable for creation of service plan*/
                    , (case when ((svc.svc_created_on is null and svcpre.svc_created_on is null)
                            and (Plan.Plan_End_Date between u.assessmentdate and add_months(to_date(to_char(psp.end_date, 'yyyymm'), 'yyyymm'),2)
                                or plan.Plan_End_date is null
                                  )
                          )
                        then 1 else 0 end) as Unavailable_ind_svc
                    /*if service plan has been created (among available to be assessed by Premier), was it generated for late UAS*/
                    , (case when svc.svc_created_on is null and svcpre.svc_created_on is not null
                        and (case when
                                ((u.assessmentdate is null)
                                    and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                                or
                                (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                    and u2.assessmentdate<trunc(l.created_on))
                                or
                                (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                        when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                        when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                                 end) in('Successful -- Deferred visit scheduled due to member request'
                                        ,'Successful -- Competed by other RN'
                                        ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                        ,'Unsuccessful - Out of Area'
                                        ,'Unsuccessful - Expired'
                                        ,'Unsuccessful - Disenrolled'
                                        ,'Unsuccessful - Vacation'
                                        ,'Unsuccessful - Refused'
                                        ,'Unsuccessful - Hospitalized')
                              then 1 else 0 end)=0
                    then 0
                    when svc.svc_created_on is not null
                        and (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    then 1
                    when (svc.svc_created_on is null and svcpre.svc_created_on is null )
                        or (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=1
                    then null
                    end) as svcplan_lateUAS
                    /*info from service plans: prioritize svcplans created for late UASs to reflect any consideration of PRMR recommendations. If svcplans created for
                    late UASs are not available, take the svcplans created in month following reassessment due month.
                    (When there is late UAS/PSP, old services needed to be re-authorized)*/
                   , decode(svc.svc_created_on, null, svcpre.svc_created_on, svc.svc_created_on) as svc_created_on
                    , decode(svc.svc_created_on, null, svcpre.svcstaff_first_name, svc.svcstaff_first_name) as svcstaff_first_name
                    , decode(svc.svc_created_on, null, svcpre.svcstaff_last_name, svc.svcstaff_last_name) as svcstaff_last_name
                    , decode(svc.svc_created_on, null, svcpre.svc_from_date, svc.svc_from_date) as svc_from_date
                    , decode(svc.svc_created_on, null, svcpre.svc_to_date, svc.svc_to_date) as svc_to_date
                    , decode(svc.svc_created_on, null, svcpre.auth_closed_seq1, svc.auth_closed_seq1) as auth_closed_seq1
                    , decode(svc.svc_created_on, null, svcpre.auth_closed_seq2, svc.auth_closed_seq2) as auth_closed_seq2
                    , decode(svc.svc_created_on, null, svcpre.auth_closed, svc.auth_closed) as auth_closed
                    , decode(svc.svc_created_on, null, svcpre.auths_summed, svc.auths_summed) as auths_summed
                    , decode(svc.svc_created_on, null, svcpre.lob_id, svc.lob_id) as svc_lob_id
                    , decode(svc.svc_created_on, null, svcpre.sum_req_units, svc.sum_req_units) as sum_req_units
                    , decode(svc.svc_created_on, null, svcpre.sum_approved_units, svc.sum_approved_units) as sum_approved_units
                    , decode(svc.svc_created_on, null, svcpre.unit_type_id, svc.unit_type_id) as svc_unit_type_id
                    , decode(svc.svc_created_on, null, svcpre.service_status_id, svc.service_status_id) as service_status_id
                    , decode(svc.svc_created_on, null, svcpre.service_status, svc.service_status) as service_status
                    , decode(svc.svc_created_on, null, svcpre.auth_no, svc.auth_no) as auth_no
                    , decode(svc.svc_created_on, null, svcpre.auth_class_id, svc.auth_class_id) as auth_class_id
                    , decode(svc.svc_created_on, null, svcpre.sum_hours, svc.sum_hours) as sum_hours
                    , decode(svc.svc_created_on, null, svcpre.sum_days, svc.sum_days) as sum_days
                    , decode(svc.svc_created_on, null, svcpre.weeks, svc.weeks) as weeks
                    , decode(svc.svc_created_on, null, svcpre.sum_hrs_x_days, svc.sum_hrs_x_days) as sum_hrs_x_days
                    , decode(svc.svc_created_on, null, svcpre.pcw_app_units, svc.pcw_app_units) as pcw_app_units
                    , decode(svc.svc_created_on, null, svcpre.pcw_rec_units, svc.pcw_rec_units) as pcw_rec_units
                    , decode(svc.svc_created_on, null, svcpre.pcw_cur_units, svc.pcw_cur_units) as pcw_cur_units
                    , decode(svc.svc_created_on, null, svcpre.auth_id, svc.auth_id) as auth_id
                    , decode(svc.svc_created_on, null, svcpre.auth_priority_id, svc.auth_priority_id) as auth_priority_id
                    , decode(svc.svc_created_on, null, svcpre.auth_priority, svc.auth_priority) as auth_priority
                    , decode(svc.svc_created_on, null, svcpre.auth_noti_date, svc.auth_noti_date) as auth_noti_date
                    , decode(svc.svc_created_on, null, svcpre.auth_from_date, svc.auth_from_date) as auth_from_date
                    , decode(svc.svc_created_on, null, svcpre.auth_status_id, svc.auth_status_id) as auth_status_id
                    , decode(svc.svc_created_on, null, svcpre.auth_status, svc.auth_status) as auth_status
                    , decode(svc.svc_created_on, null, svcpre.auth_status_reason_id, svc.auth_status_reason_id) as auth_status_reason_id
                    , decode(svc.svc_created_on, null, svcpre.auth_status_reason_name, svc.auth_status_reason_name) as auth_status_reason_name
                    , decode(svc.svc_created_on, null, svcpre.auth_created_on, svc.auth_created_on) as auth_created_on
                    , decode(svc.svc_created_on, null, svcpre.decision_status, svc.decision_status) as decision_status
                    , decode(svc.svc_created_on, null, svcpre.decision_auth_noti_date, svc.decision_auth_noti_date) as decision_auth_noti_date
                    , decode(svc.svc_created_on, null, svcpre.decision_created_on, svc.decision_created_on) as decision_created_on
                    , decode(svc.svc_created_on, null, svcpre.decision_updated_on, svc.decision_updated_on) as decision_updated_on
                    /*any svcplan/auth created among those available for Premier to assess (regardless of whether Premier completed or not)*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null)
                    then 1 else 0 end) as svcplan_created
                    /*any svcplan/auth created for those Premier completed*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and (psp.approved_units is not null and (psp.approved_units_num is null or psp.approved_units_num <> 0))
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null)
                    then 1 else 0 end) as svcplan_created_prmr_complete
                    /*any svcplan/auth created for those Premier completed, and PSP hours is usable for leakage dashboard reporting*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and psp.approved_units_num <> 0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and psp.approved_units_num is not null
                    then 1 else 0 end) as svcplan_created_psphrs_ok
                    /*any svcplan/auth closed among those available for Premier to assess (regardless of whether Premier completed or not)*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null)
                    and (case when svc.svc_created_on is null and svcpre.auth_closed =1 then 1
                              when svc.svc_created_on is not null and svc.auth_closed =1 then 1
                              else 0 end) =1
                    then 1 else 0 end) as svcplan_closed
                    /*any svcplan/auth closed for those Premier completed*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and (psp.approved_units is not null and (psp.approved_units_num is null or psp.approved_units_num <> 0))
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and (case when svc.svc_created_on is null and svcpre.auth_closed=1 then 1
                              when svc.svc_created_on is not null and svc.auth_closed=1 then 1
                              else 0 end) =1
                    then 1 else 0 end) as svcplan_closed_prmr_complete
                    /*any svcplan/auth closed for those Premier completed, and PSP hours is usable for leakage dashboard reporting*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and psp.approved_units_num <> 0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and (case when svc.svc_created_on is null and svcpre.auth_closed=1 then 1
                              when svc.svc_created_on is not null and svc.auth_closed=1 then 1
                              else 0 end) =1
                    and psp.approved_units_num is not null
                    then 1 else 0 end) as svcplan_closed_psphrs_ok
                    , trunc(var.created_date) as hha_variance_date
                    , var2.care_activity_type_name as hha_variance_status
                    , trunc(var2.created_date) as hha_variance_status_date
                    , trunc(ca.created_date) as contractadmin_req_date
                    , trunc(ops.created_date) as ops_updated_date
                    , ops.comments as ops_comments
                    /*HHA variance activity generated*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and psp.approved_units_num <> 0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and var.created_date is not null
                    then 1 else 0 end) as hha_variance_activity
                    /*Contract Admin request activity generated*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and psp.approved_units_num <> 0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and ca.created_date is not null
                    then 1 else 0 end) as contractadmin_req_activity
                    /*OPS updated activity generated*/
                    , (case when
                        (case when
                            ((u.assessmentdate is null)
                                and (Plan.Plan_End_Date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),2) or plan.Plan_End_date is null))
                            or
                            (u2.assessmentdate>=add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), -4)
                                and u2.assessmentdate<trunc(l.created_on))
                            or
                            (case when least(nvl(trunc(a3.created_date),'01jan2199'), nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc3.Attempt_Entered_Date),'01jan2299') then a_sc3.Outcome
                                    when least(nvl(trunc(a2.created_date),'01jan2199'), nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc2.Attempt_Entered_Date),'01jan2299') then a_sc2.Outcome
                                    when least(nvl(trunc(a1.created_date),'01jan2199'), nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2199'))=nvl(trunc(a_sc1.Attempt_Entered_Date),'01jan2299') then a_sc1.Outcome
                             end) in('Successful -- Deferred visit scheduled due to member request'
                                    ,'Successful -- Competed by other RN'
                                    ,'Unsuccessful - Non-working/ incorrect number (Reminder: Send Activity to CM)'
                                    ,'Unsuccessful - Out of Area'
                                    ,'Unsuccessful - Expired'
                                    ,'Unsuccessful - Disenrolled'
                                    ,'Unsuccessful - Vacation'
                                    ,'Unsuccessful - Refused'
                                    ,'Unsuccessful - Hospitalized')
                          then 1 else 0 end)=0
                    and u.assessmentdate is not null
                    and psp.status_name='Approved'
                    and atsp.atsp_created_on is not null
                    and psp.approved_units_num <> 0
                    and (svcpre.svc_created_on is not null or svc.svc_created_on is not null )
                    and ops.created_date is not null
                    then 1 else 0 end) as ops_updated_activity,
                    NULL JOB_RUN_ID,
                    SYSDATE
        from
            --(select * from cmgc.assessment_data where assessment_type='Reassessment') l
        --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on(l.client_patient_id=p.unique_id)
        (select * from patient_assessment where assessment_type='Reassessment') l
        left join patient_idx d1 on (l.patient_id=d1.patient_id and d1.created_seq=1 and d1.index_id=30)   /*index=30=Medicaid_num*/
        left join patient_idx d2 on (l.patient_id=d2.patient_id and d2.created_seq=2 and d2.index_id=30)    /*index=30=Medicaid_num*/
        left join patient_idx d3 on (l.patient_id=d3.patient_id and d3.created_seq=1 and d3.index_id=28)   /*index=28=MRN*/
        /*Name of current Care Manager/staff*/
        left join (select distinct cs.patient_id, cs.member_id, cs.is_active, staff.first_name, staff.last_name
                        , row_number() over (partition by cs.patient_id order by cs.is_active DESC) as active_seq
                        from cmgc.member_carestaff  cs
                        join cmgc.care_staff_details staff on (cs.member_id=staff.member_id)
                        where cs.is_primary=1) carestaff on (l.patient_id=carestaff.patient_id and active_seq=1)
        /*--Attempt1 - Activities*/
        left join attempts a1 on(a1.care_activity_type_id=50 and a1.patient_id=l.patient_id and a1.vendor_name=l.vendor_name and a1.created_on=l.created_on and a1.seq=1)
        /*--Attempt2 - Activities*/
        left join attempts a2 on(a2.care_activity_type_id=57 and a2.patient_id=l.patient_id and a2.vendor_name=l.vendor_name and a2.created_on=l.created_on and a2.seq=1)
        /*--Attempt3 - Activities*/
        left join attempts a3 on(a3.care_activity_type_id=58 and a3.patient_id=l.patient_id and a3.vendor_name=l.vendor_name and a3.created_on=l.created_on and a3.seq=1)
        /*Attempt1 Scripts*/
        left join (
                select a.patient_id, a.created_on as Attempt_Entered_Date
                    , a.outcome, a.comments
                    , row_number () over (partition by a.patient_id, l.created_on order by a.created_on) as seq
                    , l.created_on, l.vendor_name
                from attempt_script a
                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
                  join patient_assessment l on l.patient_id=a.patient_id
                where a.attempt_number=1 /*First attempt Script*/
                    and a.status_id=1 /*Completed Only*/
                    and l.DELETED_ON is null
                    and trunc(a.created_on)>=trunc(l.created_on) /*-- Attempts made on or after day of reassessment list loaded into GC*/
                    and trunc(a.created_on)<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), 6) /*-- Attempts made within 5 months of reassessment list month  */
                   ) a_sc1 on(a_sc1.patient_id=l.patient_id and a_sc1.vendor_name=l.vendor_name and a_sc1.created_on=l.created_on and a_sc1.seq=1)
        /*Attempt2 Scripts*/
        left join (
                select a.patient_id, a.created_on as Attempt_Entered_Date
                    , a.outcome, a.comments
                    , row_number () over (partition by a.patient_id, l.created_on order by a.created_on) as seq
                    , l.created_on, l.vendor_name
                from attempt_script a
                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
                join patient_assessment l on (l.patient_id=a.patient_id)
                where a.attempt_number=2 /*First attempt Script*/
                    and a.status_id=1 /*Completed Only*/
                    and l.DELETED_ON is null
                    and trunc(a.created_on)>=trunc(l.created_on) /*-- Attempts made on or after day of reassessment list loaded into GC*/
                    and trunc(a.created_on)<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), 6) /*-- Attempts made within 5 months of reassessment list month  */
                   ) a_sc2 on(a_sc2.patient_id=l.patient_id and a_sc2.vendor_name=l.vendor_name and a_sc2.created_on=l.created_on and a_sc2.seq=1)
        /*Attempt3 Scripts*/
        left join (
                select a.patient_id, a.created_on as Attempt_Entered_Date
                    , a.outcome, a.comments
                    , row_number () over (partition by a.patient_id, l.created_on order by a.created_on) as seq
                    , l.created_on, l.vendor_name
                from attempt_script a
                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
                join patient_assessment l on (l.patient_id=a.patient_id)
                where a.attempt_number=3 /*First attempt Script*/
                    and a.status_id=1 /*Completed Only*/
                    and l.DELETED_ON is null
                    and trunc(a.created_on)>=trunc(l.created_on) /*-- Attempts made on or after day of reassessment list loaded into GC*/
                    and trunc(a.created_on)<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'), 6) /*-- Attempts made within 5 months of reassessment list month  */
                   ) a_sc3 on(a_sc3.patient_id=l.patient_id and a_sc3.vendor_name=l.vendor_name and a_sc3.created_on=l.created_on and a_sc3.seq=1)
        /*--UAS*/
        left join (select l.patient_id, u.assessmentdate, u.onursedate, u.onursename
                    , row_number () over (partition by l.patient_id, l.created_on order by u.assessmentdate, u.onursedate) as seq
                    , l.created_on, l.vendor_name
                 from
                    --cmgc.assessment_data l
                 --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (l.client_patient_id=p.unique_id)
                    patient_assessment l
                 left join cmgc.patient_index d1 on (l.patient_id=d1.patient_id and d1.index_id=30)   /*Pick up all Medicaid numbers*/
                 join dw_owner.uas_pat_assessments u on(u.medicaidnumber1=d1.index_value)
                 where upper(onurseorgname) like '%PREMIER%'
                    and l.DELETED_ON is null
                    and u.assessmentdate>=trunc(l.created_on) /*-- on or after reassessment list loaded into GC*/
                    and u.assessmentdate<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),6) /*-- Assessments made within 5 months of reassessment list month*/
                   ) u on(u.patient_id=l.patient_id and u.vendor_name=l.vendor_name and u.created_on=l.created_on and u.seq=1)
        /*--Previous UAS*/
        left join (select l.patient_id, u.assessmentdate, u.onursedate, u.onursename, u.onurseorgname
                    , row_number () over (partition by l.patient_id, l.created_on order by u.assessmentdate desc, u.onursedate) as seq
                    , l.created_on, l.vendor_name
                  from
                        --cmgc.assessment_data l
                  --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (l.client_patient_id=p.unique_id)
                  patient_assessment l
                  left join cmgc.patient_index d1 on (l.patient_id=d1.patient_id and d1.index_id=30)   /*Pick up all Medicaid numbers*/
                  join dw_owner.uas_pat_assessments u on(u.medicaidnumber1=d1.index_value)
                  where (upper(onurseorgname) like '%VNS%'
                            or upper(onurseorgname) like '%PREMIER%'
                            or upper(onurseorgname) like '%EDDY%'
                            or upper(onurseorgname) like '%UNLIMITED%'
                            or upper(onurseorgname) like '%HCR%'
                            or upper(onurseorgname) like '%VNA%'
                            or upper(onurseorgname) like '%VISITING NURSE ASSOCIATION%'
                            or upper(onurseorgname) like '%VISITING NURSING ASSOCIATION%'
                            or upper(onurseorgname) like '%VISITING NURSE SERVICE OF NY HOME CARE%')
                    and u.assessmentdate<trunc(l.created_on) /*-- before reassessment list loaded into GC*/
                   ) u2 on(u2.patient_id=l.patient_id and u2.vendor_name=l.vendor_name and u2.created_on=l.created_on and u2.seq=1)
        /*--ATSP*/
        left join(select a.patient_id, a.created_on as atsp_created_on, row_number () over (partition by a.patient_id, l.created_on order by a.created_on desc) as seq
                        , l.created_on, l.vendor_name
        /*--                , a.description*/
                    from cmgc.patient_document_details a
                    --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
                    --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
                    join patient_assessment l  on (a.patient_id=l.patient_id)
                    where a.DOCUMENT_TYPE_ID=23 /*--ATSP*/
                        and l.DELETED_ON is null
                        and a.DELETED_BY is null
                        and a.DELETED_ON is null
                        and a.created_on>=trunc(l.created_on) /*-- on or after reassessment list loaded into GC*/
                        and a.created_on<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),6) /*--  within 5 months of reassessment list month    */
                  ) atsp on(atsp.patient_id=l.patient_id and atsp.vendor_name=l.vendor_name and atsp.created_on=l.created_on and atsp.seq=1)
        /*--PSP*/
        left join (select a.patient_id, a_desc.value, a.start_date, a.end_date
                    , row_number () over (partition by a.patient_id, l.created_on order by a.start_date desc) as seq
                    , a4_desc.status_name, a4.approved_units
                    , (case when LENGTH(TRANSLATE(trim(a4.approved_units), 'x0123456789', 'x')) IS  NULL
                            then to_number(trim(a4.approved_units)) end) as approved_units_num
                    , a2.PSP_ATSP_Tool_Total_Per_Week
                    , l.created_on, l.vendor_name
                from cmgc.scpt_patient_script_run_log a
                left join cmgc.scpt_script_run_status a_desc on(a.status_id=a_desc.status_id)
                join (select /*+ USE_HASH(A2 Q1) */ a2.script_run_log_id, max(to_number(case when a2.question_id=3365 then decode(TRANSLATE(trim(q1.option_value), 'x0123456789', 'x'),null,q1.option_value,null) else null end)) as PSP_ATSP_Tool_Total_Per_Week
                        from cmgc.scpt_pat_script_run_log_det a2
                        join cmgc.scpt_question_response q1 on (q1.script_run_log_detail_id=a2.script_run_log_detail_id)
                        where a2.script_id=107
                        group by a2.script_run_log_id) a2 on(a.script_run_log_id=a2.script_run_log_id)
                left join (select s.*, row_number () over (partition by s.patient_id, s.script_run_log_id order by s.created_on desc) as seq
                           from cmgc.scpt_form_patient_info s) a3 on(a.patient_id=a3.patient_id and a.script_run_log_id=a3.script_run_log_id and a3.seq=1)
                left join cmgc.scpt_form_pat_review_status a4 on(a3.sfpi_id=a4.sfpi_id)
                left join CMGC.CM_MA_SERVICPLAN_SCRPTFORM_STS a4_desc on(a4.status_id=a4_desc.serviceplan_scriptfrom_id)
                --join (SELECT patient_id, unique_id, deleted_on FROM cmgc.patient_details) p on (a.patient_id=p.patient_id)
                --join cmgc.assessment_data l on (l.client_patient_id=p.unique_id)
                join patient_assessment l  on (a.patient_id=l.patient_id)
                where a.DELETED_BY is null
                    and a.DELETED_ON is null
                    and l.DELETED_ON is null
                    and a.start_date>=trunc(l.created_on) /*--on or after reassessment list loaded into GC*/
                    and a.start_date<add_months(to_date(to_char(l.created_on, 'yyyymm'), 'yyyymm'),6) /*-- within 5 months of reassessment list month */
                  ) psp on(psp.patient_id=l.patient_id and psp.vendor_name=l.vendor_name and psp.created_on=l.created_on and psp.seq=1)
        /*--Version 2 of Plan Info (2016/04/20)*/
        left join plan on (plan.member_id=l.patient_id and plan.vendor_name=l.vendor_name and plan.created_on=l.created_on and plan.seq=1)
        /*service plans created in month following reassessment due month regardless of late UAS*/
        left join svcpre on (svcpre.member_id=l.patient_id and svcpre.vendor_name=l.vendor_name and svcpre.created_on=l.created_on and svcpre.authseq=1)
        /*service plans/auths created for auth period following assessment date of late UASs*/
        left join svc on (svc.member_id=l.patient_id and svc.vendor_name=l.vendor_name and svc.created_on=l.created_on and svc.authseq=1 and svc.svc_from_date = add_months(to_date(to_char(u.assessmentdate, 'yyyymm'), 'yyyymm'),1) ) /*svc_from_date corresponds to first day of month following UAS assessment date*/
        /* Activity: HHA/PCS - Variance and Decision*/
        left join activity var on (var.care_activity_type_id = 56 and var.patient_id=l.patient_id and var.vendor_name=l.vendor_name and var.created_on=l.created_on
                            and var.svc_created_on=decode(svc.svc_created_on, null, svcpre.svc_created_on, svc.svc_created_on)
                            and var.svc_from_date=decode(svc.svc_created_on, null, svcpre.svc_from_Date, svc.svc_from_date)
                            and var.seq=1)
        /*Activity: HHA/PCS - Variance and Decision approved or denied*/
        left join activity var2 on (var2.care_activity_type_id in (52,53) and var2.patient_id=l.patient_id and var2.vendor_name=l.vendor_name and var2.created_on=l.created_on
                            and var2.svc_created_on=decode(svc.svc_created_on, null, svcpre.svc_created_on, svc.svc_created_on)
                            and var2.svc_from_date=decode(svc.svc_created_on, null, svcpre.svc_from_Date, svc.svc_from_date)
                            and var2.seq2=1)
        /* Activity: Contract Admin Action Required*/
        left join activity ca on (ca.care_activity_type_id in (62) and ca.patient_id=l.patient_id and ca.vendor_name=l.vendor_name and ca.created_on=l.created_on
                            and ca.svc_created_on=decode(svc.svc_created_on, null, svcpre.svc_created_on, svc.svc_created_on)
                            and ca.svc_from_date=decode(svc.svc_created_on, null, svcpre.svc_from_Date, svc.svc_from_date)
                            and ca.seq=1)
        /*Activity: OPS Updated*/
        left join activity ops on (ops.care_activity_type_id in (49) and ops.patient_id=l.patient_id and ops.vendor_name=l.vendor_name and ops.created_on=l.created_on
                            and ops.svc_created_on=decode(svc.svc_created_on, null, svcpre.svc_created_on, svc.svc_created_on)
                            and ops.svc_from_date=decode(svc.svc_created_on, null, svcpre.svc_from_Date, svc.svc_from_date)
                            and ops.seq=1)
        where l.deleted_on is null
    );


        xutl.out('F_REASSESSMENT_TRACKING -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_REASSESSMENT_TRACKING', '', 10);

        insert into TEMP_PARA_ORDER_MBR
        SELECT para_ord_mrn,
               para_case_nbr,
               para_case_seq,
               para_ord_prog,
               para_ord_choice,
               para_ord_fida,
               para_ord_mltc,
               para_ord_status,
               para_ord_service,
               (para_ord_entry_dte) AS para_ord_entry_dte,
               (para_req_start_dte) AS para_req_start_dte,
               (order_end) AS order_end,
               (sched_wk_beg_date) AS sched_wk_beg_date,
               (sched_wk_end_date) AS sched_wk_end_date,
               seq_no_desc,
               sumhours_lv_wk,
               sched_saturday_lv,
               sched_sunday_lv,
               sched_monday_lv,
               sched_tuesday_lv,
               sched_wednesday_lv,
               sched_thursday_lv,
               sched_friday_lv
               ,null member_id
        FROM   (SELECT z.*
                FROM   (SELECT   DISTINCT
                                 a.para_ord_mrn,
                                 a.para_case_nbr,
                                 a.para_case_seq,
                                 a.para_ord_prog,
                                 (CASE
                                      WHEN SUBSTR(a.para_ord_prog, 1, 1) = 'V' THEN 1
                                      ELSE 0
                                  END)
                                     AS para_ord_choice,
                                 (CASE WHEN a.para_ord_prog = 'VCF' THEN 1 ELSE 0 END)
                                     AS para_ord_fida,
                                 (CASE
                                      WHEN     a.para_ord_prog LIKE 'V%'
                                           AND a.para_ord_prog <> 'VCF' THEN
                                          1
                                      ELSE
                                          0
                                  END)
                                     AS para_ord_mltc,
                                 a.para_ord_status,
                                 a.para_ord_service,
                                 TO_DATE(
                                     DECODE(a.para_ord_entry_dte,
                                            0, NULL,
                                            a.para_ord_entry_dte),
                                     'yyyymmdd')
                                     AS para_ord_entry_dte,
                                 TO_DATE(
                                     DECODE(a.para_req_start_dte,
                                            0, NULL,
                                            a.para_req_Start_dte),
                                     'yyyymmdd')
                                     AS para_req_start_dte,
                                 TO_DATE(
                                     DECODE(
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds),
                                         0, NULL,
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds)),
                                     'yyyymmdd')
                                     AS order_end,
                                 TO_DATE(
                                     DECODE(b.sched_wk_end_date,
                                            0, NULL,
                                            b.sched_wk_end_date),
                                     'yyyymmdd')
                                     AS sched_wk_end_date,
                                 (CASE
                                      WHEN     TO_DATE(
                                                   DECODE(b.sched_wk_end_date,
                                                          0, NULL,
                                                          b.sched_wk_end_date),
                                                   'yyyymmdd')
                                                   IS NOT NULL
                                           AND   TO_DATE(
                                                     DECODE(b.sched_wk_end_date,
                                                            0, NULL,
                                                            b.sched_wk_end_date),
                                                     'yyyymmdd')
                                               - 6 >
                                                   TO_DATE(
                                                       DECODE(a.para_req_start_dte,
                                                              0, NULL,
                                                              a.para_req_Start_dte),
                                                       'yyyymmdd') THEN
                                            TO_DATE(
                                                DECODE(b.sched_wk_end_date,
                                                       0, NULL,
                                                       b.sched_wk_end_date),
                                                'yyyymmdd')
                                          - 6
                                      WHEN     TO_DATE(
                                                   DECODE(b.sched_wk_end_date,
                                                          0, NULL,
                                                          b.sched_wk_end_date),
                                                   'yyyymmdd')
                                                   IS NOT NULL
                                           AND   TO_DATE(
                                                     DECODE(b.sched_wk_end_date,
                                                            0, NULL,
                                                            b.sched_wk_end_date),
                                                     'yyyymmdd')
                                               - 6 <=
                                                   TO_DATE(
                                                       DECODE(a.para_req_start_dte,
                                                              0, NULL,
                                                              a.para_req_Start_dte),
                                                       'yyyymmdd') THEN
                                          TO_DATE(
                                              DECODE(a.para_req_start_dte,
                                                     0, NULL,
                                                     a.para_req_Start_dte),
                                              'yyyymmdd')
                                      WHEN TO_DATE(
                                               DECODE(b.sched_wk_end_date,
                                                      0, NULL,
                                                      b.sched_wk_end_date),
                                               'yyyymmdd')
                                               IS NULL THEN
                                          TO_DATE(
                                              DECODE(a.para_req_start_dte,
                                                     0, NULL,
                                                     a.para_req_Start_dte),
                                              'yyyymmdd')
                                  END)
                                     AS sched_wk_beg_date,
                                 ROW_NUMBER()
                                 OVER (
                                     PARTITION BY a.para_ord_mrn,
                                                  a.para_case_nbr,
                                                  a.para_case_seq
                                     ORDER BY b.sched_wk_end_date DESC)
                                     AS seq_no_desc,
                                 ROW_NUMBER()
                                 OVER (
                                     PARTITION BY a.para_ord_mrn,
                                                  a.para_case_nbr,
                                                  a.para_ord_service,
                                                  (CASE
                                                       WHEN     TO_DATE(
                                                                    DECODE(
                                                                        b.sched_wk_end_date,
                                                                        0, NULL,
                                                                        b.sched_wk_end_date),
                                                                    'yyyymmdd')
                                                                    IS NOT NULL
                                                            AND   TO_DATE(
                                                                      DECODE(
                                                                          b.sched_wk_end_date,
                                                                          0, NULL,
                                                                          b.sched_wk_end_date),
                                                                      'yyyymmdd')
                                                                - 6 >
                                                                    TO_DATE(
                                                                        DECODE(
                                                                            a.para_req_start_dte,
                                                                            0, NULL,
                                                                            a.para_req_Start_dte),
                                                                        'yyyymmdd') THEN
                                                             TO_DATE(
                                                                 DECODE(
                                                                     b.sched_wk_end_date,
                                                                     0, NULL,
                                                                     b.sched_wk_end_date),
                                                                 'yyyymmdd')
                                                           - 6
                                                       WHEN     TO_DATE(
                                                                    DECODE(
                                                                        b.sched_wk_end_date,
                                                                        0, NULL,
                                                                        b.sched_wk_end_date),
                                                                    'yyyymmdd')
                                                                    IS NOT NULL
                                                            AND   TO_DATE(
                                                                      DECODE(
                                                                          b.sched_wk_end_date,
                                                                          0, NULL,
                                                                          b.sched_wk_end_date),
                                                                      'yyyymmdd')
                                                                - 6 <=
                                                                    TO_DATE(
                                                                        DECODE(
                                                                            a.para_req_start_dte,
                                                                            0, NULL,
                                                                            a.para_req_Start_dte),
                                                                        'yyyymmdd') THEN
                                                           TO_DATE(
                                                               DECODE(
                                                                   a.para_req_start_dte,
                                                                   0, NULL,
                                                                   a.para_req_Start_dte),
                                                               'yyyymmdd')
                                                       WHEN TO_DATE(
                                                                DECODE(
                                                                    b.sched_wk_end_date,
                                                                    0, NULL,
                                                                    b.sched_wk_end_date),
                                                                'yyyymmdd')
                                                                IS NULL THEN
                                                           TO_DATE(
                                                               DECODE(
                                                                   a.para_req_start_dte,
                                                                   0, NULL,
                                                                   a.para_req_Start_dte),
                                                               'yyyymmdd')
                                                   END)
                                     ORDER BY
                                         a.para_ord_entry_dte DESC,
                                         b.sched_wk_end_date DESC)
                                     AS sort_seq/*Recalculate hours for live-in days*/
                                                /*Live in should be 13 hours per day, but is represented as 24 hours per day in OPS*/
                                 ,
                                 (  (CASE
                                         WHEN b.sched_lv_in_flag2 = 'Y' THEN 13
                                         ELSE b.sched_saturday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag3 = 'Y' THEN 13
                                         ELSE b.sched_sunday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag4 = 'Y' THEN 13
                                         ELSE b.sched_monday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag5 = 'Y' THEN 13
                                         ELSE b.sched_tuesday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag6 = 'Y' THEN 13
                                         ELSE b.sched_wednesday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag7 = 'Y' THEN 13
                                         ELSE b.sched_thursday
                                     END)
                                  + (CASE
                                         WHEN b.sched_lv_in_flag8 = 'Y' THEN 13
                                         ELSE b.sched_friday
                                     END))
                                     AS sumhours_lv_wk,
                                 (CASE
                                      WHEN sched_lv_in_flag2 = 'Y' THEN 13
                                      ELSE sched_saturday
                                  END)
                                     AS sched_saturday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag3 = 'Y' THEN 13
                                      ELSE sched_sunday
                                  END)
                                     AS sched_sunday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag4 = 'Y' THEN 13
                                      ELSE sched_monday
                                  END)
                                     AS sched_monday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag5 = 'Y' THEN 13
                                      ELSE sched_tuesday
                                  END)
                                     AS sched_tuesday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag6 = 'Y' THEN 13
                                      ELSE sched_wednesday
                                  END)
                                     AS sched_wednesday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag7 = 'Y' THEN 13
                                      ELSE sched_thursday
                                  END)
                                     AS sched_thursday_lv,
                                 (CASE
                                      WHEN sched_lv_in_flag8 = 'Y' THEN 13
                                      ELSE sched_friday
                                  END)
                                     AS sched_friday_lv
                        FROM     dw_owner.tpopsd_para_order a
                                 JOIN dw_owner.tpopsd_para_sche b
                                     ON (    a.para_case_nbr = b.sched_case_nbr
                                         AND a.para_case_seq = b.sched_case_seq)
                        WHERE        (   a.para_ord_status IN ('AA', 'AC', 'DP', 'DD')
                                      OR (    a.para_ord_status = 'CC'
                                          AND a.para_ord_service = 6))
                                 AND a.para_ord_prog <> 'VCF'  /*do not include FIDA*/
                                 AND SUBSTR(a.para_ord_prog, 1, 1) <> 'K' /*exclude Partners - private pay, plus typos in dates*/
                                 AND DECODE(
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds),
                                         0, 99991231,
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds)) >=
                                         a.para_req_start_dte /*order end dt >= order start dt*/
                                 /*limit orders to applicable to dates*/
                                 AND DECODE(
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds),
                                         0, 99991231,
                                         GREATEST(a.para_canc_disc_dte,
                                                  a.para_ci_dte_ord_ds)) >= 20150101 /*order end dt >= 1/1/2015 to minimize dataset*/
                                 AND a.para_req_start_dte > 991231 /*don't include these old orders from before year 2000*/
                                 /*exclude schedules where sched_wk_beg_dt occurs after the order end dt*/
                                 AND (CASE
                                          WHEN (    TO_DATE(
                                                        DECODE(
                                                            GREATEST(
                                                                a.para_canc_disc_dte,
                                                                a.para_ci_dte_ord_ds),
                                                            0, NULL,
                                                            GREATEST(
                                                                a.para_canc_disc_dte,
                                                                a.para_ci_dte_ord_ds)),
                                                        'yyyymmdd')
                                                        IS NOT NULL
                                                AND TO_DATE(
                                                        DECODE(b.sched_wk_end_date,
                                                               0, NULL,
                                                               b.sched_wk_end_date),
                                                        'yyyymmdd')
                                                        IS NOT NULL
                                                AND TO_DATE(
                                                        DECODE(
                                                            GREATEST(
                                                                a.para_canc_disc_dte,
                                                                a.para_ci_dte_ord_ds),
                                                            0, NULL,
                                                            GREATEST(
                                                                a.para_canc_disc_dte,
                                                                a.para_ci_dte_ord_ds)),
                                                        'yyyymmdd') <
                                                          TO_DATE(
                                                              DECODE(
                                                                  b.sched_wk_end_date,
                                                                  0, NULL,
                                                                  b.sched_wk_end_date),
                                                              'yyyymmdd')
                                                        - 6) THEN
                                              1
                                          ELSE
                                              0
                                      END) = 0
                        ORDER BY a.para_ord_mrn,
                                 a.para_case_nbr,
                                 a.para_case_seq,
                                 seq_no_desc DESC) z
                WHERE  z.sort_seq = 1 /*if sched_wk_beg_date is the same for an order because one schedule has sched_wk_end_date populated and one schedule does not,
                                       take the schedule with the sched_wk_end_date populated because it is a more recent update*/
         );


        xutl.out('TEMP_PARA_ORDER_MBR -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_MBR', '', 10);

        insert into TEMP_PARA_ORDER_MBR2
        select para_ord_mrn
           , para_case_nbr
           , para_case_seq
           , para_ord_prog
           , para_ord_choice
           , para_ord_fida
           , para_ord_mltc
           , para_ord_status
           , para_ord_service
           , (para_ord_entry_dte) as para_ord_entry_dte
           , (para_req_Start_dte) as para_req_Start_dte
           , (order_end) as order_end
           , (sched_wk_beg_date) as sched_wk_beg_date
           , (sched_wk_end_date) as sched_wk_end_date
           , seq_no_desc
           , sumhours_lv_wk
           , sched_saturday_lv
           , sched_sunday_lv
           , sched_monday_lv
           , sched_tuesday_lv
           , sched_wednesday_lv
           , sched_thursday_lv
           , sched_friday_lv
           , (lagdate) as lagdate
           , (offset_date) as offset_date
           , (sched_beg) as sched_beg
           , (sched_end) as sched_end
        from
        (
            SELECT z.para_ord_mrn
                   , z.para_case_nbr
                   , z.para_case_seq
                   , z.para_ord_prog
                   , z.para_ord_choice
                   , z.para_ord_fida
                   , z.para_ord_mltc
                   , z.para_ord_status
                   , z.para_ord_service
                   , z.para_ord_entry_dte
                   , z.para_req_Start_dte
                   , z.order_end
                   , z.sched_wk_beg_date
                   , z.sched_wk_end_date
                   , z.seq_no_desc
                   , z.sumhours_lv_wk
                   , z.sched_beg
                   , z.sched_end
            , z.lagdate, z.offset_date
                   , z.sched_saturday_lv
                   , z.sched_sunday_lv
                   , z.sched_monday_lv
                   , z.sched_tuesday_lv
                   , z.sched_wednesday_lv
                   , z.sched_thursday_lv
                   , z.sched_friday_lv
              FROM
                (SELECT x.*
                        , x.sched_wk_beg_date AS sched_beg
                        ,(CASE WHEN (x.offset_date <> x.sched_wk_beg_date
                                      AND (x.offset_date <> to_Date('31-DEC-9999') OR NVL (x.seq_no_desc, 0) <> 1)
                                      AND (x.offset_date <> x.order_end OR NVL (x.seq_no_desc, 0) <> 1))
                         THEN x.offset_date - 1
                         ELSE x.offset_date
                         END) AS sched_end
                 FROM
                    ( SELECT a.*
                              ,(CASE WHEN b.fst_para_ord_entry_dt IS NOT NULL
                                THEN
                                     (CASE WHEN a.order_end IS NOT NULL THEN a.order_end
                                           WHEN a.order_end IS NULL THEN to_date('31-DEC-9999')
                                      END)
                                ELSE a.lagdate
                                END) AS offset_date
                       FROM
                            (SELECT c.*
                                    ,LAG (sched_wk_beg_date, 1) OVER (ORDER BY para_ord_mrn, para_case_nbr, para_ord_service, para_ord_entry_dte, sched_wk_beg_date DESC, sched_wk_end_date) AS lagdate
                            FROM TEMP_PARA_ORDER_MBR c) a
                               LEFT JOIN
                           (SELECT para_ord_mrn, para_case_nbr, para_ord_service, sched_wk_beg_date
                                        , sched_wk_end_date
                                        , (case when seq_no_desc=1 then para_ord_entry_dte else null end) AS fst_para_ord_entry_dt
                                        , seq_no_desc
                             FROM TEMP_PARA_ORDER_MBR) b
                             ON (b.para_ord_mrn = a.para_ord_mrn
                                 AND b.para_case_nbr = a.para_case_nbr
                                 AND b.para_ord_service=a.para_ord_service
                                 AND b.fst_para_ord_entry_dt = a.para_ord_entry_dte
                                 AND b.sched_wk_beg_date = a.sched_wk_beg_date
                                 AND NVL (b.sched_wk_end_date, '01-JAN-0001') = NVL (a.sched_wk_end_date, '01-JAN-0001'))
                      ) x
                 ) z
            ORDER BY z.para_ord_mrn, z.para_case_nbr, z.para_ord_service, z.sched_beg
            );

        xutl.out('TEMP_PARA_ORDER_MBR2 -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_PARA_ORDER_MBR2', '', 10);

        insert into TEMP_LEAKAGE_PARA_ORDER_MBR
        select a.*
                , b.*
                /*Find schedules that were active when Assessment Visit was conducted and up to 3 weeks before and 2 weeks after*/
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate between sched_beg and sched_end then sumhours_lv_wk else null end) as atsp_dt_hrs
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate+7 between sched_beg and sched_end then sumhours_lv_wk else null end) as wkhrs1
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate+14 between sched_beg and sched_end then sumhours_lv_wk else null end) as wkhrs2
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate-7 between sched_beg and sched_end then sumhours_lv_wk else null end) as wkhrs_m1
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate-14 between sched_beg and sched_end then sumhours_lv_wk else null end) as wkhrs_m2
                , (case when sched_beg is not null and assessmentdate is not null and assessmentdate-21 between sched_beg and sched_end then sumhours_lv_wk else null end) as wkhrs_m3
                /*Find schedules active on (svc_from_date +30) and up to 1 week afterwards*/
                , (case when sched_beg is not null and svc_from_Date is not null and svc_from_date+30 between sched_beg and sched_end then sumhours_lv_wk else null end) as umeffwkhrs
                , (case when sched_beg is not null and svc_from_Date is not null and svc_from_date+37 between sched_beg and sched_end then sumhours_lv_wk else null end) as umeffwkhrs1
        from F_REASSESSMENT_TRACKING a
        left join TEMP_PARA_ORDER_MBR2 b on (a.mrn=b.para_ord_mrn);


        xutl.out('TEMP_LEAKAGE_PARA_ORDER_MBR -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'TEMP_LEAKAGE_PARA_ORDER_MBR', '', 10);

        insert into F_REASSESSMENT_ORDER_HISTORY
                select
                  patient_id
                , subscriber_id
                , line_of_business
                , Lob_ID
                , medicaid_num1
                , mrntext
                , mrn
                , current_staff_First_name
                , current_staff_last_name, vendor_name
                , (assigned_to_vendor_on) as assigned_to_vendor_on
                , (reassessment_list_month) as reassessment_list_month
                , plan_desc, plan_name
                , (plan_start_date) as plan_start_date
                , (plan_end_date) as plan_end_date
                , program_name
                , (program_Start_date) as program_start_date
                , (program_end_date) as program_end_date
                , (assessmentdate) as assessmentdate
                , psp_scpt_activity_status, psp_scpt_form_activity_status
                , (psp_start_date) as psp_start_date
                , (psp_end_date) as psp_end_date
                , psp_approved_units, psp_approved_units_num, psp_approved_units_invalid
                , (atsp_date) as atsp_date
                , unavailable_ind, all_docs_completed, all_docs_nosnf, unavailable_ind_svc, svcplan_lateuas
                , (svc_created_on) as svc_created_on
                , svcstaff_first_name, svcstaff_last_name
                , (svc_from_Date) as svc_from_Date
                , (svc_to_date) as svc_to_date
                , auth_closed_seq1, auth_closed_seq2, auth_closed, auths_summed, svc_lob_id
                , sum_req_units, sum_approved_units, svc_unit_type_id, service_Status_id, service_Status
                , auth_no, auth_class_id, sum_hours, sum_days, weeks
                , sum_hrs_x_days, pcw_app_units, pcw_rec_units, pcw_cur_units, auth_id
                , auth_priority_id, auth_priority
                , (auth_noti_date) as auth_noti_date
                , (auth_from_date) as auth_From_date
                , auth_status_id, auth_Status, auth_status_reason_id, auth_status_reason_name
                , (auth_Created_on) as auth_created_on
                , decision_Status
                , (decision_auth_noti_date) as decision_auth_noti_date
                , (decision_created_on) as decision_Created_on
                , (decision_updated_on) as decision_updated_on
                , svcplan_created, svcplan_created_prmr_complete, svcplan_created_psphrs_ok
                , svcplan_closed, svcplan_closed_prmr_complete, svcplan_closed_psphrs_ok
                , (hha_variance_date) as hha_variance_date
                , hha_variance_status
                , (hha_variance_status_date) as hha_variance_status_date
                , (contractadmin_req_date) as contractadmint_req_date
                , (ops_updated_date) as ops_updated_date
                , ops_comments, hha_variance_activity, contractadmin_req_activity, ops_updated_activity
                , atspsplit1
                , atspsplit2
                , wkhrs_m1split1
                , wkhrs_m1split2
                , wkhrs_m2split1
                , wkhrs_m2split2
                , wkhrs_m3split1
                , wkhrs_m3split2
                , wkhrs1split1
                , wkhrs1split2
                , wkhrs2split1
                , wkhrs2split2
                , umeffwkhrssplit1
                , umeffwkhrssplit2
                , umeffwkhrs1split1
                , umeffwkhrs1split2
                , atsp_dt_hrs
                , wkhrs_m1
                , wkhrs_m2
                , wkhrs_m3
                , wkhrs1
                , wkhrs2
                , umeffwkhrs
                , umeffwkhrs1
                , baseline_hrs
                , endpoint_hrs
                , prmrcat
                , prmr_reduction_hrs
                , umcat
                , um_reduction_hrs
                , null job_run_id
                , sysdate SYS_UPD_TS
        from
        (
            select mbr.*
           , atsp.splithours1 as atspsplit1
           , atsp.splithours2 as atspsplit2
           , wkhrs_m1.splithours1 as wkhrs_m1split1
           , wkhrs_m1.splithours2 as wkhrs_m1split2
           , wkhrs_m2.splithours1 as wkhrs_m2split1
           , wkhrs_m2.splithours2 as wkhrs_m2split2
           , wkhrs_m3.splithours1 as wkhrs_m3split1
           , wkhrs_m3.splithours2 as wkhrs_m3split2
           , wkhrs1.splithours1 as wkhrs1split1
           , wkhrs1.splithours2 as wkhrs1split2
           , wkhrs2.splithours1 as wkhrs2split1
           , wkhrs2.splithours2 as wkhrs2split2
           , umeffwkhrs.splithours1 as umeffwkhrssplit1
           , umeffwkhrs.splithours2 as umeffwkhrssplit2
           , umeffwkhrs1.splithours1 as umeffwkhrs1split1
           , umeffwkhrs1.splithours2 as umeffwkhrs1split2
           , atsp.splithours_final as atsp_dt_hrs
           , wkhrs_m1.splithours_final as wkhrs_m1
           , wkhrs_m2.splithours_final as wkhrs_m2
           , wkhrs_m3.splithours_final as wkhrs_m3
           , wkhrs1.splithours_final as wkhrs1
           , wkhrs2.splithours_final as wkhrs2
           , umeffwkhrs.splithours_final as umeffwkhrs
           , umeffwkhrs1.splithours_final as umeffwkhrs1
            /*If OPS hours from ASSESSMENT DATE weren't found, fill in with hours from up to 2 weeks before and 3 weeks after to represent OPS baseline hours*/
            , nvl(nvl(nvl(nvl(nvl(atsp.splithours_final, wkhrs1.splithours_final), wkhrs_m1.splithours_final),wkhrs_m2.splithours_final),wkhrs_m3.splithours_final),wkhrs2.splithours_final) as baseline_hrs
            /*Find OPS hours after auth effective date (use week of effective date and week after)
            per Esther, defined effective date as 30 days from the start of the new auth period*/
            , nvl (umeffwkhrs.splithours_final ,umeffwkhrs1.splithours_final ) as endpoint_hrs
            /*Categorize members according to Premier's recommendation vs. OPS hours at baseline*/
            , (case when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is null then '0a-0basehrs'
                    when mbr.psp_approved_units_num is null then '0b-noPSPhrs'
                    when mbr.psp_approved_units_num = 0 then '0c-SNF 0hrs'
                    when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.psp_approved_units_num is not null
                        and (case
                                when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end)  - mbr.psp_approved_units_num > 0 then '1-Reduced'
                    when
                        (case   when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end) is not null
                        and mbr.psp_approved_units_num is not null
                        and (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end)  - mbr.psp_approved_units_num = 0 then '2-Same'
                    when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.psp_approved_units_num is not null
                        and (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end)  - mbr.psp_approved_units_num < 0 then '3-Increased'
                    else null end) as prmrcat
            , (case when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end) is not null
                        and mbr.psp_approved_units_num is not null
                        then mbr.psp_approved_units_num
                             -     (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null
                                end)
                    else null end) as prmr_reduction_hrs
            /*Categorize members according to what was ultimately authorized vs. OPS hours at baseline*/
            , (case when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is null then '0a-0basehrs'
                    when mbr.sum_hrs_x_days is null then '0d-no UMhrs'
                    when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.sum_hrs_x_days is not null
                        and (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end)  - mbr.sum_hrs_x_days > 0 then '1-Reduced'
                    when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.sum_hrs_x_days is not null
                        and (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end)  - mbr.sum_hrs_x_days = 0 then '2-Same'
                    when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.sum_hrs_x_days is not null
                        and (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end)  - mbr.sum_hrs_x_days < 0 then '3-Increased'
                    else null end) as umcat
            , (case when
                        (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end) is not null
                        and mbr.sum_hrs_x_days is not null
                        then mbr.sum_hrs_x_days
                             -     (case when atsp.splithours_final is not null then atsp.splithours_final
                                when wkhrs1.splithours_final is not null then wkhrs1.splithours_final
                                when wkhrs_m1.splithours_final is not null then wkhrs_m1.splithours_final
                                when wkhrs_m2.splithours_final is not null then wkhrs_m2.splithours_final
                                when wkhrs_m3.splithours_final is not null then wkhrs_m3.splithours_final
                                when wkhrs2.splithours_final is not null then wkhrs2.splithours_final
                                else null end)
                    else null end) as um_reduction_hrs
         from
            (select * from F_REASSESSMENT_TRACKING) mbr
            /*atsp_dt_hrs (OPS hours on date of assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where atsp_dt_hrs is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) atsp on (mbr.patient_id=atsp.patient_id and mbr.reassessment_list_month=atsp.reassessment_list_month
                        and mbr.line_of_business=atsp.line_of_business and mbr.vendor_name=atsp.vendor_name)
            /*wkhrs_m1 (OPS hours on week before assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where wkhrs_m1 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) wkhrs_m1 on (mbr.patient_id=wkhrs_m1.patient_id and mbr.reassessment_list_month=wkhrs_m1.reassessment_list_month
                        and mbr.line_of_business=wkhrs_m1.line_of_business and mbr.vendor_name=wkhrs_m1.vendor_name)
            /*wkhrs_m2 (OPS hours on 2 weeks before assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where wkhrs_m2 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) wkhrs_m2 on (mbr.patient_id=wkhrs_m2.patient_id and mbr.reassessment_list_month=wkhrs_m2.reassessment_list_month
                        and mbr.line_of_business=wkhrs_m2.line_of_business and mbr.vendor_name=wkhrs_m2.vendor_name)
            /*wkhrs_m3 (OPS hours on 3 weeks before assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where wkhrs_m3 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) wkhrs_m3 on (mbr.patient_id=wkhrs_m3.patient_id and mbr.reassessment_list_month=wkhrs_m3.reassessment_list_month
                        and mbr.line_of_business=wkhrs_m3.line_of_business and mbr.vendor_name=wkhrs_m3.vendor_name)
            /*wkhrs1 (OPS hours on 1 week after assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where wkhrs1 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) wkhrs1 on (mbr.patient_id=wkhrs1.patient_id and mbr.reassessment_list_month=wkhrs1.reassessment_list_month
                        and mbr.line_of_business=wkhrs1.line_of_business and mbr.vendor_name=wkhrs1.vendor_name)
            /*wkhrs2 (OPS hours on 2 weeks after assessment)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where wkhrs2 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) wkhrs2 on (mbr.patient_id=wkhrs2.patient_id and mbr.reassessment_list_month=wkhrs2.reassessment_list_month
                        and mbr.line_of_business=wkhrs2.line_of_business and mbr.vendor_name=wkhrs2.vendor_name)
            /*umeffwkhrs (OPS hours 30 days from start of service plan auth period)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final

                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where umeffwkhrs is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) umeffwkhrs on (mbr.patient_id=umeffwkhrs.patient_id and mbr.reassessment_list_month=umeffwkhrs.reassessment_list_month
                        and mbr.line_of_business=umeffwkhrs.line_of_business and mbr.vendor_name=umeffwkhrs.vendor_name)
            /*umeffwkhrs1 (OPS hours 1 week after 30 days from start of service plan auth period)*/
            left join (select b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
                    , max(decode(seq,1, sumhours_lv_wk)) as splithours1
                    , max(decode(seq,2, sumhours_lv_wk)) as splithours2
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then max(decode(seq,1, sumhours_lv_wk))+ max(decode(seq,2, sumhours_lv_wk))
                        else max(decode(seq,1, sumhours_lv_wk))
                       end) as splithours_final
                    , (case when max(decode(seq,2, sumhours_lv_wk))<= 21
                        and substr(max(decode(seq,2, para_ord_prog)),1,1) not in ('V','H')
                        and max(decode(seq,2, sched_end)) >= '29-JUN-2015'
                        and (max(decode(seq,2, sched_saturday_lv))<=3
                             and max(decode(seq,2, sched_sunday_lv))<=3
                             and max(decode(seq,2, sched_monday_lv))<=3
                             and max(decode(seq,2, sched_tuesday_lv))<=3
                             and max(decode(seq,2, sched_wednesday_lv))<=3
                             and max(decode(seq,2, sched_thursday_lv))<=3
                             and max(decode(seq,2, sched_friday_lv))<=3
                            )
                        then concat(max(decode(seq,1, para_ord_prog)), max(decode(seq,2, para_ord_prog)))
                        else max(decode(seq,1, para_ord_prog))
                       end) as splitprogram_final
                  from
                    (select a.*
                        , row_number() over (partition by patient_id, reassessment_list_month order by para_ord_choice desc, para_ord_mltc desc, order_end) as seq
                    from temp_leakage_para_order_mbr a
                    where umeffwkhrs1 is not null ) b
                   group by b.patient_id, b.reassessment_list_month, b.line_of_business, b.vendor_name
            ) umeffwkhrs1 on (mbr.patient_id=umeffwkhrs1.patient_id and mbr.reassessment_list_month=umeffwkhrs1.reassessment_list_month
                        and mbr.line_of_business=umeffwkhrs1.line_of_business and mbr.vendor_name=umeffwkhrs1.vendor_name)
             order by mbr.patient_id, mbr.reassessment_list_month
         )
         ;


        xutl.out('F_REASSESSMENT_ORDER_HISTORY -> ' || sql%rowcount);
        commit;
        DBMS_STATS.GATHER_TABLE_STATS('CHOICEBI', 'F_REASSESSMENT_ORDER_HISTORY', '', 10);
        COMMIT;

        xutl.OUT ('ended');
        xutl.run_end;

    EXCEPTION
        WHEN OTHERS
        THEN
            xutl.out_e (-20156, tid || ' ' || SUBSTR (SQLERRM, 1, 500));
            ROLLBACK;
            RAISE;
    end;

PROCEDURE p_exec_sql( p_in_sql IN VARCHAR2,
                                       p_in_run_id PLS_INTEGER DEFAULT NULL,
                                       p_in_commit_rollback PLS_INTEGER DEFAULT 1)
AS
BEGIN

   IF p_in_run_id IS NOT NULL THEN
      xutl.OUT(p_in_run_id, 'Started Executing -> '||SUBSTR(p_in_sql,1,100));
   END IF;

   EXECUTE IMMEDIATE p_in_sql;

    IF p_in_run_id IS NOT NULL THEN
      xutl.OUT (p_in_run_id, SQL%rowcount || ' rows affected');
    END IF;

    IF p_in_commit_rollback = 1 THEN
       COMMIT;
    END IF;

--    IF p_in_run_id IS NOT NULL THEN
--       xutl.out(p_in_run_id, 'Finished Executing -> '||substr(p_in_SQL,1,100));
--    END IF;
EXCEPTION
WHEN OTHERS THEN
    BEGIN
      xutl.OUT (p_in_run_id, 'ERROR: '||SQLCODE ||' - '|| SUBSTR (SQLERRM, 1, 100));
      xutl.out_e( p_in_run_id, 'ERROR: '||SQLCODE ||' - '|| SUBSTR (SQLERRM, 1, 100));

      IF p_in_commit_rollback = 1 THEN
         ROLLBACK;
      END IF;

      RAISE;
    END;


END;
   PROCEDURE p_refresh_mv (p_in_mv_name VARCHAR2)
   IS
      tid       VARCHAR2 (32);
      vw       VARCHAR2 (300);
      s_sql    VARCHAR2(4096);
      V_SCHMA   VARCHAR2(100);
      V_TBL   VARCHAR2(100);
      v_obj_type varchar2(200);
      lcl_sql   clob;
   BEGIN
      tid :=  'p_refresh_mv - ' || SUBSTR(p_in_mv_name,1,16);
      vw :=  p_in_mv_name;

      xutl.set_id(tid);
      xutl.run_start (tid);
      xutl.OUT (xutl.rid,'started '||tid);

       IF INSTR(VW,'.')>0 THEN
            V_SCHMA := SUBSTR(VW,1,INSTR(VW,'.')-1);
            V_TBL := SUBSTR(VW,INSTR(VW,'.')+1,100);
       ELSE
            V_TBL := VW;        
       END IF;

      select max(object_type) INTO V_OBJ_TYPE from all_objects where  owner =V_SCHMA and object_name =V_TBL and object_type in ('MATERIALIZED VIEW');
            
      if v_obj_type = 'MATERIALIZED VIEW' then
          DBMS_SNAPSHOT.REFRESH(
            LIST                 => vw
           ,METHOD               => 'C'
           ,PUSH_DEFERRED_RPC    => TRUE
           ,REFRESH_AFTER_ERRORS => FALSE
           ,PURGE_OPTION         => 2
           ,PARALLELISM          => 1
           ,HEAP_SIZE            => 1
           ,ATOMIC_REFRESH       => FALSE
           ,NESTED               => FALSE
           );
            commit;                     
      else
            FOR rec IN (SELECT * FROM LU_SQL where table_name = V_TBL) 
            LOOP
               
               lcl_sql := rec.SQL_TRUNCATE_STMT;
               execute immediate lcl_sql;
               xutl.OUT (xutl.rid,'table truncated - ' ||  v_tbl);
               
               lcl_sql := 'insert into ' || v_tbl || '(' ||rec.SQL_INSERT_COLUMN  || ') ' || rec.SQL_INSERT_STMT;
               EXECUTE IMMEDIATE lcl_sql;
               xutl.OUT (xutl.rid,'Data inserted  - ' ||  v_tbl || sql%rowcount );
               commit;
            END LOOP;           
      end if;
        
      xutl.OUT (xutl.rid,'analyze table.. '||tid);
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>V_SCHMA, TABNAME => V_TBL);
      commit;
      xutl.OUT (xutl.rid,'ended '||tid);
      xutl.run_end;
      

   EXCEPTION
      WHEN OTHERS
      THEN
         xutl.out_e (-20148, tid || ' ' ||
               'Error! Exception occurred in p_refresh_mv ('''|| p_in_mv_name ||''')  procedure! '
            || SQLERRM
            || DBMS_UTILITY.format_error_backtrace
            || DBMS_UTILITY.FORMAT_CALL_STACK );
         ROLLBACK;
         RAISE;
   END p_refresh_mv;


procedure ValidateBatchLoad as

    Batch_Load_Failed EXCEPTION;
    PRAGMA EXCEPTION_INIT(Batch_Load_Failed, -20001 );
    cntFailedTableLoad number :=0;
    strFailedloadTbl varchar2(4000);
    
    cursor check_batch_load is
    select * from
    (
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_MEMBER_MONTH' tbl from FACT_MEMBER_MONTH union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_HOSP_ELIG' tbl from MV_HOSP_ELIG union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_MA_RISK_SCORES' tbl from MV_MA_RISK_SCORES union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_MEMBER_ENROLL_DISENROLL' tbl from FACT_MEMBER_ENROLL_DISENROLL union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_MEMBER_DISENROLL_LOB_AGG' tbl from FACT_MEMBER_DISENROLL_LOB_AGG union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_COMPLIANCE_UAS_INITIALS' tbl from FACT_COMPLIANCE_UAS_INITIALS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_COMPLIANCE_UAS_REASSESS' tbl from FACT_COMPLIANCE_UAS_REASSESS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_VENDOR_TRACKING' tbl from FACT_VENDOR_TRACKING union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'F_ASSESSMENT_TIMELINESS' tbl from F_ASSESSMENT_TIMELINESS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_CARE_MANAGER_MONTHLY_CALL' tbl from FACT_CARE_MANAGER_MONTHLY_CALL union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'F_MEMBER_ELIGIBILITY_SCRIPTS' tbl from F_MEMBER_ELIGIBILITY_SCRIPTS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_CLAIM_IN_OUTPATIENT_FOR_LM' tbl from MV_CLAIM_IN_OUTPATIENT_FOR_LM union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_ER_VISIT_UTILIZATION_DATA' tbl from MV_ER_VISIT_UTILIZATION_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_HOSPICE_UTILIZATION_DATA' tbl from MV_HOSPICE_UTILIZATION_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_OUTPATIENT_MATRIX_DATA' tbl from MV_OUTPATIENT_MATRIX_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_VALUE_OPTIONS_MATRIX_DATA' tbl from MV_VALUE_OPTIONS_MATRIX_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_IP_ADMISSION_DATA' tbl from FACT_IP_ADMISSION_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_IP_READMISSION_DATA' tbl from FACT_IP_READMISSION_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_IP_SNF_DATA' tbl from FACT_IP_SNF_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_UAS_DETAILS' tbl from MV_UAS_DETAILS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'MV_QUALITY_MEASURE_ALL_ASSESS' tbl from MV_QUALITY_MEASURE_ALL_ASSESS union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_QUALITY_RISK_MEASURES' tbl from FACT_QUALITY_RISK_MEASURES union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_QUALITY_MEASURES' tbl from FACT_QUALITY_MEASURES union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_MEMBER_PAID_HRS_BY_DAY' tbl from FACT_MEMBER_PAID_HRS_BY_DAY where LINE_OF_BUSINESS= 'MLTC' union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_MEMBER_PAID_HRS_BY_DAY' tbl from FACT_MEMBER_PAID_HRS_BY_DAY where LINE_OF_BUSINESS= 'FIDA' union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_HHA_LTP_DATA' tbl from FACT_HHA_LTP_DATA union all
        select case when count(1) >0 then 0 else 1 end isRecordsNotExist,'FACT_HHA_LTP_MONTHLY_DATA' tbl from FACT_HHA_LTP_MONTHLY_DATA
    )
    where isRecordsNotExist>0;
    
begin
    
    cntFailedTableLoad:=0;
    
    for failedloadRec in check_batch_load 
    loop
    
        cntFailedTableLoad := cntFailedTableLoad +1;
        strFailedloadTbl := strFailedloadTbl || ',';
        
    end loop;

    if cntFailedTableLoad > 0 then
      raise_application_error( -20001,'Batch load failed for Tables : ' || strFailedloadTbl  );
    else
        return;
    end if;
end;

    procedure p_hha_ltp_data as

        ex_misc         EXCEPTION;
        msg_v          VARCHAR2 (255) := 'starting';
        tid            VARCHAR2 (16) := 'P_hha_ltp_data';

    begin

      xutl.set_id(tid);
      xutl.run_start (tid);
      xutl.OUT (xutl.rid,'started '||tid);
        
        insert into gt_hha_ltp_fmm  
        with 
        mxmths as 
        (
            SELECT /*+ no_merge  driving_site(a) */ MAX(month_id) mx_monthid FROM   choicebi.fact_member_month a
        )
        ,zzz_fmm AS
        (
            SELECT 
                /*+  no_merge */  
                 d.day_date,
                 d.choice_week_id,
                 m.month_id,
                 m.member_id,
                 m.subscriber_id,
                 b.product_id,
                 m.dl_plan_sk,
                 m.dl_lob_id,
                 m.program,
                 m.county,
                 m.region_name,
                 m.mrn
            FROM   (
                    SELECT /*+ driving_site(m) no_merge use_hash(m) use_hash(d) */  
                        m.*, 
                        (CASE
                             WHEN disenrollment_date = '31dec2199' AND m.month_id = b.mx_monthid THEN TRUNC(ADD_MONTHS( SYSDATE, 8))
                             WHEN disenrollment_date > LAST_DAY(TRUNC(SYSDATE)) AND m.month_id = b.mx_monthid THEN disenrollment_date
                             ELSE ADD_MONTHS( TO_DATE( m.month_id, 'yyyymm'), 1) - 1
                        END) dt_end_date
                    FROM   choicebi.fact_member_month m, mxmths b
                    WHERE      1 = 1
                         AND TO_DATE(month_id, 'yyyymm') >= '01jan2015' -- choose time of interest
                         AND dl_lob_id IN (2, 4, 5)
                         AND PROGRAM in ('MLTC', 'FIDA')
                 ) m
                 JOIN mstrstg.lu_day d ON (d.day_date BETWEEN TO_DATE(m.month_id, 'yyyymm') AND m.dt_end_date)
                 left join choice.dim_member_enrollment@dlake b on (b.subscriber_id = m.subscriber_id 
                                                                       and d.day_date between b.ENROLLMENT_START_DT and b.ENROLLMENT_END_DT 
                                                                       and b.dl_active_rec_ind = 'Y'AND b.PROGRAM in ('MLTC', 'FIDA')
                            )         
        )
        select * from zzz_fmm;
        xutl.OUT (xutl.rid,'insert completed gt_hha_ltp_fmm : ' || sql%rowcount || '  ' || tid);

        execute immediate 'truncate table HHA_LTP_CLAIM_DETAILS';
        
        insert into HHA_LTP_CLAIM_DETAILS  
        with zzz_hha_claim_details as  
        (
            select 
                    /*+  no_merge  use_hash(c l) driving_site(c) */
                    distinct
                  c.subscriber_id 
                , c.product_id
                , round(c.paid_amt,3) paid_amt
                , l.service_from_dt
                , l.service_provider_id
                , round(l.paid_amt,3) as line_paid_amt
                , round(sum(case when substr(proc_cd,1,5) in  ('T1021','S9122','S5125') then  (
                                                                                    case 
                                                                                        when substr(l.proc_cd,1,5) in ('T1019') and l.units_allow >= 800 then l.units_allow/400 --15 minute code, for the special case caught
                                                                                        when substr(l.proc_cd,1,5) in ('T1019') then l.units_allow/4 --15 minute code     
                                                                                        when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow <= 1 then l.units_allow*13  -- per diem code
                                                                                        when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow > 1 then l.units_allow  -- per diem code
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow/4, 0)) between 15 and 30 then nullif(l.units_allow/4, 0) --per visit code 
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/nullif(l.units_allow, 0) between 15 and 30 then nullif(l.units_allow, 0) --per visit code
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow*13, 0)) between 15 and 30 then nullif(l.units_allow*13, 0) --per visit code
                                                                                        when substr(l.proc_cd,1,5) in ('S9122') and l.units_allow > 500 then l.units_allow/100 -- per hour code
                                                                                        when substr(l.proc_cd,1,5) in ('S9122') then l.units_allow -- per hour code             
                                                                                        when substr(l.proc_cd,1,5) in ('S5130') then l.units_allow/4 --15 minute code
                                                                                        when substr(l.proc_cd,1,5) in ('S5125') then l.units_allow/4 --15 minute code 
                                                                                        else l.units_allow 
                                                                                    end
                                                                                  ) else 0 
                      end),2) as TMG_HHA
                , round(sum(case when substr(proc_cd,1,5) in  ('T1019','T1020','S5130') then  (
                                                                                    case 
                                                                                        when substr(l.proc_cd,1,5) in ('T1019') and l.units_allow >= 800 then l.units_allow/400 --15 minute code, for the special case caught
                                                                                        when substr(l.proc_cd,1,5) in ('T1019') then l.units_allow/4 --15 minute code     
                                                                                        when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow <= 1 then l.units_allow*13  -- per diem code
                                                                                        when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow > 1 then l.units_allow  -- per diem code
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow/4, 0)) between 15 and 30 then nullif(l.units_allow/4, 0) --per visit code 
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/nullif(l.units_allow, 0) between 15 and 30 then nullif(l.units_allow, 0) --per visit code
                                                                                        when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow*13, 0)) between 15 and 30 then nullif(l.units_allow*13, 0) --per visit code
                                                                                        when substr(l.proc_cd,1,5) in ('S9122') and l.units_allow > 500 then l.units_allow/100 -- per hour code
                                                                                        when substr(l.proc_cd,1,5) in ('S9122') then l.units_allow -- per hour code             
                                                                                        when substr(l.proc_cd,1,5) in ('S5130') then l.units_allow/4 --15 minute code
                                                                                        when substr(l.proc_cd,1,5) in ('S5125') then l.units_allow/4 --15 minute code 
                                                                                        else l.units_allow 
                                                                                    end
                                                                                  ) else 0 
                    end) ,2)as TMG_PCA
                , round(sum( 
                            case 
                                when substr(l.proc_cd,1,5) in ('T1019') and l.units_allow >= 800 then l.units_allow/400 --15 minute code, for the special case caught
                                when substr(l.proc_cd,1,5) in ('T1019') then l.units_allow/4 --15 minute code     
                                when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow <= 1 then l.units_allow*13  -- per diem code
                                when substr(l.proc_cd,1,5) in ('T1020') and l.units_allow > 1 then l.units_allow  -- per diem code
                                when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow/4, 0)) between 15 and 30 then nullif(l.units_allow/4, 0) --per visit code 
                                when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/nullif(l.units_allow, 0) between 15 and 30 then nullif(l.units_allow, 0) --per visit code
                                when substr(l.proc_cd,1,5) in ('T1021') and l.paid_amt/(nullif(l.units_allow*13, 0)) between 15 and 30 then nullif(l.units_allow*13, 0) --per visit code
                                when substr(l.proc_cd,1,5) in ('S9122') and l.units_allow > 500 then l.units_allow/100 -- per hour code
                                when substr(l.proc_cd,1,5) in ('S9122') then l.units_allow -- per hour code             
                                when substr(l.proc_cd,1,5) in ('S5130') then l.units_allow/4 --15 minute code
                                when substr(l.proc_cd,1,5) in ('S5125') then l.units_allow/4 --15 minute code
                                else l.units_allow 
                            end          
                  ),2) as TMG_Hours
                 from choice.fct_claim_universe@dlake c
                     /*claim line level tables start here*/
                     left join choice.fct_claim_line_universe@dlake l on (c.claim_id=l.claim_id and c.member_id = l.member_id and l.claim_status in ('02', 'P'))
                 where 1=1
                        and c.lob in ('MLTC', 'FIDA' ,'MA AND MLTC')
                        and l.service_from_dt>='01jan2015'
                        and (l.paid_amt >0 or l.units_allow>0)         
                        and c.paid_amt>0 /*claim not denied*/
                        and c.allowed_amt > 0
                        and c.claim_status in ('02', 'P')
                        and c.claim_adjusted_to is null -- latest version of the '02' claim
                        and substr(l.proc_cd,1,5) in  ('T1019', 'T1020','T1021','S9122','S5130', 'S5125')
            group by 
                subscriber_id, product_id, l.service_from_dt, c.paid_amt , l.paid_amt, l.service_provider_id--, line_paid_amt, first_name                
        ) 
        select 
            SUBSCRIBER_ID        
            ,PRODUCT_ID          
            ,PAID_AMT PAID_AMT             
            ,SERVICE_FROM_DT     
            ,SERVICE_PROVIDER_ID 
            ,LINE_PAID_AMT LINE_PAID_AMT       
            ,TMG_HHA             
            ,TMG_PCA             
            ,TMG_HOURS           
        from zzz_hha_claim_details;
        
        xutl.OUT (xutl.rid,'insert completed gt_hha_ltp_claims_details : ' || sql%rowcount );
                
        insert into gt_hha_ltp_assess 
        with
        zzz_assess as
        (
            select /*+  no_merge full(e) full(a) driving_site(a)  */
                    e.day_date,  a.member_id, a.dl_assess_sk, a.assessmentdate, a.levelofcarescore
                    , row_number () over (partition by a.member_id, e.day_date order by a.assessmentdate desc, a.dl_assess_sk desc) as seq  
            from choice.dim_member_assessments@DLAKE a 
            join mstrstg.lu_day e on(a.assessmentdate <= e.day_date and e.year_id>=2015)
        )
        select * from zzz_assess;
        xutl.OUT (xutl.rid,'insert completed zzz_assess : ' || sql%rowcount );
       
        insert into gt_hha_ltp_snf_data 
        with zzz_snf as 
        (
            select
                  /*+ no_merge use_hash(c l) driving_site(c) */ 
                  distinct
                  c.member_id, c.subscriber_id , c.LOB, c.src_sys, c.claim_id, c.claim_modifier
                , c.claim_id_base, c.claim_status, c.paid_dt, c.paid_amt, c.product_id
                , l.claim_line_seq_num, l.service_id, l.service_from_dt, l.service_to_dt
                , l.charge_amt, l.allowed_amt, l.paid_amt as line_paid_amt, l.units_allow
             from choice.fct_claim_universe@dlake c
             left join choice.fct_claim_line_universe@dlake l on (c.claim_id=l.claim_id and c.member_id = l.member_id and l.claim_status in ('02', 'P') )
             where 1=1
                    and c.lob in ('MLTC', 'FIDA' ,'MA AND MLTC')
                    and l.service_from_dt >='01jan2015'
                    and (l.paid_amt >0 or l.units_allow>0)
                    and c.paid_amt>0 /*claim not denied*/
                    and c.allowed_amt > 0
                    and c.claim_status in ('02', 'P')
                    and c.claim_adjusted_to is null
                    and c.facility_type in  ('02')
                    and c.bill_class in ('1')
                    and ((l.revenue_cd  between '0180' and '0185') 
                    or     (l.revenue_cd  between '0189' and '0199') 
                    or     (l.revenue_cd  between '0100' and '0169')
                    or     (l.revenue_cd  between '0420' and '0444') ) 
        )
        , zzz_snf2 as 
        (
            select /*+ no_merge  */
                   b.subscriber_id,
                   d.day_date, 
                   b.service_from_dt,  
                   b.snf_allow, 
                   b.claim_paid_amt,
                   b.avg_day_cost_los,
                   b.avg_day_cost_allow, 
                   b.snf_hours,
                   b.use_units_allow
        from (
                    select /*+ no_merge materialize full(d) */ 
                        a.* ,
                        case when snf_paid_amt <> claim_paid_amt then 1 else 0 end as diff_claim_line_ind,
                        case when diff_avg_los_allow <> 0 then 1 else 0 end as diff_los_allow_ind,
                        case when diff_days_los_allow <> 0   and avg_day_cost_allow >= 100 and avg_day_cost_allow <= 1500 and (avg_day_cost_los < 100 or avg_day_cost_los > 2000) 
                                then 1
                                else  0 end as use_units_allow
                    from (
                                select subscriber_id, claim_id, product_id, service_from_dt, service_to_dt,
                                    paid_amt as claim_paid_amt,
                                    sum(line_paid_amt) over (partition by claim_id, member_id) as snf_paid_amt,
                                    sum(units_allow) over (partition by claim_id, member_id) as snf_allow,
                                    service_to_dt - service_from_dt + 1 as claim_los,
                                    (service_to_dt - service_from_dt + 1) - (sum(units_allow) over (partition by claim_id, member_id)) as diff_days_los_allow,
                                    paid_amt /  (sum(units_allow) over (partition by claim_id, member_id)) as avg_day_cost_allow,
                                    paid_amt / (service_to_dt - service_from_dt + 1) as avg_day_cost_los,
                                    (paid_amt / (service_to_dt - service_from_dt + 1)) - (paid_amt / (sum(units_allow) over (partition by claim_id, member_id))) as diff_avg_los_allow,
                                    (paid_amt /  (sum(units_allow) over (partition by claim_id, member_id)))/19 as snf_hours
                                from zzz_snf
                            ) a
                        group by subscriber_id, claim_id, product_id, service_from_dt, service_to_dt, snf_paid_amt, claim_paid_amt, snf_allow, claim_los, diff_days_los_allow, avg_day_cost_allow, avg_day_cost_los, diff_avg_los_allow, snf_hours
                    ) b
                join mstrstg.lu_day d on(d.day_date between trunc(b.service_from_dt) and case when use_units_allow = 1 then trunc(b.service_from_dt) + snf_allow -1 else trunc(b.service_to_dt) end) -- when calculation of day cost depends on whether we follow the units allow or service from-to date
        )
        , ZZZ_HHA_SNF_3 as 
        (
            select * 
            from 
            (
                select 
                    a.subscriber_id
                            , a.day_date
                            , a.claim_paid_amt_total
                            , a.claim_paid_amt_day
                            , a.snf_hours
                            --, a.product_id
                from 
                (
                    select 
                                 subscriber_id
                                , day_date
                                , sum(claim_paid_amt) over (partition by subscriber_id, day_date) as claim_paid_amt_total
                                , sum(case when use_units_allow = 1 then avg_day_cost_allow else avg_day_cost_los end) over (partition by subscriber_id, day_date) as claim_paid_amt_day
                                , sum(snf_hours) over (partition by subscriber_id, day_date) as snf_hours
                                --, case when (sum(case when product_id in ('HMD00006', 'VNS030A7','MD000003','HMD00003') then 1 else 0 end) over (partition by subscriber_id, day_date)) >= 1 then 1 else 0 end  as LTP_IND_pdt -- if members have 2 LTP sts on same day take ltp
                                --, product_id
                    from zzz_snf2 
                ) a
                group by  a.subscriber_id
                            , a.day_date
                            , a.claim_paid_amt_total
                            , a.claim_paid_amt_day
                            , a.snf_hours
                            --, a.product_id
            )
        )
        select * from ZZZ_HHA_SNF_3;
        xutl.OUT (xutl.rid,'insert completed ZZZ_HHA_SNF_3 : ' || sql%rowcount );
        
        execute immediate 'truncate table fact_hha_ltp_data_tmp';
        
        insert into fact_hha_ltp_data_tmp 
        (
            DAY_DATE                 
            ,CHOICE_WEEK_ID           
            ,MONTH_ID                 
            ,QUARTER_ID               
            ,MEMBER_ID                
            ,SUBSCRIBER_ID            
            ,MRN                      
            ,DL_ASSESS_SK             
            ,ASSESSMENTDATE           
            ,LEVELOFCARESCORE         
            ,TOOL_SRC_SYS             
            ,TOOL_ID                  
            ,TOOL_HOURS_WEEK          
            ,TOOL_HOURS_DAY           
            ,SCRIPT_RUN_LOG_ID        
            ,PSP_DATE                 
            ,PSP_HOURS_WEEK           
            ,PSP_HOURS_DAY            
            ,AUTH_ID                  
            ,AUTH_HOURS_WEEK          
            ,AUTH_HOURS_DAY           
            ,AUTH_EXT_IND             
            ,OPS_HOURS_DAY            
            ,OPS_EXT_IND              
            ,TPPVE_HHA_HOURS_DAY      
            ,TPPVE_HHA_AMT_DAY        
            ,TMG_HHA_HOURS_DAY        
            ,TMG_HHA_AMT_DAY          
            ,CLAIM_HHA_HOURS_DAY      
            ,CLAIM_HHA_AMT_DAY        
            ,SNF_AUTH_ID              
            ,SNF_AUTH_TYPE_NAME       
            ,SNF_HOURS_DAY            
            ,SNF_AMT_DAY              
            ,LTP_AUTH_IND             
            ,PRODUCT_ID               
            ,LTP_PRODUCT_ID_IND       
            ,LTP_IND                  
            ,PERMANENT_PLACEMENT_DATE 
            ,LTP_PLACEMENT_DATE       
            ,PLACEMENT_TYPE           
            ,CARVEOUT_IND       
            ,TMG_PRODUCT_DESCRIPTION  
            ,DL_PLAN_SK
            ,PROGRAM
            ,DL_LOB_ID
            ,COUNTY
            ,REGION_NAME        
        )
        with 
        zzz_psp as
        (          
            select /*+ no_merge full(d) driving_site(p)  */ e.day_date
                , p.script_run_log_id
                , p.unique_id subscriber_id
                , p.end_date
                , p.psp_approved as psp_approved_Per_Week
                , p.psp_approved / 7 as psp_approved_Per_Day
                , cast(regexp_replace(p.PSP_tasking_tool, '[^0-9]+', '') as number) as PSP_tasking_Total_Per_Week
                , cast(regexp_replace(p.PSP_tasking_tool, '[^0-9]+', '') as number) / 7 as PSP_tasking_Total_Per_Day
                , row_number () over (partition by unique_id, e.day_date order by p.end_date desc) as seq   
            from    gc_psp p
            left join mstrstg.lu_day e on (trunc(p.end_date)<=e.day_date and e.year_id >= 2015)
        )
        , zzz_help as 
        (
            select /*+ no_merge full(e)  driving_site(a) */ 
                  e.day_date, row_number () over (partition by coalesce(b1.member_id, b2.member_id, b3.member_id), e.day_date order by a.createddate desc) as seq
                , a.id, a.patientname, a.mrn, a.uas_medicaid_id, coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id
                , a.levelofcarescore, a.assessmentdate, a.nurseassessor, a.nursesignaturedate
                , a.createddate, a.updateddate
                , a.finalrecommendation_totalhours  
            from dw_owner.assessments a
                left join (select a.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn a) b1 on (to_char(a.mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
                left join (select a.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn a) b2 on (to_char(a.mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
                left join (select a.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn a) b3 on (to_char(a.mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)
                left join mstrstg.lu_day e on(a.createddate <= e.day_date and e.year_id >= 2015)
            where a.nursesignatureflag='Y'
        )
        --**********************
        , ops as
        (
               select /*+ no_merge materialize */
               distinct coalesce(b1.member_id, b2.member_id, b3.member_id) as member_id,  b.subscriber_id, b.mrn, b.the_date, b.ops_hrs_day, to_char(b.the_date, 'DY') as day_name
               from choicebi.fact_member_paid_hrs_by_day b
               left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b1 on (to_char(b.mrn) = to_char(b1.mrn) and b1.mrn_src = '1-DM' and b1.mrn_seq = 1)
               left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b2 on (to_char(b.mrn) = to_char(b2.mrn) and b2.mrn_src = '2-MEDCD' and b2.mrn_seq = 1)
               left join (select x.*, row_number() over (partition by mrn, mrn_src order by member_id desc) as  mrn_seq from xwalk_member_id_mrn x) b3 on (to_char(b.mrn) = to_char(b3.mrn) and b3.mrn_src = '3-HICN' and b3.mrn_seq = 1)  
               where ops_hrs_day is not null
        )     
        , last_auth as 
        (         
            select 
                a.*, d.hours_per_week, d.hours_per_day_avg, to_char(a.day_date, 'DY') as day_name
                , row_number() over (partition by a.subscriber_id  order by a.day_date) as seq_key
            from gt_hha_ltp_fmm a
                left join gc_hha_auths_by_day d on(a.subscriber_id =d.unique_id and d.day_date=a.day_date) 
            where 
                a.choice_week_id = (select distinct choice_week_id from gt_hha_ltp_fmm where day_date = trunc(sysdate)) - 1-- to get week_id for last week
        )
        , last_ops as 
        (         
            select 
                a.*, h.ops_hrs_day, h.day_name
                , row_number() over (partition by a.mrn order by a.day_date) as seq_key
            from gt_hha_ltp_fmm a
                left join ops h on(a.member_id=h.member_id and a.day_date=h.the_date and a.subscriber_id = h.subscriber_id) 
            where 
                a.choice_week_id = (select distinct choice_week_id from gt_hha_ltp_fmm where day_date = trunc(sysdate)) - 1-- to get week_id for last week
        )
        , nami as 
        (
            select /*+ no_merge materialize  */ distinct 
                    a.id,
                    b.MEMBER_CIN, 
                    a.medicaid, 
                    a.current_eff_date, 
                    trunc(b.EFF_DATE_OF_PLACEMENT) as permanent_placement_date, 
                    trunc(a.ltp_placement_date) as ltp_placement_date, 
                    a.ros_medicaid_exc_code_1, 
                    a.member_county,
                    b.NH_NPI, 
                    b.PRACTICE_NAME, 
                    trunc(a.termination_date) as termination_date ,    
                    b.PCP_PROVIDER, 
                    a.tmg_product_description, 
                    a.tmg_product_id, 
                    trunc(a.original_eff_date) as mltc_plan_enrollment_date,   
                    a.vns_subscriber_id, 
                    a.ros_medicaid_exc_code_2, 
                    a.new_ltp_placement, 
                    a.carveout_indicator, 
                    a.carveout_date, 
                    b.NH_ADMIT_DATE, 
                    b.PLACEMENT_TYPE,  
                    b.SUBSCRIBER_ID,
                    b.source,
                    b.ACTIVE_REC_IND,
                     row_number() over (partition by b.SUBSCRIBER_ID order by  b.EFF_DATE_OF_PLACEMENT, b.ACTIVE_REC_IND desc) as seq_key
            from dw_owner.sf_mltc_lead a
                left join dw_owner.sf_ltp_placement b on (a.id = b.mltc_lead) 
            where 1=1 
            and b.EFF_DATE_OF_PLACEMENT is not null
            and b.placement_type = 'NURSING HOME - LONG TERM' 
        )          
        , zzz_hha_snf_tb as
        (
            select /*+ full(e) */ distinct
        --       date info
               e.Day_date
             , e.choice_week_id
             , e.month_id
             , e.quarter_id
        --     member info
             , a.member_id
             , coalesce(a.subscriber_id, c.subscriber_id , d.unique_id, f.subscriber_id) as Subscriber_id
             , coalesce(a.mrn, b.mrn) as MRN
        --     assessment info
             , g.dl_assess_sk
             , g.assessmentdate
             , g.levelofcarescore
        --     HelpsTool info
             , case when i.id is not null then 'Helps'
                       when f.script_run_log_id is not null then 'ATSP'
                       else null end as Tool_src_sys
             , coalesce( i.id, f.script_run_log_id) as tool_id
             , coalesce(i.finalrecommendation_totalhours, to_number(f.psp_tasking_total_per_week)) as Tool_hours_week
             , coalesce(i.finalrecommendation_totalhours, to_number(f.psp_tasking_total_per_week)) / 7 as Tool_hours_day
        --     PSP info
             , f.script_run_log_id
             , trunc(f.end_date) as PSP_date
             , f.psp_approved_per_week as PSP_hours_week
             , f.psp_approved_per_day  as PSP_hours_day
        --     Auth info
             , d.auth_id
             , coalesce(d.hours_per_week, d2.hours_per_week) as Auth_Hours_Week
             , coalesce(d.hours_per_day_avg, d2.hours_per_day_avg) as Auth_Hours_day
             , case when d.hours_per_day_avg is null and d2.hours_per_day_avg is not null then 1 else 0 end as auth_ext_ind 
        --     OPS info
             , coalesce(sum(h.ops_hrs_day) over (partition by h.mrn, h.the_date), h2.ops_hrs_day)  as OPS_Hours_day
             , case when  h.ops_hrs_day is null and h2.ops_hrs_day is not null then 1 else 0 end as ops_ext_ind 
        --     TPPVE payment info  
             , sum(b.tppve_hours) over (partition by b.mrn, b.pay_visit_date) as tppve_hha_hours_day
             , sum(b.total_pay_amount) over (partition by b.mrn, b.pay_visit_date) as tppve_hha_amt_day
        --     TMG claim info
             , sum(c.TMG_Hours) over (partition by c.subscriber_id, c.service_from_dt)  as tmg_hha_hours_day
             , sum(c.line_paid_amt) over (partition by c.subscriber_id, c.service_from_dt)  as tmg_hha_amt_day
        --     Combine HHA-Claim info
             , coalesce(sum(b.tppve_hours) over (partition by b.member_id, b.pay_visit_date), sum(c.TMG_Hours) over (partition by c.subscriber_id, c.service_from_dt)) as Claim_hha_Hours_day
             , coalesce(sum(b.total_pay_amount) over (partition by b.member_id, b.pay_visit_date) , sum(c.line_paid_amt) over (partition by c.subscriber_id, c.service_from_dt)) as Claim_hha_amt_day
        --     SNF info
             , k.auth_id as snf_auth_id
             , k.auth_type_name as snf_auth_type_name
             , j.snf_hours as snf_hours_day
             , j.claim_paid_amt_day as snf_amt_day
        --     product_id info
             , decode(k.auth_type_name, 'Inpatient - SNF', 0, 'Inpatient - Long Term Care Facility', 1, null) as ltp_auth_ind
             , a.product_id as product_id -- for missing product_id i.e. future dates, use the most recent
             , case when a.product_id in ('HMD00006', 'VNS030A7','MD000003','HMD00003', 'MD000006') then 1 else 0 end as ltp_product_id_ind 
             , case when e.month_id between '201501' and '201803' 
                  and (a.product_id in ('HMD00006', 'VNS030A7','MD000003','HMD00003', 'MD000006')) then 1 --201501 and 201803: Product_Id
                    when e.month_id >= '201804'
                    and (a.product_id in ('HMD00006', 'VNS030A7','MD000003','HMD00003', 'MD000006') OR k.auth_type_name = 'Inpatient - Long Term Care Facility') then 1 -- on and after 201804: Product_Id OR LTP AUTH
             else 0 end as ltp_ind        
        -- LTP info from NAMI table
             , p.permanent_placement_date
             , p.ltp_placement_date
             , p.placement_type
             , p.carveout_indicator
             , p.tmg_product_description
             , a.dl_plan_sk
             , a.program
             , a.dl_lob_id
             , a.county
             , a.region_name
            from gt_hha_ltp_fmm a
                left join MV_HHA_TPPVE_DETAILS b on(a.member_id=b.member_id and a.day_date=b.pay_visit_date) -- and b.tppve_hours <= 24)
                left join HHA_LTP_CLAIM_DETAILS c on(a.subscriber_id=c.subscriber_id  and a.day_date=c.service_from_dt) -- and c.tmg_hours <= 24)
                left join choicebi.gc_hha_auths_by_day d on(a.subscriber_id=d.unique_id and a.day_date=d.day_date)
                left join last_auth d2 on(a.subscriber_id =d2.subscriber_id and to_char(a.day_date, 'DY') = d2.day_name and a.choice_week_id > d2.choice_week_id and substr(a.choice_week_id, 4) = extract(year from sysdate)) -- extend auth hours
                left join mstrstg.lu_day e on(e.day_date=coalesce(a.day_date, b.pay_visit_date, c.service_from_dt, d.day_date))
                left join zzz_psp f on(a.subscriber_id=f.subscriber_id and a.day_date=trunc(f.day_date) and f.seq=1) -- and f.psp_approved_per_week <=168)
                left join gt_hha_ltp_assess g on(a.member_id=g.member_id and a.day_date=trunc(g.day_date) and g.seq=1)
                left join ops h on(a.member_id=h.member_id and a.day_date=h.the_date and a.subscriber_id = h.subscriber_id)
                left join last_ops h2 on(a.member_id=h2.member_id and a.subscriber_id = h.subscriber_id and to_char(a.day_date, 'DY') = h2.day_name and a.choice_week_id > h2.choice_week_id and substr(a.choice_week_id, 4) = extract(year from sysdate)) -- extend OPS hours
                left join zzz_help i on (a.member_id=i.member_id and a.day_date=trunc(i.day_date) and i.seq=1)
                left join gt_hha_ltp_snf_data j on (a.subscriber_id = j.subscriber_id and a.day_date = j.day_date)
                left join gc_snf_auths_by_day k on (a.subscriber_id=k.unique_id and a.day_date=k.day_date)
                left join nami p on (a.subscriber_id = p.subscriber_id and a.day_date >= trunc(p.permanent_placement_date) and p.placement_type = 'NURSING HOME - LONG TERM' and p.seq_key = 1)
            where 
                    A.PROGRAM IN ('MLTC','FIDA')
                AND a.day_date >= '01Jan2015'
        )
        select /*+ parallel(2) */ * from zzz_hha_snf_tb;
        xutl.OUT (xutl.rid,'insert completed fact_hha_ltp_data : ' || sql%rowcount );
        
        
        commit;
                
    end p_hha_ltp_data;

 BEGIN
   -- session specific initialization
   NULL;
--


END ETL;
/