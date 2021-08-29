Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      coreins5.sql
Rem
Rem    DESCRIPTION
Rem      This is a primary installation script for Oracle APEX, but this should never be invoked directly.
Rem      This file should only be invoked by apexins.sql, the primary installation script for APEX.
Rem
Rem    NOTES
Rem      Ensure that all arguments (except image prefix) are entered in UPPERCASE.
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 10.2.0.3 or later
Rem      - PL/SQL Web Toolkit
Rem
Rem    Arguments:
Rem      1 - CDB_ROOT  = CDB installation into root
Rem      2 - UPGRADE   = Upgrade flag (1 = NO, 2 = YES)
Rem      3 - APPUN     = APEX schema name
Rem      4 - UFROM     = The prior APEX schema in an upgrade installation
Rem      5 - PREFIX    = The path to the file
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   02/20/2015 - Split from coreins.sql
Rem      jstraub   02/25/2015 - Added INSTALL_TYPE as a passed parameter
Rem      cneumuel  03/04/2015 - Moved revoke of select any table up before endins (which calls validate_apex) because it made objects invalid
Rem      cneumuel  10/17/2016 - Switch schemas, create APEX$SESSION, run flows_files_new2, apex_rest_config_core.sql (feature #1723)
Rem      cneumuel  11/28/2016 - Moved registry calls for upgrade and drop of old sys objects from coreins.sql
Rem      cneumuel  01/12/2017 - Register schemas before switching and migrating FLOWS_FILES (bug #25387702)
Rem      jstraub   04/06/2017 - Adapted for application container install (bug 24679331)
Rem      cneumuel  05/23/2017 - Use gen_adm_pwd.sql (bug #25790200)
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem      cneumuel  02/22/2018 - Recompile and reset state after wwv_flow_upgrade.switch_schemas (bug #27564001)
Rem      cneumuel  07/05/2018 - Improve logging for zero downtime (feature #2355)
Rem      cneumuel  07/10/2018 - Set APEX_PATCH_STATUS->APPLYING
Rem      cneumuel  07/11/2018 - Added prefix parameter to apex_rest_config_core.sql (bug #28315666)
Rem      cneumuel  07/11/2018 - Pass list of schemas to reset_state_and_show_invalid.sql, to check for invalid objects
Rem      cneumuel  07/17/2018 - Move setting of APEX_PATCH_STATUS to wwv_flow_upgrade
Rem      cneumuel  07/18/2018 - Move invalidation of dependent objects from wwv_flow_upgrade.switch_schemas to coreins5.sql (feature #2355)
Rem      cneumuel  07/20/2018 - Set serveroutput format to wrapped
Rem      cneumuel  07/23/2018 - In "Removing Unused SYS Objects": ignore ORA-04043
Rem      cneumuel  07/27/2018 - Separate step for setting loaded/upgraded in registry
Rem      jstraub   08/16/2018 - Added set errorlogging off at end of phase 3 (bug 28488523)
Rem      cneumuel  08/28/2018 - Set current schema to ^APPUN at the beginning (bug #28542126)
Rem      cneumuel  08/28/2018 - In wwv_flow_upgrade.copy_post_metadata: moved drop_upgrade_triggers to coreins5.sql (bug #28542126)
Rem      cneumuel  08/29/2018 - In "Computing Pub Syn Dependents", exclude MVs (bug #28568001)

set define '^'
set concat on
set concat .
set verify off
set autocommit off
set serveroutput on size unlimited format wrapped

define CDB_ROOT  = '^1'
define UPGRADE   = '^2'
define APPUN     = '^3'
define UFROM     = '^4'
define PREFIX    = '^5'
define INSTALL_TYPE = '^6'

--==============================================================================
timing start "Enabling Phase 3"
begin
    ^APPUN..wwv_install_api.begin_phase (
        p_phase => 3,
        p_hot   => true );
    commit;
end;
/
set errorlogging on table ^APPUN..WWV_INSTALL_ERRORS

alter session set current_schema = ^APPUN;

--==============================================================================
-- Invalidate objects that depend on the existing public synonyms and the old
-- APEX schema objects.
--
@^PREFIX.core/scripts/install_action.sql "Computing Pub Syn Dependents"
declare
    l_object_ids wwv_flow_t_number;
    l_errors     pls_integer := 0;
begin
    if '^UFROM' <> '^APPUN' then
        with deps as (
            select d.owner,
                   d.type,
                   d.name
              from sys.dba_dependencies d
             where d.owner     not in ('SYS','FLOWS_FILES','PUBLIC', '^UFROM')
               and referenced_owner = '^UFROM'
            union -- not all, we want distinct
            select d.owner,
                   d.type,
                   d.name
              from sys.dba_dependencies d
             where d.owner     not in ('SYS','FLOWS_FILES','PUBLIC', '^UFROM')
               and d.referenced_owner    =  'PUBLIC'
               and d.referenced_name in ( select synonym_name
                                            from sys.dba_synonyms
                                           where owner       = 'PUBLIC'
                                             and table_owner = '^UFROM' )
        )
        select o.object_id
          bulk collect into
               l_object_ids
          from deps            d,
               sys.dba_objects o
         where o.owner       = d.owner
           and o.object_type = d.type
           and o.object_name = d.name
           and o.status      = 'VALID'
           and o.owner       <> '^APPUN'
           and o.object_type not in ( 'MATERIALIZED VIEW' )
         order by o.owner,
                  o.object_id;

        ^APPUN..wwv_install_api.action (
            p_action => 'Invalidating Pub Syn Dependents',
            p_info   => l_object_ids.count||' objects' );

        for i in 1 .. l_object_ids.count loop
            if mod(i, 100) = 1 then
                sys.dbms_application_info.set_action('Invalidating '||i||'/'||l_object_ids.count);
            end if;

            begin
                sys.dbms_utility.invalidate (
                    p_object_id => l_object_ids(i) );
            exception when others then
                ^APPUN..wwv_install_api.error (
                    p_message   => 'WARN: '||sqlerrm,
                    p_statement => 'dbms_utility.invalidate('||l_object_ids(i)||')' );
                l_errors := l_errors + 1;
                exit when l_errors = 100;
            end;
        end loop;
    end if;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Upgrade Hot Metadata and Switch Schemas"

alter session set current_schema = ^APPUN;

begin
    wwv_flow_upgrade.switch_schemas('^UFROM','^APPUN');
    commit;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing FLOWS_FILES Objects"

@^PREFIX.core/flows_files_new2.sql

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing APEX$SESSION Context"

create or replace context APEX$SESSION using ^APPUN..wwv_flow_session_context
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Recompiling ^APPUN."
begin
    if '^INSTALL_TYPE' <> 'APPCONTAINER' then
        sys.dbms_application_info.set_action('recompiling');
        sys.utl_recomp.recomp_parallel(schema => '^APPUN.');
    end if;
end;
/

@^PREFIX.core/scripts/reset_state_and_show_invalid.sql SYS,FLOWS_FILES,^APPUN
--
-- After a session state reset, wwv_install_api does not remember the phase it
-- was in. Since phase 4 typically already started at this stage via a
-- background job, the built-in current phase detection will assume the actions
-- below belong to phase 4. We therefore have to manually set the current phase
-- to 3.
--
exec ^APPUN..wwv_install_api.continue_phase(p_phase => 3);

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing APEX REST Config"
--
-- Configure RESTful services for this instance if APEX_LISTENER exists
--
column thescript  new_val script
set termout off
select decode(has_rest, 1, 'apex_rest_config_core.sql', 'core/null1.sql') thescript
  from ( select count(*) has_rest
           from sys.dba_users
          where username = 'APEX_LISTENER' );
set termout on
@^PREFIX.core/scripts/gen_adm_pwd.sql
@^PREFIX.^script ^PREFIX. ^ADM_PWD ^ADM_PWD

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Set Loaded/Upgraded in Registry"
begin
    ^APPUN..wwv_install_api.set_upgraded_in_registry;
    ^APPUN..wwv_flow_upgrade.set_patch_applied (
        p_from  => '^UFROM' );
    commit;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Removing Unused SYS Objects"
declare
    l_dropped boolean;
    e_does_not_exist exception;
    pragma exception_init(e_does_not_exist,-942);
    e_does_not_exist2 exception;
    pragma exception_init(e_does_not_exist2, -4043);
    procedure ddl(p_sql in varchar2)
    is
    begin
        sys.dbms_output.put_line('...'||p_sql);
        execute immediate p_sql;
        l_dropped := true;
    exception when e_does_not_exist or e_does_not_exist2 then
        l_dropped := false;
    end ddl;
begin
    if '^UPGRADE' = '2' then
        ddl('drop view sys.flow_sessions');
        ddl('drop view sys.flow_parameters');
        ddl('drop view sys.flow_sqlarea');
        ddl('drop view sys.flow_sga');
        ddl('drop view sys.wwv_flow_gv$session');
        if l_dropped then
            -- can not keep old version because of dependencies
            ddl('drop package sys.wwv_dbms_sql');
        end if;
        --
        -- drop upgrade triggers in old schema to avoid errors on downgrade
        --
        ^APPUN..wwv_flow_upgrade.drop_upgrade_triggers (
            p_from => '^UFROM' );
    end if;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Validating Installation"
begin
    if ('^INSTALL_TYPE' = 'INTERNAL' and '^UPGRADE' = '2') or '^INSTALL_TYPE' = 'APPCONTAINER' then
        null;
    else
        sys.validate_apex;
    end if;
end;
/

declare
    invalid_alter_priv exception;
    pragma exception_init(invalid_alter_priv,-02248);
begin
    if '^INSTALL_TYPE' <> 'APPCONTAINER' then
        execute immediate 'alter session set "_ORACLE_SCRIPT"=false';
    end if;
exception
    when invalid_alter_priv then
        null;
end;
/

column flow_version new_val version
set termout off
select wwv_flows_release as flow_version from sys.dual where rownum = 1;
set termout on

begin
for c1 in (select value
             from sys.v_$parameter
            where name = 'job_queue_processes') loop
    sys.dbms_output.put_line('JOB_QUEUE_PROCESSES: '|| c1.value);
    exit;
end loop;
end;
/

--==============================================================================
timing stop
begin
    ^APPUN..wwv_install_api.end_phase (
        p_phase       => 3,
        p_raise_error => false );
    ^APPUN..wwv_install_api.end_install;
end;
/
set errorlogging off

prompt
prompt
prompt
prompt      Thank you for installing Oracle Application Express ^version.
prompt
prompt      Oracle Application Express is installed in the ^APPUN schema.
prompt
prompt      The structure of the link to the Application Express administration services is as follows:
prompt      http://host:port/pls/apex/apex_admin (Oracle HTTP Server with mod_plsql)
prompt      http://host:port/apex/apex_admin     (Oracle XML DB HTTP listener with the embedded PL/SQL gateway)
prompt      http://host:port/apex/apex_admin     (Oracle REST Data Services)
prompt
prompt      The structure of the link to the Application Express development interface is as follows:
prompt      http://host:port/pls/apex (Oracle HTTP Server with mod_plsql)
prompt      http://host:port/apex     (Oracle XML DB HTTP listener with the embedded PL/SQL gateway)
prompt      http://host:port/apex     (Oracle REST Data Services)
prompt

column global_name new_value gname
set termout off
select user global_name from sys.dual;
set termout on
set heading on
set feedback on
set sqlprompt '^gname> '
