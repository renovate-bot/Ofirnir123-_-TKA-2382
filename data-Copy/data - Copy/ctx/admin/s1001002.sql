Rem
Rem $Header: ctx_src_2/src/dr/admin/s1001002.sql /main/6 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1001002.sql
Rem
Rem Copyright (c) 2004, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1001002.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      SYS changes for CTXSYS upgrade 10.1 to 10.2
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1001002.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/s1001002.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gkaminag    08/03/04 - deprecate connect 
Rem    gkaminag    03/22/04 - gkaminag_misc_040318 
Rem    gkaminag    03/18/04 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

REM
REM  IF YOU ADD ANYTHING TO THIS FILE REMEMBER TO CHANGE CTXE* SCRIPT
REM

REM connect deprecated

revoke CONNECT from CTXSYS;
grant create session, alter session, create view, create synonym to CTXSYS;


@?/rdbms/admin/sqlsessend.sql
