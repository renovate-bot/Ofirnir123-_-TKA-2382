set define '^' verify off
prompt ...wwv_flow_web_src_dev.sql
create or replace package wwv_flow_web_src_dev authid definer as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_web_src_dev.sql
--
--    DESCRIPTION
--      Web source implementation
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    05/30/2017 - Created
--    cczarski    09/04/2017 - some code improvements
--                             added test_web_src_operation
--    cczarski    09/08/2017 - Added procedures for copy / subscribe
--    cczarski    09/13/2017 - added support for UTL_HTTP p_https_host argument (ignored pre-12.2)
--    cczarski    09/17/2017 - added store_manual_web_source
--    cczarski    09/27/2017 - moved logic from builder discovery pages to here (f4000_ procedures)
--    cczarski    10/06/2017 - added sync_module_parameters and sync_operation_parameters
--    cczarski    10/09/2017 - added has_parameters function
--    cczarski    11/16/2017 - added support for Re-Discovery of existing web source modules
--                             added parameter support for Test Web Source operation 
--                             allow to specify static parameters for initial web source discovery and creation
--    cczarski    01/08/2018 - added get_adfbc_web_source_info procedure
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================

--==============================================================================
-- Constants
--==============================================================================

--==============================================================================
-- Copy a web source module, between applications p_from_application_id to p_to_application_id.
--
-- p_subscribe:
--     if true then the new web source module gets a subscription to the old one.
-- p_if_existing_raise_dupval:
--     if true and a web source module with the same name already exists in
--     p_to_flow_id then DUP_VAL_ON_INDEX gets thrown.
--==============================================================================
function copy_web_src_module (
    p_from_application_id      in number,
    p_name                     in varchar2,
    p_to_application_id        in number,
    p_to_name                  in varchar2 default null,
    p_subscribe                in boolean default false,
    p_if_existing_raise_dupval in boolean default false )
    return number;

--==============================================================================
-- This procedure pulls content from the master remote server and
-- copies it to the subscribing remote server.
--==============================================================================
procedure subscribe_web_src_module (
    p_web_src_module_id        in number,
    p_master_web_src_module_id in number );

--==============================================================================
-- If the master remote server ID is not passed, get the master remote server ID
-- and refresh subscribing remote server.
--==============================================================================
procedure unsubscribe_web_src_module (
    p_web_src_module_id in number );

--==============================================================================
-- Refresh remote server with the master remote server content.
--==============================================================================
procedure refresh_web_src_module (
    p_web_src_module_id in number );

--==============================================================================
-- Pushes content of the remote server to all remote servers that reference this
-- remote server.
--==============================================================================
procedure push_web_src_module (
    p_web_src_module_id in number );

--==============================================================================
-- Helper function: Extracts a HTTP response header value from wwv_flow_web_services_api.g_headers
-- by name.
--
-- PARAMETERS
--     p_header_name       IN    name of the HTTP response header to get the value for
--
-- RETURNS
--     HTTP response header value
--==============================================================================
function get_response_header( p_header_name in varchar2 ) return varchar2;

--==============================================================================
-- Helper function: Invokes a REST service using WWV_FLOW_WEB_SERVICE.MAKE_REST_REQUEST.
--
-- PARAMETERS
--     p_url               IN    URL endpoint to invoke
--     p_method            IN    HTTP method to use
--     p_auth_scheme       IN    Authentication schema: BASIC, OAUTH, none
--     p_auth_token_url    IN    Token server URL for OAuth authentication flows
--     p_client_id         IN    OAuth Client ID or Basic Username
--     p_client_secret     IN    OAuth Client ID or Basic Password
--
-- RETURNS
--     response CLOB
--==============================================================================
function make_request(
    p_url            in varchar2,
    p_method         in varchar2,
    p_body           in varchar2 default null,
    p_auth_scheme    in varchar2 default null,
    p_auth_token_url in varchar2 default null,
    --
    p_https_host     in varchar2 default null,
    --
    p_client_id      in varchar2 default null,
    p_client_secret  in varchar2 default null ) return clob;

