Rem
Rem $Header: ctx_src_2/src/dr/admin/catctx_schema.sql /st_rdbms_19/2 2018/09/04 08:05:40 snetrava Exp $
Rem
Rem catctx_schema.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      catctx_schema.sql - Second half of CTX installation
Rem
Rem    DESCRIPTION
Rem      runs as SYS
Rem      Grants CTX privileges and creates packages
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/catctx_schema.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/catctx_schema.sql
Rem    SQL_PHASE: CATCTX_SCHEMA
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    snetrava    09/01/18 - XbranchMerge snetrava_bug-28496939 from main
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/16/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    snetrava    08/24/18 - Bug 28496939: Remove call to utlrp.sql
Rem    npsnacha    07/11/18 - Bug 27084954: Safe Schema Loading
Rem    nspancha    07/11/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

Rem =======================================================================
Rem CTXSYS_SCHEMA.sql - Grant CTXSYS privileges
Rem =======================================================================
@@ctxsys_schema.sql

Rem =======================================================================
Rem script is ALWAYS run as SYS,  must set current_schema to CTXSYS before
Rem loading context
Rem =======================================================================
ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

Rem =======================================================================
Rem signal beginning of loading
Rem =======================================================================
begin
dbms_registry.loading('CONTEXT','Oracle Text', 'validate_context', 'CTXSYS');
end;
/

REM ========================================================================
REM CTX does not currently support char semantics, so this forces
REM creation to use byte semantics
REM ========================================================================

alter session set nls_length_semantics=byte;

Rem =======================================================================
Rem CTXTAB.sql - create tables, populates static tables
Rem =======================================================================
@@ctxtab.sql

Rem =======================================================================
Rem CTXVIEW.sql - create or replace public views, with grants and public 
Rem synonyms; include any fixed views
Rem =======================================================================
@@ctxview.sql

Rem =======================================================================
Rem create safe callout library
Rem =======================================================================
@@dr0lib.sql

Rem =======================================================================
Rem CTXTYP.sql - creates types specifications
Rem =======================================================================
@@ctxtyp.sql

Rem =======================================================================
Rem CTXPKH.sql - create or replace public pl/sql package specifications, 
Rem              functions, and procedures, with grants and synonyms
Rem =======================================================================
@@ctxpkh.sql

Rem =======================================================================
Rem CTXPLB.sql - create or replace public and private PL/SQL package bodies
Rem =======================================================================
@@ctxplb.sql

Rem =======================================================================
Rem CTXTYB.sql - create or replace public and private type bodies
Rem =======================================================================
@@ctxtyb.sql

Rem =======================================================================
Rem CTXITYP.sql - create or replace index type
Rem =======================================================================
@@ctxityp.sql

Rem =======================================================================
Rem CTXOBJ.sql - ctx object creation
Rem =======================================================================
@@ctxobj.sql

Rem =======================================================================
Rem CTXDEF.sql - ctx default object creation
Rem =======================================================================
@@ctxdef.sql

Rem =======================================================================
Rem CTXDBO.sql - ctx database object manifest
Rem =======================================================================
@@ctxdbo.sql

Rem =======================================================================
Rem CTXVAL.sql - install validation procedure
Rem =======================================================================
@@ctxval.sql

Rem =======================================================================
Rem Bug 25217590 DML by-pass needs extra recompile
Rem =======================================================================

ALTER library ctxsys.dr$lib compile;
ALTER type ctxsys.CATINDEXMETHODS compile;
ALTER type ctxsys.TEXTINDEXMETHODS compile;
ALTER type ctxsys.TEXTOPTSTATS compile;
ALTER type ctxsys.XPATHINDEXMETHODS compile;

Rem =======================================================================
Rem signal end of loading
Rem =======================================================================
execute dbms_registry.loaded('CONTEXT');
execute sys.validate_context;

REM =======================================================================
REM must reset current_schema to SYS
REM =======================================================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;

@?/rdbms/admin/sqlsessend.sql
