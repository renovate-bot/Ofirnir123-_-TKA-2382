Rem
Rem $Header: ctx_src_2/src/dr/admin/s1202020.sql /main/7 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1202020.sql
Rem
Rem Copyright (c) 2016, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1202020.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1202020.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/s1202020.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    snetrava    03/22/17 - FILE_ACCESS_ROLE to Text Datastore Access Priv
Rem    boxia       01/17/17 - Proj 68638: rm dbms_scheduler privilege to ctxapp
Rem    snetrava    01/20/17 - Only Read priv to dr$policy_tab
Rem    snetrava    01/03/17 - Bug 25266515: Trigger for FILE_ACCESS_ROLE revoke
Rem    rodfuent    12/15/16 - Bug 25028151: grant select dba_tab_subpartitions
Rem    boxia       11/29/16 - Bug 25172618: grant dbms_scheduler privilege
Rem    boxia       11/29/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

@@?/rdbms/admin/sqlsessstart.sql

grant select on SYS.DBA_TAB_SUBPARTITIONS to ctxsys;

REM ========================================================================
REM dbms_scheduler privileges
REM ========================================================================
grant create job to ctxapp;
grant manage scheduler to ctxapp;

begin
-- Only read privilege to dr$policy_tab
execute immediate 'revoke select on ctxsys.dr$policy_tab from public';
execute immediate 'grant read on ctxsys.dr$policy_tab to public';
exception
when others then
null;
end;
/

-- Grant Text Datastore Access to all users who have indexes using the 
-- File/URL datastore
begin
for c1 in
(select distinct(username) from sys.all_users where user_id in
  (select distinct(idx.idx_owner#) from 
   ctxsys.dr$index idx, ctxsys.dr$index_object idx_obj 
   where idx.idx_id = idx_obj.ixo_idx_id 
   and idx_obj.ixo_cla_id = 1 
   and (idx_obj.ixo_obj_id = 3 or idx_obj.ixo_obj_id = 4)))
loop
execute immediate ('grant Text Datastore Access to '|| 
                    dbms_assert.enquote_name(c1.username, false));
end loop;
end;
/

@?/rdbms/admin/sqlsessend.sql
 
