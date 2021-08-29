Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxu1201.sql /main/14 2018/02/28 22:49:17 boxia Exp $
Rem
Rem ctxu1201.sql
Rem
Rem Copyright (c) 2012, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxu1201.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      upgrade from 12R1 to latest version
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxu1201.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxu1201.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/09/18 - Bug 27495209: add upgrade to 19.1
Rem    boxia       11/29/16 - Bug 25172618: add s1202020
Rem    snetrava    11/02/16 - Added Upgrade to 12.2.0.2.0
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    boxia       04/01/14 - Bug 18499551: update version automatically
Rem    boxia       01/06/14 - Bug 18037959: change s1201020 to s1202000
Rem    boxia       01/02/14 - Bug 16989137: add s1201020.sql
Rem    boxia       09/11/13 - add u1202000.sql
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    boxia       03/05/13 - Bug 16404191: Upgrade to 12.1.0.2.0
Rem    ssethuma    01/14/13 - Bug 15986393: Upgrade to 12.1.0.2
Rem    ataracha    09/05/12 - update version - 12.1.0.1.0
Rem    yiqi        06/08/12 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

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
@@s1200010.sql
@@s1202000.sql
@@s1202020.sql
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
REM 12.1 to 12.1.0.2
REM ========================================================================

@@u1201020.sql
@@t1201020.sql

REM ========================================================================
REM 12.1.0.2 to 12.2
REM ========================================================================

@@u1202000.sql
@@t1202000.sql

REM ========================================================================
REM 12.2 to 12.2.0.2 (alias 18.1)
REM ========================================================================

@@u1202020.sql
@@t1202020.sql

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
