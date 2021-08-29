set define '^' verify off
prompt ...wwv_flow_theme_api
create or replace package wwv_flow_theme_api authid current_user as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2016. All Rights Reserved.
--
--    NAME
--      wwv_flow_theme_api.sql
--
--    DESCRIPTION
--      This package contains utility functions for working with themes and theme styles
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    06/07/2016 - Created
--    cczarski    07/07/2016 - Created set_default_style as copy of htmldb_util.set_current_theme_style
--    cczarski    07/07/2016 - Added set_dynamic_style procedures (feature #1992)
--    cczarski    07/08/2016 - API changes
--    cczarski    07/15/2016 - made package invokers' rights - improved the API
--    cczarski    07/18/2016 - added enable_user_style and disable_user_style API calls
--    cczarski    07/27/2016 - added clear_all_users_style to clear all theme style user preferences for an application
--
--------------------------------------------------------------------------------

--==============================================================================
-- set current theme style for the current application. This is a persistent
-- change. The "Modify this Application" setting has to be activated in
-- Shared Components, Security, Runtime API usage.
--
-- PARAMETERS
-- * p_theme_number     the theme number for which to set the default style
-- * p_style_id         the ID of the new default theme style
--
-- EXAMPLE
--    1. Get available theme styles from Application Express Dictionary View
--       for the DESKTOP user interface
--
--       select s.theme_style_id, t.theme_number
--         from apex_application_theme_styles s, apex_application_themes t
--        where s.application_id = t.application_id
--          and s.theme_number = t.theme_number
--          and s.application_id = :app_id
--          and t.ui_type_name = 'DESKTOP'
--          and s.is_current = 'Yes'
--
--    2. set the current theme style to one of values returned by the above query
--
--       apex_theme.set_current_style (
--            p_theme_number => {query.theme_number},
--            p_id => {query.theme_style_id}
--       );
--
--==============================================================================
procedure set_current_style (
    p_theme_number   in wwv_flow_themes.theme_id%type,
    p_id             in wwv_flow_theme_styles.name%type );

--==============================================================================
-- sets the theme style dynamically for the current session. This is typically
-- being called after successful authentication.
--
-- PARAMETERS
-- * p_theme_number       theme number to set the session style for, default is the
--                        current theme of the application
-- * p_name               name of the theme style to be used in the session
--
-- EXAMPLE
--    1. Get the current theme number from Application Express Dictionary Views
--       for the DESKTOP user interface
--
--       select t.theme_number
--         from apex_application_themes t
--        where t.application_id = :app_id
--          and t.ui_type_name = 'DESKTOP'
--
--    2. set the session theme style for the current theme to "Vita"
--
--       apex_theme.set_current_style (
--            p_theme_number => {query.theme_number},
--            p_name => 'Vita'
--       );
--==============================================================================
procedure set_session_style (
    p_theme_number   in wwv_flow_themes.theme_id%type   default wwv_flow.g_flow_theme_id,
    p_name           in wwv_flow_theme_styles.name%type );

--==============================================================================
-- sets the theme style dynamically for the current session. This is typically
-- being called after successful authentication.
--
-- PARAMETERS
-- * p_theme_number       theme number to set the session style for
-- * p_id                 ID of the theme style to be used in the session
--==============================================================================
procedure set_session_style (
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id,
    p_id             in wwv_flow_theme_styles.id%type );

--==============================================================================
-- sets the theme style CSS urls dynamically for the current session. Theme
-- style CSS URLs are being directly passed in; a persistent style definition is
-- not needed. This is typically being called after successful authentication.
--
-- PARAMETERS
-- * p_theme_number       theme number to set the session style for
-- * p_css_urls           URLs to CSS files with style directives
--
-- EXAMPLE
--   same as SET_CURRENT_STYLE

--==============================================================================
procedure set_session_style_css (
    p_theme_number   in wwv_flow_themes.theme_id%type            default wwv_flow.g_flow_theme_id,
    p_css_file_urls  in wwv_flow_theme_styles.css_file_urls%type );

--==============================================================================
-- sets a theme style user preference for the current user and application.
-- Theme Style User Preferences are automatically picked up and precede any
-- style set with SET_SESSION_STYLE.
--
-- PARAMETERS
-- * p_application_id     application to set the user style preference for
-- * p_user               user name to the user style preference for
-- * p_theme_number       theme number to set the user style preference for
-- * p_id                 ID of the theme style to set as a user preference
--
-- EXAMPLE
--    1. Get available theme styles from Application Express Dictionary View
--       for the DESKTOP user interface
--
--       select s.theme_style_id, t.theme_number
--         from apex_application_theme_styles s, apex_application_themes t
--        where s.application_id = t.application_id
--          and s.theme_number = t.theme_number
--          and s.application_id = :app_id
--          and t.ui_type_name = 'DESKTOP'
--          and s.is_current = 'Yes'
--
--    2. set one of the theme style id's as user preference for "ADMIN" in
--       application ID "100".
--       apex_theme.set_user_style(
--           p_application_id => 100,
--           p_user           => 'ADMIN',
--           p_theme_number   => {query.theme_number},
--           p_id             => {query.theme_style_id}
--       );
--
--==============================================================================
procedure set_user_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_user           in wwv_flow.g_user%type          default wwv_flow.g_user,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id,
    p_id             in wwv_flow_theme_styles.id%type );

