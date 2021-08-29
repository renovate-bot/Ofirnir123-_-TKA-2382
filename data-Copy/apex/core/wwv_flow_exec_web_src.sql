set define '^' verify off
prompt ...wwv_flow_exec_web_src.sql
create or replace package wwv_flow_exec_web_src as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_web_src.sql
--
--    DESCRIPTION
--      Web source implementation
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    03/14/2017 - Created
--    cczarski    08/14/2017 - moved t_source_capabilities type to wwv_flow_exec_api
--    cczarski    09/04/2017 - added "fetch all rows" functionality
--                             exposed fetch_web_soutrce overload to use in wwv_flow_web_src_dev
--    cczarski    09/27/2017 - added "make_rest_request" for all web sources using to invoke the HTTP request
--    cczarski    09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec
--    cczarski    10/04/2017 - Added open_process_context to execute a specific web source operation
--    cczarski    11/10/2017 - Change wwv_flow_exec_api to AUTHID CURRENT_USER; so this internal API will be DEFINER
--    cczarski    12/19/2017 - Added pass_ecid attribute to t_web_source_operation
--    cczarski    12/21/2017 - in describe_query: Added support for post-processing 
--    cczarski    01/08/2018 - changed constant c_web_src_type_oracle_saas to c_web_src_type_adfbc
--    cczarski    01/15/2018 - added parameter processing for JET Chart series
--    cczarski    01/24/2018 - Added purge_cache
--    cczarski    01/25/2018 - In describe_query: Added parse_as_schema_override
--    cczarski    02/20/2018 - Added prepare_endpoint_url to process URL pattern and Query String parameters
-- 
--------------------------------------------------------------------------------

--==============================================================================
-- Global type to represent a web source operation
--==============================================================================
subtype t_web_src_type       is pls_integer range 1..6;
subtype t_web_src_param_type is pls_integer range 1..5;
subtype t_web_src_param_dir  is pls_integer range 1..3;
subtype t_db_operation       is pls_integer range 1..5;

type t_web_source_param is record(
    id                    wwv_flow_web_src_params.id%type,
    name                  wwv_flow_web_src_params.name%type,
    is_required           boolean,
    direction             t_web_src_param_dir,
    param_type            t_web_src_param_type,
    value                 wwv_flow_web_src_params.value%type,
    component_value       wwv_flow_web_src_comp_params.value%type,
    component_value_type  wwv_flow_web_src_comp_params.value_type%type,
    is_static             boolean,
    is_array              boolean );

type t_web_source_params is table of t_web_source_param index by binary_integer;

type t_web_source_operation is record(
    flow_id                number, 
    module_id              number,
    operation_id           number,
    -- 
    web_source_type        t_web_src_type,
    --
    base_url               varchar2(32767),
    https_host             varchar2(500),
    --
    auth_token_url         varchar2(32767),
    auth_https_host        varchar2(500),
    credential_id          wwv_flow_web_src_modules.credential_id%type,
    --
    operation              wwv_flow_web_src_operations.operation%type,
    db_operation           t_db_operation,
    --
    url_pattern            wwv_flow_web_src_operations.url_pattern%type,
    request_body_template  wwv_flow_web_src_operations.request_body_template%type,
    params                 t_web_source_params,
    --
    timeout                pls_integer,
    pass_ecid              boolean,
    ords_fixed_page_size   pls_integer,
    allow_fetch_all_rows   boolean,
    fetch_all_rows_timeout pls_integer,
    --
    caching                wwv_flow_web_src_operations.caching%type,
    invalidate_when        wwv_flow_web_src_operations.invalidate_when%type,
    --
    security_scheme        wwv_flow_web_src_operations.security_scheme%type,
    --
    data_profile_id        wwv_flow_web_src_modules.data_profile_id%type,
    data_profile           wwv_flow_data_profile.t_data_profile );

--==============================================================================
-- contants
--==============================================================================

c_web_src_type_ords_2       constant t_web_src_type       := 1;
c_web_src_type_ords_3       constant t_web_src_type       := 2;
c_web_src_type_soap         constant t_web_src_type       := 3;
c_web_src_type_adfbc        constant t_web_src_type       := 4;
c_web_src_type_http_feed    constant t_web_src_type       := 5;
c_web_src_type_custom       constant t_web_src_type       := 6;

