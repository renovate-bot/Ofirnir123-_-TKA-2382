Rem
Rem $Header: ctx_src_2/src/dr/admin/d1110000.sql /main/18 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1110000.sql
Rem
Rem Copyright (c) 2008, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1110000.sql - downgrade from 11.2 to 11.1.0.7
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1110000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1110000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    boxia       01/21/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yiqi        12/12/12 - Bug 15960782
Rem    surman      12/21/11 - 13508115: Skip policies when creating triggers
Rem    rpalakod    08/06/10 - Bug 9973683
Rem    rpalakod    04/30/10 - autooptimize and doclexer
Rem    rpalakod    04/29/10 - Bug 9669751
Rem    rkadwe      04/04/10 - Document Level Lexer
Rem    ssethuma    03/30/10 - XbranchMerge ssethuma_bug-9048930 from main
Rem    surman      06/01/09 - 8323978: Ignore ORA-4081 error
Rem    surman      05/29/09 - 8323978: Recreate map triggers on downgrade
Rem    shorwitz    03/25/09 - Bug 4860137
Rem    nenarkhe    08/25/09 - ctx_tree
Rem    rpalakod    08/17/09 - Bug 8809055
Rem    rpalakod    08/09/09 - autooptimize
Rem    rpalakod    02/18/09 - change name of near_realtime
Rem    rpalakod    02/05/09 - nrtidx api
Rem    shorwitz    01/09/09 - Bug 4860137: roll back maxterm limits
Rem    nenarkhe    01/22/09 - reverse MVDATA changes
Rem    rpalakod    01/07/09 - separate_offsets
Rem    rpalakod    01/05/09 - Reverse BIG IO changes
Rem    rpalakod    12/08/08 - lrg 3693400: 11.1.0.7 downgrade
Rem    rpalakod    12/08/08 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ===================================================================
REM Reverse changes made for Bug 9048930 fix
REM ===================================================================

update dr$index_cdi_column
  set cdi_column_name = ltrim(rtrim(cdi_column_name, '"'),'"');
commit;

REM ==================================================================
REM Reverse Change from bug 7353283 to disallow bigram attribute
REM   in Japanese_Lexer.
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=60210 and OAT_CLA_ID=6 and OAT_OBJ_ID=2 and OAT_ATT_ID=10
    and OAT_NAME='BIGRAM';
commit;

REM ==================================================================
REM Reverse Change from BIG_IO txn to disallow BIG_IO storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90110 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=10
    and OAT_NAME='BIG_IO';
commit;

REM ==================================================================
REM Reverse Change from SEP_OFF txn to disallow SEPARATE_OFFSETS 
REM    storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90111 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=11
    and OAT_NAME='SEPARATE_OFFSETS';

REM ===================================================================
REM WILDCARD_MAXTERMS
REM ===================================================================

update dr$object_attribute
  set oat_val_min = 1
  where oat_id = 70106;
commit;

REM ==================================================================
REM Reverse Change from MVDATA txn to disallow MV_TABLE_CLAUSE
REM    storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90112 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=12
    and OAT_NAME='MV_TABLE_CLAUSE';
commit;

delete from dr$object_attribute
  where OAT_ID=50212 and OAT_CLA_ID=5 and OAT_OBJ_ID=2 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

delete from dr$object_attribute
  where OAT_ID=50312 and OAT_CLA_ID=5 and OAT_OBJ_ID=3 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

delete from dr$object_attribute
  where OAT_ID=50512 and OAT_CLA_ID=5 and OAT_OBJ_ID=5 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

REM ==================================================================
REM Reverse Change from NRTIDX txn to disallow NEAR_REALTIME storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90113 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=13
    and OAT_NAME='STAGE_ITAB';

delete from dr$object_attribute
  where OAT_ID=90114 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=14
    and OAT_NAME='G_TABLE_CLAUSE';

delete from dr$object_attribute
  where OAT_ID=90115 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=15
    and OAT_NAME='G_INDEX_CLAUSE';

commit;

