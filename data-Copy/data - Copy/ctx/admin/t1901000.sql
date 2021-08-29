Rem
Rem $Header: ctx_src_2/src/dr/admin/t1901000.sql /main/1 2018/02/28 22:49:16 boxia Exp $
Rem
Rem t1901000.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      t1901000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade from 18.1(12.2.0.2.0) to 19.1
Rem
Rem    NOTES
Rem      Indextype upgrade.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/t1901000.sql
Rem    SQL_SHIPPED_FILE:ctx/admin/t1901000.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       02/08/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

@?/rdbms/admin/sqlsessend.sql
 
