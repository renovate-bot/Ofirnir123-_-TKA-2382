Rem
Rem s0900010.sql
Rem
Rem Copyright (c) 2000, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s0900010.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem     This script upgrades an 9.0.1.X schema to 9.2.0.1.
Rem     This script should be run as SYS on an 9.0.1 ctxsys schema
Rem     No other users or schema versions are supported.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s0900010.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/s0900010.sql
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
Rem    gkaminag    04/19/01 - name change to 9.0.1
Rem    wclin       03/09/01 - put in real fix for bug 1629476
Rem    wclin       02/26/01 - bug 1629476 work around
Rem    gkaminag    12/21/00 - Creation
Rem

grant select on SYS.TS$ to ctxsys with grant option;
grant select on SYS.TABPART$ to ctxsys with grant option;
grant select on SYS.IND$ to ctxsys with grant option;
grant select on SYS.INDPART$ to ctxsys with grant option;
grant select on SYS.DBA_TYPES to ctxsys with grant option;
grant execute on dbms_registry to ctxsys with grant option;

