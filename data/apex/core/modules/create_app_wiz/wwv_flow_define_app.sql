set define '^' verify off
prompt ...wwv_flow_define_app_v3
create or replace package wwv_flow_define_app_v3 as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_define_app_v3.sql
--
--    DESCRIPTION
--     Used to define pages in new create application wizard introduced in APEX 5.1.1
--
--    NOTES
--      This API is unsupported.    
--
--    MODIFIED (MM/DD/YYYY)
--     cbcho    01/25/2017 - Created
--     cbcho    03/03/2017 - Changed t_chart type and parameters to save chart collection
--     cbcho    03/07/2017 - Added logic to save detail table and form type
--     cbcho    03/09/2017 - Added init_wizard
--     cbcho    03/09/2017 - Added save_page_id
--     cbcho    03/10/2017 - Added p_is_admin_page
--     cbcho    03/15/2017 - Added logic to save master primary and secondary display column
--     mhichwa  03/18/2017 - added link target attributes to add_page and edit page
--     cbcho    03/22/2017 - Added c_column_collection
--     cbcho    04/05/2017 - Renamed to v3
--     cbcho    04/07/2017 - Added logic to save filter report page
--     shrahman 04/10/2017 - add page type MASTER_DETAIL 
--     mhichwa  04/10/2017 - added c_page_timeline and c_page_wizard
--     cbcho    04/18/2017 - added logic to save cards page
--     cbcho    04/19/2017 - added logic to save timeline page
--     cbcho    04/25/2017 - added filter_rpt_page_exists
--     xhu      05/03/2017 - added c_md_grid
--     cbcho    05/05/2017 - added t_wizard
--     cbcho    05/12/2017 - added save_region_id
--     cbcho    05/25/2017 - added logic to save table FK defined from wizard
--     cbcho    10/05/2017 - In add_page, edit_page: added p_include_report
--     cbcho    10/26/2017 - added add_page_from_script
--     cbcho    11/03/2017 - added add_multiple_rpts
--     cbcho    01/12/2018 - added spreadhsheet load and sample data functions
--     mhichwa  01/16/2018 - added get_vehical_speed_data and get_sales_data functions and get_emp_data
--     mhichwa  01/16/2018 - added get_tennis_data
--     mhichwa  01/17/2018 - added get_f1_data, revised tennis_data, all data now returns clobs
--     mhichwa  01/31/2018 - added get_academic_data
--     hfarrell 02/01/2018 - Renamed get_json_purchase_order_data to get_json_test_data (Hudson install issue)
--     mhichwa  02/01/2018 - added function get_json_only_data 
--     cbcho    02/13/2018 - extended t_chart to save drill down link
--     cbcho    07/18/2018 - Added add_page_from_sample_json (feature #2365)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------
type t_fk is record(
    fk_column                 varchar2(255),
    detail_table_name         varchar2(255),
    detail_table_pk           varchar2(255),
    detail_table_display_col  varchar2(255) );

type t_fk_list is table of t_fk index by pls_integer;

type t_chart is record(
    chart_name        varchar2(255),
    chart_type        varchar2(30),
    table_name        varchar2(255),
    label_column      varchar2(255),
    value_column      varchar2(255),
    value_function    varchar2(30),
    --
    link_column       varchar2(255),
    link_key          varchar2(255),
    link_to_page      varchar2(255),
    link_target_key   varchar2(255) );

type t_chart_list is table of t_chart index by pls_integer;

type t_calendar is record(
    display_column    varchar2(255),
    start_date_column varchar2(255),
    end_date_column   varchar2(255),
    show_time         varchar2(1) );

type t_table_list is table of varchar2(255) index by pls_integer;

type t_md is record(
    primary_label_column   varchar2(255),
    secondary_label_column varchar2(255) );

type t_filter_rpt is record(
    title_column   varchar2(255),
    desc_column    varchar2(255),
    add_txt_column varchar2(255),
    filter_columns varchar2(4000) );

type t_card is record(
    title_column   varchar2(255),
    desc_column    varchar2(255),
    add_txt_column varchar2(255) );

type t_timeline is record(
    username_column   varchar2(255),
    date_column       varchar2(255),
    event_name_column varchar2(255),
    desc_column       varchar2(255) );

type t_wizard is record(
    page_mode     varchar2(30),
    page_name_1   varchar2(255),
    page_name_2   varchar2(255),
    page_name_3   varchar2(255),
    page_name_4   varchar2(255),
    page_name_5   varchar2(255),
    page_name_6   varchar2(255),
    page_name_7   varchar2(255),
    page_name_8   varchar2(255) );

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_empty_t_chart_list     t_chart_list;
c_empty_t_table_list     t_table_list;
c_empty_t_fk_list        t_fk_list;

-- page types
c_page_blank          constant varchar2(30) := 'BLANK';
c_page_ig             constant varchar2(30) := 'INTERACTIVE_GRID';
c_page_ir             constant varchar2(30) := 'INTERACTIVE_RPT';
c_page_cr             constant varchar2(30) := 'CLASSIC_RPT';
c_page_filter_rpt     constant varchar2(30) := 'FILTER_RPT';
c_page_cards          constant varchar2(30) := 'CARDS';
c_page_calendar       constant varchar2(30) := 'CALENDAR';
c_page_form           constant varchar2(30) := 'FORM';
c_page_master_detail  constant varchar2(30) := 'MASTER_DETAIL';
c_page_list           constant varchar2(30) := 'LIST';
c_page_dashboard      constant varchar2(30) := 'DASHBOARD';
c_page_chart          constant varchar2(30) := 'CHART';
c_page_timeline       constant varchar2(30) := 'TIMELINE';
c_page_wizard         constant varchar2(30) := 'WIZARD';

-- form types
c_form_on_table       constant varchar2(30) := 'FORM_ON_TABLE';
c_md_w_selector       constant varchar2(30) := 'MD_ON_TABLE_WITH_SELECTOR';
c_md_grid             constant varchar2(30) := 'MD_GRID';

c_page_collection     constant varchar2(255) := 'APEX$CREATE_APP_PAGE';
c_chart_collection    constant varchar2(255) := 'APEX$CREATE_APP_PAGE_CHART';
c_column_collection   constant varchar2(255) := 'APEX$CREATE_APP_PAGE_COLUMN';
c_fk_collection       constant varchar2(255) := 'APEX$CREATE_APP_PAGE_FK';

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--

function md_page_exists return boolean;

function filter_rpt_page_exists return boolean;

function is_home_page(
    p_page_id in number default null ) return boolean;

function get_internal_page_id(
    p_page_id  in number ) return number;

function get_page_id(
    p_internal_page_id  in number ) return number;

procedure init_wizard;

procedure move_page_up(
    p_page_id  in number );

procedure move_page_down(
    p_page_id  in number );

function add_page(
    p_page_name         in varchar2,
    p_page_type         in varchar2,
    p_page_icon         in varchar2     default null,
    p_page_help         in varchar2     default null,
    p_schema            in varchar2     default null,
    p_source_type       in varchar2     default null,
    p_source            in clob         default null,
    p_table_name        in varchar2     default null,
    p_is_homepage       in boolean      default false,
    p_is_admin_page     in boolean      default false,
    p_ig_is_editable    in boolean      default false,
    p_include_form      in boolean      default false,
    p_include_report    in boolean      default false,
    p_form_type         in varchar2     default null,  
    p_parent_page_id    in number       default null,
    p_calendar          in t_calendar   default null,
    p_md                in t_md         default null,
    p_filter_rpt        in t_filter_rpt default null,
    p_card              in t_card       default null,
    p_timeline          in t_timeline   default null,
    p_wizard            in t_wizard     default null,
    p_chart_list        in t_chart_list default c_empty_t_chart_list,
    p_detail_table_list in t_table_list default c_empty_t_table_list,
    p_fk_list           in t_fk_list    default c_empty_t_fk_list,
    -- mike
    p_link_column       in varchar2     default null,
    p_link_key          in varchar2     default null,
    p_link_to_page      in varchar2     default null,
    p_link_target_key   in varchar2     default null ) return number;

procedure add_page(
    p_page_name         in varchar2,
    p_page_type         in varchar2,
    p_page_icon         in varchar2     default null,
    p_page_help         in varchar2     default null,
    p_schema            in varchar2     default null,
    p_source_type       in varchar2     default null,
    p_source            in clob         default null,
    p_table_name        in varchar2     default null,
    p_is_homepage       in boolean      default false,
    p_is_admin_page     in boolean      default false,
    p_ig_is_editable    in boolean      default false,
    p_include_form      in boolean      default false,
    p_include_report    in boolean      default false,
    p_parent_page_id    in number       default null,
    p_form_type         in varchar2     default null,
    p_calendar          in t_calendar   default null,
    p_md                in t_md         default null,
    p_filter_rpt        in t_filter_rpt default null,
    p_card              in t_card       default null,
    p_timeline          in t_timeline   default null,
    p_wizard            in t_wizard     default null,
    p_chart_list        in t_chart_list default c_empty_t_chart_list,
    p_detail_table_list in t_table_list default c_empty_t_table_list,
    p_fk_list           in t_fk_list    default c_empty_t_fk_list,
    -- mike
    p_link_column       in varchar2     default null,
    p_link_key          in varchar2     default null,
    p_link_to_page      in varchar2     default null,
    p_link_target_key   in varchar2     default null );                     -- drill down attributes

procedure edit_page(
    p_page_id           in number,
    p_page_name         in varchar2,
    p_page_type         in varchar2,
    p_page_icon         in varchar2     default null,
    p_page_help         in varchar2     default null,
    p_schema            in varchar2     default null,
    p_source_type       in varchar2     default null,
    p_source            in clob         default null,
    p_table_name        in varchar2     default null,
    p_is_homepage       in boolean      default false,
    p_is_admin_page     in boolean      default false,
    p_ig_is_editable    in boolean      default false,
    p_include_form      in boolean      default false,
    p_include_report    in boolean      default false,
    p_parent_page_id    in number       default null,
    p_form_type         in varchar2     default null,
    p_calendar          in t_calendar   default null,
    p_md                in t_md         default null,
    p_filter_rpt        in t_filter_rpt default null,
    p_card              in t_card       default null,
    p_timeline          in t_timeline   default null,
    p_wizard            in t_wizard     default null,
    p_chart_list        in t_chart_list default c_empty_t_chart_list,
    p_detail_table_list in t_table_list default c_empty_t_table_list,
    p_fk_list           in t_fk_list    default c_empty_t_fk_list,
    -- mike
    p_link_column       in varchar2     default null,
    p_link_key          in varchar2     default null,
    p_link_to_page      in varchar2     default null,
    p_link_target_key   in varchar2     default null );                     -- drill down attributes

procedure delete_page(
    p_page_id     in number );

procedure save_page_id(
    p_seq_id      in number,
    p_new_page_id in number );

procedure save_region_id(
    p_internal_page_id in number,
    p_table_name       in varchar2,
    p_new_region_id    in number );

procedure add_multiple_rpts(
    p_schema             in varchar2,
    p_table_names        in wwv_flow_global.vc_arr2 );

procedure add_page_from_script(
    p_schema             in varchar2,
    p_script_result_id   in number );

procedure load_spreadsheet(
    p_schema                 in varchar2,
    p_table_name             in varchar2,
    p_collection             in varchar2 default 'EXCEL_IMPORT',
    p_string                 in clob default empty_clob(),
    p_file_name              in varchar2 default null, 
    p_file_charset           in varchar2 default null, 
    p_separator              in varchar2 default '\t',
    p_enclosed_by            in varchar2 default null,
    p_currency               in varchar2 default '$',
    p_numeric_chars          in varchar2 default '.,',
    p_first_row_is_col_name  in boolean default false,
    p_load_id                in number default null );

procedure add_page_from_spreadsheet_load(
    p_schema       in varchar2,
    p_load_id      in number );

--
-- Sample Data
--

function get_country_population_data  return clob ;
function get_project_data             return clob ;
function get_emp_data                 return clob ;
function get_vehical_speed_data       return clob ;
function get_sales_data               return clob ;
function get_tennis_data              return clob ;
function get_worldcup_data            return clob ;
function get_f1_data                  return clob ;
function get_movie_data               return clob ;
function get_academic_data            return clob ;
function get_json_test_data           return clob ;
function get_json_only_data           return clob ;

procedure add_page_from_sample_json(
    p_json_id      in number,
    --
    p_built_with_love       out varchar2, -- p5_built_with_love
    p_learn_app_def         out varchar2, -- p5_learn_yn
    p_app_name              out varchar2, -- p1_app_name
    p_app_short_desc        out varchar2, -- p5_app_short_desc
    p_app_desc              out varchar2, -- p5_app_desc
    p_features              out varchar2, -- p1_features
    p_theme_style           out varchar2, -- p1_theme_style
    p_nav_position          out varchar2, -- p1_nav_position
    p_app_icon_class        out varchar2, -- p1_app_icon_class
    p_app_color_class       out varchar2, -- p1_app_color_class
    p_app_color_hex         out varchar2, -- p1_app_color_hex
    p_base_table_prefix     out varchar2, -- p5_base_table_prefix
    p_primary_language      out varchar2, -- p1_primary_language
    p_translated_langs      out varchar2, -- p1_translated_langs
    p_authentication        out varchar2, -- p1_authentication
    p_app_version           out varchar2, -- p5_app_version
    p_app_logging           out varchar2, -- p5_app_logging
    p_app_debugging         out varchar2, -- p5_app_debugging
    p_document_direction    out varchar2, -- p5_document_direction
    p_date_format           out varchar2, -- p5_date_format
    p_date_time_format      out varchar2, -- p5_date_time_format
    p_timestamp_format      out varchar2, -- p5_timestamp_format
    p_timestamp_tz_format   out varchar2, -- p5_timestamp_tz_format
    p_deep_linking          out varchar2, -- p5_deep_linking
    p_max_session_length    out varchar2, -- p5_max_session_length
    p_max_session_idle_time out varchar2 -- p5_max_session_idle_time
    );

end wwv_flow_define_app_v3;
/
show errors;