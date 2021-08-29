set define off verify off
prompt ...wwv_flow_credential.sql
create or replace package wwv_flow_credential authid definer
------------------------------------------------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_credential.sql
--
--    DESCRIPTION
--      Secure Credential Store for Web Service Consumption, Remote SQL Data Access
--      and Social Login.
--      Runtime package - MUST NOT be publicly exposed. This is the only package which decrypts and returns stored 
--      credentials in clear text. This package is only supposed to be called by APEX components.
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    03/29/2017 - Created
--    cczarski    04/05/2017 - Rectify invalid space characters in comments which broke Hudson build
--    cczarski    04/06/2017 - Added get_token_type_string and set_token procedures needed for wwv_flow_web_services
--    cneumuel    07/27/2017 - Added re_encrypt to support copying secrets between apps
--    cczarski    12/14/2017 - In get_credential: added p_include_secret argument to enable to only retrieve the Client ID
--
------------------------------------------------------------------------------------------------------------------------

/*
$IF dbms_db_version.ver_le_11_2 $THEN
$ELSE
    accessible by ( trigger wwv_flow_credentials_dev_iot, 
                    package wwv_flow_web_services,
                    package wwv_flow_web_services_api,
                    package wwv_flow_credential_api )
$END
*/
is

--======================================================================================================================
-- checks whether the current database session is allows to make application-level changes to the applications' 
-- credential store.
--
-- EXAMPLE:
--   check whether changes to the credential store can be made.
-- 
-- begin
--     wwv_flow_credential.check_api_usage_allowed;
--     -- we can continue when the procedure returns without errors
-- exception
--     when others then
--         -- we are not allowed to make changes to the credential store
-- end;
--======================================================================================================================
procedure check_api_usage_allowed;

--======================================================================================================================
-- converts wwv_flow_credential_api.t_token_type values to VARCHAR2 values stored in the table.
--
-- PARAMETERS:
-- * p_token_type:  the numeric token type value of wwv_flow_credential_api.t_token_type
--
-- RETURNS
--   the string representation which is stored in the WWV_FLOW_CREDENTIAL_INSTANCES table
--
-- EXAMPLE
--   Look up the string representation for wwv_flow_credential_api.c_token_access;
--
--   declare
--       l_token_type_string varchar2(255);
--   begin
--       l_token_type := wwv_flow_credential.get_token_type_string(
--                           wwv_flow_credential_api.c_token_access );
--   end;
--======================================================================================================================
function get_token_type_string( 
    p_token_type in wwv_flow_credential_api.t_token_type 
) return varchar2;

--======================================================================================================================
-- Looks up the ID of the credential store by its name
--
-- PARAMETERS
-- * p_credential_name:      The credential name.
-- * p_credential_static_id: The credential static_id.
--
-- RETURNS
--   the internal ID (primary key) of the credential store
-- 
-- EXAMPLE
--   Look up ID of credential store "Login" in Application 100
--
--   declare
--      l_cred_store_id number;
---  begin
--      l_cred_store_id := wwv_flow_credential.get_credential_store_id (
--           p_credential_name => 'Login' );
--   end;
--======================================================================================================================
function get_credential_id(
    p_credential_name       in varchar2
) return number;

function get_credential_id(
    p_credential_static_id  in varchar2
) return number;

--======================================================================================================================
-- encrypts a value; is typically being called before storing the credentials into the WWV_FLOW_CREDENTIALS table.
-- Application-level credentials are encrypted with the instance key; salted with the application ID
-- Session-level credentials are encrypted with the session crypto salt to be as secure as possible.
--
-- PARAMETERS
-- * p_value:           Clear text value to be encrypted.
-- * p_session_id:      Session ID. When set then the value is encrypted with the session crypto salt, default is NULL.
--
-- RETURNS
--   the encrypted value
-- 
-- EXAMPLE
--   encrypt a value to only be encrypted within the same session
--
--   declare
--       l_encrypted varchar2(255);
---  begin
--       l_encrypted := wwv_flow_credential.encrypt_value (
--           p_value           => 'This is so secure!',
--           p_session_id      => wwv_flow_security.g_instance );
--   end;
--======================================================================================================================
function encrypt_value( 
    p_value           in varchar2,
    p_session_id      in number    default null
) return varchar2; 

