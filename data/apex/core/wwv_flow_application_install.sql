set define '^' verify off
prompt ...wwv_flow_application_install
create or replace package wwv_flow_application_install as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2010 - 2016. All Rights Reserved.
--
--    NAME
--      wwv_flow_application_install.sql
--
--    DESCRIPTION
--      Methods used to control APEX application installation behavior.  If not set,
--      then an APEX application will install normally.  However, if these global are set,
--      then these will take precedence over those specified in the application export file
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--      jkallman  01/28/2010 - Created
--      jkallman  08/16/2012 - Added publish_application
--      jkallman  08/19/2012 - Added p_new_translated_app_id to publish_application
--      cbcho     07/11/2014 - Added set_auto_install_sup_obj, get_auto_install_sup_obj (feature #1344)
--      pawolf    02/23/2015 - Added set_static_(app/theme/plugin)_file_prefix, get_static_(app/theme/plugin)_file_prefix (feature #1165)
--      cneumuel  01/26/2016 - Added set_workspace (feature #1756)
--      cneumuel  10/03/2016 - Added set_keep_sessions (feature #2067)
--      cneumuel  11/08/2016 - In get_keep_sessions, default to KEEP_SESSIONS_ON_UPGRADE (feature #2067)
--      cczarski  11/28/2017 - Added no_proxy_domains attribute (feature #2249)
--      cczarski  11/29/2017 - Added set|get_remote_server to change remote server base URLs during install (feature #2092, #2109)
--      cczarski  12/01/2017 - added ords_timezone to set|get_remote_server
--
--------------------------------------------------------------------------------

--==============================================================================
-- Use this function to set the workspace ID for the application to be imported.
--
-- ARGUMENTS
-- * p_workspace_id: The workspace ID
--
-- EXAMPLE
--   Set workspace ID for workspace FRED_PROD.
--
--   declare
--       l_workspace_id number;
--   begin
--       select workspace_id into l_workspace_id
--         from apex_workspaces
--        where workspace = 'FRED_PROD';
--
--       apex_application_install.set_workspace_id (
--           p_workspace_id => l_workspace_id );
--   end;
--
-- SEE ALSO
--   set_workspace, get_workspace_id
--==============================================================================
procedure set_workspace_id(
    p_workspace_id in number );

--==============================================================================
-- Use this function to set the workspace ID for the application to be imported.
--
-- ARGUMENTS
-- * p_workspace: The workspace name
--
-- EXAMPLE
--   Set workspace ID for workspace FRED_PROD.
--
--   apex_application_install.set_workspace (
--       p_workspace => 'FRED_PROD' );
--
-- SEE ALSO
--   set_workspace, get_workspace_id
--==============================================================================
procedure set_workspace (
    p_workspace in varchar2 );

--==============================================================================
-- Use this function to get the workspace ID for the application to be imported.
--
-- ARGUMENTS
--
-- EXAMPLE
--   The following example returns the value of the workspace ID value in the APEX_APPLICATION_INSTALL package.
--
--   declare
--       l_workspace_id number;
--   begin
--       l_workspace_id := apex_application_install.get_workspace_id;
--   end;
--
-- SEE ALSO
--   set_workspace_id, set_workspace
--==============================================================================
function get_workspace_id
    return number;

--==============================================================================
-- Application ID
--==============================================================================
procedure set_application_id(
    p_application_id in number );

function get_application_id
    return number;

procedure generate_application_id;


--==============================================================================
-- Offset
--==============================================================================
procedure set_offset(
    p_offset in number );

procedure generate_offset;

function get_offset
    return number;


--==============================================================================
-- Schema
--==============================================================================
procedure set_schema(
    p_schema in varchar2 );

function get_schema
    return varchar2;


--==============================================================================
-- Name
--==============================================================================
procedure set_application_name(
    p_application_name in varchar2 );

function get_application_name
    return varchar2;


--==============================================================================
-- Alias
--==============================================================================
procedure set_application_alias(
    p_application_alias in varchar2 );

function get_application_alias
    return varchar2;


--==============================================================================
-- Image Prefix
--==============================================================================
procedure set_image_prefix(
    p_image_prefix in varchar2 );

function get_image_prefix
    return varchar2;


--==============================================================================
-- Proxy
--==============================================================================
procedure set_proxy(
    p_proxy            in varchar2,
    p_no_proxy_domains in varchar2 default null );

function get_proxy
    return varchar2;

function get_no_proxy_domains
    return varchar2;

--==============================================================================
-- Remote Servers
--==============================================================================
procedure set_remote_server(
    p_static_id        in varchar2,
    p_base_url         in varchar2,
    p_https_host       in varchar2 default null,
    p_ords_timezone    in varchar2 default null );

function get_remote_server_base_url(
    p_static_id        in varchar2 ) 
    return varchar2;

function get_remote_server_https_host(
    p_static_id        in varchar2 ) 
    return varchar2;

function get_remote_server_ords_tz(
    p_static_id        in varchar2 ) 
    return varchar2;

--==============================================================================
-- Auto Install of Supporting Objects
--==============================================================================
procedure set_auto_install_sup_obj(
    p_auto_install_sup_obj in boolean );

function get_auto_install_sup_obj
    return boolean;

--==============================================================================
-- Static Application File Prefix
--==============================================================================
procedure set_static_app_file_prefix(
    p_file_prefix in varchar2 );

function get_static_app_file_prefix
    return varchar2;

--==============================================================================
-- Static Theme File Prefix
--==============================================================================
procedure set_static_theme_file_prefix(
    p_theme_number in number,
    p_file_prefix  in varchar2 );

function get_static_theme_file_prefix(
    p_theme_number in number )
    return varchar2;

--==============================================================================
-- Static Plugin File Prefix
--==============================================================================
procedure set_static_plugin_file_prefix(
    p_plugin_type in varchar2,
    p_plugin_name in varchar2,
    p_file_prefix in varchar2 );

function get_static_plugin_file_prefix(
    p_plugin_type in varchar2,
    p_plugin_name in varchar2 )
    return varchar2;

--==============================================================================
-- Use this function to preserve sessions associated with the application on upgrades.
--
-- ARGUMENTS
-- * p_keep_sessions: TRUE if sessions should be preserved, FALSE if they should be deleted. The instance parameter
--                    KEEP_SESSIONS_ON_UPGRADE controls the default behavior. If it is N (the default), sessions will be
--                    deleted.
--
-- EXAMPLE
--   Install application 100 in workspace FRED_PROD and keep session state.
--
--     SQL> exec apex_application_install.set_workspace(p_workspace => 'FRED_PROD');
--     SQL> exec apex_application_install.set_keep_sessions(p_keep_sessions => true);
--     SQL> @f100.sql
--
-- SEE ALSO
--   get_keep_sessions, apex_instance_admin
--==============================================================================
procedure set_keep_sessions (
    p_keep_sessions in boolean );

--==============================================================================
-- Use this function to find out if sessions and session state will be preserved or deleted on upgrades.
--
-- EXAMPLE
--   Print whether sessions will be kept or deleted.
--
--     dbms_output.put_line (
--         case when apex_application_install.get_keep_sessions then 'sessions will be kept'
--         else 'sessions will be deleted'
--         end );
--
-- SEE ALSO
--   set_keep_sessions
--==============================================================================
function get_keep_sessions
    return boolean;

--==============================================================================
-- Publish Application
--==============================================================================
procedure publish_application(
    p_application_id in number,
    p_language_code  in varchar2,
    p_new_translated_app_id in number default null );

--==============================================================================
-- Clear
--==============================================================================
procedure clear_all;

end wwv_flow_application_install;
/
