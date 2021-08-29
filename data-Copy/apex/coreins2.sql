Rem  Copyright (c) Oracle Corporation 1999 - 2016. All Rights Reserved.
Rem
Rem    NAME
Rem      coreins2.sql
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
Rem      cneumuel  10/17/2016 - Timing for copy_flow_meta_data (feature #1723)
Rem      cneumuel  10/21/2016 - reset package state to avoid ORA-04061 later on
Rem      cneumuel  11/28/2016 - Grant select on all tables in old schema, instead of SELECT ANY TABLE
Rem      cneumuel  02/26/2018 - Grant MANAGE SCHEDULER and MANAGE ANY QUEUE, which are required for parallel stats collection (bug #25346667)
Rem      cneumuel  07/05/2018 - Improve logging for zero downtime (feature #2355)
Rem      cneumuel  07/11/2018 - Pass list of schemas to reset_state_and_show_invalid.sql, to check for invalid objects (exclude FLOWS_FILES)
Rem      cneumuel  07/11/2018 - Added PREFIX parameter
Rem      cneumuel  07/20/2018 - Set serveroutput format to wrapped

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

--==============================================================================
timing start "Enabling Phase 2"
begin
    ^APPUN..wwv_install_api.begin_phase (
        p_phase => 2 );
    commit;
end;
/
set errorlogging on table ^APPUN..WWV_INSTALL_ERRORS

alter session set current_schema = ^APPUN;

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Upgrade Metadata (1)"

declare
--------------------------------------------------------------------------------
    procedure ddl (
        p_stmt in varchar2 )
    is
    begin
        execute immediate p_stmt;
    exception when others then
        ^APPUN..wwv_install_api.error (
            p_message   => sqlerrm,
            p_statement => p_stmt );
    end ddl;
--------------------------------------------------------------------------------
    procedure grant_access_to_ufrom
    is
        l_ufrom_enq varchar2(32767);
        l_appun_enq varchar2(32767);
    begin
    sys.dbms_application_info.set_action('upgrade');
    --
    -- grant select on tables of old schema to new schema
    --
    l_ufrom_enq := sys.dbms_assert.enquote_name('^UFROM');
    l_appun_enq := sys.dbms_assert.enquote_name('^APPUN');
    for i in ( select object_name
                 from sys.dba_objects
                where owner       = '^UFROM'
                  and object_type = 'TABLE'
                  and object_name not like 'SYS%'
                 order by 1 )
    loop
        ddl('grant select on '||
            l_ufrom_enq||'.'||sys.dbms_assert.enquote_name(i.object_name)||
            'to '||l_appun_enq);
    end loop;
    end grant_access_to_ufrom;
--------------------------------------------------------------------------------
begin
    if '^UPGRADE' = '2' Then
        --
        -- Grant select on all tables of UFROM to APPUN. Note that these
        -- privileges are also required for later steps, so we do not revoke
        -- them again.
        --
        grant_access_to_ufrom;
        --
        -- Grant additional required privileges for parallel stats collection.
        -- CREATE JOB is already granted in core_grants.sql.
        --
        ddl('grant MANAGE SCHEDULER to ^APPUN');
        ddl('grant MANAGE ANY QUEUE to ^APPUN');
        --
        -- Copy data, gather stats and run selective upgrades before enabling
        -- constraints.
        --
        wwv_flow_upgrade.copy_flow_meta_data('^UFROM','^APPUN','^CDB_ROOT');
        --
        -- Revoke additional privs again.
        --
        ddl('revoke MANAGE SCHEDULER from ^APPUN');
        ddl('revoke MANAGE ANY QUEUE from ^APPUN');
    end if;
end;
/
@^PREFIX.core/scripts/reset_state_and_show_invalid.sql SYS,^APPUN
