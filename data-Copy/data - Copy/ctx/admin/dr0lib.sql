Rem
Rem $Header: ctx_src_2/src/dr/admin/dr0lib.sql /main/8 2017/02/06 21:05:04 stanaya Exp $
Rem
Rem dr0lib.sql
Rem
Rem Copyright (c) 1999, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0lib.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/dr0lib.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/dr0lib.sql
Rem      SQL_PHASE: DR0LIB
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gkaminag    02/04/03 - remove ctxx 
Rem    ehuang      07/31/02 - add trusted library
Rem    ehuang      07/11/02 - add PROMPT
Rem    gkaminag    03/12/99 - work around SQL*Plus bug
Rem    dyu         02/02/99 - create library for ctxx
Rem    dyu         02/02/99 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

PROMPT ... creating trusted callout library
create or replace library dr$lib trusted as static;
/





@?/rdbms/admin/sqlsessend.sql
