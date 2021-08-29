set define off verify off
prompt ...wwv_flow
create or replace package wwv_flow as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      flow.sql
--
--    DESCRIPTION
--      Application Express rendering engine package specification.
--
--    SECURITY
--      Publicly executable.
--
--    NOTES
--      This program shows and accepts application express pages.
--      The application express engine is also known as the flows engine.
--      Frequently called from the procedure f.
--
--    RUNTIME DEPLOYMENT: YES
--
--
--    MODIFIED   (MM/DD/YYYY)
--      mhichwa   08/04/1999 - Created
--      mhichwa   09/30/1999 - Removed g_show_reset global
--      mhichwa   10/09/1999 - Added g_last_query_text global for error reporting
--      mhichwa   10/09/1999 - Removed g_success_procedure, g_success_url
--      mhichwa   10/09/1999 - Removed g_step_sub_title_font_color
--      mhichwa   10/14/1999 - Added 10 extra inputs v26 ... v35
--      mhichwa   10/21/1999 - Added t01..t35 to allow 32k for textareas
--      mhichwa   10/21/1999 - Moved g_flow_schema_owner to spec from body
--      mhichwa   10/23/1999 - Added flow_language and flow_image_prefix
--      mhichwa   10/26/1999 - Added pagination globals flow_current_min_row, max_row, rows_fetched
--      mhichwa   11/08/1999 - Added g_current_tab, and g_non_current_tab, g_box, g_navigation_bar
--      mhichwa   11/23/1999 - Added g_tab_non_current_image, g_tab_image_attributes
--      mhichwa   11/30/1999 - Added g_template_success_message
--      mhichwa   11/30/1999 - Changed paint_buttons from a procedure to a function
--      mhichwa   12/01/1999 - Added g_body_title variable, g_current_image_tab, g_non_current_image_tab
--      mhichwa   12/06/1999 - Added g_message, attribute1,2,3,4
--      mhichwa   12/09/1999 - Added g_top level tab attributes and g_tab_target
--      mhichwa   12/13/1999 - Changed g_message to g_notification_message, added g_notification
--      mhichwa   12/13/1999 - Added g_default_button_position
--      mhichwa   12/15/1999 - Added display_condition to toplevel_tab: g_tab_parent_display_cond
--      mhichwa   12/19/1999 - Added g_before_header_branch_occured global
--      mhichwa   12/19/1999 - Added g_tab_also_current_for_pages global
--      mhichwa   01/08/2000 - Added g_translated_flow_id and g_translated_page_id
--      mhichwa   01/09/2000 - Depricated initial_occurs and max_occurances
--      mhichwa   01/12/2000 - Added page plug globals
--      mhichwa   01/20/2000 - Added g_error_template, g_user, g_authentication, g_login_url
--      mhichwa   01/21/2000 - Added g_session_cookie
--      mhichwa   01/21/2000 - Depricated g_session_last_changed_set
--      mhichwa   01/23/2000 - Added logout_url
--      mhichwa   01/24/2000 - Added g_public_url_prefix
--      mhichwa   01/24/2000 - Added an extra 5 input arguments making total of 40
--      mhichwa   01/25/2000 - Added 10 more input arguments
--      mhichwa   01/26/2000 - Externalized paint_formOpen, find_value_for functions and g_ok_to_cache_sql variable
--      mhichwa   01/26/2000 - Added g_item_plug_id, g_plug_id and g_button_plug_id
--      mhichwa   01/31/2000 - Added g_heading_bgcolor,g_font_size,g_font_face,g_table_bgcolor,tattr
--      mhichwa   01/31/2000 - Added g_plug_heading_bgcolor,table_bgcolor,font_size,header,footer
--      mhichwa   02/02/2000 - Change g_box from varchar2(4000) to varchar2(32767)
--      mhichwa   02/20/2000 - Added g_cookie_session_id global
--      mhichwa   02/21/2000 - Added g_popup_filter global
--      mhichwa   02/23/2000 - Added g_page_document_1 global
--      mhichwa   03/02/2000 - Added g_tab_plsql_condtion global
--      mhichwa   03/04/2000 - Renamed draw_box_open, close to draw_body_open, close
--      mhichwa   03/08/2000 - Added g_flow_version
--      mhichwa   03/09/2000 - Added g_user_known_as
--      mhichwa   03/16/2000 - Added button_redirect_url
--      mhichwa   03/22/2000 - Added p_perform_oracle_substitutions
--      mhichwa   04/26/2000 - Added g_page_text_generated
--      mhichwa   05/03/2000 - Added f01 - f10
--      mhichwa   05/07/2000 - Moved f01 before p_t41 (allows f01 to be 98 arg, not 108 arg)
--      mhichwa   05/08/2000 - Reversed above
--      mhichwa   05/08/2000 - Add g_subscriber_id
--      mhichwa   05/16/2000 - Added g_process_when_button_id
--      mhichwa   05/22/2000 - Added g_icon_onclick
--      mhichwa   05/23/2000 - Removed drop package
--      mhichwa   05/24/2000 - obsoleted g_icon_bar_ and g_page_document_1 added comments, reordered fields
--      mhichwa   05/26/2000 - Added wwv_flow.g_rownum per thoechst request
--      mhichwa   05/30/2000 - Added g_dbauth_url_prefix, g_proxy_server
--      mhichwa   05/30/2000 - Added update_cache_with_write
--      mhichwa   06/02/2000 - Added g_step_first_item
--      mhichwa   06/03/2000 - Added lov_null_text null_value
--      mhichwa   06/09/2000 - Added g_item_lov_translated
--      mhichwa   06/11/2000 - Added g_plug_display_when_cond_type g_public_user
--      mhichwa   06/12/2000 - Added g_current_user
--      mhichwa   06/13/2000 - Added g_item_display_when_type
--      mhichwa   06/15/2000 - Added g_tab_parent_display_cond_ty g_tab_plsql_condition_type
--      mhichwa   06/18/2000 - Added g_process_type
--      mhichwa   06/18/2000 - Added g_branch_when_button_id
--      mhichwa   07/03/2000 - Added g_plug_column_width
--      mhichwa   07/10/2000 - Added g_region_table_cattributes
--      mhichwa   08/16/2000 - Added g_item_source_post_computation
--      mhichwa   08/19/2000 - Extended help procedure
--      mhichwa   08/21/2000 - Added additional help procedure arguments.
--      mhichwa   09/03/2000 - Changed formatting of page help text.
--      mhichwa   09/19/2000 - Added g_flow_status
--      mhichwa   10/25/2000 - Added p 51 ... 60
--      mhichwa   10/30/2000 - Added page cache update alt api
--      mhichwa   10/30/2000 - Added fetch_item
--      mhichwa   11/09/2000 - Added p_trace
--      mhichwa   11/21/2000 - Added g_computation_id
--      mhichwa   12/07/2000 - Added g_vpd
--      mhichwa   12/15/2000 - Added g_tab_disp_cond_text and g_compute_when_text
--      mhichwa   12/18/2000 - Removed g_subscriber_id and g_session_created_*
--      mhichwa   12/20/2000 - Removed g_item_javascript and added g_item_security_scheme
--      mhichwa   12/20/2000 - Added p_component argument to public role check function
--      mhichwa   12/20/2000 - Added g_button_security_scheme, g_icon_security_scheme, g_tab_security_scheme
--      mhichwa   12/20/2000 - Added g_tab_security_scheme
--      mhichwa   12/22/2000 - Added g_security_scheme for flow level security schemes
--      mhichwa   12/22/2000 - Added reset security check cache
--      mhichwa   01/05/2001 - Added public security check
--      mhichwa   01/12/2001 - Added g item tag_attributes
--      mhichwa   01/16/2001 - Added g application_tab set
--      mhichwa   01/17/2001 - Added f11 - f20
--      mhichwa   01/27/2001 - Return company name function
--      mhichwa   02/11/2001 - Added two functions to get sequence and unique ids
--      mhichwa   02/14/2001 - Added sdillon code to insert into temp table values from strings
--      mhichwa   03/01/2001 - Added g button alignment
--      sdillon   03/02/2001 - Added g_job for jobs which are submitted to wwv_flow_job
--      mhichwa   03/03/2001 - Removed references to carot 3, added comments
--      mhichwa   03/03/2001 - Added public syn
--      mhichwa   03/04/2001 - Added get_custom_auth_login_url
--      mhichwa   03/15/2001 - Added no data found global
--      mhichwa   03/21/2001 - Added g user id
--      mhichwa   04/09/2001 - Added p company to show and accept procedures
--      mhichwa   04/10/2001 - Added button c attributes
--      mhichwa   04/17/2001 - Added total row global to enhance pagination
--      mhichwa   04/23/2001 - Added rejoin sessions variable
--      mhichwa   05/14/2001 - Removed g item accept processing global var
--      mhichwa   06/01/2001 - Added checksum function and md5 checksum show and accept arguments
--      mhichwa   06/04/2001 - Added assignment of md5 checksum to flow global.
--      mhichwa   06/04/2001 - Added get_sgid function to return sec grp id for use in views on obj dollar table
--      mhichwa   06/18/2001 - Added g item default type
--      mhichwa   06/18/2001 - Added api to clear user session state (clear user cache)
--      mhichwa   06/18/2001 - Improved documentation
--      mhichwa   07/20/2001 - Added g_flow_language_derived_from
--      mhichwa   08/13/2001 - Added x 01 through x 20 as input items that are to be ignored.  For use with local javascript.
--      mhichwa   08/23/2001 - Added global notification
--      mhichwa   08/24/2001 - Added a global for g_last_tab_pressed
--      mhichwa   08/27/2001 - Added last tab pressed argument to show procedure
--      mhichwa   08/27/2001 - Extended documentation of flows procedure
--      mhichwa   10/02/2001 - Edited comments for show procedure
--      mhichwa   10/15/2001 - Added flow checksum fcs accept argument
--      mhichwa   10/19/2001 - Added header and footer template globals
--      mhichwa   10/24/2001 - Added process when 2 and process when 2 type to extend declarative prog on page processes
--      mhichwa   11/08/2001 - Added g_error_message_override
--      mhichwa   11/12/2001 - Added g_head (wwv_flow_steps.html_page_header)
--      mhichwa   12/10/2001 - Added set_g_nls_date_format
--      mhichwa   12/12/2001 - Added g_process_security_scheme
--      mhichwa   12/17/2001 - Added g_flow_charset
--      mhichwa   12/18/2001 - Added g_branch_security_scheme
--      mhichwa   12/19/2001 - Added g_current_parent_tab_text
--      mhichwa   02/11/2002 - Added 2 stateful process procedures and one function (sspadafore design)
--      mhichwa   02/13/2002 - Added validation global (g_validation_ids_in_error)
--      mhichwa   02/14/2002 - Added another validation global (g_inline_validation_error_cnt)
--      mhichwa   02/14/2002 - Added tag_attributes2
--      mhichwa   02/19/2002 - Added post element text
--      mhichwa   03/05/2002 - Added process_sql_clob
--      sspadafo  03/18/2002 - Added fetch_flow_item function
--      mhichwa   03/18/2002 - Added g_page_submitted global variable
--      jkallman  03/28/2002 - Added definition of vc_long_arr
--      mhichwa   04/04/2002 - Removed obsolete icon bar attributes
--      mhichwa   04/17/2002 - Fixed inline notifications of type function returning err text by adding addtional global
--      mhichwa   05/01/2002 - Added lov_display_extra g_item_lov_display_extra support
--      mhichwa   05/07/2002 - Maded look static 1, and obsolete
--      mhichwa   05/08/2002 - Added 5 more arguments (now 65 are supported)
--      mhichwa   05/08/2002 - Added button condition 2
--      mhichwa   05/09/2002 - Added g_tab_parent_display_cond2
--      mhichwa   05/09/2002 - Added g_item_display_when2
--      mhichwa   05/09/2002 - Added g_company_images and g_flow_images
--      mhichwa   05/09/2002 - Added g_shortcut_name and g_shortcut_id
--      mhichwa   05/10/2002 - Remove obsolete globals
--      mhichwa   06/05/2002 - Added p_survey_map and g_survey_map
--      sspadafo  06/22/2002 - Added g_list_mgr_cnt global
--      cbcho     07/01/2002 - Added g_footer_len, g_footer_end, g_end_tag_printed global variables
--      mhichwa   07/08/2002 - Added g_f21..g_f40 and g_plug_form_tab_attr
--      sspadafo  07/10/2002 - Added clear_flow_cache, clear_page_cache, clear_page_caches procedures
--      mhichwa   08/08/2002 - Added g_flow_alias
--      mhichwa   08/09/2002 - Added plug_query_more_data
--      mhichwa   08/11/2002 - Added exact_substitutions_only
--      mhichwa   09/24/2002 - Added plug_customized
--      mhichwa   09/25/2002 - Added g_item_cattributes_element
--      msewtz    09/26/2002 - Added g_fsp_region_id for multiple region sorting
--      mhichwa   09/30/2002 - Added g_page_onload
--      mhichwa   10/07/2002 - Increased input args from 65 to 100.
--      mhichwa   10/25/2002 - Added g_item_read_only_when g_item_read_only_when_type g_item_read_only_disp_attr
--      mhichwa   10/25/2002 - Removed support for application tabs
--      mhichwa   10/29/2002 - Added g_unique_page_id
--      mhichwa   10/29/2002 - Changed some numbers into pls_integers
--      msewtz    10/31/2002 - Added g_plug_position to indicate top and bottom position for button conditions
--      tmuth     11/01/2002 - Removed reference to ^3, now using select user... technique
--      mhichwa   11/08/2002 - Changed comments
--      jkallman  11/21/2002 - Added g_nls_decimal_separator, set_g_nls_decimal_separator
--      mhichwa   11/21/2002 - Added map1 map2 and map3
--      mhichwa   11/25/2002 - Changed map1 to an array
--      mhichwa   11/25/2002 - Added map2 and map3 array
--      msewtz    12/04/2002 - Added constant g_browser_version and function get_browser_version
--      jkallman  12/27/2002 - Removed end_page_processing
--      sspadafo  12/27/2002 - Added g_db_session_branch_targets for before header branching (Bug 2729768)
--      sspadafo  12/28/2002 - Added g_branch_to_page_accept_count for recursion limiting (Bug 2729767)
--      sspadafo  01/06/2003 - Expose function replace_cgi_env (bug 2737645)
--      mhichwa   01/27/2003 - Added g_process_item_name (bug 2769756)
--      sspadafo  02/07/2003 - Added g_in_process boolean to prevent show from being called from page process (Bug 2776207)
--      sspadafo  02/23/2003 - Changes for template column name changes from varchar2 to number (Bug 2748399)
--      msewtz    02/26/2004 - Added g_pagination_buttons_painted to determine whether or not pagination buttons are painted (bug 2823270)
--      jstraub   03/10/2003 - Replaced select user with select sys_context( 'userenv', 'current_schema') for FLOW_OWNER
--      mhichwa   03/11/2003 - Added global g_edit_cookie_session_id which replace body local var (bug 2845535)
--      mhichwa   03/14/2003 - Added global g_form_painted boolean (bug 2851819)
--      mhichwa   03/18/2003 - Added comments to globals, no bug filed
--      mhichwa   03/18/2003 - Added pk array values for use in inline edits (bug 2845535)
--      mhichwa   03/30/2003 - Added g_print_success_message
--      jkallman  04/08/2003 - Added reset_g_nls_decimal_separator (Bug 2894573)
--      sspadafo  04/26/2003 - Removed refs to g_computation_item_type for page and flow computations (Bug 2770974)
--      mhichwa   05/02/2003 - Improved 508 compliance, added g_nls_edit, bug 2772858
--      mhichwa   05/22/2003 - Added returning globals to enhanced dml support, bug 2965281
--      mhichwa   05/22/2003 - Added process globals to identify items to return keys to, bug 2965281
--      tmuth     07/09/2003 - Fixed HTML per bug 3040191
--      sspadafo  07/12/2003 - Increase size of g_footer_end (Bug 3044360)
--      sspadafo  07/30/2003 - Add clear_app_cache as equivalent of clear_flow_cache (Bug 3077346)
--      sspadafo  07/30/2003 - Add fetch_app_item as equivalent of fetch_flow_item (Bug 3077346)
--      sspadafo  08/23/2003 - Add g_build_status (Bug 3101165)
--      msewtz    02/04/2003 - Added Tablar From Globals for handling popup items in tabular forms (bug 3268062)
--      mhichwa   05/26/2004 - Added g_template_navbar_entry global.
--      jkallman  05/25/2004 - Remove references to ^FLOW_OWNER
--      sspadafo  06/09/2004 - Add save_in_substitution_cache procedure, remove update_cache procedure (Bug 3674771)
--      sspadafo  06/09/2004 - Remove find_value_for function (Bug 3677443)
--      mhichwa   06/14/2004 - Added g_flow_theme_id global
--      mhichwa   06/17/2004 - Added function get_translated_app_id return number function
--      jkallman  06/18/2004 - Added get_nls_group_separator
--      jkallman  07/14/2004 - Added reset_g_nls_date_format
--      mhichwa   08/02/2004 - Added g_logo_image and g_logo_image_attributes
--      mhichwa   08/02/2004 - Added g_plug_list_template_id
--      jkallman  08/16/2004 - Added g_base_href, set_base_href, reset_base_href, get_base_href
--      mhichwa   09/15/2004 - Removed obsolete wwv_flow.g_step_box_image, bug 3892054
--      mhichwa   09/15/2004 - Remove obsolete substitutions g_attribute 1 - 6, bug 3892054
--      mhichwa   09/15/2004 - Remove obsolete substitution g_look, bug 3892054
--      mhichwa   09/15/2004 - Remove static link substitutions, bug 3892054
--      jkallman  01/05/2004 - Adjust g_flow_schema_owner
--      sspadafo  01/31/2005 - Increase g_logout_url to vc4000 (Bug 4155342)
--      sspadafo  02/08/2005 - Added globals for URL tampering feature
--      sspadafo  02/21/2005 - Added g_protected_item_internal_flag
--      sspadafo  03/08/2005 - Added g_substitution_item_filter and g_item_escape_on_http_input arrays
--      jkallman  09/14/2005 - Adjust g_flow_schema_owner to FLOWS_020100
--      jkallman  01/23/2006 - Adjust g_flow_schema_owner to FLOWS_020200
--      sspadafo  03/07/2006 - Added g_ex_context_authentication boolean (inspired by Bug 5028808)
--      mhichwa   03/17/2006 - Added g_arg_name and g_arg_value to optimize mod plsql performance
--      mhichwa   03/20/2006 - Improved commments
--      mhichwa   03/22/2006 - Improved xhtml
--      mhichwa   04/10/2006 - Removed obsolete function convert_display_id_to_flow_id
--      sspadafo  04/22/2006 - Added g_use_zero_sid for zero session ID feature
--      sspadafo  04/23/2006 - Added g_public_page_ids, g_public_auth_scheme for zero session ID feature
--      mhichwa   06/01/2006 - Added g_sqlerrm global to log errors encountered during execution of applications
--      mhichwa   06/02/2006 - Inititialize g_sqlerrm
--      mhichwa   06/05/2006 - Removed obsolete and commented out code
--      mhichwa   06/06/2006 - Added globals for error component name and type
--      mhichwa   06/09/2006 - Added g_cache page global to support page caching wwv_flow_steps.cache_page_yn
--      mhichwa   06/09/2006 - Added get_page_alias function for use in determining if you are a login page
--      mhichwa   06/09/2006 - Added is_custom_auth_page function
--      mhichwa   06/11/2006 - Added g_cache_mode global so cache mode can be logged to activity log
--      mhichwa   06/14/2006 - Improved code comments
--      sspadafo  06/22/2006 - Changed g_flow_schema_owner to constant to prevent alteration
--      jkallman  09/29/2006 - Adjust g_flow_schema_owner to FLOWS_030000
--      jstraub   12/13/2006 - Added g_wallet_path and g_wallet_pwd for SSL (HTTPS) support
--      mhichwa   12/21/2006 - Added g_plug_caching global to support page caching, referenced from meta.plb
--      mhichwa   12/21/2006 - Added g_cached_regions global
--      mhichwa   01/02/2006 - Added g_item_pre_element_text
--      mhichwa   01/02/2006 - Added g_cached_region_count global to track the number of regions rendered from cached representations
--      mhichwa   01/03/2006 - Added g_remote_addr
--      jstraub   01/03/2006 - Removed wallet globals, moved to platform preference
--      rvallam   01/08/2007 - Added a new global g_is_item_shuttle for checking if display_as is shuttle
--      rvallam   01/08/2007 - Global added for shuttle - g_is_item_shuttle removed, not needed.
--      jkallman  01/26/2007 - Added g_item_format_mask
--      mhichwa   01/30/2007 - Added support for region static id
--      sspadafo  07/31/2007 - Added f01..f20 parameters to show procedure
--      cbcho     08/02/2007 - Adjust g_flow_schema_owner to flows_030100
--      sspadafo  08/07/2007 - Added new globals g_widget_name, g_x01..g_x10, g_clob_01; added input params to show: p_widget_name, x01..x10, p_clob_01 for AJAX requests
--      cbackstr  09/25/2007 - Changed show to include p_widget_mod,p_widget_action,p_widget_action_mod and map to g_widget_mod,g_widget_action,g_widget_action_mod
--      cbackstr  10/09/2007 - Changed show to include g_widget_num_return
--      jkallman  10/15/2007 - Added globals g_media_type and g_step_media_type
--      jkallman  11/19/2007 - Added global g_date_format
--      mhichwa   11/26/2007 - Added g_include_apex_css_js_yn
--      mhichwa   11/29/2007 - Added g_proc_runtime_where_clause
--      sspadafo  12/03/2007 - Removed g_protected_item_ids, g_protected_item_internal_flag
--      mhichwa   12/10/2007 - Removed g_step_box_footer_text global also changed meta.plb, gen_api_pkg.plb and flow.plb
--      mhichwa   12/10/2007 - Removed g_box_width global
--      mhichwa   12/13/2007 - Added g_plug_att_sub
--      sspadafo  01/21/2008 - Changed type of g_unique_page_id from pls_integer to number to accommodate IDs larger than 2**31-1
--      sspadafo  01/23/2008 - Added overloaded version of trim_sql (Bug 6754391)
--      mhichwa   01/25/2008 - Added exec count global
--      jkallman  02/26/2008 - Removed fetch_item and fetch_value from specification
--      sspadafo  04/03/2008 - Added p_ignore_01..p_ignore_10 parameters to accept (Bug 6912467)
--      jkallman  07/08/2008 - Changed FLOWS_030100 references to FLOWS_040000
--      jkallman  07/31/2008 - Added procedures emit_javascript, add_javascript and g_javascript variable
--      jkallman  08/01/2008 - Added types codeEntry, codeType, global var g_code and procedures add_code and emit_code
--      cbackstr  08/05/2008 - made paint_trailing_javascript callable so it can be used in other packages.
--      mhichwa   09/11/2008 - Added g_http_head_attr global to facilitate apex listner
--      mhichwa   09/12/2008 - Added function get_application_id and get_page_id to optimize views that need to return current app and pg
--      mhichwa   09/12/2008 - Added function get_session_id and function get_security_group_id
--      jkallman  10/02/2008 - Changed FLOWS_040000 references to APEX_040000
--      mhichwa   10/10/2008 - Added g_item_quick_pick_yn
--      mhichwa   11/1/2008  - Added g_application_info
--      sspadafo  12/05/2008 - Added session timeout globals
--      jkallman  12/17/1008 - Change default valut of p_before_region_html in procedure help()
--      jkallman  12/18/2008 - Added vc_assoc_arr, g_deferred_session_val_ids and g_deferred_session_values in support of Bug xxxx
--      sspadafo  12/22/2008 - Changed name of timeout vars to reflect units in seconds
--      jstraub   12/23/2008 - Added g_autocomplete_on_off
--      mhichwa   12/23/2008 - Added g_substitution_item_encrypted to support session state encryption
--      sspadafo  12/31/2008 - Added g_item_encrypted to support session state encryption
--      sspadafo  12/31/2008 - Added g_substitution_item_value_enc, g_item_values_encrypted, g_fetch_encrypted to allow value encryption in URLs
--      sspadafo  01/06/2009 - Added g_disable_browser_caching
--      sspadafo  01/11/2009 - Added g_save_state_before_branch_yn array and g_save_state_before_branch scalar
--      sspadafo  02/04/2009 - Added g_column_values array to take the place of wwv_flow_dml.g_column_values
--      jkallman  02/11/2009 - Added g_dml_* variables from corresponding variables in wwv_flow_dml
--      pawolf    03/09/2009 - Moved wwv_flow.add_code/emit_code to wwv_flow_javascript
--      pawolf    03/13/2009 - Moved deprecated functions/procedures to the bottom of the file
--      pawolf    04/01/2009 - Added custom item types
--      pawolf    04/09/2009 - Added g_validation_displ_location
--      mhichwa   07/07/2009 - Added g_listener and p_listener to communicate with apex listner for actions such as xls parsing
--      sspadafo  07/08/2009 - Changed spelling of new accept parameter p_listner to p_listener
--      pawolf    07/09/2009 - Added add_validation_error
--      jkallman  07/28/2009 - Added globals g_timestamp_format, g_timestamp_tz_format, g_nls_timestamp_format, g_nls_timestamp_tz_format
--      jkallman  08/03/2009 - Added global g_localtimestamp
--      jkallman  08/04/2009 - Renamed global g_localtimestamp to g_systimestamp_gmt
--      pawolf    08/17/2009 - Added parent_plug_id for regions
--      arayner   08/21/2009 - Added globals g_button_show_wait and g_button_wait_message
--      jkallman  08/28/2009 - Add p_time_zone to show
--      jkallman  08/28/2009 - Added global g_auto_time_zone
--      jkallman  08/31/2009 - Added p_time_zone to accept
--      mhichwa   08/31/2009 - Added g_plug_image global to support region images
--      msewtz    09/16/2009 - Added fmap to accept to support mapping tabular form fxx arrays to report columns
--      pawolf    10/23/2009 - Added g_item_is_required
--      pawolf    10/28/2009 - Added g_default_error_display_loc
--      mhichwa   11/05/2009 - Added g_plug_image_attr
--      mhichwa   11/18/2009 - Added  g_icon_is_feedback
--      mhichwa   11/19/2009 - added p_lang to flow.show and accept
--      jstraub   12/10/2009 - Added convert_page_alias_to_id to spec
--      pawolf    12/14/2009 - Added new columns for javascript to wwv_flow_steps
--      msewtz    12/17/2009 - Updated tabular form validations to perform #COLUMN_HEADER# substituion on validation message and include row number
--      mhichwa   12/17/2009 - increased size of g_listener from 100 to 200
--      mhichwa   12/23/2009 - added g_current_region_id global, to allow general access to the current region ID
--      pawolf    12/29/2009 - Added g_item_standard_validations
--      msewtz    01/07/2010 - Added fhdr to accept to include tabular form column headers
--      msewtz    01/07/2010 - Update tabular form validation error messages to use fhdr arrays to substitute column headers
--      pawolf    01/20/2010 - Added escape_on_http_output to wwv_flow_step_items
--      arayner   01/20/2010 - Added g_widget_view_mode global and p_widget_view_mode parameter to show to handle new way of setting IRR view mode
--      pawolf    01/21/2010 - Added g_item_type_features
--      jkallman  01/29/2010 - Added function get_elapsed_time
--      pawolf    02/02/2010 - Added cascading lov columns to wwv_flow_step_items
--      pawolf    02/15/2010 - Added "Execute Validations" feature
--      pawolf    02/18/2010 - Removed LOV_COLUMNS
--      pawolf    02/20/2010 - Added support for process plugins
--      sspadafo  03/02/2010 - Moved g_in_accept boolean from package body (Bug 5765184)
--      jkallman  03/02/2010 - Added g_edition
--      pawolf    03/16/2010 - Removed g_list_managers
--      jkallman  03/18/2010 - Added g_plug_query_parse_override
--      pawolf    04/01/2010 - Changed p_listener to an array
--      cbcho     04/01/2010 - Added g_ws_app_id
--      msewtz    04/08/2010 - Added tabular form globals
--      pawolf    04/17/2010 - Renamed lov_items_to_submit and lov_optimize_refresh to ajax_item_to_submit and ajax_optimize_refresh
--      jkallman  04/22/2010 - Added p_territory to show and accept
--      arayner   04/23/2010 - Added g_item_plain_label global
--      arayner   04/23/2010 - Removed g_button_show_wait and g_button_wait_message globals
--      jkallman  05/18/2010 - Added g_workspace_delete_in_progress (Bug 9652683)
--      jkallman  11/22/2010 - Change APEX_040000 references to APEX_040100
--      pawolf    11/25/2010 - Removed not necessary global variables of branches (Bug 10197557)
--      pawolf    12/14/2010 - Added attribute_11 - attribute_15 to all tables supporting plug-ins (feature# 572)
--      pawolf    01/04/2011 - Added support for component specific values (feature# 542)
--      arayner   03/03/2011 - Added g_button_static_id global (feature #385)
--      arayner   03/03/2011 - Added g_button_html_id global (feature #385)
--      pawolf    03/08/2011 - Added new error display location column to wwv_flow_step_processing and wwv_flow_processing (feature# 544)
--      msewtz    03/10/2011 - Added g_mobile_mode to page template globals (feature 586)
--      arayner   03/16/2011 - Added g_button_action global and removed g_button_html_id global as this is not required (feature #385)
--      pawolf    02/28/2011 - Added new error handling (feature# 544)
--      pawolf    03/28/2011 - Removed g_plug_display_error_message (feature# 544)
--      pawolf    03/29/2011 - Enhanced procedure description of stop_apex_engine (feature# 639)
--      msewtz    03/30/2011 - Added g_item_before_item_text and g_item_after_item_text to allow for custom HTML when form not rendered as table (feature 586)
--      msewtz    03/30/2011 - Added g_render_form_items_in_table, used while rendering form items to determine whether to put them in table grid  (feature 586)
--      pawolf    04/07/2011 - Added p_fsp_region_id, p_pg_min_row, p_pg_max_rows and p_pg_rows_fetched to show procedure to allow AJAX calls with a "POST" (feature #505)
--      msewtz    04/08/2011 - Removed g_render_form_items_in_table, moved to region templates and region rendering (feature 586)
--      arayner   04/11/2011 - Added g_item_button_action and g_item_button_redirect_url globals (feature 380)
--      cneumuel  04/18/2011 - Made get_home_link_url public
--      pawolf    05/10/2011 - Added "is hot button" (feature 702)
--      jkallman  06/01/2011 - Added g_date_time_format (feature 715)
--      cneumuel  06/17/2011 - Replaced g_disable_browser_caching with g_browser_cache (feature #726)
--      cneumuel  06/17/2011 - Added support for vpd teardown code (feature #616)
--      cneumuel  06/20/2011 - Renamed variables for db session init/cleanup in wwv_flow (feature #616)
--      cneumuel  07/07/2011 - Added g_browser_frame (feature #731)
--      pawolf    08/05/2011 - Added compatibility_mode (bug# 12835127)
--      pawolf    11/30/2011 - Added trim_nl_sp_tab to public interface (bug# 13076709)
--      pawolf    01/24/2011 - Added p_arg_checksums and p_page_checksum to accept (bug 12790216)
--      pawolf    02/21/2012 - Changed APEX_040100 references to APEX_040200
--      pawolf    02/23/2012 - Changed accept to support up to 110 page items
--      pawolf    02/28/2012 - Added placeholder attribute for page items (feature# 837)
--      pawolf    03/02/2012 - Added css_classes for page items and buttons (feature# 815)
--      pawolf    03/05/2012 - Added css_classes for regions (feature# 815)
--      pawolf    03/06/2012 - Added content delivery network (feature# 819)
--      cneumuel  03/07/2012 - Changed type of g_content_delivery_network to varchar2(20) because of dependency problems during install
--      jkallman  03/15/2012 - Changed accept to support up to 200 page items
--      pawolf    03/19/2012 - Changed code to only use new columns in wwv_flow_user_interfaces instead of the old columns in wwv_flow (feature# 827)
--      pawolf    03/22/2012 - Removed get_current_flow_sgid, Renamed convert_flow_alias_to_id to get_application_id and moved convert_page_alias_to_id to wwv_flow_page
--      pawolf    04/05/2012 - Added support for page and popup transitions (feature #826)
--      cneumuel  04/10/2012 - Moved g_deferred_session_val_ids,g_deferred_session_values into wwv_flow_session_state (feature #897)
--      pawolf    04/10/2012 - Added read only on page and region level (feature# 570)
--      vuvarov   04/11/2012 - Added global for branch names (feature #872)
--      pawolf    04/12/2012 - Removed g_is_read_only and g_plug_is_read_only
--      jkallman  05/03/2012 - Added c_max_size_vc2
--      pawolf    05/03/2012 - Added javascript file urls, css file urls and inline css (feature #816 and #817)
--      arayner   05/04/2012 - Added procedure set_ppr_query_session_state, required by new classic report Ajax handling in wwv_render_report3 (feature #599)
--      pawolf    05/07/2012 - Added g_error_page_template
--      pawolf    05/08/2012 - Moved render code of page into wwv_flow_page
--      pawolf    05/08/2012 - Added new g_page_tmpl_* globals (feature# 816 and 817)
--      pawolf    05/11/2012 - Added Item Display Point (feature #278)
--      pawolf    05/14/2012 - Added grid templates (feature #936)
--      arayner   05/15/2012 - Added g_include_legacy_javascript (feature #927)
--      cneumuel  05/16/2012 - Added g_clob_column_values (bug #14079243)
--      pawolf    05/19/2012 - Added g_step_grid_template_id (feature #936)
--      pawolf    05/24/2012 - Moved grid template attributes into wwv_flow_templates and removed wwv_flow_grid_templates (feature #936)
--      cneumuel             - removed {set,get,clear}_component_values
--      pawolf    05/29/2012 - Changed c_current_compatibility_mode to 4.2
--      pawolf    06/01/2012 - Removed render_form_items_in_table
--      pawolf    06/05/2012 - Continued work on grid layout (feature #936)
--      cneumuel  06/14/2012 - Removed g_remote_addr
--      pawolf    06/15/2012 - Added has_edit_links to wwv_flow_templates
--      pawolf    06/18/2012 - Added APP_EMAIL substitution (feature# 695)
--      pawolf    06/20/2012 - Added global page support (feature #987)
--      vuvarov   07/19/2012 - Added g_nls_sort and g_nls_comp (feature #978)
--      hfarrell  08/16/2012 - Added parameters j and XMLCallDate to procedure show for Flash chart support (bug #14496908)
--      hfarrell  08/16/2012 - Changed paramater XMLCallDate in show from number to varchar2 to be consistent with htmldb_util.flash2
--      jkallman  12/17/2012 - Change APEX_040200 references to APEX_050000
--      cneumuel  01/11/2013 - Added LF constant for export/import (feature #985)
--      pawolf    04/08/2013 - Moved wwv_flow_security.g_page_checksum* variables into wwv_flow.show
--      pawolf    04/12/2013 - Added resolve_friendly_url (feature #478)
--      pawolf    04/12/2013 - Added population of wwv_flow.g_theme_file_prefix (feature #1162)
--      hfarrell  05/31/2013 - Added g_page_tmpl_is_popup, g_page_tmpl_js_dialog_code, g_page_mode, g_dialog_attributes, g_dialog_width, g_dialot_maxwidth, g_dialog_title (feature #587)
--      cneumuel  06/03/2013 - Removed g_sessionCnt, g_roleCnt
--      hfarrell  06/07/2013 - Added g_page_tmpl_dialog_width and g_page_tmpl_dialog_maxwidth (feature #587)
--      hfarrell  06/07/2013 - Renamed g_page_tmpl_js_dialog_code to g_page_tmpl_dialog_js_code and g_page_tmpl_dialog_maxwidth to g_page_tmpl_dialog_max_width, and g_dialog_maxwidth to g_dialog_max_width
--      hfarrell  06/20/2013 - Added g_dialog_height (feature # 587)
--      hfarrell  06/26/2013 - Added g_page_tmpl_dialog_height (feature #587)
--      hfarrell  07/01/2013 - Added g_default_dialog_page_template (feature #1200)
--      hfarrell  07/19/2013 - In show: added p_dialog_cs (feature #1200)
--      msewtz    08/09/2013 - Added g_navigation_list_id, g_navigation_list_template_id (feature 1236)
--      hfarrell  09/12/2013 - Added g_page_tmpl_dialog_close_js (feature #1201)
--      hfarrell  09/16/2013 - Added g_dialog_css_classes (feature #1204)
--      hfarrell  09/17/2013 - Added g_page_tmpl_dialog_css, g_page_tmpl_dialog_close_js (feature #1204)
--      hfarrell  10/24/2013 - Added g_page_tmpl_dialog_cancel_js (feature #1201)
--      cneumuel  11/08/2013 - Removed g_http_head_attr (feature #1065)
--      cneumuel  11/15/2013 - Replaced g_plug_% with table of records, to support migration of regions to native plugins (feature #1312)
--      hfarrell  11/22/2013 - Added g_branch_page_mode, g_branch_page_id and g_branch_flow_id for dialog page branch processing
--      cneumuel  11/28/2013 - page button migration (feature #1314)
--      cneumuel  11/29/2013 - page button migration makes image attributes obsolete (feature #1314)
--      pawolf    12/12/2013 - Added page_id to item, button and plug record structure
--      cneumuel  02/10/2014 - Added CR constant
--      msewtz    02/11/2014 - Added before and after element attributes and help link attribute for item globals (feature 1377)
--      msewtz    02/17/2014 - Added region_sub_css_classes to g_plugs (feature 1383)
--      cneumuel  02/20/2014 - Made g_rejoin_existing_sessions varchar2(1) (feature #1047)
--      cneumuel  02/21/2014 - Removed g_public_page_ids, g_public_page_aliases, g_protected_page_ids, g_protected_page_aliases,
--                           - g_ex_context_authentication, g_cookie_session_id, g_authentication, g_session_cookie, g_required_roles
--      cneumuel  02/28/2014 - move substitution cache variable from wwv_flow.g_use_cached_substitution_val to wwv_flow_session_state.g_substitution_item_not_loaded
--      pawolf    03/03/2014 - Added js_messages (feature #1279)
--      msewtz    03/12/2014 - Added icon CSS classes for buttons
--      pawolf    03/15/2014 - Added plug_query_headings* to t_plug
--      msewtz    03/25/2014 - Added template options to t_plug (feature 1394)
--      msewtz    03/28/2014 - Added template options to t_button (feature 1394)
--      cneumuel  04/04/2014 - Removed g_itemCnt, g_plugCnt, g_buttonCnt.
--                           - In t_button: added columns for item button migration (feature #1314)
--                           - Replace g_item_NN tables with g_items, a table of t_items.
--                           - Added t_region_component, t_plug.components, g_page_components
--      msewtz    04/04/2014 - Added item_css_classes and item_template_options to t_items
--      msewtz    04/04/2014 - Added default_template_options to t_items
--      msewtz    04/04/2014 - Aded page css classes, page template options
--      cneumuel  04/07/2014 - In t_button: added request_name (feature #1314)
--                           - Removed g_current_region_id
--                           - In t_plug:  added is_read_only, idx, parent_idx
--      cneumuel  04/10/2014 - Added t_region_component and t_region_components as replacement for the object types (feature #1314)
--      cneumuel  04/15/2014 - Removed unused g_step_sub_title, g_step_sub_title_type, g_spell_check_required and g_cached_regions
--                           - renamed g_cache to g_page_cache_mode and added additional page cache attributes (feature #1401)
--                           - In t_plug: added additional region cache attributes
--      msewtz    04/17/2014 - Added icon_css_classes to t_plug (feature 1394)
--      jkallman  04/17/2014 - Added g_page_alias (feature #1317)
--      cneumuel  04/24/2014 - In t_plug: added plug_cache_depends_on_items (feature #1401)
--      pawolf    05/23/2014 - Removed g_page_tmpl_has_edit_links
--      hfarrell  05/26/2014 - Added function apps_only_workspace (feature #1429)
--      cneumuel  05/30/2014 - In t_plug: added item_sequence_before, item_sequence_after (feature #1401)
--      hfarrell  07/04/2014 - In accept: added p_dialog_cs, required for dialog page support
--      pawolf    07/08/2014 - Changed c_current_compatibility_mode to 5.0
--      hfarrell  07/14/2014 - Added set_dialog_browser_frame procedure
--      hfarrell  07/15/2014 - Moved set_dialog_browser_frame to wwv_flow_page
--      cneumuel  07/17/2014 - Removed g_stepCnt. In show,accept: fetch_step_info is a procedure
--      pawolf    08/13/2014 - Added #APPLICATION_CSS# (feature #1474)
--      pawolf    08/13/2014 - Added #TOP_GLOBAL_NAVIGATION_LIST# and #SIDE_GLOBAL_NAVIGATION_LIST# (feature #1236)
--      pawolf    08/14/2014 - Added include_jquery_migrate to wwv_flow_user_interfaces (feature #1475)
--      hfarrell  10/15/2014 - Added navigation bar globals: g_nav_bar_type, g_nav_bar_list_id, g_nav_bar_list_template_id, g_nav_bar_template_options (feature #1536)
--      pawolf    10/21/2014 - t_item: added label_id (feature #1503)
--      cneumuel  10/30/2014 - Removed g_arg_values_delimited, added g_url_checksum_src (bug #17750471)
--      cneumuel  11/03/2014 - moved g_url_checksum_src from wwv_flow to wwv_flow_security
--      cneumuel  11/05/2014 - Added g_processes, g_branches, g_computations: metadata now uses table of record
--      pawolf    11/28/2014 - Added grid_label_column_span to t_item (feature #1615)
--      pawolf    12/05/2014 - Added grid_column_css_classes to regions, page items and buttons (feature #1466)
--      pawolf    12/09/2014 - Added g_shared_components_scn (feature #1624)
--      pawolf    01/20/2015 - In js_messages: added p_builder (bug #20184648)
--      pawolf    02/24/2015 - Added #FAVICONS# page template substitution (bug #20482545)
--      cneumuel  05/05/2015 - g_edition, g_flow_owner: long identifier support (bug #21031940)
--      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
--      msewtz    08/21/2015 - Added g_direction_right_to_left (feature 1046)
--      pawolf    12/07/2015 - Changed wwv_flow.g_direction_right_to_left to boolean
--      pawolf    12/16/2015 - Added ajax
--      cneumuel  01/20/2016 - Removed g_public_url_prefix,g_dbauth_url_prefix, g_current_user (bug #21178334)
--      pawolf    02/18/2016 - Added t_plug.master_region_id and t_plug.master_region_static_id
--      pawolf    02/27/2016 - In accept: removed parameters and added JSON support (feature #1958)
--      cczarski  03/01/2016 - In get_company_name: add parameter p_escape (bug#21133331, 21151803)
--      arayner   03/04/2016 - Added g_page_tmpl_id global (feature #1963)
--      arayner   03/04/2016 - Added template_id to t_item (feature #1963)
--      pawolf    03/17/2016 - Refactored branching logic into wwv_flow_branch
--      pawolf    04/11/2016 - In wwv_flow_steps: added warn_on_unsaved_changes (feature #1652)
--      pawolf    04/13/2016 - In wwv_flow_step_items and wwv_flow_step_buttons: added warn_on_unsaved_changes (feature #1652)
--      pawolf    04/17/2016 - Changed c_current_compatibility_mode to 5.1
--      pawolf    04/17/2016 - In t_button: added button_execute_validations
--      cczarski  05/04/2016 - In t_item: added item_icon_css_classes and inline_help_text
--      cczarski  05/11/2016 - in t_item: added pre_element_template and post_element_template (feature #1998)
--      cczarski  06/09/2016 - In t_item and t_plug: Added PLUGIN_INIT_JAVASCRIPT_CODE attribute (feature #2018)
--      cczarski  07/06/2016 - add g_app_builder_icon_name (feature #1978)
--      pawolf    07/14/2016 - In ajax: added new parameters
--      cneumuel  07/14/2016 - Removed g_user_id
--      pawolf    08/16/2016 - In js_messages: added p_names
--      cczarski  09/21/2016 - add inline CSS and CSS file URLs from region/report/list templates to g_plugs
--      cneumuel  10/03/2016 - Changed varchar2 size of globals to 32767 to reduce space consumption
--      pawolf    11/03/2016 - In accept: added x01 - x10 which are required as dummy parameters for some builder pages (bug #24694121)
--      hfarrell  01/05/2017 - Changed APEX_050100 reference to APEX_050200
--      pawolf    05/31/2017 - Added g_json to keep IG session state in popup lov dialog (bug #25117499)
--      cczarski  06/13/2017 - In t_plug: Add attributes for remote SQL and REST Service consumption (#2092, #2109)
--      pawolf    07/14/2017 - Added Built with love using Oracle APEX (feature #2191)
--      pawolf    07/28/2017 - Added wwv_flow_page_plugs.optimizer_hint (feature #1107)
--      pawolf    08/18/2017 - In show/ajax: added parameters x11 - x20 (feature #2201)
--      cczarski  10/02/2017 - in t_process: added attributes for web source / Remote SQL (features #2109, #2092)
--      cczarski  11/28/2017 - added g_no_proxy_domains (feature #2249)
--      cneumuel  11/28/2017 - In t_plug: remove obsolete item_sequence_before, item_sequence_after (bug #27098205)
--      cneumuel  12/11/2017 - remove obsolete wwv_flow.g_application_info (feature #1878)
--      pawolf    12/13/2017 - In t_plug: added include_rowid_column
--      cczarski  12/20/2017 - In t_plug: added source_post_processing, external_filter_expr and external_order_by_expr
--      cneumuel  01/09/2018 - Removed g_exec_count (bug #27362478)
--      pawolf    01/16/2018 - In wwv_flow_user_interfaces: changed include_legacy_javascript from a flag to checkbox values (feature #2223)
--      cneumuel  01/26/2018 - Added g_populate_roles (feature #2268)
--      pawolf    02/02/2018 - In wwv_flow_user_interfaces: added built_with_love (feature #2191)
--      cneumuel  02/20/2018 - Moved runtime engine globals from flow.sql to meta.sql (bug #27523529)
--      cneumuel  02/22/2018 - Moved more runtime globals from flow.sql to meta.sql (bug #27523529)
--      cczarski  07/10/2018 - In js_messages: add parameter p_operation in order to allow retrieving messages by prefix
--
--------------------------------------------------------------------------------

----------------------------------------------------------------------------
-- F L O W   G L O B A L    V A R I A B L E S
--

    -------------------------
    -- flow public data types
    --
    type flow_vc_arr is table of varchar2(32767) index by binary_integer;
    empty_flow_vc_arr flow_vc_arr;
    --
    empty_vc_arr wwv_flow_global.vc_arr2;
    type vc_long_arr is table of varchar2(32767) index by binary_integer;

    empty_vc_long_arr vc_long_arr;

    type clob_arr      is table of clob index by binary_integer;
    type vc_assoc_arr  is table of varchar2(32767) index by varchar2(255);
    type num_assoc_arr is table of number index by varchar2(255);

    type t_component is record (
        type varchar2(30), /* APEX dictionary view name of the component where an error occurred. For example APEX_APPLICATION_PAGE_PROC */
        id   number,       /* Internal component id which triggered the error. The id is always the id of the primary application  */
        name varchar2(32767) /* Name of the component which triggered the error like the process name */
        );

    -------------------------------------
    -- Globals for generic and public use
    --
    g_image_prefix                 varchar2(32767) := wwv_flow_global.g_image_prefix;
    g_company_images               varchar2(32767);
    g_flow_images                  varchar2(32767);
    g_theme_file_prefix            varchar2(32767);
    g_id                           number;
    g_notification                 varchar2(32767);
    g_global_notification          varchar2(32767);
    g_value                        varchar2(32767);
    g_sysdate                      date;
    g_systimestamp_gmt             timestamp;
    g_boolean                      boolean := false;
    g_excel_format                 boolean := false;
    g_error_message_override       varchar2(32767);         -- if set programmatically overrides process error messages
    g_unique_page_id               number;
    g_form_painted                 boolean := false;
    g_print_success_message        varchar2(32767);
    g_return_key_1                 varchar2(32767);         -- used to return keys from dml operations
    g_return_key_2                 varchar2(32767);         -- used to return keys from dml operations
    g_base_href                    varchar2(32767);         -- BASE HREF for APEX references
    g_edition                      wwv_flow_global.t_dbms_id;

    CR                             constant varchar2(1) default unistr('\000d');
    LF                             constant varchar2(1) default unistr('\000a');
    ---------------------
    -- translated strings
    g_nls_edit                     varchar2(32767) := 'Edit';

    ----------------------------------------------------
    -- Optimization and performance feedback information
    --
    g_form_count                   pls_integer := 0;
    g_package_instantiated         number;
    g_ok_to_cache_sql              boolean := false;
    g_page_text_generated          boolean := false;
    g_import_in_progress           boolean := false;
    g_workspace_delete_in_progress boolean := false;
    g_cached_region_count          pls_integer := 0;

    -----------------------------------
    -- Debug and error page information
    --
    g_debug                        boolean := false;        -- identifies if flow is running in debug mode
    g_unrecoverable_error          boolean := false;        -- NOTE: This global variable is deprecated,
                                                            -- use apex_application.stop_apex_engine instead!
    g_last_query_text              varchar2(32767);         -- if set is the last user sql query executed

    ----------------------------------------
    -- Authentication and login, logout info
    --
    g_user                         varchar2(32767);         -- corresponds to username used to login
    g_user_known_as                varchar2(32767);
    g_flow_schema_owner            constant varchar2(11)  := 'APEX_180200'; -- the owner of Oracle Application Express
    g_login_url                    varchar2(32767);
    g_logout_url                   varchar2(32767);
    g_logo_image                   varchar2(32767);
    g_logo_image_attributes        varchar2(32767);
    g_app_builder_icon_name        varchar2(32767);
    g_use_zero_sid                 boolean := false;
    g_public_auth_scheme           boolean := false;

    -----------------------------
    -- Optimistic Locking Globals
    --
    g_md5_checksum                 varchar2(32767) := '0';

    ------------------
    -- spatial globals
    --
    g_map1                         wwv_flow_global.vc_arr2;
    g_map2                         wwv_flow_global.vc_arr2;
    g_map3                         wwv_flow_global.vc_arr2;

    ---------------------
    -- Pagination Globals
    --
    g_rownum                       pls_integer := 0;
    g_flow_current_min_row         pls_integer := 1;
    g_flow_current_max_rows        pls_integer := 10;
    g_flow_current_rows_fetched    pls_integer := 0;
    g_flow_total_row_count         pls_integer := 0;
    g_pagination_buttons_painted   boolean := false;

    ---------------------
    -- Tabular Form Globals
    --
    g_item_idx_offset              number := 0;
    g_rownum_offset                number := 0;
    g_fmap                         num_assoc_arr;
    g_fhdr                         wwv_flow_global.vc_arr2;

    ---------------------
    -- Sorting Globals
    --
    g_fsp_region_id                number := 0;

    ----------------------------
    -- Translation (NLS) Globals
    --
    g_flow_language                varchar2(32767);        -- language flow written in (primary language)
    g_flow_language_derived_from   varchar2(30);           -- how the language preference of the user is determined
    g_browser_language             varchar2(32767);        -- users language preference (set using lang_derived_from method)
    g_browser_version              varchar2(32767);        -- browser version
    g_translated_flow_id           number;                 -- flow ID for translated flow
    g_translated_page_id           number;                 -- page ID for translated flow, e.g. page_id.trans_flow_id
    g_translated_global_page_id    number;                 -- global page id for translated flow. e.g. page_id.trans_flow_id
    g_nls_date_format              varchar2(32767);        -- current database date format from nls_session_parameters table.
    g_nls_timestamp_format         varchar2(32767);        -- current database timestamp with time zone format from nls_session_parameters table.
    g_nls_timestamp_tz_format      varchar2(32767);        -- current database timestamp with time zone format from nls_session_parameters table.
    g_nls_decimal_separator        varchar2(10);           -- current database session decimal separator (derived from NLS_NUMERIC_CHARACTERS)
    g_nls_group_separator          varchar2(10);           -- current database session numeric group separator (derived from NLS_NUMERIC_CHARACTERS)
    g_nls_sort                     varchar2(32767);        -- NLS_SORT value for the current application
    g_nls_comp                     varchar2(32767);        -- NLS_COMP value for the current application
    g_direction_right_to_left      boolean := false;       -- Indicates whether page is rendered right-to-left

    ----------------------
    -- Session Information
    --
    g_new_instance                 boolean := false;

    -------------------
    -- Websheet Information
    --
    g_ws_app_id                   number;                   -- wwv_flow_ws_application pk

    -------------------
    -- Flow Information
    --
    g_flow_id                      number;                  -- flow pk
    g_flow_theme_id                number;                  -- current theme for flow
    g_flow_alias                   varchar2(32767);         -- flow alphanumeric alias
    g_flow_step_id                 number;                  -- page pk
    g_page_alias                   varchar2(32767);         -- page alias
    g_instance                     number;                  -- flow session
    g_edit_cookie_session_id       number;                  -- flow builder session
    g_page_submitted               number;                  -- set when page posted
    g_exact_substitutions_only     varchar2(1);             -- Y or N
    g_arg_names                    wwv_flow_global.vc_arr2; -- array of item names
    g_arg_values                   wwv_flow_global.vc_arr2; -- array of item values
    g_flow_name                    varchar2(32767);         -- name of flow
    g_flow_charset                 varchar2(32767);         -- used in html header
    g_date_format                  varchar2(32767);         -- Application default date format
    g_date_time_format             varchar2(32767);         -- Application date time format
    g_timestamp_format             varchar2(32767);         -- Application default timestamp format
    g_timestamp_tz_format          varchar2(32767);         -- Application default timestamp with time zone format
    g_flow_owner                   wwv_flows.owner%type;    -- for secure use wwv_flow_security.g_parse_as_schema
    g_home_link                    varchar2(32767);         -- home page for this flow
    --g_box_width                    varchar2(30);          -- obsolete ?
    g_default_page_template        varchar2(32767);         --
    g_default_dialog_page_template varchar2(32767);         -- Application Theme default dialog page template
    g_printer_friendly_template    varchar2(32767);         --
    g_error_template               varchar2(32767);         --
    g_webdb_logging                varchar2(30);            -- YES (insert entries into a log table), NO (do not do inserts)

    g_public_user                  varchar2(32767);         -- identifies public user name
    g_proxy_server                 varchar2(32767);         -- used for some regions of type url and web services
    g_no_proxy_domains             varchar2(32767);         -- used for some regions of type url and web services
    g_media_type                   varchar2(32767);         -- Media Type used in Content-Type HTTP header
    g_flow_version                 varchar2(32767);         --
    g_flow_status                  varchar2(30);            -- controls availability of flow
    g_build_status                 varchar2(30);            --
    g_rejoin_existing_sessions     varchar2(1);             -- wwv_flows.rejoin_existing_sessions
    g_request                      varchar2(32767);         -- method of submitting page
    g_sqlerrm                      varchar2(32767);         -- unexpected sql error message to be logged into log tables
    g_err_comp_type                varchar2(32767);         -- sqlerrm_component_type identifies what type of component caused the error
    g_err_comp_name                varchar2(32767);         -- sqlerrm_component_name identifies the name of the component that raised the error
    g_cache_mode                   varchar2(1) := 'D';      -- R = rendered from cache, C = Cache Created, D = Dynamic
    g_auto_time_zone               varchar2(1);             -- automatic time zone (Y or N)
    g_default_error_display_loc    varchar2(40);            -- default error display location for validations
    g_javascript_file_urls         varchar2(32767);         -- application javascript file URLs #APPLICATION_JAVASCRIPT#
    g_content_delivery_network     varchar2(20);            -- content delivery network which should be used
    g_include_legacy_javascript    wwv_flow_user_interfaces.include_legacy_javascript%type; -- should legacy javascript functions be included?
    g_include_jquery_migrate       boolean := false;        -- should the jQuery Migrate plug-in be included?
    g_css_file_urls                varchar2(32767);         -- application css file URLs #APPLICATION_CSS#
    g_built_with_love_using_apex   boolean := false;        -- show Built with Love using Oracle APEX?
    g_email_from                   varchar2(32767);
    g_favicons                     varchar2(32767);         -- favicons of the application currently stored in APP_FAVICONS substitution variable
    g_global_page_id               number;
    g_shared_components_scn        number;

    g_json_response                boolean default false;   -- should the output of the accept procedure be in JSON

    -------------------
    -- Page Information
    --
    g_popup_filter                 varchar2(32767);         --
    g_printer_friendly             boolean := false;        -- if true use printer friendly page template
    g_first_field_displayable      boolean := false;        --
    g_step_name                    varchar2(32767);         -- page name
    g_step_user_interface_id       number;                  -- page user interface id
    g_step_tab_set                 varchar2(32767);         -- page current tab set
    g_step_title                   varchar2(32767);         -- page title typically becomes html page title
    g_step_media_type              varchar2(32767);         -- Media Type used in Content-Type HTTP header
    g_step_first_item              varchar2(32767);         -- name of item to put cursor in
    g_step_welcome_text            varchar2(32767);         -- wwv_flow_steps.welcome_text displayed after page template header
    g_step_box_welcome_text        varchar2(32767);         -- wwv_flow_steps.box_welcome_text displayed before #BOX_BODY# in page template body
    g_step_footer_text             varchar2(32767);         -- wwv_flow_steps.footer_text displayed before showing page template footer
    g_step_template                varchar2(32767);         -- page template
    g_page_css_classes             varchar2(32767);         -- page css classes
    g_page_template_options        varchar2(32767);         -- page template options
    g_step_required_role           varchar2(32767);         -- priv required to view page
    g_allow_duplicate_submissions  varchar2(3);             -- Y or N
    g_reload_on_submit             varchar2(1);             -- A=Always), S=Only for Success
    g_warn_on_unsaved_changes      boolean := true;
    g_head                         varchar2(32767);         -- page header for CSS, etc. #HEAD#
    g_page_onload                  varchar2(32767);         -- allows control over #ONLOAD# in page template
    g_step_javascript_file_urls    varchar2(32767);         -- page specific javascript file URLs #PAGE_JAVASCRIPT#
    g_javascript_code              varchar2(32767);         -- page specific javascript #PAGE_JAVASCRIPT#
    g_javascript_code_onload       varchar2(32767);         -- javascript code execute onload
    g_step_css_file_urls           varchar2(32767);         -- page specific CSS file URLs #PAGE_CSS#
    g_step_inline_css              varchar2(32767);         -- page specific inline CSS #PAGE_CSS#
    g_autocomplete_on_off          varchar2(3);             -- should autocomplete="off" be included in form tag
    g_include_apex_css_js_yn       varchar2(1);             -- Y is default, N does not include standard apex css and js files for mobile devices
    g_browser_cache                boolean;                 -- If false (the default) this sends the cache-control: no-store http response in wwv_flow.show
    g_browser_frame                varchar2(1);             -- If D, send X-Frame-Options:DENY header, if S, send X-Frame-Options:SAMEORIGIN header
    g_compatibility_mode           number;                  -- Compatibility Mode which contains a version number is used to determine how the runtime engine should behave when the application is executed
    g_page_transition              varchar2(20);            -- transition which is used for navigating to a new page or submitting the page
    g_popup_transition             varchar2(20);            -- transition which is used to open a popup
    g_page_mode                    varchar2(20);
    g_dialog_height                varchar2(20);
    g_dialog_width                 varchar2(20);
    g_dialog_max_width             varchar2(20);
    g_dialog_title                 varchar2(32767);
    g_dialog_css_classes           varchar2(32767);
    g_dialog_attributes            varchar2(32767);

    g_navigation_list_id           number;
    g_navigation_list_position     wwv_flow_user_interfaces.navigation_list_position%type;
    g_navigation_list_template_id  number;
    g_nav_list_template_options    wwv_flow_user_interfaces.nav_list_template_options%type;

    g_nav_bar_type                 wwv_flow_user_interfaces.nav_bar_type%type;              -- Navigation Bar Type: Render either as a List or a Navigation Bar
    g_nav_bar_list_id              number;                                                  -- Navigation Bar List ID: where type is set to List
    g_nav_bar_list_template_id     number;                                                  -- Navigation Bar List Template ID: where type is set to List
    g_nav_bar_template_options     wwv_flow_user_interfaces.nav_bar_template_options%type;  -- Navigation Bar List Template Options: where type is set to List

    -- Do only use this constant for the parameter p_compatibility_mode in wwv_flow_api.create_flow!
    -- It's a string and would result in NLS errors if you compare it against g_compatibility_mode
    c_current_compatibility_mode   constant varchar2(3) := '5.1';

    --
    -- computation result
    --
    g_computation_result_vc       varchar2(32767);
    g_computation_result_vc_arr   wwv_flow_global.vc_arr2;
    g_computation_result_num      number;
    --
    -- validations
    --
    g_column_ids_in_error         wwv_flow_global.vc_arr2;
    -- if g_execute_validations is programmatically set before the validations
    -- are evaluated then this flag will determin if built-in validations and the
    -- validations defined for the page are evaluated. If set to NULL, the
    -- "Execute Validations" flag for buttons and select lists/radio groups will
    -- be evaluated
    g_execute_validations         boolean default null;

    --------------------------------------------
    -- Global input values for updatable reports
    --
    g_f01             wwv_flow_global.vc_arr2;
    g_f02             wwv_flow_global.vc_arr2;
    g_f03             wwv_flow_global.vc_arr2;
    g_f04             wwv_flow_global.vc_arr2;
    g_f05             wwv_flow_global.vc_arr2;
    g_f06             wwv_flow_global.vc_arr2;
    g_f07             wwv_flow_global.vc_arr2;
    g_f08             wwv_flow_global.vc_arr2;
    g_f09             wwv_flow_global.vc_arr2;
    g_f10             wwv_flow_global.vc_arr2;
    g_f11             wwv_flow_global.vc_arr2;
    g_f12             wwv_flow_global.vc_arr2;
    g_f13             wwv_flow_global.vc_arr2;
    g_f14             wwv_flow_global.vc_arr2;
    g_f15             wwv_flow_global.vc_arr2;
    g_f16             wwv_flow_global.vc_arr2;
    g_f17             wwv_flow_global.vc_arr2;
    g_f18             wwv_flow_global.vc_arr2;
    g_f19             wwv_flow_global.vc_arr2;
    g_f20             wwv_flow_global.vc_arr2;
    g_f21             wwv_flow_global.vc_arr2;
    g_f22             wwv_flow_global.vc_arr2;
    g_f23             wwv_flow_global.vc_arr2;
    g_f24             wwv_flow_global.vc_arr2;
    g_f25             wwv_flow_global.vc_arr2;
    g_f26             wwv_flow_global.vc_arr2;
    g_f27             wwv_flow_global.vc_arr2;
    g_f28             wwv_flow_global.vc_arr2;
    g_f29             wwv_flow_global.vc_arr2;
    g_f30             wwv_flow_global.vc_arr2;
    g_f31             wwv_flow_global.vc_arr2;
    g_f32             wwv_flow_global.vc_arr2;
    g_f33             wwv_flow_global.vc_arr2;
    g_f34             wwv_flow_global.vc_arr2;
    g_f35             wwv_flow_global.vc_arr2;
    g_f36             wwv_flow_global.vc_arr2;
    g_f37             wwv_flow_global.vc_arr2;
    g_f38             wwv_flow_global.vc_arr2;
    g_f39             wwv_flow_global.vc_arr2;
    g_f40             wwv_flow_global.vc_arr2;
    g_f41             wwv_flow_global.vc_arr2;
    g_f42             wwv_flow_global.vc_arr2;
    g_f43             wwv_flow_global.vc_arr2;
    g_f44             wwv_flow_global.vc_arr2;
    g_f45             wwv_flow_global.vc_arr2;
    g_f46             wwv_flow_global.vc_arr2;
    g_f47             wwv_flow_global.vc_arr2;
    g_f48             wwv_flow_global.vc_arr2;
    g_f49             wwv_flow_global.vc_arr2;
    g_f50             wwv_flow_global.vc_arr2;
    g_fcs             wwv_flow_global.vc_arr2;
    g_fcud            wwv_flow_global.vc_arr2;
    g_frowid          wwv_flow_global.vc_arr2;
    g_survey_map      varchar2(32767);

    --------------------------------------------
    -- Global input variables for AJAX utilities
    --
    g_widget_name       varchar2(32767);
    g_widget_mod        varchar2(32767);
    g_widget_action     varchar2(32767);
    g_widget_action_mod	varchar2(32767);
    g_widget_num_return	varchar2(32767);
    g_widget_view_mode  varchar2(32767);

    g_x01             varchar2(32767);
    g_x02             varchar2(32767);
    g_x03             varchar2(32767);
    g_x04             varchar2(32767);
    g_x05             varchar2(32767);
    g_x06             varchar2(32767);
    g_x07             varchar2(32767);
    g_x08             varchar2(32767);
    g_x09             varchar2(32767);
    g_x10             varchar2(32767);
    g_x11             varchar2(32767);
    g_x12             varchar2(32767);
    g_x13             varchar2(32767);
    g_x14             varchar2(32767);
    g_x15             varchar2(32767);
    g_x16             varchar2(32767);
    g_x17             varchar2(32767);
    g_x18             varchar2(32767);
    g_x19             varchar2(32767);
    g_x20             varchar2(32767);
    g_clob_01         clob;

    ------------------------------------
    -- Session Timeout
    --

    g_max_session_length_sec        number;
    g_max_session_idle_sec          number;

    ----------------------------------------------------------------------------
    -- Global array of form item values fetched by automated row fetch processes
    -- and other globals previously in wwv_flow_dml
    --
    g_column_values             wwv_flow.flow_vc_arr;
    g_clob_column_values        wwv_flow.clob_arr;
    g_dml_blob                  blob;
    g_dml_mimetype              varchar2(32767);
    g_dml_filename              varchar2(32767);
    g_dml_charset               varchar2(32767);
    g_dml_last_updated_date     date;
    g_dml_clob_text             clob;
    g_dml_varchar32767_text     varchar2(32767);
    g_dml_rowid                 varchar2(32767);
    g_dml_blob_length           number := 0;

    -----------------------------
    -- Stop APEX Engine
    -----------------------------
    c_stop_apex_engine_no constant pls_integer := -20876;
    e_stop_apex_engine    exception;
    pragma exception_init(e_stop_apex_engine, -20876);

    ---------------------------
    -- Maximum DB VARCHAR2 size
    --
$if sys.dbms_db_version.ver_le_10_2 $then
    c_max_size_vc2 constant number := 4000;
$elsif sys.dbms_db_version.ver_le_11_1 $then
    c_max_size_vc2 constant number := 4000;
$elsif sys.dbms_db_version.ver_le_11_2 $then
    c_max_size_vc2 constant number := 4000;
$else
    c_max_size_vc2 constant number := 32767;
$end

    ------------------------------------------------
    -- For Internal use only, will be removed in 5.2
    ------------------------------------------------
    g_json wwv_flow_global.vc_arr2;

--==============================================================================
-- Return global flags that were previously exposed as variables
--==============================================================================
function g_in_accept
    return boolean;
function g_in_process
    return boolean;

----------------------------------------------------------------------------
-- S H O W
--
-- This procedure is the entry point for the display of application express pages.
--
--
-- p_request              -- Request which can be the tab pressed, the button pressed, an
--                           arbitrary value etc.
-- p_instance             -- Flow Session ID, must be numeric.
-- p_flow_id              -- Flow ID, must be numeric.
-- p_flow_step_id         -- Page ID, must be numeric (for example: 1)
-- p_debug                -- If "YES" then flows will display debug messages.
-- p_arg_names            -- Comma seperated list of flow item names.  Item names should
--                           have corresponding (p_arg_values) values.  For example:
--                           p_arg_names => 'A,B,C'
--                           p_arg_values=> '1,2,3'
--                           This assumes that a flow or page item called A, B, and C
--                           exists.  When called a value of 1 will be assigned to A,
--                           2 to B, etc.
-- p_arg_values           -- Comma seperated list of values that corresponds to a
--                           comma seperated list of names (p_arg_names).  The session
--                           state for the flow items identified will be set to these
--                           values.
-- p_arg_name             -- use when passing one item name, itentifies a single item name
-- p_arg_value            -- use when passing one item value, identifies a single item value
-- p_clear_cache          -- Comma seperated list of pages (e.g. 2,3,4).
--                           Sets to null the values of any flow item declared for a
--                           list of pages.
-- p_box_border           -- obsolete
-- p_printer_friendly     -- If "YES" then show page using printer friendly template.
--                           Do not generate tabs or nav bar icons.
-- p_trace                -- If "YES", generate trace file for debugging and performance tuning
-- p_company              -- ID of company (security group id) must be numeric
-- p_md5_checksum         -- checksum to prevent lost updates
-- p_last_button_pressed  -- facilitates reference to :flow_last_button_pressed
-- p_dialog_cs            -- check sum for modal dialog page to allow use of iframe when Embed in Frame security setting is DENY

procedure show (
    p_request             in varchar2   default null,
    p_instance            in varchar2   default null,
    p_flow_id             in varchar2   default null,
    p_flow_step_id        in varchar2   default null,
    p_debug               in varchar2   default 'NO',
    p_arg_names           in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_arg_values          in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_clear_cache         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_box_border          in varchar2   default '0',
    p_printer_friendly    in varchar2   default 'NO',
    p_trace               in varchar2   default 'NO',
    p_company             in number     default null,
    p_md5_checksum        in varchar2   default '0',
    p_last_button_pressed in varchar2   default null,
    p_arg_name            in varchar2   default null,
    p_arg_value           in varchar2   default null,
    f01                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f02                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f03                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f04                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f05                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f06                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f07                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f08                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f09                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f10                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f11                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f12                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f13                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f14                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f15                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f16                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f17                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f18                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f19                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f20                   in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_widget_name         in varchar2   default null,
    p_widget_mod          in varchar2   default null,
    p_widget_action       in varchar2   default null,
    p_widget_action_mod   in varchar2   default null,
    p_widget_num_return   in varchar2   default null,
    p_widget_view_mode    in varchar2   default null,
    p_fsp_region_id       in number     default null,
    p_pg_min_row          in number     default null,
    p_pg_max_rows         in number     default null,
    p_pg_rows_fetched     in number     default null,
    p_time_zone           in varchar2   default null,
    x01                   in varchar2   default null,
    x02                   in varchar2   default null,
    x03                   in varchar2   default null,
    x04                   in varchar2   default null,
    x05                   in varchar2   default null,
    x06                   in varchar2   default null,
    x07                   in varchar2   default null,
    x08                   in varchar2   default null,
    x09                   in varchar2   default null,
    x10                   in varchar2   default null,
    x11                   in varchar2   default null,
    x12                   in varchar2   default null,
    x13                   in varchar2   default null,
    x14                   in varchar2   default null,
    x15                   in varchar2   default null,
    x16                   in varchar2   default null,
    x17                   in varchar2   default null,
    x18                   in varchar2   default null,
    x19                   in varchar2   default null,
    x20                   in varchar2   default null,
    p_json                in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_clob_01             in clob       default null,
    p_lang                in varchar2   default null,
    p_territory           in varchar2   default null,
    p_cs                  in varchar2   default null,
    j                     in varchar2   default null,
    XMLCallDate           in varchar2   default null,
    p_dialog_cs           in varchar2   default null)
    ;


----------------------------------------------------------------------------
-- A C C E P T
--
-- This procedure accepts virtually every flow page.
-- Reference show procedure for input argument descriptions.
--
--
--
--

procedure accept (
    p_request          in varchar2 default null,
    p_instance         in varchar2 default null,
    p_flow_id          in varchar2 default null,
    p_company          in number   default null,
    p_flow_step_id     in varchar2 default null,
    p_reload_on_submit in varchar2 default 'A',
    p_arg_names        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_arg_values       in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_json             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_files            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f01             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f02             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f03             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f04             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f05             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f06             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f07             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f08             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f09             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f10             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f11             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f12             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f13             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f14             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f15             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f16             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f17             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f18             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f19             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f20             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f21             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f22             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f23             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f24             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f25             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f26             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f27             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f28             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f29             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f30             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f31             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f32             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f33             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f34             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f35             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f36             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f37             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f38             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f39             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f40             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f41             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f42             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f43             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f44             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f45             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f46             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f47             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f48             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f49             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f50             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    fcs             in wwv_flow_global.vc_arr2 default empty_vc_arr,
    fmap            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    fhdr            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    fcud            in wwv_flow_global.vc_arr2 default empty_vc_arr,
    frowid          in wwv_flow_global.vc_arr2 default empty_vc_arr,
    x01             in varchar2   default null,
    x02             in varchar2   default null,
    x03             in varchar2   default null,
    x04             in varchar2   default null,
    x05             in varchar2   default null,
    x06             in varchar2   default null,
    x07             in varchar2   default null,
    x08             in varchar2   default null,
    x09             in varchar2   default null,
    x10             in varchar2   default null,
    x11             in varchar2   default null,
    x12             in varchar2   default null,
    x13             in varchar2   default null,
    x14             in varchar2   default null,
    x15             in varchar2   default null,
    x16             in varchar2   default null,
    x17             in varchar2   default null,
    x18             in varchar2   default null,
    x19             in varchar2   default null,
    x20             in varchar2   default null,
    p_listener      in wwv_flow_global.vc_arr2 default empty_vc_arr, -- used to communicate with apex listner
    p_map1          in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_map2          in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_map3          in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_debug              in varchar2 default 'NO',
    p_trace              in varchar2 default 'NO',
    p_page_submission_id in varchar2 default null,
    p_time_zone          in varchar2 default null,
    p_ignore_01     in varchar2 default null,
    p_ignore_02     in varchar2 default null,
    p_ignore_03     in varchar2 default null,
    p_ignore_04     in varchar2 default null,
    p_ignore_05     in varchar2 default null,
    p_ignore_06     in varchar2 default null,
    p_ignore_07     in varchar2 default null,
    p_ignore_08     in varchar2 default null,
    p_ignore_09     in varchar2 default null,
    p_ignore_10     in varchar2 default null,
    p_lang          in varchar2 default null,
    p_territory     in varchar2 default null,
    p_dialog_cs     in varchar2 default null)
    ;

--==============================================================================
-- This procedure is used for Ajax requests where p_json contains a JSON document
-- with all the necessary information to dispatch the Ajax request(s) to the
-- different components.
--==============================================================================
procedure ajax (
    p_flow_id           in varchar2,
    p_flow_step_id      in varchar2,
    p_instance          in varchar2,
    p_debug             in varchar2 default 'NO',
    p_trace             in varchar2 default 'NO',
    p_request           in varchar2 default null,
    p_arg_names         in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_arg_values        in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_json              in wwv_flow_global.vc_arr2 default empty_vc_arr,
    x01                 in varchar2 default null,
    x02                 in varchar2 default null,
    x03                 in varchar2 default null,
    x04                 in varchar2 default null,
    x05                 in varchar2 default null,
    x06                 in varchar2 default null,
    x07                 in varchar2 default null,
    x08                 in varchar2 default null,
    x09                 in varchar2 default null,
    x10                 in varchar2 default null,
    x11                 in varchar2 default null,
    x12                 in varchar2 default null,
    x13                 in varchar2 default null,
    x14                 in varchar2 default null,
    x15                 in varchar2 default null,
    x16                 in varchar2 default null,
    x17                 in varchar2 default null,
    x18                 in varchar2 default null,
    x19                 in varchar2 default null,
    x20                 in varchar2 default null,
    f01                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f02                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f03                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f04                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f05                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f06                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f07                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f08                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f09                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f10                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f11                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f12                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f13                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f14                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f15                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f16                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f17                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f18                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f19                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    f20                 in wwv_flow_global.vc_arr2 default empty_vc_arr,
    -- For backward compatibility, don't use for new apps
    p_clob_01           in clob     default null,
    p_widget_name       in varchar2 default null,
    p_widget_mod        in varchar2 default null,
    p_widget_action     in varchar2 default null,
    p_widget_action_mod in varchar2 default null,
    p_widget_num_return in varchar2 default null,
    p_widget_view_mode  in varchar2 default null,
    p_fsp_region_id     in number   default null,
    p_clear_cache       in wwv_flow_global.vc_arr2 default empty_vc_arr,
    p_pg_min_row        in number   default null,
    p_pg_max_rows       in number   default null,
    p_pg_rows_fetched   in number   default null );

----------------------------------------------------------------------------
-- Returns all text messages of the APEX Runtime Engine and the specified
-- application which are marked as JavaScript messages.
-- If p_names is specified, only those text messages will be returned.
-- Those messages don't have to be marked as JavaScript messages.
--
procedure js_messages (
    p_app_id    in number,
    p_lang      in varchar2,
    p_version   in varchar2,
    p_builder   in varchar2 default 'N',
    p_names     in wwv_flow_global.vc_arr2 default wwv_flow_global.c_empty_vc_arr2,
    p_operation in varchar2 default 'EQ' );

----------------------------------------------------------------------------
-- H E L P   S Y S T E M
--

procedure help (
    --
    -- Returns Page and Column level help from flow builder meta data
    -- repository.
    --
    -- Arguments:
    --    p_flow_id        = flow ID
    --    p_flow_step_id   = page ID
    --    p_show_item_help = YES (include item level help), NO do not show item level help
    --
    p_request        in varchar2 default null,
    p_flow_id        in varchar2 default null,
    p_flow_step_id   in varchar2 default null,
    p_show_item_help in varchar2 default 'YES',
    p_show_regions   in varchar2 default 'YES',
    --
    p_before_page_html     in varchar2 default '<p>',
    p_after_page_html      in varchar2 default null,
    p_before_region_html   in varchar2 default null,
    p_after_region_html    in varchar2 default '</td></tr></table></p>',
    p_before_prompt_html   in varchar2 default '<p><b>',
    p_after_prompt_html    in varchar2 default '</b></p>:&nbsp;',
    p_before_item_html     in varchar2 default null,
    p_after_item_html      in varchar2 default null)
    ;







----------------------------------------------------------------------------
-- U T I L I T I E S
--

function do_substitutions (
    --
    -- Perform substitutions of ampersand prefixed flow items with
    -- current flow session state for current user and current session.
    --
    p_string                       in varchar2 default null,
    p_sub_type                     in varchar2 default 'SQL',
    p_perform_oracle_substitutions in boolean default false )
    return varchar2
    ;

function trim_sql (
    --
    -- Given a SQL statement , trim trailing and leading
    -- white spaces.  Optionally perform session state substitutions
    -- as well as ensuring the statement ends in a semicolon.
    --
    p_sql               in varchar2 default null,
    p_ends_in_semicolon in boolean default false,
    p_do_substitutions  in boolean default true)
    return varchar2
    ;

function trim_sql (
    --
    -- This function gets a SQL statement ready for execution
    -- Function is overloaded; p_owner may be provided in order to cause package global
    -- to be temporarily replaced with the value of p_owner in package state during
    -- the execution of this function and until its return to the caller.
    --
    p_sql               in varchar2 default null,
    p_ends_in_semicolon in boolean default false,
    p_do_substitutions  in boolean default true,
    p_owner             in varchar2)
    return varchar2
    ;

function trim_nl_sp_tab (
    -- This function removes all whitespace, tab, and new line characters at the begin and end of the input string
    p_string varchar2 )
    return varchar2;

procedure set_g_nls_date_format
    ;

procedure reset_g_nls_date_format
    ;


procedure set_g_nls_decimal_separator
    ;

procedure reset_g_nls_decimal_separator
    ;

function get_nls_decimal_separator return varchar2
    ;

function get_nls_group_separator return varchar2
    ;

function get_translated_app_id return number
    ;

procedure set_g_base_href
    ;

procedure reset_g_base_href
    ;

function get_g_base_href return varchar2
    ;

function get_page_alias return varchar2
    ;

function is_custom_auth_page return boolean
    ;

function get_application_id return number
    ;

function get_page_id return number
    ;

function get_session_id return number
    ;

function get_security_group_id return number
    ;

function is_pressed_button (
    p_button_id in number )
    return boolean;

----------------------------------------------------------------------------
-- E R R O R   H A N D L I N G
--
--==============================================================================
-- Returns the number of inline validation errors.
-- Note: That's a compatibility wrapper,
--       use wwv_flow_error.get_validation_error_count instead.
--==============================================================================
function g_inline_validation_error_cnt return pls_integer;

--==============================================================================
-- Signals the APEX engine to stop further processing and immediately exit so
-- that no additional HTML code is added to the HTTP buffer.
--
-- Note: This procedure will internally raise the exception e_stop_apex_engine.
--       You have to reraise that exception if you use a WHEN OTHERS exception
--       handler!
--
-- Example:
--
-- owa_util.redirect_url('http://apex.oracle.com');
-- apex_application.stop_apex_engine;
--
-- Complex example with a when others exception handler:
--
-- begin
--     ... code which can raise an exception ...
--     owa_util.redirect_url('http://apex.oracle.com');
--     apex_application.stop_apex_engine;
-- exception
--     when apex_application.e_stop_apex_engine then
--         raise; -- reraise the stop APEX engine exception
--     when others then
--         ...; -- code to handle the exception
-- end;
--
--==============================================================================
procedure stop_apex_engine;

----------------------------------------
-- I N T E R N A L     U T I L I T I E S
--
-- Internal utilities used by the flow engine runtime
-- that are not intened and are not useful to the
-- flows programmer.
--

procedure set_component (
    p_type in varchar2,
    p_id   in number   default null,
    p_name in varchar2 default null );

function get_component return t_component;

procedure clear_component;

function paint_formOpen
    -- Return the HTML form open tag given current flow state.
    return varchar2
    ;


function get_form_close_tag return varchar2;

function paint_buttons (
    -- Given current flows context draw (omit the HTML) for
    -- buttons given a position and region ID.
    p_position in varchar2 default 'TOP',
    p_plug_id  in varchar2 default '0')
    return varchar2
    ;

procedure s (
    p in varchar2 default null)
    ;

----------------------------------------------------------------------------
-- D E B U G G I N G
--
procedure debug (
    -- Given a string this will result in the generation of a debug entry
    p_string         in varchar2 default null)
    ;


function get_elapsed_time
    -- Get the elapsed time from package instantiation
    return number;




----------------------------------------------------------------------------
-- S E S S I O N   S T A T E   M A N A G E M E N T
--
-- The following routines can be called to read and write session state.
--
--
--
--

function get_next_session_id
    -- Get integer ID values, session ID is a sequence, unique ID is a sequence
    -- with a random number which produces a virtual global unique ID.
    return number
    ;

function get_unique_id
    -- Return a number which is virually globally unique.
    return number
    ;

procedure clear_page_cache (
    -- Reset all cached items for a given page to null
    p_flow_page_id in number default null)
    ;

procedure clear_page_caches (
    -- Reset all cached items for pages in array to null
    p_flow_page_id in wwv_flow_global.vc_arr2 default empty_vc_arr)
    ;

procedure clear_flow_cache (
    -- For the current session remove session state for the given flow.
    -- Requires g_instance to be set to the current flows session.
    p_flow_id in varchar2 default null)
    ;

procedure clear_app_cache (
    -- For the current session remove session state for the given flow.
    -- Requires g_instance to be set to the current flows session.
    p_app_id in varchar2 default null)
    ;

procedure clear_user_cache
    -- For the current users session remove session state and flow system preferences.
    -- Run this procedure if you reuse session IDs and want to run flows without
    -- the benifit of existing session state.  Requires g_instance to be set to the
    -- current flows session.
    ;

function find_item_id (
    -- Given a flow page or flow level items name return its numeric identifier.
    p_name in varchar2 default null)
    return number
    ;

function find_item_name (
    -- Given a flow page or flow level items numeric identifier return the items name.
    p_id in number default null)
    return varchar2
    ;

procedure update_cache_with_write (
    -- For the current session update an items cached value.  This update is persistent
    -- for the life of the flow session, unless the session state is cleared or updated.
    p_name    in varchar2 default null,
    p_value   in varchar2 default null)
    ;

procedure reset_security_check
    -- Security checks are cached to increase performance, this procedure allows you to
    -- undo the caching and thus require all security checks to be revalidated for the
    -- current user.  Use this routine if you allow a user to change "responcibilities"
    -- within an application, thus changing their authentication scheme.
    ;

function public_role_check (
    p_role      in varchar2 default null,
    p_component in varchar2 default null)
    return boolean
    ;

function public_security_check (
    -- Given the name of a flow security scheme determine if the current user
    -- passes the security check.
    p_security_scheme in varchar2)
    return boolean
    ;

function fetch_flow_item(
    -- Given a flow-level item name, locate item in current or specified
    -- flow and current or specified session and return item value.
    p_item         in varchar2,
    p_flow         in number default null,
    p_instance     in number default null)
    return varchar2
    ;

function fetch_app_item(
    -- Given a flow-level item name, locate item in current or specified
    -- flow and current or specified session and return item value.
    p_item         in varchar2,
    p_app          in number default null,
    p_instance     in number default null)
    return varchar2
    ;

------------------------------------------------------------------
-- V I R T U A L   P R I V A T E   D A T A B A S E   S U P P O R T
--
-- flows are owned by companies which are identified by a security
-- group ID.  The flow meta data repository is "sliced up" by
-- the security group id (sgid).
--

function get_sgid return number
    -- Given the current users context return the security group ID.
    ;
function get_browser_version return varchar2;
     -- return browser versiob

function get_company_name (
    p_escape in boolean default true
) return varchar2
    -- Given the current users context return the company name.
    ;

function apps_only_workspace return boolean;

------------------------------------------------------------------
-- Stateful processes
--

function process_state(
    p_process_id in number)
    return varchar2
    ;

procedure reset_page_process(
    p_process_id in number)
    ;

procedure reset_page_processess(
    p_page_id in number)
    ;


------------------------------------------------------------------
-- A U T H E N T I C A T I O N
--

function get_custom_auth_login_url return varchar2
    -- for use with custom authentication
    ;

function replace_cgi_env(
    p_in varchar2)
    return varchar2
    ;

function get_home_link_url return varchar2
    -- internal use only
    ;

--==============================================================================
-- Public procedure used as "Path Alias Procedure" (see http://download.oracle.com/docs/cd/A97335_02/apps.102/a90099/feature.htm#1007126
-- to translate a friendly URL of APEX into a related wwv_flow.show or
-- wwv_flow_file_mgr.get_file call.
--==============================================================================
procedure resolve_friendly_url (
    p_path in varchar2 );

------------------------------------------------------------------
-- Deprecated, obsolete procedures and functions.
-- Don't use them anymore!
--

procedure null_page_cache (
    p_flow_page_id in number default null)
    ;

procedure null_step_cache (
    p_flow_step_id in number default null)
    ;

procedure null_page_caches (
    p_flow_page_id in wwv_flow_global.vc_arr2 default empty_vc_arr)
    ;

procedure null_step_caches (
    p_flow_step_id in wwv_flow_global.vc_arr2 default empty_vc_arr)
    ;

procedure show_error_message (
    p_message  in varchar2 default 'Error',
    p_footer   in varchar2 default null,
    p_query    in varchar2 default null)
    ;

function get_application_id (
    p_application_id_or_alias in varchar2,
    p_security_group_id       in number   default null )
    return number;

procedure set_ppr_query_session_state (p_region_id in number);

end wwv_flow;
/
show errors

set define '^'
