set define '^' verify off
prompt ...wwv_flow_exec_api
create or replace package wwv_flow_exec_api authid current_user
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_api.sql
--
--    DESCRIPTION
--      This package encapsulates data processing and querying capabilities and provides an abstraction from the
--      data source to Application Express components and plug-ins.
--      It contains procedures and functions to execute queries or procedural calls on local and remote data 
--      sources as well as web source modules. It can be used for plug-in development as well as for procedural 
--      PL/SQL processing in applications or within packages and procedures.
--
--      All procedures require an APEX session to be set up. In a pure SQL or PL/SQL context, use the
--      APEX_SESSION package to initialize a new session.
--
--      The typical call sequence depends on the used data source.
--
--      1. REST Enabled SQL Data Sources
--         a) prepare bind variables with [optional]
--            - create a variable of APEX_EXEC.T_PARAMETERS type
--            - add bind values with APEX_EXEC.ADD_PARAMETER
--         b) execute the remote query call
--            - call APEX_EXEC.OPEN_REMOTE_SQL_QUERY
--         c) get column indexes for result column names
--            - call APEX_EXEC.GET_COLUMN_POSITION
--         d) loop until the result set is exhausted
--            - call APEX_EXEC.NEXT_ROW
--         e) retrieve column values for each column by position
--            - call APEX_EXEC.GET_VARCHAR2, APEX_EXEC.GET_NUMBER, APEX_EXEC.GET_DATE, ...
--         f) finally ALWAYS close the query context - IMPORTANT
--            - call APEX_EXEC.CLOSE
--
--      2. Web source module
--         a) prepare web source parameters variables with [optional]
--            - create a variable of APEX_EXEC.T_PARAMETERS type
--            - add bind values with APEX_EXEC.ADD_PARAMETER
--         b) prepare filters to be passed to the web source (if supported by the web source)
--            - create a variable of APEX_EXEC.T_FILTERS type
--            - add bind values with APEX_EXEC.ADD_FILTER
--         c) prepare order by expressions to be passed to the web source (if supported by the web source)
--            - create a variable of APEX_EXEC.T_ORDER_BYS type
--            - add bind values with APEX_EXEC.ADD_ORDER_BY
--         d) execute the remote query call
--            - call APEX_EXEC.OPEN_REMOTE_SQL_QUERY
--            - pass in filters, order bys and parameters previously prepared
--         e) get column indexes for result column names
--            - call APEX_EXEC.GET_COLUMN_POSITION
--         f) loop until the result set is exhausted
--            - call APEX_EXEC.NEXT_ROW
--         g) retrieve column values for each column by position
--            - call APEX_EXEC.GET_VARCHAR2, APEX_EXEC.GET_NUMBER, APEX_EXEC.GET_DATE, ...
--         h) finally ALWAYS close the query context - IMPORTANT
--            - call APEX_EXEC.CLOSE
--      
--      Make sure to always add an exception handler to your procedure or function which makes sure that
--      APEX_EXEC.CLOSE is being called in any case. This is important to release server resources like
--      database cursors, temporary lobs and others.
--
--    MODIFIED   (MM/DD/YYYY)
--    pawolf      03/17/2017 - Created
--    pawolf      04/11/2017 - Modified subtypes
--    cczarski    05/03/2017 - added subtype t_web_source and dependent subtypes
--    pawolf      05/18/2017 - added new filter types
--    pawolf      05/13/2017 - Continued development
--    pawolf      06/16/2017 - Added add_order_by
--    pawolf      07/26/2017 - Added optimizer_hint (feature #1107)
--    cczarski    08/03/2017 - Added "like", "search" and "sql expression" filter types (interactive report)
--    cczarski    08/10/2017 - Added is_end_user, is_aggregation column attributes; added ends_with filter constants
--    cczarski    08/13/2017 - Added support for positional order bys
--    cczarski    08/14/2017 - Added t_source_capabilities type
--    cczarski    09/04/2017 - Added "allow_fetch_all_rows" capability
--    cczarski    09/25/2017 - Added procedures to programmatically query a web source module or execute a remote query
--    pawolf      09/27/2017 - Moved plugin_util.open_query_context to wwv_flow_exec*
--    cczarski    09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec; changed API procedures to only
--                             return wwv_flow_exec_api.t_context as a numeric handle only
--    cczarski    09/29/2017 - Added open_remote_plsql, get_out_parameters and get_out_parameter to execute PL/SQL code  
--                             on the remote database and to get OUT binds back.
--                             changed direction of p_context from IN OUT NOCOPY to just IN
--    cczarski    10/04/2017 - Added more documentation; added ADD_COLUMN, GET_PARAMETER_XXXX procedures and functions
--    pawolf      10/09/2017 - Added overloaded execute_plsql
--    cczarski    10/09/2017 - Added is_remote_sql_auth_valid
--    cczarski    11/10/2017 - Change this package (public API APEX_EXEC) to AUTHID CURRENT_USER
--    cczarski    11/13/2017 - added get_data_type_vc2_plugin to convert t_data_tyoe to VC2 data types used by Plug-Ins
--    cczarski    12/07/2017 - exposed get_anydata function and p_component_sql argument in open_query_context
--    cczarski    12/07/2017 - moved wwv_flow_exec.c_inner_query constant to wwv_flow_exec_api.c_data_source_table_name
--    pawolf      01/23/2018 - Renamed #APEX_SOURCE_DATA# to #APEX$SOURCE_DATA#
--    cczarski    01/24/2018 - Added purge_web_src_cache
--    cczarski    01/26/2018 - In open_web_source_query: added external_filter_expr and external_order_by_expr arguments
--    pawolf      02/08/2018 - Added resolve_local_synonym
--    cczarski    03/06/2018 - added p_set_session_state parameter to open_query_context calls (for plug-in development)
--    cczarski    07/24/2018 - added open_query_context
--    cczarski    09/05/2018 - in execute_web_source: add NOCOPY for p_parameters to return them in case of an error (bug #28575023)
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================

--------------------------------------------------------------------------------
-- Generic

subtype t_column_name is varchar2(32767);

subtype t_data_type   is pls_integer range 1..13;

type t_value is record (
    varchar2_value      varchar2(32767),
    number_value        number,
    date_value          date,
    timestamp_value     timestamp,
    timestamp_tz_value  timestamp with time zone,
    timestamp_ltz_value timestamp with local time zone,
    interval_y2m_value  interval year to month,
    interval_d2s_value  interval day to second,
    blob_value          blob,
    bfile_value         bfile,
    clob_value          clob,
    anydata_value       sys.anydata );

type t_values is table of t_value index by pls_integer;

--------------------------------------------------------------------------------
-- Bind variables

type t_parameter is record (
    name      t_column_name,
    data_type t_data_type,
    value     t_value );

type t_parameters is table of t_parameter index by pls_integer;

--------------------------------------------------------------------------------
-- Column meta data

subtype t_lov_type is pls_integer range 1..3;

-- Internal type definition. ** DO NOT USE **
type t_lov is record (
    lov_type            t_lov_type,
    shared_lov_id       varchar2(32767),
    sql_query           varchar2(32767),
    static_values       varchar2(32767) ); 

-- Internal type definition. ** DO NOT USE **
type t_column is record (
    name                 t_column_name,
    sql_expression       varchar2(4000),
    -- when is_selected is false, the column will not added to the most outer select list
    is_selected          boolean default true,
    -- for analytic functions - apply these after filtering; otherwise apply before filtering to make the
    -- column available to filters
    is_aggregation       boolean default false,
    -- SQL expressions of end user columns can only work on columns specified in the p_columns array parameter
    is_end_user          boolean default true,
    -- required for Generic Columns. If COL25 has "Compute Sum" enabled, we generate a SUM (OVER) clause for it.
    -- When the base SQL query does not return COL25, we have to remove that derived column, so we need to know, on 
    -- which column it depends. 
    dependent_on         t_column_name,
    data_type            t_data_type,
    data_type_length     pls_integer,
    data_type_name       t_column_name, -- $$$ look for a better name
                                        -- required for "display as LOV" in interactive reports
    lov                  t_lov,
    format_mask          varchar2(4000),
    is_required          boolean default false,
    is_primary_key       boolean default false,
    is_query_only        boolean default false,
    is_checksum          boolean default false,
    is_returning         boolean default false );

type t_columns is table of t_column index by pls_integer;

--------------------------------------------------------------------------------
-- filters

subtype t_filter_type          is pls_integer range 1..27;
subtype t_filter_interval_type is varchar2(2);

type t_filter is record (
    column_name       t_column_name, -- $$$ should we reference the index of t_columns instead? -> Always require to specify p_columns? Would avoid having to specify data_type
    data_type         t_data_type,
    filter_type       t_filter_type,
    filter_values     t_values,
    sql_expression    varchar2(32767),
    search_columns    t_columns,
    null_result       boolean default false,
    is_case_sensitive boolean default true );

type t_filters is table of t_filter index by pls_integer;

--------------------------------------------------------------------------------
-- order bys

subtype t_order_direction is pls_integer range 1..2;
subtype t_order_nulls     is pls_integer range 1..2;

type t_order_by is record (
    column_name t_column_name, -- $$$ should we reference the index of t_columns instead? -> Always require to specify p_columns?
    position    pls_integer,   -- if given, we will generate the order by clause with a column position 
    lov         t_lov,
    direction   t_order_direction, 
    order_nulls t_order_nulls );

type t_order_bys is table of t_order_by index by pls_integer;

subtype t_location     is varchar2(12);

--------------------------------------------------------------------------------
-- Context handle

subtype t_context is pls_integer;

--------------------------------------------------------------------------------
-- data source capabilities 

type t_source_capabilities is record(
    location               t_location,
    --
    pagination             boolean default false,
    --
    allow_fetch_all_rows   boolean default false,
    --
    filtering              boolean default false,
    order_by               boolean default false,
    group_by               boolean default false,
    --
    filter_eq              boolean default false,
    filter_not_eq          boolean default false,
    filter_gt              boolean default false,
    filter_gte             boolean default false,
    filter_lt              boolean default false,
    filter_lte             boolean default false,
    filter_null            boolean default false,
    filter_not_null        boolean default false,
    filter_contains        boolean default false,
    filter_not_contains    boolean default false,
    filter_like            boolean default false,
    filter_not_like        boolean default false,
    filter_starts_with     boolean default false,
    filter_not_starts_with boolean default false,
    filter_between         boolean default false,
    filter_not_between     boolean default false,
    filter_in              boolean default false,
    filter_not_in          boolean default false,
    filter_regexp          boolean default false,
    filter_last            boolean default false,
    filter_not_last        boolean default false,
    filter_next            boolean default false,
    filter_not_next        boolean default false,
    --
    orderby_asc            boolean default false,
    orderby_desc           boolean default false,
    orderby_nulls          boolean default false );

--==============================================================================
-- Constants
--==============================================================================
c_data_source_table_name  constant varchar2(18) := '#APEX$SOURCE_DATA#';

--==============================================================================
-- INTERNAL constants - DO NOT USE
--==============================================================================
c_location_local_db       constant t_location  := 'LOCAL';
c_location_remote_db      constant t_location  := 'REMOTE';
c_location_web_source     constant t_location  := 'WEB_SOURCE';

c_lov_shared              constant t_lov_type  := 1;
c_lov_sql_query           constant t_lov_type  := 2;
c_lov_static              constant t_lov_type  := 3;

subtype t_query_type is varchar2(23);

c_query_type_table           constant t_query_type := 'TABLE';
c_query_type_sql_query       constant t_query_type := 'SQL';
c_query_type_func_return_sql constant t_query_type := 'FUNC_BODY_RETURNING_SQL';

subtype t_dml_operation is pls_integer range 1..3;

c_dml_operation_insert constant t_dml_operation := 1;
c_dml_operation_update constant t_dml_operation := 2;
c_dml_operation_delete constant t_dml_operation := 3;

subtype t_target_type is varchar2(5);

c_target_type_table     constant t_target_type := 'TABLE';
c_target_type_sql_query constant t_target_type := 'SQL';
c_target_type_plsql     constant t_target_type := 'PLSQL';

--==============================================================================
-- data type constants to be used in the ADD_FILTER or ADD_COLUMN procedures.
--==============================================================================
c_data_type_varchar2      constant t_data_type := 1;
c_data_type_number        constant t_data_type := 2;
c_data_type_date          constant t_data_type := 3;
c_data_type_timestamp     constant t_data_type := 4;
c_data_type_timestamp_tz  constant t_data_type := 5;
c_data_type_timestamp_ltz constant t_data_type := 6;
c_data_type_interval_y2m  constant t_data_type := 7;
c_data_type_interval_d2s  constant t_data_type := 8;
c_data_type_blob          constant t_data_type := 9;
c_data_type_bfile         constant t_data_type := 10;
c_data_type_clob          constant t_data_type := 11;
c_data_type_rowid         constant t_data_type := 12;
c_data_type_user_defined  constant t_data_type := 13;

--==============================================================================
-- filter type constants to be used in the ADD_FILTER procedures.
--==============================================================================
-- $$$ c_filter_row or would those be a separate input parameter? p_filter_row, p_oracle_text_index_column, p_oracle_text_function -> should p_oracle_text_function be application wide instead just for IG?

c_filter_eq              constant t_filter_type := 1;
c_filter_not_eq          constant t_filter_type := 2;
c_filter_gt              constant t_filter_type := 3;
c_filter_gte             constant t_filter_type := 4;
c_filter_lt              constant t_filter_type := 5;
c_filter_lte             constant t_filter_type := 6;
c_filter_null            constant t_filter_type := 7;
c_filter_not_null        constant t_filter_type := 8;
c_filter_starts_with     constant t_filter_type := 9;
c_filter_not_starts_with constant t_filter_type := 10;
c_filter_ends_with       constant t_filter_type := 11;
c_filter_not_ends_with   constant t_filter_type := 12;
c_filter_contains        constant t_filter_type := 13;
c_filter_not_contains    constant t_filter_type := 14;
c_filter_in              constant t_filter_type := 15;
c_filter_not_in          constant t_filter_type := 16;
c_filter_between         constant t_filter_type := 17;
c_filter_not_between     constant t_filter_type := 18;
c_filter_regexp          constant t_filter_type := 19;
-- date filters: days/months/...
c_filter_last            constant t_filter_type := 20;
c_filter_not_last        constant t_filter_type := 21;
c_filter_next            constant t_filter_type := 22;
c_filter_not_next        constant t_filter_type := 23;

-- interactive reports
c_filter_like            constant t_filter_type := 24;
c_filter_not_like        constant t_filter_type := 25;
c_filter_search          constant t_filter_type := 26;
c_filter_sql_expression  constant t_filter_type := 27;

c_filter_expr_sep       constant varchar2(1) := '~';
c_filter_expr_value_sep constant varchar2(1) := chr(1);

-- interval types for date filters (last, not last, next, not next)
c_filter_int_type_year   constant t_filter_interval_type := 'Y';
c_filter_int_type_month  constant t_filter_interval_type := 'M';
c_filter_int_type_week   constant t_filter_interval_type := 'W';
c_filter_int_type_day    constant t_filter_interval_type := 'D';
c_filter_int_type_hour   constant t_filter_interval_type := 'H';
c_filter_int_type_minute constant t_filter_interval_type := 'MI';

--==============================================================================
-- order by constants to be used in the ADD_FILTER procedures.
--==============================================================================
c_order_asc           constant t_order_direction := 1;
c_order_desc          constant t_order_direction := 2;

c_order_nulls_first   constant t_order_nulls := 1;
c_order_nulls_last    constant t_order_nulls := 2;

--==============================================================================
-- constants or empty filter, order by, columns or parameter arrays
--==============================================================================
c_empty_columns    t_columns;
c_empty_filters    t_filters;
c_empty_order_bys  t_order_bys;
c_empty_parameters t_parameters;

--==============================================================================
-- converts the t_data_type constant into the VARCHAR2 representation used by the
-- Plug-In infrastructure.
--==============================================================================
function get_data_type_vc2_plugin( 
    p_datatype_num in wwv_flow_exec_api.t_data_type ) return varchar2;

--==============================================================================
-- This procedure opens a query context based on the current region source/
-- item lov/process source.
--
-- PARAMETERS
--    p_columns                 columns to be selected from the data source
--    p_filters                 filters to be used
--    p_order_bys               order by expressions to be used
--
--    p_first_row               first row to be fetched
--    p_max_rows                maximum amount of rows to be fetched
--
--    p_total_row_count         whether to determine the total row count
--    p_total_row_count_limit   upper limit for the total row count computation
--
--    p_select_all_query_cols   when set to TRUE, the columns passed in p_columns
--                              will be selected *in addition* to the columns of
--                              the data source. Useful to compute derived values.
--
--    p_component_sql           SQL query which wraps the data source - typically used to apply
--                              SQL functions on the data returned by the data source. In this SQL query,
--                              use the "APEX_EXECC_DATA_SOURCE_NAME" constant as the table name for
--                              the actual data.
-- 
--    p_sql_parameters          bind variables to be used
--
-- RETURNS 
--    the context object representing a "cursor" for the query
--==============================================================================
function open_query_context (
    p_columns               in t_columns    default c_empty_columns,
    --
    p_filters               in t_filters    default c_empty_filters,
    p_order_bys             in t_order_bys  default c_empty_order_bys,
    --
    p_first_row             in pls_integer  default null,
    p_max_rows              in pls_integer  default null,

    p_total_row_count       in boolean      default false,
    p_total_row_count_limit in number       default null,
    --
    p_select_all_query_cols in boolean      default false,
    p_component_sql         in varchar2     default null,
    --
    p_sql_parameters        in t_parameters default c_empty_parameters,
    --
    p_set_session_state     in boolean      default false ) return t_context;

--==============================================================================
-- This procedure opens a Web Source query context. Based on the provided web source 
-- name, the operation matched to the FETCH_COLLECTION database operation will be
-- selected.
--
-- PARAMETERS
--    p_module_static_id        static ID of the web source module to invoke
-- 
--    p_parameters              parameter values to be passed to the web source
--    p_filters                 filters to be passed to the web source
--    p_order_bys               order by expressions to be passed to the web source
--    p_columns                 columns to be selected from the web source 
--
--    p_external_filter_expr    filter expression to be passed 1:1 to the external web service
--                              Depends on the actual web service being used.
--    p_external_order_by_expr  order by expression to be passed 1:1 to the external web service. 
--                              Depends on the actual web service being used.
--
--    p_first_row               first row to be fetched from the web source
--    p_max_rows                maximum amount of rows to be fetched from the web source
--   
--    p_total_row_count         wether to determine the total row count (only supported
--                              when the "allow fetch all rows" attribute is set to Yes)
--
-- RETURNS 
--    the context object representing a "cursor" for the web source query
--
-- EXAMPLE
--    the following example assumes a Web Source module named "USGS" to be 
--    created in Shared Components, based on the URL endpoint
--    https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson. The
--    example invokes the REST service and prints out the result set. This example code could
--    be used Within a plug-in or within a "Execute PL/SQL" region. 
--    
--    declare 
--        l_context apex_exec.t_context;
--        l_filters apex_exec.t_filters;
--        l_columns apex_exec.t_columns;
--        
--        l_row     pls_integer := 1;
--    
--        l_magidx  pls_integer;
--        l_titidx  pls_integer;
--        l_plcidx  pls_integer;
--        l_timidx  pls_integer;
--        l_ididx   pls_integer;
--    begin
--        l_context := apex_exec.open_web_source_query(
--            p_module_static_id => 'USGS',           -- use the Web Source Module static ID here
--            p_max_rows         => 1000 );
--    
--        l_titidx := apex_exec.get_column_position( l_context, 'TITLE' );
--        l_magidx := apex_exec.get_column_position( l_context, 'MAG' );
--        l_plcidx := apex_exec.get_column_position( l_context, 'PLACE' );
--        l_timidx := apex_exec.get_column_position( l_context, 'TIME' );
--        l_ididx  := apex_exec.get_column_position( l_context, 'ID' );
--    
--        while apex_exec.next_row( l_context ) loop
--    
--            htp.p( 'ID:    ' || apex_exec.get_varchar2( l_context, l_ididx  ) );
--            htp.p( 'MAG:   ' || apex_exec.get_varchar2( l_context, l_magidx ) );
--            htp.p( 'PLACE: ' || apex_exec.get_varchar2( l_context, l_plcidx ) );
--            htp.p( 'TITLE: ' || apex_exec.get_varchar2( l_context, l_titidx ) );
--            htp.p( 'TIME:  ' || apex_exec.get_varchar2( l_context, l_timidx ) );
--        end loop;
--        
--        apex_exec.close( l_context );
--    exception
--        when others then
--            apex_exec.close( l_context );
--            raise;    
--    end;
--    
--==============================================================================
function open_web_source_query(
    p_module_static_id       in varchar2,
    p_parameters             in t_parameters default c_empty_parameters,
    --
    p_filters                in t_filters    default c_empty_filters,
    p_order_bys              in t_order_bys  default c_empty_order_bys,
    p_columns                in t_columns    default c_empty_columns,
    --
    p_external_filter_expr   in varchar2     default null,
    p_external_order_by_expr in varchar2     default null,
    --
    p_first_row              in pls_integer  default null,
    p_max_rows               in pls_integer  default null,
    --
    p_total_row_count        in boolean      default false)
    return t_context;

--==============================================================================
-- This procedure purges the local cache for a Web Source module. The web source
-- module must exist in the current application and is being identified by its
-- static ID. If caching is disabled or no cache entries exist, nothing happens.
--
-- PARAMETERS
--    p_module_static_id        static ID of the web source module to invoke
--    p_current_session_only    specify true if you only want to purge entries that
--                              where saved for the current session. defaults to
--                              false.
--
-- EXAMPLE
--    Purge cache for the Web Source Module with static ID "USGS"
--    
--    begin
--        apex_exec.purge_web_source_cache(
--            p_module_static_id => 'USGS' );
--    end;
--    
--==============================================================================
procedure purge_web_source_cache(
    p_module_static_id     in varchar2,
    p_current_session_only in boolean default false );

--==============================================================================
-- This procedure opens a query context and executes the provided SQL query
-- on the ORDS REST Enabled SQL instance. 
--
-- PARAMETERS
--    p_server_static_id        static ID of the ORDS REST Enabled SQL Instance
--    p_sql_query               SQL Query to execute
--    p_sql_parameters          bind variables to pass to the remote server
--    p_auto_bind_items         whether to auto-bind all page items
-- 
--    p_first_row               first row to be fetched from the result set
--    p_max_rows                maximum amount of rows to be fetched 
--
--    p_total_row_count         wether to determine the total row count
--    p_total_row_count_limit   upper boundary for total row count computation
--
-- RETURNS 
--    the context object representing a "cursor" for the web source query
--
-- EXAMPLE
--
--    the following example assumes a REST enabled ORDS instance to be configured
--    in Shared Components as "My Remote SQL Instance". Based on that, the example
--    executes the query on the remote server and prints out the result set.
--    This example code could be used Within a plug-in or within a "Execute PL/SQL" region. 
--    
--    declare
--        l_context apex_exec.t_context;
--    
--        l_idx_empno    pls_integer;
--        l_idx_ename    pls_integer;
--        l_idx_job      pls_integer;
--        l_idx_hiredate pls_integer;
--        l_idx_mgr      pls_integer;
--        l_idx_sal      pls_integer;
--        l_idx_comm     pls_integer;
--        l_idx_deptno   pls_integer;
--    
--    begin
--        l_context := apex_exec.open_remote_sql_query(
--            p_server_static_id  => 'DevOps_Remote_SQL',
--            p_sql_query         => 'select * from emp' );
--    
--        l_idx_empno    := apex_exec.get_column_position( l_context, 'EMPNO'); 
--        l_idx_ename    := apex_exec.get_column_position( l_context, 'ENAME'); 
--        l_idx_job      := apex_exec.get_column_position( l_context, 'JOB'); 
--        l_idx_hiredate := apex_exec.get_column_position( l_context, 'HIREDATE'); 
--        l_idx_mgr      := apex_exec.get_column_position( l_context, 'MGR'); 
--        l_idx_sal      := apex_exec.get_column_position( l_context, 'SAL'); 
--        l_idx_comm     := apex_exec.get_column_position( l_context, 'COMM'); 
--        l_idx_deptno   := apex_exec.get_column_position( l_context, 'DEPTNO'); 
--    
--        while apex_exec.next_row( l_context ) loop
--
--            htp.p( 'EMPNO: ' || apex_exec.get_number  ( l_context, l_idx_empno    ) ); 
--            htp.p( 'ENAME: ' || apex_exec.get_varchar2( l_context, l_idx_ename    ) );
--            htp.p( 'MGR:   ' || apex_exec.get_number  ( l_context, l_idx_mgr      ) );
--
--        end loop;
--        
--        apex_exec.close( l_context );
--        return;
--    exception
--        when others then
--            apex_exec.close( l_context );
--            raise;    
--    end;
--==============================================================================
function open_remote_sql_query(
    p_server_static_id      in varchar2,
    p_sql_query             in varchar2,
    p_sql_parameters        in t_parameters default c_empty_parameters,
    p_auto_bind_items       in boolean      default true,
    --
    p_first_row             in pls_integer  default null,
    p_max_rows              in pls_integer  default null,
    --
    p_total_row_count       in boolean      default false,
    p_total_row_count_limit in number       default null )
    return t_context;

--==============================================================================
-- This procedure opens a query context and executes the provided SQL query.
--
-- PARAMETERS
--    p_location               Location to open the query context for. Can be local database , remote database or Web Source Module.
--                             Use the C_LOCATION_LOCAL_DB, C_LOCATION_REMOTE_DB or C_LOCATION_WEB_SOURCE constants.
--
--    p_module_static_id       Static ID of the Web Source Module, when C_LOCATION_WEB_SOURCE has been used for p_location
--    p_server_static_id       Static ID of the Remote Server, when C_LOCATION_REMOTE_DB has been used for p_location
--
--    p_table_owner            Table owner when query type TABLE is used.
--    p_table_name             Table name when query type TABLE is used.
--    p_where_clause           Where clause to append when query type TABLE is used.
--    p_order_by_clause        Order by clause to append when query type TABLE is used.
--    p_include_rowid_column   Add the ROWID column to the SELECT list when query type TABLE is used. Defaults to "false"
--
--    p_sql_query              SQL Query to execute when query type SQL Query is used.
--    p_plsql_function_body    PL/SQL function body returning SQL query.
--    p_optimizer_hint         Optimizer hint to be applied to the most outer SQL query generated by APEX.
--
--    p_external_filter_expr   external filter expression to be passed to a Web Source Module.
--    p_external_order_by_expr external order by expression to be passed to a Web Source Module.
--    p_web_src_parameters     parameters to be passed to a web source module 
--
--    p_auto_bind_items        whether to auto-bind APEX items (page and application items)
--    p_sql_parameters         additional bind variables to be used for the SQL query
--
--    p_filters                filters to be passed to the query context
--    p_order_bys              order by expressions to be passed to the query context
--    p_columns                columns to be selected 
--
--    p_first_row               first row to be fetched from the result set
--    p_max_rows                maximum amount of rows to be fetched 
--
--    p_total_row_count         wether to determine the total row count
--    p_total_row_count_limit   upper boundary for total row count computation
--
-- RETURNS 
--    the context object representing a "cursor" for the web source query
--
-- EXAMPLE
--
--    the following example executes a query and prints out the result set.
--    This example code can be used within a "Execute PL/SQL" region. 
--    
--    declare
--        l_context apex_exec.t_context;
--    
--        l_idx_empno    pls_integer;
--        l_idx_ename    pls_integer;
--        l_idx_job      pls_integer;
--        l_idx_hiredate pls_integer;
--        l_idx_mgr      pls_integer;
--        l_idx_sal      pls_integer;
--        l_idx_comm     pls_integer;
--        l_idx_deptno   pls_integer;
--    
--    begin
--        l_context := apex_exec.open_query_context(
--            p_location          => apex_exec.c_location_local_db,
--            p_sql_query         => 'select * from emp' );
--    
--        l_idx_empno    := apex_exec.get_column_position( l_context, 'EMPNO'); 
--        l_idx_ename    := apex_exec.get_column_position( l_context, 'ENAME'); 
--        l_idx_job      := apex_exec.get_column_position( l_context, 'JOB'); 
--        l_idx_hiredate := apex_exec.get_column_position( l_context, 'HIREDATE'); 
--        l_idx_mgr      := apex_exec.get_column_position( l_context, 'MGR'); 
--        l_idx_sal      := apex_exec.get_column_position( l_context, 'SAL'); 
--        l_idx_comm     := apex_exec.get_column_position( l_context, 'COMM'); 
--        l_idx_deptno   := apex_exec.get_column_position( l_context, 'DEPTNO'); 
--    
--        while apex_exec.next_row( l_context ) loop
--
--            htp.p( 'EMPNO: ' || apex_exec.get_number  ( l_context, l_idx_empno    ) ); 
--            htp.p( 'ENAME: ' || apex_exec.get_varchar2( l_context, l_idx_ename    ) );
--            htp.p( 'MGR:   ' || apex_exec.get_number  ( l_context, l_idx_mgr      ) );
--
--        end loop;
--        
--        apex_exec.close( l_context );
--        return;
--    exception
--        when others then
--            apex_exec.close( l_context );
--            raise;    
--    end;
--==============================================================================
function open_query_context(
    p_location               in wwv_flow_exec_api.t_location,
    --  
    p_table_owner            in varchar2                       default null,
    p_table_name             in varchar2                       default null,
    p_where_clause           in varchar2                       default null,
    p_order_by_clause        in varchar2                       default null,
    p_include_rowid_column   in boolean                        default false,
    --
    p_sql_query              in varchar2                       default null,
    p_plsql_function_body    in varchar2                       default null,
    p_optimizer_hint         in varchar2                       default null,
    --
    p_server_static_id       in varchar2                       default null,
    --
    p_module_static_id       in varchar2                       default null,
    p_web_src_parameters     in t_parameters                   default c_empty_parameters,
    p_external_filter_expr   in varchar2                       default null,
    p_external_order_by_expr in varchar2                       default null,
    --
    p_sql_parameters         in t_parameters                   default c_empty_parameters,
    p_auto_bind_items        in boolean                        default true,
    --
    p_columns                in t_columns                      default c_empty_columns,
    --
    p_filters                in t_filters                      default c_empty_filters,
    p_order_bys              in t_order_bys                    default c_empty_order_bys,
    --
    p_first_row              in pls_integer                    default null,
    p_max_rows               in pls_integer                    default null,
    --
    p_total_row_count        in boolean                        default false,
    p_total_row_count_limit  in number                         default null ) return t_context;

--==============================================================================
-- This procedure executes PL/SQL code based on the current process or plug-in
-- location settings.
--
-- PARAMETERS
--    p_plsql_code              PL/SQL code to execute. Based on the settings of the
--                              current process or process-type plug-in, the code is executed
--                              locally or remote.
--
-- EXAMPLE
--    executes a PL/SQL block.
--
--    begin
--        apex_exec.execute_plsql(
--            p_plsql_code => q'#begin :P10_NEW_SAL := salary_pkg.raise_sal( p_empno => :P10_EMPNO ); end;#' );
--    end;
--
--==============================================================================
procedure execute_plsql (
    p_plsql_code in varchar2 );

--==============================================================================
-- This procedure executes PL/SQL code based on the current process or plug-in
-- location settings.
--
-- PARAMETERS
--    p_plsql_code            PL/SQL code to be executed
--    p_auto_bind_items       whether to automatically bind page item values for IN *and* OUT direction. If 
--                            the PL/SQL code references bind variables which are not page items, this
--                            must be set to FALSE. Default: TRUE
--    p_sql_parameters        additional bind variables; if needed
--
-- EXAMPLE
--    executes a PL/SQL block with arbitrary bind variables, so any bind can be used to 
--    pass values and to get values back.
--
--    declare
--        l_sql_parameters apex_exec.t_parameters;
--        l_out_value      varchar2(32767);
--    begin
--        apex_exec.add_parameter( l_sql_parameters, 'MY_BIND_IN_VAR',  '{some value}' );
--        apex_exec.add_parameter( l_sql_parameters, 'MY_BIND_OUT_VAR', ''             );
--
--        apex_exec.execute_plsql(
--            p_plsql_code      => q'#begin :MY_BIND_OUT_VAR := some_plsql( p_parameter => :MY_BIND_IN_VAR ); end;#',
--            p_auto_bind_items => false,
--            p_sql_parameters  => l_sql_parameters );
--            
--        l_out_value := apex_exec.get_parameter_varchar2( 
--            p_parameters => l_sql_parameters,
--            p_name       => 'MY_BIND_OUT_VAR');
--            
--        -- further processing of l_out_value        
--    end;
--
--==============================================================================
procedure execute_plsql (
    p_plsql_code      in     varchar2,
    p_auto_bind_items in     boolean      default true,
    p_sql_parameters  in out t_parameters );

--==============================================================================
-- This procedure executes PL/SQL code on a REST Enabled SQL instance. 
--
-- PARAMETERS
--    p_server_static_id      static ID of the ORDS REST Enabled SQL Instance
--    p_plsql_code            PL/SQL code to be executed
--
-- EXAMPLE
--    executes a PL/SQL block on a remote database.
--
--    begin
--        apex_exec.execute_remote_plsql(
--            p_server_static_id => '{static ID of the REST Enabled SQL Service}',
--            p_plsql_code       => q'#begin :P10_NEW_SAL := salary_pkg.raise_sal( p_empno => :P10_EMPNO ); end;#' );
--    end;
---==============================================================================
procedure execute_remote_plsql(
    p_server_static_id in varchar2,
    p_plsql_code       in varchar2 );

--==============================================================================
-- This procedure executes PL/SQL code on a REST Enabled SQL instance. 
--
-- PARAMETERS
--    p_server_static_id      static ID of the ORDS REST Enabled SQL Instance
--    p_plsql_code            PL/SQL code to be executed
--    p_auto_bind_items       whether to automatically bind page item values for IN *and* OUT direction. If 
--                            the PL/SQL code references bind variables which are not page items, this
--                            must be set to FALSE. Default: TRUE
--    p_sql_parameters        additional bind variables; if needed
--
-- EXAMPLE
--    executes a PL/SQL block on a remote database.
--
--    begin
--        apex_exec.execute_remote_plsql(
--            p_server_static_id => '{static ID of the REST Enabled SQL Service}',
--            p_plsql_code       => q'#begin :P10_NEW_SAL := salary_pkg.raise_sal( p_empno => :P10_EMPNO ); end;#' );
--    end;
--
--    the second example works with arbitrary bind variables, so any bind can be used to 
--    pass values to the REST Enabled SQL service and to get values back.
--
--    declare
--        l_sql_parameters apex_exec.t_parameters;
--        l_out_value      varchar2(32767);
--    begin
--        apex_exec.add_parameter( l_sql_parameters, 'MY_BIND_IN_VAR',  '{some value}' );
--        apex_exec.add_parameter( l_sql_parameters, 'MY_BIND_OUT_VAR', ''             );
--
--        apex_exec.execute_remote_plsql(
--            p_server_static_id  => '{static ID of the REST Enabled SQL Service}',
--            p_plsql_code        => q'#begin :MY_BIND_OUT_VAR := some_remote_plsql( p_parameter => :MY_BIND_IN_VAR ); end;#',
--            p_auto_bind_items   => false,
--            p_sql_parameters    => l_sql_parameters );
--            
--        l_out_value := apex_exec.get_parameter_varchar2( 
--            p_parameters  => l_sql_parameters,
--            p_name        => 'MY_BIND_OUT_VAR');
--            
--        -- further processing of l_out_value        
--    end;
--==============================================================================
procedure execute_remote_plsql(
    p_server_static_id  in     varchar2,
    p_plsql_code        in     varchar2,
    p_auto_bind_items   in     boolean      default true,
    p_sql_parameters    in out t_parameters );

--==============================================================================
-- checks whether the current authentication credentials are correct for the
-- given REST Enabled SQL instance.
--
-- PARAMETERS:
--     p_server_static_id     static ID of the REST enabled SQL instance
--
-- RETURNS:
--     true, when credentials are correct, false otherwise
-- 
-- EXAMPLE
--     The following example requires a REST enabled SQL instance being
--     created as "My Remote SQL". It uses credentials stored as 
--     SCOTT_Credentials.
--
--  
-- begin
--     apex_credentials.set_session_credentials(
--         p_application_id    => {application-id},
--         p_credential_name   => 'SCOTT_Credentials',
--         p_username          => 'SCOTT',
--         p_password          => '****' );
--     if apex_exec.check_rest_enabled_sql_auth(
--         p_server_static_id  => 'My Remote SQL' )
--     then
--         sys.dbms_output.put_line( 'credentials are correct!');
--     else 
--         sys.dbms_output.put_line( 'credentials are NOT correct!');
--     end if;
-- end;
--
--==============================================================================
function is_remote_sql_auth_valid(
    p_server_static_id  in  varchar2 ) return boolean;

--==============================================================================
-- Executes a web source operation based on module static ID, operation and
-- URL pattern (if required). Use the t_parameters array to pass in values
-- for declared web source parameters. Web Source invocation is done based
-- on meta data defined in Shared Components.
--
-- PARAMETERS
--    p_module_static_id  static ID of the web source module
--    p_operation         Name of the operation, e.g. POST, GET, DELETE
--    p_url_pattern       If multiple operations with the same name exist, specify the URL pattern,
--                        as defined in Shared Components, to identify the web source operation.
--    p_parameters        parameter values to pass to the external web source
--
-- RETURNS
--    p_parameters        array with OUT parameter values, received from the web source module.
--
-- EXAMPLE:
--    This example assumes a REST service being created on the EMP table using
--    ORDS and the "Auto-REST" feature (ORDS.ENABLE_OBJECT). Then a Web Source Module
--    for this REST service is being created in Shared Components as "ORDS EMP".
--
--    * The POST operation has the following "Request Body Template" defined:
--      {"empno": "#EMPNO#", "ename": "#ENAME#", "job": "#JOB#", "sal": #SAL#}
--
--    * Parameters are defined as follows:
--      Name         Direction    Type
--      ------------ ------------ --------------
--      EMPNO        IN           Request Body 
--      ENAME        IN           Request Body 
--      SAL          IN           Request Body 
--      JOB          IN           Request Body 
--      RESPONSE     OUT          Request Body
--      Content-Type IN           HTTP Header
--    
--    PL/SQL code to invoke that web source operation looks as follows:
--
--    declare
--        l_params apex_exec.t_parameters;
--    begin
--        apex_exec.add_parameter( l_params, 'ENAME', :P2_ENAME );
--        apex_exec.add_parameter( l_params, 'EMPNO', :P2_EMPNO );
--        apex_exec.add_parameter( l_params, 'SAL',   :P2_SAL   );
--        apex_exec.add_parameter( l_params, 'JOB',   :P2_JOB   );

--        apex_exec.execute_web_source(
--            p_module_static_id => 'ORDS_EMP',
--            p_operation        => 'POST',
--            p_parameters       => l_params );
--            
--        :P2_RESPONSE := apex_exec.get_parameter_clob(l_params,'RESPONSE');
--    end;
--==============================================================================

procedure execute_web_source (
    p_module_static_id in            varchar2,
    p_operation        in            varchar2,
    p_url_pattern      in            varchar2         default null,
    p_parameters       in out nocopy t_parameters );

--==============================================================================
-- Returns the result column count for this web source cursor
--
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--
-- RETURNS
--    result columns count
--==============================================================================
function get_column_count (
    p_context in t_context ) return pls_integer;

--==============================================================================
-- Returns the total row count of the query result
--
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--
-- RETURNS
--    total row count; NULL if unknown
--==============================================================================
function get_total_row_count (
    p_context in t_context ) return pls_integer;

--==============================================================================
-- Returns the array index for a given column alias.
-- 
-- PARAMETERS
--    p_context           context object obtained with one of the OPEN_ functions
--    p_attribute_label   attribute label to format error messages
--    p_column_name       column name
--    p_is_required       indicates whether this is a required column
--    p_data_type         indicates the requsted data type
--
-- RETURNS
--    the position of the column in the query result set. Throws an exception
--    when p_is_required or p_data_type prerequisites are not met.
--==============================================================================
function get_column_position (
    p_context           in t_context, 
    p_column_name       in varchar2,
    p_attribute_label   in varchar2  default null,
    p_is_required       in boolean   default false,
    p_data_type         in varchar2  default c_data_type_varchar2 )
    return pls_integer;

--==============================================================================
-- Returns detailed information about a result set column
-- 
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--    p_column_idx     index of the column to retrieve information for
--
-- RETURNS
--    t_column object with column meta data
--
--==============================================================================
function get_column(
    p_context    in t_context,
    p_column_idx in pls_integer ) return t_column;

--==============================================================================
-- Advances the cursors of an open query context by one row. For Web Sources 
-- returning their data page-wise, additional pages are being fetched transparently.
--
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--
-- RETURNS
--     false when the end of the response has been reached, true otherwise
--==============================================================================
function next_row(
    p_context in t_context ) return boolean;

--==============================================================================
-- Getter functions to retrieve column values
--
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--    p_column_idx     column index
--
-- RETURNS
--    column value as specific data type
--==============================================================================
function get_varchar2 (
    p_context     in t_context,
    p_column_idx  in pls_integer ) return varchar2;
    
function get_number (
    p_context    in t_context,
    p_column_idx in pls_integer ) return number;

function get_date (
    p_context    in t_context,
    p_column_idx in pls_integer ) return date;

function get_timestamp (
    p_context    in t_context,
    p_column_idx in pls_integer ) return timestamp;

function get_timestamp_tz (
    p_context    in t_context,
    p_column_idx in pls_integer ) return timestamp with time zone;

function get_timestamp_ltz (
    p_context    in t_context,
    p_column_idx in pls_integer ) return timestamp with local time zone;

function get_clob (
    p_context    in t_context,
    p_column_idx in pls_integer ) return clob;

function get_intervald2s (
    p_context    in t_context,
    p_column_idx in pls_integer ) return interval day to second;

function get_intervaly2m (
    p_context    in t_context,
    p_column_idx in pls_integer ) return interval year to month;

function get_anydata (
    p_context    in t_context,
    p_column_idx in pls_integer ) return sys.anydata;

--==============================================================================
-- Closes the query context and releases resources. Make sure to 
-- always call this procedure after work has finished or an exception occurs.
--
-- PARAMETERS
--    p_context        context object obtained with one of the OPEN_ functions
--==============================================================================
procedure close(
    p_context in t_context );

--==============================================================================
-- Adds a SQL parameter to the parameter collection. To use SQL parameters,
-- prepare the array first, then use it in the execution call.
--
-- PARAMETERS
--    p_parameters              SQL parameter array
--    p_name                    parameter name
--    p_value                   parameter value
--
-- EXAMPLE
--
-- declare
--     l_parameters     apex_exec.t_parameters;
-- begin
--     apex_exec.add_parameter( l_parameters, 'ENAME',    'SCOTT' );
--     apex_exec.add_parameter( l_parameters, 'SAL',      2000 );
--     apex_exec.add_parameter( l_parameters, 'HIREDATE', sysdate );
--
--     apex_exec.execute_remote_plsql(
--         p_server_static_id => '{name of the REST Enabled SQL Service}',
--         p_auto_bind_items  => false,
--         p_plsql_code       => q'#begin insert into emp values (:ENAME, :SAL, :HIREDATE ); end;#',
--         p_sql_parameters   => l_parameters );
-- end;
--==============================================================================
procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            varchar2 );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            number );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            date );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            timestamp );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            timestamp with time zone );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            timestamp with local time zone );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            interval year to month );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            interval day to second );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            blob );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            bfile );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            clob );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_value      in            sys.anydata );