--==============================================================================
-- Helper function: frees this CLOB when it's a temporary CLOB. If the LOB is not
-- temporary, the function does nothing.
--
-- PARAMETERS
--     p_clob       IN    CLOB locator
-- 
-- EXAMPLES
--
-- declare
--     l_clob clob;
-- begin
--     dbms_lob.createtemporary( l_clob, true, dbms_lob.session );
--     free_clob( l_clob );
-- end;
--==============================================================================
procedure free_clob( p_clob in out nocopy clob ) ;

--==============================================================================
-- deletes a web source module. Also removes associated data profiles and 
-- remote servers, if requested. Data profiles and remote servers are only
-- deleted, when not referenced by other components.
--
-- PARAMETERS
--     p_web_src_module_id    IN    ID of the web source module to remove
--     p_remove_remote_server IN    whether to remove the remote server
--     p_remove_data_profile  IN    whether to remove the data profile
--
--==============================================================================
procedure remove_web_src_module(
    p_web_src_module_id    in number,
    p_application_id       in number,
    p_remove_remote_server in boolean default false,
    p_remove_data_profile  in boolean default false );

--==============================================================================
-- API for App Builder: Discovers a generic REST service. Invokes the GET operation
-- on the URL endpoint passed in as the P_URL_ENDPOINT argument. The function samples
-- the response JSON and generates a data profile. Discovered service meta data is
-- stored in the P_COLLECTION collection.
--
-- C001: Information type: 
--      DATA_PROFILE:
--          C002: row_selector
--          C003: is_single_row (Y|N)
--          C004: response format (XML|JSON)
--          C005: xml_namespaces (XML only)
--          CLOB001: raw data
--      DATA_PROFILE_COLUMNS:
--          C002: column_name,
--          C003: is_primary_key (Y|N)
--          C004: data_type
--          C005: max_length
--          C006: format_mask (DATE or TIMESTAMP types)
--          C007: has_time_zone
--          C008: selector
--      ERROR:
--          C002: HTTP Status Code
--       CLOB001: response CLOB
--
-- Based on the discovered data profile, the service response is parsed for data
-- columns. Rows and column values are stored into the P_DATA_COLLECTION collection.
--
-- PARAMETERS
--     p_url_endpoint       URL of the REST service to discover
--     p_auth_scheme        Authorization: None, Basic or OAUTH_CLIENTCRED
--     p_client_id          OAuth Client ID or username
--     p_client_secret      OAuth Client Secret or password
--     p_row_selector       row selector to use for response data sampling
--     p_auto_detect        try to auto-detect the row selector
--     p_collection         collection to store service meta data
--     p_data_collection    collection to store service sample data
--==============================================================================
procedure get_generic_web_source_info(
    p_url_endpoint        in varchar2,
    p_method              in varchar2                       default 'GET',
    --
    p_auth_scheme         in varchar2                       default null,
    p_oauth_token_url     in varchar2                       default null,
    p_client_id           in varchar2                       default null,
    p_client_secret       in varchar2                       default null,
    --
    p_https_host          in varchar2                       default null,
    --
    p_request_body        in varchar2                       default null,
    --
    p_row_selector        in varchar2                       default null,
    p_is_single_row       in boolean                        default null,
    p_auto_detect         in boolean                        default true,
    --
    p_parameter_types     in wwv_flow_t_varchar2,
    p_parameter_names     in wwv_flow_t_varchar2,
    p_parameter_values    in wwv_flow_t_varchar2,
    p_parameter_static    in wwv_flow_t_varchar2,
    --
    p_collection          in varchar2                       default 'WEB_SOURCE_INFO',
    p_data_collection     in varchar2                       default 'WEB_SOURCE_DATA' );


--==============================================================================
-- executes a web source operation and stores the response into a collection
--
-- PARAMETERS
--     p_web_src_module_id     Web Source Module ID
--     p_web_src_operation_id  ID of the operation to execute
--     p_collection            name of the collection to write the information to
--==============================================================================
procedure test_web_src_operation(
    p_web_src_module_id    in number,
    p_web_src_operation_id in number,
    p_data_collection      in varchar2 default 'WEB_SOURCE_DATA',
    p_info_collection      in varchar2 default 'WEB_SOURCE_INFO'); 

