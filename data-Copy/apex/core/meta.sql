set define '^' verify off
prompt ...wwv_flow_meta_data
create or replace package wwv_flow_meta_data as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    DESCRIPTION
--      Fetch meta data for flow rendering
--
--    NOTES
--      Information required to render and process page information is queried from
--      tables using this package.  Template information is queried using the
--      wwv_flow_templates_util package.

--    SECURITY
--      only executable by flows engine
--
--    SECURITY
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED  (MM/DD/YYYY)
--      mhichwa  11/13/1999 - Created
--      mhichwa  12/09/1999 - Added fetch_toplevel_tab_info
--      mhichwa  01/09/2000 - Removed alt_flow_step_id argument
--      mhichwa  01/12/2000 - Added fetch_page_plugs function
--      mhichwa  02/19/2000 - Moved fetch_template_preference from fetch_flow_info
--      mhichwa  05/02/2000 - Added g_first_displayable_field global
--      mhichwa  11/08/2000 - Added static subs
--      mhichwa  12/12/2000 - fetch_required_roles is obsolete
--      mhichwa  12/22/2000 - Added security checks passed global
--      mhichwa  12/26/2000 - Added security checks failed
--      mhichwa  01/20/2001 - Added g_on_new_instance_fired_for
--      mhichwa  08/01/2001 - Set sec failed and fast to 4000 from 5000 bytes
--      tmuth    10/03/2002 - Changed g_first_displayable_field to 50 char instead of 8
--      mhichwa  10/20/2002 - Added fetch_show and accept processing
--      sspadafo 12/27/2002 - Added fetch_show_branch_info and fetch_accept_branch_info (Bug 2729764)
--      sspadafo 02/09/2003 - Added globals for new build option evaluation method (Bug 2748385)
--      sspadafo 02/10/2003 - Added functions fetch_g_build_options_.. to return build option globals (Bug 2748385)
--      sspadafo 02/08/2005 - Added fetch_protected_item_ids, fetch_protected_page_info procedures for URL tampering feature
--      sspadafo 02/27/2006 - Remove obsolete fetch_process_info
--      sspadafo 04/23/2006 - Added fetch_public_page_info for zero session ID feature
--      sspadafo 12/03/2007 - Removed fetch_protected_item_ids procedure
--      mhichwa  09/11/2008 - Added p_mode argument
--      sspadafo 01/11/2009 - Removed obsolete procedure fetch_branch_info
--      pawolf   04/10/2009 - Moved format_lov_query to wwv_flow_meta_data
--      pawolf   06/09/2009 - Added is_ok_to_display and is_valid_build_option
--      pawolf   06/10/2009 - Moved functions from wwv_flow_meta_data to wwv_flow_meta_util
--      cneumuel 06/30/2011 - Added do_static_substitutions and find_static_substitution, moved g_static_substitution% from spec to body (bug #12636771)
--      cneumuel 05/21/2012 - Removed fetch_template_preference, fetch_items_on_new_instance
--      cneumuel 05/24/2012 - Added find_item_by_name, find_item_by_id
--      cneumuel 05/29/2012 - in t_item_properties: removed dependency to wwv_flow_step_items because of dependency problem in coreins.sql (mail vlad)
--      cneumuel 05/31/2012 - In t_item_properties and cursors: add scope (feature #897)
--      cneumuel 06/01/2012 - Added t_item_scope.c_report_scope for saving report metadata in session state
--                          - In find_item_by_name: added p_application_id
--      cneumuel 05/31/2013 - removed g_on_new_instance_fired_for (feature #861)
--      cneumuel 09/11/2013 - Added fetch_flow_record
--      cneumuel 02/21/2014 - Remove obsolete fetch_public_page_info, fetch_protected_page_info (feature #1047)
--      cneumuel 03/11/2014 - result cache optimizations for find_item_by_%
--      cneumuel 03/14/2014 - Remove internal_rc_find_item_by_name from spec
--      cneumuel 04/04/2014 - Moved fetch_button_info and fetch_item_info into fetch_page_plugs. Added get_component_index (feature #1314)
--      cneumuel 04/08/2014 - In get_component_index: use type and id as parameters, not object type
--      cneumuel 06/05/2014 - Added c_process_scope: pseudo item type for process scope session state
--      cneumuel 07/17/2014 - In fetch_step_info: change to procedure that raises error if page not found. optimizations.
--      cneumuel 11/05/2014 - In fetch_branch_info, fetch_process_info, fetch_computations: use result cache and table of record result type
--      cneumuel 02/09/2015 - In find_item_by_name: added p_error_when_not_found (bug #20495355)
--      cneumuel 05/07/2015 - long identifier support (bug #21031940)
--      cneumuel 10/09/2015 - in t_item_properties.protection_level: use wwv_flow_security.t_checksum_protection_level (bug #21973444)
--      pawolf   05/18/2016 - renamed wwv_flow_meta_data.g_first_displayable_field to g_first_navigable_js_code
--      cczarski 07/06/2016 - add C_THEME_SCOPE to store theme-related information in session state
--      cneumuel 02/20/2018 - Moved runtime engine globals from flow.sql to meta.sql (bug #27523529)
--      cneumuel 02/22/2018 - Moved more runtime globals from flow.sql to meta.sql (bug #27523529)
--
--------------------------------------------------------------------------------

--==============================================================================
-- t_item_properties and utility subtypes
--
-- for protection_level, we can not use the type t_checksum_protection_level and
-- it's constants in wwv_flow_security. doing so causes PLS-00707 [2603, 2604]
-- because of cross package dependency problems for default values.
--==============================================================================
subtype t_item_scope is varchar2(7);
c_page_item_scope    constant t_item_scope := 'PAGE';    -- page item
c_app_item_scope     constant t_item_scope := 'APP';     -- app-local app item
c_global_item_scope  constant t_item_scope := 'GLOBAL';  -- global app item
c_report_scope       constant t_item_scope := 'REPORT';  -- report metadata pseudo-item
c_process_scope      constant t_item_scope := 'PROCESS'; -- process metadata pseudo-item
c_theme_scope        constant t_item_scope := 'THEME';   -- theme metadata pseudo-item
type t_item_properties is record (
    id                    number,
    security_group_id     number,
    scope                 t_item_scope,
    name                  varchar2(255),
    prompt                varchar2(4000),
    data_type             varchar2(30),
    restricted_characters varchar2(20),
    is_persistent         varchar2(1),
    is_encrypted          boolean,
    is_password_dnss      boolean,
    escape_on_http_input  boolean,
    protection_level      pls_integer not null default 0 );
--==============================================================================
-- t_flows: wwv_flows rowtype
--==============================================================================
subtype t_flows is wwv_flows%rowtype;

--==============================================================================
-- package globals
--==============================================================================
g_first_navigable_js_code      varchar2(4000);
g_build_options_included       varchar2(32767);
g_build_options_excluded       varchar2(32767);

--==============================================================================
-- page information
--==============================================================================
g_page_cache_mode              wwv_flow_steps.cache_mode%type;-- page cache mode
g_page_cache_timeout_seconds   wwv_flow_steps.cache_timeout_seconds%type;
g_page_cache_when_cond_type    wwv_flow_steps.cache_when_condition_type%type;
g_page_cache_when_cond_e1      wwv_flow_steps.cache_when_condition_e1%type;
g_page_cache_when_cond_e2      wwv_flow_steps.cache_when_condition_e2%type;
g_read_only_when_type          varchar2(32767);
g_read_only_when               varchar2(32767);
g_read_only_when2              varchar2(32767);

--==============================================================================
-- shortcuts
--==============================================================================
g_shortcut_name                wwv_flow_global.vc_arr2;
g_shortcut_id                  wwv_flow_global.vc_arr2;

--==============================================================================
-- buttons
--==============================================================================
type t_button is record (
    id                         wwv_flow_step_buttons.id%type                      ,
    page_id                    wwv_flow_step_buttons.flow_step_id%type            ,
    button_name                wwv_flow_step_buttons.button_name%type             ,
    button_plug_id             wwv_flow_step_buttons.button_plug_id%type          ,
    button_template_id         wwv_flow_step_buttons.button_template_id%type      ,
    button_template_options    wwv_flow_step_buttons.button_template_options%type ,
    button_is_hot              wwv_flow_step_buttons.button_is_hot%type           ,
    button_label               wwv_flow_step_buttons.button_image_alt%type        ,
    button_position            wwv_flow_step_buttons.button_position%type         ,
    button_sequence            wwv_flow_step_buttons.button_sequence%type         ,
    button_alignment           wwv_flow_step_buttons.button_alignment%type        ,
    button_css_classes         wwv_flow_step_buttons.button_css_classes%type      ,
    icon_css_classes           wwv_flow_step_buttons.icon_css_classes%type        ,
    button_redirect_url        wwv_flow_step_buttons.button_redirect_url%type     ,
    button_action              wwv_flow_step_buttons.button_action%type           ,
    button_execute_validations wwv_flow_step_buttons.button_execute_validations%type,
    warn_on_unsaved_changes    wwv_flow_step_buttons.warn_on_unsaved_changes%type ,
    button_condition           wwv_flow_step_buttons.button_condition%type        ,
    button_condition2          wwv_flow_step_buttons.button_condition2%type       ,
    button_condition_type      wwv_flow_step_buttons.button_condition_type%type   ,
    button_cattributes         wwv_flow_step_buttons.button_cattributes%type      ,
    security_scheme            wwv_flow_step_buttons.security_scheme%type         ,
    button_static_id           wwv_flow_step_buttons.button_static_id%type        ,
    request_source             wwv_flow_step_buttons.request_source%type          ,
    request_source_type        wwv_flow_step_buttons.request_source_type%type     ,
    pre_element_text           wwv_flow_step_buttons.pre_element_text%type        ,
    post_element_text          wwv_flow_step_buttons.post_element_text%type       ,
    grid_column_attributes     wwv_flow_step_buttons.grid_column_attributes%type  ,
    grid_new_grid              wwv_flow_step_buttons.grid_new_grid%type           ,
    grid_new_row               wwv_flow_step_buttons.grid_new_row%type            ,
    grid_new_column            wwv_flow_step_buttons.grid_new_column%type         ,
    grid_column_span           wwv_flow_step_buttons.grid_column_span%type        ,
    grid_row_span              wwv_flow_step_buttons.grid_row_span%type           ,
    grid_column                wwv_flow_step_buttons.grid_column%type             ,
    grid_column_css_classes    wwv_flow_step_buttons.grid_column_css_classes%type ,
    --
    -- attributes that are not directly set via base table fields
    --
    is_ok_to_display           boolean,                   -- result of conditional display computation
    request_name               varchar2(32767) );         -- submit request name
type t_buttons is table of t_button index by pls_integer;
g_buttons                      t_buttons;
g_default_button_position      varchar2(30);

--==============================================================================
-- Navigation Bar
--==============================================================================
g_icon_id                    wwv_flow_global.n_arr;       -- pk of nav bar icon
g_icon_image                 wwv_flow_global.vc_arr2;     -- name of image
g_icon_subtext               wwv_flow_global.vc_arr2;     -- entry label
g_icon_is_feedback           wwv_flow_global.n_arr;       -- 1 = is feedback, 0 = not feedback
g_icon_target                wwv_flow_global.vc_arr2;     --
g_icon_image_alt             wwv_flow_global.vc_arr2;     --
g_icon_height                wwv_flow_global.vc_arr2;     --
g_icon_width                 wwv_flow_global.vc_arr2;     --
g_icon_free_text             wwv_flow_global.vc_arr2;     --
g_icon_bar_disp_cond         wwv_flow_global.vc_arr2;     --
g_icon_bar_disp_cond_type    wwv_flow_global.vc_arr2;     --
g_icon_bar_flow_cond_instr   wwv_flow_global.vc_arr2;     --
g_icon_begins_on_new_line    wwv_flow_global.vc_arr2;     --
g_icon_colspan               wwv_flow_global.vc_arr2;     --
g_icon_onclick               wwv_flow_global.vc_arr2;     --
g_icon_security_scheme       wwv_flow_global.vc_arr2;     --

--==============================================================================
-- tab and parent tab info
--==============================================================================
g_tab_id                     wwv_flow_global.n_arr;       -- std tab: pk
g_tab_set                    wwv_flow_global.vc_arr2;     -- std tab: name of tab "collection"
g_tab_step                   wwv_flow_global.vc_arr2;     -- std tab: page
g_tab_name                   wwv_flow_global.vc_arr2;     -- std tab: name of tab, not the display text
g_tab_image                  wwv_flow_global.vc_arr2;     -- std tab: optional image name
g_tab_non_current_image      wwv_flow_global.vc_arr2;     -- std tab: optional image name
g_tab_image_attributes       wwv_flow_global.vc_arr2;     -- std tab: attributes for images
g_tab_text                   wwv_flow_global.vc_arr2;     -- std tab: display text of tab
g_tab_target                 wwv_flow_global.vc_arr2;     --
g_tab_parent_id              wwv_flow_global.n_arr;       -- parent tab pk
g_tab_parent_tabset          wwv_flow_global.vc_arr2;     -- parent tab tabset
g_tab_parent_display_cond    wwv_flow_global.vc_arr2;     -- parent tab display condition
g_tab_parent_display_cond2   wwv_flow_global.vc_arr2;     -- parent tab display condition2
g_tab_parent_display_cond_ty wwv_flow_global.vc_arr2;     -- parent tab display condition type
g_tab_parent_security_scheme wwv_flow_global.vc_arr2;     -- parent tab security scheme
g_tab_current_on_tabset      wwv_flow_global.vc_arr2;     -- parent tab current for this standard tab set
g_tab_also_current_for_pages wwv_flow_global.vc_arr2;     -- std tab: also current for comma delimited page list
g_tab_plsql_condition        wwv_flow_global.vc_arr2;     --
g_tab_plsql_condition_type   wwv_flow_global.vc_arr2;     --
g_tab_disp_cond_text         wwv_flow_global.vc_arr2;     --
g_tab_security_scheme        wwv_flow_global.vc_arr2;     -- sec scheme
g_last_tab_pressed           varchar2(32767);             -- when branching to a tab, this global is set
g_current_parent_tab_text    varchar2(32767);             -- text of the current parent tab set

--==============================================================================
-- page template info
--==============================================================================
g_page_tmpl_id               number;
g_current_tab                varchar2(32767);               --
g_current_tab_font_attr      varchar2(32767);               --
g_non_current_tab            varchar2(32767);               --
g_non_current_tab_font_attr  varchar2(32767);               --
g_current_image_tab          varchar2(32767);               --
g_non_current_image_tab      varchar2(32767);               --
g_top_current_tab            varchar2(32767);               --
g_top_current_tab_font_attr  varchar2(32767);               --
g_top_non_curr_tab           varchar2(32767);               --
g_top_non_curr_tab_font_attr varchar2(32767);               --
g_header_template            varchar2(32767);               -- page template header
g_box                        varchar2(32767);               -- page template body
g_footer_template            varchar2(32767);               -- page template footer
g_page_tmpl_def_templ_opt    varchar2(32767);               -- page template default template options
g_footer_len                 pls_integer;                   --
g_footer_end                 varchar2(32767);               --
g_end_tag_printed            boolean         default true;  -- used to position edit links
g_template_navigation_bar    varchar2(32767);               --
g_template_navbar_entry      varchar2(32767);               -- defines a navigation bar occurance
g_template_success_message   varchar2(32767);               -- success message page sub template
g_body_title                 varchar2(32767);               --
g_notification_message       varchar2(32767);               -- notification message page sub template
g_error_page_template        varchar2(32767);               -- error page template
g_mobile_mode                boolean         default false; -- render page in mobile mode when using mobile page template

g_heading_bgcolor            varchar2(32767);               -- obsolete ?
g_table_bgcolor              varchar2(32767);               -- obsolete ?
g_table_cattributes          varchar2(32767);               -- obsolete ?
g_region_table_cattributes   varchar2(32767);               -- obsolete ?
g_font_size                  varchar2(32767);               -- obsolete ?
g_font_face                  varchar2(32767);               -- obsolete ?
g_page_tmpl_dialog_css       varchar2(32767);
g_page_tmpl_css_file_urls    varchar2(32767);
g_page_tmpl_inline_css       varchar2(32767);
g_page_tmpl_js_file_urls     varchar2(32767);
g_page_tmpl_js_code          varchar2(32767);
g_page_tmpl_js_code_onload   varchar2(32767);
g_page_tmpl_dialog_js_code   varchar2(32767);
g_page_tmpl_dialog_close_js  varchar2(32767);
g_page_tmpl_dialog_cancel_js varchar2(32767);
g_page_tmpl_is_popup         boolean         default false;
g_page_tmpl_dialog_height    varchar2(20);
g_page_tmpl_dialog_width     varchar2(20);
g_page_tmpl_dialog_max_width varchar2(20);

--==============================================================================
-- item info
--==============================================================================
type t_item is record (
    id                            wwv_flow_step_items.id%type                       ,
    page_id                       wwv_flow_step_items.flow_step_id%type             ,
    name                          wwv_flow_step_items.name%type                     ,
    is_persistent                 wwv_flow_step_items.is_persistent%type            ,
    is_required                   wwv_flow_step_items.is_required%type              ,
    item_sequence                 wwv_flow_step_items.item_sequence%type            ,
    item_plug_id                  wwv_flow_step_items.item_plug_id%type             ,
    item_default                  wwv_flow_step_items.item_default%type             ,
    item_default_type             wwv_flow_step_items.item_default_type%type        ,
    prompt                        wwv_flow_step_items.prompt%type                   ,
    plain_label                   wwv_flow_step_items.prompt%type                   ,
    label_id                      varchar2( 261 )                                   , -- 261=length of name + _label
    placeholder                   wwv_flow_step_items.placeholder%type              ,
    template_id                   wwv_flow_field_templates.id%type                  ,
    before_item_text              wwv_flow_field_templates.before_item%type         ,
    after_item_text               wwv_flow_field_templates.after_item%type          ,
    before_element_text           wwv_flow_field_templates.before_element%type      ,
    after_element_text            wwv_flow_field_templates.after_element%type       ,
    help_template                 wwv_flow_field_templates.help_link%type           ,
    inline_help_template          wwv_flow_field_templates.inline_help_text%type    ,
    error_template                wwv_flow_field_templates.error_template%type      ,
    pre_element_text              wwv_flow_step_items.pre_element_text%type         ,
    post_element_text             wwv_flow_step_items.post_element_text%type        ,
    pre_element_template          wwv_flow_field_templates.item_pre_text%type       ,
    post_element_template         wwv_flow_field_templates.item_post_text%type      ,
    format_mask                   wwv_flow_step_items.format_mask%type              ,
    item_css_classes              wwv_flow_step_items.item_css_classes%type         ,
    item_icon_css_classes         wwv_flow_step_items.item_icon_css_classes%type    ,
    item_template_options         wwv_flow_step_items.item_template_options%type    ,
    default_template_options      wwv_flow_step_items.item_template_options%type    ,
    source                        wwv_flow_step_items.source%type                   ,
    source_type                   wwv_flow_step_items.source_type%type              ,
    source_post_computation       wwv_flow_step_items.source_post_computation%type  ,
    display_as                    wwv_flow_step_items.display_as%type               ,
    lov                           wwv_flow_step_items.lov%type                      ,
    lov_display_extra             wwv_flow_step_items.lov_display_extra%type        ,
    lov_display_null              wwv_flow_step_items.lov_display_null%type         ,
    lov_null_text                 wwv_flow_step_items.lov_null_text%type            ,
    lov_null_value                wwv_flow_step_items.lov_null_value%type           ,
    lov_translated                wwv_flow_step_items.lov_translated%type           ,
    lov_cascade_parent_item       wwv_flow_step_items.lov_cascade_parent_items%type ,
    ajax_items_to_submit          wwv_flow_step_items.ajax_items_to_submit%type     ,
    ajax_optimize_refresh         wwv_flow_step_items.ajax_optimize_refresh%type    ,
    --
    csize                         wwv_flow_step_items.csize%type                    ,
    cmaxlength                    wwv_flow_step_items.cmaxlength%type               ,
    cHeight                       wwv_flow_step_items.cHeight%type                  ,
    cattributes                   wwv_flow_step_items.cattributes%type              ,
    cattributes_element           wwv_flow_step_items.cattributes_element%type      ,
    tag_css_classes               wwv_flow_step_items.tag_css_classes%type          ,
    tag_attributes                wwv_flow_step_items.tag_attributes%type           ,
    tag_attributes2               wwv_flow_step_items.tag_attributes2%type          ,
    --
    new_grid                      wwv_flow_step_items.new_grid%type                 ,
    begin_on_new_line             wwv_flow_step_items.begin_on_new_line%type        ,
    begin_on_new_field            wwv_flow_step_items.begin_on_new_field%type       ,
    colspan                       wwv_flow_step_items.colspan%type                  ,
    rowspan                       wwv_flow_step_items.rowspan%type                  ,
    grid_column                   wwv_flow_step_items.grid_column%type              ,
    grid_label_column_span        wwv_flow_step_items.grid_label_column_span%type   ,
    grid_column_css_classes       wwv_flow_step_items.grid_column_css_classes%type  ,
    --
    label_alignment               wwv_flow_step_items.label_alignment%type          ,
    display_when                  wwv_flow_step_items.display_when%type             ,
    display_when2                 wwv_flow_step_items.display_when2%type            ,
    display_when_type             wwv_flow_step_items.display_when_type%type        ,
    --
    warn_on_unsaved_changes       wwv_flow_step_items.warn_on_unsaved_changes%type  ,
    use_cache_before_def          wwv_flow_step_items.use_cache_before_default%type ,
    field_alignment               wwv_flow_step_items.field_alignment%type          ,
    security_scheme               wwv_flow_step_items.security_scheme%type          ,
    read_only_when                wwv_flow_step_items.read_only_when%type           ,
    read_only_when2               wwv_flow_step_items.read_only_when2%type          ,
    read_only_when_type           wwv_flow_step_items.read_only_when_type%type      ,
    read_only_disp_attr           wwv_flow_step_items.read_only_disp_attr%type      ,
    escape_on_http_input          wwv_flow_step_items.escape_on_http_input%type     ,
    escape_on_http_output         wwv_flow_step_items.escape_on_http_output%type    ,
    encrypted                     wwv_flow_step_items.encrypt_session_state_yn%type ,
    quick_pick_yn                 wwv_flow_step_items.show_quick_picks%type         ,
    inline_help_text              wwv_flow_step_items.inline_help_text%type         ,
    plugin_init_javascript_code   wwv_flow_step_items.plugin_init_javascript_code%type             ,
    attribute_01                  wwv_flow_step_items.attribute_01%type             ,
    attribute_02                  wwv_flow_step_items.attribute_02%type             ,
    attribute_03                  wwv_flow_step_items.attribute_03%type             ,
    attribute_04                  wwv_flow_step_items.attribute_04%type             ,
    attribute_05                  wwv_flow_step_items.attribute_05%type             ,
    attribute_06                  wwv_flow_step_items.attribute_06%type             ,
    attribute_07                  wwv_flow_step_items.attribute_07%type             ,
    attribute_08                  wwv_flow_step_items.attribute_08%type             ,
    attribute_09                  wwv_flow_step_items.attribute_09%type             ,
    attribute_10                  wwv_flow_step_items.attribute_10%type             ,
    attribute_11                  wwv_flow_step_items.attribute_11%type             ,
    attribute_12                  wwv_flow_step_items.attribute_12%type             ,
    attribute_13                  wwv_flow_step_items.attribute_13%type             ,
    attribute_14                  wwv_flow_step_items.attribute_14%type             ,
    attribute_15                  wwv_flow_step_items.attribute_15%type             ,
    --
    is_ok_to_display              boolean );
type t_items is table of t_item index by pls_integer;

g_items                       t_items;
g_item_type_features          wwv_flow_global.vc_map; -- indexed by item type name

--==============================================================================
-- branch info
--==============================================================================
type t_branch is record (
    id                          wwv_flow_step_branches.id%type                          ,
    branch_name                 wwv_flow_step_branches.branch_name%type                 ,
    branch_action               wwv_flow_step_branches.branch_action%type               ,
    branch_point                wwv_flow_step_branches.branch_point%type                ,
    branch_type                 wwv_flow_step_branches.branch_type%type                 ,
    branch_condition            wwv_flow_step_branches.branch_condition%type            ,
    branch_condition_text       wwv_flow_step_branches.branch_condition_text%type       ,
    branch_condition_type       wwv_flow_step_branches.branch_condition_type%type       ,
    branch_when_button_id       wwv_flow_step_branches.branch_when_button_id%type       ,
    save_state_before_branch_yn wwv_flow_step_branches.save_state_before_branch_yn%type ,
    security_scheme             wwv_flow_step_branches.security_scheme%type );
type t_branches is table of t_branch index by pls_integer;

g_branches                    t_branches;
g_branch_page_mode            varchar2(10);

--==============================================================================
-- process info
--==============================================================================
type t_process is record (
    id                           wwv_flow_step_processing.id%type                      ,
    process_sequence             wwv_flow_step_processing.process_sequence%type        ,
    process_name                 wwv_flow_step_processing.process_name%type            ,
    process_sql                  varchar2(32767)                                       ,
    process_point                wwv_flow_step_processing.process_point%type           ,
    region_id                    wwv_flow_step_processing.region_id%type               ,
    process_type                 wwv_flow_step_processing.process_type%type            ,
    process_component_name       varchar2(30)                                          , -- APEX_APPLICATION_PROCESSES or APEX_APPLICATION_PAGE_PROCESS
    process_error_message        wwv_flow_step_processing.process_error_message%type   ,
    error_display_location       wwv_flow_step_processing.error_display_location%type  ,
    process_success_message      wwv_flow_step_processing.process_success_message%type ,
    process_when                 wwv_flow_step_processing.process_when%type            ,
    process_when_type            wwv_flow_step_processing.process_when_type%type       ,
    process_when2                wwv_flow_step_processing.process_when2%type           ,
    process_when_button_id       wwv_flow_step_processing.process_when_button_id%type  ,
    security_scheme              wwv_flow_step_processing.security_scheme%type         ,
    only_for_changed_rows        wwv_flow_step_processing.only_for_changed_rows%type   ,
    exec_cond_for_each_row       wwv_flow_step_processing.exec_cond_for_each_row%type  ,
    process_is_stateful_y_n      wwv_flow_step_processing.process_is_stateful_y_n%type ,
    item_name                    wwv_flow_step_processing.item_name%type               ,
    --
    location                     wwv_flow_step_processing.location%type,
    remote_server_id             wwv_flow_step_processing.remote_server_id%type,
    web_src_module_id            wwv_flow_step_processing.web_src_module_id%type,
    web_src_operation_id         wwv_flow_step_processing.web_src_operation_id%type,
    --
    attribute_01                 wwv_flow_step_processing.attribute_01%type            ,
    attribute_02                 wwv_flow_step_processing.attribute_02%type            ,
    attribute_03                 wwv_flow_step_processing.attribute_03%type            ,
    attribute_04                 wwv_flow_step_processing.attribute_04%type            ,
    attribute_05                 wwv_flow_step_processing.attribute_05%type            ,
    attribute_06                 wwv_flow_step_processing.attribute_06%type            ,
    attribute_07                 wwv_flow_step_processing.attribute_07%type            ,
    attribute_08                 wwv_flow_step_processing.attribute_08%type            ,
    attribute_09                 wwv_flow_step_processing.attribute_09%type            ,
    attribute_10                 wwv_flow_step_processing.attribute_10%type            ,
    attribute_11                 wwv_flow_step_processing.attribute_11%type            ,
    attribute_12                 wwv_flow_step_processing.attribute_12%type            ,
    attribute_13                 wwv_flow_step_processing.attribute_13%type            ,
    attribute_14                 wwv_flow_step_processing.attribute_14%type            ,
    attribute_15                 wwv_flow_step_processing.attribute_15%type );
type t_processes is table of t_process index by pls_integer;

g_processes                   t_processes;

--==============================================================================
-- region (plug) info
--==============================================================================
subtype t_region_component_type_id is pls_integer range 1 .. 3;
c_region_component_item        constant t_region_component_type_id := 1;
c_region_component_button      constant t_region_component_type_id := 2;
c_region_component_region      constant t_region_component_type_id := 3;
type t_region_component is record (
    display_point                  varchar2(32767)            , -- e.g. 'BODY'
    display_sequence               number                     , -- e.g. wwv_flow_step_items.item_sequence
    component_id                   number                     , -- e.g. wwv_flow_step_items.id
    type_id                        t_region_component_type_id , -- a t_region_component
    idx                            pls_integer                  -- index of the component within the component array ,
);                                                              -- e.g. index of an item in g_items
type t_region_components is table of t_region_component index by pls_integer;

type t_plug is record (
    id                             wwv_flow_page_plugs.id%type                             ,
    page_id                        wwv_flow_page_plugs.page_id%type                        ,
    plug_name                      wwv_flow_page_plugs.plug_name%type                      ,
    parent_plug_id                 wwv_flow_page_plugs.parent_plug_id%type                 ,
    master_region_id               wwv_flow_page_plugs.master_region_id%type               ,
    master_region_static_id        varchar2(32767)                                         ,
    plug_template                  wwv_flow_page_plugs.plug_template%type                  ,
    plug_new_grid                  wwv_flow_page_plugs.plug_new_grid%type                  ,
    plug_new_grid_row              wwv_flow_page_plugs.plug_new_grid_row%type              ,
    plug_new_grid_column           wwv_flow_page_plugs.plug_new_grid_column%type           ,
    plug_display_column            wwv_flow_page_plugs.plug_display_column%type            ,
    plug_grid_column_span          wwv_flow_page_plugs.plug_grid_column_span%type          ,
    plug_grid_column_css_classes   wwv_flow_page_plugs.plug_grid_column_css_classes%type   ,
    plug_display_sequence          wwv_flow_page_plugs.plug_display_sequence%type          ,
    plug_display_point             wwv_flow_page_plugs.plug_display_point%type             ,
    plug_item_display_point        wwv_flow_page_plugs.plug_item_display_point%type        ,
    plug_source                    varchar2(32767)                                         ,
    plug_source_type               wwv_flow_page_plugs.plug_source_type%type               ,
    --
    plug_query_type                wwv_flow_page_plugs.query_type%type                     ,
    --
    source_location                wwv_flow_page_plugs.location%type                       ,
    remote_server_id               wwv_flow_page_plugs.remote_server_id%type               ,
    web_source_module_id           wwv_flow_page_plugs.web_src_module_id%type              ,
    --
    query_owner                    wwv_flow_page_plugs.query_owner%type                    ,
    query_table                    wwv_flow_page_plugs.query_table%type                    ,
    query_where                    wwv_flow_page_plugs.query_where%type                    ,
    query_order_by                 wwv_flow_page_plugs.query_order_by%type                 ,
    source_post_processing         wwv_flow_page_plugs.source_post_processing%type         ,
    include_rowid_column           wwv_flow_page_plugs.include_rowid_column%type           ,
    optimizer_hint                 wwv_flow_page_plugs.optimizer_hint%type                 ,
    --
    remote_sql_caching             wwv_flow_page_plugs.remote_sql_caching%type             , 
    remote_sql_invalidate_when     wwv_flow_page_plugs.remote_sql_invalidate_when%type     ,
    --
    external_filter_expr           wwv_flow_page_plugs.external_filter_expr%type           ,
    external_order_by_expr         wwv_flow_page_plugs.external_order_by_expr%type         ,
    --
    list_template_id               wwv_flow_page_plugs.list_template_id%type               ,
    list_id                        wwv_flow_page_plugs.list_id%type                        ,
    menu_id                        wwv_flow_page_plugs.menu_id%type                        ,
    --
    plug_header                    wwv_flow_page_plugs.plug_header%type                    ,
    plug_footer                    wwv_flow_page_plugs.plug_footer%type                    ,
    --
    plug_required_role             wwv_flow_page_plugs.plug_required_role%type             ,
    plug_display_when_condition    wwv_flow_page_plugs.plug_display_when_condition%type    ,
    plug_display_when_cond2        wwv_flow_page_plugs.plug_display_when_cond2%type        ,
    plug_display_condition_type    wwv_flow_page_plugs.plug_display_condition_type%type    ,
    plug_column_width              wwv_flow_page_plugs.plug_column_width%type              ,
    plug_customized                wwv_flow_page_plugs.plug_customized%type                ,
    plug_query_no_data_found       wwv_flow_page_plugs.plug_query_no_data_found%type       ,
    plug_query_more_data           wwv_flow_page_plugs.plug_query_more_data%type           ,
    plug_query_parse_override      wwv_flow_page_plugs.plug_query_parse_override%type      ,
    plug_query_num_rows            wwv_flow_page_plugs.plug_query_num_rows%type            ,
    plug_query_num_rows_item       wwv_flow_page_plugs.plug_query_num_rows_item%type       ,
    plug_query_headings_type       wwv_flow_page_plugs.plug_query_headings_type%type       ,
    plug_query_headings            wwv_flow_page_plugs.plug_query_headings%type            ,
    ajax_items_to_submit           wwv_flow_page_plugs.ajax_items_to_submit%type           ,
    escape_on_http_output          wwv_flow_page_plugs.escape_on_http_output%type          ,
    plug_caching                   wwv_flow_page_plugs.plug_caching%type                   ,
    plug_cache_when                wwv_flow_page_plugs.plug_cache_when%type                ,
    plug_cache_expression1         wwv_flow_page_plugs.plug_cache_expression1%type         ,
    plug_cache_expression2         wwv_flow_page_plugs.plug_cache_expression2%type         ,
    plug_cache_depends_on_items    wwv_flow_page_plugs.plug_cache_depends_on_items%type    ,
    plug_static_id                 varchar2(32767)                                         ,
    region_css_classes             wwv_flow_page_plugs.region_css_classes%type             ,
    icon_css_classes               wwv_flow_page_plugs.icon_css_classes%type               ,
    region_sub_css_classes         wwv_flow_page_plugs.region_sub_css_classes%type         ,
    region_template_options        wwv_flow_page_plugs.region_template_options%type        ,
    component_template_options     wwv_flow_page_plugs.component_template_options%type     ,
    region_attributes_substitution wwv_flow_page_plugs.region_attributes_substitution%type ,
    region_image                   wwv_flow_page_plugs.region_image%type                   ,
    region_image_attr              wwv_flow_page_plugs.region_image_attr%type              ,
    plug_read_only_when_type       wwv_flow_page_plugs.plug_read_only_when_type%type       ,
    plug_read_only_when            wwv_flow_page_plugs.plug_read_only_when%type            ,
    plug_read_only_when2           wwv_flow_page_plugs.plug_read_only_when2%type           ,
    --
    plugin_init_javascript_code    wwv_flow_page_plugs.plugin_init_javascript_code%type    ,
    --
    region_template_css_file_urls  wwv_flow_page_plug_templates.css_file_urls%type         ,
    region_template_inline_css     wwv_flow_list_templates.inline_css%type                 ,
    --
    attribute_01                   wwv_flow_page_plugs.attribute_01%type                   ,
    attribute_02                   wwv_flow_page_plugs.attribute_02%type                   ,
    attribute_03                   wwv_flow_page_plugs.attribute_03%type                   ,
    attribute_04                   wwv_flow_page_plugs.attribute_04%type                   ,
    attribute_05                   wwv_flow_page_plugs.attribute_05%type                   ,
    attribute_06                   wwv_flow_page_plugs.attribute_06%type                   ,
    attribute_07                   wwv_flow_page_plugs.attribute_07%type                   ,
    attribute_08                   wwv_flow_page_plugs.attribute_08%type                   ,
    attribute_09                   wwv_flow_page_plugs.attribute_09%type                   ,
    attribute_10                   wwv_flow_page_plugs.attribute_10%type                   ,
    attribute_11                   wwv_flow_page_plugs.attribute_11%type                   ,
    attribute_12                   wwv_flow_page_plugs.attribute_12%type                   ,
    attribute_13                   wwv_flow_page_plugs.attribute_13%type                   ,
    attribute_14                   wwv_flow_page_plugs.attribute_14%type                   ,
    attribute_15                   wwv_flow_page_plugs.attribute_15%type                   ,
    attribute_16                   wwv_flow_page_plugs.attribute_16%type                   ,
    attribute_17                   wwv_flow_page_plugs.attribute_17%type                   ,
    attribute_18                   wwv_flow_page_plugs.attribute_18%type                   ,
    attribute_19                   wwv_flow_page_plugs.attribute_19%type                   ,
    attribute_20                   wwv_flow_page_plugs.attribute_20%type                   ,
    attribute_21                   wwv_flow_page_plugs.attribute_21%type                   ,
    attribute_22                   wwv_flow_page_plugs.attribute_22%type                   ,
    attribute_23                   wwv_flow_page_plugs.attribute_23%type                   ,
    attribute_24                   wwv_flow_page_plugs.attribute_24%type                   ,
    attribute_25                   wwv_flow_page_plugs.attribute_25%type                   ,
    --
    -- attributes that are not directly set via base table fields, but
    -- populated some time during page processing
    --
    is_read_only                   boolean                                                 , -- result of read only computation
    is_ok_to_display               boolean                                                 , -- result of conditional display computation
    save_in_cache                  boolean                                                 , -- should the render result be saved in the cache?
    protected_items_in_region      pls_integer                                             , -- number of protected items that have been rendered in this region
    idx                            pls_integer                                             , -- index in g_plugs
    parent_idx                     pls_integer                                             , -- index of parent region in g_plugs
    --
    components                     t_region_components );
type t_plugs is table of t_plug index by pls_integer;

g_plugs                       t_plugs;
g_page_components             t_region_components;
g_plug_position               varchar2(32767);

--==============================================================================
-- computation info
--==============================================================================
type t_computation is record (
    id                          wwv_flow_step_computations.id%type                    ,
    computation_sequence        wwv_flow_step_computations.computation_sequence%type  ,
    computation_item            wwv_flow_step_computations.computation_item%type      ,
    computation_point           wwv_flow_step_computations.computation_point%type     ,
    computation_type            wwv_flow_step_computations.computation_type%type      ,
    computation_component_type  varchar2(30)                                          ,
    computation_processed       wwv_flow_step_computations.computation_processed%type ,
    computation                 wwv_flow_step_computations.computation%type           ,
    compute_when                wwv_flow_step_computations.compute_when%type          ,
    compute_when_text           wwv_flow_step_computations.compute_when_text%type     ,
    compute_when_type           wwv_flow_step_computations.compute_when_type%type     ,
    security_scheme             wwv_flow_step_computations.security_scheme%type );
type t_computations is table of t_computation index by pls_integer;

g_computations                t_computations;

-----------------
-- Fetch Counters
--
g_flowCnt                      pls_integer := 0;      -- flow info found, 1 = yes, 0 = no
g_iconbarCnt                   pls_integer := 0;      -- nav bar icon count
g_tabCnt                       pls_integer := 0;      -- standard tab count
g_branchCnt                    pls_integer;           -- branch count
g_computationCnt               pls_integer;           -- computations count
g_list_mgr_cnt                 pls_integer := 0;      --

--==============================================================================
-- flow level fetch
--==============================================================================
function  fetch_flow_info
    return number;
--==============================================================================
function  fetch_icon_bar_info
    return number;

--==============================================================================
function  fetch_flow_record (
    p_security_group_id in number default wwv_flow_security.g_curr_flow_security_group_id,
    p_application_id    in number )
    return t_flows;

--==============================================================================
-- page level fetch
-- raises APEX.PAGE.NOT_FOUND if page can not be found
--==============================================================================
procedure  fetch_step_info;

--==============================================================================
function  fetch_tab_info
    return number;
--==============================================================================
function  fetch_toplevel_tab_info (p_tabset in varchar2)
    return number;

--==============================================================================
function fetch_branch_info
    return number;

--==============================================================================
procedure fetch_process_info (
    p_in_accept in boolean );

--==============================================================================
function fetch_g_build_options_included
    return varchar2;
--==============================================================================
function fetch_g_build_options_excluded
    return varchar2;
--==============================================================================
function  fetch_computations
    return number;

--==============================================================================
procedure fetch_item_type_settings;
--==============================================================================
-- fetch regions and optionally also items and buttons into the wwv_flow.g_NNN
-- tables.
--
-- ARGUMENTS
-- * p_include_subcomponents if true (wwv_flow.show), also fetch items and buttons
--==============================================================================
procedure  fetch_page_plugs (
    p_include_subcomponents in boolean );

--==============================================================================
-- for a region, item or button, get it's index in the wwv_flow.g_NNN tables
-- (e.g. g_plugs).
--==============================================================================
function get_component_index (
    p_type_id      in t_region_component_type_id,
    p_component_id in number )
    return pls_integer;

--==============================================================================
-- return item properties
--
-- t_item_properties.id is the ID of the ITEM (p_name) or 0 for items that begin
-- with IR and are not an existing item name or -1 if the item is contained in
-- the component value array
--
-- ARGUMENTS
-- * p_name                 the item name
-- * p_application_id       the application
-- * p_error_when_not_found if true (default), raise internal error if the item
--                          can not be found. if false, return an empty record.
--==============================================================================
function find_item_by_name (
    p_name                  in  varchar2,
    p_application_id        in  number default wwv_flow_security.g_flow_id,
    p_error_when_not_found  in  boolean default true )
    return t_item_properties;

--==============================================================================
-- return item properties
--
-- t_item_properties.id is the ID of the ITEM (p_name) or 0 for items that begin
-- with IR and are not an existing item name or -1 if the item is contained in
-- the component value array
--
--==============================================================================
function find_item_by_id (
    p_id in number,
    p_security_group_id in number default wwv_flow_security.g_curr_flow_security_group_id )
    return t_item_properties;

--==============================================================================
-- replace application-level substitution variables in p_str
--==============================================================================
procedure do_static_substitutions (
    p_str in out nocopy varchar2 );
--
--==============================================================================
-- look up application-level substitution variable p_name. if found, return true
-- and the variable's value in p_value
--==============================================================================
function find_static_substitution (
    p_name  in varchar2,
    p_value in out nocopy varchar2 )
    return boolean;

end wwv_flow_meta_data;
/
show errors
