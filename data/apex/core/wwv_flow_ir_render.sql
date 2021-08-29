set define '^' verify off
prompt ...wwv_flow_ir_render
create or replace package wwv_flow_ir_render as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_ir_render.sql
--
--    DESCRIPTION
--      This package is responsible for handling interactive reports. Beginning
--      with APEX 5.2, interactive report code will be separated from websheets
--      code: 
--      Websheets code remains in wwv_flow_worksheet, whereas interactive
--      report implementation will be migrated to use the wwv_flow_exec 
--      infrastructure.
--      
--    MODIFIED  (MM/DD/YYYY)
--      cczarski 08/11/2017 - Created based on wwv_flow_worksheet.plb
--      cneumuel 08/31/2017 - Removed parse override parameters from render procs
--      cczarski 09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec
--      cneumuel 02/20/2018 - In function render: removed unused p_plugin, p_plug (bug #27523529)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_empty_columns           wwv_flow_ir.t_columns;
c_empty_columns_by_name   wwv_flow_ir.t_columns_by_name;

c_canonical_date_format   constant varchar2(16)  := 'YYYYMMDDHH24MISS';
c_canonical_number_format constant varchar2(47)  := '99999999999999999999999999999999999999.99999999';
c_nls_num_characters      constant varchar2(29)  := 'NLS_NUMERIC_CHARACTERS=''.,''';

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--
g_notify_in_progress          boolean     := false;

g_ir_show_select_columns      varchar2(1);
g_ir_show_filter              varchar2(1);
g_ir_show_sort                varchar2(1);
g_ir_show_ctrl_break          varchar2(1);
g_ir_show_highlight           varchar2(1);
g_ir_show_computation         varchar2(1);
g_ir_show_aggregate           varchar2(1);
g_ir_show_notify              varchar2(1);
g_ir_show_chart               varchar2(1);
g_ir_show_group_by            varchar2(1);
g_ir_show_flashback           varchar2(1);
g_ir_show_save_report         varchar2(1);
g_ir_show_save_report_public  varchar2(1);
g_ir_show_reset               varchar2(1);
g_ir_show_help                varchar2(1);
g_ir_show_download            varchar2(1);
g_ir_show_download_csv        varchar2(1);
g_ir_show_download_html       varchar2(1);
g_ir_show_download_email      varchar2(1);
g_ir_show_download_xls        varchar2(1);
g_ir_show_download_pdf        varchar2(1);
g_ir_show_download_rtf        varchar2(1);
g_ir_show_download_xml        varchar2(1);

--
--==============================================================================
function build_ir_dom_id (
    p_ir_attributes in wwv_flow_ir.t_interactive_report,
    p_id            in varchar2 ) return varchar2;

--
--==============================================================================
function fetch_ir_attributes(
    p_region                     in wwv_flow_plugin_api.t_region,
    p_report_id                  in number,
    p_include_hidden_cols        in boolean default false,
    p_include_computed_cols      in boolean default false,
    p_create_report_if_necessary in boolean default true ) return wwv_flow_ir.t_interactive_report;

--
--==============================================================================
procedure get_worksheet_prefs (
    p_worksheet_id   in            number,
    p_ir_preferences in out nocopy wwv_flow_ir.t_ir_preferences );

--
--==============================================================================
procedure set_worksheet_prefs (
    p_ir_preferences    in out nocopy wwv_flow_ir.t_ir_preferences,
    p_worksheet_id      in            number,
    --
    p_parent_report_id  in number   default null, 
    p_hide_rpt_settings in varchar2 default null, 
    p_show_nulls        in varchar2 default null, 
    p_show_rpt_cols     in varchar2 default null, 
    p_rpt_view_mode     in varchar2 default null ) ;

--
--==============================================================================
function open_filter_context(
    p_ir_attributes     in out nocopy wwv_flow_ir.t_interactive_report,
    p_report_id         in            number default null,
    p_column            in            varchar2,
    p_search_string     in            varchar2 default null ) return wwv_flow_exec.t_context;

--
--==============================================================================
procedure render_report (
    p_ir_attributes    in out nocopy wwv_flow_ir.t_interactive_report,
    --
    p_app_user         in varchar2,
    p_request          in varchar2,
    p_max_rows         in number   default null,
    p_view_mode        in varchar2 default null,
    --
    p_show_checkbox    in boolean  default false,
    p_show_report_tabs in varchar2 default null );

--
--==============================================================================
function generate_report_query(
    p_ir_attributes           in out nocopy wwv_flow_ir.t_interactive_report,
    p_view_mode               in varchar2 default 'REPORT' ) return varchar2;

--
--==============================================================================
procedure get_chart( 
    p_ir_attributes  in out nocopy wwv_flow_ir.t_interactive_report );

--
--==============================================================================
procedure show_single_row (
    p_ir_attributes      in out nocopy wwv_flow_ir.t_interactive_report,
    p_row_id             in varchar2 default null,
    p_base_report_id     in number   default null,
    p_display_button_bar in boolean  default true );

-- 
--==============================================================================
procedure render (
    p_region                 in wwv_flow_plugin_api.t_region,
    p_request                in varchar2,
    p_actions_menu_structure in varchar2 default 'IG' );

-- 
--==============================================================================
procedure render_ajax(
    p_region                    in wwv_flow_plugin_api.t_region,
    p_request                   in varchar2,
    p_max_rows                  in number   default null,
    p_report_id                 in number   default null,
    p_view_mode                 in varchar2 default null );

--==============================================================================
function get_version_identifier
    return varchar2;
--
--
end wwv_flow_ir_render;
/
show errors
