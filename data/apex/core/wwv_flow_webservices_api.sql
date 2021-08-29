set define '^' verify off
prompt ...wwv_flow_webservices_api
create or replace package wwv_flow_webservices_api as
------------------------------------------------------------------------------------------------------------------------
--
--   Copyright (c) Oracle Corporation 2009 - 2017. All Rights Reserved.
-- 
--     NAME
--       wwv_flow_webservices_api.sql
-- 
--     DESCRIPTION
--       API to interact with Web services.
-- 
--     NOTES
-- 
--     SCRIPT ARGUMENTS
--       None
-- 
--     RUNTIME DEPLOYMENT: YES
-- 
--     MODIFIED   (MM/DD/YYYY)
--       jstraub   02/06/2009 - Created
--       jstraub   08/27/2009 - Removed make_request function and procedure, consolidated to wwv_flow_web_services.make_soap_request
--       jstraub   09/22/2009 - Moved make_request functions and procedures from htmldb_util
--       jstraub   11/17/2009 - Removed p_http_headers parameters, no longer necessary with header globals
--       jstraub   05/18/2011 - Added p_transfer_timeout to make_rest_request and make_request (bug 11886970)
--       cneumuel  04/17/2012 - Prefix sys objects with schema (bug #12338050)
--       jstraub   04/09/2014 - Added function make_rest_request_b returning BLOB
--       jstraub   04/09/2014 - Added p_scheme for auth type in make_request and make_rest_request*
--       jstraub   04/14/2015 - Changed header.value type to varchar2(4096) bug (20882245)
--       cczarski  09/20/2016 - Added OAuth2 "Client Credentials" Authentication for REST Requests (oauth_authenticate);feature #2052
--       cczarski  09/27/2016 - Added OAUTH_SET_TOKEN in order to use OAuth tokens obtained otherwise than with OAUTH_AUTHENTICATE
--       cczarski  04/06/2016 - Added overloadings for make_rest_request to work with a credential store (feature #2117)
--                              Improved comment formatting and added function return values and examples
--       cczarski  09/13/2017 - Added p_https_host argument to the MAKE_*_REQUEST calls (ignored in DB versions below 12.2)
--       cczarski  09/18/2017 - Increase VARCHAR2 limit for OAuth Access token (bug #26817719)
--       cczarski  11/14/2017 - API changes due to the move of credentials to the workspace level
--      cczarski   06/27/2018 - expose "reason_phrase" in apex_web_service, like g_status_code (bug #27945850)
--
------------------------------------------------------------------------------------------------------------------------

OAUTH_CLIENT_CRED constant varchar2(30) := 'OAUTH_CLIENT_CRED';

type header is record (
    name       varchar2(256), 
    value      varchar2(4096) );

type header_table is table of header index by binary_integer;

type oauth_token is record(
    token      varchar2(32767),
    expires    date );

empty_vc_arr               wwv_flow_global.vc_arr2;

g_request_cookies          sys.utl_http.cookie_table;
g_response_cookies         sys.utl_http.cookie_table;

g_headers                  header_table;
g_request_headers          header_table;

g_status_code              pls_integer;
g_reason_phrase            varchar2(32767);

g_oauth_token              oauth_token;

--======================================================================================================================
-- This function converts a blob to base64 character encoded representation and
-- returns it as a clob.
--
-- PARAMETERS:
--   p_blob                 The blob to convert
--
-- RETURNS:
--   the base64 encoded representation of the input BLOB
-- 
-- EXAMPLE:
--
--   declare
--       l_base64 clob;
--       l_blob   blob;
--   begin
--       l_blob   := my_function_returning_a_blob;
--       l_base64 := apex_web_service.blob2clobbase64( l_blob );
--   end;
--======================================================================================================================
function blob2clobbase64 (
    p_blob in blob ) return clob;

--======================================================================================================================
-- This function converts base64 encoded binary data and returns it as a blob.
--
-- PARAMETERS:
--   p_clob                 The base64 encoded data
--
-- RETURNS:
--   the BLOB represented by the Base64 encoded data
-- 
-- EXAMPLE:
--
--   declare
--       l_base64 clob;
--       l_blob   blob;
--   begin
--       l_base64 := func_returning_base64_data;
--       l_blob   := apex_web_service.clobbase642blob( l_base64 );
--   end;
--======================================================================================================================
function clobbase642blob (
    p_clob in clob ) return blob;

--======================================================================================================================
-- This function invokes a Web service with the supplied SOAP envelope and returns
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
--
-- RETURNS
--   The SOAP service response as a XMLTYPE
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
--           p_envelope       => '{SOAP envelope in XML format}' );
--   end;
--======================================================================================================================
function make_request (
    p_url               in varchar2,
    p_action            in varchar2 default null,
    p_version           in varchar2 default '1.1',
    p_envelope          in clob,
    p_username          in varchar2 default null,
    p_password          in varchar2 default null,
    p_scheme            in varchar2 default 'Basic',
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number   default 180,
    p_wallet_path       in varchar2 default null,
    p_wallet_pwd        in varchar2 default null,
    p_https_host        in varchar2 default null) return sys.xmltype;

--======================================================================================================================
-- This procedure invokes a Web service with the supplied SOAP envelope and stores
-- the response in a collection.
--
-- PARAMETERS:
-- * p_url                  The url endpoint of the Web service
-- * p_action               The SOAP Action corresponding to the operation invoked
-- * p_version              The SOAP version, 1.1 or 1.2
-- * p_collection_name      The name of the collection to store the response
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
--
-- EXAMPLE
--   invoke a SOAP service and store the response into a collection
--
--   begin
--       apex_web_service.make_request(
--           p_url             => 'http://{host}:{port}/path/to/soap/service/',
--           p_collection_name => 'MY_RESPONSE_COLLECTION',
--           p_action          => 'doSoapRequest',
--           p_envelope        => '{SOAP envelope in XML format}' );
--   end;
--======================================================================================================================
procedure make_request (
    p_url               in varchar2,
    p_action            in varchar2 default null,
    p_version           in varchar2 default '1.1',
    p_collection_name   in varchar2 default null,
    p_envelope          in clob,
    p_username          in varchar2 default null,
    p_password          in varchar2 default null,
    p_scheme            in varchar2 default 'Basic',
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number   default 180,
    p_wallet_path       in varchar2 default null,
    p_wallet_pwd        in varchar2 default null,
    p_https_host        in varchar2 default null);

--======================================================================================================================
-- This function invokes a Web service with the supplied SOAP envelope and returns
-- the response as an sys.xmltype.
--
-- PARAMETERS:
-- * p_url                  The url endpoint of the Web service
-- * p_action               The SOAP Action corresponding to the operation invoked
-- * p_version              The SOAP version, 1.1 or 1.2
-- * p_envelope             The SOAP envelope to post to the service
--
-- * p_credential_static_id The static ID of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.
--
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https
--                          ex., file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- RETURNS
--   The SOAP service response as a XMLTYPE
--
-- EXAMPLE
--   invoke a SOAP service returning an XMLTYPE. 
--
--   declare
--       l_xml sys.xmltype;
--   begin
--       l_xml := apex_web_service.make_request(
--           p_url                  => 'http://{host}:{port}/path/to/soap/service/',
--           p_action               => 'doSoapRequest',
--           p_envelope             => '{SOAP envelope in XML format}',
--           p_credential_static_id => 'My_Credentials',
--           p_token_url            => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
function make_request (
    p_url                  in varchar2,
    p_action               in varchar2 default null,
    p_version              in varchar2 default '1.1',
    p_envelope             in clob,
    --
    p_credential_static_id in varchar2,
    p_token_url            in varchar2 default null,
    --
    p_proxy_override       in varchar2 default null,
    p_transfer_timeout     in number   default 180,
    p_wallet_path          in varchar2 default null,
    p_wallet_pwd           in varchar2 default null,
    p_https_host           in varchar2 default null ) return sys.xmltype;

--======================================================================================================================
-- This procedure invokes a Web service with the supplied SOAP envelope and stores
-- the response in a collection.
--
-- PARAMETERS:
-- * p_url                  The url endpoint of the Web service
-- * p_action               The SOAP Action corresponding to the operation invoked
-- * p_version              The SOAP version, 1.1 or 1.2
-- * p_credential_static_id The static ID of the credential store to be used.
-- * p_envelope             The SOAP envelope to post to the service
--
-- * p_credential_static_id The name of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.
--
-- * p_proxy_override       The proxy to use for the request
-- * p_transfer_timeout     The amount of time in seconds to wait for a response
-- * p_wallet_path          The filesystem path to a wallet if request is https
--                          ex., file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- EXAMPLE
--   invoke a SOAP service and store the response into a collection
--
--   begin
--       apex_web_service.make_request(
--           p_url                  => 'http://{host}:{port}/path/to/soap/service/',
--           p_collection_name      => 'MY_RESPONSE_COLLECTION',
--           p_action               => 'doSoapRequest',
--           p_envelope             => '{SOAP envelope in XML format}',
--           p_credential_static_id => 'My_Credentials',
--           p_token_url            => 'http://{host}:{port}/ords/scott/oauth/token' );
--   end;
--======================================================================================================================
procedure make_request (
    p_url                  in varchar2,
    p_action               in varchar2 default null,
    p_version              in varchar2 default '1.1',
    p_collection_name      in varchar2 default null,
    p_envelope             in clob,
    --
    p_credential_static_id in varchar2,
    p_token_url            in varchar2 default null,
    --
    p_proxy_override       in varchar2 default null,
    p_transfer_timeout     in number   default 180,
    p_wallet_path          in varchar2 default null,
    p_wallet_pwd           in varchar2 default null,
    p_https_host           in varchar2 default null);


--======================================================================================================================
-- This function performs OAUTH authentication and requests an OAuth access token.
-- The token and its expiry date are stored in the global variable g_oauth_token.
--
-- type oauth_token is record(
--     token      varchar2(255),
--     expires    date );
--
-- Currently only the Client Credentials flow is supported.
--
-- Arguments:
-- *  p_token_url            The url endpoint of the OAuth token service
-- *  p_client_id            OAuth Client ID to use for authentication
-- *  p_client_secret        OAuth Client Secret to use for authentication
-- *  p_flow_type            OAuth flow type - only OAUTH_CLIENT_CRED is supported at this time
-- *  p_proxy_override       The proxy to use for the request
-- *  p_transfer_timeout     The amount of time in seconds to wait for a response
-- *  p_wallet_path          The filesystem path to a wallet if request is https, e.g. file:/usr/home/oracle/WALLETS
-- *  p_wallet_pwd           The password to access the wallet
-- *  p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--======================================================================================================================
procedure oauth_authenticate(
    p_token_url         in varchar2,
    p_client_id         in varchar2,
    p_client_secret     in varchar2,
    p_flow_type         in varchar2 default OAUTH_CLIENT_CRED,
    p_proxy_override    in varchar2 default null,
    p_transfer_timeout  in number   default 180,
    p_wallet_path       in varchar2 default null,
    p_wallet_pwd        in varchar2 default null,
    p_https_host        in varchar2 default null);

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
-- * p_credential_static_id The static ID of the credential store to be used.
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
--       apex_web_service.oauth_authenticate (
--           p_token_url              => 'http://{host}:{port}/ords/scott/oauth/token',
--           p_credential_static_id   => 'My_credentials');
--   end;
--======================================================================================================================
procedure oauth_authenticate(
    p_token_url            in varchar2,
    p_credential_static_id in varchar2,
    p_proxy_override       in varchar2 default null,
    p_transfer_timeout     in number   default 180,
    p_wallet_path          in varchar2,
    p_wallet_pwd           in varchar2,
    p_https_host           in varchar2 default null);

--======================================================================================================================
-- this function returns the OAuth access token received in the last OAUTH_AUTHENTICATE call.
-- Returns NULL when the token is already expired or OAUTH_AUTHENTICATE has not been called.
--
-- RETURNS
--     the access token used in the latest APEX_WEB_SERVICE call.
--
-- EXAMPLE
-- 
-- declare
--     l_token varchar2(255);
-- begin
--     l_token := apex_web_service.oauth_get_last_token;
-- end;
--======================================================================================================================
function oauth_get_last_token return varchar2;

--======================================================================================================================
-- this procedure sets the OAuth Access token to be used in MAKE_REST_REQUEST calls within this *database* session. 
-- This procedure can be used to set a token which has been obtained by other means than with 
-- OAUTH_AUTHENTICATE (for instance, custom code).
--
-- PARAMETERS:
-- * p_token               The OAuth access token to be used by MAKE_REST_REQUEST calls
-- * p_expires             Optional: The token expiry date; NULL means: No expiration date.
--
-- EXAMPLE:
--
-- begin
--     apex_web_service.oauth_set_token( 
--         p_token => '37948987dqshjgd97638..' );
-- end;
--======================================================================================================================
procedure oauth_set_token(
    p_token          in varchar2,
    p_expires        in date      default null );

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an clob.
--
-- PARAMETERS:
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
-- * p_wallet_path          The filesystem path to a wallet if request is https
--                          ex., file:/usr/home/oracle/WALLETS
-- * p_wallet_pwd           The password to access the wallet
-- * p_https_host           The host name to be matched against the common name (CN) of the remote server's certificate for an HTTPS request
--
-- * p_credential_static_id The name of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.
--
-- RETURNS
--   The REST service response as a CLOB
--
-- EXAMPLE
--   invoke a REST service returning a CLOB. 

--   begin
--       apex_web_service.make_rest_request(
--           p_url            => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method    => 'GET' );
--   end;
--======================================================================================================================
function make_rest_request(
    p_url                  in varchar2,
    p_http_method          in varchar2,
    p_username             in varchar2                default null,
    p_password             in varchar2                default null,
    p_scheme               in varchar2                default 'Basic',
    p_proxy_override       in varchar2                default null,
    p_transfer_timeout     in number                  default 180,
    p_body                 in clob                    default empty_clob(),
    p_body_blob            in blob                    default empty_blob(),
    p_parm_name            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value           in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path          in varchar2                default null,
    p_wallet_pwd           in varchar2                default null,
    p_https_host           in varchar2                default null,
    --
    p_credential_static_id in varchar2                default null,
    p_token_url            in varchar2                default null) return clob;

--======================================================================================================================
-- This function invokes a RESTful Web service with the supplied name value pairs, body clob, or body blob
-- the response as an blob.
--
-- PARAMETERS:
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
-- * p_credential_static_id The name of the credential store to be used.
-- * p_token_url            For token-based authentication flows: The URL where to get the token from.
--
-- RETURNS
--   The REST service response as a BLOB
--
-- EXAMPLE
--   invoke a REST service returning a BLOB
--
--   begin
--       apex_web_service.make_rest_request_b(
--           p_url         => 'http://{host}:{port}/ords/scott/emp/',
--           p_http_method => 'GET' );
--   end;
--======================================================================================================================
function make_rest_request_b(
    p_url                  in varchar2,
    p_http_method          in varchar2,
    p_username             in varchar2                default null,
    p_password             in varchar2                default null,
    p_scheme               in varchar2                default 'Basic',
    p_proxy_override       in varchar2                default null,
    p_transfer_timeout     in number                  default 180,
    p_body                 in clob                    default empty_clob(),
    p_body_blob            in blob                    default empty_blob(),
    p_parm_name            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_parm_value           in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_wallet_path          in varchar2                default null,
    p_wallet_pwd           in varchar2                default null,
    p_https_host           in varchar2                default null,
    --
    p_credential_static_id in varchar2                default null,
    p_token_url            in varchar2                default null) return blob;

--======================================================================================================================
-- This function returns a particular node of an xml document and returns it as
-- a varchar.
--
-- PARAMETERS:
-- * p_xml                  The xmldocument as an sys.xmltype to parse
-- * p_xpath                The xPath to the desired node
-- * p_ns                   The namespace to the desired node
--
-- RETURNS:
--   the VARCHAR2 value of the XML node specified by the P_XPATH argument.
--
-- EXAMPLE:
-- 
--   declare
--       l_xml   xmltype := xmltype('<root><tag>Test</tag></root>');
--       l_value varchar2;
--   begin
--       l_value := apex_web_service.parse_xml(
--           p_xml    => l_xml,
--           p_xpath  => '/root/tag/text()' );
--   end; 
-- 
--======================================================================================================================
function parse_xml (
    p_xml               in sys.xmltype,
    p_xpath             in varchar2,
    p_ns                in varchar2 default null ) return varchar2;

--======================================================================================================================
-- This function returns a particular node of an xml document and returns it as
-- a varchar.
--
-- PARAMETERS:
-- * p_xml                  The xmldocument as an sys.xmltype to parse
-- * p_xpath                The xPath to the desired node
-- * p_ns                   The namespace to the desired node
--
-- RETURNS:
--   the CLOB value of the XML node specified by the P_XPATH argument.
--
-- EXAMPLE:
-- 
--   declare
--       l_xml   xmltype := xmltype('<root><tag>Test</tag></root>');
--       l_value clob;
--   begin
--       l_value := apex_web_service.parse_xml_clob(
--           p_xml    => l_xml,
--           p_xpath  => '/root/tag/text()' );
--   end; 
-- 
--======================================================================================================================
function parse_xml_clob (
    p_xml               in sys.xmltype,
    p_xpath             in varchar2,
    p_ns                in varchar2 default null ) return clob;

--======================================================================================================================
-- This function converts the clob001 column of passed collection to an sys.xmltype
-- and then returns a particular node of that document.
--
-- PARAMETERS:
-- * p_collection_name      The name of the collection that has the xml document
-- * p_xpath                The xPath to the desired node
-- * p_ns                   The namespace to the desired node
--
-- RETURNS:
--   the VARCHAR2 value of the XML node specified by the P_XPATH argument.
--
-- EXAMPLE:
-- 
--   declare
--       l_value clob;
--   begin
--       l_value := apex_web_service.parse_response(
--           p_collection_name => 'MY_RESPONSE_COLLECTION',
--           p_xpath           => '/root/tag/text()' );
--   end; 
-- 
--======================================================================================================================
function parse_response (
    p_collection_name   in varchar2,
    p_xpath             in varchar2,
    p_ns                in varchar2 default null ) return varchar2;

--======================================================================================================================
-- This function converts the clob001 column of passed collection to an sys.xmltype
-- and then returns a particular node of that document.
--
-- PARAMETERS:
-- * p_collection_name      The name of the collection that has the xml document
-- * p_xpath                The xPath to the desired node
-- * p_ns                   The namespace to the desired node
--
-- RETURNS:
--   the CLOB value of the XML node specified by the P_XPATH argument.
--
-- EXAMPLE:
-- 
--   declare
--       l_value clob;
--   begin
--       l_value := apex_web_service.parse_response_clob(
--           p_collection_name => 'MY_RESPONSE_COLLECTION',
--           p_xpath           => '/root/tag/text()' );
--   end; 
-- 
--======================================================================================================================
function parse_response_clob (
    p_collection_name   in varchar2,
    p_xpath             in varchar2,
    p_ns                in varchar2 default null ) return clob;

end wwv_flow_webservices_api;
/
show errors
