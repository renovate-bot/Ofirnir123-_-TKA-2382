Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe121.sql /main/6 2018/02/28 22:49:17 boxia Exp $
Rem
Rem ctxe121.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxe121.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Downgrade from 12.2 to 12.1.0.1
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe121.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxe121.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: rdbms/admin/cmpdbdwg.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/09/18 - Bug 27495209: add downgrade from 19.1
Rem    snetrava    11/02/16 - Added Downgrade from 12.2.0.2.0
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    boxia       11/05/13 - Downgrade from 12.2 to 12.1.0.1
Rem    ssethuma    06/26/13 - Downgrade to 12.1.0.1
Rem    ssethuma    06/26/13 - Created
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

REM ===========================================================
REM drop all packages, procedures, programmatic types
REM ===========================================================

@@ctxdpkg.sql

REM ===========================================================
REM downgrade from 19.1 to 12.2.0.2 (alias 18.1)
REM ===========================================================

@@d1901000.sql

REM ===========================================================
REM downgrade from 12.2.0.2 to 12.2
REM ===========================================================

@@d1202020.sql

REM ===========================================================
REM downgrade from 12.2 to 12.1.0.2
REM ===========================================================

@@d1202000.sql

REM ===========================================================
REM downgrade from 12.1.0.2 to 12.1.0.1
REM ===========================================================

@@d1201020.sql

REM ===========================================================
REM Registry to downgraded state
REM ===========================================================

EXECUTE dbms_registry.downgraded('CONTEXT','12.1.0.1.0');

REM ===========================================================
REM reset schema to SYS
REM ===========================================================
    
ALTER SESSION SET CURRENT_SCHEMA = SYS;