--==============================================================================
-- returns the theme style user preference for the user and application.
-- If no user preference is present, NULL is returned.
--
-- PARAMETERS
-- * p_application_id     application to set the user style preference for
-- * p_user               user name to the user style preference for
-- * p_theme_number       theme number to set the session style for
--
-- RETURN
--   the theme style ID which is set as a user preference
--
-- EXAMPLE
--   the following query returns the theme style user preference for
--   the "ADMIN" user in application "100" and theme "42"
--
--   select apex_theme.get_user_style( 100, 'ADMIN', 42 ) from dual;
--==============================================================================
function get_user_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_user           in wwv_flow.g_user%type          default wwv_flow.g_user,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id
) return number;

--==============================================================================
-- clears the theme style user preference for user and application.
--
-- PARAMETERS
-- * p_application_id     application to set the user style preference for
-- * p_user               user name to the user style preference for
-- * p_theme_number       theme number to clear the theme style user preference
--
-- EXAMPLE
--   clear the theme style user preference for the "ADMIN" user
--   in application "100" and theme "42"
--
--   apex_theme.clear_user_style(
--       p_application_id => 100,
--       p_user           => 'ADMIN',
--       p_theme_number   => 42
--   );
--==============================================================================
procedure clear_user_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_user           in wwv_flow.g_user%type          default wwv_flow.g_user,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id );

--==============================================================================
-- clears all theme style user preferences for an application and theme.
--
-- PARAMETERS
-- * p_application_id     application to clear all user theme style preferences for
-- * p_theme_number       theme number to clear all theme style user preferences for
--
-- EXAMPLE
--   clear the all theme style user preferences for theme "42" in application "100"
--
--   apex_theme.clear_all_users_style(
--       p_application_id => 100,
--       p_theme_number   => 42
--   );
--==============================================================================
procedure clear_all_users_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id );

--==============================================================================
-- enables theme style selection by end users. When enabled and there is at least
-- one theme style marked as "Public", end users will see a Customize link which
-- allows to choose the theme style. End user theme style selection is enabled or
-- disabled at the User Interface level.
-- When providing a theme number, the theme must be the "Current Theme" for a
-- User Interface.
--
-- Note that this only affects the "Customization" link for end users. APEX_THEME
-- API calls are independent.
--
-- PARAMETERS
-- * p_application_id     Application ID
-- * p_theme_number       number of User Interface's "Current Theme"
--
-- EXAMPLE
--   enable end user theme style selection for the "Desktop" user interface of
--   application "100".
--
--   declare
--     l_theme_id apex_themes.theme_number%type;
--   begin
--     select theme_number into l_theme_id
--       from apex_appl_user_interfaces
--      where application_id = 100
--        and display_name   = 'Desktop';
--
--     apex_theme.enable_user_style(
--       p_application_id => 100,
--       p_theme_number   => l_theme_id
--     );
--   end;
--==============================================================================
procedure enable_user_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id );

--==============================================================================
-- disables theme style selection by end users. End users will not be able
-- to customize the theme style on their own.
--
-- Note that this only affects the "Customization" link for end users. APEX_THEME
-- API calls are independent.
--
-- PARAMETERS
-- * p_application_id     Application ID
-- * p_theme_number       number of User Interface's "Current Theme"
--
-- EXAMPLE
--   enable end user theme style selection for the "Desktop" user interface of
--   application "100".
--
--   declare
--     l_theme_id apex_themes.theme_number%type;
--   begin
--     select theme_number into l_theme_id
--       from apex_appl_user_interfaces
--      where application_id = 100
--        and display_name   = 'Desktop';
--
--     apex_theme.disable_user_style(
--       p_application_id => 100,
--       p_theme_number   => l_theme_id
--     );
--   end;
--==============================================================================
procedure disable_user_style (
    p_application_id in wwv_flow.g_flow_id%type       default wwv_flow.g_flow_id,
    p_theme_number   in wwv_flow_themes.theme_id%type default wwv_flow.g_flow_theme_id );

end wwv_flow_theme_api;
/
show errors
