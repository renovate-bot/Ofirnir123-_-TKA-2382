Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxu1801.sql /main/1 2018/04/17 19:17:48 boxia Exp $
Rem
Rem ctxu1801.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      ctxu1801.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade from 18.0.0.0.0 to the latest version
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxu1801.sql
Rem    SQL_SHIPPED_FILE:ctx_src_2/src/dr/admin/ctxu1801.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: UPGRADE
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       04/06/18 - Bug 27797333: created
Rem

@@?/rdbms/admin/sqlsessstart.sql

REM ========================================================================
REM set schema, Registry to upgrading state
REM ========================================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

begin
dbms_registry.upgrading('CONTEXT','Oracle Text','validate_context','CTXSYS');
end;
/

REM ========================================================================
REM
REM ******************* Begin SYS changes **********************************
REM
REM ========================================================================

ALTER SESSION SET CURRENT_SCHEMA = SYS;
@@s1901000.sql
ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

REM ========================================================================
REM
REM ******************* End SYS changes ************************************
REM
REM ========================================================================

REM ========================================================================
REM
REM ******************* Begin CTXSYS schema changes ************************
REM
REM ========================================================================

REM ========================================================================
REM Pre-upgrade steps
REM ========================================================================

@@ctxpreup.sql

REM ========================================================================
REM 18.1 to 19.1
REM ========================================================================

@@u1901000.sql
@@t1901000.sql

REM ========================================================================
REM Post-upgrade steps
REM ========================================================================

@@ctxposup.sql

REM ========================================================================
REM
REM ****************  End CTXSYS schema change *****************************
REM
REM ========================================================================

REM ========================================================================
REM Registry to upgraded state, reset schema
REM ========================================================================

begin
  dbms_registry.loaded('CONTEXT');
  dbms_registry.valid('CONTEXT');
end;
/

ALTER SESSION SET CURRENT_SCHEMA = SYS;


@?/rdbms/admin/sqlsessend.sql
 
