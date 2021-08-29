Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxrelod.sql /main/11 2018/07/25 13:49:10 surman Exp $
Rem
Rem ctxrelod.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxrelod.sql
Rem
Rem    DESCRIPTION
Rem      reload views, packages and JAVA classes after a downgrade.
Rem      The dictionary objects are reset to the old release by the
Rem      ctxe***.sql script, this reload script processes the "old"
Rem      scripts to reload the "old" version using the "old" server.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxrelod.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxrelod.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/05/18 - 27464252: Update SQL_PHASE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    surman      01/06/09 - 7690709: run ctxview first
Rem    gkaminag    10/07/04 - val proc to sys 
Rem    gkaminag    01/07/03 - recompile views
Rem    ehuang      12/16/02 - 
Rem    gkaminag    11/26/02 - add call to check_server_instance
Rem    ehuang      07/09/02 - 
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/11/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

Rem ensure that we are in an expected state

WHENEVER SQLERROR EXIT;
EXECUTE dbms_registry.check_server_instance;
WHENEVER SQLERROR CONTINUE;

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

begin
dbms_registry.loading('CONTEXT','Oracle Text', 'validate_context','CTXSYS');
end;
/

@@ctxview.sql
@@ctxpkh.sql
@@ctxplb.sql
@@ctxtyb.sql
@@ctxdbo.sql
@@ctxval.sql

EXECUTE dbms_registry.loaded('CONTEXT');

EXECUTE sys.validate_context;

ALTER SESSION SET CURRENT_SCHEMA = SYS;


@?/rdbms/admin/sqlsessend.sql
