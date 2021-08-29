Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe181.sql /main/2 2018/07/10 06:55:19 bspeckha Exp $
Rem
Rem ctxe181.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      ctxe181.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Downgrade from latest version to 18.0.0.0.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe181.sql
Rem    SQL_SHIPPED_FILE:ctx_src_2/src/dr/admin/ctxe181.sql
Rem    SQL_PHASE: DOWNGRADE
Rem    SQL_STARTUP_MODE: DOWNGRADE
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bspeckha    05/07/18 - Bug 27964123 Fix REM
Rem    boxia       04/06/18 - Bug 27797333: Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

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
REM downgrade from 19.1 to 18.1
REM ===========================================================

@@d1901000.sql

REM ===========================================================
REM Registry to downgraded state
REM ===========================================================

EXECUTE dbms_registry.downgraded('CONTEXT','18.0.0.0.0');

REM ===========================================================
REM reset schema to SYS
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = SYS

@?/rdbms/admin/sqlsessend.sql
 
