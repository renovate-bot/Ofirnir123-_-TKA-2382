Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxe191.sql /main/1 2018/02/28 22:49:17 boxia Exp $
Rem
Rem ctxe191.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      ctxe191.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      Downgrade from latest version to 19.1.0.0.0
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxe191.sql
Rem    SQL_SHIPPED_FILE:ctx/admin/ctxe191.sql
Rem    SQL_PHASE: DOWNGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/08/18 - Created
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

EM ===========================================================
REM downgrade from 
REM ===========================================================


REM ===========================================================
REM Registry to downgraded state
REM ===========================================================

EXECUTE dbms_registry.downgraded('CONTEXT','19.1.0.0.0');

REM ===========================================================
REM reset schema to SYS
REM ===========================================================

ALTER SESSION SET CURRENT_SCHEMA = SYS;

@?/rdbms/admin/sqlsessend.sql
 
