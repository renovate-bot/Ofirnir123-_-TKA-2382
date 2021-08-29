Rem
Rem $Header: ctx_src_2/src/dr/admin/s1002000.sql /main/7 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1002000.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1002000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem     This script upgrades an 10.2.0.X schema to latest version
Rem     This script should be run as SYS on an 10.2.0 ctxsys schema
Rem     No other users or schema versions are supported.
Rem
Rem    NOTES
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1002000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/s1002000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    oshiowat    08/10/05 - feature usage tracking 
Rem    yucheng     06/22/05 - fix bug 3003812 
Rem    gkaminag    02/21/05 - gkaminag_test_050217
Rem    gkaminag    02/17/05 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

grant select on SYS.snap$ to ctxsys with grant option;
grant select on SYS.GV_$DB_OBJECT_CACHE to ctxsys;



@?/rdbms/admin/sqlsessend.sql
