Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe102.sql /main/9 2018/07/25 13:49:08 surman Exp $
Rem
Rem ctxe102.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe102.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 11.x to 10.2
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe102.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe102.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yiqi        08/23/11 - lrg 5850479
Rem    rpalakod    04/30/10 - d1102000.sql
Rem    wclin       09/28/07 - add call to d1100000.sql
Rem    oshiowat    09/15/05 - feature usage tracking 
Rem    gkaminag    09/01/05 - drop packages 
Rem    yucheng     06/24/05 - yucheng_bug-3003812
Rem    yucheng     06/23/05 - Created
Rem

REM ===========================================================
REM revoke select privilege on SYS.GV_$DB_OBJECT_CACHE
REM ===========================================================

revoke select on SYS.GV_$DB_OBJECT_CACHE from CTXSYS;

REM ===========================================================
REM revoke select privilege on sys.snap$ 
REM ===========================================================

revoke select on SYS.SNAP$ from CTXSYS;

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

REM ========================================================================
REM Registry to downgraded state
REM ========================================================================

EXECUTE dbms_registry.downgraded('CONTEXT','10.2.0');

REM ========================================================================
REM reset schema to SYS
REM ========================================================================     
ALTER SESSION SET CURRENT_SCHEMA = SYS;