--======================================================================================================================
-- returns credential information in clear text; only to be executed by the APEX engine in order to use 
-- the credentials for e.g. invoking a REST service.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
--
-- RETURNS
--   credential information (Client ID, Client Secret and Authentication Type) in clear text
-- 
-- EXAMPLE
--   retrieve Client ID and Client Secret for credential "Login" in Application 100 in clear text.
--
--   declare
--       l_credential wwv_flow_credential_api.t_credential;
--   begin
--       l_credential := wwv_flow_credential.get_credential (
--           p_credential_id   => wwv_flow_credential.get_credential_store_id( 'Login' ) );
--
--       dbms_output.put_line( 'Client ID:     ' || l_credential.client_id );
--       dbms_output.put_line( 'Client Secret: ' || l_credential.client_secret );
--   end;
--======================================================================================================================
function get_credential(
    p_credential_id   in number,
    p_include_secret  in boolean default true
) return wwv_flow_credential_api.t_credential;

--======================================================================================================================
-- returns OAuth2 tokens stored in a credential store in clear text; only to be executed by the APEX engine 
-- in order to use for e.g. invoking a REST service.
-- When Client ID and Client Secret have been set at session level using the WWV_FLOW_CREDENTIAL_API package, 
-- only session-level tokens are being returned. Application-level tokens are only returned when Client ID 
-- and Client Secret are *not* set at the session level.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
--
-- RETURNS
--   list of tokens (wwv_flow_credential_api.t_tokens type)
-- 
-- EXAMPLE
--   retrieve OAuth tokens for credential "Login" in Application 100 in clear text.
--
--   declare
--       l_tokens wwv_flow_credential_api.t_tokens;
--   begin
--       l_tokens := wwv_flow_credential.get_tokens (
--           p_credential_id   => get_credential_store_id( 'Login' ) );
--
--       for i in 1 .. l_tokens.count loop
--          dbms_output.put_line( 'Token Type:  ' || l_tokens( i ).value_type );
--          dbms_output.put_line( 'Token Value: ' || l_tokens( i ).value );
--          dbms_output.put_line( 'Expiry:      ' || l_tokens( i ).expiry_date );
--       end loop;
--   end;
--======================================================================================================================
function get_tokens(
    p_credential_id   in number
) return wwv_flow_credential_api.t_tokens;

--======================================================================================================================
-- Set Client ID and Client Secret for a given credential. 
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_client_id:       OAuth2 Client ID
-- * p_client_secret:   OAuth2 Client Secret
--
-- EXAMPLE
--   Set credential "OAuth Login" for application 100.
--
--   begin
--       wwv_flow_credential.set_application_credentials (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_client_id       => 'dnkjq237o8832ndj98098-..',
--           p_client_secret   => '1278672tjksaGSDA789312..' );
--   end;
--======================================================================================================================
procedure set_workspace_credentials(
    p_credential_id   in number,
    p_client_id       in varchar2,
    p_client_secret   in varchar2 );

--======================================================================================================================
-- Set Client ID and Client Secret for a given credential for the current session.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_client_id:       OAuth2 Client ID
-- * p_client_secret:   OAuth2 Client Secret
--
-- EXAMPLE
--   Set credential "OAuth Login" for application 100.
--
--   begin
--       wwv_flow_credential.set_session_credentials (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_client_id       => 'dnkjq237o8832ndj98098-..',
--           p_client_secret   => '1278672tjksaGSDA789312..' );
--   end;
--======================================================================================================================
procedure set_session_credentials(
    p_credential_id   in number,
    p_client_id       in varchar2,
    p_client_secret   in varchar2 );

