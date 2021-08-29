Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe112.sql /main/10 2018/02/28 22:49:17 boxia Exp $
Rem
Rem ctxe112.sql
Rem
Rem Copyright (c) 2010, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe112.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Downgrade from 121 to 11204, 11203, 11202
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe112.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe112.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: rdbms/admin/cmpdbdwg.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/09/18 - Bug 27495209: add downgrade from 19.1
Rem    snetrava    11/02/16 - Added Downgrade from 12.2.0.2.0
Rem    nspancha    07/26/16 - Adding call for downgrade from 12.2 too
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yiqi        04/17/12 - Bug 13973043
Rem    yiqi        02/08/12 - lrg 6715880
Rem    rpalakod    04/30/10 - d1102000.sql
Rem    surman      01/28/10 - 9305120: Creation
Rem    surman      01/28/10 - Created
Rem

REM ===========================================================
REM set schema, registry
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

EXECUTE dbms_registry.downgrading('CONTEXT');

REM drop all packages, procedures, programmatic types
@@ctxdpkg.sql

REM ===========================================================
REM downgrade from 19.1 to 12.2.0.2 (alias 18.1)
REM ===========================================================

@@d1901000.sql

REM ===========================================================
REM downgrade from 12.2.0.2 to 12.2
REM ===========================================================

@@d1202020

REM ==========================================
REM downgrade from 12.2 to 12.1
REM ==========================================

@@d1202000


REM ==========================================
REM downgrade from 121 to 11204
REM ==========================================

@@d1201000

Rem ===========================================
Rem setup component script filname variable
Rem ===========================================

COLUMN :s1_name NEW_VALUE d11204_file NOPRINT
Variable s1_name varchar2(50)
COLUMN :s2_name NEW_VALUE d11203_file NOPRINT
Variable s2_name varchar2(50)

REM =============================================================
REM downgrade from 11204 to 11203, 11203 to 11202 if applicable
REM =============================================================

declare
  prv_version   SYS.registry$.version%type; 
begin
  :s1_name := dbms_registry.nothing_script;
  :s2_name := dbms_registry.nothing_script;
  select dbms_registry.prev_version('CONTEXT') into prv_version from dual;
  IF prv_version < '11.2.0.4' THEN
    :s1_name := '@d1102040.sql';
    IF prv_version < '11.2.0.3' THEN
      :s2_name := '@d1102030.sql';
    END IF;
  END IF;
end;
/

Rem ===========================================
Rem Invoke version specific downgrade script
Rem ===========================================
select :s1_name from dual;
@&d11204_file
select :s2_name from dual;
@&d11203_file


REM ========================================================================
REM Registry to downgraded state
REM ========================================================================

EXECUTE dbms_registry.downgraded('CONTEXT','11.2.0');

REM ========================================================================
REM reset schema to SYS
REM ========================================================================     
ALTER SESSION SET CURRENT_SCHEMA = SYS;

