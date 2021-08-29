set define '^' verify off
prompt ...wwv_flow_web_services
create or replace package wwv_flow_web_services as
------------------------------------------------------------------------------------------------------------------------
--  Copyright (c) Oracle Corporation 2002. All Rights Reserved.
--
--    NAME
--      wwv_flow_web_services.sql
--
--    DESCRIPTION
--      Flow Web Services
--
--    NOTES
--
--    INTERNATIONALIZATION
--      unknown
--
--    MULTI-CUSTOMER
--      unknown
--
--    SCRIPT ARGUMENTS
--      None
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED    (MM/DD/YYYY)
--      jkallman   07/23/2002 - Created
--      jkallman   08/05/2002 - Added parse
--      jkallman   08/07/2002 - Added get_error_code, get_error_message, print_rendered_result
--      jkallman   08/08/2002 - Added parmeters to make_request
--      jkallman   08/09/2002 - Added get_last_error_code, get_last_error_message
--      mhichwa    08/25/2002 - Added grant execute to public
--      jstraub    04/21/2004 - Added UDDI_request, find_proxy, find_services_by_busname,
--                              find_services_by_servname, get_service_details, WSDL_analyze,
--                              create_web_service to add UDDI browsing and improved web services features.
--      jstraub    04/23/2004 - Added second make_request procedure to support new process type
--      jstraub    05/05/2004 - Added get_path, and append element to dynamically build xpath and request envelope
--      jstraub    05/07/2004 - Added update_process_parms to support updating process of type web service
--      jstraub    05/14/2004 - Significantly changed the way paramaters relate, using ID instead of name, and changed parsing of response
--      jstraub    05/17/2004 - Added p_in_msg_style parameters to generate_body and append_element
--      jstraub    05/17/2004 - Added p_level parameter to get_path to support getting partial paths
--      jstraub    05/20/2004 - Added generate_query
--      jstraub    06/02/2004 - Added generate_header and append_element2 to support soap:header
--      jstraub    08/20/2004 - Added p_type to append_element and append_element2
--      jstraub    11/16/2006 - Added p_soap_style to create_web_service
--      jstraub    11/17/2006 - Added p_style to generate_envelope
--      jstraub    12/11/2006 - Added p_username and p_password to WSDL_analyze to support basic auth for 11g XDB Web services
--      jstraub    12/12/2006 - Added p_basic_auth to create_web_service to support basic auth for 11g XDB Web services
--      jstraub    12/12/2006 - Added p_username and p_password to function make_request to support basic auth
--      jstraub    12/15/2006 - Added p_wallet_path and p_wallet_pwd to make_request to support SSL (HTTPS)
--      jstraub    12/15/2006 - Added get_wallet_info to support SSL (HTTPS)
--      jstraub    12/22/2006 - Added create_auth_parms for basic auth support
--      jstraub    01/03/2006 - Removed get_wallet_info, no longer necessary since wallet info now platform preference
--      jstraub    01/05/2006 - Added generate_query_manual to support manual web references
--      jstraub    01/16/2009 - Added p_soap_style to append_element, append_element2, generate_body, generate_header (bug 7718753)
--      jstraub    03/27/2009 - Removed p_01 to p_10 parameters from make_request
--      jstraub    03/27/2009 - Removed obsolete generate_envelope functions
--      jstraub    04/02/2009 - Removed obsolete get_error_code, get_error_message, get_last_error_code
--      jstraub    06/03/2009 - Added create_rest_web_reference, make_rest_request, update_rest_web_reference
--      jstraub    06/09/2009 - Added p_xmlns parameter to create_rest_web_reference, update_rest_web_reference
--      jstraub    06/10/2009 - Added p_http_hdr_values to make_rest_request
--      jstraub    07/27/2009 - Added p_input_format and p_body to create_rest_web_reference to support other REST input types than name/value pairs
--      jstraub    08/13/2009 - Added p_body_blob() to make_rest_request to support file input type
--      jstraub    08/24/2009 - Added make_soap_request to consolidate sys.UTL_HTTP SOAP logic
--      jstraub    01/11/2010 - Added p_soap_version to create_web_service
--      jstraub    01/11/2010 - Added p_version to generate_envelope
--      jstraub    03/01/2010 - Added p_form_qualified to append_element and append_element2
--      jstraub    05/18/2011 - Added p_transfer_timeout to make_rest_request and make_soap_request (bug 11886970)
--      cneumuel   04/17/2012 - Prefix sys objects with schema (bug #12338050)
--      jstraub    04/09/2014 - Added function make_rest_request_b returning BLOB
--      jstraub    04/09/2014 - Added p_scheme for auth type in make_request, make_rest_request*, make_soap_request
--      cczarski   09/20/2016 - Added OAuth2 "Client Credentials" Authentication for REST Requests (oauth_authenticate);feature #2052
--      cczarski   04/06/2017 - Added overloadings for make_rest_request to work with a credential store (feature #2117)
--                              Improved comment formatting and added function return values and examples
--      cczarski   04/07/2017 - Added make_rest_request_a returning wwv_flow_global.vc_arr2 for JSON responses
--      cczarski   09/13/2017 - Added p_https_host argument to the MAKE_*_REQUEST calls (ignored in DB versions below 12.2)
--      cczarski   11/14/2017 - API changes due to the move of credentials to the workspace level
--
------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------
-- globals for response, clob and sys.xmltype
--
type flow_soap_response_clob    is table of clob index by binary_integer;
g_flow_soap_response_clob       flow_soap_response_clob;

type flow_soap_response_xmltype is table of sys.xmltype index by binary_integer;
g_flow_soap_response_xmltype    flow_soap_response_xmltype;

type flow_soap_idx              is table of number index by binary_integer;
g_flow_soap_idx                 flow_soap_idx;

g_flow_soap_error_code          sys.dbms_sql.varchar2_table;
g_flow_soap_error_message       sys.dbms_sql.varchar2_table;

empty_vc_arr                    wwv_flow_global.vc_arr2;
g_body                          varchar2(32000);
g_header                        varchar2(32000);

function generate_envelope(
    p_operation in varchar2,
    p_style     in varchar2,
    p_ns        in varchar2,
    p_version   in varchar2 default '1.1',
    p_body      in clob,
    p_header    in clob )
return clob;

function make_request(
    p_url            in varchar2,
    p_action         in varchar2,
    p_version        in varchar2 default '1.1',
    p_envelope       in clob,
    p_username       in varchar2,
    p_password       in varchar2,
    p_scheme         in varchar2 default 'Basic',
    p_proxy_override in varchar2 default null,
    p_charset        in varchar2 default null,
    p_wallet_path    in varchar2,
    p_wallet_pwd     in varchar2,
    p_https_host     in varchar2 default null )
return clob;

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an clob.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE
-- * p_username             The username if basic authentication is required for this service
-- * p_password             The password if basic authentication is required for this service
-- * p_scheme               The authentication scheme, Basic (default), OAUTH_CLIENT_CRED or AWS
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- RETURNS
--   The REST service response as a CLOB
--
-- EXAMPLE
--   invoke a REST service returning a CLOB
--
--   begin
--       wwv_flow_web_services.make_rest_request(
--           p_url         => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method => 'GET' );
--   end;
--======================================================================================================================
function make_rest_request(
    p_url               in varchar2,
    p_http_method       in varchar2,
    p_username          in varchar2,
    p_password          in varchar2,
    p_scheme            in varchar2 default 'Basic',
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number default 180,
    p_body              in clob default empty_clob(),
    p_body_blob         in blob default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2 default null )
return clob;

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an clob. Use a credential store for authentication.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE

-- * p_credential_id        The ID of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.

-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- RETURNS
--   The REST service response as a CLOB
--
-- EXAMPLE
--   invoke a REST service returning a CLOB. Use the credential store  ID 4711 within application 100 and a token
--   URL to get the OAuth access token from.
--
--   begin
--       wwv_flow_web_services.make_rest_request(
--           p_url            => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method    => 'GET',
--           p_application_id => 100,
--           p_token_url      => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
function make_rest_request(
    p_url               in varchar2,
    p_http_method       in varchar2,
    --
    p_credential_id     in number,
    p_token_url         in varchar2                default null,
    --
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_body              in clob                    default empty_clob(),
    p_body_blob         in blob                    default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2                default null ) return clob;

--======================================================================================================================
-- This procedure invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as wwv_flow_global.vc_arr2. Use a credential store for authentication.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE
-- * p_username             The username if basic authentication is required for this service
-- * p_password             The password if basic authentication is required for this service
-- * p_scheme               The authentication scheme, Basic (default), OAUTH_CLIENT_CRED or AWS
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request

-- * p_response_array       OUT-Parameter: The response as wwv_flow_global.vc_arr2 type
--
-- EXAMPLE
--   invoke a REST service returning a CLOB. Use the credential store  ID 4711 within application 100 and a token
--   URL to get the OAuth access token from.
--
--   begin
--       wwv_flow_web_services.make_rest_request_a(
--           p_url            => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method    => 'GET',
--           p_application_id => 100,
--           p_token_url      => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
procedure make_rest_request_a(
    p_url               in varchar2,
    p_http_method       in varchar2,
    p_username          in varchar2,
    p_password          in varchar2,
    p_scheme            in varchar2                default 'Basic',
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_body              in clob                    default empty_clob(),
    p_body_blob         in blob                    default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2                default null,
    p_response_array    in out nocopy wwv_flow_global.vc_arr2 );

--======================================================================================================================
-- This procedure invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as wwv_flow_global.vc_arr2. Use a credential store for authentication.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE

-- * p_credential_id        The ID of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.

-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request

-- * p_response_array       OUT-Parameter: The response as wwv_flow_global.vc_arr2 type
--
-- EXAMPLE
--   invoke a REST service returning a CLOB. Use the credential store  ID 4711 within application 100 and a token
--   URL to get the OAuth access token from.
--
--   begin
--       wwv_flow_web_services.make_rest_request_a(
--           p_url            => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method    => 'GET',
--           p_application_id => 100,
--           p_token_url      => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
procedure make_rest_request_a(
    p_url               in varchar2,
    p_http_method       in varchar2,
    --
    p_credential_id     in number,
    p_token_url         in varchar2                default null,
    --
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_body              in clob                    default empty_clob(),
    p_body_blob         in blob                    default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2, 
    p_https_host        in varchar2                default null,
    p_response_array    in out nocopy wwv_flow_global.vc_arr2 );

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an blob.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE
-- * p_username             The username if basic authentication is required for this service
-- * p_password             The password if basic authentication is required for this service
-- * p_scheme               The authentication scheme, Basic (default), OAUTH_CLIENT_CRED or AWS
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- RETURNS
--   The REST service response as a BLOB
--
-- EXAMPLE
--   invoke a REST service returning a BLOB
--
--   begin
--       wwv_flow_web_services.make_rest_request_b(
--           p_url         => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method => 'GET' );
--   end;
--======================================================================================================================
function make_rest_request_b(
    p_url               in varchar2,
    p_http_method       in varchar2,
    p_username          in varchar2,
    p_password          in varchar2,
    p_scheme            in varchar2 default 'Basic',
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number default 180,
    p_body              in clob default empty_clob(),
    p_body_blob         in blob default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2, 
    p_https_host        in varchar2                default null)
return blob;

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an blob. Use a credential store for authentication.
--
-- PARAMETERS
-- * p_url                  The url endpoint of the Web service
-- * p_http_method          The HTTP Method to use, PUT, POST, GET, HEAD or DELETE

-- * p_credential_id        The ID of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.

-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
--
-- * p_body                 The HTTP payload to be sent as clob
-- * p_body_blob            The HTTP payload to be sent as binary blob (ex., posting a file)
-- * p_parm_name            The name of the parameters to be used in name/value pairs
-- * p_parm_value           The value of the paramters to be used in name/value pairs
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- RETURNS
--   The REST service response as a BLOB
--
-- EXAMPLE
--   invoke a REST service returning a BLOB. Use the credential store  ID 4711 within application 100 and a token
--   URL to get the OAuth access token from.
--
--   begin
--       wwv_flow_web_services.make_rest_request_b(
--           p_url            => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method    => 'GET',
--           p_application_id => 100,
--           p_token_url      => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
function make_rest_request_b(
    p_url               in varchar2,
    p_http_method       in varchar2,
    --
    p_credential_id     in number,
    p_token_url         in varchar2                default null,
    --
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_body              in clob                    default empty_clob(),
    p_body_blob         in blob                    default empty_blob(),
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2                default null ) return blob;

--======================================================================================================================
-- This procedure invokes a Web service with the supplied SOAP envelope and returns
-- the response as an sys.xmltype.
--
-- PARAMETERS:
-- * p_url                  The url endpoint of the Web service
-- * p_action               The SOAP Action corresponding to the operation invoked
-- * p_version              The SOAP version, 1.1 or 1.2
-- * p_envelope             The SOAP envelope to post to the service
-- * p_username             The username if basic authentication is required for this service
-- * p_password             The password if basic authentication is required for this service
-- * p_scheme               The authentication scheme, Basic (default) or AWS
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https
--                          ex., file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
-- * p_http_headers         Array of HTTP Header Names to be set for the SOAP request
-- * p_http_hdr_values      Array of HTTP Header Values to be set for the SOAP request
--
-- EXAMPLE
--   invoke a SOAP service and store the response into a collection
--
--   begin
--       apex_web_service.make_request(
--           p_url             => 'http://{host}:{port}/path/to/soap/service/',
--           p_action          => 'doSoapRequest',
--           p_envelope        => '{SOAP envelope in XML format}' );
--   end;
--======================================================================================================================
function make_soap_request(
    p_url               in varchar2,
    p_action            in varchar2                default null,
    p_version           in varchar2                default '1.1',
    p_envelope          in clob,
    p_username          in varchar2                default null,
    p_password          in varchar2                default null,
    p_scheme            in varchar2                default 'Basic',
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_wallet_path       in varchar2                default null,
    p_wallet_pwd        in varchar2                default null,
    p_https_host        in varchar2                default null,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr) return clob;

--======================================================================================================================
-- This procedure invokes a Web service with the supplied SOAP envelope and returns
-- the response as an sys.xmltype.
--
-- PARAMETERS:
-- * p_url                  The url endpoint of the Web service
-- * p_action               The SOAP Action corresponding to the operation invoked
-- * p_version              The SOAP version, 1.1 or 1.2
-- * p_envelope             The SOAP envelope to post to the service
--
-- * p_application_id       The ID of the application which contains the credential store to be used.
-- * p_credential_name      The name of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.
--
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https
--                          ex., file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
-- * p_http_headers         Array of HTTP Header Names to be set for the SOAP request
-- * p_http_hdr_values      Array of HTTP Header Values to be set for the SOAP request
--
-- EXAMPLE
--   invoke a SOAP service returning an XMLTYPE. 
--
--   declare
--       l_xml sys.xmltype;
--   begin
--       l_xml := apex_web_service.make_request(
--           p_url            => 'http://{host}:{port}/path/to/soap/service/',
--           p_action         => 'doSoapRequest',
--           p_envelope       => '{SOAP envelope in XML format}',
--           p_application_id  => 100,
--           p_credential_name => 'My Credentials',
--           p_token_url       => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
function make_soap_request(
    p_url               in varchar2,
    p_action            in varchar2                default null,
    p_version           in varchar2                default '1.1',
    p_envelope          in clob,
    --
    p_credential_id     in number,
    p_token_url         in varchar2                default null,
    --
    p_proxy_override    in varchar2                default null,
    p_transfer_timeout  in number                  default 180,
    p_wallet_path       in varchar2                default null,
    p_wallet_pwd        in varchar2                default null,
    p_https_host        in varchar2                default null,
    p_http_headers      in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_http_hdr_values   in wwv_flow_global.vc_arr2 default empty_vc_arr ) return clob;

procedure make_request(
    p_id             in number,
    p_process_id     in number,
    p_charset        in varchar2 default null );

procedure make_request(
    p_id             in number,
    p_operation_id   in number,
    p_process_id     in number,
    p_charset        in varchar2 default null );

function render_request(
    p_service_id     in number,
    p_stylesheet     in clob   default null,
    p_occurrence     in number default 1,
    p_stylesheet_id  in number default null)
return clob;

procedure print_rendered_result(
    p_service_id     in number,
    p_stylesheet     in clob   default null,
    p_occurrence     in number default 1,
    p_stylesheet_id  in number default null );

function parse( p_clob in clob )
return clob ;

function get_last_error_message
return varchar2;

function find_proxy(
    p_flow_id   in varchar2)
return varchar2;

function get_parm_value(
    p_parm_id       in number,
    p_process_id    in number )
return varchar2;

function get_parm_value(
    p_name          in varchar2,
    p_parm_name     in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value    in wwv_flow_global.vc_arr2 default empty_vc_arr )
return varchar2;

procedure append_element(
    p_process_id        in number default null,
    p_parm_id           in number,
    p_name              in varchar2,
    p_is_xsd            in varchar2,
    p_form_qualified    in varchar2,
    p_type              in varchar2,
    p_operation_id      in number,
    p_in_msg_style      in varchar2,
    p_soap_style        in varchar2,
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr );

procedure append_element2(
    p_process_id        in number default null,
    p_parm_id           in number,
    p_name              in varchar2,
    p_is_xsd            in varchar2,
    p_form_qualified    in varchar2,
    p_type              in varchar2,
    p_operation_id      in number,
    p_in_msg_style      in varchar2,
    p_ns                in varchar2,
    p_soap_style        in varchar2,
    p_parm_name         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value        in wwv_flow_global.vc_arr2 default empty_vc_arr );

procedure generate_body(
    p_process_id    in number default null,
    p_operation_id  in number,
    p_in_msg_style  in varchar2,
    p_soap_style    in varchar2,
    p_parm_name     in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value    in wwv_flow_global.vc_arr2 default empty_vc_arr );

procedure generate_header(
    p_process_id    in number default null,
    p_operation_id  in number,
    p_in_msg_style  in varchar2,
    p_ns            in varchar2,
    p_soap_style    in varchar2,
    p_parm_name     in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value    in wwv_flow_global.vc_arr2 default empty_vc_arr );

function get_path(
    p_parm_id       in number,
    p_level         in number default 0 )
return varchar2;

function generate_query(
    p_operation_id              in number,
    p_array_parm                in number,
    p_report_collection_name    in varchar2,
    p_array_parms_collection    in varchar2 )
return varchar2;

function generate_query_manual(
    p_result_node               in varchar2,
    p_soap_style                in varchar2,
    p_message_format            in varchar2,
    p_namespace                 in varchar2,
    p_report_collection_name    in varchar2,
    p_array_parms_collection    in varchar2 )
return varchar2;

function UDDI_request(
    p_uddi_url              in varchar2,
    p_request_type          in varchar2,
    p_request_parameter     in varchar2,
    p_proxy_url             in varchar2,
    p_request_parameter2    in varchar2 default null,
    p_uddi_version          in varchar2 default '2.0' )
return sys.xmltype;

procedure find_services_by_servname(
    p_uddi_url              in varchar2,
    p_request_parameter2    in varchar2,
    p_flow_id               in varchar2,
    p_services_collection   in varchar2,
    p_exact                 in varchar2 default 'N',
    p_case_sensitive        in varchar2 default 'N',
    p_uddi_version          in varchar2 default '2.0' );

procedure find_services_by_busname(
    p_uddi_url              in varchar2,
    p_request_parameter     in varchar2,
    p_flow_id               in varchar2,
    p_services_collection   in varchar2,
    p_exact                 in varchar2 default 'N',
    p_case_sensitive        in varchar2 default 'N',
    p_uddi_version          in varchar2 default '2.0' );

procedure get_service_details(
    p_uddi_url              in varchar2,
    p_request_parameter     in varchar2,
    p_flow_id               in varchar2,
    p_services_collection   in varchar2,
    p_details_collection    in varchar2,
    p_uddi_version          in varchar2 default '2.0' );

function WSDL_analyze(
    p_wsdl_url                      in varchar2,
    p_flow_id                       in varchar2,
    p_uddi_details_collection       in varchar2,
    p_web_service_collection        in varchar2,
    p_operations_collection         in varchar2,
    p_inputs_collection             in varchar2,
    p_outputs_collection            in varchar2,
    p_username                      in varchar2,
    p_password                      in varchar2 )
return varchar2;

procedure create_web_service(
    p_id                            in number,
    p_flow_id                       in varchar2,
    p_name                          in varchar2,
    p_url                           in varchar2,
    p_target_ns                     in varchar2,
    p_xsd_prefix                    in varchar2,
    p_soap_style                    in varchar2,
    p_soap_version                  in varchar2 default '1.1',
    p_operations_collection         in varchar2,
    p_inputs_collection             in varchar2,
    p_outputs_collection            in varchar2,
    p_basic_auth                    in varchar2 );

procedure create_rest_web_reference(
    p_id                            in number,
    p_flow_id                       in varchar2,
    p_name                          in varchar2,
    p_url                           in varchar2,
    p_proxy_override                in varchar2,
    p_http_method                   in varchar2,
    p_input_format                  in varchar2,
    p_body                          in varchar2,
    p_output_format                 in varchar2,
    p_xpath                         in varchar2,
    p_xmlns                         in varchar2,
    p_text_parm_delim               in varchar2,
    p_text_record_delim             in varchar2,
    p_inputs_collection             in varchar2,
    p_outputs_collection            in varchar2,
    p_headers_collection            in varchar2,
    p_basic_auth                    in varchar2 );

procedure update_rest_web_reference(
    p_id                            in number,
    p_flow_id                       in varchar2,
    p_name                          in varchar2,
    p_url                           in varchar2,
    p_proxy_override                in varchar2,
    p_http_method                   in varchar2,
    p_input_format                  in varchar2,
    p_body                          in varchar2,
    p_output_format                 in varchar2,
    p_xpath                         in varchar2,
    p_xmlns                         in varchar2,
    p_text_parm_delim               in varchar2,
    p_text_record_delim             in varchar2,
    p_inputs_collection             in varchar2,
    p_outputs_collection            in varchar2,
    p_headers_collection            in varchar2,
    p_basic_auth                    in varchar2 );

procedure update_process_parms(
    p_process_id                    in number,
    p_in_parm_ids                   in wwv_flow_global.vc_arr2,
    p_in_parm_map_types             in wwv_flow_global.vc_arr2,
    p_in_parm_values                in wwv_flow_global.vc_arr2,
    p_out_map_type                  in varchar2,
    p_out_parm_ids                  in wwv_flow_global.vc_arr2,
    p_out_parm_values               in wwv_flow_global.vc_arr2,
    p_auth_parm_ids                 in wwv_flow_global.vc_arr2,
    p_auth_parm_map_types           in wwv_flow_global.vc_arr2,
    p_auth_parm_values              in wwv_flow_global.vc_arr2 );

procedure create_process_parms(
    p_process_id                    in number,
    p_in_parm_collection_name       in varchar2,
    p_out_map_type                  in varchar2,
    p_out_parm_collection_name      in varchar2 );

procedure create_auth_parms(
    p_process_id                    in number,
    p_auth_collection_name         in varchar2 );

--======================================================================================================================
-- This function performs OAUTH autentication using the Client ID and Client Secret passed in as arguments.
-- The obtained access token and its expiry date are stored in the global variable g_oauth_token.
--
-- type oauth_token is record(
--     token      varchar2(255),
--     expires    date );
--
-- PARAMETERS
-- * p_token_url            The url endpoint of the OAuth token service
-- * p_client_id            OAuth Client ID to use for authentication
-- * p_client_secret        OAuth Client Secret to use for authentication
-- * p_flow_type            OAuth flow type - only OAUTH_CLIENT_CRED is supported at this time
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- EXAMPLE
--   perform OAuth client credentials authentication using passed client ID and client secret
--   and obtain access token.
--
--   begin
--       apex_credential.oauth_authenticate (
--           p_token_url       => 'http://{host}:{port}/ords/scott/oauth/token',
--           p_client_id       => '6721hkj2-tzqugdw67843671..',
--           p_client_secret   => 'w87nsh8zF6124oij3ns2934...' );
--   end;
--======================================================================================================================
procedure oauth_authenticate(
    p_token_url         in varchar2,
    p_client_id         in varchar2,
    p_client_secret     in varchar2,
    p_flow_type         in varchar2 default wwv_flow_webservices_api.OAUTH_CLIENT_CRED,
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number   default 180,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2                default null );

--======================================================================================================================
-- This function performs OAUTH autentication using a credential store
-- The obtained access token and its expiry date are stored in the global variable g_oauth_token.
--
-- type oauth_token is record(
--     token      varchar2(255),
--     expires    date );
--
-- PARAMETERS
-- * p_token_url            The url endpoint of the OAuth token service
-- * p_credential_id        ID of the credential store to use.
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- EXAMPLE
--   perform OAuth client credentials authentication using passed client ID and client secret
--   and obtain access token.
--
--   begin
--       apex_credential.oauth_authenticate (
--           p_token_url       => 'http://{host}:{port}/ords/scott/oauth/token',
--           p_credential_id   => 312786312489789423 );
--   end;
--======================================================================================================================
procedure oauth_authenticate(
    p_token_url         in varchar2,
    p_credential_id     in number,
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number   default 180,
    p_wallet_path       in varchar2,
    p_wallet_pwd        in varchar2,
    p_https_host        in varchar2                default null );

end wwv_flow_web_services;
/
show errors
