set define '^' verify off
prompt ...wwv_flow_create_app_v3
create or replace package wwv_flow_create_app_v3 as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_create_app_v3.sql
--
--    DESCRIPTION
--      Extension to create application based on new UI introduced in APEX 5.1.1
--
--    MODIFIED (MM/DD/YYYY)
--    cbcho     01/18/2017 - Created
--    cbcho     03/03/2017 - In create_app: added p_translated_langs
--    cbcho     03/08/2017 - Added c_pg_global
--    cbcho     03/09/2017 - Exposed get_pk_column
--    cbcho     03/13/2017 - Added g_pg_group_id_admin
--    cbcho     03/13/2017 - In create_app: added additional parameters
--    cbcho     03/14/2017 - Added g_short_description, g_long_description
--    cbcho     03/16/2017 - Exposed g_theme_id
--    cbcho     03/16/2017 - Added additional parameters in create_region_plugin, create_page_item
--    cbcho     03/20/2017 - Added c_empty_t_lov_list, c_empty_t_ir_col_list, c_empty_t_button_list
--    cbcho     03/21/2017 - Added c_pg_add_multiple_users%
--    cbcho     03/22/2017 - Exposed get_fk_column, enquote_name, update_region
--    cbcho     03/22/2017 - Added create_ir_default_report
--    cbcho     04/05/2017 - Renamed to v3
--    cbcho     04/06/2017 - Added c_pg_email_send
--    cbcho     04/07/2017 - In create_page_item: added p_lov_display_null and p_lov_null_text
--    cbcho     04/17/2017 - Added c_pg_email_view
--    xhu       04/20/2017 - added p_protection_level to create_ir_modal_page
--    cbcho     04/21/2017 - Added c_pg_metric_dashboard
--    cbcho     04/21/2017 - Extended t_lov to indclude display condition
--    cbcho     04/27/2017 - In create_app: added p_base_table_prefix
--    cbcho     05/02/2017 - Exposed create_shared_lov
--    cbcho     05/02/2017 - Changed c_pg_login_page to be 9999
--    xhu       05/03/2017 - added p_protection_level to create_page_item
--    cbcho     05/10/2017 - In create_app: added p_learn_app_def
--    cbcho     06/23/2017 - In create_app: added p_learn_existing_apps, p_seed_from_app_id
--    cbcho     06/26/2017 - Added create_feedback_button
--    cbcho     07/05/2017 - Added c_pg_feedback_success
--    cbcho     09/13/2017 - Extended t_ir_col to include LOV attributes
--    cbcho     10/26/2017 - Exposed overloaded get_fk_column accepting p_parent_table_name
--    cbcho     01/02/2018 - Removed rejoin sessions
--    cbcho     01/26/2018 - Moved template procedures to shared comp pkg
--    cbcho     01/30/2018 - Added p_app_id if procedures are shared from create features page
--    sbkenned  01/31/2018 - added c_pg_email_monitor, c_pg_job_monitor, c_pg_job_monitor_detail, g_bo_email_monitor_id, g_bo_job_monitor_id
--    cbcho     02/02/2018 - added t_theme, In create_app: added p_theme to take in custom theme
--    cbcho     02/06/2018 - Removed email page constants
--    cbcho     02/08/2018 - Removed table prefix
--    cbcho     02/14/2018 - In create_ir_modal_page: added p_user_interface_id, p_group_id
--    cbcho     02/22/2018 - Changed c_pg_home to 1
--    cbcho     02/23/2018 - Changed feature page IDs gap 10s between features, increment by 1 within a feature (# EA1-31)
--    cbcho     02/26/2018 - Removed feature page constants
--    cbcho     03/02/2018 - In create_page_item: added read only attributes
--    cbcho     07/18/2018 - In create_app: added p_built_with_love (feature #2359)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------
type t_theme is record(
    theme_type       varchar2(255),
    id               number,       -- PK of wwv_flow_themes
    theme_style      varchar2(255) -- IMPORTANT: need to keep it as varchar2 as UT passes theme style name and custom theme passes style ID
    );

type t_feature is record(
    access_control         boolean,
    activity_report        boolean,
    notification           boolean,
    feedback               boolean,
    application_setting    boolean,
    configuration_setting  boolean,
    email                  boolean,
    global_search          boolean,
    help                   boolean,
    theme_selector         boolean,
    timezone               boolean,
    user_profile           boolean );

type t_lov is record(
    display_value    varchar2(4000),
    return_value     varchar2(4000),
    template         varchar2(4000),
    disp_cond_type   varchar2(255),
    disp_cond        varchar2(4000),
    disp_cond2       varchar2(4000) );

type t_lov_list is table of t_lov index by binary_integer;

type t_ir_col is record(
    db_column_name       varchar2(255),
    display_order        number,
    column_type          varchar2(4000),
    column_label         varchar2(4000),
    column_link          varchar2(4000),
    column_linktext      varchar2(4000),
    format_mask          varchar2(255),
    column_alignment     varchar2(4000),
    display_text_as      varchar2(255),
    --
    lov_type             varchar2(255),
    lov_name             varchar2(255),
    lov_query            varchar2(4000),
    lov_static_list      t_lov_list,
    --
    help_text            varchar2(4000),
    -- default report settings
    is_visible           boolean,
    sort_order           number,
    sort_direction       varchar2(5),
    break_order          number );
type t_ir_col_list is table of t_ir_col index by binary_integer;

type t_button is record(
    name          varchar2(2000),
    image_alt     varchar2(2000),   
    is_hot        varchar2(1),
    redirect_url  varchar2(4000) );
type t_button_list is table of t_button index by binary_integer;

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_empty_t_lov_list             t_lov_list;
c_empty_t_ir_col_list          t_ir_col_list;
c_empty_t_button_list          t_button_list;

c_pg_home                      constant number := 1;
c_pg_home_alias                constant varchar2(10) := 'HOME';

c_page_global                  constant number := 0;
c_pg_login_page                constant number := 9999;
c_pg_administration            constant number := 10000;

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--
g_app_id                       number;
g_theme_id                     number;
g_schema                       varchar2(255);
g_user_interface_id            wwv_flow_user_interfaces.id%type;
g_feature                      t_feature;
g_prefix                       varchar2(10);
g_breadcrumb_id                number;
g_nav_bar_list_id              number;

-- advanced attribute
g_short_description            varchar2(4000);
g_long_description             varchar2(4000);

-- page group ID
g_pg_group_id_admin            number;

-- build option IDs
g_bo_acl_id                    number;
g_bo_activity_rpt_id           number;
g_bo_app_notifications_id      number;
g_bo_app_feedback_id           number;
g_bo_app_settings_id           number;
g_bo_app_configuration_id      number;
g_bo_email_framework_id        number;
g_bo_global_search_id          number;
g_bo_help_functionality_id     number;
g_bo_theme_selector_id         number;
g_bo_user_time_zone_support_id number;
g_bo_user_profiles_id          number;
g_bo_email_monitor_id          number;
g_bo_job_monitor_id            number;
--
-- authorization scheme IDs
g_as_admin_id                  number;
g_as_app_sentry_id             number;
g_as_contribution_id           number;

function enquote_name(
    p_name in varchar2 ) return varchar2;

function get_pk_column(
    p_table_owner in varchar2,
    p_table_name  in varchar2 ) return varchar2;

function get_fk_column(
    p_table_owner       in varchar2,
    p_table_name        in varchar2,
    p_parent_table_name in varchar2 ) return varchar2;

--
-- get colon delimited list of FK columns of the table
--
function get_fk_column(
    p_table_owner in varchar2,
    p_table_name  in varchar2 ) return varchar2;

procedure update_region(
    p_app_id                     in number   default g_app_id,
    p_page_id                    in number,
    p_region_id                  in number,
    p_region_name                in varchar2 default null,
    p_include_in_reg_disp_sel    in boolean  default null,
    p_region_css_classes         in varchar2 default null,
    p_region_sub_css_classes     in varchar2 default null,
    p_region_template_options    in varchar2 default null,
    p_component_template_options in varchar2 default null,
    p_region_attributes          in varchar2 default null,
    p_new_grid_row               in boolean  default null,
    p_translate_title            in boolean  default null,
    p_ajax_enabled               in boolean  default null,
    p_sort_null                  in varchar2 default null,
    p_plug_query_strip_html      in boolean  default null );

procedure create_region_plugin (
    p_id                          in number  default null,
    p_app_id                      in number  default g_app_id,
    p_page_id                     in number,
    p_title                       in varchar2,
    p_type                        in varchar2,
    p_region_name                 in varchar2 default null,
    p_source                      in varchar2 default null,
    p_parent_region_id            in number   default null,
    p_display_point               in varchar2 default 'BODY',
    p_display_sequence            in number   default 10,
    p_template_id                 in number   default null,
    p_region_css_classes          in varchar2 default null,
    p_icon_css_classes            in varchar2 default null,
    --
    p_escape_on_http_output       in varchar2 default 'Y',
    p_item_display_point          in varchar2 default 'ABOVE',
    p_include_in_reg_disp_sel_yn  in varchar2 default null,
    p_plug_new_grid               in boolean  default false,
    p_plug_new_grid_row           in boolean  default true,
    p_plug_new_grid_column        in boolean  default true,
    p_ajax_items_to_submit        in varchar2 default null,
    --
    p_list_id                     in number   default null,
    p_list_template_id            in number   default null,
    p_region_template_options     in varchar2 default null,
    p_component_template_options  in varchar2 default null,
    --
    p_query_row_template          in number   default null,
    p_query_headings_type         in varchar2 default null,
    p_query_num_rows_type         in varchar2 default null,
    p_query_options               in varchar2 default null,
    p_query_show_nulls_as         in varchar2 default null,
    p_pagination_display_position in varchar2 default null,
    p_query_num_rows              in number   default 15,
    --
    p_build_option_id             in number   default null,
    p_auth_scheme_id              in number   default null,
    --
    p_attribute_01                in varchar2 default null,
    p_attribute_02                in varchar2 default null,
    p_attribute_03                in varchar2 default null,
    p_attribute_04                in varchar2 default null,
    p_attribute_05                in varchar2 default null,
    p_attribute_06                in varchar2 default null,
    p_attribute_07                in varchar2 default null,
    p_attribute_08                in varchar2 default null,
    p_attribute_09                in varchar2 default null,
    p_attribute_10                in varchar2 default null,
    p_attribute_11                in varchar2 default null,
    p_attribute_12                in varchar2 default null,
    p_attribute_13                in varchar2 default null,
    p_attribute_14                in varchar2 default null,
    p_attribute_15                in varchar2 default null,
    p_attribute_16                in varchar2 default null,
    p_attribute_17                in varchar2 default null,
    p_attribute_18                in varchar2 default null,
    p_attribute_19                in varchar2 default null,
    p_attribute_20                in varchar2 default null,
    p_attribute_21                in varchar2 default null,
    p_attribute_22                in varchar2 default null,
    p_attribute_23                in varchar2 default null,
    p_attribute_24                in varchar2 default null,
    p_attribute_25                in varchar2 default null,
    p_condition_type              in varchar2 default null,
    p_condition_expr              in varchar2 default null,
    p_condition_expr2             in varchar2 default null );

function create_shared_lov(
    p_app_id          in number   default g_app_id,
    p_lov_type        in varchar2,
    p_named_lov       in varchar2,
    p_dynamic_lov     in varchar2   default null,
    p_static_lov_list in t_lov_list default c_empty_t_lov_list ) return varchar2;

procedure create_page_item (
    p_id                        in number   default null,
    p_app_id                    in number   default g_app_id,
    p_page_id                   in number,
    p_display_as                in varchar2,
    p_name                      in varchar2 default null,
    p_is_required               in boolean  default null,
    p_item_sequence             in number   default null,
    p_item_plug_id              in number   default null,
    p_use_cache_before_default  in varchar2 default 'YES',
    p_prompt                    in varchar2 default null,
    p_placeholder               in varchar2 default null,
    p_pre_element_text          in varchar2 default null,
    p_format_mask               in varchar2 default null,
    p_source                    in varchar2 default null,
    p_source_type               in varchar2 default 'ALWAYS_NULL',
    p_item_default              in varchar2 default null,
    p_item_default_type         in varchar2 default null,
    p_named_lov                 in varchar2 default null,
    p_lov_type                  in varchar2 default 'DYNAMIC',
    p_lov                       in varchar2 default null,
    p_lov_display_extra         in varchar2 default 'NO',
    p_lov_display_null          in varchar2 default 'NO',
    p_lov_null_text             in varchar2 default null,
    p_lov_cascade_parent_items  in varchar2 default null,
    p_static_lov_list           in t_lov_list default c_empty_t_lov_list,
    p_ajax_optimize_refresh     in varchar2 default null,
    p_cSize                     in number   default null,
    p_cMaxlength                in number   default null,
    p_cHeight                   in number   default null,
    p_tag_attributes            in varchar2 default null,
    p_begin_on_new_line         in varchar2 default 'Y',
    p_grid_label_column_span    in number   default null,
    p_display_when              in varchar2 default null,
    p_display_when_type         in varchar2 default null,
    p_field_template            in varchar2 default null,
    p_tag_css_classes           in varchar2 default null,
    p_item_css_classes          in varchar2 default null,
    p_item_icon_css_classes     in varchar2 default null,
    p_item_template_options     in varchar2 default null,
    p_restricted_characters     in varchar2 default null,
    p_escape_on_http_output     in varchar2 default null,
    p_protection_level          in varchar2 default null,
    p_help_text                 in varchar2 default null,
    p_inline_help_text          in varchar2 default null,
    --
    p_read_only_when            in varchar2 default null,
    p_read_only_when2           in varchar2 default null,
    p_read_only_when_type       in varchar2 default null,
    p_read_only_disp_attr       in varchar2 default null,
    --
    p_attribute_01              in varchar2 default null,
    p_attribute_02              in varchar2 default null,
    p_attribute_03              in varchar2 default null,
    p_attribute_04              in varchar2 default null,
    p_attribute_05              in varchar2 default null,
    p_attribute_06              in varchar2 default null,
    p_attribute_07              in varchar2 default null,
    p_attribute_08              in varchar2 default null,
    p_attribute_09              in varchar2 default null,
    p_attribute_10              in varchar2 default null,
    p_attribute_11              in varchar2 default null,
    p_attribute_12              in varchar2 default null,
    p_attribute_13              in varchar2 default null,
    p_attribute_14              in varchar2 default null,
    p_attribute_15              in varchar2 default null );

function create_ir_default_report(
    p_app_id    in number default g_app_id,
    p_page_id   in number,
    p_region_id in number ) return number;

procedure create_ir_modal_page(
    p_app_id                      in number   default g_app_id,
    p_page_id                     in number,
    p_user_interface_id           in number   default g_user_interface_id,
    p_group_id                    in number   default g_pg_group_id_admin,
    p_title                       in varchar2,
    p_page_inline_css             in varchar2 default null,
    p_help_text                   in varchar2 default null,
    --
    p_show_help_button_always     in boolean default false,
    -- ir attributes
    p_ir_region_id                in number default null,
    p_query                       in varchar2,
    p_show_detail_link            in boolean  default false,
    p_detail_link                 in varchar2 default null,
    p_detail_link_text            in varchar2 default null,
    p_column_list                 in t_ir_col_list default c_empty_t_ir_col_list,
    p_button_list                 in t_button_list default c_empty_t_button_list,
    --     
    p_ir_disp_when_cond1          in varchar2 default null,
    p_ir_disp_when_cond2          in varchar2 default null,
    p_ir_disp_condition_type      in varchar2 default null,
    -- filter button region     
    p_include_filter              in boolean  default true,
    p_filter_region_id            in number default null,
    p_da_filter_id                in number default null,
    --     
    p_build_option_id             in number default null,
    p_auth_scheme_id              in number default null,
    p_protection_level            in varchar2 default null );

procedure create_app(
    p_app_id                   in number,
    p_app_name                 in varchar2,
    p_parsing_schema           in varchar2,
    p_app_language             in varchar2,
    --
    p_theme                    in t_theme,
    --
    p_app_icon_class           in varchar2 default null,
    p_app_color_class          in varchar2 default null,
    p_app_icon_color_hex       in varchar2 default null,
    p_nav_position             in varchar2 default 'SIDE',
    p_authentication_name      in varchar2 default wwv_flow_authentication_api.c_type_apex_accounts,
    p_base_table_prefix        in varchar2 default null,
    p_features                 in varchar2 default null,
    p_translated_langs         in varchar2 default null,
    -- advanced general
    p_built_with_love          in boolean  default true,
    p_learn_app_def            in boolean  default true,
    p_learn_existing_apps      in boolean  default true,
    p_seed_from_app_id         in number   default null,
    p_short_description        in varchar2 default null,
    p_long_description         in varchar2 default null,
    p_app_version              in varchar2 default null,
    p_js_content_del           in varchar2 default null,
    p_app_logging              in boolean  default true,
    p_app_debugging            in boolean  default false,
    -- advanced security
    p_deep_linking             in boolean  default false,
    p_max_session_length_sec   in number   default null,
    p_max_session_idle_sec     in number   default null,
    -- advanced globalization
    p_document_direction       in varchar2 default null,
    p_date_format              in varchar2 default null,
    p_date_time_format         in varchar2 default null,
    p_timestamp_format         in varchar2 default null,
    p_timestamp_tz_format      in varchar2 default null );

end wwv_flow_create_app_v3;
/
show errors
