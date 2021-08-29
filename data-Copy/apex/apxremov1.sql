Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      apxremov1.sql
Rem
Rem    DESCRIPTION
Rem      Removes Application Express
Rem
Rem    NOTES
Rem      Assumes the SYS user is connected. You must exit the SQL*Plus session prior to running
Rem      apexins.sql
Rem
Rem    REQUIRENTS
Rem      Application Express
Rem
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   08/14/2006 - Created
Rem      jkallman  09/29/2006 - Adjusted APPUN to FLOWS_030000, add FLOWS_020200 to upgrade query
Rem      jstraub   02/14/2007 - Added call to wwv_flow_upgrade.drop_public_synonyms, and dropping APEX_PUBLIC_USER if not upgraded
Rem      jkallman  08/02/2007 - Change FLOWS_030000 references to FLOWS_030100
Rem      jstraub   08/29/2007 - Altered to completely remove Application Express per bug 6086891
Rem      jstraub   11/27/2007 - Added removing APEX_ADMINISTRATOR_ROLE if not an upgrade installation
Rem      jkallman  07/08/2008 - Change FLOWS_030100 references to FLOWS_040000
Rem      jkallman  10/02/2008 - Change FLOWS_040000 references to APEX_040000
Rem      jstraub   01/29/2009 - Added removal of SYS owned objects specific to Application Express
Rem      jstraub   01/29/2009 - Moved XDB cleanup to block that only executes if not an upgrade from prior release
Rem      jstraub   01/30/2009 - Added dropping WWV_FLOW_KEY and WWV_FLOW_VAL_LIB
Rem      jkallman  11/22/2010 - Change APEX_040000 references to APEX_040100
Rem      jkallman  03/18/2011 - Don't drop APEX DAD if it does not exist
Rem      pawolf    02/21/2012 - Changed APEX_040100 references to APEX_040200
Rem      hfarrell  07/19/2012 - Drop RESTful Services schemas APEX_LISTENER and APEX_REST_PUBLIC_USER if they exist
Rem      jstraub   08/23/2012 - Added prompt to exit the SQL*Plus session prior to running apexins.sql
Rem      jkallman  12/17/2012 - Changed APEX_040200 references to APEX_050000
Rem      cneumuel  12/19/2012 - Removed inconsistency with sqlplus substitution variables: wwv_flow_upgrade.flows_files_objects_remove was called with invalid syntax
Rem      jkallman  04/17/2013 - Added drop of WWV_FLOW_GV$SESSION
Rem      jstraub   06/13/2013 - Adapted for multitenant architecture
Rem      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
Rem      jstraub   07/31/2015 - Added p_drop_all => TRUE in call to drop_public_synonyms (bug 21531843)
Rem      hfarrell  02/05/2016 - Add APEX_050000 to list of schemas to upgrade from
Rem      cneumuel  11/28/2016 - existence check via dba_users, not dbms_registry, because phased install registers APEX at end
Rem      hfarrell  01/05/2017 - Changed APEX_050100 references to APEX_050200; added APEX_050100 to upgrade list
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem

set define '^'
prompt ...Removing Application Express

@@core/scripts/set_appun.sql

alter session set current_schema = ^APPUN;

begin
    wwv_flow_upgrade.drop_public_synonyms(p_drop_all => TRUE);
end;
/

@@core/scripts/set_ufrom_and_upgrade.sql

begin
    if '^UPGRADE' = '1' then
        wwv_flow_upgrade.flows_files_objects_remove('^APPUN');
    end if;
end;
/

alter session set current_schema = SYS;

set serveroutput on
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
declare
    l_has_apex number;
begin
    select count(*)
      into l_has_apex
      from sys.dba_users
     where username = '^APPUN';

    if l_has_apex = 0 then
        dbms_output.put_line(chr(13)||chr(10));
        dbms_output.put_line('Error:');
        dbms_output.put_line('You can only use this script to remove Application Express');
        dbms_output.put_line(chr(13)||chr(10)||chr(13)||chr(10));
        execute immediate('invalid sql stmnt to force exit');
    end if;
end;
/
WHENEVER SQLERROR CONTINUE
