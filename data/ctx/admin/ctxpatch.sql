Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxpatch.sql /main/20 2018/07/25 13:49:10 surman Exp $
Rem
Rem ctxpatch.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxpatch.sql 
Rem
Rem    DESCRIPTION
Rem      this patch script is used to apply bug fixes. It is run in
Rem      the context of catpatch.sql, after the RDBMS catalog.sql
Rem      and catproc.sql is run with a special EVEN set which causes
Rem      CREATE OR REPLACE statements to only recompile objects if
Rem      the new source is different from the source stored in the 
Rem      database.  Tables, types and public interfaces should not
Rem      be changed by the patch scripts.
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxpatch.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxpatch.sql
Rem      SQL_PHASE: UTILITY
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UTILITY
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    boxia       05/22/14 - Bug 18685991: Back out the previous change
Rem    boxia       04/12/14 - Remove all content but add call to ctxdbmig.sql
Rem                           Will restore it back after version change solved
Rem    boxia       04/01/14 - Bug 18499551: upgrade to 12.2
Rem    gauryada    03/14/14 - Add s1202000.sql
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    ssethuma    01/14/13 - Bug 15986393
Rem    yiqi        06/08/12 - Bug 13606137
Rem    rpalakod    06/07/08 - 11.2
Rem    gkaminag    10/10/05 - upgrade problems 
Rem    gkaminag    02/28/05 - typo
Rem    gkaminag    02/17/05 - 
Rem    gkaminag    10/07/04 - val proc to sys 
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
dbms_registry.loading('CONTEXT','Oracle Text', 'validate_context', 'CTXSYS');
end;
/

REM ========================================================================
REM
REM ******************* Begin SYS changes **********************************
REM
REM ========================================================================

ALTER SESSION SET CURRENT_SCHEMA = SYS;

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

REM ========================================================================
REM
REM ******************* End SYS changes ************************************
REM
REM ========================================================================

REM ========================================================================
REM
REM ******************* Begin CTXSYS schema changes ************************
REM
REM ========================================================================

REM ========================================================================
REM Pre-upgrade steps
REM ========================================================================

@@ctxpreup.sql

Rem do any needed upgrades, then recompile packages, etc.


REM ========================================================================
REM Post-upgrade steps
REM ========================================================================

@@ctxposup.sql

REM ========================================================================
REM
REM ****************  End CTXSYS schema change *****************************
REM
REM ========================================================================

EXECUTE dbms_registry.loaded('CONTEXT');

EXECUTE sys.validate_context;

ALTER SESSION SET CURRENT_SCHEMA = SYS;


@?/rdbms/admin/sqlsessend.sql

