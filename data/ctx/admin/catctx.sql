Rem
Rem $Header: ctx_src_2/src/dr/admin/catctx.sql /main/20 2018/08/08 15:49:34 nspancha Exp $
Rem
Rem catctx.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      catctx.sql
Rem
Rem    DESCRIPTION
Rem      runs as SYS
Rem  
Rem      performs an initial load of the complete component for the
Rem      current release.  It calls all of the other scripts that 
Rem      create database objects.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem 
Rem    BEGIN SQL_FILE_METADATA
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/catctx.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/catctx.sql
Rem      SQL_PHASE: CATCTX
Rem      SQL_STARTUP_MODE: NORMAL
Rem      SQL_IGNORABLE_ERRORS: NONE
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    npsnacha    07/11/18 - Bug 27084954: Safe Schema Loading
Rem    rodfuent    05/19/17 - bug 25217590 need dr$lib compile
Rem    calagian    12/17/15 - set echo on for identifying changes easily
Rem                           on drpostseed.log comparison
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    boxia       05/21/13 - Remove hard-coded version load
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    boxia       02/27/13 - Change version to 12.1.0.2.0
Rem    ataracha    08/31/12 - Change version to 12.1.0.1.0
Rem    ssethuma    03/02/12 - Bug 13782544: 12.1.0.0.2
Rem    hsarkar     12/11/11 - Bug 13468942: 12.1.0.0.1
Rem    rpalakod    03/04/11 - version 12.1
Rem    wclin       05/01/10 - version 11.2.0.2
Rem    rpalakod    09/11/09 - bug 8892286
Rem    gkaminag    10/07/04 - val proc to sys
Rem    gkaminag    02/04/03 - ctxx location no longer needed
Rem    ehuang      01/21/03 - use default version number
Rem    ehuang      12/12/02 - add parameters
Rem    ehuang      09/27/02 - remove set statements
Rem    ehuang      07/02/02 - add ctxdef, ctxobj
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/11/02 - Created
Rem

SET ECHO ON

@@?/rdbms/admin/sqlsessstart.sql

Rem pass and dolock are now no-ops, preserving to keep 
define pass          = "&1"
define tbs           = "&2"
define ttbs          = "&3"
define dolock        = "&4"

Rem =======================================================================
Rem CTXSYS.sql - User schema creation
Rem =======================================================================
@@catctx_user.sql &tbs &ttbs

Rem =======================================================================
Rem CTXSYS_SCHEMA.sql - Grant CTXSYS privileges
Rem =======================================================================
@@catctx_schema.sql

@?/rdbms/admin/sqlsessend.sql