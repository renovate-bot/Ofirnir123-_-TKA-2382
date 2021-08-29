set define off verify off
prompt ...wwv_flow_credential_api.sql
create or replace package wwv_flow_credential_api authid current_user 
------------------------------------------------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_credential_api.sql
--
--    DESCRIPTION
--      Public API for Secure Credentials
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    03/29/2017 - Created
--    cczarski    04/06/2017 - Added string constants for authentication types
--    cczarski    12/01/2017 - Changed set_workspace_* to set_persistent_*
--
------------------------------------------------------------------------------------------------------------------------
is

subtype t_token_type is pls_integer range 1..3;

c_token_access  constant t_token_type := 1;
c_token_refresh constant t_token_type := 2;
c_token_id      constant t_token_type := 3;

subtype t_credential_type is varchar2(25);

c_type_basic             constant t_credential_type := 'BASIC';
c_type_oauth_client_cred constant t_credential_type := 'OAUTH2_CLIENT_CREDENTIALS';
c_type_jwt               constant t_credential_type := 'JWT';

type t_credential is record (
    auth_type                      wwv_credentials.authentication_type%type,                 
    client_id                      wwv_credentials.client_id%type,
    client_secret                  wwv_credentials.client_secret%type );

type t_token is record (
    value_type                     wwv_credential_instances.value_type%type,
    value                          wwv_credential_instances.value%type,
    expiry_date                    date );

type t_tokens is table of t_token index by binary_integer;

