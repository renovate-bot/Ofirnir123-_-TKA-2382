set define '^' verify off
prompt ...wwv_flow_web_src_ords_dev.sql
create or replace package wwv_flow_web_src_ords_dev authid current_user as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_web_src_ords_dev.sql
--
--    DESCRIPTION
--      Web source implementation
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    05/30/2017 - Created
--    cczarski    09/13/2017 - added support for UTL_HTTP p_https_host argument (ignored pre-12.2)
--
--------------------------------------------------------------------------------


--==============================================================================
-- Global types 
--==============================================================================

--==============================================================================
-- contants
--==============================================================================

--==============================================================================
-- Discovers the data profile for the ORDS service. The procedure will try to
-- follow the "describedBy" link which is part of the REST service response and
-- when that is not sufficient, the web service response will be sampled.
--
-- PARAMETERS
--     p_ords_url_endpoint IN    URL endpoint of the ORDS service
--     p_auth_scheme       IN    Authentication schema: BASIC, OAUTH, none
--     p_client_id         IN    OAuth Client ID or Basic Username
--     p_client_secret     IN    OAuth Client ID or Basic Password
--     p_data_profile      OUT   discovered data profile 
--==============================================================================
procedure discover_data_profile( 
    p_ords_url_endpoint   in varchar2,
    p_auth_scheme         in varchar2 default null,
    p_oauth_token_url     in varchar2 default null,
    p_client_id           in varchar2 default null,
    p_client_secret       in varchar2 default null,
    p_https_host          in varchar2 default null,
    p_status_code         out pls_integer,
    p_response            in out nocopy clob,
    p_data_profile        in out nocopy wwv_flow_data_profile.t_data_profile );


--==============================================================================
-- Detects whether the JSON response is the "ORDS Legacy JSON syntax".
--
-- PARAMETERS
--     p_response          IN    JSON response to parse
--     p_is_legacy         IN    true, if the JSON is ORDS Legacy
--     p_page_size         IN    the page size, if we were able to detect
--==============================================================================
procedure detect_legacy_ords(
    p_response            in out nocopy clob,
    p_page_size           out           number,
    p_is_legacy           out           boolean );

--==============================================================================
-- Performs the OPTIONS request in order to fetch the allowed methods on a REST
-- service.
--
-- PARAMETERS
--     p_ords_url_endpoint IN    URL endpoint of the ORDS instance, end typically with "/ords"
--     p_auth_scheme       IN    Authentication schema: BASIC, OAUTH, none
--     p_client_id         IN    OAuth Client ID or Basic Username
--     p_client_secret     IN    OAuth Client ID or Basic Password
--     p_collection_name   IN    name of the collection to populate
--
-- RETURNS
--     true if a metadata catalog exists, false otherwise
--==============================================================================
procedure fetch_available_methods(
    p_ords_url_endpoint   in varchar2,
    p_auth_scheme         in varchar2 default null,
    p_oauth_token_url     in varchar2 default null,
    p_https_host          in varchar2 default null,
    p_client_id           in varchar2 default null,
    p_client_secret       in varchar2 default null,
    p_collection_name     in varchar2 ); 


end wwv_flow_web_src_ords_dev;
/
show err

set define '^'

