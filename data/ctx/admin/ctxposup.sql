Rem
Rem Copyright (c) 2002, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxposup.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script contains common post-upgrade steps.  Developers
Rem      should keep this up-to-date so that it is compatible with
Rem      the latest versions of everything.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxposup.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxposup.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxpatch.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    demukhin    10/13/17 - bug 26561772: create $R constraint during sync
Rem    demukhin    08/18/17 - lrg 20498809: skip CTXCAT when adding $RC
Rem    demukhin    05/25/17 - bug 26051570: keep $R for legacy indexes
Rem    demukhin    03/21/17 - prj 68638: remove $R
rem    rkadwe      02/08/17 - Bug 25511204: Buffer size
Rem    nspancha    02/06/17 - Dropping temp fns for widening token columns
Rem    pkosaraj    01/31/16 - Bug 25386529
Rem    rkadwe      10/06/16 - Change default stoplist for JSON
Rem    pkosaraj    05/04/16 - Bug 22069248: upgscript
Rem    aczarlin    04/25/16 - RTI 19240430 handle lowercase owner,idx name
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      11/21/15 - 22097228: Force 30 character index objects
Rem    surman      10/09/15 - 21814723: Handle errors
Rem    aczarlin    09/29/15 - bug 21795261 add auto_opt
Rem    surman      05/05/15 - 20952246: Check constraints
Rem    surman      04/21/15 - 11067010: Fix view compile
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    aczarlin    09/29/14 - bug 19706070
Rem    aczarlin    02/26/14 - $R fix ltrim, ctxsys, index type 1
Rem    aczarlin    08/26/13 - bug 17231225 primary key in $R
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    rkadwe      09/21/11 - Bug 12960302
Rem    rkadwe      06/16/11 - Bug 12659548
Rem    ssethuma    03/18/11 - section specific attributes
Rem    rkadwe      08/04/10 - Bug 9964288
Rem    rpalakod    01/11/08 - Drop temp procedure setatt
Rem    gkaminag    10/07/04 - inst val proc 
Rem    ehuang      12/16/02 - 
Rem    ehuang      08/02/02 - ehuang_component_upgrade_2
Rem    ehuang      07/30/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql


REM ========================================================================
REM drop dummy operator and index implementation type
REM ========================================================================

drop operator dummyop;
drop package ctx_dummyop;
drop type DummyIndexMethods;

REM ========================================================================
REM drop temporary versions of ctx_ddl routines
REM ========================================================================
drop procedure dr$temp_crepref;
drop procedure dr$temp_cresg;
drop procedure dr$temp_setatt;
drop procedure dr$temp_setsecgrpatt;
drop function dr$temp_get_object_name;
drop function dr$temp_get_object_prefix;
drop function dr$temp_make_pfx;
drop function dr$temp_max_name_length;
drop function dr$temp_GetIndexRec;
drop function dr$temp_IndexHasFullLengthObj;
drop function dr$temp_ChkIndexOption;
drop procedure dr$temp_parse_object_name;
drop function dr$temp_enquote_parts;
drop package temp_utl_pkg;


REM ========================================================================
REM Recompile shared library 

REM ========================================================================

PROMPT STARTING DR0ULIB.SQL
@@dr0ulib.sql

REM ========================================================================
REM Attempt to recompile any invalid views
REM ========================================================================

declare
begin
  for c1 in (select object_name 
             from dba_objects 
             where status = 'INVALID'
               and owner = 'CTXSYS'
               and object_type = 'VIEW')
  loop
    begin
      execute immediate 
        'alter view '||dbms_assert.enquote_name(c1.object_name, FALSE)||
        ' compile';
    exception
       when others then null;
    end;
  end loop;
end;
/

REM ========================================================================
REM Recompile Packages
REM ========================================================================

REM Assumption is that the INDEXTYPE HEADERS are VALID at this point

PROMPT STARTING CTXPKH.SQL
@@ctxpkh.sql

PROMPT STARTING CTXPLB.SQL
@@ctxplb.sql

REM ========================================================================
REM Recompile Type Bodies
REM ========================================================================

@@ctxtyb.sql

REM ========================================================================
REM populate database object manifest
REM ========================================================================

@@ctxdbo.sql

REM ========================================================================
REM Attempt to recompile any leftover errant objects
REM ========================================================================

declare
  cbody varchar2(10);
  otype varchar2(30);