procedure add_parameter (
    p_parameters in out nocopy t_parameters,
    p_name       in            t_column_name,
    p_data_type  in            t_data_type,
    p_value      in            t_value );

--==============================================================================
-- Returns a SQL parameter value. Typically used to retrieve values for
-- OUT binds of an executed SQL or PL/SQL statement.
--
-- PARAMETERS
--    p_parameters              SQL parameter array
--    p_name                    parameter name
--
-- RETURNS 
--    parameter value
--
--==============================================================================
function get_parameter_varchar2(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return varchar2;

function get_parameter_number(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return number;

function get_parameter_date(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return date;

function get_parameter_timestamp(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return timestamp;

function get_parameter_timestamp_tz(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return timestamp with time zone;

function get_parameter_timestamp_ltz(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return timestamp with local time zone;

function get_parameter_clob(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return clob;

function get_parameter_interval_d2s(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return interval day to second;

function get_parameter_interval_y2m(
    p_parameters      in t_parameters,
    p_name            in varchar2 ) return interval year to month;

--==============================================================================
-- Adds a column to the columns collection. Columns collections can be passed
-- the OPEN_*_CONTEXT calls in order to request only a subset of columns. This is
-- particularly useful for web sources where no SQL statement is involved.
-- If no or an empty column array is passed, all columns defined in the web source are being
-- fetched. 
--
-- PARAMETERS
--    p_columns            columns array
--    p_column_name        column name
--    p_data_type          column data type
--    p_sql_expression     SQL expression in order to derive a column from other columns
--
-- EXAMPLE
--     declare
--         l_columns     apex_exec.t_columns;
--         l_context     apex_exec.t_context;
--     begin
--         apex_exec.add_column(
--             p_columns     => l_columns,
--             p_column_name => 'ENAME' );
--
--         apex_exec.add_column(
--             p_columns     => l_columns,
--             p_column_name => 'SAL' );

--         l_context := apex_exec.open_web_source_query(
--             p_module_static_id => '{web source module static ID}', 
--             p_columns          => l_columns
--             p_max_rows         => 1000 );
--        
--             while apex_exec.next_row( l_context ) loop
--                -- process rows here ...
--             end loop;
--            
--         apex_exec.close( l_context );
--     exception
--         when others then
--             apex_exec.close( l_context );
--             raise;    
--     end;
--==============================================================================
procedure add_column(
    p_columns         in out nocopy t_columns,
    p_column_name     in            varchar2,
    p_data_type       in            t_data_type default null,
    p_sql_expression  in            varchar2    default null );

--==============================================================================
-- Adds a filter to the filter collection.
--
-- PARAMETERS
--    p_filters            filters array
--    p_filter_type        type of filter - use one of the t_filter_type constants 
--    p_column_name        column to apply this filter on
--
--    p_value              value for filters requiring one value (e.g. equals or greater than)
--    p_values             value array for IN or NOT IN filters
--    p_from_value         lower value for filters requiring a range (e.g. between)
--    p_to_value           upper value for filters requiring a range (e.g. between)
--    p_interval           interval for date filters (e.g. last X months)
--    p_interval_type      interval type for date filters (months, dates)
--
--    p_sql_expression     generic SQL expression to use as filter
--
--    p_null_result        result to return when the actual column value is NULL
--    p_is_case_sensitive  whether this filter should work case-sensitive or not
--
-- EXAMPLE
--
-- declare
--     l_filters     apex_exec.t_filters;
--     l_context     apex_exec.t_context;
-- begin
--     apex_exec.add_filter(
--         p_filters     => l_filters,
--         p_filter_type => apex_exec.c_filter_eq,
--         p_column_name => 'ENAME',
--         p_value       => 'KING' );

--     apex_exec.add_filter(
--         p_filters     => l_filters,
--         p_filter_type => apex_exec.c_filter_gt,
--         p_column_name => 'SAL',
--         p_value       => 2000 );
--
--     l_context := apex_exec.open_web_source_query(
--         p_module_static_id => '{web source module static ID}', 
--         p_filters          => l_filters
--         p_max_rows         => 1000 );
--    
--         while apex_exec.next_row( l_context ) loop
--            -- process rows here ...
--         end loop;
--        
--     apex_exec.close( l_context );
-- exception
--     when others then
--         apex_exec.close( l_context );
--         raise;    
-- end;
--==============================================================================
procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            varchar2,
    p_null_result       in            boolean  default false,
    p_is_case_sensitive in            boolean  default true );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            varchar2,
    p_to_value          in            varchar2,
    p_null_result       in            boolean default false,
    p_is_case_sensitive in            boolean default true );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_values            in            wwv_flow_t_varchar2,
    p_null_result       in            boolean default false,
    p_is_case_sensitive in            boolean default true );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            number,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            number,
    p_to_value          in            number,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_values            in            wwv_flow_t_number,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            date,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            date,
    p_to_value          in            date,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            timestamp,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            timestamp,
    p_to_value          in            timestamp,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            timestamp with time zone,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            timestamp with time zone,
    p_to_value          in            timestamp with time zone,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_value             in            timestamp with local time zone,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_from_value        in            timestamp with local time zone,
    p_to_value          in            timestamp with local time zone,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_filter_type       in            t_filter_type,
    p_column_name       in            t_column_name,
    p_interval          in            pls_integer,
    p_interval_type     in            t_filter_interval_type,
    p_null_result       in            boolean default false );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_search_columns    in            t_columns,
    p_is_case_sensitive in            boolean default false,
    p_value             in            varchar2 );

procedure add_filter (
    p_filters           in out nocopy t_filters,
    p_sql_expression    in            varchar2 );

--==============================================================================
-- Adds an order by expression to the order bys collection.
--
-- PARAMETERS
--     p_order_bys    order by collection
--     p_column_name: references a column name or alias of the provided data source.
--     p_direction:   defines if the column should be sorted ascending or descending.
--                    Valid values are c_order_asc and c_order_desc.
--     p_order_nulls: defines if NULL data will sort to the bottom or top. Valid
--                    values are NULL, c_order_nulls_first and c_order_nulls_last.
--                    Use NULL for automatic handling based on the sort direction.
--                    c_order_asc  -> c_order_nulls_last
--                    c_order_desc -> c_order_nulls_first
--                    Note: p_order_nulls might not be supported by Non-Oracle data sources.
--
-- EXAMPLE
--
-- declare
--     l_order_bys   apex_exec.t_order_bys;
--     l_context     apex_exec.t_context;
-- begin
--     apex_exec.add_order_by(
--         p_order_bys     => l_order_bys,
--         p_column_name   => 'ENAME',
--         p_direction     => apex_exec.c_order_asc );
--
--     l_context := apex_exec.open_web_source_query(
--         p_module_static_id => '{web source module static ID}', 
--         p_order_bys        => l_order_bys,
--         p_max_rows         => 1000 );
--    
--         while apex_exec.next_row( l_context ) loop
--            -- process rows here ...
--         end loop;
--        
--     apex_exec.close( l_context );
-- exception
--     when others then
--         apex_exec.close( l_context );
--         raise;    
-- end;
--==============================================================================
procedure add_order_by (
    p_order_bys         in out nocopy t_order_bys,
    p_column_name       in            t_column_name,
    p_lov               in            t_lov,
    p_direction         in            t_order_direction default c_order_asc,
    p_order_nulls       in            t_order_nulls     default null );-- c_order_nulls_last if ascending, c_order_nulls_first when descending

procedure add_order_by (
    p_order_bys         in out nocopy t_order_bys,
    p_position          in            pls_integer,
    p_direction         in            t_order_direction default c_order_asc,
    p_order_nulls       in            t_order_nulls     default null );-- c_order_nulls_last if ascending, c_order_nulls_first when descending

--==============================================================================
-- *** INTERNAL USE ONLY !!! ***
--==============================================================================

--==============================================================================
-- Returns the 'real' owner and table name of a database object/synonym.
--==============================================================================
procedure resolve_local_synonym (
    p_object_name in     varchar2,
    p_owner          out varchar2,
    p_name           out varchar2 );

end wwv_flow_exec_api;
/
show errors