--==============================================================================
-- API for App Builder: Discovers an ADF BC REST service. 
-- 2) Invokes the GET operation on the URL endpoint passed in as the P_URL_ENDPOINT 
--    argument. Also retrieves service desciption by fetching the {url-endpoint}/describe resource.
--
-- C001: Information type: 
--      DATA_PROFILE:
--          C002: row_selector
--          C003: is_single_row (Y|N)
--          C004: response format (XML|JSON)
--          C005: xml_namespaces (XML only)
--      DATA_PROFILE_COLUMNS:
--          C002: column_name,
--          C003: is_primary_key (Y|N)
--          C004: data_type
--          C005: max_length
--          C006: format_mask (DATE or TIMESTAMP types)
--          C007: has_time_zone
--          C008: selector
--      ERROR:
--          C002: HTTP Status Code
--       CLOB001: response CLOB
--
-- Based on the discovered data profile, the service response is parsed for data
-- columns. Rows and column values are stored into the P_DATA_COLLECTION collection.
--
-- PARAMETERS
--     p_url_endpoint       URL of the REST service to discover
--     p_auth_scheme        Authorization: None, Basic or OAUTH_CLIENTCRED
--     p_client_id          OAuth Client ID or username
--     p_client_secret      OAuth Client Secret or password
--     p_collection         collection to store service meta data
--     p_data_collection    collection to store service sample data
--==============================================================================
procedure get_adfbc_web_source_info(
    p_url_endpoint        in varchar2,
    p_auth_scheme         in varchar2                        default null,
    p_oauth_token_url     in varchar2                        default null,
    p_client_id           in varchar2                        default null,
    p_client_secret       in varchar2                        default null,
    p_https_host          in varchar2                        default null,
    --
    p_parameter_types     in wwv_flow_t_varchar2,
    p_parameter_names     in wwv_flow_t_varchar2,
    p_parameter_values    in wwv_flow_t_varchar2,
    p_parameter_static    in wwv_flow_t_varchar2,
    --
    p_collection          in varchar2                        default 'WEB_SOURCE_INFO',
    p_data_collection     in varchar2                        default 'WEB_SOURCE_DATA' );

--==============================================================================
-- API for App Builder: Discovers an ORDS REST service. 
-- 1) Invokes the OPTIONS request in order to get available HTTP methods for
--    this service.
-- 2) Invokes the GET operation on the URL endpoint passed in as the P_URL_ENDPOINT 
--    argument. In the response the procedure retrieves the JSON, looks up the 
--    "describedBy" attribute and fetches the /metadata-catalog JSON document. 
--    When there is no "describedBy" attribute or the meta data is incomplete, the
--    data profile is determined by sampling the response data, like for a generuc
--    REST service.
--
-- C001: Information type: 
--      METHODS:
--          C002: HTTP method (GET | POST | PUT | DELETE )
--          C003: URL Endpoint
--      DATA_PROFILE:
--          C002: row_selector
--          C003: is_single_row (Y|N)
--          C004: response format (XML|JSON)
--          C005: xml_namespaces (XML only)
--      DATA_PROFILE_COLUMNS:
--          C002: column_name,
--          C003: is_primary_key (Y|N)
--          C004: data_type
--          C005: max_length
--          C006: format_mask (DATE or TIMESTAMP types)
--          C007: has_time_zone
--          C008: selector
--      ERROR:
--          C002: HTTP Status Code
--       CLOB001: response CLOB
--
-- Based on the discovered data profile, the service response is parsed for data
-- columns. Rows and column values are stored into the P_DATA_COLLECTION collection.
--
-- PARAMETERS
--     p_url_endpoint       URL of the REST service to discover
--     p_auth_scheme        Authorization: None, Basic or OAUTH_CLIENTCRED
--     p_client_id          OAuth Client ID or username
--     p_client_secret      OAuth Client Secret or password
--     p_collection         collection to store service meta data
--     p_data_collection    collection to store service sample data
--==============================================================================
procedure get_ords_web_source_info(
    p_url_endpoint        in varchar2,
    p_auth_scheme         in varchar2                        default null,
    p_oauth_token_url     in varchar2                        default null,
    p_client_id           in varchar2                        default null,
    p_client_secret       in varchar2                        default null,
    p_https_host          in varchar2                        default null,
    --
    p_parameter_types     in wwv_flow_t_varchar2,
    p_parameter_names     in wwv_flow_t_varchar2,
    p_parameter_values    in wwv_flow_t_varchar2,
    p_parameter_static    in wwv_flow_t_varchar2,
    --
    p_collection          in varchar2                        default 'WEB_SOURCE_INFO',
    p_data_collection     in varchar2                        default 'WEB_SOURCE_DATA' );

