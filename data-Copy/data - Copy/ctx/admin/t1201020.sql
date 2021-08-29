Rem
Rem $Header: ctx_src_2/src/dr/admin/t1201020.sql /main/5 2018/07/25 13:49:09 surman Exp $
Rem
Rem t1201020.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      t1201020.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade indextypes to 12.1.0.2.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/t1201020.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/t1201020.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu920.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    ssethuma    01/17/13 - Type upgrade 12.1.0.2
Rem    ssethuma    01/17/13 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


@?/rdbms/admin/sqlsessend.sql
