set define '^' verify off
prompt ...wwv_flow_app_shared_comp_v3
create or replace package wwv_flow_app_shared_comp_v3 as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_app_shared_comp_v3.sql
--
--    DESCRIPTION
--      Manage application shared components defined from create app extension wizard
--
--    MODIFIED (MM/DD/YYYY)
--    cbcho     02/14/2017 - Created
--    mhichwa   02/20/2017 - Added create_app_items
--    cbcho     02/21/2017 - Added create_authorization_schemes, create_app_computations
--    cbcho     02/22/2017 - Added create_app_process
--    cbcho     02/23/2017 - Added create_shortcut
--    cbcho     03/13/2017 - Added create_page_group
--    cbcho     03/16/2017 - Added create_medialist_rpt_template
--    cbcho     04/05/2017 - Renamed to v3
--    xhu       04/21/2017 - added create_app_js
--    xhu       12/07/2017 - removed create_app_js
--    cbcho     01/10/2018 - Removed create_app_items, create_app_computations
--                         - Added create_app_settings
--    cbcho     01/26/2018 - Added template procedures
--    cbcho     01/30/2018 - In get_template_id: removed theme_id
--    sbkenned  01/31/2018 - added c_bo_email_monitor and c_bo_job_monitor
--    cbcho     02/06/2018 - Added get_admin_list, create_list
--    cbcho     02/07/2018 - Added create_acl_roles, create_app_roles, create_auth_scheme
--    cbcho     02/09/2018 - Exposed get_auth_scheme_id
--    cbcho     02/09/2018 - In create_list: added p_build_option_id
--    cbcho     02/12/2018 - Removed procedures to create system message and supporting object
--    cbcho     02/15/2018 - Removed create_app_process
--    cbcho     02/21/2018 - In get_admin_list: added p_app_id
--    cbcho     02/26/2018 - Replaced t_page with feature package t_feature_page
--    cbcho     02/27/2018 - Removed procedure to create medialist report template as it longer needs
--    cbcho     03/15/2018 - Added replace_admin_auth_scheme (bug #27657571)
--    cbcho     07/05/2018 - In create_admin_list: added p_theme_style_list_id (bug #28209395)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------
subtype t_bo_feature_identifier is varchar2(50);

type t_list_items  is table of wwv_flow_list_items%rowtype index by binary_integer;

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------

-- build option identifier
c_bo_app_configuration         constant t_bo_feature_identifier := 'APPLICATION_CONFIGURATION';
c_bo_app_acl                   constant t_bo_feature_identifier := 'APPLICATION_ACCESS_CONTROL';
c_bo_app_activity_report       constant t_bo_feature_identifier := 'APPLICATION_ACTIVITY_REPORTING';
c_bo_app_feedback              constant t_bo_feature_identifier := 'APPLICATION_FEEDBACK';
c_bo_app_about_page            constant t_bo_feature_identifier := 'APPLICATION_ABOUT_PAGE';
c_bo_app_themes_style          constant t_bo_feature_identifier := 'APPLICATION_THEME_STYLE_SELECTION';
c_bo_email_monitor             constant t_bo_feature_identifier := 'APPLICATION_EMAIL_REPORTING';
c_bo_job_monitor               constant t_bo_feature_identifier := 'APPLICATION_JOB_REPORTING';

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--
--
--

procedure create_app_icon(
    p_icon_class in varchar2,
    p_color_hex  in varchar2 );

procedure create_shortcut;

procedure create_page_group(
    p_admin_pg_group_id out number );

function get_template_id(
    p_app_id   in number default wwv_flow_create_app_v3.g_app_id,
    p_type     in varchar2,
    p_name     in varchar2  ) return number;

procedure update_template_options(
    p_id               in number,
    p_app_id           in number default wwv_flow_create_app_v3.g_app_id,
    p_page_id          in number,
    p_component        in varchar2,
    p_template_options in varchar2 );

function get_build_option_id(
    p_app_id             in number default wwv_flow_create_app_v3.g_app_id,
    p_feature_identifier in t_bo_feature_identifier ) return number;

procedure create_build_option(
    p_id                    in number,
    p_app_id                in number default wwv_flow_create_app_v3.g_app_id,
    p_feature_identifier    in t_bo_feature_identifier );

procedure create_build_options(
    p_bo_access_control            out number,
    p_bo_activity_reporting        out number,
    p_bo_application_feedback      out number,
    p_bo_application_settings      out number,
    p_bo_application_configuration out number,
    p_bo_email_framework           out number,
    p_bo_global_search             out number,
    p_bo_help_functionality        out number,
    p_bo_theme_selector            out number,
    p_bo_user_time_zone_support    out number,
    p_bo_user_profiles             out number );

procedure create_acl_roles(
    p_app_id    in number default wwv_flow_create_app_v3.g_app_id );

procedure create_app_roles;

function get_auth_scheme_id(
    p_app_id      in number default wwv_flow_create_app_v3.g_app_id,
    p_static_name in varchar2 ) return number;

procedure replace_admin_auth_scheme(
    p_app_id         in number,
    p_auth_scheme_id in number );

procedure create_auth_scheme(
    p_id                 in number default null,
    p_app_id             in number default wwv_flow_create_app_v3.g_app_id,
    p_static_name        in varchar2,
    p_role_based_admin   in boolean default false );

procedure create_authorization_schemes(
    p_as_admin_id        out number,
    p_as_app_sentry_id   out number,
    p_as_contribution_id out number );

function get_admin_list(
    p_app_id          in number default wwv_flow_create_app_v3.g_app_id,
    p_feature_names   in wwv_flow_t_varchar2,
    p_pages           in wwv_flow_app_feature_v3.t_feature_pages default wwv_flow_app_feature_v3.g_feature_pages ) return t_list_items;

procedure create_list(
    p_app_id          in number default wwv_flow_create_app_v3.g_app_id,
    p_list_id         in number,
    p_list_name       in varchar2,
    p_list_items      in t_list_items,
    p_build_option_id in number default null );

procedure create_admin_list(
    p_configure_list_id    out number,
    p_theme_style_list_id  out number,
    p_activity_rpt_list_id out number,
    p_acl_list_id          out number,
    p_feedback_list_id     out number );

procedure create_navbar;

procedure create_feature_app_settings(
    p_app_id          in number,
    p_feature_name    in wwv_flow_app_feature_v3.t_feature_name,
    p_build_option_id in number );

procedure create_app_settings;

end wwv_flow_app_shared_comp_v3;
/
show errors
