Rem
Rem ctxe101.sql
Rem
Rem Copyright (c) 2004, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe101.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 10.2 to 10.1
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe101.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe101.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/27/15 - 20411134: Add SQL metadata tags
Rem    yiqi        08/23/11 - lrg 5850479
Rem    rpalakod    04/30/10 - d1102000.sql
Rem    wclin       10/12/07 - run d1100000.sql
Rem    gkaminag    09/01/05 - drop packages 
Rem    gkaminag    02/18/05 - backout any patchset changes
Rem    gkaminag    08/03/04 - deprecate connect
Rem    gkaminag    05/12/04 - gkaminag_upgrade_040512
Rem    gkaminag    05/12/04 - gkaminag_upgrade_040512
Rem    gkaminag    03/22/04 - gkaminag_misc_040318 
Rem    gkaminag    03/18/04 - Created
Rem


REM ===========================================================
REM regrant connect role
REM ===========================================================

revoke create session, alter session, create view, create synonym from CTXSYS;
grant CONNECT to CTXSYS;

REM ===========================================================
REM set schema, registry
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

EXECUTE dbms_registry.downgrading('CONTEXT');

REM drop all packages, procedures, programmatic types
@@ctxdpkg.sql

REM run downgrade scripts
@@d1102040.sql
@@d1102030.sql
@@d1102000.sql
@@d1100000.sql
@@d1002000.sql
@@d1001002.sql

REM ========================================================================
REM Registry to downgraded state
REM ========================================================================

EXECUTE dbms_registry.downgraded('CONTEXT','10.1.0');

REM ========================================================================
REM reset schema to SYS
REM ========================================================================     
ALTER SESSION SET CURRENT_SCHEMA = SYS;

