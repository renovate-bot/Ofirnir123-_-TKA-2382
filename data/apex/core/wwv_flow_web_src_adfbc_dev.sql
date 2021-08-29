set define '^' verify off
prompt ...wwv_flow_web_src_adfbc_dev.sql
create or replace package wwv_flow_web_src_adfbc_dev authid current_user as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_web_src_adfbc.sql
--
--    DESCRIPTION
--      Web source implementation for ORDS REST Services (procedures for app builder)
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    01/09/2018 Created
--
--------------------------------------------------------------------------------

--==============================================================================
-- Discovers the data profile for the ADF BC service. 
--
-- PARAMETERS
--     p_url_endpoint      IN    URL endpoint of the ORDS service
--     p_auth_scheme       IN    Authentication schema: BASIC, OAUTH, none
--     p_oauth_token_url   IN    token URL to use for OAuth authentication
--     p_client_id         IN    OAuth Client ID or Basic Username
--     p_client_secret     IN    OAuth Client ID or Basic Password
--     p_https_host        IN    host name to use for SNI with HTTPS services (12.2 and higher)
--     p_status_code       OUT   HTTP status code to be returned
--     p_response          OUT   CLOB containing sample JSON data
--     p_data_profile      OUT   discovered data profile 
--==============================================================================
procedure discover_data_profile( 
    p_url_endpoint        in     varchar2,
    p_auth_scheme         in     varchar2 default null,
    p_oauth_token_url     in     varchar2 default null,
    p_client_id           in     varchar2 default null,
    p_client_secret       in     varchar2 default null,
    p_https_host          in     varchar2 default null,
    p_status_code         out    pls_integer,
    p_response            in out nocopy clob,
    p_data_profile        in out nocopy wwv_flow_data_profile.t_data_profile );

end wwv_flow_web_src_adfbc_dev;
/
show err

set define '^'