c_db_operation_insert       constant t_db_operation       := 1;
c_db_operation_update       constant t_db_operation       := 2;
c_db_operation_delete       constant t_db_operation       := 3;
c_db_operation_fetch_coll   constant t_db_operation       := 4;
c_db_operation_fetch_row    constant t_db_operation       := 5;

c_web_src_param_header      constant t_web_src_param_type := 1;
c_web_src_param_query       constant t_web_src_param_type := 2;
c_web_src_param_url_pattern constant t_web_src_param_type := 3;
c_web_src_param_body        constant t_web_src_param_type := 4;
c_web_src_param_cookie      constant t_web_src_param_type := 5;

c_web_src_param_dir_in      constant t_web_src_param_dir  := 1;
c_web_src_param_dir_out     constant t_web_src_param_dir  := 2;
c_web_src_param_dir_inout   constant t_web_src_param_dir  := 3;

c_def_user_agent_hdr        constant varchar2(26)         := 'Oracle Application Express'; 

c_empty_web_source_params   t_web_source_params;

--======================================================================================================================
-- Globals
--======================================================================================================================

--======================================================================================================================
-- finds the web source module id by name
--
-- PARAMETERS
--     p_module_name             IN web source module name
--     p_application_id          IN application ID (optional)
--======================================================================================================================
function find_web_src_module_id(
    p_module_name      in varchar2,
    p_application_id   in number default wwv_flow.g_flow_id ) return wwv_flow_web_src_modules.id%type;

--======================================================================================================================
-- finds the web source module id by static ID
--
-- PARAMETERS
--     p_module_static_id        IN web source module static ID
--     p_application_id          IN application ID (optional)
--======================================================================================================================
function find_web_src_module_id(
    p_module_static_id in varchar2,
    p_application_id   in number default wwv_flow.g_flow_id ) return wwv_flow_web_src_modules.id%type;

--======================================================================================================================
-- finds the web source module and operation ids
--
-- PARAMETERS
--     p_module_name             IN web source module name
--     p_operation               IN web source operation
--     p_application_id          IN application ID (optional)
--     p_module_id              OUT web source module_id
--     p_operation_id           OUT web source operation id
--======================================================================================================================
procedure find_websrc_module_operation(
    p_module_name      in  varchar2,
    p_operation        in  varchar2,
    p_url_pattern      in  varchar2 default null,
    p_application_id   in  number   default wwv_flow.g_flow_id,
    p_module_id        out number,
    p_operation_id     out number );

--======================================================================================================================
-- finds the web source module and operation ids
--
-- PARAMETERS
--     p_module_static_id        IN web source module static ID
--     p_operation               IN web source operation
--     p_application_id          IN application ID (optional)
--     p_module_id              OUT web source module_id
--     p_operation_id           OUT web source operation id
--======================================================================================================================
procedure find_websrc_module_operation(
    p_module_static_id in  varchar2,
    p_operation        in  varchar2,
    p_url_pattern      in  varchar2 default null,
    p_application_id   in  number   default wwv_flow.g_flow_id,
    p_module_id        out number,
    p_operation_id     out number );

--======================================================================================================================
-- fetches all data for a web source operation by name into one record.
--
-- PARAMETERS
--     p_application_id      IN application_id
--     p_module_name         IN name of the web source module
--     p_operation           IN name of the web source operation or action
--     p_database_operation  IN database operation to look up the web source operation for
--
-- Either p_operation or p_database operation must be NULL
--======================================================================================================================
function fetch_web_source(
    p_application_id     in number,
    p_module_name        in varchar2,
    p_operation          in varchar2                     default null,
    p_database_operation in wwv_flow_exec.t_context_type default null )
return t_web_source_operation; 

--======================================================================================================================
-- fetches all data for a web source operation into one record.
--
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_web_source          IN OUT record structure to be populated with details on the web source operation
--     p_operation_type          IN lookup web source operation for this given DB operation
--======================================================================================================================
procedure fetch_web_source (
    p_web_src_module_id     in            wwv_flow_web_src_modules.id%type,
    p_web_src_operation_id  in out nocopy wwv_flow_web_src_operations.id%type,
    p_operation_type        in            wwv_flow_exec.t_context_type     default null,
    p_web_source            in out nocopy t_web_source_operation );

