Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxdbmig.sql /main/33 2018/04/17 19:17:48 boxia Exp $
Rem
Rem ctxdbmig.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxdbmig.sql
Rem
Rem    DESCRIPTION
Rem      runs as SYS
Rem
Rem      performs the upgrade of context from all prior releases
Rem      supported for upgrade (806, 817, 901 and 920 for 10i).
Rem      It first runs a 'u' script to upgrade the tables and types
Rem      and then load in the new package specifications, views and 
Rem      package and type bodies..etc.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem 
Rem    BEGIN SQL_FILE_METADATA
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxdbmig.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxdbmig.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL
Rem      SQL_IGNORABLE_ERRORS: NONE
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       04/06/18 - Bug 27797333: add 18.1
Rem    boxia       02/09/18 - Bug 27495209: add ctxu1901.sql
Rem    boxia       12/22/16 - Lrg 20003643: add ctxu1202.sql
Rem    nspancha    06/30/16 - Bug 23501267: Security Bug
Rem    boxia       02/03/16 - Bug 22650033: add count_errors_in_registry
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yinlu       05/09/14 - grant select on sys.opqtype
Rem    boxia       01/02/14 - Bug 16989137: grant select on sys.dba_procedures
Rem    boxia       11/05/13 - Bug 17635127: add ctxu1201.sql
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    dalpern     02/15/12 - proj 32719: INHERIT PRIVILEGES privilege
Rem    rpalakod    11/10/11 - add grants on dba_indexes, dba_triggers
Rem    hsarkar     08/19/11 - Bug 12867992: grant inherit any privileges to
Rem                           CTXSYS
Rem    jmadduku    03/14/11 - Proj32507: Grant Unlimited Tablespace explicitly
Rem                           with RESOURCE role
Rem    rpalakod    02/08/11 - upgrade to 12.1
Rem    rpalakod    02/08/10 - Bug 9310235
Rem    rpalakod    08/03/09 - autooptimize
Rem    rpalakod    01/15/09 - bug 6791488
Rem    rpalakod    06/07/08 - 11.2
Rem    gkaminag    10/16/05 - 
Rem    surman      08/23/05 - 4472797: Call ctxpatch 
Rem    gkaminag    10/07/04 - val proc to sys 
Rem    gkaminag    03/18/04 - version 
Rem    gkaminag    02/13/03 - avoid calling upgraded if nothing has been done
Rem    mfaisal     01/15/03 - restore schema
Rem    ehuang      12/12/02 - add parameters
Rem    gkaminag    11/26/02 - add call to check_server_instance
Rem    ehuang      11/11/02 - 
Rem    ehuang      09/23/02 - add missing quote
Rem    ehuang      07/09/02 - 
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/11/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

Rem ensure that we are in an expected state

WHENEVER SQLERROR EXIT;
EXECUTE dbms_registry.check_server_instance;
WHENEVER SQLERROR CONTINUE;

Rem ===========================================
Rem Make sure we are in SYS schema
Rem ===========================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;

Rem ===========================================
Rem Make sure ctxsys has all required 
Rem   privileges.  Taken from ctxsys.sql
Rem ===========================================
grant select on sys.v_$session to ctxsys with grant option;

grant create public synonym to ctxsys;
grant drop public synonym to ctxsys;

grant select on SYS.GV_$DB_OBJECT_CACHE to ctxsys;
grant select on SYS.ARGUMENT$ to ctxsys with grant option;
grant select on SYS.DBA_COLL_TYPES to ctxsys;
grant select on SYS.DBA_CONSTRAINTS to ctxsys;
grant select on SYS.DBA_CONS_COLUMNS to ctxsys with grant option;
grant select on SYS.DBA_DB_LINKS to ctxsys with grant option;
grant select on SYS.DBA_INDEXTYPES to ctxsys with grant option;
grant select on SYS.DBA_JOBS to ctxsys;
grant select on SYS.DBA_JOBS_RUNNING to ctxsys;
grant select on SYS.DBA_OBJECTS to ctxsys with grant option;
grant select on SYS.DBA_OBJECTS to ctxsys;
grant select on SYS.DBA_PROCEDURES to ctxsys;
grant select on SYS.DBA_ROLES to ctxsys with grant option;
grant select on SYS.DBA_ROLE_PRIVS to ctxsys with grant option;
grant select on SYS.DBA_SYNONYMS to ctxsys with grant option;
grant select on SYS.DBA_SYS_PRIVS to ctxsys;
grant select on SYS.DBA_TABLES to ctxsys;
grant select on SYS.DBA_TAB_COLUMNS to ctxsys;
grant select on SYS.DBA_TAB_COLS to ctxsys;
grant select on SYS.DBA_TAB_PARTITIONS to ctxsys;
grant select on SYS.DBA_TAB_PRIVS to ctxsys with grant option;
grant select on SYS.DBA_TYPE_ATTRS to ctxsys with grant option;
grant select on SYS.DBA_INDEXES to ctxsys;
grant select on SYS.DBA_TRIGGERS to ctxsys;
grant select on SYS.DBA_PART_KEY_COLUMNS to ctxsys;
grant select on SYS.DBA_SEGMENTS to ctxsys;
grant select on SYS.DBA_USERS to ctxsys;
grant select on SYS.GV_$PARAMETER to ctxsys;
grant select on SYS.COL$ to ctxsys with grant option;
grant select on SYS.COLTYPE$ to ctxsys;
grant select on SYS.IND$ to ctxsys with grant option;
grant select on SYS.INDPART$ to ctxsys with grant option;
grant select on SYS.LOB$ to ctxsys with grant option;
grant select on SYS.LOBFRAG$ to ctxsys with grant option;
grant select on SYS.OBJ$ to ctxsys with grant option;
grant select on SYS.PARTOBJ$ to ctxsys with grant option;
grant select on SYS.SYN$ to ctxsys with grant option;
grant select on SYS.SYSAUTH$ to ctxsys with grant option;
grant select on SYS.TAB$ to ctxsys with grant option;
grant select on SYS.TABPART$ to ctxsys with grant option;
grant select on SYS.TS$ to ctxsys with grant option;
grant select on SYS."_BASE_USER" to ctxsys with grant option;
grant select on SYS.VIEW$ to ctxsys with grant option;
grant select on SYS.V_$PARAMETER to ctxsys with grant option;
grant select on SYS.V_$RESOURCE to ctxsys with grant option;
grant select on dba_types to ctxsys with grant option;
grant select on SYS.V_$THREAD to ctxsys with grant option;
grant select on SYS.CDEF$ to ctxsys with grant option;
grant select on SYS.CON$ to ctxsys with grant option;
grant select on SYS.CCOL$ to ctxsys with grant option;
grant select on SYS.ICOL$ to ctxsys with grant option;
grant select on SYS.snap$ to ctxsys with grant option;
grant select on v_$db_pipes to ctxsys;
grant select on SYS.OPQTYPE$ to ctxsys;