--==============================================================================
-- stores data profile columns after discovery or rediscovery
--==============================================================================
procedure store_data_profile_columns(
    p_application_id      in number              default v('FB_FLOW_ID'),
    p_data_profile_id     in number, 
    p_info_collection     in varchar2            default 'WEB_SOURCE_INFO',
    p_replace             in boolean             default false );

--==============================================================================
-- stores a web source module based on discovery information
--==============================================================================
procedure store_web_src_module(
    p_application_id      in number              default v('FB_FLOW_ID'),
    p_module_name         in varchar2,
    p_web_source_type     in varchar2,
    p_http_method         in varchar2,
    --
    p_remote_server_id    in number              default null,
    p_server_base_url     in varchar2            default null,
    p_url_pattern         in varchar2,
    p_https_host          in varchar2            default null,
    --
    p_oauth_token_url     in varchar2            default null,
    --
    p_credential_store_id in number              default null,
    p_auth_scheme         in varchar2            default null,
    p_client_id           in varchar2            default null,
    p_client_secret       in varchar2            default null,
    p_username            in varchar2            default null,
    p_password            in varchar2            default null,
    --
    p_info_collection     in varchar2            default 'WEB_SOURCE_INFO' );

--==============================================================================
-- stores a web source module without discovery. Operations and data profile
-- will be populated with some default values.
--==============================================================================
procedure store_manual_web_source(
    p_application_id      in number              default v('FB_FLOW_ID'),
    p_module_name         in varchar2,
    p_web_source_type     in varchar2,
    p_http_method         in varchar2,
    --
    p_remote_server_id    in number              default null,
    p_server_base_url     in varchar2            default null,
    p_url_pattern         in varchar2,
    p_https_host          in varchar2            default null,
    --
    p_oauth_token_url     in varchar2            default null,
    --
    p_credential_store_id in number              default null,
    p_auth_scheme         in varchar2            default null,
    p_client_id           in varchar2            default null,
    p_client_secret       in varchar2            default null,
    --
    p_row_selector        in varchar2            default null,
    p_is_single_row       in boolean             default null,
    --
    p_parameter_types     in wwv_flow_t_varchar2,
    p_parameter_names     in wwv_flow_t_varchar2,
    p_parameter_values    in wwv_flow_t_varchar2,
    p_parameter_static    in wwv_flow_t_varchar2,
    --
    p_collection          in varchar2                       default 'WEB_SOURCE_INFO' );

--==============================================================================
-- synchronizes module level attributes in all components based on the
-- given web source module id.
--==============================================================================
procedure sync_module_attributes(
    p_application_id       in number,
    p_web_src_module_id    in number );

--==============================================================================
-- synchronizes module level attributes in all processes based on the
-- given web source operation id.
--==============================================================================
procedure sync_operation_attributes(
    p_application_id       in number,
    p_web_src_operation_id in number );

--==============================================================================
-- returns true when there are parameters for the specified web source module 
-- and database operation. 
--==============================================================================
function has_parameters(
    p_application_id       in number,
    p_web_src_module_id    in number,
    p_database_operation   in varchar2 )
return boolean;


--==============================================================================
-- rediscover an existing web source module and generate a new data profile
--==============================================================================
procedure rediscover(
    p_web_src_module_id     in number,
    p_info_collection       in varchar2 default 'WEB_SOURCE_INFO',
    p_data_collection       in varchar2 default 'WEB_SOURCE_DATA' );

