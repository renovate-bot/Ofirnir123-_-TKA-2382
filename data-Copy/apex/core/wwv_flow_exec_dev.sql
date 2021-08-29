set define '^'
set verify off
prompt ...wwv_flow_exec_dev
create or replace package wwv_flow_exec_dev
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_dev.sql
--
--    DESCRIPTION
--      This package is used to to check and describe SQL and PL/SQL for
--      local and remote data sources and web sources.
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    06/14/2017 - Created
--    pawolf      06/21/2017 - Continue implementation
--    pawolf      07/26/2017 - Added optimizer_hint (feature #1107)
--    cczarski    08/16/2017 - Exposed p_test_for_rowid argument
--    pawolf      10/10/2017 - Added check_plsql
--    pawolf      11/30/2017 - In check_and_describe, get_query_columns and check_plsql: added p_parse_as_schema
--    cczarski    12/21/2017 - In check_and_describe: added p_post_processing_type
--    cczarski    02/05/2018 - code changes in order to allow wrapped SQL queries growing larger than 32K
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================


type t_describe_result is record (
    query_columns       wwv_flow_exec_api.t_columns,
    has_order_by_clause boolean,
    error_message       varchar2( 32767 ));

type t_query_column is record(
    column_name      wwv_flow_global.t_dbms_id,
    data_type        wwv_flow_global.t_dbms_id,
    column_name_esc  varchar2(255)
);

type t_query_columns is table of t_query_column;

--==============================================================================
-- Constants
--==============================================================================
subtype t_plsql_check_type is pls_integer range 1..5;

c_check_plsql               constant t_plsql_check_type := 1;
c_check_plsql_expr_varchar2 constant t_plsql_check_type := 2;
c_check_plsql_expr_boolean  constant t_plsql_check_type := 3;
c_check_plsql_func_varchar2 constant t_plsql_check_type := 4;
c_check_plsql_func_boolean  constant t_plsql_check_type := 5;

--==============================================================================
-- Describes a SQL statement and returns the selected columns used in the SQL.
--==============================================================================
function check_and_describe (
    p_location             in wwv_flow_exec_api.t_location default wwv_flow_exec_api.c_location_local_db,
    p_remote_server_id     in number                       default null,
    --
    p_query_type           in wwv_flow_exec_api.t_query_type,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_owner                in varchar2                     default null,
    p_table_name           in varchar2                     default null,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query
    p_sql_query            in varchar2                     default null,
    -- Used by wwv_flow_exec_api.c_query_type_func_return_sql
    p_plsql_function_body  in varchar2                     default null,
    p_generic_column_count in number                       default null,
    -- Used by wwv_flow_exec_api.t_query_type_table and wwv_flow_exec_api.t_location_web_source
    p_where_clause         in varchar2                     default null,
    p_order_by_clause      in varchar2                     default null,
    -- Used by wwv_flow_exec_api.t_query_type_table, wwv_flow_exec_api.t_query_type_sql_query and wwv_flow_exec_api.c_query_type_func_return_sql
    p_optimizer_hint       in varchar2                     default null,
    --
    p_test_for_rowid       in boolean                      default false,
    --
    p_web_src_module_id    in number                       default null,
    p_post_processing_type in varchar2                     default null,
    --
    p_columns              in wwv_flow_exec_api.t_columns  default wwv_flow_exec_api.c_empty_columns,
    p_min_column_count     in pls_integer                  default null,
    p_max_column_count     in pls_integer                  default null,
    -- Used by local database
    p_application_id       in number                       default nv( 'FB_FLOW_ID' ),
    p_parse_as_schema      in varchar2                     default null,
    -- legacy
    p_do_substitutions     in boolean                      default false )
    return t_describe_result;

--==============================================================================
-- Describes a SQL statement and returns the selected columns used in the SQL
-- as a table function to be used by LOVs within the Builder
--==============================================================================
function get_query_columns (
    p_location             in varchar2,
    p_remote_server_id     in number   default null,
    --
    p_query_type           in varchar2,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_owner                in varchar2 default null,
    p_table_name           in varchar2 default null,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query
    p_sql_query            in varchar2 default null,
    -- Used by wwv_flow_exec_api.c_query_type_func_return_sql
    p_plsql_function_body  in varchar2 default null,
    p_generic_column_count in number   default null,
    -- Used by wwv_flow_exec_api.t_query_type_table, wwv_flow_exec_api.t_query_type_sql_query and wwv_flow_exec_api.c_query_type_func_return_sql
    p_optimizer_hint       in varchar2    default null,
    --
    p_web_src_module_id    in number      default null,
    p_min_column_count     in pls_integer default null,
    p_max_column_count     in pls_integer default null,
    p_application_id       in number      default nv( 'FB_FLOW_ID' ),
    p_parse_as_schema      in varchar2    default null,
    -- legacy
    p_do_substitutions     in boolean  default false )
    return t_query_columns pipelined;

--==============================================================================
-- Returns true if p_sql_query contains an order by clause at the end.
-- Used by validations on 4000:420, 4000:4651, 4000:4796 and 4000:831 and
-- by check_and_describe_sql
--==============================================================================
function has_sql_query_order_by_clause (
    p_sql_query in clob )
    return boolean;

--==============================================================================
-- Checks a PL/SQL anonymous block against the local or remote database and
-- returns the validation error as result.
--==============================================================================
function check_plsql (
    p_location         in wwv_flow_exec_api.t_location default wwv_flow_exec_api.c_location_local_db,
    p_remote_server_id in number                       default null,
    p_type             in t_plsql_check_type           default c_check_plsql,
    p_plsql_code       in varchar2,
    -- Used by local database
    p_application_id   in number                       default nv( 'FB_FLOW_ID' ),
    p_parse_as_schema  in varchar2                     default null )
    return varchar2;

--==============================================================================
-- Maps the numeric column data type into a string.
--==============================================================================
function get_data_type_as_string (
    p_column in wwv_flow_exec_api.t_column )
    return varchar2;


end wwv_flow_exec_dev;
/
show errors