grant execute on dbms_pipe to ctxsys;
grant execute on dbms_lock to ctxsys;
grant execute on dbms_registry to ctxsys;
grant create job to ctxsys;
grant manage scheduler to ctxsys;
grant RESOURCE, UNLIMITED TABLESPACE to ctxsys;
grant inherit any privileges to ctxsys;
grant inherit privileges on user sys to ctxsys;

--Bug fix 12867992
declare
  already_revoked exception;
  pragma exception_init(already_revoked,-01927);
begin
  execute immediate 'revoke inherit privileges on user CTXSYS from PUBLIC';
exception
  when already_revoked then
    null;
end;
/

Rem If XDB is already installed, grant CTXSYS inherit privileges on it.
declare
  v varchar2(100);
begin
  select u.name into v from "_BASE_USER" u, registry$ r
   where u.user# = r.schema# and
         u.name = 'XDB';
  execute immediate 'grant inherit privileges on user xdb to ctxsys';
exception when NO_DATA_FOUND then
    null;
end;
/

Rem ===========================================
Rem set current schema
Rem ===========================================
ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

Rem ===========================================
Rem setup component script filname variable
Rem ===========================================
COLUMN :SCRIPT_NAME NEW_VALUE comp_file NOPRINT
Variable script_name varchar2(50)

Rem ===========================================
Rem select upgrade script to run
Rem ===========================================
Begin

If (substr(dbms_registry.version('CONTEXT'), 1, 5) = '8.1.7') then

   :script_name := '@ctxu817.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 5) = '9.0.1') then

   :script_name := '@ctxu901.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 5) = '9.2.0') then

   :script_name := '@ctxu920.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '10.1.0') then

   :script_name := '@ctxu1010.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '10.2.0') then

   :script_name := '@ctxu1020.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '11.1.0') then

   :script_name := '@ctxu1100.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '11.2.0') then

   :script_name := '@ctxu1120.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '12.1.0') then

   :script_name := '@ctxu1201.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '12.2.0') then

   :script_name := '@ctxu1202.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '18.0.0') then

  :script_name := '@ctxu1801.sql';

elsif (substr(dbms_registry.version('CONTEXT'), 1, 6) = '19.0.0') then

  :script_name := '@ctxu1901.sql';

else

   :script_name := '?/rdbms/admin/nothing.sql';

end if;

end;
/


Rem set to upgrading
begin
  if (upper(:script_name) not like '%NOTHING%') then
    dbms_registry.upgrading('CONTEXT','Oracle Text','validate_context',
                            'CTXSYS');
  end if;
end;
/

select :script_name from dual;

@&comp_file

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

Rem ====================================================
Rem call ctxpatch.sql to upgrade to latest patch set
Rem This will also call validate_context
Rem ====================================================
@@ctxpatch

Rem ====================================================
Rem reset schema just in case the last script changed it
Rem ====================================================
begin
  if (upper(:script_name) not like '%NOTHING%') then
    dbms_registry.upgraded('CONTEXT');
    if dbms_registry.count_errors_in_registry('CONTEXT') > 0 then
      dbms_registry.invalid('CONTEXT');
    end if;
  end if;
end;
/

Rem ===========================================
Rem reset current schema
Rem ===========================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;



@?/rdbms/admin/sqlsessend.sql
