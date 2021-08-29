Rem
Rem $Header: ctx_src_2/src/dr/admin/d1201010.sql /main/4 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1201010.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1201010.sql - Downgrade to 12.1.0.1.0
Rem
Rem    DESCRIPTION
Rem      Downgrade ctx from 12.1.0.2.0 to 12.1.0.1.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1201010.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1201010.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    ssethuma    06/26/13 - Downgrade to 12.1.0.1.0
Rem    ssethuma    06/26/13 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

