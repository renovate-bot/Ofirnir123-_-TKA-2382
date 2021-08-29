Rem
Rem $Header: ctx_src_2/src/dr/admin/s1202000.sql /main/5 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1202000.sql
Rem
Rem Copyright (c) 2014, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1202000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1202000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/s1202000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yinlu       05/09/14 - grant select on sys.opqtype
Rem    boxia       01/06/14 - Grant select on sys.dba_procedures to ctxsys
Rem    boxia       01/06/14 - Created
Rem

@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ========================================================================
REM validate procedure
REM ========================================================================
grant select on SYS.DBA_PROCEDURES to ctxsys;
grant select on SYS.OPQTYPE$ to ctxsys;

@?/rdbms/admin/sqlsessend.sql

