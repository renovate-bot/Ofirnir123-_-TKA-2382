Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      coreins3.sql
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
Rem      1 - CDB_ROOT       = CDB installation into root
Rem      2 - UPGRADE        = Upgrade flag (1 = NO, 2 = YES)
Rem      3 - APPUN          = APEX schema name
Rem      4 - UFROM          = The prior APEX schema in an upgrade installation
Rem      5 - INSTALL_TYPE   = Full development environment or runtime only
Rem      6 - PREFIX         = The path to the file
Rem      7 - ADM_PWD        = Random passwords
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   02/20/2015 - Split from coreins.sql
Rem      cneumuel  02/23/2015 - Moved restricted schema initialization to coreins3.sql (bug #20569037)
Rem                           - Added restricted schemas.
Rem      hfarrell  11/25/2015 - Replaced reference to upgrade_to_050000 with upgrade_to_050100, and upgrade_ws_to_050000 with upgrade_ws_to_050100
Rem      cneumuel  11/26/2015 - Renamed upgrade%_to_050100 to upgrade%_to_latest
Rem      jstraub   12/01/2015 - Moved wwv_flow_upgrade.[drop|create|grant]_public_synonyms from appins.sql (bug 22105151)
Rem      cczarski  04/25/2016 - Added APEX_INSTANCE_ADMIN_USER to the list of restricted schemas
Rem      cneumuel  05/03/2016 - Move insert into wwv_flow_prov_signup_q from provisioning_tables.sql to coreins3.sql
Rem      cneumuel  06/03/2016 - Add FLOWS_nnnnnn, APEX_nnnnnn, DBSFWUSER, GGSYS as restricted schema (bug #23515920)
Rem      cneumuel  06/08/2016 - Add ORDS_PUBLIC_USER, ORDS_METADATA as restricted schema (bug #23515920)
Rem      cneumuel  09/07/2016 - Moved flows_files_new2.sql from coreins.sql to coreins3.sql (bug #23255258)
Rem      cneumuel  09/13/2016 - Added apex schema suffix to wwv_dbms_sql. Re-ordered files to fix flows_files install errors.
Rem      cneumuel  09/20/2016 - Removed code to remove/re-create public synonyms
Rem      cneumuel  10/17/2016 - Moved wwv_flow_upgrade.switch_schemas,flows_files_new2.sql,apex_rest_config_core.sql to coreins5.sql (feature #1723)
Rem      cneumuel  10/21/2016 - Reset package state after recompiling to avoid ORA-04061 later on
Rem      jkallman  10/28/2016 - Remove condition of g_xe (Bug 16516300)
Rem      hfarrell  01/05/2017 - Added APEX_050200 to list of default Oracle schemas
Rem      cneumuel  01/27/2017 - When listing invalid objects, exclude sys objects not owned by us (bug #25408443)
Rem      cczarski  02/03/2017 - Add APEX_INSTANCE_ADMIN_USER to INTERNAL workspace when it has been in the previous release (bug #23113889)
Rem      jstraub   04/06/2017 - Adapted for application container install (bug 24679331)
Rem      cneumuel  06/08/2017 - Recompile wwv_flow_t_writer (bug #26200919)
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem      cneumuel  03/01/2018 - Copy instance settings after installing internal apps (bug #25504652)
Rem      cneumuel  07/05/2018 - Improve logging for zero downtime (feature #2355)
Rem      msewtz    07/16/2018 - Added pkg_app_only_ws_yn, show_schema_yn to insert into wwv_flow_prov_signup_q (feature 2363)
Rem      cneumuel  07/20/2018 - Set serveroutput format to wrapped
Rem      cneumuel  07/31/2018 - Added OWBSYS as restricted schema

set define '^'
set concat on
set concat .
set verify off
set autocommit off
set serveroutput on size unlimited format wrapped

define CDB_ROOT     = '^1'
define UPGRADE      = '^2'
define APPUN        = '^3'
define UFROM        = '^4'
define INSTALL_TYPE = '^5'
define PREFIX       = '^6'
define ADM_PWD      = '^7'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Upgrade Metadata (2)"

set errorlogging on table ^APPUN..WWV_INSTALL_ERRORS

alter session set current_schema = ^APPUN;

begin
if '^UPGRADE' = '2' Then
    sys.dbms_output.put_line('   -- Upgrading new schema. -------');
    wwv_flow_upgrade.upgrade_to_latest (
        p_owner => '^APPUN',
        p_from  => '^UFROM' );
    commit;
end if;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Recompiling ^APPUN schema"

begin
    if '^INSTALL_TYPE' <> 'APPCONTAINER' then
        sys.dbms_application_info.set_action('recompiling');
        sys.utl_recomp.recomp_parallel(schema => '^APPUN.');
    end if;
end;
/

alter package sys.wwv_dbms_sql_^APPUN. compile body;
alter type wwv_flow_t_writer compile body;

@^PREFIX.core/scripts/reset_state_and_show_invalid.sql SYS,^APPUN

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Configuring Restricted Schemas"

prompt ...Migrate APEX_INSTANCE_ADMIN_USER - Administration REST Interface
declare
    l_instadmin_user_from number := 0;
    l_instadmin_user_curr number := 0;
    l_restadmin_user_name varchar2(30) := 'APEX_INSTANCE_ADMIN_USER';
begin
    begin
        select 1
          into l_instadmin_user_from
          from ^UFROM..wwv_flow_company_schemas
         where security_group_id = 10
           and schema = l_restadmin_user_name;
    exception
        when NO_DATA_FOUND then null;
    end;
    begin
        select 1
          into l_instadmin_user_curr
          from ^APPUN..wwv_flow_company_schemas
         where security_group_id = 10
           and schema = l_restadmin_user_name;
    exception
        when NO_DATA_FOUND then null;
    end;
    if l_instadmin_user_from = 1 and l_instadmin_user_curr = 0 then
        -- unrestrict first in order to assign to INTERNAL workspace
        ^APPUN..wwv_flow_instance_admin.unrestrict_schema( l_restadmin_user_name );
        ^APPUN..wwv_flow_instance_admin.add_schema(
            p_workspace    => 'INTERNAL',
            p_schema       => l_restadmin_user_name
        );
        -- schema will be restricted again with the following block
    end if;
end;
/

prompt ...Initialize the table of Oracle default schema names
declare
    l_schemas wwv_flow_t_varchar2;
begin
    l_schemas := wwv_flow_t_varchar2 (
                     'ANONYMOUS',
                     'APEX_LISTENER', 'APEX_PUBLIC_USER', 'APEX_REST_PUBLIC_USER', 'APEX_INSTANCE_ADMIN_USER',
                     'APPQOSSYS',
                     'AUDSYS',
                     'AURORA$JIS$UTILITY$', 'AURORA$ORB$UNAUTHENTICATED',
                     'AVSYS',
                     'CTXSYS',
                     'DBSNMP', 'DBSFWUSER',
                     'DIP',
                     'DMSYS',
                     'DVF', 'DVSYS',
                     'EXFSYS',
                     'FLOWS_FILES',
                     'GGSYS', 'GSMADMIN_INTERNAL', 'GSMCATUSER', 'GSMUSER',
                     'HTMLDB_PUBLIC_USER',
                     'LBACSYS',
                     'MDDATA', 'MDSYS',
                     'MGMT_VIEW',
                     'ODM', 'ODM_MTR',
                     'OE',
                     'OJVMSYS',
                     'OLAPSYS',
                     'ORACLE_OCM',
                     'ORDDATA', 'ORDPLUGINS', 'ORDSYS',
                     'ORDS_PUBLIC_USER', 'ORDS_METADATA',
                     'OWBSYS',
                     'OSE$HTTP$ADMIN',
                     'OUTLN',
                     'PERFSTAT',
                     'PM',
                     'QS', 'QS_ADM', 'QS_CB', 'QS_CBADM', 'QS_CS', 'QS_ES', 'QS_OS', 'QS_WS',
                     'REMOTE_SCHEDULER_AGENT',
                     'RMAN',
                     'SCOTT',
                     'SH',
                     'SI_INFORMTN_SCHEMA',
                     'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
                     'SYS', 'SYSBACKUP', 'SYSDG', 'SYSKM', 'SYSMAN', 'SYSRAC', 'SYSTEM', 'SYS$UMF',
                     'TSMSYS',
                     'WKPROXY', 'WKSYS', 'WK_TEST',
                     'WMSYS',
                     'XDB',
                     'XS$NULL' );
    --
    -- add existing APEX schemas
    --
    for i in ( select username
                 from sys.dba_users
                where username between 'APEX_030200' and '^APPUN.'
                   or username between 'FLOWS_010500' and 'FLOWS_030100' )
    loop
        l_schemas.extend;
        l_schemas(l_schemas.count) := i.username;
    end loop;

    insert into wwv_flow_restricted_schemas (
           schema )
    select schema
      from ( select s.column_value schema
               from table(l_schemas) s
           ) s
     where not exists ( select null
                          from wwv_flow_restricted_schemas s2
                         where s2.schema = s.schema );
end;
/
prompt ...Service signup Question install
begin
    -- insert disabled service signup question. on upgrade, the question can already exist. we ignore that error.
    insert into wwv_flow_prov_signup_q (id, pkg_app_only_ws_yn, show_schema_yn, survey_enabled_yn, justification_required_yn) values (1, 'N', 'N', 'N', 'Y');
exception when dup_val_on_index then null;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Page Designer Metadata"

prompt ...Page Designer metadata install
-- PD meta data are referenced by plug-ins, that's why we always have to install them.
-- We skip the creation of system messages, because they will be loaded by f4411.sql
@^PREFIX.core/apex_install_pe_data.sql NO

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4411"
@^PREFIX.builder/f4411.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4155"
@^PREFIX.builder/f4155.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Internal Themes"
@^PREFIX.core/themes/apex_install_internal_themes.sql
set define '^'

prompt ...Applications install if necessary
column foo new_val script
set termout off
select decode('^INSTALL_TYPE','RUNTIME','core/null1.sql','appins.sql') foo from sys.dual;
set termout on
@^PREFIX.^script

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Updating App Owner/Version"
update wwv_flows
   set owner = '^APPUN',
       flow_version = case when id in (4550) then '&PRODUCT_NAME.'
                           else '&PRODUCT_NAME. ' || wwv_flows_release
                      end
 where id between 4000 and 4999;

commit;

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Copying Instance settings"
begin
if '^UPGRADE' = '2' Then
    sys.dbms_output.put_line('   -- Copying preferences to new schema. -------');
    wwv_flow_upgrade.copy_prefs('^UFROM','^APPUN');
    commit;
end if;
end;
/
