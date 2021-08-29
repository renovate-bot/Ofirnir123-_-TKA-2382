Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe111.sql /main/6 2018/07/25 13:49:08 surman Exp $
Rem
Rem ctxe111.sql
Rem
Rem Copyright (c) 2008, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe111.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade to 11.1.0.6
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe111.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe111.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yiqi        08/22/11 - lrg 5850479
Rem    rpalakod    04/30/10 - d1102000.sql
Rem    rpalakod    12/08/08 - lrg 3693400: 11.1.0.6 vs 11.1.0.7 downgrade
Rem    rpalakod    02/21/08 - lrg 3310955
Rem    rpalakod    02/21/08 - Created
Rem

REM ===========================================================
REM set schema, registry
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

EXECUTE dbms_registry.downgrading('CONTEXT');

REM drop all packages, procedures, programmatic types
@@ctxdpkg.sql

REM ==========================================
REM downgrade from 11.2.0.4 to 11.2.0.3
REM ==========================================

@@d1102040.sql

REM ==========================================
REM downgrade from 11.2.0.3 to 11.2.0.2
REM ==========================================

@@d1102030.sql

REM ==========================================
REM downgrade from 11.2.0.2 to 11.2.0.1
REM ==========================================

@@d1102000.sql

Rem ===========================================
Rem setup component script filname variable
Rem ===========================================
COLUMN :script_name NEW_VALUE comp_file NOPRINT
Variable script_name varchar2(50)

Rem ===========================================
Rem select downgrade script to run
Rem ===========================================
DECLARE
  version   SYS.registry$.version%type;
Begin
  --init 
  :script_name := dbms_registry.nothing_script;

  select dbms_registry.version('CONTEXT') into version from dual;
  If (substr(version, 1, 8) = '11.1.0.6') then
     :script_name := '@d1100000.sql';
  elsif (substr(version, 1, 8) = '11.1.0.7') then
     :script_name := '@d1110000.sql';
  else
     :script_name := dbms_registry.nothing_script;
  end if;

end;
/


Rem ===========================================
Rem Invoke version specific downgrade script
Rem ===========================================
select :script_name from dual;
@&comp_file


REM ========================================================================
REM Registry to downgraded state
REM ========================================================================

EXECUTE dbms_registry.downgraded('CONTEXT','11.1.0');

REM ========================================================================
REM reset schema to SYS
REM ========================================================================     
ALTER SESSION SET CURRENT_SCHEMA = SYS;

