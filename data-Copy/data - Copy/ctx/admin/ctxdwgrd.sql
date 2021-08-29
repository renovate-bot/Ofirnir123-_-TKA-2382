Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxdwgrd.sql /main/3 2018/04/17 19:17:48 boxia Exp $
Rem
Rem ctxdwgrd.sql
Rem
Rem Copyright (c) 2016, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxdwgrd.sql - Downgrade script of CTX CONTEXT
Rem
Rem    DESCRIPTION
Rem      This script performs downgrade of CTX CONTEXT from the current
Rem      release.
Rem
Rem    NOTES
Rem      It is invoked by cmpdwgrd.sql.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxdwgrd.sql
Rem    SQL_SHIPPED_FILE: ctx_src_2/src/dr/admin/ctxdwgrd.sql
Rem    SQL_PHASE: DOWNGRADE
Rem    SQL_STARTUP_MODE: UPGRADE
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE: rdbms/admin/cmpdwgrd.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       04/06/18 - Bug 27797333: add downgrade 18.1
Rem    boxia       02/09/18 - Bug 27495209: add downgrade 19.1
Rem    boxia       12/27/16 - Bug 25035428: init CTX downgrade script
Rem    boxia       12/27/16 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

Rem =======================================
Rem ensure that we are in an expected state
Rem =======================================
WHENEVER SQLERROR EXIT
EXECUTE sys.dbms_registry.check_server_instance;
WHENEVER SQLERROR CONTINUE;

EXECUTE sys.dbms_registry.downgrading('CONTEXT');

Rem ===========================================
Rem set current schema
Rem ===========================================
ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

Rem ===========================================
Rem Setup component script filename variable
Rem ===========================================
COLUMN :script_name NEW_VALUE comp_file NOPRINT
VARIABLE script_name VARCHAR2(50)

Rem ==================================================================
Rem Select downgrade script to run based on previous component version
Rem ==================================================================
DECLARE
  prev_version varchar2(100);
BEGIN
  prev_version := substr(sys.dbms_registry.prev_version('CONTEXT'),1,6);

  IF (prev_version = '19.1.0') THEN
    :script_name := '@ctxe191.sql';
  ELSIF (prev_version = '18.0.0') THEN
    :script_name := '@ctxe181.sql';
  ELSIF (prev_version = '12.2.0') THEN
    :script_name := '@ctxe122.sql';
  ELSIF (prev_version = '12.1.0') THEN
    :script_name := '@ctxe121.sql';
  ELSIF (prev_version = '12.0.0') THEN
    :script_name := '@ctxe120.sql';
  ELSIF (prev_version = '11.2.0') THEN
    :script_name := '@ctxe112.sql';
  ELSE
    :script_name := sys.dbms_registry.nothing_script;
  END IF;
END;
/

SELECT :script_name FROM SYS.DUAL;
@&comp_file

Rem ===========================================
Rem set current schema
Rem ===========================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;

@?/rdbms/admin/sqlsessend.sql
 