--======================================================================================================================
-- stores a token into a credential store at session level. The token will only be usable in the current APEX session,
-- regardless of its expiration date.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_token_type:      The token type: wwv_flow_credential_api.C_TOKEN_ACCESS, 
--                                      wwv_flow_credential_api.C_TOKEN_REFRESH 
--                                      wwv_flow_credential_api.C_TOKEN_ID
-- * p_token_value:     The value of the token
-- * p_token_expiry:    Expiry date of the token
--
-- EXAMPLE
--   Store OAuth2 access token with value "sdakjjkhw7632178jh12hs876e38.." and expiry date of 2017-10-31 into
--   credential "OAuth Login'.
--
--   begin
--       wwv_flow_credential.set_session_token (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_token_type      => apex_credential.C_TOKEN_ACCESS,
--           p_token_value     => 'sdakjjkhw7632178jh12hs876e38..',
--           p_token_expiry    => to_date('2017-10-31', 'YYYY-MM-DD') );
--   end;
--======================================================================================================================
procedure set_session_token(
    p_credential_id   in number,
    p_token_type      in wwv_flow_credential_api.t_token_type,
    p_token_value     in varchar2,
    p_token_expires   in date );

--======================================================================================================================
-- stores a token into a credential store at application level. The token will be usable until its expiration date
-- has been reached, for all sessions and users of the application.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_token_type:      The token type: wwv_flow_credential_api.C_TOKEN_ACCESS, 
--                                      wwv_flow_credential_api.C_TOKEN_REFRESH 
--                                      wwv_flow_credential_api.C_TOKEN_ID
-- * p_token_value:     The value of the token
-- * p_token_expiry:    Expiry date of the token
--
-- EXAMPLE
--   Store OAuth2 access token with value "sdakjjkhw7632178jh12hs876e38.." and expiry date of 2017-10-31 into
--   credential "OAuth Login'.
--
--   begin
--       wwv_flow_credential.set_application_token (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_token_type      => apex_credential.C_TOKEN_ACCESS,
--           p_token_value     => 'sdakjjkhw7632178jh12hs876e38..',
--           p_token_expiry    => to_date('2017-10-31', 'YYYY-MM-DD') );
--   end;
--======================================================================================================================
procedure set_workspace_token(
    p_credential_id   in number,
    p_token_type      in wwv_flow_credential_api.t_token_type,
    p_token_value     in varchar2,
    p_token_expires   in date );


--======================================================================================================================
-- stores a token into a credential store. The token is stored at session level, when there is Client ID at session 
-- level and at application level, when there is not. The token will be usable until its expiration date
-- has been reached.
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_token_type:      The token type: wwv_flow_credential_api.C_TOKEN_ACCESS, 
--                                      wwv_flow_credential_api.C_TOKEN_REFRESH 
--                                      wwv_flow_credential_api.C_TOKEN_ID
-- * p_token_value:     The value of the token
-- * p_token_expiry:    Expiry date of the token
--
-- EXAMPLE
--   Store OAuth2 access token with value "sdakjjkhw7632178jh12hs876e38.." and expiry date of 2017-10-31 into
--   credential "OAuth Login'.
--
--   begin
--       wwv_flow_credential.set_token (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_token_type      => apex_credential.C_TOKEN_ACCESS,
--           p_token_value     => 'sdakjjkhw7632178jh12hs876e38..',
--           p_token_expiry    => to_date('2017-10-31', 'YYYY-MM-DD') );
--   end;
--======================================================================================================================
procedure set_token(
    p_credential_id      in number,
    p_token_type         in wwv_flow_credential_api.t_token_type,
    p_token_value        in varchar2,
    p_token_expires      in date );

--======================================================================================================================
-- Clears all set or aquired tokens for a given credential. 
--
-- PARAMETERS
-- * p_credential_id:   The credential ID.
-- * p_session_id:      If set, only session-level tokens will be deleted, defaults to null.
-- * p_token_type:      If set, only tokens of that type will be deleted, defautts to null.
--
-- EXAMPLE
--   Clear all tokens for the credential "Login"
--
--   begin
--       wwv_flow_credential.delete_tokens (
--           p_credential_id   => get_credential_store_id( 'OAuth Login' ),
--           p_token_type      => wwv_flow_credential_api.C_TOKEN_ACCESS );
--   end;
--======================================================================================================================
procedure delete_tokens(
    p_credential_id   in number,
    p_session_id      in number                               default null,
    p_token_type      in wwv_flow_credential_api.t_token_type default null ); 

end wwv_flow_credential;
/
sho err

set define '^'

