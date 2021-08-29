Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxu817.sql /main/29 2018/07/25 13:49:08 surman Exp $
Rem
Rem ctxu817.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxu817.sql 
Rem
Rem    DESCRIPTION
Rem      component upgrade from 8.1.7 to 9.0.1
Rem
Rem    NOTES
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxu817.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxu817.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    boxia       11/29/16 - Bug 25172618: add s1202020
Rem    snetrava    11/02/16 - Added Upgrade to 12.2.0.2.0
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    boxia       04/01/14 - Bug 18499551: update version automatically
Rem    boxia       01/06/14 - Bug 18037959: change s1201020 to s1202000
Rem    boxia       01/02/14 - Bug 16989137: add s1201020.sql
Rem    boxia       09/11/13 - add u1202000.sql
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    boxia       03/05/13 - Bug 16404191: Upgrade to 12.1.0.2.0
Rem    ssethuma    01/17/13 - Bug 15986393: Upgrade to 12.1.0.2
Rem    ataracha    08/31/12 - change version to 12.1.0.1.0
Rem    yiqi        06/06/12 - Bug 13606137
Rem    ssethuma    03/02/12 - Bug 13782544: 12.1.0.0.2
Rem    hsarkar     12/12/11 - Bug 13468942: 12.1.0.0.1
Rem    rpalakod    02/08/11 - upgrade to 12
Rem    wclin       05/01/10 - version 11.2.0.2
Rem    rpalakod    09/11/09 - Bug 8892286
Rem    rpalakod    06/07/08 - 11.2
Rem    yucheng     06/22/05 - load 10.2 upgrade scripts 
Rem    gkaminag    10/07/04 - val proc to sys 
Rem    gkaminag    03/18/04 - version 
Rem    ehuang      01/21/03 - use default version number
Rem    ehuang      01/24/03 - 
Rem    ehuang      12/12/02 - add parameters
Rem    ehuang      07/29/02 - component upgrade
Rem    ehuang      07/02/02 - move from s/u0900010.sql
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/12/02 - Created

@@?/rdbms/admin/sqlsessstart.sql

Rem  =======================================================================
Rem  
Rem  ******************** changes to be made by SYS ************************
Rem
Rem  =======================================================================

@@s0801070.sql
@@s0900010.sql
@@s0902000.sql
@@s1001002.sql
@@s1002000.sql
@@s1100000.sql
@@s1102000.sql
@@s1200010.sql
@@s1202000.sql
@@s1202020.sql

Rem  =======================================================================
Rem  
Rem  ***********************   end of SYS changes  *************************
Rem
Rem  =======================================================================

REM ========================================================================
REM set schema, Registry to upgrading state
REM ========================================================================

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

begin
dbms_registry.upgrading('CONTEXT','Oracle Text','validate_context','CTXSYS');
end;
/
                                

REM ========================================================================
REM 
REM ******************* Begin CTXSYS schema changes ************************
REM
REM ========================================================================

REM ========================================================================
REM Pre-upgrade steps
REM ========================================================================

@@ctxpreup.sql

REM ========================================================================
REM 8.1.7 to 9.0.1
REM ========================================================================

@@u0801070.sql
@@t0801070.sql

REM ========================================================================
REM 9.0.1 to 9.2.0
REM ========================================================================

@@u0900010.sql
@@t0900010.sql

REM ========================================================================
REM 9.2.0 to 10.1.0
REM ========================================================================

@@u0902000.sql
@@t0902000.sql

REM ========================================================================
REM 10.1 to 10.2
REM ========================================================================

@@u1001002.sql
@@t1001002.sql

REM ========================================================================
REM 10.2 to 11.1.0
REM ========================================================================

@@u1002000.sql
@@t1002000.sql

REM ========================================================================
REM 11.1.0 to 11.2.0
REM ========================================================================

@@u1100000.sql
@@t1100000.sql

REM ========================================================================
REM 11.2.0.2 to 12.1
REM ========================================================================

@@u1200000.sql
@@t1200000.sql

REM ========================================================================
REM 12.1 to 12.1.0.2
REM ========================================================================

@@u1201020.sql
@@t1201020.sql

REM ========================================================================
REM 12.1.0.2 to 12.2
REM ========================================================================

@@u1202000.sql
@@t1202000.sql

REM ========================================================================
REM 12.2 to 12.2.0.2
REM ========================================================================

@@u1202020.sql
@@t1202020.sql

REM ========================================================================
REM Post-upgrade steps
REM ========================================================================

@@ctxposup.sql

REM ========================================================================
REM special case; default policy oracontains
REM ========================================================================

PROMPT creating default policy for ora:contains
begin
  CTX_DDL.create_policy('CTXSYS.DEFAULT_POLICY_ORACONTAINS',
    filter        => 'CTXSYS.NULL_FILTER',
    section_group => 'CTXSYS.NULL_SECTION_GROUP',
    lexer         => 'CTXSYS.DEFAULT_LEXER',
    stoplist      => 'CTXSYS.DEFAULT_STOPLIST',
    wordlist      => 'CTXSYS.DEFAULT_WORDLIST'
);
end;
/

REM ========================================================================
REM
REM ****************  End CTXSYS schema change *****************************
REM
REM ========================================================================

REM ========================================================================
REM Registry to upgraded state, reset schema
REM ========================================================================

begin
  dbms_registry.loaded('CONTEXT');
  dbms_registry.valid('CONTEXT');
end;
/

ALTER SESSION SET CURRENT_SCHEMA = SYS;

@?/rdbms/admin/sqlsessend.sql