--======================================================================================================================
-- Set username and password for a given credential for the current session. Typically used for
-- BASIC authentication when the credentials to be used are to be provided by the end user.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID.
-- * p_username:             Credential Username 
-- * p_password:             Credential Password
--
-- EXAMPLE
--   Set credential "Login"
--
--   begin
--       apex_credential.set_session_credentials (
--           p_credential_static_id => 'Login',
--           p_username             => 'scott',
--           p_password             => 'tiger );
--   end;
--======================================================================================================================
procedure set_session_credentials(
    p_credential_static_id  in varchar2,
    p_username              in varchar2,
    p_password              in varchar2 );

--======================================================================================================================
-- Set Client ID and Client Secret for a given credential for the current session. Typically used for
-- the OAuth2 "Client Credentials" flow.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID
-- * p_client_id:            OAuth2 Client ID
-- * p_client_secret:        OAuth2 Client Secret
--
-- EXAMPLE
--   Set credential "OAuth Login" 
--
--   begin
--       apex_credential.set_session_credentials (
--           p_credential_static_id => 'OAuth Login',
--           p_client_id            => 'dnkjq237o8832ndj98098-..',
--           p_client_secret        => '1278672tjksaGSDA789312..' );
--   end;
--======================================================================================================================
procedure set_session_credentials(
    p_credential_static_id  in varchar2,
    p_client_id             in varchar2,
    p_client_secret         in varchar2 );

--======================================================================================================================
-- Clears all aquired tokens for a given credential. Applies only to OAuth2 based flows, where the Client ID and
-- Client Secret are used to obtain an "Access Token" with a certain expiry time. This call clears the obtained tokens.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID.
--
-- EXAMPLE
--   Clear all obtained tokens for the credential "OAuth Login"
--
--   begin
--       apex_credential.clear_tokens(
--           p_credential_static_id => 'OAuth Login' );
--   end;
--======================================================================================================================
procedure clear_tokens( p_credential_static_id in varchar2);

--======================================================================================================================
-- stores a token into a credential store which has been obtained with manual or custom PL/SQL code. The credential
-- store saves this token in encrypted form for subsequent use by APEX components. The token will only be stored
-- for the lifetime of the APEX session. Other sessions cannot use that token.
-- When tokens are obtained with custom PL/SQL code, Client ID and Client Secret are typically not being stored
-- in that credential store - it contains the tokens set by this procedure only.
-- 
-- This procedure uses an autonomous transaction in order to store the token in the database table.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID.
-- * p_token_type:           The token type: APEX_CREDENTIAL.C_TOKEN_ACCESS, APEX_CREDENTIAL.C_TOKEN_REFRESH or APEX_CREDENTIAL.C_TOKEN_ID
-- * p_token_value:          The value of the token
-- * p_token_expiry:         Expiry date of the token
--
-- EXAMPLE
--   Store OAuth2 access token with value "sdakjjkhw7632178jh12hs876e38.." and expiry date of 2017-10-31 into
--   credential "OAuth Login'.
--
--   begin
--       apex_credential.set_session_token (
--           p_credential_static_id => 'OAuth Login',
--           p_token_type           => apex_credential.C_TOKEN_ACCESS,
--           p_token_value          => 'sdakjjkhw7632178jh12hs876e38..',
--           p_token_expiry         => to_date('2017-10-31', 'YYYY-MM-DD') );
--   end;
--======================================================================================================================
procedure set_session_token(
    p_credential_static_id  in varchar2,
    p_token_type            in t_token_type,
    p_token_value           in varchar2,
    p_token_expires         in date );

--======================================================================================================================
-- stores a token which has been obtained with manual or custom PL/SQL code. The token is stored
-- in encrypted form for subsequent use by APEX components. The token will be valid for all APEX sessions.
-- When tokens are obtained with custom PL/SQL code, Client ID and Client Secret are typically not being stored
-- in that credential store - it contains the tokens set by this procedure only.
-- 
-- This procedure uses an autonomous transaction in order to store the token in the database table.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID.
-- * p_token_type:           The token type: APEX_CREDENTIAL.C_TOKEN_ACCESS, APEX_CREDENTIAL.C_TOKEN_REFRESH or APEX_CREDENTIAL.C_TOKEN_ID
-- * p_token_value:          The value of the token
-- * p_token_expiry:         Expiry date of the token
--
-- EXAMPLE
--   Store OAuth2 access token with value "sdakjjkhw7632178jh12hs876e38.." and expiry date of 2017-10-31 into
--   credential "OAuth Login'.
--
--   begin
--       apex_credential.set_persistent_token (
--           p_credential_static_id => 'OAuth Login',
--           p_token_type           => apex_credential.c_token_access,
--           p_token_value          => 'sdakjjkhw7632178jh12hs876e38..',
--           p_token_expiry         => to_date('2017-10-31', 'YYYY-MM-DD') );
--   end;
--======================================================================================================================
procedure set_persistent_token(
    p_credential_static_id in varchar2,
    p_token_type           in t_token_type,
    p_token_value          in varchar2,
    p_token_expires        in date );

--======================================================================================================================
-- Set Client ID and Client Secret for a given credential. Typically used for the OAuth2 "Client Credentials" flow.
-- The new credentials are stored persistently and are valid for all current and future sessions.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID
-- * p_client_id:            OAuth2 Client ID
-- * p_client_secret:        OAuth2 Client Secret
--
-- EXAMPLE
--   Set credential "OAuth Login"
--
--   begin
--       apex_credential.set_persistent_credentials (
--           p_credential_static_id  => 'OAuth Login',
--           p_client_id             => 'dnkjq237o8832ndj98098-..',
--           p_client_secret         => '1278672tjksaGSDA789312..' );
--   end;
--======================================================================================================================
procedure set_persistent_credentials(
    p_credential_static_id  in varchar2,
    p_client_id             in varchar2,
    p_client_secret         in varchar2 );

--======================================================================================================================
-- Set username and password for a given credential. This is typically be used by a security person after 
-- application import, and allows to separate responsibilities between a person importing the application 
-- and another person storing the credentials.
--
-- PARAMETERS
-- * p_credential_static_id: The credential static ID.
-- * p_username:             Credential Username 
-- * p_password:             Credential Password
--
-- EXAMPLE
--   Set credential "Login" 
--
--   begin
--       apex_credential.set_persistent_credentials (
--           p_credential_static_id => 'Login',
--           p_username             => 'scott',
--           p_password             => 'tiger );
--   end;
--======================================================================================================================
procedure set_persistent_credentials(
    p_credential_static_id  in varchar2,
    p_username              in varchar2,
    p_password              in varchar2 );

end wwv_flow_credential_api;
/
sho err

set define '^' 
