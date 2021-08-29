set define '^' verify off
prompt ...validate_apex
create or replace procedure validate_apex as
--------------------------------------------------------------------------------
--
-- Copyright (c) 1999 - 2018, Oracle and/or its affiliates. All rights reserved.
--
--    NAME
--      validate_apex.sql
--
--    SYNOPSIS
--      @validate_apex x x APEX_050100
--
--    DESCRIPTION
--      This procedure checks that the objects in the APEX application schema
--      are valid.
--
--    NOTES
--      Assumes the SYS user is connected. Call with 3 parameters, the 3rd has
--      to be the APEX schema.
--
--    REQUIREMENTS
--      - Oracle 10g
--
--    MODIFIED   (MM/DD/YYYY)
--      jstraub   06/21/2006 - Created, borrowed almost exclusively from CTXSYS, thanks gkaminag
--      jstraub   06/22/2006 - Broke out validate procedure into a package
--      jstraub   06/29/2006 - Turned back into standalone procedure on advice from rburns
--      jstraub   01/30/2007 - Excluded wwv_flow_custom_auth_sso (Bug 5852920)
--      jstraub   01/31/2007 - Changed query on all objects to improve performance
--      jstraub   07/13/2007 - Removed WWV_FLOW_DATA_LOAD and WWV_FLOW_XLIFF from existance check to support runtime
--      jstraub   02/01/2008 - Removed check for WWV_EXECUTE_IMMEDIATE and added check for WWV_DBMS_SQL
--      mhichwa   10/13/2008 - added logging to account for time
--      mhichwa   10/13/2008 - Replacing carrot 3 with APEX_040000
--      mhichwa   10/14/2008 - Enhanced logging, display numbers of objects installed by object type
--      mhichwa   10/14/2008 - Removed duplicate dot after Compile objects that are invalid
--      mhichwa   10/15/2008 - Added accounting for the number of procedures loaded
--      mhichwa   10/15/2008 - Report all errors for compilation and existance not just first error
--      mhichwa   10/18/2008 - Re-instated carrot 3 subs
--      sspadafo  10/23/2008 - Added wwv_flow_assert calls (Bug 7426240)
--      sspadafo  10/23/2008 - Prefixed wwv_flow_assert with APEX_040000. (Bug 7426240)
--      sspadafo  10/23/2008 - Undo previous two changes; added local function simple_sql_name and use as alternative to assert (Bug 7426240)
--      sspadafo  10/23/2008 - Replace APEX_040000 references with caret-3 (Bug 7426240)
--      jkallman  06/09/2009 - Correct typos of 'Regristry'
--      jstraub   06/07/2011 - Replaced references to local simple_sql_name with dbms_assert.enquote_name
--      cneumuel  07/02/2014 - Report missing direct grants. prefix sys objects with schema. optimize compilation code.
--      cneumuel  07/02/2014 - Renamed apexvalidate.sql to core/validate_apex.sql
--      cneumuel  08/08/2014 - Emit ORA-20001: for error messages, to make it easier to spot them in hudson
--      cneumuel  08/14/2014 - use utl_recomp instead of execute immediate and emit compile errors
--      cneumuel  09/12/2014 - Ignore XDB.X$% in missing grants (12gR2)
--      cneumuel  01/20/2015 - Ignore SYS.XMLSEQUENCETYPE in missing grants (11gXE)
--      cneumuel  02/23/2015 - In missing grants check for XMLSEQUENCETYPE, use referenced_OWNER = SYS, not referenced_name
--      cneumuel  04/03/2015 - In missing privlileges check, grant SYS privileges and INHERIT privileges if missing
--      jstraub   04/23/2015 - Added DBMS_STATS_INTERNAL in check for SYS grants
--      jstraub   05/07/2015 - Added DBMS_METADATA in check for SYS grants
--      jstraub   05/13/2015 - Added DBMS_CRYPTO in check for SYS grants
--      cneumuel  06/22/2015 - Added dbms_assert calls around parameters for dynamic code (lrg problem 17042191)
--      cneumuel  06/25/2015 - Added DBMS_CRYPTO_STATS_INT (project 49581)
--      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100 in SYNOPSIS above
--      cneumuel  07/27/2015 - Added DBMS_CRYPTO_INT (project 49581)
--      jstraub   07/27/2015 - Changed DBMS_CRYPTO_INT to DBMS_CRYPTO_INTERNAL
--      jstraub   12/30/2015 - Changed COMPILE ERROR text to COMPILE FAILURE for RTI 16428087
--      cneumuel  02/19/2016 - Do not quote "INHERIT ANY PRIVILEGES" when granting (bug #22724824)
--      jstraub   04/28/2016 - Don't indicate an error if current APEX schema is different than procedure schema (bug 22885960)
--      jstraub   06/07/2016 - Regrant DBA_SCHEDULER_JOBS and NLS_DATABASE_PARAMETERS if missing after downgrade and drop
--                             remaining invalid objects in the schema downgraded from
--      cneumuel  09/08/2016 - sys.wwv_dbms_sql has APEX schema suffix
--      cneumuel  09/16/2016 - Removed logging of object type count. New checks for jobs, FLOWS_FILES and SYS objects.
--      cneumuel  04/20/2017 - dbms_assert was missing in calls to ddl (bug #21382758)
--      cneumuel  08/17/2017 - Also recompile FLOWS_FILES and SYS if one of our objects there is invalid (bug #26591398)
--      cczarski  09/07/2017 - Add wwv_flow_db_env_detection.detect to make new database features (after upgrade) available to APEX
--      cneumuel  11/30/2017 - Added JSON_ARRAY_T, JSON_ELEMENT_T, JSON_KEY_LIST, JSON_OBJECT_T for data profiles
--      cneumuel  12/20/2017 - In valid objects check, order schemas (SYS, FLOWS_FILES, APEX_nnnnnn)
--      cneumuel  02/23/2018 - Recompile serial and not parallel
--      cneumuel  02/26/2018 - Changed recompile to use dbms_utility.compile_schema, because there were still invalid objects
--      cneumuel  06/29/2018 - alter package/compile for SYS objects
--
--------------------------------------------------------------------------------
    c_apex_schema        constant varchar2(30) := '^3';
    c_reg_schema         constant varchar2(30) := sys.dbms_registry.schema('APEX');
    l_error_count        pls_integer := 0;
    c_key_apex_objects   constant sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll (
                                                                'WWV_FLOW_COLLECTIONS$',
                                                                'WWV_FLOW_COMPANIES',
                                                                'WWV_FLOW_FND_USER',
                                                                'WWV_FLOW_ITEMS',
                                                                'WWV_FLOW_LISTS',
                                                                'WWV_FLOW_MAIL_QUEUE',
                                                                'WWV_FLOW_MESSAGES$',
                                                                'WWV_FLOW_PAGE_PLUGS',
                                                                'WWV_FLOW_STEP_ITEMS',
                                                                'WWV_FLOW_STEP_PROCESSING',
                                                                'WWV_FLOW_STEP_VALIDATIONS',
                                                                'WWV_FLOW_STEPS',
                                                                'WWV_FLOW_SW_STMTS',
                                                                'WWV_FLOWS',
                                                                'WWV_FLOW_DML',
                                                                'WWV_FLOW_ITEM',
                                                                'WWV_FLOW_LANG',
                                                                'WWV_FLOW_LOG',
                                                                'WWV_FLOW_MAIL',
                                                                'WWV_FLOW_SVG',
                                                                'WWV_FLOW_SW_PARSER',
                                                                'WWV_FLOW_SW_UTIL',
                                                                'WWV_FLOW_UTILITIES',
                                                                'F',
                                                                'P',
                                                                'Z',
                                                                'V',
                                                                -- scheduler jobs
                                                                'ORACLE_APEX_DAILY_MAINTENANCE',
                                                                'ORACLE_APEX_MAIL_QUEUE',
                                                                'ORACLE_APEX_PURGE_SESSIONS',
                                                                'ORACLE_APEX_WS_NOTIFICATIONS' );
    c_key_file_objects   constant sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll (
                                                                'WWV_FLOW_FILE_OBJECTS$',
                                                                'WWV_BIU_FLOW_FILE_OBJECTS' );
    c_key_sys_objects    constant sys.dbms_debug_vc2coll := sys.dbms_debug_vc2coll (
                                                                'WWV_DBMS_SQL_'||c_apex_schema,
                                                                'WWV_FLOW_KEY',
                                                                'WWV_FLOW_VAL' );
--------------------------------------------------------------------------------
    procedure p (
        p_message in varchar2 )
    is
    begin
        sys.dbms_output.put_line (p_message);
    end p;
--------------------------------------------------------------------------------
    procedure error (
        p_message in varchar2 )
    is
    begin
        l_error_count := l_error_count + 1;
        if nvl(c_reg_schema,'x') = c_apex_schema then
            p('ORA-20001: '||p_message);
        else
            p('Current APEX schema is '||c_reg_schema||' and validate schema is '||c_apex_schema);
        end if;
    end error;
--------------------------------------------------------------------------------
    procedure log_action (
        p_message in varchar2 )
    is
    begin
        p('...('||to_char(sysdate,'HH24:MI:SS')||') '||p_message);
    end log_action;
--------------------------------------------------------------------------------
    procedure check_key_objects_exist (
        p_schema  in varchar2,
        p_objects in sys.dbms_debug_vc2coll )
    is
    begin
        for i in ( select p.column_value object_name,
                          o.status
                     from table(p_objects) p,
                          sys.dba_objects  o
                    where p.column_value = o.object_name (+)
                      and ( o.status is null or o.owner = p_schema ) )
        loop
            if i.status is null then
                error('FAILED Existence check for '||p_schema||'.'||i.object_name);
            elsif i.status <> 'VALID' then
                error('FAILED status check for '||p_schema||'.'||i.object_name||': '||i.status);
            end if;
        end loop;
    end check_key_objects_exist;
--------------------------------------------------------------------------------
    procedure ddl (
        p_ddl in varchar2 )
    is
    begin
        log_action(p_ddl);
        execute immediate p_ddl;
    exception when others then
        --
        -- during a database downgrade the object might not exist
        --
        log_action('DDL not successful: '||p_ddl);
    end ddl;
--------------------------------------------------------------------------------
begin
    log_action('Starting validate_apex for '||c_apex_schema);
    if nvl(c_reg_schema,'x') <> c_apex_schema then
        log_action('DBMS registry schema for APEX is "'||c_reg_schema||'"');
    end if;
    --
    -- log missing direct grants
    --
    for c1 in ( select distinct
                       d.owner,
                       d.referenced_owner,
                       d.referenced_name,
                       d.referenced_type
                  from dba_dependencies d
                 where d.owner = c_apex_schema
                   and d.referenced_owner not in (d.owner, 'PUBLIC')
                   and d.referenced_name  not in ('STANDARD',
                                                  'DBMS_STANDARD',
                                                  'PLITBLM')
                   and not (    d.referenced_owner = 'XDB'
                            and d.referenced_name  like 'X$%' )
                   and not (    d.referenced_owner = 'SYS'
                            and d.referenced_name  = 'XMLSEQUENCETYPE' )
                   and not exists ( select null
                                      from dba_tab_privs p
                                     where d.referenced_owner = p.owner
                                       and d.referenced_name  = p.table_name
                                       and d.owner            = p.grantee )
                 order by 1, 2,3 )
    loop
        if c1.referenced_owner = 'SYS'
           and c1.referenced_name in ( 'DBA_TAB_IDENTITY_COLS',
                                       'DBA_XS_DYNAMIC_ROLES',
                                       'V_$XS_SESSION_ROLES',
                                       'DBA_SCHEDULER_JOBS',
                                       'NLS_DATABASE_PARAMETERS' )
        then
            ddl('grant select on '||
                sys.dbms_assert.enquote_name(c1.referenced_owner)||'.'||
                sys.dbms_assert.enquote_name(c1.referenced_name)||' to '||
                c_apex_schema);
        elsif c1.referenced_owner = 'SYS'
           and c1.referenced_name in ( 'DBMS_XS_NSATTR',
                                       'DBMS_XS_NSATTRLIST',
                                       'DBMS_STATS_INTERNAL',
                                       'DBMS_CRYPTO_INTERNAL',
                                       'DBMS_CRYPTO_STATS_INT',
                                       'DBMS_METADATA',
                                       'DBMS_CRYPTO',
                                       'DIANA',
                                       'DIUTIL',
                                       'GETLONG',
                                       'KU$_DDL',
                                       'KU$_DDLS',
                                       'UTL_CALL_STACK',
                                       'UTL_TCP',
                                       'XS$NAME_LIST',
                                       'JSON_ARRAY_T',
                                       'JSON_ELEMENT_T',
                                       'JSON_KEY_LIST',
                                       'JSON_OBJECT_T' )
        then
            ddl('grant execute on '||
                sys.dbms_assert.enquote_name(c1.referenced_owner)||'.'||
                sys.dbms_assert.enquote_name(c1.referenced_name)||' to '||
                c_apex_schema);
        else
            error('MISSING GRANT: grant '||
                case when c1.referenced_type in ('TABLE', 'VIEW') then 'select' else 'execute' end||
                ' on "'||c1.referenced_owner||'"."'||c1.referenced_name||
                '" to '||c_apex_schema);
        end if;
    end loop;
    --
    -- check missing sys privileges
    --
    log_action('Checking missing sys privileges');
    for i in ( select name
                 from sys.system_privilege_map m
                where name in ( 'INHERIT ANY PRIVILEGES' )
                  and not exists ( select null
                                     from sys.dba_sys_privs p
                                    where p.grantee = c_apex_schema
                                      and p.privilege = m.name ))
    loop
        ddl('grant '||
            sys.dbms_assert.enquote_name(i.name)||
            ' to '||c_apex_schema);
    end loop;
    --
    -- detect database environment (version and available features)
    --
    log_action('Re-generating ^3..wwv_flow_db_version');
    begin
        execute immediate 'begin ' ||
                          '^3..wwv_flow_db_env_detection.generate_wwv_flow_db_version;' ||
                          'end;';
    exception when others then
        error(sqlerrm);
    end;
    --
    -- recompile any invalid objects in schemas that we use
    --
    for l_schema in ( select owner, count(*)
                        from sys.dba_objects
                       where owner in ( c_apex_schema, 'FLOWS_FILES', 'SYS' )
                         and ( owner <> 'SYS' or object_name member of c_key_sys_objects )
                         and status <> 'VALID'
                       group by owner
                       order by case owner
                                when 'SYS'         then 1
                                when 'FLOWS_FILES' then 2
                                else 3
                                end )
    loop
        if l_schema.owner <> 'SYS' then
            log_action('Recompiling '||l_schema.owner||' ... with dbms_utility.compile_schema');
            sys.dbms_utility.compile_schema (
                schema         => l_schema.owner,
                compile_all    => false,
                reuse_settings => true );
        else
            --
            -- dbms_utility.compile_schema can not compile SYS, that raises
            -- ORA-20001: Cannot recompile SYS objects
            --
            for i in ( select object_type, object_name
                         from sys.dba_objects
                        where owner = l_schema.owner
                          and status <> 'VALID'
                          and object_name member of c_key_sys_objects
                        order by 1 )
            loop
                ddl (
                    'alter package sys.'||sys.dbms_assert.enquote_name(i.object_name)||
                    ' compile'||
                    case when i.object_type='PACKAGE BODY' then ' body' end );
            end loop;
        end if;
        --
        -- check for objects that are still invalid
        --
        log_action('Checking for objects that are still invalid');
        for c1 in ( select object_name, object_type, status
                      from sys.dba_objects
                     where owner           = l_schema.owner
                       and ( owner <> 'SYS' or object_name member of c_key_sys_objects )
                       and object_type not in ( 'SYNONYM' )
                       and object_type not like 'LOB%'
                       and status <> 'VALID'
                     order by case object_type
                              when 'PACKAGE'      then 1
                              when 'PACKAGE BODY' then 3
                              when 'TYPE BODY'    then 3
                              else 2
                              end,
                              object_name )
        loop
            -- check if downgrade
            if nvl(c_reg_schema,'x') = c_apex_schema then -- registry matches, not a downgrade
                error('COMPILE FAILURE: '||c1.object_type||' '||l_schema.owner||'.'||c1.object_name);
                for l_err in ( select line, position, text
                                 from dba_errors
                                where owner = l_schema.owner
                                  and name  = c1.object_name
                                  and type  = c1.object_type
                                order by line, position )
                loop
                    p('...'||rpad(l_err.line||'/'||l_err.position, 8)||' '||l_err.text);
                end loop;
            else -- there are invalid objects but they exist in the schema downgraded from
                if l_schema.owner = c_apex_schema
                    and c1.object_name in ('APEX$_WS_ROWS_T1')
                then
                    ddl('drop '||
                        sys.dbms_assert.noop(c1.object_type)||' '||
                        sys.dbms_assert.enquote_name(c_apex_schema)||'.'||
                            sys.dbms_assert.enquote_name(c1.object_name));
                end if;
            end if;
        end loop;
    end loop;
    --
    -- check for the existence of key objects
    --
    log_action('Key object existence check');

    check_key_objects_exist (
        p_schema  => c_apex_schema,
        p_objects => c_key_apex_objects );
    check_key_objects_exist (
        p_schema  => 'FLOWS_FILES',
        p_objects => c_key_file_objects );
    check_key_objects_exist (
        p_schema  => 'SYS',
        p_objects => c_key_sys_objects );
    --
    -- write summary and set registry status
    --
    if l_error_count > 0 then
        log_action('Setting DBMS registry for APEX to INVALID');
        sys.dbms_registry.invalid('APEX');
    else
        log_action('Setting DBMS Registry for APEX to valid');
        sys.dbms_registry.valid('APEX');
    end if;
    --
    log_action('Exiting validate_apex');
exception when others then
    sys.dbms_registry.invalid('APEX');
    error('Error in validate_apex: '||sqlerrm);
    p(sys.dbms_utility.format_error_backtrace);
end validate_apex;
/
show errors
