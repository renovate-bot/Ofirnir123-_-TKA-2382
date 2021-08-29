Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe120.sql /main/5 2018/02/28 22:49:17 boxia Exp $
Rem
Rem ctxe120.sql
Rem
Rem Copyright (c) 2011, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe120.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 12.1 to 11.2.0.2
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe120.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe120.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/09/18 - Bug 27495209: add downgrade from 19.1
Rem    snetrava    11/02/16 - Added Downgrade from 12.2.0.2.0
Rem    nspancha    08/01/16 - Bug 23501267: Adding call to 12.2 dwngrade script
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rpalakod    02/08/11 - downgrade from 12.1
Rem    rpalakod    02/08/11 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ===========================================================
REM set schema, registry
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

EXECUTE dbms_registry.downgrading('CONTEXT');

REM drop all packages, procedures, programmatic types
@@ctxdpkg.sql

@@d1901000
@@d1202020
@@d1202000
@@d1200000

REM ========================================================================
REM Registry to downgraded state
REM ========================================================================

EXECUTE dbms_registry.downgraded('CONTEXT','11.2.0.2.0');

REM ========================================================================
REM reset schema to SYS
REM ========================================================================     
ALTER SESSION SET CURRENT_SCHEMA = SYS;