begin
  for c1 in (select object_type, object_name 
             from dba_objects 
             where status = 'INVALID'
               and owner = 'CTXSYS'
             order by object_type) 
  loop
    otype := c1.object_type;
    cbody := null;

    if (c1.object_type = 'PACKAGE BODY') then
      otype := 'PACKAGE';
      cbody := 'BODY';
    elsif (c1.object_type = 'TYPE BODY') then
      otype := 'TYPE';
      cbody := 'BODY';
    elsif (c1.object_type = 'VIEW') then
      -- 11067010: No 'BODY' for view compile
      cbody := '';
    end if;
    
    begin
      execute immediate 
        'alter '||otype||' '||dbms_assert.enquote_name(c1.object_name, FALSE)
        ||' compile '||cbody;
    exception
       when others then null;
    end;
  end loop;
end;
/

REM this is not a mistake -- we want to run this twice due to possible
REM cyclical dependencies

/

REM ========================================================================
REM Install latest version of validation procedure
REM ========================================================================
@@ctxval.sql


REM ========================================================================
REM Insert individual section attributes to dr$index_value table
REM ========================================================================
begin
  for c1 in (select ixv_idx_id, ixv_value, ixv_oat_id, oat_name, driv.rowid
               from dr$index_value driv, dr$object_attribute
              where ixv_oat_id = oat_id
                and oat_cla_id = DRIOBJ.CLASS_SECTION_GROUP
                and ixv_value like '%:%:%') loop
    drisgp.csv_to_section_attr(c1.ixv_idx_id, c1.oat_name, c1.ixv_value);
    delete from dr$index_value where rowid = c1.rowid;
  end loop;
commit;
end;
/

REM ========================================================================
REM special case; default policy AUTO_OPT_OBJ
REM ========================================================================

PROMPT creating default policy for auto_opt_obj

declare
  l_owner#  number;
  l_errnum  number;
  l_count   number;

begin

  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select count(*) into l_count from dr$index where
    idx_name = 'AUTO_OPT_OBJ' and
    idx_owner# = l_owner#;

  /* if this object does not exist yet, create it. */
  if (0 = l_count) then
    CTX_DDL.create_policy('CTXSYS.AUTO_OPT_OBJ',
      filter        => 'CTXSYS.NULL_FILTER',
      section_group => 'CTXSYS.NULL_SECTION_GROUP',
      lexer         => 'CTXSYS.BASIC_LEXER',
      stoplist      => 'CTXSYS.EMPTY_STOPLIST',
      wordlist      => 'CTXSYS.BASIC_WORDLIST'
  );
  end if;

exception
  when others then
    l_errnum := SQLCODE;
    if (l_errnum = -20000) then
      null;
    else
      raise;
    end if;
end;
/

REM ========================================================================
REM special case; default policy STOP_OPT_LIST
REM ========================================================================

PROMPT creating default policy for STOP_OPT_LIST

declare
  l_owner#  number;
  l_errnum  number;
  l_count   number;
begin

  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select count(*) into l_count from dr$index where
    idx_name = 'STOP_OPT_LIST' and
    idx_owner# = l_owner#;

  /* if this object does not exist yet, create it. */
  if (0 = l_count) then
    CTX_DDL.create_policy('CTXSYS.STOP_OPT_LIST',
      filter        => 'CTXSYS.NULL_FILTER',
      section_group => 'CTXSYS.NULL_SECTION_GROUP',
      lexer         => 'CTXSYS.BASIC_LEXER',
      stoplist      => 'CTXSYS.EMPTY_STOPLIST',
      wordlist      => 'CTXSYS.BASIC_WORDLIST'
  );
  end if;

exception
  when others then
    l_errnum := SQLCODE;
    if (l_errnum = -20000) then
      null;
    else
      raise;
    end if;
end;
/

REM ========================================================================
REM special case; default policy ENT_EXT_DICT_OBJ
REM ========================================================================


declare
  l_owner#  number;
  l_errnum  number;
  l_count   number;

begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_count from dr$index where
    idx_name = 'ENT_EXT_DICT_OBJ' and
    idx_owner# = l_owner#;

  /* if this object does not exist yet, create it. */
  if (0 = l_count) then
    CTX_DDL.create_policy('CTXSYS.ENT_EXT_DICT_OBJ',
      filter        => 'CTXSYS.NULL_FILTER',
      section_group => 'CTXSYS.NULL_SECTION_GROUP',
      lexer         => 'CTXSYS.BASIC_LEXER',
      stoplist      => 'CTXSYS.EMPTY_STOPLIST',
      wordlist      => 'CTXSYS.BASIC_WORDLIST'
  );
  end if;
exception
  when others then
    l_errnum := SQLCODE;
    if (l_errnum = -20000) then
      null;
    else
      raise;
    end if;
end;
/
show err

REM END OF CTXPOSUP

@?/rdbms/admin/sqlsessend.sql
