Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      apxremov2.sql
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
Rem      jkallman  03/18/2011 - Dont drop APEX DAD if it does not exist
Rem      pawolf    02/21/2012 - Changed APEX_040100 references to APEX_040200
Rem      hfarrell  07/19/2012 - Drop RESTful Services schemas APEX_LISTENER and APEX_REST_PUBLIC_USER if they exist
Rem      jstraub   08/23/2012 - Added prompt to exit the SQL*Plus session prior to running apexins.sql
Rem      jkallman  12/17/2012 - Changed APEX_040200 references to APEX_050000
Rem      cneumuel  12/19/2012 - Removed inconsistency with sqlplus substitution variables: wwv_flow_upgrade.flows_files_objects_remove was called with invalid syntax
Rem      jkallman  04/17/2013 - Added drop of WWV_FLOW_GV$SESSION
Rem      jstraub   06/13/2013 - Adapted for multitenant architecture
Rem      cneumuel  05/05/2014 - Removed WWV_FLOW_GV$SESSION
Rem      jstraub   11/24/2014 - Added setting "_oracle_script" to allow for dropping users when installed locally in a PDB
Rem      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
Rem      hfarrell  02/05/2016 - Add APEX_050000 to list of schemas to upgrade from
Rem      cczarski  04/15/2016 - Add removal of APEX_INSTANCE_ADMIN_USER
Rem      cneumuel  09/20/2016 - Drop wwv_dbms_sql_^APPUN.
Rem      cneumuel  10/06/2016 - Drop APEX_ADMINISTRATOR_READ_ROLE, APEX$SESSION
Rem      hfarrell  01/05/2017 - Changed APEX_050100 references to APEX_050200; added APEX_050100 to upgrade list
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem      cneumuel  06/15/2018 - Drop old wwv_dbms_sql if it is invalid (bug #27914194)

set define '^'

@@core/scripts/set_appun.sql

alter session set current_schema = SYS;

declare
    invalid_alter_priv exception;
    pragma exception_init(invalid_alter_priv,-02248);
begin
    execute immediate 'alter session set "_ORACLE_SCRIPT"=true';
exception
    when invalid_alter_priv then
        null;
end;
/

@@core/scripts/set_ufrom_and_upgrade.sql

-- remove APEX REST Administration proxy "APEX_INSTANCE_ADMIN_USER"

declare
    is_assigned_to_internal number;
    user_has_objects        number;

    restadmin_username      varchar2(30) := 'APEX_INSTANCE_ADMIN_USER';
begin
    begin
        -- only remove user, when exists and assigned to INTERNAL workspace
        select 1 into is_assigned_to_internal
          from ^APPUN..wwv_flow_company_schemas 
         where schema = restadmin_username
           and security_group_id = 10;

        select count(*) into user_has_objects 
          from sys.dba_objects
         where owner = restadmin_username
           and rownum = 1;

        -- only remove user when schema contains no objects
        if user_has_objects = 0 then
            execute immediate 'drop user ' || restadmin_username;
        end if;
    exception
        when NO_DATA_FOUND then
           null; -- Schema not assigned to INTERNAL: Do nothing.
    end;
end;
/

-- Remove FLOWS SCHEMA
drop user ^APPUN cascade;

-- Remove FLOWS_FILES and APEX_PUBLIC_USER SCHEMA if no other versions exist

begin
    if '^UPGRADE' = '1' then
        execute immediate 'drop user FLOWS_FILES cascade';
        execute immediate 'drop user APEX_PUBLIC_USER cascade';
        execute immediate 'drop role APEX_ADMINISTRATOR_ROLE';
        execute immediate 'drop role APEX_ADMINISTRATOR_READ_ROLE';
        execute immediate 'drop context APEX$SESSION';
    end if;
end;
/

-- Remove APEX_LISTENER and APEX_REST_PUBLIC_USER RESTful Services schema
begin
    if '^UPGRADE' = '1' then
        execute immediate 'drop user APEX_LISTENER cascade';
    end if;
exception when others then
    null;
end;
/

begin
    if '^UPGRADE' = '1' then
        execute immediate 'drop user APEX_REST_PUBLIC_USER cascade';
    end if;
exception when others then
    null;
end;
/



-- XDB Cleanup
declare
    cfg XMLType;
    l_dad_list dbms_epg.varchar2_table;
begin

    if '^UPGRADE' = '1' then

        if dbms_xdb.existsresource('/i/') then
          dbms_xdb.deleteresource('/i/', dbms_xdb.delete_recursive_force);
        end if;

        if dbms_xdb.existsresource('/images/') then
          dbms_xdb.deleteresource('/images/',dbms_xdb.delete_recursive_force);
        end if;

        dbms_epg.get_dad_list( l_dad_list );
        for i in 1..l_dad_list.count loop
            if upper(l_dad_list(i)) = 'APEX' then
                dbms_epg.drop_dad('APEX');
            end if;
        end loop;

        cfg := dbms_xdb.cfg_get();

        if cfg.existsNode('/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-mappings/servlet-mapping/servlet-name[text()="PublishedContentServlet"]') = 1 then
            cfg := cfg.deleteXML('/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-mappings/servlet-mapping/servlet-name[text()="PublishedContentServlet"]/..');
        end if;

        if cfg.existsNode('/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list/servlet/servlet-name[text()="PublishedContentServlet"]') = 1 then
            cfg := cfg.deleteXML('/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list/servlet/servlet-name[text()="PublishedContentServlet"]/..');
        end if;

        dbms_xdb.cfg_update(cfg);
        commit;
        dbms_xdb.cfg_refresh;

    end if;

end;
/

-- Remove SYS owned objects

begin
    if '^UPGRADE' = '1' then
        execute immediate 'drop procedure validate_apex';
        execute immediate 'drop package WWV_FLOW_VAL';
        execute immediate 'drop package WWV_FLOW_KEY';
        execute immediate 'drop library WWV_FLOW_VAL_LIB';
    end if;
    --
    -- drop old wwv_dbms_sql if it is invalid
    --
    for i in ( select 1
                 from sys.dba_objects
                where owner       = 'SYS'
                  and object_name = 'WWV_DBMS_SQL'
                  and status      = 'INVALID' )
    loop
        execute immediate 'drop package wwv_dbms_sql';
    end loop;
end;
/
drop package WWV_DBMS_SQL_^APPUN.;

declare
    invalid_alter_priv exception;
    pragma exception_init(invalid_alter_priv,-02248);
begin
    execute immediate 'alter session set "_ORACLE_SCRIPT"=false';
exception
    when invalid_alter_priv then
        null;
end;
/

prompt ...Application Express Removed
prompt
prompt ********************************************************************
prompt ** You must exit this SQL*Plus session before running apexins.sql **
prompt ********************************************************************
