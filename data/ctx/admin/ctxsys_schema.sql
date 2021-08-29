Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxsys_schema.sql /st_rdbms_19/1 2018/08/29 16:13:58 nspancha Exp $
Rem
Rem ctxsys_schema.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      ctxsys_schema.sql - This script grants privileges CTXSYS
Rem
Rem    DESCRIPTION
Rem      Grants necessary privileges to CTXSYS user during Oracle Text install
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxsys_schema.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/ctxsys_schema.sql
Rem    SQL_PHASE:CTXSYS_SCHEMA
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/16/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    nspancha    03/28/18 - Bug 27084954: Safe Schema Loading
Rem    nspancha    03/28/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

grant create session, alter session, create view, 
      create synonym, resource , unlimited tablespace, 
      set container, inherit any privileges to CTXSYS;
grant inherit privileges on user sys to ctxsys;
grant execute on DBMS_PRIV_CAPTURE to ctxsys;

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

REM
REM Needed for ctx_servers
REM

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
grant select on SYS.DBA_TAB_SUBPARTITIONS to ctxsys;
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
grant select on SYS.v_$db_pipes to ctxsys;
grant select on SYS.OPQTYPE$ to ctxsys;

grant execute on dbms_pipe to ctxsys;
grant execute on dbms_lock to ctxsys;
grant execute on dbms_registry to ctxsys;
grant create job to ctxsys;
grant manage scheduler to ctxsys;

promp ...creating role CTXAPP
create role CTXAPP;
grant ctxapp to ctxsys with admin option;

REM Support DROP USER CASCADE
DELETE FROM sys.duc$
  WHERE owner = 'CTXSYS'
    AND pack = 'CTX_ADM'
    AND proc = 'DROP_USER_OBJECTS'
    AND operation# = 1;

INSERT INTO sys.duc$ (owner, pack, proc, operation#, seq, com)
  VALUES ('CTXSYS', 'CTX_ADM', 'DROP_USER_OBJECTS', 1, 1,
          'Drops any Text objects for this user');

COMMIT;

@?/rdbms/admin/sqlsessend.sql
