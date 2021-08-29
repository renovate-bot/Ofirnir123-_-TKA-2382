Rem
Rem $Header: ctx_src_2/src/dr/admin/dr0ulib.sql /main/7 2018/07/25 13:49:10 surman Exp $
Rem
Rem dr0ulib.sql
Rem
Rem Copyright (c) 2001, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0ulib.sql - upgrade shared library
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/dr0ulib.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/dr0ulib.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/posup.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gkaminag    02/04/03 - remove ctxx
Rem    ehuang      07/31/02 - add trusted library
Rem    gkaminag    03/27/01 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql


PROMPT ... creating trusted callout library
create or replace library dr$lib trusted as static;
/

@?/rdbms/admin/sqlsessend.sql
