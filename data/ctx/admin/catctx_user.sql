Rem
Rem $Header: ctx_src_2/src/dr/admin/catctx_user.sql /st_rdbms_19/1 2018/08/29 16:13:58 nspancha Exp $
Rem
Rem catctx_user.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      catctx_user.sql - CTXSYS user installation call.
Rem
Rem    DESCRIPTION
Rem      runs as SYS
Rem      Calls CTXSYS user creation script, but not privileges script
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/catctx_user.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/catctx_user.sql
Rem    SQL_PHASE: CATCTX_USER
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/16/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    npsnacha    07/11/18 - Bug 27084954: Safe Schema Loading
Rem    nspancha    07/11/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

define tbs           = "&1"
define ttbs          = "&2"

Rem =======================================================================
Rem CTXSYS_USER.sql - user schema creation
Rem =======================================================================
@@ctxsys_user.sql &tbs &ttbs

@?/rdbms/admin/sqlsessend.sql
