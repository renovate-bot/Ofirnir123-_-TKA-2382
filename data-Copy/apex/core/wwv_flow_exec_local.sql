set define '^'
set verify off
prompt ...wwv_flow_exec_local
create or replace package wwv_flow_exec_local
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_local.sql
--
--    DESCRIPTION
--      This package is used to select, insert, update and delete rows from
--      a local database. In addition it can also be used to execute PL/SQL code
--      on a local database.
--
--    MODIFIED   (MM/DD/YYYY)
--    pawolf      03/20/2017 - Created
--    cczarski    06/20/2017 - added get_query_row_count for report pagination
--    pawolf      07/19/2017 - Simplified p_parse_as_schema and p_is_user to p_parse_as_schema_override
--    pawolf      07/26/2017 - Added optimizer_hint (feature #1107)
--    pawolf      08/09/2017 - In describe_query: added parameter p_test_for_rowid
--    cczarski    09/28/2017 - moved t_context from wwv_flow_exec_api to wwv_flow_exec
--    cczarski    09/29/2017 - added open_plsql_context to execute PL/SQL code
--    pawolf      10/10/2017 - Added check_plsql
--    cczarski    02/05/2018 - code changes in order to allow wrapped SQL queries growing larger than 32K
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================

--==============================================================================
-- Constants
--==============================================================================




--==============================================================================
-- This procedure opens a "local database" query context.
--==============================================================================
procedure open_query_context (
    p_context                  in out nocopy wwv_flow_exec.t_context,
    p_columns                  in            wwv_flow_exec_api.t_columns,
    -- Should only be used by INTERNAL apps to execute the statement with a schema of the
    -- current workspace, instead of using APEX_xxxxxx
    p_parse_as_schema_override in            varchar2                    default null );

--==============================================================================
-- $$$
--==============================================================================
procedure populate_buffer (
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- Re-executes the SQL Statement assigned to the given context. Useful when a SQL
-- is to be executed repeatedly with different bind values for each execute.
--==============================================================================
procedure re_execute_query (
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- This procedure cleans up an existing context.
--==============================================================================
procedure close_context (
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- This function checks if the SQL query is valid and returns the columns
-- returned by the query.
--==============================================================================
function describe_query (
    p_sql_query                in varchar2,
    p_optimizer_hint           in varchar2 default null,
    --
    p_test_for_rowid           in boolean  default false,
    p_parse_as_schema_override in varchar2 default null )
    return wwv_flow_exec_api.t_columns;

function describe_query (
    p_sql_query                in wwv_flow_global.vc_arr2,
    p_optimizer_hint           in varchar2 default null,
    --
    p_test_for_rowid           in boolean  default false,
    p_parse_as_schema_override in varchar2 default null )
    return wwv_flow_exec_api.t_columns;

--==============================================================================
-- This procedure opens a "local database" execute PLSQL context.
--==============================================================================
procedure open_plsql_context(
    p_context                  in out nocopy wwv_flow_exec.t_context,
    p_parse_as_schema_override in            varchar2   default null ); 

--==============================================================================
-- Checks a PL/SQL anonymous block against the local database and
-- returns the validation error as result.
--==============================================================================
function check_plsql (
    p_plsql_code      in varchar2,
    p_parse_as_schema in varchar2 )
    return varchar2;

end wwv_flow_exec_local;
/
show errors