--==============================================================================
-- returns a record structure with information about web source capabilities
--
-- PARAMETERS
--     p_context          IN context object with execution details
--
-- RETURNS
--     t_web_source_capabilities record structure with information about web source capabilities
--==============================================================================
function get_capabilities( 
    p_web_source_module_id in wwv_flow_web_src_modules.id%type )
return wwv_flow_exec_api.t_source_capabilities;

function get_capabilities_json( 
    p_web_source_module_id in wwv_flow_web_src_modules.id%type )
return varchar2;

--======================================================================================================================
-- raise PL/SQL error and add HTTP status code to the message
--======================================================================================================================
procedure raise_http_error;

--======================================================================================================================
-- prepares the URL to invoke the REST service. This procedure processes URL pattern and Query string parameters
--======================================================================================================================
procedure prepare_endpoint_url(
    p_context              in  wwv_flow_exec.t_context,
    p_web_source_operation in  wwv_flow_exec_web_src.t_web_source_operation,
    p_url_path             out varchar2,
    p_query_string         out varchar2 );

--======================================================================================================================
-- compute component values for web service parameters and return the name-value pairs as 
-- wwv_flow_exec_api.t_parameter_values array
--
-- PARAMETERS
--     p_region_id              IN region ID to fetch parameters for
--     p_page_process_id        IN region ID to fetch parameters for
--     p_app_process_id         IN region ID to fetch parameters for
--
-- EXAMPLE
--     declare
--         l_parameter_values wwv_flow_exec_api.t_parameter_values;
--     begin
--         l_parameter_values := wwv_flow_exec_api.get_parameter_values(
--               p_region_id         => 31267978234874321 );
--     end;
--======================================================================================================================
function get_region_parameters(
    p_region_id              in wwv_flow_web_src_comp_params.page_plug_id%type
) return wwv_flow_exec_api.t_parameters;

function get_page_process_parameters(
    p_page_process_id        in wwv_flow_web_src_comp_params.page_process_id%type
) return wwv_flow_exec_api.t_parameters;

function get_app_process_parameters(
    p_app_process_id         in wwv_flow_web_src_comp_params.app_process_id%type
) return wwv_flow_exec_api.t_parameters;

function get_jet_chart_parameters(
    p_jet_chart_series_id         in wwv_flow_web_src_comp_params.jet_chart_series_id%type
) return wwv_flow_exec_api.t_parameters; 

--==============================================================================
-- Purges the cache for the FETCH_COLLECTION database operation of a Web Source Module
--
-- PARAMETERS
--     p_application_id         Application ID
--     p_module_id              Purge cache entries for the given web sourc module ID
--     p_current_session_only   Purge only cache entries for the current session
--==============================================================================
procedure purge_cache(
    p_application_id       in number, 
    p_module_id            in number,
    p_current_session_only in boolean );

--==============================================================================
-- Performs the "open_query_context" operation for execution on a web source
--
-- For a DML context, the procedure does nothing; a query context will be
-- executed so that the component can continue with fetching rows.
--
-- PARAMETERS
--     p_context           IN context object with execution details
--     p_columns           IN column names and data types
--     p_web_src_operation IN already fetched information about the web src operation
--==============================================================================
procedure open_query_context( 
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_web_source_operation in            t_web_source_operation,
    p_columns              in            wwv_flow_exec_api.t_columns
);

--======================================================================================================================
-- looks up a parameter value from the context object
-- 
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_name                    IN parameter name
--
-- RETURNS
--     parameter value 
--======================================================================================================================
function get_parameter_value(
    p_context         in wwv_flow_exec.t_context,
    p_name            in varchar2
) return varchar2;

--======================================================================================================================
-- processes HTTP response headers (wwv_flow_webservices_api.g_headers) after the REST service has been invoked.
--
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_web_source_operation    IN web source operation details
--======================================================================================================================
procedure get_http_response_headers(
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_web_source_operation in            wwv_flow_exec_web_src.t_web_source_operation );


--======================================================================================================================
-- processes HTTP response cookies (wwv_flow_webservices_api.g_response_cookies) after the REST service has been invoked.
--
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_web_source_operation    IN web source operation details
--======================================================================================================================
procedure get_http_response_cookies(
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_web_source_operation in            wwv_flow_exec_web_src.t_web_source_operation );

