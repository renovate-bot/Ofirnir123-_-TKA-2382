Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxdwchk.sql /main/3 2018/07/25 13:49:10 surman Exp $
Rem
Rem ctxdwchk.sql
Rem
Rem Copyright (c) 2014, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxdwchk.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxdwchk.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxdwchk.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: CATDWGRD
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/05/18 - 27464252: Update SQL_PHASE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      11/06/14 - 19976518: Creation
Rem    surman      11/06/14 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

REM This script is called during RDBMS downgrade to verify that the Text 
REM installation is OK to downgrade.  
REM If there are any Text indexes which use 12.2 specific features then
REM we need to raise an error here so the user can resolve them before
REM attempting the downgrade again.


@?/rdbms/admin/sqlsessend.sql
