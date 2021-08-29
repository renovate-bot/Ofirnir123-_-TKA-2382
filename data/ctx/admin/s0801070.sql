Rem
Rem $Header: ctx_src_2/src/dr/admin/s0801070.sql /main/7 2018/07/25 13:49:08 surman Exp $
Rem
Rem s0801070.sql
Rem
Rem Copyright (c) 2000, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s0801070.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem     This script upgrades an 8.1.7.X schema to 9.0.1.0.
Rem     This script should be run as SYS on an 8.1.7 database
Rem     No other users or schema versions are supported.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s0801070.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/s0801070.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    gkaminag    03/18/04 - 
Rem    ehuang      10/10/02 - call current directory
Rem    ehuang      07/30/02 - upgrade script restructuring
Rem    ehuang      04/05/00 - grant dba_roles to ctxsys
Rem    wclin       01/27/00 - fix bug 1134309
Rem    wclin       01/27/00 - Created
Rem

grant execute on dbms_pipe to ctxsys;
grant execute on dbms_lock to ctxsys;

REM now we are at 9.0.1 -- call 9.0.1 upgrade
@@s0900010.sql
