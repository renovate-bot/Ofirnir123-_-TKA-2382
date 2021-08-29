set define '^'
set verify off
prompt ...wwv_flow_exec
create or replace package wwv_flow_exec
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec.sql
--
--    DESCRIPTION
--      This package is used to select, insert, update and delete rows from
--      different data locations (local-, remote database and web services).
--      In addition it can also be used to execute PL/SQL code on a local and
--      remote database.
--
--    MODIFIED   (MM/DD/YYYY)
--    pawolf      03/17/2017 - Created
--    pawolf      04/10/2017 - Fixed anydata reference
--    pawolf      05/13/2017 - Continued development
--    cczarski    06/20/2017 - made changes to integrate Classic Reports
--    pawolf      06/21/2017 - Exposed generate_sql_query
--    pawolf      07/19/2017 - Simplified p_parse_as_schema and p_is_user to p_parse_as_schema_override
--    pawolf      07/26/2017 - Added optimizer_hint (feature #1107)
--    cczarski    08/01/2017 - Added flashback_minutes, return_distinct_rows and component_sql arguments
--    pawolf      09/27/2017 - Moved plugin_util.open_query_context to wwv_flow_exec*
--    cczarski    09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec
--    cczarski    09/29/2017 - Added open_process_context to execute remote PL/SQL 
--    pawolf      10/09/2017 - In open_process_context: added p_auto_bind_items
--    cczarski    12/07/2017 - moved wwv_flow_exec.c_inner_query constant to wwv_flow_exec_api.c_data_source_table_name
--    pawolf      12/18/2017 - Added p_include_rowid_column
--    cczarski    12/18/2017 - Added parameters to pass component ID and component type to exec_remote for caching
--    cczarski    12/20/2017 - Added new parameter source_post_processing, external_filter_expr and external_order_by_expr
--    cczarski    02/05/2018 - code changes in order to allow wrapped SQL queries growing larger than 32K
--    cczarski    03/06/2018 - added p_set_session_state parameter to open_query_context calls (for plug-in development)
--    cczarski    03/16/2018 - added "page_items_to_sessionstate" context attribute and parameters to have items references by SQL 
--    cczarski    05/29/2018 - In open_query_context: Change default for p_do_substitutions to "true" (bug #28075855)
--    cczarski    07/06/2018 - added t_context.use_sql_pagination
--    cczarski    07/10/2018 - removed debug; we now have wwv_flow_debug.log_vc_array
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================

subtype t_source_post_processing is pls_integer range 1..3;

--------------------------------------------------------------------------------
-- Column values 
type t_anydata_table is table of sys.anydata index by pls_integer;

type t_column_values is record (
    varchar2_values      sys.dbms_sql.varchar2_table,
    number_values        sys.dbms_sql.number_table,
    date_values          sys.dbms_sql.date_table,
    timestamp_values     sys.dbms_sql.timestamp_table,
    timestamp_tz_values  sys.dbms_sql.timestamp_with_time_zone_table,
    timestamp_ltz_values sys.dbms_sql.timestamp_with_ltz_table,
    interval_y2m_values  sys.dbms_sql.interval_year_to_month_table,
    interval_d2s_values  sys.dbms_sql.interval_day_to_second_table,
    blob_values          sys.dbms_sql.blob_table,
    bfile_values         sys.dbms_sql.bfile_table,
    clob_values          sys.dbms_sql.clob_table,
    anydata_values       t_anydata_table );
    
type t_columns_values is table of t_column_values index by pls_integer;

--------------------------------------------------------------------------------
-- for BULK DML: Array with records to report on status (Success / Failure / SQL Message ) for each row
type t_row_dml_result is record (
    row_idx             pls_integer,
    sqlcode             pls_integer,        
    sqlerrm             varchar2(32767) );

type t_bulk_dml_result is table of t_row_dml_result index by pls_integer;

--------------------------------------------------------------------------------
-- SQL Statement information - SQL, Remote Server, Binds, Offset and Limit
type t_sql_statement is record (
    sql_text                     varchar2(32767),                        -- SQL to execute 
    sql_text_array               wwv_flow_global.vc_arr2,
    optimizer_hint               varchar2(32767),
    total_row_count              boolean          default false,
    total_row_count_limit        number,
    total_row_count_column_idx   pls_integer,
    items                        wwv_flow_dynamic_exec.t_bind_variables, -- Items referenced by SQL
    auto_bind_items              boolean,
    page_items_to_sessionstate   boolean          default false,
    remote_server_id             number,
    force_single_row_fetch       boolean          default false,
    -- DML specific
    dml_row_count                pls_integer,
    dml_columns                  wwv_flow_exec_api.t_columns,            -- column metadata for DML contexts (to build TO_XXXXX expressions)
    dml_return_columns           wwv_flow_t_varchar2,                    -- list of columns for the RETURNING clause
    dml_columns_values           t_columns_values,                       -- column values for DML contexts.
    -- Query specific
    first_row                    pls_integer,                            -- pagination request from APEX component, NULL to start on first page
    max_rows                     pls_integer,                            -- pagination request from APEX component, NULL for default page size
    use_sql_pagination           boolean          default true );

--------------------------------------------------------------------------------
-- web source specific
type t_web_source is record (
    -- common 
    module_id                number,
    operation_id             number,
    web_src_parameters       wwv_flow_exec_api.t_parameters,
    --
    filter_expr              varchar2(32767),
    order_by_expr            varchar2(32767),
    component_sql            varchar2(32767),
    --
    post_processing_type     t_source_post_processing,
    post_processing_where    varchar2(32767),
    post_processing_order_by varchar2(32767),
    post_processing_sql      varchar2(32767),
    --
    filters                  wwv_flow_exec_api.t_filters,
    order_bys                wwv_flow_exec_api.t_order_bys,
    -- 
    first_row                pls_integer,
    max_rows                 pls_integer,
    --
    dml_columns              wwv_flow_exec_api.t_columns,        -- column metadata for DML contexts (to build TO_XXXXX expressions)
    dml_columns_values       t_columns_values );                 -- column values for DML contexts.

--------------------------------------------------------------------------------
-- Query Result information (description, data and status information)
type t_query_result is record (
    fetched_row_count  pls_integer,
    buffered_row_count pls_integer,
    current_array_idx  pls_integer,
    current_row_idx    pls_integer,        -- next_row() increases this one; then <buffered_row_count> is reached, next fetch is done.
    --
    total_row_count    number,             -- total result row count, when requested
    has_more           boolean,
    bulk_fetch         boolean,            -- local db
    --
    sqlcode            pls_integer,
    error_message      varchar2(32767),
    --
    query_columns      wwv_flow_exec_api.t_columns,
    columns_values     t_columns_values ); 

--------------------------------------------------------------------------------
-- DML Result information (description, data and status information)
type t_sql_nonquery_result is record (
    sqlcode            pls_integer,
    error_message      varchar2(32767),
    affected_row_count pls_integer,
    out_parameters     wwv_flow_exec_api.t_parameters,
    --                                        -- Bulk-related information
    returning_columns  t_columns_values,      -- RETURNING values for each row for DML statement
    bulk_dml_result    t_bulk_dml_result );   -- succcess / failure information for each row

--------------------------------------------------------------------------------
-- Web Source result - particularly temporary LOBs 
type t_web_source_response is record(
    has_more       boolean,
    last_fetched   varchar2(32767),
    out_parameters wwv_flow_exec_api.t_parameters,
    status_code    pls_integer );


--------------------------------------------------------------------------------
-- Context types ...
subtype t_context_type is pls_integer range 1..6;

--------------------------------------------------------------------------------
-- finally: The CONTEXT object
type t_context is record (
    context_type        t_context_type,
    location            wwv_flow_exec_api.t_location,
    cursor_id           integer,        -- local SQL cursor ID if exists
    set_session_state   boolean, 
    in_parameters       wwv_flow_exec_api.t_parameters,        -- Bind variables
    sql_statement       t_sql_statement,
    web_source          t_web_source,
    query_result        t_query_result,
    sql_nonquery_result t_sql_nonquery_result,
    web_source_response t_web_source_response );


--==============================================================================
-- Constants
--==============================================================================
c_context_query              constant t_context_type := 1;
c_context_dml_fetch_row      constant t_context_type := 2;
c_context_dml_insert         constant t_context_type := 3;
c_context_dml_update         constant t_context_type := 4;
c_context_dml_delete         constant t_context_type := 5;
c_context_plsql              constant t_context_type := 6;

c_total_row_count_column     constant varchar2(20) := 'APEX$TOTAL_ROW_COUNT';
c_rowid_alias                constant varchar2(16) := 'APEX$ROWID_ALIAS';

c_empty_dml_result           t_bulk_dml_result;

c_post_proc_where_orderby    constant t_source_post_processing := 1;
c_post_proc_sql              constant t_source_post_processing := 2;
c_post_proc_plsql_return_sql constant t_source_post_processing := 3;

--==============================================================================
-- Returns a query context type for the current region source/item lov/process source.
--==============================================================================
procedure open_query_context (
    p_context                    in out nocopy t_context,
    p_columns                    in wwv_flow_exec_api.t_columns    default wwv_flow_exec_api.c_empty_columns,
    p_select_all_query_cols      in boolean                        default false,
    p_use_generic_columns        in boolean                        default false,
    p_generic_column_cnt         in pls_integer                    default 50,
    p_first_row                  in pls_integer                    default null,
    p_max_rows                   in pls_integer                    default null,
    --
    p_return_distinct_rows       in boolean                        default false,
    p_flashback_minutes          in pls_integer                    default null,
    --
    p_component_sql              in varchar2                       default null,
    --
    p_total_row_count            in boolean                        default false,
    p_total_row_count_limit      in number                         default null,
    --
    p_force_single_row_fetch     in boolean                        default false,
    --
    p_filters                    in wwv_flow_exec_api.t_filters    default wwv_flow_exec_api.c_empty_filters,
    p_order_bys                  in wwv_flow_exec_api.t_order_bys  default wwv_flow_exec_api.c_empty_order_bys,
    --
    p_sql_parameters             in wwv_flow_exec_api.t_parameters default wwv_flow_exec_api.c_empty_parameters,
    --
    p_set_session_state          in boolean                        default false,
    p_page_items_to_sessionstate in boolean                        default false,
    -- legacy
    p_do_substitutions           in boolean                        default true,
    -- Should only be used by INTERNAL apps to execute the statement with a schema of the
    -- current workspace, instead of using APEX_xxxxxx
    p_parse_as_schema_override   in varchar2                       default null );

--==============================================================================
-- xxx
-- a) open a context for queries (rows to be fetched)
--    supports bulk fetches
--==============================================================================
procedure open_query_context (
    p_context                    in out nocopy t_context,
    p_location                   in            wwv_flow_exec_api.t_location,
    p_remote_server_id           in            number                           default null,
    p_web_src_module_id          in            number                           default null,
    --
    p_query_type                 in            wwv_flow_exec_api.t_query_type,  
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_owner                      in            varchar2                         default null,
    p_table_name                 in            varchar2                         default null,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query
    p_sql_query                  in            varchar2                         default null,
    -- Used by wwv_flow_exec_api.c_query_type_func_return_sql
    p_plsql_function_body        in            varchar2                         default null,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_where_clause               in            varchar2                         default null,
    p_include_rowid_column       in            boolean                          default null,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query, wwv_flow_exec_api.c_query_type_func_return_sql and if p_where_clause is set
    p_order_by_clause            in            varchar2                         default null,
    p_source_post_processing     in            t_source_post_processing         default null,
    -- Used by wwv_flow_exec_api.t_query_type_table, wwv_flow_exec_api.t_query_type_sql_query and wwv_flow_exec_api.c_query_type_func_return_sql
    p_optimizer_hint             in            varchar2                         default null,
    -- Used by p_where_clause, p_order_by_clause, wwv_flow_exec_api.t_query_type_sql_query and wwv_flow_exec_api.c_query_type_func_return_sql
    p_use_generic_columns        in            boolean                          default false,
    p_generic_column_cnt         in            pls_integer                      default 50,
    --
    p_return_distinct_rows       in            boolean                          default false,
    p_flashback_minutes          in            pls_integer                      default null,
    --
    p_component_sql              in            varchar2                         default null,
    -- 
    p_auto_bind_items            in            boolean                          default true,
    p_sql_parameters             in            wwv_flow_exec_api.t_parameters   default wwv_flow_exec_api.c_empty_parameters,
    --
    p_parameters                 in            wwv_flow_exec_api.t_parameters   default wwv_flow_exec_api.c_empty_parameters,
    -- Used by wwv_flow_exec_api.t_location_remote_db and wwv_flow_exec_api.t_location_web_source
    p_cache                      in            varchar2                         default null,
    p_cache_invalidation         in            varchar2                         default null,
    p_cache_comp_id              in            number                           default null,
    p_cache_comp_type            in            number                           default null,
    --
    p_external_filter_expr       in            varchar2                         default null,
    p_external_order_by_expr     in            varchar2                         default null,
    -- Used by all location and query types
    p_columns                    in            wwv_flow_exec_api.t_columns      default wwv_flow_exec_api.c_empty_columns,
    p_select_all_query_cols      in            boolean                          default false,
    --
    p_total_row_count            in            boolean                          default false,
    p_total_row_count_limit      in            number                           default null,
    --
    p_force_single_row_fetch     in            boolean                          default false,
    --
    p_first_row                  in            pls_integer                      default null,
    p_max_rows                   in            pls_integer                      default null,
    p_filters                    in            wwv_flow_exec_api.t_filters      default wwv_flow_exec_api.c_empty_filters,
    p_order_bys                  in            wwv_flow_exec_api.t_order_bys    default wwv_flow_exec_api.c_empty_order_bys,
    --
    p_set_session_state          in            boolean                          default false,
    -- legacy
    -- IR writes page items transparently to session state; need to do here as well
    p_page_items_to_sessionstate in            boolean                          default false,
    p_do_substitutions           in            boolean                          default true,
    -- Should only be used by INTERNAL apps to execute the statement with a schema of the
    -- current workspace, instead of using APEX_xxxxxx
    p_parse_as_schema_override   in            varchar2                         default null );
/*
-- b) open a context for DML (forms; IG; execute INSERT / UPDATE / DELETE on a table or "SQL Query")
--    supports bulk DML
function open_dml_context (
    p_dml_operation      in wwv_flow_exec_api.t_dml_operation,
    p_returning_columns  in wwv_flow_t_varchar2 default wwv_flow_exec_api.c_empty_list, -- $$$ do we need the format mask and data type?
    --
    p_location           in wwv_flow_exec_api.t_location,
    p_remote_server_id   in number       default null,
    --
    p_target_type        in wwv_flow_exec_api.t_target_type,
    -- Used by wwv_flow_exec_api.t_target_type_table
    p_owner              in varchar2     default null,
    p_table_name         in varchar2     default null,
    -- Used by wwv_flow_exec_api.t_target_type_sql_query
    p_sql_statement      in varchar2     default null,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_where_clause       in varchar2     default null, -- $$$ ???
    --
    p_auto_bind_items    in boolean      default true,
    p_binds              in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    --
    -- Used by local database
    p_parse_as_schema    in varchar2 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema     in boolean  default null,
    -- legacy
    p_do_substitutions   in boolean  default false )
    return t_context;

-- c) open a context for any PL/SQL code - not connected to a table, form or report
--    no support for bulk ...? 
function open_plsql_context (
    p_location         in wwv_flow_exec_api.t_location,
    p_remote_server_id in number   default null,
    p_plsql_code       in varchar2,
    -- Used by local database
    p_parse_as_schema  in varchar2 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema   in boolean  default null,
    -- legacy
    p_do_substitutions in boolean  default false )
    return t_context;
*/
--==============================================================================
-- Returns the result column count
--==============================================================================
function get_column_count (
    p_context in out nocopy t_context )
    return pls_integer;

--==============================================================================
-- Returns an array with column metadata
--==============================================================================
function get_columns (
    p_context in out nocopy t_context )
    return wwv_flow_exec_api.t_columns;

--==============================================================================
-- Returns the total row count of a query context, if available
--==============================================================================
function get_row_count(
    p_context in out nocopy t_context )
    return number;

--==============================================================================
-- Returns the array index for a given column alias
--==============================================================================
function get_column_idx (
    p_context           in out nocopy t_context, 
    p_attribute_label   in            varchar2,
    p_column_name       in            varchar2,
    p_is_required       in            boolean,
    p_data_type         in            varchar2 default wwv_flow_exec_api.c_data_type_varchar2 )
    return pls_integer;

--==============================================================================
-- Re-executes the SQL Statement assigned to the given context. Useful when a SQL
-- is to be executed repeatedly with different bind values for each execute.
--==============================================================================
procedure re_execute_query (
    p_context    in out nocopy t_context,
    p_parameters in            wwv_flow_exec_api.t_parameters default wwv_flow_exec_api.c_empty_parameters );
/*
--==============================================================================
-- Executes the SQL Statement assigned to the given context. Useful when a SQL is to be executed repeatedly
-- with different bind values for each execute.
--==============================================================================
procedure execute_dml (
    p_context in out nocopy t_context, 
    p_columns in out nocopy wwv_flow_exec_api.t_columns,    -- bound for each row
    p_binds   in            wwv_flow_exec_api.t_binds   default wwv_flow_exec_api.c_empty_binds );    -- bound once for DML statement

--==============================================================================
-- Executes the PL/SQL Statement assigned to the given context. Useful when a SQL is to be executed repeatedly
-- with different bind values for each execute.
--==============================================================================
procedure execute_plsql (
    p_context in out nocopy t_context, 
    -- bulk would require to pass an array of t_binds ... do we need that for arbitrary SQL or PL/SQL ...?
    p_binds   in            wwv_flow_exec_api.t_binds   default wwv_flow_exec_api.c_empty_binds );    
*/
--==============================================================================
-- Data fetching functions. 
--==============================================================================

--==============================================================================
-- This function advances one row in the result data. When the last row in the
-- buffer has been reached, the next bulk fetch is executed. For remote SQL,
-- when the last row in the buffer has been reached, the next result page
-- is fetched from the remote server.
--==============================================================================
function next_row (
    p_context in out nocopy t_context )
    return boolean;

function get_varchar2 (
    p_context     in out nocopy t_context,
    p_column_idx  in pls_integer,
    p_raise_error in boolean     default true )
    return varchar2;  

function get_number (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return number;  

function get_date (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return date;  

function get_timestamp (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return timestamp;  

function get_timestamp_tz (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return timestamp with time zone;  

function get_timestamp_ltz (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return timestamp with local time zone;  

function get_blob (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return blob;  

function get_bfile (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return bfile;  

function get_clob (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return clob;  

function get_intervaly2m (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return interval year to month;  

function get_intervald2s (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return interval day to second;  

function get_anydata (
    p_context    in out nocopy t_context,
    p_column_idx in pls_integer )
    return sys.anydata;  

--==============================================================================
-- XXX. $$$ Should we call it set_session_state_row or set_row_in_session_state???
--
-- p_context: ...
-- p_row_num: ...
--==============================================================================
procedure set_session_state (
    p_context in out nocopy t_context );

--==============================================================================
-- XXX. $$$
--==============================================================================
procedure clear_session_state;

--==============================================================================
-- This procedure cleans up an existing open_xyz context.
--==============================================================================
procedure close_context (
    p_context in out nocopy t_context );

--==============================================================================
-- Returns a "execute PL/SQL" context type 
--==============================================================================
procedure open_process_context(
    p_context                  in out nocopy t_context,
    p_location                 in            wwv_flow_exec_api.t_location,
    --
    p_remote_server_id         in            number                           default null,
    --
    p_web_src_operation_id     in            number                           default null,
    p_parameters               in            wwv_flow_exec_api.t_parameters   default wwv_flow_exec_api.c_empty_parameters,
    --
    p_plsql_code               in            varchar2                         default null,
    p_auto_bind_items          in            boolean                          default true,
    p_sql_parameters           in            wwv_flow_exec_api.t_parameters   default wwv_flow_exec_api.c_empty_parameters,
    --
    p_do_substitutions         in            boolean                          default false,
    p_parse_as_schema_override in            varchar2                         default null );

--
--
--==============================================================================
-- Executes PL/SQL code locally or remotely, based on component or plug-in setting
--==============================================================================
procedure open_process_context (
    p_context                  in out nocopy t_context,
    p_plsql_code               in            varchar2                       default null,
    --
    p_auto_bind_items          in            boolean                        default true,
    p_sql_parameters           in            wwv_flow_exec_api.t_parameters default wwv_flow_exec_api.c_empty_parameters,
    --
    p_do_substitutions         in            boolean                        default false,
    p_parse_as_schema_override in            varchar2                       default null );

/*
--==============================================================================
-- Executes a PL/SQL expression and returns a VARCHAR2 result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns string.
--==============================================================================
function get_plsql_expr_result_varchar2 (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_plsql_expression in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return varchar2;

--==============================================================================
-- Executes a PL/SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns boolean.
--==============================================================================
function get_plsql_expr_result_boolean (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_plsql_expression in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a PL/SQL function code block and returns a VARCHAR2 result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns string.
--                   For example:
--                   declare
--                       l_test varchar2(10);
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================
function get_plsql_func_result_varchar2 (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_plsql_function   in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema,
    p_do_substitutions in boolean )
    return varchar2;

--==============================================================================
-- Executes a PL/SQL function code block and returns a CLOB result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns a clob.
--                   For example:
--                   declare
--                       l_test clob;
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================
function get_plsql_func_result_clob (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_plsql_function   in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return clob;

--==============================================================================
-- Executes a PL/SQL function code block and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns boolean.
--                   For example:
--                   declare
--                       l_test boolean;
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================
function get_plsql_func_result_boolean (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_plsql_function   in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a PL/SQL code block.
--
-- The procedure automatically performs the necessary binding of bind variables.
--==============================================================================
procedure execute_plsql_code (
    p_location             in varchar2,
    p_remote_server_id     in number                    default null,
    p_plsql_code           in varchar2,
    p_auto_bind_items      in boolean                   default true,
    p_binds                in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema      in varchar2                  default wwv_flow_security.g_parse_as_schema,
    p_commit_session_state in boolean                   default true );

--==============================================================================
-- Executes a SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_expression: SQL expression which will be wrapped by
--                   select count(*) from dual where <p_sql_expression>.
--                   a row count of 0 returns FALSE otherwise TRUE.
--==============================================================================
function get_sql_expr_result_boolean (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_sql_expression   in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a SQL statement and returns TRUE if rows exist and FALSE if no row
-- is returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement which will be wrapped by
--                  select count(*) from dual where exists (<p_sql_statement>).
--==============================================================================
function do_rows_exist (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_sql_statement    in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a SQL statement which contains one VARCHAR2 column and returns the
-- value of the first row. If the SQL statement doesn't return any rows or the
-- SQL statement itself is NULL then NULL will be returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement with one VARCHAR2 column.
--==============================================================================
function get_first_row_result_varchar2 (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_sql_statement    in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema   in boolean                   default null )
    return varchar2;

--==============================================================================
-- Executes a SQL statement which contains one NUMBER column and returns the
-- value of the first row. If the SQL statement doesn't return any rows or the
-- SQL statement itself is NULL then NULL will be returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement with one NUMBER column.
--==============================================================================
function get_first_row_result_number (
    p_location         in varchar2,
    p_remote_server_id in number                    default null,
    p_sql_statement    in varchar2,
    p_auto_bind_items  in boolean                   default true,
    p_binds            in wwv_flow_exec_api.t_binds default wwv_flow_exec_api.c_empty_binds,
    p_parse_as_schema  in varchar2                  default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema   in boolean                   default null )
    return number;
*/
--==============================================================================
-- Based on the p_query_type, a SQL query is returned in the p_sql_text
-- record type.
-- This API will only work for t_location_local_db and t_location_remote_db.
--==============================================================================
procedure generate_sql_query (
    p_parameters               in out nocopy wwv_flow_exec_api.t_parameters,
    p_sql_text_array           in out nocopy wwv_flow_global.vc_arr2,
    --
    p_query_type               in wwv_flow_exec_api.t_query_type,
    p_location                 in wwv_flow_exec_api.t_location,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_owner                    in varchar2,
    p_table_name               in varchar2,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query
    p_sql_query                in varchar2,
    -- Used by wwv_flow_exec_api.c_query_type_func_return_sql
    p_plsql_function_body      in varchar2,
    -- Used by wwv_flow_exec_api.t_query_type_table and wwv_flow_exec_api.t_location_web_source
    p_where_clause             in varchar2,
    p_order_by_clause          in varchar2,
    p_include_rowid_column     in boolean,
    -- Used by all location and query types
    p_columns                  in wwv_flow_exec_api.t_columns      default wwv_flow_exec_api.c_empty_columns,
    p_select_all_query_cols    in boolean                          default false,
    p_filters                  in wwv_flow_exec_api.t_filters      default wwv_flow_exec_api.c_empty_filters,
    p_order_bys                in wwv_flow_exec_api.t_order_bys    default wwv_flow_exec_api.c_empty_order_bys,
    --
    p_return_distinct_rows     in boolean                          default false,
        
    p_flashback_minutes        in pls_integer                      default null,
    --
    p_component_sql            in varchar2                         default null,
    --
    p_total_row_count          in boolean                          default false,
    p_total_row_count_limit    in number                           default null,
    -- legacy
    p_do_substitutions         in boolean                          default false,
    --
    -- Should only be used by INTERNAL apps to execute the statement with a schema of the
    -- current workspace, instead of using APEX_xxxxxx
    p_parse_as_schema_override in varchar2                         default null,
    -- Should only be used by INTERNAL apps to execute the PL/SQL function with the privileges of APEX_xxxxxx
    -- but the SQL query itself with the schema of the workspace
    p_parse_plsql_func_as_apex in boolean                          default false );

procedure generate_sql_query (
    p_parameters               in out nocopy wwv_flow_exec_api.t_parameters,
    p_sql_text                 in out nocopy varchar2,
    --
    p_query_type               in wwv_flow_exec_api.t_query_type,
    p_location                 in wwv_flow_exec_api.t_location,
    -- Used by wwv_flow_exec_api.t_query_type_table
    p_owner                    in varchar2,
    p_table_name               in varchar2,
    -- Used by wwv_flow_exec_api.t_query_type_sql_query
    p_sql_query                in varchar2,
    -- Used by wwv_flow_exec_api.c_query_type_func_return_sql
    p_plsql_function_body      in varchar2,
    -- Used by wwv_flow_exec_api.t_query_type_table and wwv_flow_exec_api.t_location_web_source
    p_where_clause             in varchar2,
    p_order_by_clause          in varchar2,
    p_include_rowid_column     in boolean,
    -- Used by all location and query types
    p_columns                  in wwv_flow_exec_api.t_columns      default wwv_flow_exec_api.c_empty_columns,
    p_select_all_query_cols    in boolean                          default false,
    p_filters                  in wwv_flow_exec_api.t_filters      default wwv_flow_exec_api.c_empty_filters,
    p_order_bys                in wwv_flow_exec_api.t_order_bys    default wwv_flow_exec_api.c_empty_order_bys,
    --
    p_return_distinct_rows     in boolean                          default false,
        
    p_flashback_minutes        in pls_integer                      default null,
    --
    p_component_sql            in varchar2                         default null,
    --
    p_total_row_count          in boolean                          default false,
    p_total_row_count_limit    in number                           default null,
    -- legacy
    p_do_substitutions         in boolean                          default false,
    --
    -- Should only be used by INTERNAL apps to execute the statement with a schema of the
    -- current workspace, instead of using APEX_xxxxxx
    p_parse_as_schema_override in varchar2                         default null,
    -- Should only be used by INTERNAL apps to execute the PL/SQL function with the privileges of APEX_xxxxxx
    -- but the SQL query itself with the schema of the workspace
    p_parse_plsql_func_as_apex in boolean                          default false );

end wwv_flow_exec;
/
show errors