REM ==================================================================
REM 8323978: Recreate map triggers
REM ==================================================================
set serveroutput on
declare
  cursor all_indexes is
    select username, idx_name, idx_id,
           ixp_name, ixp_id
      from dba_users u, ctxsys.dr$index i, ctxsys.dr$index_partition p
      where i.idx_option not like '%O%'
        and i.idx_id = p.ixp_idx_id (+)
        and u.user_id = i.idx_owner#;

  sql_string varchar2(4000);
  pfx   varchar2(80);
  tpfx  varchar2(80);
begin
  for rec in all_indexes loop
    if (ctxsys.drixmd.IndexHasPTable(rec.idx_id)) then
      pfx := ctxsys.driutl.make_pfx(rec.username, rec.idx_name,
                                    '$', rec.ixp_id);
      tpfx := ctxsys.driutl.make_pfx(rec.username, rec.idx_name, 'T',
                                     rec.ixp_id);
      sql_string :=
        ctxsys.drvxtab.map_trigger_text(pfx, tpfx,
          gtab=>ctxsys.drixmd.IndexHasGTable(rec.idx_id));

        if rec.ixp_name is null then
          dbms_output.put_line('creating trigger for index ' || rec.username ||
          '.' || rec.idx_name);
        else
          dbms_output.put_line('creating trigger for index ' || rec.username ||
          '.' || rec.idx_name || ', partition ' || rec.ixp_name);
        end if;

      begin
        execute immediate sql_string;
      exception
        when others then
          if sqlcode != -4081 then
            -- ignore "trigger already exists" error
            raise;
          end if;
      end;
    end if;
  end loop;
end;
/

REM ==================================================================
REM Reverse Changes from stop_opt_list
REM ==================================================================

declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'STOP_OPT_LIST' and
    idx_owner# = l_owner#;
  delete from dr$index_object where ixo_idx_id = l_pol_id;
  delete from dr$index_value where ixv_idx_id = l_pol_id;
  delete from dr$index where idx_id = l_pol_id;
  delete from dr$stats where idx_id = l_pol_id;
  delete from dr$index_error where err_idx_id = l_pol_id;
  commit;
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/

drop type dr$itab_t force;
create or replace type dr$itab_t as object(
  token_text  varchar2(64),
  token_type  number(3),
  token_first number,
  token_last  number,
  token_count number,
  token_info  blob
);
/
drop type dr$itab_set_t force;
create or replace type dr$itab_set_t as table of dr$itab_t;
/
drop type dr$itab0_t force;
create or replace type dr$itab0_t as object(
  token_text       varchar2(64),
  token_type       number(3),
  token_first      number,
  token_last       number,
  token_count      number,
  token_info_raw   raw(4000)
);
/
drop type dr$itab0_set_t force;
create or replace type dr$itab0_set_t as table of dr$itab0_t;
/

drop type dr$opttf_impl_t force;
create or replace type dr$opttf_impl_t authid current_user as object(
  key     RAW(16),

  static function ODCITableStart(
      sctx        OUT    dr$opttf_impl_t, 
      optim_state IN     dr$optim_state_t,
      mycur              SYS_REFCURSOR,
      tempItab           VARCHAR2,
      ntab               VARCHAR2)
     return PLS_INTEGER,

  static function ODCITableStart2(
      sctx OUT    dr$opttf_impl_t, 
      mycur       SYS_REFCURSOR,
      tempItab    VARCHAR2,
      ntab        VARCHAR2)
     return PLS_INTEGER
    is
    language C
    library dr$lib
    name "optStart"
    with context
    parameters (
      context,
      sctx,
      sctx INDICATOR STRUCT,
      mycur,
      tempItab,
      ntab,
      return INT
    ),

  member function ODCITableFetch(self IN OUT dr$opttf_impl_t, nrows IN Number,
                                 outarr OUT dr$itab0_set_t) return PLS_INTEGER
    as language C
    library dr$lib
    name "optFetch"
    with context
    parameters (
      context,
      self,
      self INDICATOR STRUCT,
      nrows,
      outarr OCIColl,
      outarr INDICATOR sb2,
      return INT
    ),

  member function ODCITableClose(self IN dr$opttf_impl_t) return PLS_INTEGER
    as language C
    library dr$lib
    name "optClose"
    with context
    parameters (
      context,
      self,
      self INDICATOR STRUCT,
      return INT
    )
);
/