--======================================================================================================================
-- processes parameter substitutions for the request body. The request body template may contain substitution
-- strings #ENAME#, for instance as follows:
-- {
--     "ename": "#ENAME#",
--     "sal":   "#SAL#",
--     "empno": "#EMPNO#" 
-- }
--
-- Web Source parameters of type c_web_src_param_body are being used to replace these substitutions; the final
-- request body is then being passed to the web service.

-- PARAMETERS
--     p_context             IN     context object with execution details
--     p_web_source          IN     record structure to be populated with details on the web source operation
--
-- RETURNS
--     the request body to be passed to the web service
--======================================================================================================================
procedure process_request_body(
    p_context    in            wwv_flow_exec.t_context,
    p_web_source in            t_web_source_operation,
    p_body       in out nocopy clob
);

--======================================================================================================================
-- Sets HTTP Request headers (wwv_flow_webservices_api.g_request_headers) before invoking the REST Service
--
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_web_source_operation    IN web source operation details
--======================================================================================================================
procedure set_http_headers(
    p_context              in wwv_flow_exec.t_context,
    p_web_source_operation in wwv_flow_exec_web_src.t_web_source_operation,
    p_extend_existing      in boolean default false );

--======================================================================================================================
-- Sets HTTP Request cookies (wwv_flow_webservices_api.g_request_cookies) before invoking the REST Service
--
-- PARAMETERS
--     p_context                 IN context object with execution details
--     p_web_source_operation    IN web source operation details
--======================================================================================================================
procedure set_http_cookies(
    p_context              in wwv_flow_exec.t_context,
    p_web_source_operation in wwv_flow_exec_web_src.t_web_source_operation );

--======================================================================================================================
-- performs the actual REST request for the specific operarion
--
-- PARAMETERS
--     p_url                      URL to invoke
--     p_web_source_operation     Details on Web Source Operation
--
-- RETURNS
--     CLOB with the Web Service response
--======================================================================================================================
function make_rest_request(
    p_url                  in varchar2,
    p_web_source_operation in t_web_source_operation,
    p_method_override      in varchar2 default null,
    p_timeout_override     in number   default null,
    p_body                 in clob     default null ) return clob;

--==============================================================================
-- Performs the "open_query_context" operation for execution on a web source
--
-- For a DML context, the procedure does nothing; a query context will be
-- executed so that the component can continue with fetching rows.
--
-- PARAMETERS
--     p_context          IN context object with execution details
--     p_columns          IN column names and data types
--==============================================================================
procedure open_query_context( 
    p_context in out nocopy wwv_flow_exec.t_context,
    p_columns in            wwv_flow_exec_api.t_columns );

--==============================================================================
-- Performs the "open_process_context" operation for execution on a web source.
--
-- PARAMETERS
--     p_context          IN context object with execution details
--==============================================================================
procedure open_process_context( 
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- fetches the next page of a web source response
--
-- PARAMETERS
--     p_context          IN context object with execution details
--
-- RETURNS
--     true if a next page exists, false otherwise
--==============================================================================
function next_page( 
    p_context in out nocopy wwv_flow_exec.t_context) return boolean; 

--==============================================================================
-- closes a context object and frees all associated resources 
-- (cursors, temporary LOBs)
--
-- PARAMETERS
--     p_context          IN context object with execution details
--==============================================================================
procedure close_context (
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- Performs a describe operation for the query on the remote server and 
-- populates the context object with result set metadata
--
-- PARAMETERS
--     p_web_src_module_id  IN Web source module to get a result description for.
--     p_columns            IN array with column names of interest, can be empty
--==============================================================================
function describe_query (
    p_web_src_module_id        in number,
    p_columns                  in wwv_flow_exec_api.t_columns,
    p_post_processing_type     in wwv_flow_exec.t_source_post_processing default null,
    p_post_processing_sql      in varchar2                               default null,
    p_post_processing_where    in varchar2                               default null,
    p_post_processing_order_by in varchar2                               default null,
    p_parse_as_schema_override in varchar2                               default null
) return wwv_flow_exec_api.t_columns;

end wwv_flow_exec_web_src;
/
show err

set define '^'