--==============================================================================
-- entry point for builder pages 1943, 1944 and others to either discover 
-- web source information (store in collection) or to manually store a web
-- source module.
--==============================================================================
procedure f4000_store_or_discover(
    p_application_id   in number,
    --
    p_action           in varchar2 default 'DISCOVER',
    --
    p_web_src_type     in varchar2,
    p_server_id        in number   default null,
    p_server_url       in varchar2,
    p_service_path     in varchar2,
    p_http_method      in varchar2 default 'GET',
    --
    p_https_host       in varchar2 default null,
    --
    p_auth_required    in boolean,
    p_cred_store       in number   default null,
    p_token_url        in varchar2 default null,
    --
    p_auth_type        in varchar2 default null,
    p_client_id        in varchar2 default null,
    p_client_secret    in varchar2 default null,
    p_username         in varchar2 default null,
    p_password         in varchar2 default null,
    --
    p_url_param_name1  in varchar2 default null,
    p_url_param_type1  in varchar2 default null,
    p_url_param_value1 in varchar2 default null,
    p_url_param_stat1  in varchar2 default 'N',
    --
    p_url_param_name2  in varchar2 default null,
    p_url_param_type2  in varchar2 default null,
    p_url_param_value2 in varchar2 default null,
    p_url_param_stat2  in varchar2 default 'N',
    --
    p_url_param_name3  in varchar2 default null,
    p_url_param_type3  in varchar2 default null,
    p_url_param_value3 in varchar2 default null,
    p_url_param_stat3  in varchar2 default 'N',
    --
    p_url_param_name4  in varchar2 default null,
    p_url_param_type4  in varchar2 default null,
    p_url_param_value4 in varchar2 default null,
    p_url_param_stat4  in varchar2 default 'N',
    --
    p_url_param_name5  in varchar2 default null,
    p_url_param_type5  in varchar2 default null,
    p_url_param_value5 in varchar2 default null,
    p_url_param_stat5  in varchar2 default 'N',
    --
    p_module_name      in varchar2 default null,
    --
    p_row_selector     in varchar2 default null,
    p_is_single_row    in boolean  default null,
    --
    p_info_collection  in varchar2 default 'WEB_SOURCE_INFO',
    p_data_collection  in varchar2 default 'WEB_SOURCE_DATA' );


--==============================================================================
-- entry point for builder pages 1943, 1944 and others to find an existing remote
-- server based on the given endpoint URL. Then -- split the URL into the server- 
-- and a service-specific part.
-- If no remote server is found, do a proposal for splitting the URL.
--==============================================================================
procedure f4000_find_remote_server(
    p_application_id    in  number,
    p_endpoint_url      in  varchar2,
    p_remote_server_id  out varchar2,
    p_remote_server_url out varchar2,
    p_server_url        out varchar2,
    p_service_path      out varchar2 ); 

--==============================================================================
-- entry point for builder pages 1943, 1944 and others to find an existing remote
-- server based on the given endpoint URL. Then -- split the URL into the server- 
-- and a service-specific part.
-- If no remote server is found, do a proposal for splitting the URL.
--==============================================================================
procedure f4000_test_endpoint_url(
    p_application_id   in     number,
    p_endpoint_url     in out varchar2,
    p_http_method      in     varchar2 default 'GET',
    p_https_host       in     varchar2,
    p_web_source_type  in     varchar2,
    p_url_param1_name  in     varchar2,
    p_url_param1_value in     varchar2,
    p_url_param2_name  in     varchar2,
    p_url_param2_value in     varchar2,
    --
    p_param1_name      out    varchar2,
    p_param1_type      out    varchar2,
    p_param1_value     out    varchar2,
    p_param2_name      out    varchar2,
    p_param2_type      out    varchar2,
    p_param2_value     out    varchar2,
    --
    p_auth_required    out    varchar2,
    p_success          out    varchar2,
    p_message          out    varchar2 );

end wwv_flow_web_src_dev;
/
show err

set define '^'

