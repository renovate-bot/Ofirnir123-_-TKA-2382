Rem  Copyright (c) Oracle Corporation 2012 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      dev_views.sql
Rem
Rem    DESCRIPTION
Rem      Views which are used in internal applications
Rem
Rem    NOTE
Rem      All views must have the postfix _DEV
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem    pawolf      03/12/2012 - Created
Rem    pawolf      03/15/2012 - Moved wwv_flow_search_result and wwv_flow_advisor_result from tab.sql
Rem    cneumuel    04/17/2012 - Prefix sys objects with schema (bug #12338050)
Rem    cneumuel    06/26/2012 - Fixed typo in wwv_flow_ui_types.autodetect_js_function_body (feature #791)
Rem    cneumuel    10/25/2013 - Added wwv_flow_page_proc_ws_parm_dev+iot (feature #1281)
Rem    cneumuel    11/04/2013 - Moved wwv_flow_developer_workspaces from view.sql to dev_views.sql (feature #3)
Rem                           - in wwv_flow_developer_workspaces: added last_login, removed image, description, created_on (feature #3)
Rem    cneumuel    11/05/2013 - Moved wwv_flow_developer_workspaces back to view.sql, becuase of dependencies in wwv_flow_cloud_idm
Rem    cneumuel    11/21/2013 - Added wwv_flow_visible_flows (bug #17825560)
Rem    cneumuel    11/22/2013 - In wwv_flow_visible_flows: sys.dual
Rem    pawolf      12/07/2013 - Added wwv_flow_worksheet_col_grp_dev, wwv_flow_region_rpt_dev and wwv_flow_region_rpt_col_dev
Rem    pawolf      12/08/2013 - Continued working on wwv_flow_region_rpt_col_dev
Rem    pawolf      12/08/2013 - Continued working on wwv_flow_region_rpt_dev
Rem    cneumuel    12/09/2013 - Added wwv_flow_step_items_dev
Rem    pawolf      12/09/2013 - Continued working on wwv_flow_region_rpt_dev
Rem    pawolf      12/10/2013 - Added wwv_flow_worksheet_col_dev
Rem    cneumuel    12/12/2013 - Added wwv_flow_step_branches_dev and IOT
Rem    pawolf      12/16/2013 - Changed wwv_flow_step_items_dev to return named_lov_id instead of name of lov
Rem    pawolf      12/19/2013 - Added support for derived classic report and tabular form columns
Rem    pawolf      12/20/2013 - Added wwv_flow_chart5_series_dev
Rem    pawolf      01/10/2014 - Continued work on wwv_flow_charts5_dev and wwv_flow_chart5_series_dev
Rem    pawolf      01/10/2014 - Added wwv_flow_worksheet_rpts_dev
Rem    pawolf      01/13/2014 - Added wwv_flow_cals_dev
Rem    pawolf      01/14/2014 - Fixed wwv_flow_cals_dev
Rem    pawolf      01/15/2014 - Fixed trigger of wwv_flow_region_rpt_col_dev which did not save the column_format
Rem    pawolf      01/16/2014 - Improved wwv_flow_worksheet_col_dev when columns are added or removed
Rem    arayner     01/21/2014 - Added some map attribute logic to wwv_flow_charts5_dev
Rem    pawolf      01/21/2014 - Added map_level_* columns to wwv_flow_charts5_dev
Rem    arayner     01/23/2014 - Started map_attr logic in wwv_flow_charts5_dev
Rem    arayner     01/24/2014 - Continued map_attr logic in wwv_flow_charts5_dev
Rem    arayner     01/28/2014 - Continued map logic in wwv_flow_charts5_dev
Rem    pawolf      01/28/2014 - Changed map level logical in wwv_flow_charts5_dev
Rem    arayner     01/29/2014 - Continued map logic in wwv_flow_charts5_dev
Rem    arayner     01/31/2014 - Continued map logic in wwv_flow_charts5_dev
Rem    pawolf      02/20/2014 - Added wwv_flow_region_print_dev
Rem    pawolf      03/04/2014 - Changed wwv_flow_worksheet_col_dev to workaround a data issue with page_id
Rem    pawolf      03/11/2014 - Added wwv_flow_region_plugin_dev
Rem    pawolf      03/17/2014 - Added wwv_flow_region_columns_dev (feature #1393)
Rem    pawolf      03/21/2014 - Added item_css_classes to wwv_flow_step_items (feature #1394)
Rem    pawolf      03/21/2014 - Added region_sub_css_classes to wwv_flow_region_rpt_dev and wwv_flow_region_plugin_dev
Rem    pawolf      03/24/2014 - Added template_options (feature #1394)
Rem    cbcho       03/24/2014 - Changed link_example and added region_id in wwv_flow_worksheet_rpts_dev (feature #1402)
Rem    arayner     03/28/2014 - Added setting of format mask for LINK, PLAIN and STRIP_HTML in wwv_flow_worksheet_col_dev_iot
Rem    pawolf      04/11/2014 - Fixed bug in wwv_flow_charts5_dev where some attribute values have to be nullified if they are N
Rem    pawolf      04/11/2014 - Fixed defaulting of series_type in wwv_flow_chart5_series_dev
Rem    pawolf      04/12/2014 - Added wwv_flow_steps_dev
Rem    pawolf      04/25/2014 - Updated wwv_flow_page_proc_ws_parm_dev
Rem    pawolf      05/05/2014 - Added wwv_flow_page_plugs_dev
Rem    pawolf      05/06/2014 - Fixed wwv_flow_step_items_dev where named_lov contains %null%
Rem    pawolf      05/07/2014 - Added component type and component id to wwv_flow_search_result_dev and wwv_flow_advisor_result_dev
Rem    pawolf      05/09/2014 - Updated trigger wwv_flow_page_proc_ws_parm_dev to delete parameters
Rem    pawolf      05/12/2014 - Added wwv_flow_ws_operations_dev
Rem    pawolf      05/12/2014 - Added blob table owner to IR and classic report columns (feature #1418)
Rem    arayner     05/15/2014 - Continued work on map attributes in wwv_flow_charts5_dev
Rem    arayner     05/16/2014 - Minor change to map attributes in wwv_flow_charts5_dev
Rem    pawolf      05/21/2014 - Added wwv_flow_ws_oper_param_dev
Rem                           - Changed wwv_flow_page_proc_ws_parm_dev
Rem    pawolf      05/26/2014 - Added theme navigation type to wwv_flow_steps_dev
Rem    pawolf      05/27/2014 - Added trigger for wwv_flow_steps_dev
Rem    cneumuel    06/11/2014 - Added wwv_flow_company_filestats_dev (feature #1198)
Rem    pawolf      06/12/2014 - Added plug_query_parse_override to wwv_flow_page_plugs_dev
Rem    cneumuel    06/12/2014 - In wwv_flow_company_filestats_dev: removed plugin files and themes (feature #1198)
Rem    pawolf      06/13/2014 - In wwv_flow_page_plugs_dev: changed trigger to clear plug-in attributes if region type has been changed
Rem    arayner     06/24/2014 - Fixed issue in wwv_flow_region_print_dev_iot where content disposition was not being saved
Rem    cneumuel    07/16/2014 - In wwv_flow_company_filestats_dev: use message name in file_type and add file_newest/file_oldest for 4350:85
Rem    cbcho       08/08/2014 - Added navigation_list_position to wwv_flow_steps_dev (feature #1472)
Rem    pawolf      08/11/2014 - Added nav_list_template_options to wwv_flow_steps_dev (feature #1472)
Rem    pawolf      10/08/2014 - Added lov_type FUNCTION_RETURNING_SQL_QUERY to wwv_flow_region_rpt_col_dev and wwv_flow_step_items_dev
Rem    arayner     10/24/2014 - Fixed PCT_GRAPH handling for IR and Classic reports; supports if format mask is just PCT_GRAPH, adds handling for possible # in colour codes (bug #19866013)
Rem    pawolf      11/28/2014 - Added wwv_flow_step_items_dev.grid_label_column_span (feature #1615)
Rem    arayner     11/28/2014 - Added fixed_header to wwv_flow_region_rpt_dev and wwv_flow_region_rpt_dev_iot (feature #1534)
Rem    arayner     12/04/2014 - Added fixed_header_max_height to wwv_flow_region_rpt_dev and wwv_flow_region_rpt_dev_iot (feature #1534)
Rem    pawolf      12/04/2014 - Added grid_column_css_classes to wwv_flow_page_plugs, wwv_flow_step_items and wwv_flow_step_buttons (feature #1466)
Rem    pawolf      12/18/2014 - Always default wwv_flow_page_plugs.plug_query_options to DERIVED_REPORT_COLUMNS (bug #19019257)
Rem    pawolf      12/19/2014 - Fixed wwv_flow_region_rpt_col_dev to work with Date Picker (Classic)
Rem    cneumuel    01/09/2015 - Added wwv_flow_object_owners_dev, wwv_flow_tables_views_dev, wwv_flow_table_columns_dev, wwv_flow_sequences_dev (bug #19829723)
Rem    cneumuel    01/12/2015 - In wwv_flow_tables_views_dev: added object_type, has_date_column. Added wwv_flow_trigger_source_dev (bug #19829723)
Rem    arayner     02/12/2015 - Added static ID to wwv_flow_worksheet_col_dev view and wwv_flow_worksheet_col_dev_iot trigger (feature #1457)
Rem    pawolf      02/19/2015 - In wwv_flow_region_plugin_dev: only return records for plug-ins having additional attributes (bug #20554410)
Rem    pawolf      03/03/2015 - In wwv_flow_page_plugs_dev: changed include_in_reg_disp_sel_yn to be optional (bug #19019646)
Rem    pawolf      03/05/2015 - In wwv_flow_region_rpt_col_dev: don't show hidden Row Selector column as Hidden (save state) (bug #20648442)
Rem    pawolf      03/11/2015 - In wwv_flow_charts5_dev: fixed garbage value in map_center (bug #20681834)
Rem    cneumuel    03/31/2015 - In wwv_flow_tables_views_dev, wwv_flow_table_columns_dev, wwv_flow_sequences_dev: do not escape display columns (bug #20717882)
Rem    pawolf      06/08/2015 - In wwv_flow_charts5_dev: 3d mode for Stacked Column and other chart types was not correctly detected (bug #21214555)
Rem    pawolf      08/10/2015 - In wwv_flow_steps_dev_iot: added a number of defaults to avoid ORA-01407 when updating a Global Page (bug #21605583)
Rem    cbcho       10/27/2015 - Changed wwv_flow_step_items_dev lov_type return value (feature #1215)
Rem    cbcho       10/29/2015 - Added master_region_id in wwv_flow_page_plugs_dev (feature #1215)
Rem    cbcho       11/04/2015 - Changed lov_display_extra, lov_display_null values to Y/N in wwv_flow_step_items_dev, wwv_flow_region_rpt_col_dev (feature #1215)
Rem                           - Added to query wwv_flow_interactive_grids in wwv_flow_region_print_dev (feature #1215)
Rem    hfarrell    11/25/2015 - Added wwv_flow_jet_charts_dev, wwv_flow_jet_series_dev, wwv_flow_jet_axes_dev (feature #1837)
Rem    hfarrell    12/03/2015 - Removed wwv_flow_jet_charts_dev
Rem    hfarrell    01/12/2016 - Updated wwv_flow_jet_series_dev: added series_type_column_mapping, custom_column_mapping
Rem    hfarrell    02/08/2016 - Added min_value to wwv_flow_jet_chart_series table - applied to wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot
Rem    hfarrell    02/11/2016 - Updated wwv_flow_jet_axes_dev_iot, wwv_flow_jet_axes_dev to remove prefix,postfix
Rem    hfarrell    02/12/2016 - Updated wwv_flow_jet_axes_dev_iot, wwv_flow_jet_axes_dev to add format_scaling
Rem    pawolf      02/17/2016 - In wwv_flow_jet_chart_series: changed handling of single chart types (bar, line, ...)
Rem    cbcho       02/18/2016 - Changed wwv_flow_region_rpt_col_dev lov_type return value
Rem    pawolf      02/22/2016 - Added RELOAD_ON_SUBMIT to wwv_flow_steps
Rem    pawolf      04/11/2016 - In wwv_flow_steps: added warn_on_unsaved_changes (feature #1652)
Rem    pawolf      04/13/2016 - In wwv_flow_step_items and wwv_flow_step_buttons: added warn_on_unsaved_changes (feature #1652)
Rem    pawolf      04/22/2016 - Added wwv_flow_ig_columns_dev
Rem    cczarski    05/02/2016 - added item_icon_css_classes for wwv_flow_step_items
Rem    cczarski    05/02/2016 - added inline_help_text for wwv_flow_step_items
Rem    cczarski    06/09/2016 - Add PLUGIN_INIT_JAVASCRIPT_CODE column to WWV_FLOW_STEP_ITEM, WWV_FLOW_PAGE_PLUG (Feature #2018)
Rem    pawolf      06/20/2016 - In wwv_flow_reg_rpt_col_dev_iot: added error if lov_type = pl/sql function (bug #20720798)
Rem    arayner     06/28/2016 - Added wwv_flow_page_da_events_dev (feature #1946)
Rem    arayner     07/04/2016 - In wwv_flow_page_da_events_dev: minor change to select all columns explicitly
Rem    arayner     07/06/2016 - Added wwv_flow_page_da_actions_dev (feature #1946)
Rem    cczarski    07/19/2016 - Added Build Options to Classic Reports, IG and IR columns (feature #1955)
Rem    pawolf      08/29/2016 - In wwv_flow_page_da_events_dev, wwv_flow_page_da_actions_dev: renamed is_ig_region to ig_region_id
Rem    msewtz      03/03/2017 - Added static_id to wwv_flow_region_rpt_col_dev and wwv_flow_reg_rpt_col_dev_iot (bug #20756299)
Rem    pawolf      03/13/2017 - In wwv_flow_page_plugs: added columns for remote sql (feature #2109)
Rem    cczarski    03/31/2017 - Add view WWV_FLOW_CREDENTIAL_DEV and instead-of trigger for client secret encryption (feature #2117)
Rem    cneumuel    03/31/2016 - In wwv_flow_tables_views_dev,wwv_flow_table_columns_dev,wwv_flow_sequences_dev,wwv_flow_trigger_source_dev: changed privilege computation (bug #22067754)
Rem    cczarski    04/05/2017 - Add view WWV_FLOW_REMOTESQL_SERVERS_DEV and instead-of trigger to maintain Remote SQL Data Access servers (feature #2117)
Rem    hfarrell    06/14/2017 - Updated wwv_flow_jet_series_dev: added box plot column mappings for q1, q2, q3, and box_items
Rem    pawolf      06/16/2017 - In wwv_flow_page_plugs_dev: added web_src_module_id
Rem    cneumuel    07/17/2017 - In wwv_flow_objects_dev: union instead of union all (bug #26407890)
Rem    hfarrell    07/19/2017 - Updated wwv_flow_jet_series_dev: removed box plot column mappings for q1, q2, q3, and box_items - simplified mapping to label and value (5.2 feature #2145)
Rem    pawolf      07/28/2017 - Added wwv_flow_page_plugs.optimizer_hint (feature #1107)
Rem    dpeake      08/04/2017 - Replace wwv_flow_tables_views_dev and create wwv_flow_tables_views_dt_dev to improve performance (bug #26572627)
Rem    hfarrell    08/08/2017 - Revised wwv_flow_tables_views_dev and wwv_flow_tables_views_dt_dev to reference sys.dual instead of dual (resolving Hudson build issue)
Rem    hfarrell    08/10/2017 - In wwv_flow_jet_series_dev: added q2_color, q3_color
Rem    pawolf      08/11/2017 - Removed FNC_REPORT native plug-in
Rem    dpeake      08/18/2017 - Update wwv_flow_tables_views_dev and removed wwv_flow_tables_views_dt_dev (bug #26572627)
Rem    pawolf      08/25/2017 - Added wwv_flow_page_plugs.include_rowid_column (feature #2109)
Rem    cczarski    09/25/2017 - Added HTTPS_HOST column to wwv_flow_remotesql_servers_dev (feature #2109)
Rem    cczarski    10/06/2017 - Added ords_timezone column to wwv_flow_remotesql_servers_dev (feature #2109)
Rem    cczarski    11/14/2017 - change wwv_flow_credentials to store credentials at workspace level (feature #2109, #2092)
Rem    cczarski    11/15/2017 - change wwv_flow_remote_servers to store remote servers at workspace level (feature #2109, #2092)
Rem    hfarrell    11/15/2017 - Added Chart Remote SQL support to wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot (feature #2109)
Rem    hfarrell    11/22/2017 - Added Gantt chart support to wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot (feature #2126)
Rem    hfarrell    11/23/2017 - Updated wwv_flow_jet_series_dev_iot - removed comma typo
Rem    cczarski    12/04/2017 - Added wwv_flow_jet_series_dev.aggregate_function and .include_rowid_column (feature #2235)
Rem    cneumuel    12/13/2017 - Moved wwv_flow_data_view from view.sql and added item_value_decrypted (bug #26880410)
Rem    hfarrell    12/14/2017 - wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot: updated to remove start_date_value and end_date_value, unrequired columns; added viewport columns
Rem    cczarski    12/19/2017 - wwv_flow_jet_series_dev and wwv_flow_page_plugs_dev: Added source_post_processing, external_filter_expr and external_order_by_expr
Rem    hfarrell    01/08/2018 - In applied to wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot: added support for gantt css classes
Rem    hfarrell    01/16/2018 - In wwv_flow_jet_series_dev and wwv_flow_jet_series_dev_iot: added items_label_display_as column
Rem    sbkenned    01/30/2018 - added wwv_flow_scheduler_jobs_dev for use by Scheduler Job Monitoring add page feature (feature 2284)
Rem    sbkenned    05/08/2018 - updated wwv_flow_jobs_dev to use sys.dba_scheduler_jobs to improve performance (bug 27987552)
Rem    pawolf      05/28/2018 - In wwv_flow_reg_rpt_col_dev_iot: always expose disable_sort_column (bug #28088414)

set define '^'

prompt creating dev views

--==============================================================================
prompt ...wwv_flow_ui_types_dev
create or replace force view wwv_flow_ui_types_dev
as
select id,
       name,
       case
         when security_group_id is null then wwv_flow_lang.system_message('UI_TYPE.' || name)
         else name
       end as display_name,
       based_on_ui_type_id,
       autodetect_js_file_urls,
       autodetect_js_function_body,
       autodetect_plsql_function_body,
       security_group_id,
       created_by,
       created_on,
       last_updated_by,
       last_updated_on
  from wwv_flow_ui_types
 where (  security_group_id is null
       or security_group_id = ( select nv('WORKSPACE_ID') from sys.dual ))
/

--==============================================================================
prompt ...wwv_flow_search_result_dev
create or replace view wwv_flow_search_result_dev
as
select n001    as flow_id,
       c001    as path,
       c002    as order_value,
       c003    as attribute_name,
       clob001 as attribute_value,
       c004    as link_url,
       c040    as page_id,
       c041    as component_type_id,
       c042    as component_id
  from wwv_flow_collections
 where collection_name = 'FLOW_SEARCH_RESULT'
/

--==============================================================================
prompt ...wwv_flow_advisor_result_dev
create or replace view wwv_flow_advisor_result_dev
as
select n001    as flow_id,
       c001    as path,
       c002    as order_value,
       c003    as attribute_name,
       clob001 as attribute_value,
       c004    as link_url,
       c040    as page_id,
       c041    as component_type_id,
       c042    as component_id,
       c005    as check_description,
       c006    as category_description,
       c007    as message_text,
       c008    as help_text,
       n002    as category_id,
       n003    as check_id
  from wwv_flow_collections
 where collection_name = 'FLOW_ADVISOR_RESULT'
/

--==============================================================================
-- view for web service operations to workaround missing flow_id in table.
--==============================================================================
prompt ...wwv_flow_ws_operations_dev
create or replace view wwv_flow_ws_operations_dev
as
select o.*,
       ws.flow_id,
       ws.name || ' - ' || o.name as full_name
  from wwv_flow_ws_operations o,
       wwv_flow_shared_web_services ws
 where o.security_group_id  = (select nv( 'WORKSPACE_ID' ) from sys.dual )
   and ws.id                = o.ws_id
   and ws.security_group_id = o.security_group_id
/

--==============================================================================
-- view for web service operations to workaround missing flow_id in table.
--==============================================================================
prompt ...wwv_flow_ws_oper_param_dev
create or replace view wwv_flow_ws_oper_param_dev
as
select p.id,
       ws.flow_id,
       ws_opers_id,
       case
         when p.input_or_output='A' and p.name='username' then
           wwv_flow_lang.system_message('ACCESS_CONTROL_USERNAME')
         when p.input_or_output='A' and p.name='password' then
           wwv_flow_lang.system_message('PASSWORD')
         else
           p.name
       end as name,
       p.input_or_output,
       p.parm_type,
       p.path,
       p.type_is_xsd,
       p.form_qualified,
       p.parent_id,
       p.security_group_id,
       p.last_updated_by,
       p.last_updated_on
  from wwv_flow_ws_parameters p,
       wwv_flow_ws_operations o,
       wwv_flow_shared_web_services ws
 where p.security_group_id  = (select nv( 'WORKSPACE_ID' ) from sys.dual )
   and o.id                 = p.ws_opers_id
   and ws.id                = o.ws_id
   and ws.security_group_id = o.security_group_id
/

--==============================================================================
-- view+iot for page process web service parameters
-- the trigger only supports update on (parameter_value, map_type). all other
-- columns are read only.
--==============================================================================
prompt ...wwv_flow_page_proc_ws_parm_dev
create or replace view wwv_flow_page_proc_ws_parm_dev (
    id,
    wspm_exists,
    --
    security_group_id,
    flow_id,
    page_id,
    process_id,
    parameter_id,
    --
    parameter_type, -- (I)nput, (O)utput, (A)uthentication, (H)eader
    parameter_name,
    parameter_value,
    map_type,       -- ITEM, STATIC, FUNCTION, COLLECTION
    last_updated_by,
    last_updated_on
) as
select coalesce( wspm.id, ora_hash( proc.id || '-' || wsp.id )) as id,
       case when wspm.id is null then 'N' else 'Y' end as wspm_exists,
       --
       proc.security_group_id,
       proc.flow_id,
       proc.flow_step_id,
       proc.id,
       wsp.id,
       --
       wsp.input_or_output,
       case
         when wsp.input_or_output='A' and wsp.name='username' then
           wwv_flow_lang.system_message('ACCESS_CONTROL_USERNAME')
         when wsp.input_or_output='A' and wsp.name='password' then
           wwv_flow_lang.system_message('PASSWORD')
         else
           wsp.name
       end,
       wspm.parm_value,
       wspm.map_type,
       wspm.last_updated_by,
       wspm.last_updated_on
  from wwv_flow_step_processing      proc,
       wwv_flow_ws_operations        wso,
       wwv_flow_ws_parameters        wsp,
       wwv_flow_ws_process_parms_map wspm
 where proc.process_type      = 'NATIVE_WEB_SERVICE_LEGACY'
   and proc.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and proc.attribute_01      = to_char(wso.ws_id)
   and proc.security_group_id = wso.security_group_id
   and wso.id                 = wsp.ws_opers_id
   and wso.security_group_id  = wsp.security_group_id
   -- Don't include out parameters if result is stored in a collection and they don't exist
   -- We need the out parameter to be able to delete them first when switching to page items
   and (  wsp.input_or_output <> 'O'
       or proc.attribute_02 = 'ITEMS' /* result stored in */
       or ( proc.attribute_02 = 'COLLECTION' and wsp.input_or_output = 'O' and wspm.id is not null )
       )
   and proc.id                = wspm.process_id(+)
   and proc.security_group_id = wspm.security_group_id(+)
   and (wspm.id is null or wspm.parameter_id = wsp.id)
union all
select coalesce( wspm.id, ora_hash( wsp.process_id || '-' || wsp.parameter_id )) as id,
       case when wspm.id is null then 'N' else 'Y' end as wspm_exists,
       --
       wsp.security_group_id,
       wsp.flow_id,
       wsp.page_id,
       wsp.process_id,
       wsp.parameter_id,
       wsp.parameter_type,
       wsp.parameter_name,
       wspm.parm_value,
       coalesce(
           wspm.map_type,
           case when wsp.parameter_type = 'O' then 'ITEM' else 'STATIC' end) as map_type,
       wspm.last_updated_by,
       wspm.last_updated_on
  from ( select proc.id             as process_id,
                proc.security_group_id,
                proc.flow_id,
                proc.flow_step_id   as page_id,
                proc.attribute_02   as store_result_in,
                wsp.id              as parameter_id,
                wsp.input_or_output as parameter_type,
                case
                  when wsp.input_or_output='A' and wsp.name='username' then
                    wwv_flow_lang.system_message('ACCESS_CONTROL_USERNAME')
                  when wsp.input_or_output='A' and wsp.name='password' then
                    wwv_flow_lang.system_message('PASSWORD')
                  else
                    wsp.name
                end as parameter_name
           from wwv_flow_step_processing proc,
                wwv_flow_ws_operations   wso,
                wwv_flow_ws_parameters   wsp
          where proc.process_type      = 'NATIVE_WEB_SERVICE'
            and proc.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
            and to_char(wso.id)        = proc.attribute_01
            and wso.security_group_id  = proc.security_group_id
            and wsp.ws_opers_id        = wso.id
            and wsp.security_group_id  = wso.security_group_id
       ) wsp,
       wwv_flow_ws_process_parms_map wspm
 where wspm.process_id(+)        = wsp.process_id
   and wspm.parameter_id(+)      = wsp.parameter_id
   and wspm.security_group_id(+) = wsp.security_group_id
   -- Don't include out parameters if result is stored in a collection and they don't exist
   -- We need the out parameter to be able to delete them first when switching to page items
   and (  wsp.parameter_type <> 'O'
       or wsp.store_result_in = 'ITEMS'
       or ( wsp.store_result_in = 'COLLECTION' and wsp.parameter_type = 'O' and wspm.id is not null )
       )
/
create or replace trigger wwv_flow_pproc_ws_parm_dev_iot
instead of insert or update or delete
on wwv_flow_page_proc_ws_parm_dev
for each row
begin
    if inserting then
        -- If it's a real insert we use the id provided, because it's generated on the client using wwv_flow_id.nextval
        insert into wwv_flow_ws_process_parms_map (
            id,
            parameter_id,
            process_id,
            map_type,
            parm_value )
        values (
            :new.id,
            :new.parameter_id,
            :new.process_id,
            :new.map_type,
            :new.parameter_value );
    elsif updating then
        if nvl( :new.wspm_exists, 'N' ) = 'N' then
            -- It's a fake insert, we can't use the existing hashed id. Let's get a new one
            insert into wwv_flow_ws_process_parms_map (
                parameter_id,
                process_id,
                map_type,
                parm_value )
            values (
                :new.parameter_id,
                :new.process_id,
                :new.map_type,
                :new.parameter_value );
        else
            update wwv_flow_ws_process_parms_map
               set parm_value = :new.parameter_value,
                   map_type   = :new.map_type
             where id                = :old.id
               and process_id        = :old.process_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        end if;
    elsif deleting then
        delete wwv_flow_ws_process_parms_map
         where id                = :old.id
           and process_id        = :old.process_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/


--==============================================================================
-- view+iot for ir column groups to workaround missing page_id in table.
--==============================================================================
prompt ...wwv_flow_worksheet_col_grp_dev
create or replace view wwv_flow_worksheet_col_grp_dev
as
select g.id,
       g.security_group_id,
       g.flow_id,
       w.page_id,
       g.worksheet_id,
       g.name,
       g.description,
       g.display_sequence,
       g.updated_on,
       g.updated_by
  from wwv_flow_worksheet_col_groups g,
       wwv_flow_worksheets w
 where w.id = g.worksheet_id
   and g.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_work_col_grp_dev_iot
instead of insert or update or delete
on wwv_flow_worksheet_col_grp_dev
for each row
begin
    if inserting then
        insert into wwv_flow_worksheet_col_groups (
            id,
            security_group_id,
            flow_id,
            worksheet_id,
            name,
            description,
            display_sequence )
        values (
            :new.id,
            wwv_flow_security.g_security_group_id,
            :new.flow_id,
            :new.worksheet_id,
            :new.name,
            :new.description,
            :new.display_sequence );
    elsif updating then
        update wwv_flow_worksheet_col_groups
           set name             = :new.name,
               description      = :new.description,
               display_sequence = :new.display_sequence
         where id                = :new.id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete wwv_flow_worksheet_col_groups
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
--==============================================================================
-- view+iot for ir saved reports.
--==============================================================================
prompt ...wwv_flow_worksheet_rpts_dev
create or replace view wwv_flow_worksheet_rpts_dev
as
select r.id,
       r.security_group_id,
       r.flow_id,
       r.page_id,
       w.region_id,
       r.worksheet_id,
       case
         when r.is_default = 'Y' and r.application_user = 'APXWS_DEFAULT' then wwv_flow_lang.system_message( 'SAVED_REPORTS.PRIMARY_REPORT' )
         else r.name
       end as name,
       r.report_alias,
       case
         when r.is_default = 'Y' and r.application_user = 'APXWS_DEFAULT'        then 'PRIMARY_DEFAULT'
         when r.is_default = 'Y' and r.application_user = 'APXWS_ALTERNATIVE'    then 'ALTERNATIVE_DEFAULT'
         when r.is_default = 'N' and r.status = 'PUBLIC'  and r.session_id is null then 'PUBLIC'
         when r.is_default = 'N' and r.status = 'PRIVATE' and r.session_id is null then 'PRIVATE'
       end as visibility,
       case when r.report_alias is not null then
           'f?p=' || chr( 38 ) || 'APP_ID.:' || r.page_id || ':' || chr( 38 ) || 'APP_SESSION.:IR' ||
           case when p.region_name is not null then
             '[' || p.region_name || ']'
           end|| '_' || r.report_alias
       end as link_example,
       -- audit
       r.created_on,
       r.created_by,
       r.updated_on,
       r.updated_by
  from wwv_flow_worksheet_rpts r,
       wwv_flow_worksheets w,
       wwv_flow_page_plugs p
 where r.worksheet_id = w.id
 and w.region_id = p.id
 and r.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_w_sheet_rpts_dev_iot
instead of update
on wwv_flow_worksheet_rpts_dev
for each row
begin
    update wwv_flow_worksheet_rpts
       set report_alias = :new.report_alias
     where id                = :old.id
       and flow_id           = :old.flow_id
       and security_group_id = wwv_flow_security.g_security_group_id;
end;
/
--==============================================================================
-- view for page to add additional virtual columns.
--==============================================================================
prompt ...wwv_flow_steps_dev
create or replace view wwv_flow_steps_dev
as
select p.*,
       case when p.id = ui.global_page_id then 'Y' else 'N' end as is_global_page,
       t.navigation_type
  from wwv_flow_steps p,
       wwv_flow_user_interfaces ui,
       wwv_flow_themes t
 where p.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and ui.id               = p.user_interface_id
   and t.flow_id           = ui.flow_id
   and t.theme_id          = ui.theme_id
/
create or replace trigger wwv_flow_steps_dev_iot
instead of update or delete
on wwv_flow_steps_dev
for each row
begin
    -- Insert not yet needed
    if updating then
        update wwv_flow_steps
           set name                        = :new.name,
               alias                       = :new.alias,
               step_title                  = :new.step_title,
               group_id                    = :new.group_id,
               page_mode                   = nvl( :new.page_mode, 'NORMAL' ),
               step_template               = :new.step_template,
               page_template_options       = :new.page_template_options,
               page_css_classes            = :new.page_css_classes,
               dialog_width                = :new.dialog_width,
               dialog_height               = :new.dialog_height,
               dialog_max_width            = :new.dialog_max_width,
               dialog_attributes           = :new.dialog_attributes,
               dialog_css_classes          = :new.dialog_css_classes,
               dialog_chained              = :new.dialog_chained,
               overwrite_navigation_list   = nvl( :new.overwrite_navigation_list, 'N' ),
               navigation_list_id          = :new.navigation_list_id,
               navigation_list_position    = :new.navigation_list_position,
               navigation_list_template_id = :new.navigation_list_template_id,
               nav_list_template_options   = :new.nav_list_template_options,
               tab_set                     = :new.tab_set,
               first_item                  = :new.first_item,
               page_transition             = :new.page_transition,
               popup_transition            = :new.popup_transition,
               media_type                  = :new.media_type,
               javascript_file_urls        = :new.javascript_file_urls,
               javascript_code             = :new.javascript_code,
               javascript_code_onload      = :new.javascript_code_onload,
               include_apex_css_js_yn      = :new.include_apex_css_js_yn,
               css_file_urls               = :new.css_file_urls,
               inline_css                  = :new.inline_css,
               html_page_header            = :new.html_page_header,
               html_page_onload            = :new.html_page_onload,
               welcome_text                = :new.welcome_text,
               box_welcome_text            = :new.box_welcome_text,
               footer_text                 = :new.footer_text,
               read_only_when_type         = :new.read_only_when_type,
               read_only_when              = :new.read_only_when,
               read_only_when2             = :new.read_only_when2,
               required_role               = :new.required_role,
               page_is_public_y_n          = nvl( :new.page_is_public_y_n, 'N' ),
               rejoin_existing_sessions    = :new.rejoin_existing_sessions,
               deep_linking                = :new.deep_linking,
               protection_level            = nvl( :new.protection_level, 'D' ),
               autocomplete_on_off         = nvl( :new.autocomplete_on_off, 'OFF' ),
               browser_cache               = :new.browser_cache,
               allow_duplicate_submissions = nvl( :new.allow_duplicate_submissions, 'Y' ),
               on_dup_submission_goto_url  = :new.on_dup_submission_goto_url,
               reload_on_submit            = nvl( :new.reload_on_submit, 'S' ),
               warn_on_unsaved_changes     = :new.warn_on_unsaved_changes,
               cache_mode                  = nvl( :new.cache_mode, 'NOCACHE' ),
               cache_timeout_seconds       = :new.cache_timeout_seconds,
               cache_when_condition_type   = :new.cache_when_condition_type,
               cache_when_condition_e1     = :new.cache_when_condition_e1,
               cache_when_condition_e2     = :new.cache_when_condition_e2,
               required_patch              = :new.required_patch,
               error_notification_text     = :new.error_notification_text,
               error_handling_function     = :new.error_handling_function,
               help_text                   = :new.help_text,
               page_comment                = :new.page_comment
         where id                = :new.id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete wwv_flow_steps
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
--==============================================================================
-- view+iot for region to swap translate_title column.
--==============================================================================
prompt ...wwv_flow_page_plugs_dev
create or replace view wwv_flow_page_plugs_dev
as
select id,
       security_group_id,
       flow_id,
       page_id,
       plug_name,
       plug_source_type,
       location,
       remote_server_id,
       web_src_module_id,
       query_type,
       plug_source,
       query_owner,
       query_table,
       query_where,
       query_order_by,
       source_post_processing,
       include_rowid_column,
       optimizer_hint,
       remote_sql_caching,
       remote_sql_invalidate_when,
       external_filter_expr,
       external_order_by_expr,
       list_id,
       menu_id,
       ajax_items_to_submit,
       plug_query_parse_override,
       plug_query_options,
       plug_query_max_columns,
       plug_display_sequence,
       parent_plug_id,
       master_region_id,
       plug_display_point,
       plug_template,
       region_template_options,
       region_css_classes,
       icon_css_classes,
       plug_item_display_point,
       plug_new_grid,
       plug_new_grid_row,
       plug_display_column,
       plug_new_grid_column,
       plug_grid_column_span,
       plug_grid_column_css_classes,
       plug_column_width,
       region_name,
       region_attributes_substitution,
       region_image,
       region_image_attr,
       include_in_reg_disp_sel_yn,
       case when translate_title = 'N' then 'Y' else 'N' end as exclude_title_from_translation,
       plug_header,
       plug_footer,
       plug_display_condition_type,
       plug_display_when_condition,
       plug_display_when_cond2,
       plug_read_only_when_type,
       plug_read_only_when,
       plug_read_only_when2,
       plug_required_role,
       escape_on_http_output,
       required_patch,
       plug_caching,
       plug_caching_max_age_in_sec,
       plug_cache_depends_on_items,
       plug_cache_when,
       plug_cache_expression1,
       plug_cache_expression2,
       plug_customized,
       plug_customized_name,
       plug_comment,
       --
       last_updated_by,
       last_updated_on
  from wwv_flow_page_plugs
 where security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_page_plugs_dev_iot
instead of insert or update or delete
on wwv_flow_page_plugs_dev
for each row
begin
    if inserting then
        insert into wwv_flow_page_plugs (
            id,
            security_group_id,
            flow_id,
            page_id,
            plug_name,
            plug_source_type,
            location,
            remote_server_id,
            web_src_module_id,
            query_type,
            plug_source,
            query_owner,
            query_table,
            query_where,
            query_order_by,
            source_post_processing,
            include_rowid_column,
            optimizer_hint,
            remote_sql_caching,
            remote_sql_invalidate_when,
            external_filter_expr,
            external_order_by_expr,
            list_id,
            menu_id,
            ajax_items_to_submit,
            plug_query_parse_override,
            plug_query_options,
            plug_query_max_columns,
            plug_display_sequence,
            parent_plug_id,
            master_region_id,
            plug_display_point,
            plug_template,
            region_template_options,
            region_css_classes,
            icon_css_classes,
            plug_item_display_point,
            plug_new_grid,
            plug_new_grid_row,
            plug_display_column,
            plug_new_grid_column,
            plug_grid_column_span,
            plug_grid_column_css_classes,
            plug_column_width,
            region_name,
            region_attributes_substitution,
            region_image,
            region_image_attr,
            include_in_reg_disp_sel_yn,
            translate_title,
            plug_header,
            plug_footer,
            plug_display_condition_type,
            plug_display_when_condition,
            plug_display_when_cond2,
            plug_read_only_when_type,
            plug_read_only_when,
            plug_read_only_when2,
            plug_required_role,
            escape_on_http_output,
            required_patch,
            plug_caching,
            plug_caching_max_age_in_sec,
            plug_cache_depends_on_items,
            plug_cache_when,
            plug_cache_expression1,
            plug_cache_expression2,
            plug_customized,
            plug_customized_name,
            plug_comment)
        values (
            :new.id,
            wwv_flow_security.g_security_group_id,
            :new.flow_id,
            :new.page_id,
            :new.plug_name,
            :new.plug_source_type,
            :new.location,
            :new.remote_server_id,
            :new.web_src_module_id,
            :new.query_type,
            :new.plug_source,
            :new.query_owner,
            :new.query_table,
            :new.query_where,
            :new.query_order_by,
            :new.source_post_processing,
            :new.include_rowid_column,
            :new.optimizer_hint,
            :new.remote_sql_caching,
            :new.remote_sql_invalidate_when,
            :new.external_filter_expr,
            :new.external_order_by_expr,
            :new.list_id,
            :new.menu_id,
            :new.ajax_items_to_submit,
            :new.plug_query_parse_override,
            nvl( :new.plug_query_options, 'DERIVED_REPORT_COLUMNS' ),
            :new.plug_query_max_columns,
            :new.plug_display_sequence,
            :new.parent_plug_id,
            :new.master_region_id,
            :new.plug_display_point,
            :new.plug_template,
            :new.region_template_options,
            :new.region_css_classes,
            :new.icon_css_classes,
            :new.plug_item_display_point,
            :new.plug_new_grid,
            :new.plug_new_grid_row,
            :new.plug_display_column,
            :new.plug_new_grid_column,
            :new.plug_grid_column_span,
            :new.plug_grid_column_css_classes,
            :new.plug_column_width,
            :new.region_name,
            :new.region_attributes_substitution,
            :new.region_image,
            :new.region_image_attr,
            nvl( :new.include_in_reg_disp_sel_yn, 'N' ),
            case when :new.exclude_title_from_translation = 'Y' then 'N' else 'Y' end,
            :new.plug_header,
            :new.plug_footer,
            :new.plug_display_condition_type,
            :new.plug_display_when_condition,
            :new.plug_display_when_cond2,
            :new.plug_read_only_when_type,
            :new.plug_read_only_when,
            :new.plug_read_only_when2,
            :new.plug_required_role,
            :new.escape_on_http_output,
            :new.required_patch,
            :new.plug_caching,
            :new.plug_caching_max_age_in_sec,
            :new.plug_cache_depends_on_items,
            :new.plug_cache_when,
            :new.plug_cache_expression1,
            :new.plug_cache_expression2,
            :new.plug_customized,
            :new.plug_customized_name,
            :new.plug_comment);
    elsif updating then
        update wwv_flow_page_plugs
           set plug_name                      = :new.plug_name,
               plug_source_type               = :new.plug_source_type,
               location                       = :new.location,
               remote_server_id               = :new.remote_server_id,
               web_src_module_id              = :new.web_src_module_id,
               query_type                     = :new.query_type,
               plug_source                    = :new.plug_source,
               query_owner                    = :new.query_owner,
               query_table                    = :new.query_table,
               query_where                    = :new.query_where,
               query_order_by                 = :new.query_order_by,
               source_post_processing         = :new.source_post_processing,
               include_rowid_column           = :new.include_rowid_column,
               optimizer_hint                 = :new.optimizer_hint,
               remote_sql_caching             = :new.remote_sql_caching,
               remote_sql_invalidate_when     = :new.remote_sql_invalidate_when,
               external_filter_expr           = :new.external_filter_expr,
               external_order_by_expr         = :new.external_order_by_expr,
               list_id                        = :new.list_id,
               menu_id                        = :new.menu_id,
               ajax_items_to_submit           = :new.ajax_items_to_submit,
               plug_query_parse_override      = :new.plug_query_parse_override,
               plug_query_options             = nvl( :new.plug_query_options, 'DERIVED_REPORT_COLUMNS' ),
               plug_query_max_columns         = :new.plug_query_max_columns,
               plug_display_sequence          = :new.plug_display_sequence,
               parent_plug_id                 = :new.parent_plug_id,
               master_region_id               = :new.master_region_id,
               plug_display_point             = :new.plug_display_point,
               plug_template                  = :new.plug_template,
               region_template_options        = :new.region_template_options,
               region_css_classes             = :new.region_css_classes,
               icon_css_classes               = :new.icon_css_classes,
               plug_item_display_point        = :new.plug_item_display_point,
               plug_new_grid                  = :new.plug_new_grid,
               plug_new_grid_row              = :new.plug_new_grid_row,
               plug_display_column            = :new.plug_display_column,
               plug_new_grid_column           = :new.plug_new_grid_column,
               plug_grid_column_span          = :new.plug_grid_column_span,
               plug_grid_column_css_classes   = :new.plug_grid_column_css_classes,
               plug_column_width              = :new.plug_column_width,
               region_name                    = :new.region_name,
               region_attributes_substitution = :new.region_attributes_substitution,
               region_image                   = :new.region_image,
               region_image_attr              = :new.region_image_attr,
               include_in_reg_disp_sel_yn     = nvl( :new.include_in_reg_disp_sel_yn, 'N' ),
               translate_title                = case when :new.exclude_title_from_translation = 'Y' then 'N' else 'Y' end,
               plug_header                    = :new.plug_header,
               plug_footer                    = :new.plug_footer,
               plug_display_condition_type    = :new.plug_display_condition_type,
               plug_display_when_condition    = :new.plug_display_when_condition,
               plug_display_when_cond2        = :new.plug_display_when_cond2,
               plug_read_only_when_type       = :new.plug_read_only_when_type,
               plug_read_only_when            = :new.plug_read_only_when,
               plug_read_only_when2           = :new.plug_read_only_when2,
               plug_required_role             = :new.plug_required_role,
               escape_on_http_output          = :new.escape_on_http_output,
               required_patch                 = :new.required_patch,
               plug_caching                   = :new.plug_caching,
               plug_caching_max_age_in_sec    = :new.plug_caching_max_age_in_sec,
               plug_cache_depends_on_items    = :new.plug_cache_depends_on_items,
               plug_cache_when                = :new.plug_cache_when,
               plug_cache_expression1         = :new.plug_cache_expression1,
               plug_cache_expression2         = :new.plug_cache_expression2,
               plug_customized                = :new.plug_customized,
               plug_customized_name           = :new.plug_customized_name,
               plug_comment                   = :new.plug_comment
         where id                = :new.id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;

        -- If the region type changes, we clear all plug-in, classic report, tabular form and print attributes.
        -- They will be set by updating wwv_flow_region_plugin_dev/wwv_flow_region_rpt_dev/... This is necessary, because
        -- wwv_flow_region_plugin_dev and wwv_flow_region_rpt_dev are just a wrapper on
        -- wwv_flow_page_plugs which returns the plug-in/report attributes. In the case if the
        -- region type is updated, the check for update check on wwv_flow_region_plugin_dev will fail with
        -- "Changed by other user" because that already returns the new region type,
        -- but still the old plug-in attribute values which look like plug-in attribute
        -- values of the new region type.
        if :new.plug_source_type <> :old.plug_source_type then
            update wwv_flow_page_plugs
                   -- from wwv_flow_region_plugin_dev
               set plugin_init_javascript_code = null,
                   attribute_01 = null,
                   attribute_02 = null,
                   attribute_03 = null,
                   attribute_04 = null,
                   attribute_05 = null,
                   attribute_06 = null,
                   attribute_07 = null,
                   attribute_08 = null,
                   attribute_09 = null,
                   attribute_10 = null,
                   attribute_11 = null,
                   attribute_12 = null,
                   attribute_13 = null,
                   attribute_14 = null,
                   attribute_15 = null,
                   attribute_16 = null,
                   attribute_17 = null,
                   attribute_18 = null,
                   attribute_19 = null,
                   attribute_20 = null,
                   attribute_21 = null,
                   attribute_22 = null,
                   attribute_23 = null,
                   attribute_24 = null,
                   attribute_25 = null,
                   list_template_id           = null,
                   menu_template_id           = null,
                   component_template_options = null,
                   region_sub_css_classes     = null,
                   plug_query_headings_type   = null,
                   plug_query_headings        = null,
                   plug_query_num_rows        = null,
                   plug_query_num_rows_item   = null,
                   plug_query_no_data_found   = null,
                   -- From wwv_flow_region_rpt_dev
                   plug_query_row_template        = null,
                   plug_query_num_rows_type       = null,
                   plug_query_more_data           = null,
                   plug_query_row_count_max       = null,
                   plug_query_show_nulls_as       = null,
                   plug_query_break_cols          = null,
                   plug_query_exp_filename        = null,
                   plug_query_exp_separator       = null,
                   plug_query_exp_enclosed_by     = null,
                   plug_query_strip_html          = null,
                   report_total_text_format       = null,
                   break_column_text_format       = null,
                   break_before_row               = null,
                   break_generic_column           = null,
                   break_after_row                = null,
                   break_type_flag                = null,
                   break_repeat_heading_format    = null,
                   csv_output                     = null,
                   csv_output_link_text           = null,
                   print_url                      = null,
                   print_url_label                = null,
                   prn_output                     = null,
                   report_attributes_substitution = null,
                   pagination_display_position    = null,
                   ajax_enabled                   = null,
                   sort_null                      = null,
                   fixed_header                   = null,
                   fixed_header_max_height        = null,
                   -- from wwv_flow_region_print_dev
                   prn_output_link_text        = null,
                   prn_output_file_name        = null,
                   prn_format                  = null,
                   prn_format_item             = null,
                   prn_template_id             = null,
                   prn_width_units             = null,
                   prn_print_server_overwrite  = null,
                   prn_content_disposition     = null,
                   prn_document_header         = null,
                   prn_units                   = null,
                   prn_paper_size              = null,
                   prn_width                   = null,
                   prn_orientation             = null,
                   prn_height                  = null,
                   prn_border_width            = null,
                   prn_border_color            = null,
                   prn_page_header_font_family = null,
                   prn_page_header_font_weight = null,
                   prn_page_header_font_size   = null,
                   prn_page_header_font_color  = null,
                   prn_page_header_alignment   = null,
                   prn_page_header             = null,
                   prn_header_font_family      = null,
                   prn_header_font_weight      = null,
                   prn_header_font_size        = null,
                   prn_header_font_color       = null,
                   prn_header_bg_color         = null,
                   prn_body_font_family        = null,
                   prn_body_font_weight        = null,
                   prn_body_font_size          = null,
                   prn_body_font_color         = null,
                   prn_body_bg_color           = null,
                   prn_page_footer_font_family = null,
                   prn_page_footer_font_weight = null,
                   prn_page_footer_font_size   = null,
                   prn_page_footer_font_color  = null,
                   prn_page_footer_alignment   = null,
                   prn_page_footer             = null
             where id                = :new.id
               and flow_id           = :new.flow_id
               and security_group_id = wwv_flow_security.g_security_group_id;
            -- Just to be save we should also clear all child report/region columns
            if :old.plug_source_type in ( 'NATIVE_SQL_REPORT', 'NATIVE_TABFORM' ) then
                delete wwv_flow_region_report_column
                 where region_id         = :new.id
                   and flow_id           = :old.flow_id
                   and security_group_id = wwv_flow_security.g_security_group_id;
            else
                delete wwv_flow_region_columns
                 where region_id         = :new.id
                   and flow_id           = :old.flow_id
                   and security_group_id = wwv_flow_security.g_security_group_id;
            end if;
        end if;
    elsif deleting then
        delete wwv_flow_page_plugs
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
--==============================================================================
-- view+iot for classic reports to have report specific columns in it's own "table".
--==============================================================================
prompt ...wwv_flow_region_rpt_dev
create or replace view wwv_flow_region_rpt_dev
as
select id,
       id as region_id,
       security_group_id,
       flow_id,
       page_id,
       plug_source_type,
       case
         when plug_query_row_template in ( '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22' ) then 'PREDEFINED'
         else 'THEME'
       end as template_type,
       plug_query_row_template,
       component_template_options,
       region_sub_css_classes,
       nvl( plug_query_headings_type, 'COLON_DELMITED_LIST' ) as plug_query_headings_type,
       plug_query_headings,
       case
         when plug_query_num_rows_type = '0' then null
         else plug_query_num_rows_type
       end as plug_query_num_rows_type,
       case
         when plug_query_num_rows_item is not null then 'ITEM'
         else 'STATIC'
       end as number_of_rows_type,
       nvl( plug_query_num_rows, 15 ) as plug_query_num_rows,
       plug_query_num_rows_item,
       plug_query_no_data_found,
       plug_query_more_data,
       plug_query_row_count_max,
       plug_query_show_nulls_as,
       case
         when plug_query_break_cols = '0' then null
         else plug_query_break_cols
       end as plug_query_break_cols,
       plug_query_exp_filename,
       plug_query_exp_separator,
       plug_query_exp_enclosed_by,
       nvl( plug_query_strip_html, 'Y' ) as plug_query_strip_html,
       --
       report_total_text_format,
       break_column_text_format,
       break_before_row,
       break_generic_column,
       break_after_row,
       break_type_flag,
       break_repeat_heading_format,
       nvl( csv_output, 'N' ) as csv_output,
       csv_output_link_text,
       case
         when print_url is not null then 'Y'
         else 'N'
       end print_enabled,
       print_url,
       print_url_label,
       nvl( prn_output, 'N' ) as prn_output,
       --
       report_attributes_substitution,
       nvl( case
              when pagination_display_position = '0' then null
              else pagination_display_position
            end, 'BOTTOM_RIGHT' ) as pagination_display_position,
       nvl( ajax_enabled, 'N' ) as ajax_enabled,
       nvl( sort_null, 'L' ) as sort_null,
       fixed_header,
       fixed_header_max_height
  from wwv_flow_page_plugs
 where security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_region_rpt_dev_iot
instead of insert or update or delete
on wwv_flow_region_rpt_dev
for each row
begin
    if inserting or updating then
        -- !!!!!!!!!!!!
        -- NOTE! Keep in sync with the set to NULL update in wwv_flow_page_plugs_dev
        -- !!!!!!!!!!!!
        update wwv_flow_page_plugs
           set plug_query_row_template        = :new.plug_query_row_template,
               component_template_options     = :new.component_template_options,
               region_sub_css_classes         = :new.region_sub_css_classes,
               plug_query_headings            = :new.plug_query_headings,
               plug_query_headings_type       = :new.plug_query_headings_type,
               plug_query_num_rows            = :new.plug_query_num_rows,
               plug_query_num_rows_type       = :new.plug_query_num_rows_type,
               plug_query_num_rows_item       = :new.plug_query_num_rows_item,
               plug_query_no_data_found       = :new.plug_query_no_data_found,
               plug_query_more_data           = :new.plug_query_more_data,
               plug_query_row_count_max       = :new.plug_query_row_count_max,
               plug_query_show_nulls_as       = :new.plug_query_show_nulls_as,
               plug_query_break_cols          = :new.plug_query_break_cols,
               plug_query_exp_filename        = :new.plug_query_exp_filename,
               plug_query_exp_separator       = :new.plug_query_exp_separator,
               plug_query_exp_enclosed_by     = :new.plug_query_exp_enclosed_by,
               plug_query_strip_html          = :new.plug_query_strip_html,
               report_total_text_format       = :new.report_total_text_format,
               break_column_text_format       = :new.break_column_text_format,
               break_before_row               = :new.break_before_row,
               break_generic_column           = :new.break_generic_column,
               break_after_row                = :new.break_after_row,
               break_type_flag                = :new.break_type_flag,
               break_repeat_heading_format    = :new.break_repeat_heading_format,
               csv_output                     = :new.csv_output,
               csv_output_link_text           = :new.csv_output_link_text,
               print_url                      = :new.print_url,
               print_url_label                = :new.print_url_label,
               prn_output                     = :new.prn_output,
               report_attributes_substitution = :new.report_attributes_substitution,
               pagination_display_position    = :new.pagination_display_position,
               ajax_enabled                   = :new.ajax_enabled,
               sort_null                      = :new.sort_null,
               fixed_header                   = :new.fixed_header,
               fixed_header_max_height        = :new.fixed_header_max_height
         where id                = :new.region_id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        null;
    end if;
end;
/
--==============================================================================
-- view+iot for plug-in regions to have plug-in specific columns in it's own "table".
--==============================================================================
prompt ...wwv_flow_region_plugin_dev
create or replace view wwv_flow_region_plugin_dev
as
select id,
       id as region_id,
       security_group_id,
       flow_id,
       page_id,
       plug_source_type,
       plugin_init_javascript_code,
       attribute_01,
       attribute_02,
       attribute_03,
       attribute_04,
       attribute_05,
       attribute_06,
       attribute_07,
       attribute_08,
       attribute_09,
       attribute_10,
       attribute_11,
       attribute_12,
       attribute_13,
       attribute_14,
       attribute_15,
       attribute_16,
       attribute_17,
       attribute_18,
       attribute_19,
       attribute_20,
       attribute_21,
       attribute_22,
       attribute_23,
       attribute_24,
       attribute_25,
       list_template_id,
       menu_template_id,
       component_template_options,
       region_sub_css_classes,
       plug_query_headings_type,
       plug_query_headings,
       case
         when plug_query_num_rows_item is not null then 'ITEM'
         else 'STATIC'
       end as number_of_rows_type,
       plug_query_num_rows,
       plug_query_num_rows_item,
       plug_query_no_data_found
  from wwv_flow_page_plugs r
 where security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and plug_source_type  not in ( 'NATIVE_SQL_REPORT', 'NATIVE_TABFORM' )
   and exists ( select 1
                  from wwv_flow_plugins p
                 where flow_id     = case when r.plug_source_type like 'NATIVE%' then 4411 else r.flow_id end
                   and plugin_type = 'REGION TYPE'
                   and name        = substr( r.plug_source_type, 8 )
                   and (  instr( p.standard_attributes, 'FETCHED_ROWS'          ) > 0
                       or instr( p.standard_attributes, 'NO_DATA_FOUND_MESSAGE' ) > 0
                       or instr( p.standard_attributes, 'COLUMN_HEADING'        ) > 0
                       or instr( p.standard_attributes, 'INIT_JAVASCRIPT_CODE'  ) > 0
                       or r.plug_source_type in ( 'NATIVE_BREADCRUMB', 'NATIVE_LIST' )
                       or exists ( select 1
                                     from wwv_flow_plugin_attributes a
                                    where a.plugin_id = p.id
                                      and a.attribute_scope = 'COMPONENT'
                                 )
                       )
              )
/
create or replace trigger wwv_flow_region_plugin_dev_iot
instead of insert or update or delete
on wwv_flow_region_plugin_dev
for each row
begin
    if inserting or updating then
        -- !!!!!!!!!!!!
        -- NOTE! Keep in sync with the set to NULL update in wwv_flow_page_plugs_dev
        -- !!!!!!!!!!!!
        update wwv_flow_page_plugs
           set plugin_init_javascript_code = :new.plugin_init_javascript_code,
               attribute_01                = :new.attribute_01,
               attribute_02                = :new.attribute_02,
               attribute_03                = :new.attribute_03,
               attribute_04                = :new.attribute_04,
               attribute_05                = :new.attribute_05,
               attribute_06                = :new.attribute_06,
               attribute_07                = :new.attribute_07,
               attribute_08                = :new.attribute_08,
               attribute_09                = :new.attribute_09,
               attribute_10                = :new.attribute_10,
               attribute_11                = :new.attribute_11,
               attribute_12                = :new.attribute_12,
               attribute_13                = :new.attribute_13,
               attribute_14                = :new.attribute_14,
               attribute_15                = :new.attribute_15,
               attribute_16                = :new.attribute_16,
               attribute_17                = :new.attribute_17,
               attribute_18                = :new.attribute_18,
               attribute_19                = :new.attribute_19,
               attribute_20                = :new.attribute_20,
               attribute_21                = :new.attribute_21,
               attribute_22                = :new.attribute_22,
               attribute_23                = :new.attribute_23,
               attribute_24                = :new.attribute_24,
               attribute_25                = :new.attribute_25,
               list_template_id            = :new.list_template_id,
               menu_template_id            = :new.menu_template_id,
               component_template_options  = :new.component_template_options,
               region_sub_css_classes      = :new.region_sub_css_classes,
               plug_query_headings_type    = :new.plug_query_headings_type,
               plug_query_headings         = :new.plug_query_headings,
               plug_query_num_rows         = case when :new.number_of_rows_type = 'STATIC' then :new.plug_query_num_rows else null end,
               plug_query_num_rows_item    = case when :new.number_of_rows_type = 'ITEM'   then :new.plug_query_num_rows_item else null end,
               plug_query_no_data_found    = :new.plug_query_no_data_found
         where id                = :new.region_id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        null;
    end if;
end;
/
--==============================================================================
-- view+iot for classic reports and IR to have print specific columns in it's own "table".
--==============================================================================
prompt ...wwv_flow_region_print_dev
create or replace view wwv_flow_region_print_dev
as
select r.id  as region_id,
       ir.id as worksheet_id,
       r.security_group_id,
       r.flow_id,
       r.page_id,
       r.plug_source_type,
       nvl( r.prn_output, 'N' ) as prn_output,
       case
         when plug_source_type = 'NATIVE_IR' then ir.download_formats
         when plug_source_type = 'NATIVE_IG' then ig.download_formats
       end as download_formats,
       r.prn_output_link_text,
       r.prn_output_file_name,
       r.prn_format,
       r.prn_format_item,
       r.prn_template_id,
       r.prn_width_units,
       r.prn_print_server_overwrite,
       'f?p=' || chr(38) || 'APP_ID.:' || chr(38) || 'APP_PAGE_ID.:' || chr(38) || 'SESSION.:FLOW_XMLP_OUTPUT_R' || r.id as print_example_url,
       nvl( r.prn_content_disposition, 'ATTACHMENT' ) as prn_content_disposition,
       nvl( r.prn_document_header, 'APEX' )           as prn_document_header,
       nvl( r.prn_paper_size, 'LETTER' )      as prn_paper_size,
       nvl( r.prn_orientation, 'HORIZONTAL' ) as prn_orientation,
       nvl( r.prn_units, 'INCHES' )           as prn_units,
       nvl( r.prn_width, 11 )                 as prn_width,
       nvl( r.prn_height, 8.5 )               as prn_height,
       nvl( r.prn_border_width, 0.5 )         as prn_border_width,
       r.prn_border_color,
       nvl( r.prn_page_header_font_family, 'Helvetica' ) as prn_page_header_font_family,
       nvl( r.prn_page_header_font_weight, 'normal' )    as prn_page_header_font_weight,
       nvl( r.prn_page_header_font_size,   12 )          as prn_page_header_font_size,
       nvl( r.prn_page_header_font_color,  '#000000' )   as prn_page_header_font_color,
       nvl( r.prn_page_header_alignment,   'CENTER' )    as prn_page_header_alignment,
       r.prn_page_header,
       nvl( r.prn_header_font_family, 'Helvetica' ) as prn_header_font_family,
       nvl( r.prn_header_font_weight, 'normal' )    as prn_header_font_weight,
       nvl( r.prn_header_font_size,   10 )          as prn_header_font_size,
       nvl( r.prn_header_font_color,  '#000000' )   as prn_header_font_color,
       nvl( r.prn_header_bg_color,    '#9bafde' )   as prn_header_bg_color,
       nvl( r.prn_body_font_family,   'Helvetica' ) as prn_body_font_family,
       nvl( r.prn_body_font_weight,   'normal' )    as prn_body_font_weight,
       nvl( r.prn_body_font_size,     10 )          as prn_body_font_size,
       nvl( r.prn_body_font_color,    '#000000' )   as prn_body_font_color,
       nvl( r.prn_body_bg_color,      '#efefef' )   as prn_body_bg_color,
       nvl( r.prn_page_footer_font_family, 'Helvetica' ) as prn_page_footer_font_family,
       nvl( r.prn_page_footer_font_weight, 'normal' )    as prn_page_footer_font_weight,
       nvl( r.prn_page_footer_font_size,   12 )          as prn_page_footer_font_size,
       nvl( r.prn_page_footer_font_color,  '#000000' )   as prn_page_footer_font_color,
       nvl( r.prn_page_footer_alignment,   'CENTER' )    as prn_page_footer_alignment,
       r.prn_page_footer
  from wwv_flow_page_plugs r,
       wwv_flow_worksheets ir,
       wwv_flow_interactive_grids ig
 where r.security_group_id      = (select nv('WORKSPACE_ID') from sys.dual)
   and ir.region_id         (+) = r.id
   and ir.security_group_id (+) = r.security_group_id
   and ig.region_id         (+) = r.id
   and ig.security_group_id (+) = r.security_group_id
/
create or replace trigger wwv_flow_region_print_dev_iot
instead of insert or update or delete
on wwv_flow_region_print_dev
for each row
declare
    l_region_id number := :new.region_id;
begin
    if inserting or updating then
        -- For IR Print Attributes we have to get the region id, because we use WORKSHEET_ID as primary key
        if l_region_id is null then
            select region_id
              into l_region_id
              from wwv_flow_worksheets
             where id                = :new.worksheet_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        end if;

        -- !!!!!!!!!!!!
        -- NOTE! Keep in sync with the set to NULL update in wwv_flow_page_plugs_dev
        -- !!!!!!!!!!!!
        update wwv_flow_page_plugs
           set prn_output_link_text        = :new.prn_output_link_text,
               prn_output_file_name        = :new.prn_output_file_name,
               prn_format                  = :new.prn_format,
               prn_format_item             = :new.prn_format_item,
               prn_template_id             = :new.prn_template_id,
               prn_width_units             = :new.prn_width_units,
               prn_print_server_overwrite  = :new.prn_print_server_overwrite,
               prn_content_disposition     = :new.prn_content_disposition,
               prn_document_header         = :new.prn_document_header,
               prn_units                   = :new.prn_units,
               prn_paper_size              = :new.prn_paper_size,
               prn_width                   = :new.prn_width,
               prn_orientation             = :new.prn_orientation,
               prn_height                  = :new.prn_height,
               prn_border_width            = :new.prn_border_width,
               prn_border_color            = :new.prn_border_color,
               prn_page_header_font_family = :new.prn_page_header_font_family,
               prn_page_header_font_weight = :new.prn_page_header_font_weight,
               prn_page_header_font_size   = :new.prn_page_header_font_size,
               prn_page_header_font_color  = :new.prn_page_header_font_color,
               prn_page_header_alignment   = :new.prn_page_header_alignment,
               prn_page_header             = :new.prn_page_header,
               prn_header_font_family      = :new.prn_header_font_family,
               prn_header_font_weight      = :new.prn_header_font_weight,
               prn_header_font_size        = :new.prn_header_font_size,
               prn_header_font_color       = :new.prn_header_font_color,
               prn_header_bg_color         = :new.prn_header_bg_color,
               prn_body_font_family        = :new.prn_body_font_family,
               prn_body_font_weight        = :new.prn_body_font_weight,
               prn_body_font_size          = :new.prn_body_font_size,
               prn_body_font_color         = :new.prn_body_font_color,
               prn_body_bg_color           = :new.prn_body_bg_color,
               prn_page_footer_font_family = :new.prn_page_footer_font_family,
               prn_page_footer_font_weight = :new.prn_page_footer_font_weight,
               prn_page_footer_font_size   = :new.prn_page_footer_font_size,
               prn_page_footer_font_color  = :new.prn_page_footer_font_color,
               prn_page_footer_alignment   = :new.prn_page_footer_alignment,
               prn_page_footer             = :new.prn_page_footer
         where id                = l_region_id
           and flow_id           = :new.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        null;
    end if;
end;
/
--==============================================================================
-- view+iot for classic report column to workaround missing page_id in table.
--==============================================================================
prompt ...wwv_flow_region_rpt_col_dev
create or replace view wwv_flow_region_rpt_col_dev
as
select a.*,
       -- Percent Graph format mask is defined as PCT_GRAPH:<background>:<foreground>:<width>
       case when display_as = 'PCT_GRAPH' then regexp_replace(regexp_substr( column_format, '(:[#]?)([^:]*)', 1,  1, null, 2 ), '(.+)','#\1') end as pct_graph_background_color,
       case when display_as = 'PCT_GRAPH' then regexp_replace(regexp_substr( column_format, '(:[#]?)([^:]*)', 1,  2, null, 2 ), '(.+)','#\1') end as pct_graph_foreground_color,
       case when display_as = 'PCT_GRAPH' then regexp_substr( column_format, '([^:]*)(:|$)', 1,  4, null, 1 ) end as pct_graph_bar_width,
       -- Image and Download format mask is defined as IMAGE/DOWNLOAD:<table>:<content column>:<pk column1>:<pk column2>:<mime type column>:<filename column>:<charset column>:<last updated column>:<content disposition>:<download text>
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  2, null, 1 ) end as blob_table,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  3, null, 1 ) end as blob_content_column,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  4, null, 1 ) end as blob_pk_column1,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  5, null, 1 ) end as blob_pk_column2,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  6, null, 1 ) end as blob_mime_type_column,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  7, null, 1 ) end as blob_filename_column,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  8, null, 1 ) end as blob_last_updated_column,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1,  9, null, 1 ) end as blob_charset_column,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then lower( regexp_substr( column_format, '([^:]*)(:|$)', 1, 10, null, 1 )) end as blob_content_disposition,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1, 11, null, 1 ) end as blob_download_text,
       case when display_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( column_format, '([^:]*)(:|$)', 1, 12, null, 1 ) end as blob_table_owner
  from ( select c.id,
                c.security_group_id,
                c.flow_id,
                r.page_id as flow_step_id,
                c.region_id,
                c.query_column_id,
                nvl( c.derived_column, 'N' ) as derived_column,
                c.form_element_id,
                c.column_alias,
                c.static_id,
                c.column_display_sequence,
                c.column_heading,
                nvl( c.use_as_row_header, 'N' ) as use_as_row_header,
                case
                  when display_as like 'PICK_%' then display_as /* Date Picker (Classic) */
                  else c.column_format
                end as column_format,
                c.column_html_expression,
                c.column_css_class,
                c.column_css_style,
                c.column_hit_highlight,
                c.column_link,
                c.column_linktext,
                c.column_link_attr,
                c.column_link_checksum_type,
                c.column_alignment,
                nvl(c.heading_alignment, 'CENTER') as heading_alignment,
                case c.default_sort_column_sequence
                  when 0 then null
                  else c.default_sort_column_sequence
                end as default_sort_column_sequence,
                c.default_sort_dir,
                c.disable_sort_column,
                nvl( c.sum_column, 'N' ) as sum_column,
                c.display_when_cond_type,
                c.display_when_condition,
                c.display_when_condition2,
                case
                  when display_as in ( 'WITHOUT_MODIFICATION', 'TEXT_FROM_LOV' ) then 'N'
                  else 'Y'
                end as escape_on_http_output,
                c.report_column_required_role,
                case
                  when hidden_column = 'Y' or display_as = 'HIDDEN' then
                      case
                        when display_as in ( 'WITHOUT_MODIFICATION', 'ESCAPE_SC', 'TEXT_FROM_LOV', 'CHECKBOX' ) then 'HIDDEN_COLUMN'
                        else 'HIDDEN_FIELD'
                      end
                  when upper(column_format) like 'PCT_GRAPH%'                       then 'PCT_GRAPH'
                  when upper(column_format) like 'IMAGE:%'                          then 'IMAGE'
                  when upper(column_format) like 'DOWNLOAD:%'                       then 'DOWNLOAD'
                  when column_html_expression is not null                           then 'PLAIN'
                  when column_link   is not null and column_html_expression is null then 'LINK'
                  when display_as in ( 'ESCAPE_SC',   'WITHOUT_MODIFICATION' )      then 'PLAIN'
                  when display_as in ( 'SELECT_LIST', 'SELECT_LIST_FROM_LOV', 'SELECT_LIST_FROM_QUERY' ) then 'SELECT_LIST'
                  when display_as in ( 'RADIOGROUP',  'RADIOGROUP_FROM_LOV', 'RADIOGROUP_FROM_QUERY' )   then 'RADIOGROUP'
                  when display_as in ( 'POPUP', 'POPUP_QUERY' )       then 'POPUP'
                  when display_as in ( 'POPUPKEY', 'POPUPKEY_QUERY' ) then 'POPUPKEY'
                  when display_as = 'TEXT_FROM_LOV'                   then 'PLAIN_LOV'
                  when display_as = 'CHECKBOX'                        then 'ROW_SELECTOR'
                  when display_as like 'PICK_%'                       then 'DATE_POPUP' /* Date Picker (Classic) */
                  else display_as
                end as display_as,
                case
                  when display_as in ( 'SELECT_LIST_FROM_LOV', 'RADIOGROUP_FROM_LOV', 'POPUP', 'POPUPKEY' ) then 'SHARED'
                  else case
                         when display_as = 'TEXT_FROM_LOV' and named_lov is not null then 'SHARED'
                         when upper( substr( inline_lov, 1, 6 )) = 'STATIC'          then 'STATIC'
                         when upper( substr( ltrim( inline_lov ), 1, 6 )) = 'SELECT'
                           or upper( substr( ltrim( inline_lov ), 1, 4 )) = 'WITH'   then 'SQL_QUERY'
                         when inline_lov is not null                                 then 'PLSQL_FUNCTION_BODY'
                       end
                end as lov_type,
                c.named_lov,
                c.inline_lov,
                case
                  when c.lov_show_nulls = 'YES' then 'Y'
                  when c.lov_show_nulls = 'NO' then 'N'
                end as lov_show_nulls,
                c.lov_null_text,
                c.lov_null_value,
                c.column_width,
                c.report_column_width,
                c.column_height,
                c.css_classes,
                c.cattributes,
                c.cattributes_element,
                c.column_field_template,
                c.attribute_01,
                c.attribute_02,
                c.attribute_03,
                c.attribute_04,
                c.attribute_05,
                c.attribute_06,
                c.attribute_07,
                c.attribute_08,
                c.attribute_09,
                c.attribute_10,
                c.attribute_11,
                c.attribute_12,
                c.attribute_13,
                c.attribute_14,
                c.attribute_15,
                c.is_required,
                c.standard_validations,
                c.pk_col_source_type,
                c.pk_col_source,
                c.column_default,
                c.column_default_type,
                case
                  when c.lov_display_extra = 'YES' then 'Y'
                  when c.lov_display_extra = 'NO' then 'N'
                end as lov_display_extra,
                nvl( c.include_in_export, 'Y' ) as include_in_export,
                c.print_col_width,
                c.print_col_align,
                c.ref_schema,
                c.ref_table_name,
                c.ref_column_name,
                c.required_patch,
                c.column_comment,
                c.last_updated_by,
                c.last_updated_on
           from wwv_flow_region_report_column c,
                wwv_flow_page_plugs r
          where r.id = c.region_id
       ) a
 where a.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_reg_rpt_col_dev_iot
instead of insert or update or delete
on wwv_flow_region_rpt_col_dev
for each row
declare
    l_display_as          wwv_flow_region_report_column.display_as%type          := :new.display_as;
    l_column_format       wwv_flow_region_report_column.column_format%type       := :new.column_format;
    l_hidden_column       wwv_flow_region_report_column.hidden_column%type       := 'N';
    l_disable_sort_column wwv_flow_region_report_column.disable_sort_column%type;
begin
    if inserting or updating then

        if :new.column_alias = 'CHECK$01' then
            if :new.display_as not in ( 'ROW_SELECTOR', 'HIDDEN_COLUMN' ) then
                raise_application_error( -20999, 'You can''t change the type of a Row Selector column!' );
            else
                l_display_as := 'CHECKBOX';
                if :new.display_as = 'HIDDEN_COLUMN' then
                    l_hidden_column := 'Y';
                end if;
            end if;

        elsif :new.display_as = 'ROW_SELECTOR' and :new.column_alias <> 'CHECK$01' then

            raise_application_error( -20999, 'You have to create a Row Selector column to use this type!' );

        elsif :new.display_as in ( 'IMAGE', 'DOWNLOAD' ) then
            l_display_as    := 'ESCAPE_SC';
            l_column_format := :new.display_as               || ':' ||
                               :new.blob_table               || ':' ||
                               :new.blob_content_column      || ':' ||
                               :new.blob_pk_column1          || ':' ||
                               :new.blob_pk_column2          || ':' ||
                               :new.blob_mime_type_column    || ':' ||
                               :new.blob_filename_column     || ':' ||
                               :new.blob_last_updated_column || ':' ||
                               :new.blob_charset_column      || ':' ||
                               :new.blob_content_disposition || ':' ||
                               :new.blob_download_text       || ':' ||
                               :new.blob_table_owner;

        elsif :new.display_as = 'PCT_GRAPH' then
            l_display_as    := 'WITHOUT_MODIFICATION';
            l_column_format := :new.display_as                 || ':' ||
                               :new.pct_graph_background_color || ':' ||
                               :new.pct_graph_foreground_color || ':' ||
                               :new.pct_graph_bar_width;

        elsif :new.display_as in ( 'LINK', 'PLAIN', 'HIDDEN_COLUMN' ) then
            l_display_as := case :new.escape_on_http_output
                              when 'N' then 'WITHOUT_MODIFICATION'
                              else          'ESCAPE_SC'
                            end;
            if :new.display_as = 'HIDDEN_COLUMN' then
                l_hidden_column := 'Y';
            end if;

        elsif :new.display_as = 'HIDDEN_FIELD' then
            l_display_as    := 'HIDDEN';
            l_hidden_column := 'Y';

        elsif :new.display_as = 'DATE_POPUP' then /* Date Picker (Classic) */
            l_display_as    := :new.column_format;
            l_column_format := null;

        elsif :new.display_as in ( 'SELECT_LIST', 'RADIOGROUP', 'POPUP', 'POPUPKEY', 'PLAIN_LOV' ) then
            if :new.display_as = 'PLAIN_LOV' then
                l_display_as := 'TEXT_FROM_LOV';

            elsif :new.lov_type = 'SHARED' then
                if :new.display_as in ( 'SELECT_LIST', 'RADIOGROUP' ) then
                    l_display_as := l_display_as || '_FROM_LOV';
                end if;

            elsif :new.lov_type = 'SQL_QUERY' then
                if :new.display_as in ( 'SELECT_LIST', 'RADIOGROUP' ) then
                    l_display_as := l_display_as || '_FROM_QUERY';
                elsif :new.display_as in ( 'POPUP', 'POPUPKEY' ) then
                    l_display_as := l_display_as || '_QUERY';
                end if;

            elsif :new.lov_type = 'PLSQL_FUNCTION_BODY' then
                raise_application_error( -20999, '''PL/SQL Function Body returning SQL Query'' List of Values not supported for this type!' );

            elsif :new.lov_type = 'STATIC' then
                if :new.display_as in ( 'POPUP', 'POPUPKEY' ) then
                    raise_application_error( -20999, '''Static'' List of Values not supported for this type!' );
                end if;
            end if;
        end if;

        l_disable_sort_column := nvl( :new.disable_sort_column, 'Y' );
    end if;
    --
    if inserting then
        insert into wwv_flow_region_report_column (
            id,
            region_id,
            flow_id,
            query_column_id,
            derived_column,
            form_element_id,
            column_alias,
            static_id,
            column_display_sequence,
            column_heading,
            use_as_row_header,
            column_format,
            column_html_expression,
            column_css_class,
            column_css_style,
            column_hit_highlight,
            column_link,
            column_linktext,
            column_link_attr,
            column_link_checksum_type,
            column_alignment,
            heading_alignment,
            default_sort_column_sequence,
            default_sort_dir,
            disable_sort_column,
            sum_column,
            hidden_column,
            display_when_cond_type,
            display_when_condition,
            display_when_condition2,
            report_column_required_role,
            display_as,
            named_lov,
            inline_lov,
            lov_show_nulls,
            lov_null_text,
            lov_null_value,
            column_width,
            report_column_width,
            column_height,
            css_classes,
            cattributes,
            cattributes_element,
            column_field_template,
            attribute_01,
            attribute_02,
            attribute_03,
            attribute_04,
            attribute_05,
            attribute_06,
            attribute_07,
            attribute_08,
            attribute_09,
            attribute_10,
            attribute_11,
            attribute_12,
            attribute_13,
            attribute_14,
            attribute_15,
            is_required,
            standard_validations,
            pk_col_source_type,
            pk_col_source,
            column_default,
            column_default_type,
            lov_display_extra,
            include_in_export,
            print_col_width,
            print_col_align,
            ref_schema,
            ref_table_name,
            ref_column_name,
            required_patch,
            column_comment,
            security_group_id )
        values (
            :new.id,
            :new.region_id,
            :new.flow_id,
            :new.query_column_id,
            :new.derived_column,
            :new.form_element_id,
            :new.column_alias,
            :new.static_id,
            :new.column_display_sequence,
            :new.column_heading,
            :new.use_as_row_header,
            l_column_format,
            :new.column_html_expression,
            :new.column_css_class,
            :new.column_css_style,
            :new.column_hit_highlight,
            :new.column_link,
            :new.column_linktext,
            :new.column_link_attr,
            :new.column_link_checksum_type,
            :new.column_alignment,
            :new.heading_alignment,
            nvl( :new.default_sort_column_sequence, 0 ),
            :new.default_sort_dir,
            l_disable_sort_column,
            nvl( :new.sum_column, 'N'),
            l_hidden_column,
            :new.display_when_cond_type,
            :new.display_when_condition,
            :new.display_when_condition2,
            :new.report_column_required_role,
            l_display_as,
            :new.named_lov,
            :new.inline_lov,
            case
              when :new.lov_show_nulls = 'Y' then 'YES'
              when :new.lov_show_nulls = 'N' then 'NO'
            end,
            :new.lov_null_text,
            :new.lov_null_value,
            :new.column_width,
            :new.report_column_width,
            :new.column_height,
            :new.css_classes,
            :new.cattributes,
            :new.cattributes_element,
            :new.column_field_template,
            :new.attribute_01,
            :new.attribute_02,
            :new.attribute_03,
            :new.attribute_04,
            :new.attribute_05,
            :new.attribute_06,
            :new.attribute_07,
            :new.attribute_08,
            :new.attribute_09,
            :new.attribute_10,
            :new.attribute_11,
            :new.attribute_12,
            :new.attribute_13,
            :new.attribute_14,
            :new.attribute_15,
            :new.is_required,
            :new.standard_validations,
            :new.pk_col_source_type,
            :new.pk_col_source,
            :new.column_default,
            :new.column_default_type,
            case
              when :new.lov_display_extra = 'Y' then 'YES'
              when :new.lov_display_extra = 'N' then 'NO'
            end,
            :new.include_in_export,
            :new.print_col_width,
            :new.print_col_align,
            :new.ref_schema,
            :new.ref_table_name,
            :new.ref_column_name,
            :new.required_patch,
            :new.column_comment,
            wwv_flow_security.g_security_group_id );
    elsif updating then
        update wwv_flow_region_report_column
           set query_column_id              = :new.query_column_id,
               derived_column               = :new.derived_column,
               form_element_id              = :new.form_element_id,
               column_alias                 = :new.column_alias,
               static_id                    = :new.static_id,
               column_display_sequence      = :new.column_display_sequence,
               column_heading               = :new.column_heading,
               use_as_row_header            = :new.use_as_row_header,
               column_format                = l_column_format,
               column_html_expression       = :new.column_html_expression,
               column_css_class             = :new.column_css_class,
               column_css_style             = :new.column_css_style,
               column_hit_highlight         = :new.column_hit_highlight,
               column_link                  = :new.column_link,
               column_linktext              = :new.column_linktext,
               column_link_attr             = :new.column_link_attr,
               column_link_checksum_type    = :new.column_link_checksum_type,
               column_alignment             = :new.column_alignment,
               heading_alignment            = :new.heading_alignment,
               default_sort_column_sequence = nvl( :new.default_sort_column_sequence, 0 ),
               default_sort_dir             = :new.default_sort_dir,
               disable_sort_column          = l_disable_sort_column,
               sum_column                   = nvl( :new.sum_column, 'N' ),
               hidden_column                = l_hidden_column,
               display_when_cond_type       = :new.display_when_cond_type,
               display_when_condition       = :new.display_when_condition,
               display_when_condition2      = :new.display_when_condition2,
               report_column_required_role  = :new.report_column_required_role,
               display_as                   = l_display_as,
               named_lov                    = :new.named_lov,
               inline_lov                   = :new.inline_lov,
               lov_show_nulls               = case when :new.lov_show_nulls = 'Y' then 'YES' when :new.lov_show_nulls = 'N' then 'NO' end,
               lov_null_text                = :new.lov_null_text,
               lov_null_value               = :new.lov_null_value,
               column_width                 = :new.column_width,
               report_column_width          = :new.report_column_width,
               column_height                = :new.column_height,
               css_classes                  = :new.css_classes,
               cattributes                  = :new.cattributes,
               cattributes_element          = :new.cattributes_element,
               column_field_template        = :new.column_field_template,
               attribute_01                 = :new.attribute_01,
               attribute_02                 = :new.attribute_02,
               attribute_03                 = :new.attribute_03,
               attribute_04                 = :new.attribute_04,
               attribute_05                 = :new.attribute_05,
               attribute_06                 = :new.attribute_06,
               attribute_07                 = :new.attribute_07,
               attribute_08                 = :new.attribute_08,
               attribute_09                 = :new.attribute_09,
               attribute_10                 = :new.attribute_10,
               attribute_11                 = :new.attribute_11,
               attribute_12                 = :new.attribute_12,
               attribute_13                 = :new.attribute_13,
               attribute_14                 = :new.attribute_14,
               attribute_15                 = :new.attribute_15,
               is_required                  = :new.is_required,
               standard_validations         = :new.standard_validations,
               pk_col_source_type           = :new.pk_col_source_type,
               pk_col_source                = :new.pk_col_source,
               column_default               = :new.column_default,
               column_default_type          = :new.column_default_type,
               lov_display_extra            = case when :new.lov_display_extra = 'Y' then 'YES' when :new.lov_display_extra = 'N' then 'NO' end,
               include_in_export            = :new.include_in_export,
               print_col_width              = :new.print_col_width,
               print_col_align              = :new.print_col_align,
               ref_schema                   = :new.ref_schema,
               ref_table_name               = :new.ref_table_name,
               ref_column_name              = :new.ref_column_name,
               required_patch               = :new.required_patch,
               column_comment               = :new.column_comment
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete wwv_flow_region_report_column
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
--==============================================================================
-- view+iot for interactive report column to workaround missing page_id in table.
--==============================================================================
prompt ...wwv_flow_worksheet_col_dev
create or replace view wwv_flow_worksheet_col_dev
as
select a.*,
       -- Percent Graph format mask is defined as PCT_GRAPH:<background>:<foreground>:<width>
       case when display_text_as = 'PCT_GRAPH' then regexp_replace(regexp_substr( format_mask, '(:[#]?)([^:]*)', 1,  1, null, 2 ), '(.+)','#\1') end as pct_graph_background_color,
       case when display_text_as = 'PCT_GRAPH' then regexp_replace(regexp_substr( format_mask, '(:[#]?)([^:]*)', 1,  2, null, 2 ), '(.+)','#\1') end as pct_graph_foreground_color,
       case when display_text_as = 'PCT_GRAPH' then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  4, null, 1 ) end as pct_graph_bar_width,
       -- Image and Download format mask is defined as IMAGE/DOWNLOAD:<table>:<content column>:<pk column1>:<pk column2>:<mime type column>:<filename column>:<charset column>:<last updated column>:<content disposition>:<download text>
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  2, null, 1 ) end as blob_table,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  3, null, 1 ) end as blob_content_column,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  4, null, 1 ) end as blob_pk_column1,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  5, null, 1 ) end as blob_pk_column2,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  6, null, 1 ) end as blob_mime_type_column,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  7, null, 1 ) end as blob_filename_column,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  8, null, 1 ) end as blob_last_updated_column,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1,  9, null, 1 ) end as blob_charset_column,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then lower( regexp_substr( format_mask, '([^:]*)(:|$)', 1, 10, null, 1 )) end as blob_content_disposition,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1, 11, null, 1 ) end as blob_download_text,
       case when display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then regexp_substr( format_mask, '([^:]*)(:|$)', 1, 12, null, 1 ) end as blob_table_owner
  from ( select c.id,
                c.security_group_id,
                c.flow_id,
                ir.page_id,
                c.worksheet_id,
                c.db_column_name,
                c.column_type,
                c.tz_dependent,
                case
                  when c.display_text_as = 'HIDDEN'               then 'HIDDEN_COLUMN'
                  when c.display_text_as = 'LOV_ESCAPE_SC'        then 'PLAIN_LOV'
                  when c.display_text_as = 'STRIP_HTML_ESCAPE_SC' then 'STRIP_HTML'
                  when upper(c.format_mask) like 'PCT_GRAPH%'     then 'PCT_GRAPH'
                  when upper(c.format_mask) like 'IMAGE:%'        then 'IMAGE'
                  when upper(c.format_mask) like 'DOWNLOAD:%'     then 'DOWNLOAD'
                  when c.column_link   is not null                then 'LINK'
                  when c.column_html_expression is not null       then 'PLAIN'
                  else 'PLAIN'
                end as display_text_as,
                c.report_label,
                c.sync_form_label,
                c.column_label,
                c.heading_alignment,
                c.display_order,
                c.column_alignment,
                c.group_id,
                c.format_mask,
                c.column_link,
                c.column_linktext,
                c.column_link_attr,
                c.column_html_expression,
                c.rpt_show_filter_lov,
                c.rpt_named_lov,
                c.rpt_lov,
                c.rpt_distinct_lov,
                c.rpt_filter_date_ranges,
                c.static_id,
                c.allow_hide,
                c.allow_sorting,
                c.allow_filtering,
                c.allow_highlighting,
                c.allow_ctrl_breaks,
                c.allow_aggregations,
                c.allow_computations,
                c.allow_charting,
                c.allow_group_by,
                c.allow_pivot,
                c.display_condition_type,
                c.display_condition,
                c.display_condition2,
                c.security_scheme,
                case
                  when c.display_text_as = 'WITHOUT_MODIFICATION' then 'N'
                  else 'Y'
                end as escape_on_http_output,
                c.help_text,
                c.required_patch,
                c.column_comment,
                c.updated_by,
                c.updated_on
           from wwv_flow_worksheet_columns c,
                wwv_flow_worksheets ir
          where ir.id                = c.worksheet_id
            and ir.flow_id           = c.flow_id
            and ir.security_group_id = c.security_group_id
       ) a
/
create or replace trigger wwv_flow_worksheet_col_dev_iot
instead of insert or update or delete
on wwv_flow_worksheet_col_dev
for each row
declare
    l_display_text_as wwv_flow_worksheet_columns.display_text_as%type;
    l_format_mask     wwv_flow_worksheet_columns.format_mask%type;
begin
    if inserting or updating then
        if :new.display_text_as in ( 'IMAGE', 'DOWNLOAD' ) then
            l_display_text_as := 'ESCAPE_SC';
            l_format_mask     := :new.display_text_as          || ':' ||
                                 :new.blob_table               || ':' ||
                                 :new.blob_content_column      || ':' ||
                                 :new.blob_pk_column1          || ':' ||
                                 :new.blob_pk_column2          || ':' ||
                                 :new.blob_mime_type_column    || ':' ||
                                 :new.blob_filename_column     || ':' ||
                                 :new.blob_last_updated_column || ':' ||
                                 :new.blob_charset_column      || ':' ||
                                 :new.blob_content_disposition || ':' ||
                                 :new.blob_download_text       || ':' ||
                                 :new.blob_table_owner;

        elsif :new.display_text_as = 'PCT_GRAPH' then
            l_display_text_as := 'WITHOUT_MODIFICATION';
            l_format_mask     := :new.display_text_as            || ':' ||
                                 :new.pct_graph_background_color || ':' ||
                                 :new.pct_graph_foreground_color || ':' ||
                                 :new.pct_graph_bar_width;

        elsif :new.display_text_as in ( 'LINK', 'PLAIN' ) then
            l_display_text_as := case :new.escape_on_http_output
                                   when 'N' then 'WITHOUT_MODIFICATION'
                                   else          'ESCAPE_SC'
                                 end;
            l_format_mask     := :new.format_mask;

        elsif :new.display_text_as = 'HIDDEN_COLUMN' then
            l_display_text_as := 'HIDDEN';

        elsif :new.display_text_as = 'PLAIN_LOV' then
            l_display_text_as := 'LOV_ESCAPE_SC';

        elsif :new.display_text_as = 'STRIP_HTML' then
            l_display_text_as := 'STRIP_HTML_ESCAPE_SC';
            l_format_mask     := :new.format_mask;

        end if;
    end if;
    --
    if inserting then
        insert into wwv_flow_worksheet_columns (
            id,
            security_group_id,
            flow_id,
            page_id,
            worksheet_id,
            db_column_name,
            column_type,
            tz_dependent,
            display_text_as,
            report_label,
            sync_form_label,
            column_label,
            heading_alignment,
            display_order,
            column_alignment,
            group_id,
            format_mask,
            column_link,
            column_linktext,
            column_link_attr,
            column_html_expression,
            rpt_show_filter_lov,
            rpt_named_lov,
            rpt_lov,
            rpt_distinct_lov,
            rpt_filter_date_ranges,
            static_id,
            allow_hide,
            allow_sorting,
            allow_filtering,
            allow_highlighting,
            allow_ctrl_breaks,
            allow_aggregations,
            allow_computations,
            allow_charting,
            allow_group_by,
            allow_pivot,
            display_condition_type,
            display_condition,
            display_condition2,
            security_scheme,
            help_text,
            required_patch,
            column_comment )
        values (
            :new.id,
            wwv_flow_security.g_security_group_id,
            :new.flow_id,
            :new.page_id,
            :new.worksheet_id,
            :new.db_column_name,
            :new.column_type,
            :new.tz_dependent,
            l_display_text_as,
            nvl( :new.report_label, :new.db_column_name ),  /* column is NN */
            nvl( :new.sync_form_label, 'Y'),  /* column is NN */
            coalesce( :new.column_label, :new.report_label, :new.db_column_name ),
            nvl( :new.heading_alignment, 'CENTER' ),  /* column is NN */
            :new.display_order,
            nvl( :new.column_alignment, 'LEFT' ), /* column is NN */
            :new.group_id,
            l_format_mask,
            :new.column_link,
            :new.column_linktext,
            :new.column_link_attr,
            :new.column_html_expression,
            :new.rpt_show_filter_lov,
            :new.rpt_named_lov,
            :new.rpt_lov,
            :new.rpt_distinct_lov,
            :new.rpt_filter_date_ranges,
            :new.static_id,
            :new.allow_hide,
            :new.allow_sorting,
            :new.allow_filtering,
            :new.allow_highlighting,
            :new.allow_ctrl_breaks,
            :new.allow_aggregations,
            :new.allow_computations,
            :new.allow_charting,
            :new.allow_group_by,
            :new.allow_pivot,
            :new.display_condition_type,
            :new.display_condition,
            :new.display_condition2,
            :new.security_scheme,
            :new.help_text,
            :new.required_patch,
            :new.column_comment );

        wwv_flow_worksheet_api.show_column_in_default_report (
            p_worksheet_id  => :new.worksheet_id,
            p_column        => :new.db_column_name );

    elsif updating then
        update wwv_flow_worksheet_columns
           set page_id                = :old.page_id, /* set page id to fix a data issue where page id isn't populated */
               db_column_name         = :new.db_column_name,
               column_type            = :new.column_type,
               tz_dependent           = :new.tz_dependent,
               display_text_as        = l_display_text_as,
               report_label           = nvl( :new.report_label, :new.db_column_name ),  /* column is NN */
               sync_form_label        = nvl( :new.sync_form_label, 'Y'),  /* column is NN */
               column_label           = coalesce( :new.column_label, :new.report_label, :new.db_column_name ),
               heading_alignment      = nvl( :new.heading_alignment, 'CENTER' ),  /* column is NN */
               display_order          = :new.display_order,
               column_alignment       = nvl( :new.column_alignment, 'LEFT' ), /* column is NN */
               group_id               = :new.group_id,
               format_mask            = l_format_mask,
               column_link            = :new.column_link,
               column_linktext        = :new.column_linktext,
               column_link_attr       = :new.column_link_attr,
               column_html_expression = :new.column_html_expression,
               rpt_show_filter_lov    = :new.rpt_show_filter_lov,
               rpt_named_lov          = :new.rpt_named_lov,
               rpt_lov                = :new.rpt_lov,
               rpt_distinct_lov       = :new.rpt_distinct_lov,
               rpt_filter_date_ranges = :new.rpt_filter_date_ranges,
               static_id              = :new.static_id,
               allow_hide             = :new.allow_hide,
               allow_sorting          = :new.allow_sorting,
               allow_filtering        = :new.allow_filtering,
               allow_highlighting     = :new.allow_highlighting,
               allow_ctrl_breaks      = :new.allow_ctrl_breaks,
               allow_aggregations     = :new.allow_aggregations,
               allow_computations     = :new.allow_computations,
               allow_charting         = :new.allow_charting,
               allow_group_by         = :new.allow_group_by,
               allow_pivot            = :new.allow_pivot,
               display_condition_type = :new.display_condition_type,
               display_condition      = :new.display_condition,
               display_condition2     = :new.display_condition2,
               security_scheme        = :new.security_scheme,
               help_text              = :new.help_text,
               required_patch         = :new.required_patch,
               column_comment         = :new.column_comment
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_worksheet_columns
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
        -- Remove deleted column from all saved reports (bug 15874222)
        update wwv_flow_worksheet_rpts
           set report_columns    = rtrim( regexp_replace( report_columns, '(^|:)' || wwv_flow_escape.regexp( :old.db_column_name ) || '($|:)', '\1' ), ':' )
         where worksheet_id      = :old.worksheet_id
           and security_group_id = wwv_flow_security.g_security_group_id;

    end if;
end;
/
--==============================================================================
-- view for region columns to include the region type used by the property configuration.
--==============================================================================
prompt ...wwv_flow_region_columns_dev
create or replace view wwv_flow_region_columns_dev
as
select c.*,
       r.plug_source_type as region_type
  from wwv_flow_region_columns c,
       wwv_flow_page_plugs r
 where c.security_group_id = ( select nv( 'WORKSPACE_ID' ) from sys.dual )
   and r.id                = c.region_id
   and r.security_group_id = c.security_group_id
   and r.plug_source_type <> 'NATIVE_IG'
/
--==============================================================================
-- view for region columns to include the region type used by the property configuration.
--==============================================================================
prompt ...wwv_flow_ig_columns_dev
create or replace view wwv_flow_ig_columns_dev
as
select c.*,
       -- If we are filtering a column with a lookup/lov, it's always of type VARCHAR2
       case when c.lov_type is not null
             and exists ( select 1
                            from wwv_flow_plugins p
                           where p.flow_id     = case when c.item_type like 'NATIVE%' then 4411 else c.flow_id end
                             and p.plugin_type = 'ITEM TYPE'
                             and p.name        = substr( c.item_type, 8 )
                             and instr( p.standard_attributes, 'JOIN_LOV' ) > 0
                        )
            then 'VARCHAR2'
            else c.data_type
       end as filter_data_type
  from wwv_flow_region_columns c,
       wwv_flow_page_plugs r
 where c.security_group_id = ( select nv( 'WORKSPACE_ID' ) from sys.dual )
   and r.id                = c.region_id
   and r.security_group_id = c.security_group_id
   and r.plug_source_type  = 'NATIVE_IG'
/
--==============================================================================
-- view+iot that joins page items and page item help
--==============================================================================
prompt ...wwv_flow_step_items_dev
create or replace force view wwv_flow_step_items_dev
as
select i.id,
       i.flow_id,
       i.flow_step_id,
       i.name,
       i.name_length,
       i.data_type,
       i.is_required,
       i.standard_validations,
       i.accept_processing,
       i.item_sequence,
       i.item_plug_id,
       i.use_cache_before_default,
       i.item_default,
       i.item_default_type,
       i.prompt,
       i.placeholder,
       i.pre_element_text,
       i.post_element_text,
       i.format_mask,
       i.item_field_template,
       i.item_template_options,
       i.item_css_classes,
       i.item_icon_css_classes,
       i.source,
       i.source_type,
       i.source_post_computation,
       i.display_as,
       i.read_only_when_type,
       i.read_only_when,
       i.read_only_when2,
       i.read_only_disp_attr,
       case
         when i.named_lov is not null and i.named_lov <> '%null%' then 'SHARED'
         when upper( substr( i.lov, 1, 6 )) = 'STATIC'            then 'STATIC'
         when upper( substr( ltrim( i.lov ), 1, 6 )) = 'SELECT'
           or upper( substr( ltrim( i.lov ), 1, 4 )) = 'WITH'     then 'SQL_QUERY'
         when i.lov is not null                                   then 'PLSQL_FUNCTION_BODY'
       end as lov_type,
       l.id as named_lov_id,
       i.lov,
       i.lov_columns,
       case
         when i.lov_display_extra = 'YES' then 'Y'
         when i.lov_display_extra = 'NO' then 'N'
       end as lov_display_extra,
       case
         when i.lov_display_null = 'YES' then 'Y'
         when i.lov_display_null = 'NO' then 'N'
       end as lov_display_null,
       i.lov_null_text,
       i.lov_null_value,
       i.lov_translated,
       i.lov_cascade_parent_items,
       i.ajax_items_to_submit,
       i.ajax_optimize_refresh,
       i.csize,
       i.cmaxlength,
       i.cheight,
       i.cattributes,
       i.cattributes_element,
       i.tag_css_classes,
       i.tag_attributes,
       i.tag_attributes2,
       i.button_image,
       i.button_image_attr,
       i.new_grid,
       i.begin_on_new_line,
       i.begin_on_new_field,
       i.colspan,
       i.rowspan,
       i.grid_column,
       i.grid_label_column_span,
       i.grid_column_css_classes,
       i.label_alignment,
       i.field_alignment,
       i.field_template,
       i.label_cell_attr,
       i.field_cell_attr,
       i.display_when,
       i.display_when2,
       i.display_when_type,
       i.warn_on_unsaved_changes,
       i.is_persistent,
       i.protection_level,
       i.escape_on_http_input,
       i.escape_on_http_output,
       i.restricted_characters,
       i.security_scheme,
       i.required_patch,
       i.encrypt_session_state_yn,
       i.inline_help_text,
       nvl(i.show_quick_picks, 'N') show_quick_picks,
       i.quick_pick_label_01,
       i.quick_pick_value_01,
       i.quick_pick_label_02,
       i.quick_pick_value_02,
       i.quick_pick_label_03,
       i.quick_pick_value_03,
       i.quick_pick_label_04,
       i.quick_pick_value_04,
       i.quick_pick_label_05,
       i.quick_pick_value_05,
       i.quick_pick_label_06,
       i.quick_pick_value_06,
       i.quick_pick_label_07,
       i.quick_pick_value_07,
       i.quick_pick_label_08,
       i.quick_pick_value_08,
       i.quick_pick_label_09,
       i.quick_pick_value_09,
       i.quick_pick_label_10,
       i.quick_pick_value_10,
       i.quick_pick_link_attr,
       i.plugin_init_javascript_code,
       i.attribute_01,
       i.attribute_02,
       i.attribute_03,
       i.attribute_04,
       i.attribute_05,
       i.attribute_06,
       i.attribute_07,
       i.attribute_08,
       i.attribute_09,
       i.attribute_10,
       i.attribute_11,
       i.attribute_12,
       i.attribute_13,
       i.attribute_14,
       i.attribute_15,
       i.button_execute_validations,
       i.button_redirect_url,
       i.button_action,
       i.button_is_hot,
       i.security_group_id,
       i.created_by,
       i.created_on,
       i.last_updated_by,
       i.last_updated_on,
       i.item_comment,
       h.help_text
  from wwv_flow_step_items i,
       wwv_flow_lists_of_values$ l,
       wwv_flow_step_item_help h
 where i.security_group_id     = (select nv('WORKSPACE_ID') from sys.dual)
   and h.flow_id           (+) = i.flow_id
   and h.flow_item_id      (+) = i.id
   and h.security_group_id (+) = i.security_group_id
   and l.flow_id           (+) = i.flow_id
   and l.lov_name          (+) = i.named_lov
   and l.security_group_id (+) = i.security_group_id
/
create or replace trigger wwv_flow_step_items_dev_iot
instead of insert or update or delete
on wwv_flow_step_items_dev
for each row
declare
    l_new_id    number;
    l_named_lov wwv_flow_lists_of_values$.lov_name%type;
begin
    if deleting then
        delete from wwv_flow_step_items
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    else
        l_new_id := :new.id;

        if :new.named_lov_id is not null then
            select lov_name
              into l_named_lov
              from wwv_flow_lists_of_values$
             where id                = :new.named_lov_id
               and flow_id           = :new.flow_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        end if;

        if inserting then
            insert into wwv_flow_step_items (
                id,
                flow_id,
                flow_step_id,
                name,
                name_length,
                data_type,
                is_required,
                standard_validations,
                accept_processing,
                item_sequence,
                item_plug_id,
                use_cache_before_default,
                item_default,
                item_default_type,
                prompt,
                placeholder,
                pre_element_text,
                post_element_text,
                format_mask,
                item_field_template,
                item_template_options,
                item_css_classes,
                item_icon_css_classes,
                source,
                source_type,
                source_post_computation,
                display_as,
                read_only_when_type,
                read_only_when,
                read_only_when2,
                read_only_disp_attr,
                named_lov,
                lov,
                lov_columns,
                lov_display_extra,
                lov_display_null,
                lov_null_text,
                lov_null_value,
                lov_translated,
                lov_cascade_parent_items,
                ajax_items_to_submit,
                ajax_optimize_refresh,
                csize,
                cmaxlength,
                cheight,
                cattributes,
                cattributes_element,
                tag_css_classes,
                tag_attributes,
                tag_attributes2,
                button_image,
                button_image_attr,
                new_grid,
                begin_on_new_line,
                begin_on_new_field,
                colspan,
                rowspan,
                grid_column,
                grid_label_column_span,
                grid_column_css_classes,
                label_alignment,
                field_alignment,
                field_template,
                label_cell_attr,
                field_cell_attr,
                display_when,
                display_when2,
                display_when_type,
                warn_on_unsaved_changes,
                is_persistent,
                protection_level,
                escape_on_http_input,
                escape_on_http_output,
                restricted_characters,
                security_scheme,
                required_patch,
                encrypt_session_state_yn,
                inline_help_text,
                show_quick_picks,
                quick_pick_label_01,
                quick_pick_value_01,
                quick_pick_label_02,
                quick_pick_value_02,
                quick_pick_label_03,
                quick_pick_value_03,
                quick_pick_label_04,
                quick_pick_value_04,
                quick_pick_label_05,
                quick_pick_value_05,
                quick_pick_label_06,
                quick_pick_value_06,
                quick_pick_label_07,
                quick_pick_value_07,
                quick_pick_label_08,
                quick_pick_value_08,
                quick_pick_label_09,
                quick_pick_value_09,
                quick_pick_label_10,
                quick_pick_value_10,
                quick_pick_link_attr,
                plugin_init_javascript_code,
                attribute_01,
                attribute_02,
                attribute_03,
                attribute_04,
                attribute_05,
                attribute_06,
                attribute_07,
                attribute_08,
                attribute_09,
                attribute_10,
                attribute_11,
                attribute_12,
                attribute_13,
                attribute_14,
                attribute_15,
                button_execute_validations,
                button_redirect_url,
                button_action,
                button_is_hot,
                security_group_id,
                created_by,
                created_on,
                last_updated_by,
                last_updated_on,
                item_comment )
            values (
                l_new_id,
                :new.flow_id,
                :new.flow_step_id,
                :new.name,
                :new.name_length,
                :new.data_type,
                :new.is_required,
                :new.standard_validations,
                :new.accept_processing,
                :new.item_sequence,
                :new.item_plug_id,
                :new.use_cache_before_default,
                :new.item_default,
                :new.item_default_type,
                :new.prompt,
                :new.placeholder,
                :new.pre_element_text,
                :new.post_element_text,
                :new.format_mask,
                :new.item_field_template,
                :new.item_template_options,
                :new.item_css_classes,
                :new.item_icon_css_classes,
                :new.source,
                :new.source_type,
                :new.source_post_computation,
                :new.display_as,
                :new.read_only_when_type,
                :new.read_only_when,
                :new.read_only_when2,
                :new.read_only_disp_attr,
                l_named_lov,
                :new.lov,
                :new.lov_columns,
                case
                  when :new.lov_display_extra = 'Y' then 'YES'
                  when :new.lov_display_extra = 'N' then 'NO'
                end,
                case
                  when :new.lov_display_null = 'Y' then 'YES'
                  when :new.lov_display_null = 'N' then 'NO'
                end,
                :new.lov_null_text,
                :new.lov_null_value,
                :new.lov_translated,
                :new.lov_cascade_parent_items,
                :new.ajax_items_to_submit,
                :new.ajax_optimize_refresh,
                :new.csize,
                :new.cmaxlength,
                :new.cheight,
                :new.cattributes,
                :new.cattributes_element,
                :new.tag_css_classes,
                :new.tag_attributes,
                :new.tag_attributes2,
                :new.button_image,
                :new.button_image_attr,
                :new.new_grid,
                :new.begin_on_new_line,
                :new.begin_on_new_field,
                :new.colspan,
                :new.rowspan,
                :new.grid_column,
                :new.grid_label_column_span,
                :new.grid_column_css_classes,
                :new.label_alignment,
                :new.field_alignment,
                :new.field_template,
                :new.label_cell_attr,
                :new.field_cell_attr,
                :new.display_when,
                :new.display_when2,
                :new.display_when_type,
                :new.warn_on_unsaved_changes,
                :new.is_persistent,
                :new.protection_level,
                :new.escape_on_http_input,
                :new.escape_on_http_output,
                :new.restricted_characters,
                :new.security_scheme,
                :new.required_patch,
                :new.encrypt_session_state_yn,
                :new.inline_help_text,
                :new.show_quick_picks,
                :new.quick_pick_label_01,
                :new.quick_pick_value_01,
                :new.quick_pick_label_02,
                :new.quick_pick_value_02,
                :new.quick_pick_label_03,
                :new.quick_pick_value_03,
                :new.quick_pick_label_04,
                :new.quick_pick_value_04,
                :new.quick_pick_label_05,
                :new.quick_pick_value_05,
                :new.quick_pick_label_06,
                :new.quick_pick_value_06,
                :new.quick_pick_label_07,
                :new.quick_pick_value_07,
                :new.quick_pick_label_08,
                :new.quick_pick_value_08,
                :new.quick_pick_label_09,
                :new.quick_pick_value_09,
                :new.quick_pick_label_10,
                :new.quick_pick_value_10,
                :new.quick_pick_link_attr,
                :new.plugin_init_javascript_code,
                :new.attribute_01,
                :new.attribute_02,
                :new.attribute_03,
                :new.attribute_04,
                :new.attribute_05,
                :new.attribute_06,
                :new.attribute_07,
                :new.attribute_08,
                :new.attribute_09,
                :new.attribute_10,
                :new.attribute_11,
                :new.attribute_12,
                :new.attribute_13,
                :new.attribute_14,
                :new.attribute_15,
                :new.button_execute_validations,
                :new.button_redirect_url,
                :new.button_action,
                :new.button_is_hot,
                wwv_flow_security.g_security_group_id,
                :new.created_by,
                :new.created_on,
                :new.last_updated_by,
                :new.last_updated_on,
                :new.item_comment )
            returning id into l_new_id;
        else
            update wwv_flow_step_items
               set flow_id                    = :new.flow_id,
                  flow_step_id               = :new.flow_step_id,
                  name                       = :new.name,
                  name_length                = :new.name_length,
                  data_type                  = :new.data_type,
                  is_required                = :new.is_required,
                  standard_validations       = :new.standard_validations,
                  accept_processing          = :new.accept_processing,
                  item_sequence              = :new.item_sequence,
                  item_plug_id               = :new.item_plug_id,
                  use_cache_before_default   = :new.use_cache_before_default,
                  item_default               = :new.item_default,
                  item_default_type          = :new.item_default_type,
                  prompt                     = :new.prompt,
                  placeholder                = :new.placeholder,
                  pre_element_text           = :new.pre_element_text,
                  post_element_text          = :new.post_element_text,
                  format_mask                = :new.format_mask,
                  item_field_template        = :new.item_field_template,
                  item_template_options      = :new.item_template_options,
                  item_css_classes           = :new.item_css_classes,
                  item_icon_css_classes      = :new.item_icon_css_classes,
                  source                     = :new.source,
                  source_type                = :new.source_type,
                  source_post_computation    = :new.source_post_computation,
                  display_as                 = :new.display_as,
                  read_only_when_type        = :new.read_only_when_type,
                  read_only_when             = :new.read_only_when,
                  read_only_when2            = :new.read_only_when2,
                  read_only_disp_attr        = :new.read_only_disp_attr,
                  named_lov                  = l_named_lov,
                  lov                        = :new.lov,
                  lov_columns                = :new.lov_columns,
                  lov_display_extra          = case when :new.lov_display_extra = 'Y' then 'YES' when :new.lov_display_extra = 'N' then 'NO' end,
                  lov_display_null           = case when :new.lov_display_null = 'Y' then 'YES' when :new.lov_display_null = 'N' then 'NO' end,
                  lov_null_text              = :new.lov_null_text,
                  lov_null_value             = :new.lov_null_value,
                  lov_translated             = :new.lov_translated,
                  lov_cascade_parent_items   = :new.lov_cascade_parent_items,
                  ajax_items_to_submit       = :new.ajax_items_to_submit,
                  ajax_optimize_refresh      = :new.ajax_optimize_refresh,
                  csize                      = :new.csize,
                  cmaxlength                 = :new.cmaxlength,
                  cheight                    = :new.cheight,
                  cattributes                = :new.cattributes,
                  cattributes_element        = :new.cattributes_element,
                  tag_css_classes            = :new.tag_css_classes,
                  tag_attributes             = :new.tag_attributes,
                  tag_attributes2            = :new.tag_attributes2,
                  button_image               = :new.button_image,
                  button_image_attr          = :new.button_image_attr,
                  new_grid                   = :new.new_grid,
                  begin_on_new_line          = :new.begin_on_new_line,
                  begin_on_new_field         = :new.begin_on_new_field,
                  colspan                    = :new.colspan,
                  rowspan                    = :new.rowspan,
                  grid_column                = :new.grid_column,
                  grid_label_column_span     = :new.grid_label_column_span,
                  grid_column_css_classes    = :new.grid_column_css_classes,
                  label_alignment            = :new.label_alignment,
                  field_alignment            = :new.field_alignment,
                  field_template             = :new.field_template,
                  label_cell_attr            = :new.label_cell_attr,
                  field_cell_attr            = :new.field_cell_attr,
                  display_when               = :new.display_when,
                  display_when2              = :new.display_when2,
                  display_when_type          = :new.display_when_type,
                  warn_on_unsaved_changes    = :new.warn_on_unsaved_changes,
                  is_persistent              = :new.is_persistent,
                  protection_level           = :new.protection_level,
                  escape_on_http_input       = :new.escape_on_http_input,
                  escape_on_http_output      = :new.escape_on_http_output,
                  restricted_characters      = :new.restricted_characters,
                  security_scheme            = :new.security_scheme,
                  required_patch             = :new.required_patch,
                  encrypt_session_state_yn   = :new.encrypt_session_state_yn,
                  inline_help_text           = :new.inline_help_text,
                  show_quick_picks           = :new.show_quick_picks,
                  quick_pick_label_01        = :new.quick_pick_label_01,
                  quick_pick_value_01        = :new.quick_pick_value_01,
                  quick_pick_label_02        = :new.quick_pick_label_02,
                  quick_pick_value_02        = :new.quick_pick_value_02,
                  quick_pick_label_03        = :new.quick_pick_label_03,
                  quick_pick_value_03        = :new.quick_pick_value_03,
                  quick_pick_label_04        = :new.quick_pick_label_04,
                  quick_pick_value_04        = :new.quick_pick_value_04,
                  quick_pick_label_05        = :new.quick_pick_label_05,
                  quick_pick_value_05        = :new.quick_pick_value_05,
                  quick_pick_label_06        = :new.quick_pick_label_06,
                  quick_pick_value_06        = :new.quick_pick_value_06,
                  quick_pick_label_07        = :new.quick_pick_label_07,
                  quick_pick_value_07        = :new.quick_pick_value_07,
                  quick_pick_label_08        = :new.quick_pick_label_08,
                  quick_pick_value_08        = :new.quick_pick_value_08,
                  quick_pick_label_09        = :new.quick_pick_label_09,
                  quick_pick_value_09        = :new.quick_pick_value_09,
                  quick_pick_label_10        = :new.quick_pick_label_10,
                  quick_pick_value_10        = :new.quick_pick_value_10,
                  quick_pick_link_attr       = :new.quick_pick_link_attr,
                  plugin_init_javascript_code = :new.plugin_init_javascript_code,
                  attribute_01               = :new.attribute_01,
                  attribute_02               = :new.attribute_02,
                  attribute_03               = :new.attribute_03,
                  attribute_04               = :new.attribute_04,
                  attribute_05               = :new.attribute_05,
                  attribute_06               = :new.attribute_06,
                  attribute_07               = :new.attribute_07,
                  attribute_08               = :new.attribute_08,
                  attribute_09               = :new.attribute_09,
                  attribute_10               = :new.attribute_10,
                  attribute_11               = :new.attribute_11,
                  attribute_12               = :new.attribute_12,
                  attribute_13               = :new.attribute_13,
                  attribute_14               = :new.attribute_14,
                  attribute_15               = :new.attribute_15,
                  button_execute_validations = :new.button_execute_validations,
                  button_redirect_url        = :new.button_redirect_url,
                  button_action              = :new.button_action,
                  button_is_hot              = :new.button_is_hot,
                  created_by                 = :new.created_by,
                  created_on                 = :new.created_on,
                  last_updated_by            = :new.last_updated_by,
                  last_updated_on            = :new.last_updated_on,
                  item_comment               = :new.item_comment
             where id                = :old.id
               and flow_id           = :old.flow_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        end if;
        --
        -- processing help_text
        --
        if  :new.help_text is not null
            and (inserting or :old.help_text is null)
        then
            begin
                insert into wwv_flow_step_item_help (
                    security_group_id,
                    flow_id,
                    flow_item_id,
                    help_text )
                values (
                    wwv_flow_security.g_security_group_id,
                    :new.flow_id,
                    l_new_id,
                    :new.help_text );
            exception when dup_val_on_index then
                update wwv_flow_step_item_help
                   set help_text = :new.help_text
                 where flow_item_id      = l_new_id
                   and flow_id           = :new.flow_id
                   and security_group_id = wwv_flow_security.g_security_group_id;
            end;
        elsif :new.help_text <> :old.help_text then
            update wwv_flow_step_item_help
               set help_text = :new.help_text
             where flow_item_id      = l_new_id
               and flow_id           = :new.flow_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        elsif :new.help_text is null and updating then
            delete from wwv_flow_step_item_help
             where flow_item_id      = l_new_id
               and flow_id           = :old.flow_id
               and security_group_id = wwv_flow_security.g_security_group_id;
        end if;
    end if;
end wwv_flow_step_items_dev_iot;
/
show err

--==============================================================================
-- view+iot for branches
--==============================================================================
prompt ...wwv_flow_step_branches_dev
create or replace force view wwv_flow_step_branches_dev
as
select id,
       flow_id,
       flow_step_id,
       coalesce (
           branch_name,
           case branch_type
             when 'REDIRECT_URL' then
                 wwv_flow_lang.system_message('LAYOUT.T_REDIRECT_TO_PG')||' '||
                 case
                   when branch_action like 'f?p%' then regexp_substr(branch_action, 'f\?p=[^:]*:([^:]*)', 1, 1, null, 1)
                   else branch_action
                 end
             when 'BRANCH_TO_STEP' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_PG')||' '||branch_action
             when 'BRANCH_TO_PAGE_ACCEPT' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_PAGE_ACCEPT')||' '||branch_action
             when 'BRANCH_TO_PAGE_IDENT_BY_ITEM' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_PAGE_IDENTIFIED_BY_ITEM')
             when 'BRANCH_TO_FUNCTION_RETURNING_PAGE' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_FUNCTION_RETURNING_PAGE')
             when 'BRANCH_TO_FUNCTION_RETURNING_URL' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_FUNCTION_RETURNING_URL')
             when 'BRANCH_TO_URL_IDENT_BY_ITEM' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_URL_IDENTIFIED_BY_ITEM')
             when 'PLSQL' then wwv_flow_lang.system_message('LAYOUT.T_BRANCH_TO_PLSQL')
             else branch_type
           end )
       branch_name,
       case
         when branch_type = 'REDIRECT_URL' then branch_action
       end branch_redirect_url,
       case
         when branch_type = 'BRANCH_TO_STEP' then branch_action
         when branch_type <> 'BRANCH_TO_PAGE_ACCEPT' then null
         when instr(branch_action, '|') > 0 then substr(branch_action, 1, instr(branch_action, '|')-1)
         else branch_action
       end branch_page_number,
       case
         when branch_type = 'BRANCH_TO_PAGE_ACCEPT' and instr(branch_action, '|') > 0
         then substr(branch_action, instr(branch_action, '|')+1)
       end branch_accept_request,
       case
         when branch_type in ('BRANCH_TO_PAGE_IDENT_BY_ITEM','BRANCH_TO_URL_IDENT_BY_ITEM') then branch_action
       end branch_item,
       case
         when branch_type in ('BRANCH_TO_FUNCTION_RETURNING_PAGE','BRANCH_TO_FUNCTION_RETURNING_URL') then branch_action
       end branch_plsql_function_body,
       case
         when branch_type = 'PLSQL' then branch_action
       end branch_plsql,
       branch_point,
       branch_when_button_id,
       branch_type,
       branch_sequence,
       clear_page_cache,
       nvl(save_state_before_branch_yn, 'N') save_state_before_branch_yn,
       branch_condition_type,
       branch_condition,
       branch_condition_text,
       required_patch,
       security_scheme,
       security_group_id,
       nvl( last_updated_by, created_by ) as last_updated_by,
       nvl( last_updated_on, created_on ) as last_updated_on,
       branch_comment
  from wwv_flow_step_branches
 where security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
/
create or replace trigger wwv_flow_step_branches_dev_iot
instead of insert or update or delete on wwv_flow_step_branches_dev
for each row
declare
    l_action wwv_flow_step_branches.branch_action%type;
    procedure compute_values
    is
    begin
        if :new.branch_type = 'REDIRECT_URL' then
            l_action := :new.branch_redirect_url;
        elsif :new.branch_type = 'BRANCH_TO_STEP' then
            l_action := :new.branch_page_number;
        elsif :new.branch_type in ('BRANCH_TO_PAGE_IDENT_BY_ITEM','BRANCH_TO_URL_IDENT_BY_ITEM') then
            l_action := :new.branch_item;
        elsif :new.branch_type in ('BRANCH_TO_FUNCTION_RETURNING_PAGE','BRANCH_TO_FUNCTION_RETURNING_URL') then
            l_action := :new.branch_plsql_function_body;
        elsif :new.branch_type = 'PLSQL' then
            l_action := :new.branch_plsql;
        elsif :new.branch_type = 'BRANCH_TO_PAGE_ACCEPT' then
            l_action := :new.branch_page_number||
                        case when :new.branch_accept_request is not null then
                          '|'||:new.branch_accept_request
                        end;
        else
            wwv_flow_error.raise_masked_internal_error (
                p_error_message => 'invalid branch type "%0"',
                p0              => :new.branch_type );
        end if;
    end compute_values;
begin
    if inserting then
        compute_values;
        insert into wwv_flow_step_branches (
            id,
            flow_id,
            flow_step_id,
            branch_name,
            branch_action,
            branch_point,
            branch_when_button_id,
            branch_type,
            branch_sequence,
            clear_page_cache,
            save_state_before_branch_yn,
            branch_condition_type,
            branch_condition,
            branch_condition_text,
            required_patch,
            security_scheme,
            security_group_id,
            branch_comment )
        values (
            :new.id,
            :new.flow_id,
            :new.flow_step_id,
            :new.branch_name,
            l_action,
            :new.branch_point,
            :new.branch_when_button_id,
            :new.branch_type,
            :new.branch_sequence,
            :new.clear_page_cache,
            :new.save_state_before_branch_yn,
            :new.branch_condition_type,
            :new.branch_condition,
            :new.branch_condition_text,
            :new.required_patch,
            :new.security_scheme,
            wwv_flow_security.g_security_group_id,
            :new.branch_comment );
    elsif updating then
        compute_values;
        wwv_flow_debug.trace('...updating branch %s (type=%s) to action %s', :new.id, :new.branch_type, l_action);
        update wwv_flow_step_branches
           set flow_id                     = :new.flow_id,
               flow_step_id                = :new.flow_step_id,
               branch_name                 = :new.branch_name,
               branch_action               = l_action,
               branch_point                = :new.branch_point,
               branch_when_button_id       = :new.branch_when_button_id,
               branch_type                 = :new.branch_type,
               branch_sequence             = :new.branch_sequence,
               clear_page_cache            = :new.clear_page_cache,
               save_state_before_branch_yn = :new.save_state_before_branch_yn,
               branch_condition_type       = :new.branch_condition_type,
               branch_condition            = :new.branch_condition,
               branch_condition_text       = :new.branch_condition_text,
               required_patch              = :new.required_patch,
               security_scheme             = :new.security_scheme,
               branch_comment              = :new.branch_comment
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    else
        delete from wwv_flow_step_branches
         where id                = :old.id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end wwv_flow_step_branches_dev_iot;
/
show err

--==============================================================================
-- view+iot for chart5
--==============================================================================
prompt ...wwv_flow_charts5_dev
create or replace force view wwv_flow_charts5_dev
as
select x.*,
       case
         when gantt_start_date      is not null then 'STATIC'
         when gantt_start_date_item is not null then 'ITEM'
       end as gantt_start_date_type,
       case
         when gantt_end_date      is not null then 'STATIC'
         when gantt_end_date_item is not null then 'ITEM'
       end as gantt_end_date_type,
       -- if it's the leaf level, return the complete map file path
       case when map_source_level_1 like '%.amap' then map_source else map_source_level_1 end as map_level_1,
       case when map_source_level_2 like '%.amap' then map_source else map_source_level_2 end as map_level_2,
       case when map_source_level_3 like '%.amap' then map_source else map_source_level_3 end as map_level_3,
       case when map_source_level_4 like '%.amap' then map_source else map_source_level_4 end as map_level_4
  from ( select id,
                flow_id,
                page_id,
                region_id,
                case
                  when chart_type in ( '2DPie', '3DPie' ) then 'PIE'
                  when chart_type = '2DDoughnut'          then 'DOUGHNUT'
                  when chart_type = 'GaugeChart'          then 'DIAL'
                  when chart_type = '2DLine'              then 'LINE'
                  when chart_type = 'Candlestick'         then 'CANDLESTICK'
                  when chart_type = 'ScatterMarker'       then 'SCATTER_MARKER'
                  when chart_type = 'ProjectGantt'        then 'PROJECT_GANTT'
                  when chart_type = 'ResourceGantt'       then 'RESOURCE_GANTT'
                  when chart_type in ( '2DColumn', '3DColumn' )               then 'COLUMN'
                  when chart_type in ( 'Range2DColumn', 'Range3DColumn' )     then 'RANGE_COLUMN'
                  when chart_type in ( 'Stacked3DColumn', 'Stacked2DColumn' ) then 'STACKED_COLUMN'
                  when chart_type in ( '3DSTACKED_PCT', '2DSTACKED_PCT' )     then 'STACKED_COLUMN_PCT'
                  when chart_type in ( 'Horizontal2DColumn', 'Horizontal3DColumn' )               then 'BAR'
                  when chart_type in ( 'HorizontalRange3DColumn', 'HorizontalRange2DColumn' )     then 'RANGE_BAR'
                  when chart_type in ( 'StackedHorizontal3DColumn', 'StackedHorizontal2DColumn' ) then 'STACKED_BAR'
                  when chart_type in ( '3DHSTACKED_PCT', '2DHSTACKED_PCT' )                       then 'STACKED_BAR_PCT'
                  when chart_type = 'Map'                 then 'MAP'
                  else upper( chart_type )
                end as chart_type,
                case when chart_type like '%3D%' then 'Y' else 'N' end as enable_3d_mode,
                nvl( chart_rendering, 'FLASH_PREFERRED' )              as chart_rendering,
                chart_width,
                chart_height,
                chart_title,
                -- Chart title font column defined as <face>:<size>:<color>
                regexp_substr( chart_title_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as chart_title_font_face,
                regexp_substr( chart_title_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as chart_title_font_size,
                regexp_substr( chart_title_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as chart_title_font_color,
                -- Margin columns defined as <top>:<bottom>:<left>:<right>
                regexp_substr( margins, '([^:]*)(:|$)', 1, 1, null, 1 ) as chart_margin_top,
                regexp_substr( margins, '([^:]*)(:|$)', 1, 2, null, 1 ) as chart_margin_bottom,
                regexp_substr( margins, '([^:]*)(:|$)', 1, 3, null, 1 ) as chart_margin_left,
                regexp_substr( margins, '([^:]*)(:|$)', 1, 4, null, 1 ) as chart_margin_right,
                -- Display Attributes column defined as
                -- <1-enable 3d mode>:<2-show hints>:<3-show names>:<4-show values>:<5-show grid>:<6-show scrollbar>:<7-show legend>:<8-group series>:<9-legend layout>:
                -- <10-legend background>:<11-show marker>:<12-multi y-axes>:<13-multi x-axes>:<14-hatch pattern>:<15-invert x-axis>:<16-invert y-axis>:<17-series style>:
                -- <18-overlay>:<19-sort overlay>:<20-color scheme level>:<21-smart axis calculation>
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 2, null, 1 ) = 'H' then 'Y' else 'N' end  as show_tooltip,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 3, null, 1 ) = 'N' then 'Y' else 'N' end  as show_label,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 4, null, 1 ) = 'V' then 'Y' else 'N' end  as show_value,
                regexp_substr( display_attr, '([^:]*)(:|$)', 1, 5, null, 1 )                                        as chart_grid_type,
                nvl( regexp_substr( display_attr, '([^:]*)(:|$)', 1, 6, null, 1 ), 'N' )                            as show_scrollbars,
                regexp_substr( display_attr, '([^:]*)(:|$)', 1, 7, null, 1 )                                        as show_legend,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 8, null, 1 ) = 'Y' then 'Y' else 'N' end  as group_by_series,
                regexp_substr( display_attr, '([^:]*)(:|$)', 1, 9, null, 1 )                                        as legend_element_orientation,
                nvl( regexp_substr( display_attr, '([^:]*)(:|$)', 1, 10, null, 1 ), 'N' )                           as show_legend_background,
                regexp_substr( display_attr, '([^:]*)(:|$)', 1, 11, null, 1 )                                       as marker,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 12, null, 1 ) = 'Y' then 'Y' else 'N' end as y_axis_multiple,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 13, null, 1 ) = 'Y' then 'Y' else 'N' end as x_axis_multiple,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 14, null, 1 ) = 'Y' then 'Y' else 'N' end as hatch_pattern,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 15, null, 1 ) = 'Y' then 'Y' else 'N' end as x_axis_inverted,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 16, null, 1 ) = 'Y' then 'Y' else 'N' end as y_axis_inverted,
                nvl( regexp_substr( display_attr, '([^:]*)(:|$)', 1, 17, null, 1 ), 'Default' )                     as series_style,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 18, null, 1 ) = 'Y' then 'Y' else 'N' end as y_axis_overlay,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 19, null, 1 ) = 'Y' then 'Y' else 'N' end as y_axis_overlay_sorted,
                nvl( regexp_substr( display_attr, '([^:]*)(:|$)', 1, 20, null, 1 ), 'S' )                           as color_level,
                case when regexp_substr( display_attr, '([^:]*)(:|$)', 1, 21, null, 1 ) = 'Y' then 'Y' else 'N' end as smart_axis_calculation,
                color_scheme,
                custom_colors,
                chart_bgtype   as background_color_type,
                chart_bgcolor  as background_color,
                chart_bgcolor2 as background_color_2,
                nvl( chart_gradient_angle, 0 ) as background_gradient_angle,
                nvl( chart_animation, 'N' ) as animation,
                x_axis_min,
                x_axis_max,
                x_axis_prefix,
                x_axis_postfix,
                x_axis_major_interval,
                x_axis_minor_interval,
                x_axis_decimal_place as x_axis_decimal_places,
                x_axis_label_rotation,
                -- X axis label font column defined as <face>:<size>:<color>
                regexp_substr( x_axis_label_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as x_axis_label_font_face,
                regexp_substr( x_axis_label_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as x_axis_label_font_size,
                regexp_substr( x_axis_label_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as x_axis_label_font_color,
                x_axis_title,
                -- X axis title font column defined as <face>:<size>:<color>
                regexp_substr( x_axis_title_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as x_axis_title_font_face,
                regexp_substr( x_axis_title_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as x_axis_title_font_size,
                regexp_substr( x_axis_title_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as x_axis_title_font_color,
                y_axis_min,
                y_axis_max,
                extra_y_axis_min,
                extra_y_axis_max,
                y_axis_prefix,
                y_axis_postfix,
                y_axis_major_interval,
                y_axis_minor_interval,
                y_axis_decimal_place as y_axis_decimal_places,
                y_axis_label_rotation,
                -- Y axis label font column defined as <face>:<size>:<color>
                regexp_substr( y_axis_label_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as y_axis_label_font_face,
                regexp_substr( y_axis_label_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as y_axis_label_font_size,
                regexp_substr( y_axis_label_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as y_axis_label_font_color,
                y_axis_title,
                -- Y axis title font column defined as <face>:<size>:<color>
                regexp_substr( y_axis_title_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as y_axis_title_font_face,
                regexp_substr( y_axis_title_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as y_axis_title_font_size,
                regexp_substr( y_axis_title_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as y_axis_title_font_color,
                -- Dial tick attribute column defined as
                -- <1-major ticks>:<2-minor ticks><3-tick labels>:<4-gauge frame>:<5-gauge pointer><6-major interval>:<7-minor interval>:
                -- <8-start angle>:<9-sweep angle>:<10-label rotation>:<11-label alignment>:<12-invert scale>
                case when regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 1, null, 1 ) = 'T' then 'Y' else 'N' end as show_major_ticks,
                case when regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 2, null, 1 ) = 'T' then 'Y' else 'N' end as show_minor_ticks,
                case when regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 3, null, 1 ) = 'N' then 'Y' else 'N' end as show_tick_labels,
                regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  4, null, 1 )             as gauge_frame_type,
                regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  5, null, 1 )             as gauge_pointer,
                to_number( regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  6, null, 1 )) as gauge_major_interval,
                to_number( regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  7, null, 1 )) as gauge_minor_interval,
                to_number( regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  8, null, 1 )) as gauge_start_angle,
                to_number( regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1,  9, null, 1 )) as gauge_sweep_angle,
                regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 10, null, 1 )             as label_rotation,
                regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 11, null, 1 )             as gauge_label_alignment,
                case when regexp_substr( dial_tick_attr, '([^:]*)(:|$)', 1, 12, null, 1 ) = 'Y'  then 'Y' else 'N' end as scale_inverted,
                gantt_date_format,
                gantt_start_date,
                gantt_end_date,
                -- Gantt attribute column defined as
                -- <1-show navigation bar>:<2-actual start>:<3-actual end>:<4-actual shape>:
                -- <5-progress start>:<6-progress end>:<7-progress shape>:
                -- <8-baseline start>:<9-baseline end>:<10-baseline shape>:
                -- <11-line height>:<12-item height>:<13-item padding>:<14-show datagrid>:<15-show datagrid id>:
                -- <16-show datagrid name>:<17-show datagrid start>:<18-show datagrid end>:
                -- <19-start date item>:<20-end date item>
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  1, null, 1 ), 'Y' )    as gantt_show_navigation_bar,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  2, null, 1 ), 'None' ) as gantt_actual_start,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  3, null, 1 ), 'None' ) as gantt_actual_end,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  4, null, 1 ), 'Full' ) as gantt_actual_shape,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  5, null, 1 ), 'None' ) as gantt_progress_start,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  6, null, 1 ), 'None' ) as gantt_progress_end,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  7, null, 1 ), 'Full' ) as gantt_progress_shape,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  8, null, 1 ), 'None' ) as gantt_baseline_start,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1,  9, null, 1 ), 'None' ) as gantt_baseline_end,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 10, null, 1 ), 'Full' ) as gantt_baseline_shape,
                nvl( to_number( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 11, null, 1 )), 30 ) as gantt_timeline_height,
                nvl( to_number( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 12, null, 1 )), 15 ) as gantt_item_height,
                nvl( to_number( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 13, null, 1 )), 5  ) as gantt_item_padding,
                nvl( regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 14, null, 1 ), 'Y' ) as gantt_show_datagrid,
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 15, null, 1 ) || ':' ||
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 16, null, 1 ) || ':' ||
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 17, null, 1 ) || ':' ||
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 18, null, 1 )             as gantt_include_on_datagrid,
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 19, null, 1 )             as gantt_start_date_item,
                regexp_substr( gantt_attr, '([^:]*)(:|$)', 1, 20, null, 1 )             as gantt_end_date_item,
                -- Map Level
                map_source,
                regexp_substr( map_source, '([^/]*)(/|$)', 1,  1, null, 1 ) as map_source_level_1,
                regexp_substr( map_source, '([^/]*)(/|$)', 1,  2, null, 1 ) as map_source_level_2,
                regexp_substr( map_source, '([^/]*)(/|$)', 1,  3, null, 1 ) as map_source_level_3,
                regexp_substr( map_source, '([^/]*)(/|$)', 1,  4, null, 1 ) as map_source_level_4,
                -- Map attribute column defined as
                -- <1-map projection>:<2-label display mode>:<3-map region column>:<4-show zoom>
                -- <5-show navigation>:<6-legend item source>:<7-map centroid x>:<8-map centroid y>
                -- <9-map center>:<10-set undefined colors>:<11:undefined hatch pattern>
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 1, null, 1 ) as map_projection,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 2, null, 1 ) as value_display_mode,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 3, null, 1 ) as map_region_column,
                nvl( regexp_substr( map_attr, '([^:]*)(:|$)', 1, 4, null, 1 ), 'N' ) as zoom_panel,
                nvl( regexp_substr( map_attr, '([^:]*)(:|$)', 1, 5, null, 1 ), 'N' ) as navigation_panel,
                nvl( regexp_substr( map_attr, '([^:]*)(:|$)', 1, 6, null, 1 ), 'Series' ) as legend_item_source,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 7, null, 1 ) as map_centroid_x,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 8, null, 1 ) as map_centroid_y,
                case -- Remove garbage data contained in old chart maps (bug #20681834)
                  when regexp_substr( map_attr, '([^:]*)(:|$)', 1, 9, null, 1 ) = '- Map Regions -' then null
                  else regexp_substr( map_attr, '([^:]*)(:|$)', 1, 9, null, 1 )
                end as map_center,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 10, null, 1 ) as set_undef_colors,
                regexp_substr( map_attr, '([^:]*)(:|$)', 1, 11, null, 1 ) as set_undef_hatch_pattern,
                map_undef_color_scheme,
                map_undef_custom_colors,
                grid_bgtype         as grid_background_color_type,
                grid_bgcolor        as grid_background_color,
                grid_bgcolor2       as grid_background_color_2,
                nvl( grid_gradient_angle, 0 ) as grid_background_gradient_angle,
                -- Labels font column defined as <face>:<size>:<color>
                regexp_substr( gauge_labels_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as labels_font_face,
                regexp_substr( gauge_labels_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as labels_font_size,
                regexp_substr( gauge_labels_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as labels_font_color,
                -- Pie attribute column defined as <1-label position>:<2-pie prefix>:<3-pie postfix>:<4-pie decimal places>
                regexp_substr( pie_attr, '([^:]*)(:|$)', 1, 1, null, 1 ) as label_position,
                case
                  when chart_type in ( '2DPie', '3DPie', '2DDoughnut' ) then regexp_substr( pie_attr, '([^:]*)(:|$)', 1, 2, null, 1 )
                  else values_prefix
                end as value_prefix,
                case
                  when chart_type in ( '2DPie', '3DPie', '2DDoughnut' ) then regexp_substr( pie_attr, '([^:]*)(:|$)', 1, 3, null, 1 )
                  else values_postfix
                end as value_postfix,
                regexp_substr( pie_attr, '([^:]*)(:|$)', 1, 4, null, 1 ) as value_decimal_places,
                values_rotation,
                -- Values font column defined as <face>:<size>:<color>
                regexp_substr( values_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as values_font_face,
                regexp_substr( values_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as values_font_size,
                regexp_substr( values_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as values_font_color,
                -- Hints font column defined as <face>:<size>:<color>
                regexp_substr( tooltip_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as tooltip_font_face,
                regexp_substr( tooltip_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as tooltip_font_size,
                regexp_substr( tooltip_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as tooltip_font_color,
                legend_title,
                -- Legend font column defined as <face>:<size>:<color>
                regexp_substr( legend_font, '([^:]*)(:|$)', 1, 1, null, 1 ) as legend_font_face,
                regexp_substr( legend_font, '([^:]*)(:|$)', 1, 2, null, 1 ) as legend_font_size,
                regexp_substr( legend_font, '([^:]*)(:|$)', 1, 3, null, 1 ) as legend_font_color,
                nvl( async_update, 'N' ) as async_update,
                async_time,
                nvl( use_chart_xml, 'N' ) as use_chart_xml,
                chart_xml,
                security_group_id,
                nvl( updated_by, created_by ) as last_updated_by,
                nvl( updated_on, created_on ) as last_updated_on
           from wwv_flow_flash_charts_5
          where security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
       ) x
/
create or replace trigger wwv_flow_charts5_dev_iot
instead of insert or update or delete on wwv_flow_charts5_dev
for each row
declare
    l_chart_type        wwv_flow_flash_charts_5.chart_type%type;
    l_chart_title_font  wwv_flow_flash_charts_5.chart_title_font%type;
    l_margins           wwv_flow_flash_charts_5.margins%type;
    l_display_attr      wwv_flow_flash_charts_5.display_attr%type;
    l_x_axis_label_font wwv_flow_flash_charts_5.x_axis_label_font%type;
    l_x_axis_title_font wwv_flow_flash_charts_5.x_axis_title_font%type;
    l_y_axis_label_font wwv_flow_flash_charts_5.y_axis_label_font%type;
    l_y_axis_title_font wwv_flow_flash_charts_5.y_axis_title_font%type;
    l_dial_tick_attr    wwv_flow_flash_charts_5.dial_tick_attr%type;
    l_gantt_attr        wwv_flow_flash_charts_5.gantt_attr%type;
    l_gauge_labels_font wwv_flow_flash_charts_5.gauge_labels_font%type;
    l_pie_attr          wwv_flow_flash_charts_5.pie_attr%type;
    l_values_font       wwv_flow_flash_charts_5.values_font%type;
    l_tooltip_font      wwv_flow_flash_charts_5.tooltip_font%type;
    l_legend_font       wwv_flow_flash_charts_5.legend_font%type;
    l_map_source        wwv_flow_flash_charts_5.map_source%type;
    l_map_attr          wwv_flow_flash_charts_5.map_attr%type;
    l_map_centroids     varchar2(4000);

    function get_map_centroids (
        p_map_region_id     in wwv_flow_flash_map_regions.id%type )
        return varchar2
    is
        l_map_centroid_x    wwv_flow_flash_map_regions.centroid_x%type;
        l_map_centroid_y    wwv_flow_flash_map_regions.centroid_y%type;
    begin
        select centroid_x,
               centroid_y
          into l_map_centroid_x,
               l_map_centroid_y
          from wwv_flow_flash_map_regions
         where id = p_map_region_id;

         return l_map_centroid_x || ':' ||
                l_map_centroid_y;
    exception
        when no_data_found then
            return ':';
    end get_map_centroids;

    function null_if_n (
        p_value in varchar2 )
        return varchar2
    is
    begin
        return case when p_value = 'N' then null else p_value end;
    end null_if_n;
begin
    l_chart_type :=
        case :new.chart_type
          when 'PIE'                then case when :new.enable_3d_mode = 'Y' then '3DPie' else '2DPie' end
          when 'DOUGHNUT'           then '2DDoughnut'
          when 'DIAL'               then 'GaugeChart'
          when 'LINE'               then '2DLine'
          when 'CANDLESTICK'        then 'Candlestick'
          when 'SCATTER_MARKER'     then 'ScatterMarker'
          when 'PROJECT_GANTT'      then 'ProjectGantt'
          when 'RESOURCE_GANTT'     then 'ResourceGantt'
          when 'MAP'                then 'Map'
          when 'COLUMN'             then case when :new.enable_3d_mode = 'Y' then '3DColumn'                  else '2DColumn' end
          when 'RANGE_COLUMN'       then case when :new.enable_3d_mode = 'Y' then 'Range3DColumn'             else 'Range2DColumn' end
          when 'STACKED_COLUMN'     then case when :new.enable_3d_mode = 'Y' then 'Stacked3DColumn'           else 'Stacked2DColumn' end
          when 'STACKED_COLUMN_PCT' then case when :new.enable_3d_mode = 'Y' then '3DSTACKED_PCT'             else '2DSTACKED_PCT' end
          when 'BAR'                then case when :new.enable_3d_mode = 'Y' then 'Horizontal3DColumn'        else 'Horizontal2DColumn' end
          when 'RANGE_BAR'          then case when :new.enable_3d_mode = 'Y' then 'HorizontalRange3DColumn'   else 'HorizontalRange2DColumn' end
          when 'STACKED_BAR'        then case when :new.enable_3d_mode = 'Y' then 'StackedHorizontal3DColumn' else 'StackedHorizontal2DColumn' end
          when 'STACKED_BAR_PCT'    then case when :new.enable_3d_mode = 'Y' then '3DHSTACKED_PCT'            else '2DHSTACKED_PCT' end
          else :new.chart_type
        end;
    --
    l_chart_title_font := :new.chart_title_font_face || ':' || :new.chart_title_font_size || ':' || :new.chart_title_font_color;
    l_margins          := :new.chart_margin_top || ':' || :new.chart_margin_bottom || ':' || :new.chart_margin_left || ':' || :new.chart_margin_right;
    l_display_attr     :=
        ':' ||
        case when :new.show_tooltip = 'Y' then 'H' end || ':' ||
        case when :new.show_label   = 'Y' then 'N' end || ':' ||
        case when :new.show_value   = 'Y' then 'V' end || ':' ||
        :new.chart_grid_type              || ':' ||
        null_if_n( :new.show_scrollbars ) || ':' ||
        :new.show_legend                  || ':' ||
        null_if_n( :new.group_by_series ) || ':' ||
        :new.legend_element_orientation   || ':' ||
        null_if_n( :new.show_legend_background ) || ':' ||
        :new.marker                       || ':' ||
        :new.y_axis_multiple       || ':' ||
        :new.x_axis_multiple       || ':' ||
        :new.hatch_pattern         || ':' ||
        :new.x_axis_inverted       || ':' ||
        :new.y_axis_inverted       || ':' ||
        :new.series_style          || ':' ||
        :new.y_axis_overlay        || ':' ||
        :new.y_axis_overlay_sorted || ':' ||
        :new.color_level           || ':' ||
        null_if_n( :new.smart_axis_calculation );
    l_x_axis_label_font := :new.x_axis_label_font_face || ':' || :new.x_axis_label_font_size || ':' || :new.x_axis_label_font_color;
    l_x_axis_title_font := :new.x_axis_title_font_face || ':' || :new.x_axis_title_font_size || ':' || :new.x_axis_title_font_color;
    l_y_axis_label_font := :new.y_axis_label_font_face || ':' || :new.y_axis_label_font_size || ':' || :new.y_axis_label_font_color;
    l_y_axis_title_font := :new.y_axis_title_font_face || ':' || :new.y_axis_title_font_size || ':' || :new.y_axis_title_font_color;
    l_dial_tick_attr    :=
        case when :new.show_major_ticks = 'Y' then 'T' end || ':' ||
        case when :new.show_minor_ticks = 'Y' then 'T' end || ':' ||
        case when :new.show_tick_labels = 'Y' then 'N' end || ':' ||
        :new.gauge_frame_type      || ':' ||
        :new.gauge_pointer         || ':' ||
        :new.gauge_major_interval  || ':' ||
        :new.gauge_minor_interval  || ':' ||
        :new.gauge_start_angle     || ':' ||
        :new.gauge_sweep_angle     || ':' ||
        :new.label_rotation        || ':' ||
        :new.gauge_label_alignment || ':' ||
        :new.scale_inverted;
    l_gantt_attr :=
        :new.gantt_show_navigation_bar || ':' ||
        :new.gantt_actual_start    || ':' ||
        :new.gantt_actual_end      || ':' ||
        :new.gantt_actual_shape    || ':' ||
        :new.gantt_progress_start  || ':' ||
        :new.gantt_progress_end    || ':' ||
        :new.gantt_progress_shape  || ':' ||
        :new.gantt_baseline_start  || ':' ||
        :new.gantt_baseline_end    || ':' ||
        :new.gantt_baseline_shape  || ':' ||
        :new.gantt_timeline_height || ':' ||
        :new.gantt_item_height     || ':' ||
        :new.gantt_item_padding    || ':' ||
        :new.gantt_show_datagrid   || ':' ||
        case when instr( :new.gantt_include_on_datagrid, 'I' ) > 0 then 'I' end || ':' ||
        case when instr( :new.gantt_include_on_datagrid, 'N' ) > 0 then 'N' end || ':' ||
        case when instr( :new.gantt_include_on_datagrid, 'S' ) > 0 then 'S' end || ':' ||
        case when instr( :new.gantt_include_on_datagrid, 'E' ) > 0 then 'E' end || ':' ||
        :new.gantt_start_date_item || ':' ||
        :new.gantt_end_date_item;
    l_gauge_labels_font := :new.labels_font_face || ':' || :new.labels_font_size || ':' || :new.labels_font_color;
    l_pie_attr          :=
        :new.label_position || ':' ||
        :new.value_prefix   || ':' ||
        :new.value_postfix  || ':' ||
        :new.value_decimal_places;
    l_map_source   := coalesce( :new.map_level_4, :new.map_level_3, :new.map_level_2, :new.map_level_1 );
    l_values_font  := :new.values_font_face  || ':' || :new.values_font_size  || ':' || :new.values_font_color;
    l_tooltip_font := :new.tooltip_font_face || ':' || :new.tooltip_font_size || ':' || :new.tooltip_font_color;
    l_legend_font  := :new.legend_font_face  || ':' || :new.legend_font_size  || ':' || :new.legend_font_color;

    if ( :new.chart_type = 'MAP' and :new.map_center is not null ) then
        l_map_centroids := get_map_centroids( :new.map_center );
    end if;

    l_map_attr :=
        :new.map_projection         || ':' ||
        :new.value_display_mode     || ':' ||
        :new.map_region_column      || ':' ||
        :new.zoom_panel             || ':' ||
        :new.navigation_panel       || ':' ||
        :new.legend_item_source     || ':' ||
        nvl( l_map_centroids, ':' ) || ':' ||
        :new.map_center             || ':' ||
        :new.set_undef_colors       || ':' ||
        :new.set_undef_hatch_pattern;
    --
    if inserting then
        insert into wwv_flow_flash_charts_5 (
            id,
            flow_id,
            page_id,
            region_id,
            chart_type,
            chart_rendering,
            chart_width,
            chart_height,
            chart_title,
            chart_title_font,
            margins,
            display_attr,
            color_scheme,
            custom_colors,
            chart_bgtype,
            chart_bgcolor,
            chart_bgcolor2,
            chart_gradient_angle,
            chart_animation,
            x_axis_min,
            x_axis_max,
            x_axis_prefix,
            x_axis_postfix,
            x_axis_major_interval,
            x_axis_minor_interval,
            x_axis_decimal_place,
            x_axis_label_rotation,
            x_axis_label_font,
            x_axis_title,
            x_axis_title_font,
            y_axis_min,
            y_axis_max,
            extra_y_axis_min,
            extra_y_axis_max,
            y_axis_prefix,
            y_axis_postfix,
            y_axis_major_interval,
            y_axis_minor_interval,
            y_axis_decimal_place,
            y_axis_label_rotation,
            y_axis_label_font,
            y_axis_title,
            y_axis_title_font,
            dial_tick_attr,
            gantt_date_format,
            gantt_start_date,
            gantt_end_date,
            gantt_attr,
            gauge_labels_font,
            pie_attr,
            map_source,
            values_prefix,
            values_postfix,
            values_rotation,
            values_font,
            tooltip_font,
            legend_title,
            legend_font,
            async_update,
            async_time,
            use_chart_xml,
            chart_xml,
            map_attr,
            map_undef_color_scheme,
            map_undef_custom_colors,
            grid_bgtype,
            grid_bgcolor,
            grid_bgcolor2,
            grid_gradient_angle )
        values (
            :new.id,
            :new.flow_id,
            :new.page_id,
            :new.region_id,
            l_chart_type,
            nvl( :new.chart_rendering, 'FLASH_PREFERRED' ),
            :new.chart_width,
            :new.chart_height,
            :new.chart_title,
            l_chart_title_font,
            l_margins,
            l_display_attr,
            :new.color_scheme,
            :new.custom_colors,
            :new.background_color_type,
            :new.background_color,
            :new.background_color_2,
            :new.background_gradient_angle,
            :new.animation,
            :new.x_axis_min,
            :new.x_axis_max,
            :new.x_axis_prefix,
            :new.x_axis_postfix,
            :new.x_axis_major_interval,
            :new.x_axis_minor_interval,
            :new.x_axis_decimal_places,
            :new.x_axis_label_rotation,
            l_x_axis_label_font,
            :new.x_axis_title,
            l_x_axis_title_font,
            :new.y_axis_min,
            :new.y_axis_max,
            :new.extra_y_axis_min,
            :new.extra_y_axis_max,
            :new.y_axis_prefix,
            :new.y_axis_postfix,
            :new.y_axis_major_interval,
            :new.y_axis_minor_interval,
            :new.y_axis_decimal_places,
            :new.y_axis_label_rotation,
            l_y_axis_label_font,
            :new.y_axis_title,
            l_y_axis_title_font,
            l_dial_tick_attr,
            :new.gantt_date_format,
            :new.gantt_start_date,
            :new.gantt_end_date,
            l_gantt_attr,
            l_gauge_labels_font,
            l_pie_attr,
            l_map_source,
            :new.value_prefix,
            :new.value_postfix,
            :new.values_rotation,
            l_values_font,
            l_tooltip_font,
            :new.legend_title,
            l_legend_font,
            :new.async_update,
            :new.async_time,
            :new.use_chart_xml,
            :new.chart_xml,
            l_map_attr,
            :new.map_undef_color_scheme,
            :new.map_undef_custom_colors,
            :new.grid_background_color_type,
            :new.grid_background_color,
            :new.grid_background_color_2,
            :new.grid_background_gradient_angle );
    elsif updating then
        update wwv_flow_flash_charts_5
           set chart_type                   = l_chart_type,
               chart_rendering              = nvl( :new.chart_rendering, 'FLASH_PREFERRED' ),
               chart_width                  = :new.chart_width,
               chart_height                 = :new.chart_height,
               chart_title                  = :new.chart_title,
               chart_title_font             = l_chart_title_font,
               margins                      = l_margins,
               display_attr                 = l_display_attr,
               color_scheme                 = :new.color_scheme,
               custom_colors                = :new.custom_colors,
               chart_bgtype                 = :new.background_color_type,
               chart_bgcolor                = :new.background_color,
               chart_bgcolor2               = :new.background_color_2,
               chart_gradient_angle         = :new.background_gradient_angle,
               chart_animation              = :new.animation,
               x_axis_min                   = :new.x_axis_min,
               x_axis_max                   = :new.x_axis_max,
               x_axis_prefix                = :new.x_axis_prefix,
               x_axis_postfix               = :new.x_axis_postfix,
               x_axis_major_interval        = :new.x_axis_major_interval,
               x_axis_minor_interval        = :new.x_axis_minor_interval,
               x_axis_decimal_place         = :new.x_axis_decimal_places,
               x_axis_label_rotation        = :new.x_axis_label_rotation,
               x_axis_label_font            = l_x_axis_label_font,
               x_axis_title                 = :new.x_axis_title,
               x_axis_title_font            = l_x_axis_title_font,
               y_axis_min                   = :new.y_axis_min,
               y_axis_max                   = :new.y_axis_max,
               extra_y_axis_min             = :new.extra_y_axis_min,
               extra_y_axis_max             = :new.extra_y_axis_max,
               y_axis_prefix                = :new.y_axis_prefix,
               y_axis_postfix               = :new.y_axis_postfix,
               y_axis_major_interval        = :new.y_axis_major_interval,
               y_axis_minor_interval        = :new.y_axis_minor_interval,
               y_axis_decimal_place         = :new.y_axis_decimal_places,
               y_axis_label_rotation        = :new.y_axis_label_rotation,
               y_axis_label_font            = l_y_axis_label_font,
               y_axis_title                 = :new.y_axis_title,
               y_axis_title_font            = l_y_axis_title_font,
               dial_tick_attr               = l_dial_tick_attr,
               gantt_date_format            = :new.gantt_date_format,
               gantt_start_date             = :new.gantt_start_date,
               gantt_end_date               = :new.gantt_end_date,
               gantt_attr                   = l_gantt_attr,
               gauge_labels_font            = l_gauge_labels_font,
               pie_attr                     = l_pie_attr,
               map_source                   = l_map_source,
               values_prefix                = :new.value_prefix,
               values_postfix               = :new.value_postfix,
               values_rotation              = :new.values_rotation,
               values_font                  = l_values_font,
               tooltip_font                 = l_tooltip_font,
               legend_title                 = :new.legend_title,
               legend_font                  = l_legend_font,
               async_update                 = :new.async_update,
               async_time                   = :new.async_time,
               use_chart_xml                = :new.use_chart_xml,
               chart_xml                    = :new.chart_xml,
               map_attr                     = l_map_attr,
               map_undef_color_scheme       = :new.map_undef_color_scheme,
               map_undef_custom_colors      = :new.map_undef_custom_colors,
               grid_bgtype                  = :new.grid_background_color_type,
               grid_bgcolor                 = :new.grid_background_color,
               grid_bgcolor2                = :new.grid_background_color_2,
               grid_gradient_angle          = :new.grid_background_gradient_angle
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_flash_charts_5
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err

--==============================================================================
-- view+iot for chart5 series
--==============================================================================
prompt ...wwv_flow_chart5_series_dev
create or replace force view wwv_flow_chart5_series_dev
as
select s.id,
       s.flow_id,
       c.page_id,
       s.chart_id,
       c.chart_type,
       s.series_name,
       coalesce(
           s.series_type,
           case
             when chart_type in ( 'COLUMN', 'BAR', 'STACKED_COLUMN', 'STACKED_COLUMN_PCT', 'STACKED_BAR', 'STACKED_BAR_PCT' ) then 'Bar'
             when chart_type = 'LINE'           then 'Line'
             when chart_type = 'SCATTER_MARKER' then 'Marker'
           end ) as series_type,
       s.series_seq,
       s.series_query_type,
       s.series_query,
       s.series_ajax_items_to_submit,
       nvl( s.show_action_link, 'N' ) as show_action_link,
       s.action_link,
       s.series_query_row_count_max,
       s.series_query_no_data_found,
       s.display_when_cond_type,
       s.display_when_condition,
       s.display_when_condition2,
       s.series_required_role,
       s.required_patch,
       s.security_group_id,
       nvl( s.updated_by, s.created_by ) as last_updated_by,
       nvl( s.updated_on, s.created_on ) as last_updated_on
  from wwv_flow_flash_chart5_series s,
       wwv_flow_charts5_dev c
 where s.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and c.id                = s.chart_id
   and c.security_group_id = s.security_group_id
/
create or replace trigger wwv_flow_chart5_series_dev_iot
instead of insert or update or delete on wwv_flow_chart5_series_dev
for each row
begin
    if inserting then
        insert into wwv_flow_flash_chart5_series (
            id,
            flow_id,
            chart_id,
            series_name,
            series_type,
            series_seq,
            series_query_type,
            series_query,
            series_query_parse_opt,
            series_ajax_items_to_submit,
            show_action_link,
            action_link,
            series_query_row_count_max,
            series_query_no_data_found,
            display_when_cond_type,
            display_when_condition,
            display_when_condition2,
            series_required_role,
            required_patch )
        values (
            :new.id,
            :new.flow_id,
            :new.chart_id,
            :new.series_name,
            :new.series_type,
            :new.series_seq,
            :new.series_query_type,
            :new.series_query,
            'PARSE_CHART_QUERY',
            :new.series_ajax_items_to_submit,
            :new.show_action_link,
            :new.action_link,
            :new.series_query_row_count_max,
            :new.series_query_no_data_found,
            :new.display_when_cond_type,
            :new.display_when_condition,
            :new.display_when_condition2,
            :new.series_required_role,
            :new.required_patch );
    elsif updating then
        update wwv_flow_flash_chart5_series
           set series_name                 = :new.series_name,
               series_type                 = :new.series_type,
               series_seq                  = :new.series_seq,
               series_query_type           = :new.series_query_type,
               series_query                = :new.series_query,
               series_ajax_items_to_submit = :new.series_ajax_items_to_submit,
               show_action_link            = :new.show_action_link,
               action_link                 = :new.action_link,
               series_query_row_count_max  = :new.series_query_row_count_max,
               series_query_no_data_found  = :new.series_query_no_data_found,
               display_when_cond_type      = :new.display_when_cond_type,
               display_when_condition      = :new.display_when_condition,
               display_when_condition2     = :new.display_when_condition2,
               series_required_role        = :new.series_required_role,
               required_patch              = :new.required_patch
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_flash_chart5_series
         where id                = :old.id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err

--==============================================================================
-- view+iot for jet chart axes
--==============================================================================
prompt ...wwv_flow_jet_axes_dev
create or replace force view wwv_flow_jet_axes_dev
as
select a.id,
       a.chart_id,
       a.static_id,
       a.flow_id,
       a.page_id,
       c.chart_type,
       a.axis,
       a.is_rendered,
       a.title,
       a.min,
       a.max,
       a.format_type,
       a.decimal_places,
       a.currency,
       a.numeric_pattern,
       a.format_scaling,
       a.scaling,
       a.baseline_scaling,
       a.step,
       a.position,
       a.major_tick_rendered,
       a.min_step,
       a.minor_tick_rendered,
       a.minor_step,
       a.tick_label_rendered,
       a.tick_label_rotation,
       a.tick_label_position,
       a.split_dual_y,
       a.splitter_position,
       a.axis_scale,
       a.zoom_order_seconds,
       a.zoom_order_minutes,
       a.zoom_order_hours,
       a.zoom_order_days,
       a.zoom_order_weeks,
       a.zoom_order_months,
       a.zoom_order_quarters,
       a.zoom_order_years,
       a.security_group_id,
       nvl( a.updated_by, a.created_by ) as last_updated_by,
       nvl( a.updated_on, a.created_on ) as last_updated_on
  from wwv_flow_jet_chart_axes a,
       wwv_flow_jet_charts c
 where a.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and c.id                = a.chart_id
   and c.security_group_id = a.security_group_id
/
create or replace trigger wwv_flow_jet_axes_dev_iot
instead of insert or update or delete on wwv_flow_jet_axes_dev
for each row
begin
    if inserting then
        insert into wwv_flow_jet_chart_axes (
            id,
            chart_id,
            static_id,
            flow_id,
            page_id,
            axis,
            is_rendered,
            title,
            min,
            max,
            format_type,
            decimal_places,
            currency,
            numeric_pattern,
            format_scaling,
            scaling,
            baseline_scaling,
            step,
            position,
            major_tick_rendered,
            min_step,
            minor_tick_rendered,
            minor_step,
            tick_label_rendered,
            tick_label_rotation,
            tick_label_position,
            split_dual_y,
            splitter_position,
            axis_scale,
            zoom_order_seconds,
            zoom_order_minutes,
            zoom_order_hours,
            zoom_order_days,
            zoom_order_weeks,
            zoom_order_months,
            zoom_order_quarters,
            zoom_order_years,
            security_group_id )
        values (
            :new.id,
            :new.chart_id,
            :new.static_id,
            :new.flow_id,
            :new.page_id,
            :new.axis,
            :new.is_rendered,
            :new.title,
            :new.min,
            :new.max,
            :new.format_type,
            :new.decimal_places,
            :new.currency,
            :new.numeric_pattern,
            :new.format_scaling,
            :new.scaling,
            :new.baseline_scaling,
            :new.step,
            :new.position,
            :new.major_tick_rendered,
            :new.min_step,
            :new.minor_tick_rendered,
            :new.minor_step,
            :new.tick_label_rendered,
            :new.tick_label_rotation,
            :new.tick_label_position,
            :new.split_dual_y,
            :new.splitter_position,
            :new.axis_scale,
            :new.zoom_order_seconds,
            :new.zoom_order_minutes,
            :new.zoom_order_hours,
            :new.zoom_order_days,
            :new.zoom_order_weeks,
            :new.zoom_order_months,
            :new.zoom_order_quarters,
            :new.zoom_order_years,
            wwv_flow_security.g_security_group_id );
    elsif updating then
        update wwv_flow_jet_chart_axes
           set static_id                = :new.static_id,
               is_rendered              = :new.is_rendered,
               title                    = :new.title,
               min                      = :new.min,
               max                      = :new.max,
               format_type              = :new.format_type,
               decimal_places           = :new.decimal_places,
               currency                 = :new.currency,
               numeric_pattern          = :new.numeric_pattern,
               format_scaling           = :new.format_scaling,
               scaling                  = :new.scaling,
               baseline_scaling         = :new.baseline_scaling,
               step                     = :new.step,
               position                 = :new.position,
               major_tick_rendered      = :new.major_tick_rendered,
               min_step                 = :new.min_step,
               minor_tick_rendered      = :new.minor_tick_rendered,
               minor_step               = :new.minor_step,
               tick_label_rendered      = :new.tick_label_rendered,
               tick_label_rotation      = :new.tick_label_rotation,
               tick_label_position      = :new.tick_label_position,
               split_dual_y             = :new.split_dual_y,
               splitter_position        = :new.splitter_position,
               axis_scale               = :new.axis_scale,
               zoom_order_seconds       = :new.zoom_order_seconds,
               zoom_order_minutes       = :new.zoom_order_minutes,
               zoom_order_hours         = :new.zoom_order_hours,
               zoom_order_days          = :new.zoom_order_days,
               zoom_order_weeks         = :new.zoom_order_weeks,
               zoom_order_months        = :new.zoom_order_months,
               zoom_order_quarters      = :new.zoom_order_quarters,
               zoom_order_years         = :new.zoom_order_years
         where id                       = :old.id
           and flow_id                  = :old.flow_id
           and security_group_id        = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_jet_chart_axes
         where id                = :old.id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err

--==============================================================================
-- view+iot for jet chart series
--==============================================================================
prompt ...wwv_flow_jet_series_dev
create or replace force view wwv_flow_jet_series_dev
as
select s.id,
       s.chart_id,
       s.static_id,
       s.flow_id,
       s.page_id,
       c.chart_type,
       s.seq,
       s.name,
       s.data_source_type,
       s.data_source,
       s.max_row_count,
       s.ajax_items_to_submit,
       s.location,
       s.remote_server_id,
       s.web_src_module_id,
       s.query_owner,
       s.query_table,
       s.query_where,
       s.query_order_by,
       s.source_post_processing,
       s.include_rowid_column,
       s.optimizer_hint,
       s.remote_sql_caching,
       s.remote_sql_invalidate_when,
       s.external_filter_expr,
       s.external_order_by_expr,
       s.series_type,
       nvl( s.series_type, c.chart_type ) as series_type_column_mapping,
       s.series_name_column_name,
       s.items_value_column_name,
       s.items_low_column_name,
       s.items_high_column_name,
       s.items_open_column_name,
       s.items_close_column_name,
       s.items_volume_column_name,
       s.items_x_column_name,
       s.items_y_column_name,
       s.items_z_column_name,
       s.items_target_value,
       s.items_min_value,
       s.items_max_value,
       s.group_name_column_name,
       s.group_short_desc_column_name,
       s.items_label_column_name,
       s.items_short_desc_column_name,
       s.custom_column_name,
       s.aggregate_function,
       s.link_target,
       s.link_target_type,
       s.color,
       s.q2_color,
       s.q3_color,
       s.line_style,
       s.line_width,
       s.line_type,
       s.marker_rendered,
       s.marker_shape,
       s.assigned_to_y2,
       s.items_label_rendered,
       s.items_label_position,
       s.items_label_display_as,
       s.items_label_css_classes,
       s.gantt_start_date_source,
       s.gantt_start_date_column,
       s.gantt_start_date_item,
       s.gantt_end_date_source,
       s.gantt_end_date_column,
       s.gantt_end_date_item,
       s.gantt_row_id,
       s.gantt_row_name,
       s.gantt_task_id,
       s.gantt_task_name,
       s.gantt_task_start_date,
       s.gantt_task_end_date,
       s.gantt_task_css_style,
       s.gantt_task_css_class,
       s.gantt_predecessor_task_id,
       s.gantt_successor_task_id,
       s.gantt_baseline_start_column,
       s.gantt_baseline_end_column,
       s.gantt_baseline_css_class,
       s.gantt_progress_column,
       s.gantt_progress_css_class,
       s.gantt_viewport_start_source,
       s.gantt_viewport_start_column,
       s.gantt_viewport_start_item,
       s.gantt_viewport_end_source,
       s.gantt_viewport_end_column,
       s.gantt_viewport_end_item,
       s.task_label_position,
       s.series_comment,
       s.display_when_cond_type,
       s.display_when_condition,
       s.display_when_condition2,
       s.security_scheme,
       s.required_patch,
       s.security_group_id,
       nvl( s.updated_by, s.created_by ) as last_updated_by,
       nvl( s.updated_on, s.created_on ) as last_updated_on
  from wwv_flow_jet_chart_series s,
       wwv_flow_jet_charts c
 where s.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and c.id                = s.chart_id
   and c.security_group_id = s.security_group_id
/
create or replace trigger wwv_flow_jet_series_dev_iot
instead of insert or update or delete on wwv_flow_jet_series_dev
for each row
begin
    if inserting then
        insert into wwv_flow_jet_chart_series (
            id,
            chart_id,
            security_group_id,
            static_id,
            flow_id,
            page_id,
            seq,
            name,
            data_source_type,
            data_source,
            max_row_count,
            ajax_items_to_submit,
            location,
            remote_server_id,
            web_src_module_id,
            query_owner,
            query_table,
            query_where,
            query_order_by,
            source_post_processing,
            include_rowid_column,
            optimizer_hint,
            remote_sql_caching,
            remote_sql_invalidate_when,
            external_filter_expr,
            external_order_by_expr,
            series_type,
            series_name_column_name,
            items_value_column_name,
            items_low_column_name,
            items_high_column_name,
            items_open_column_name,
            items_close_column_name,
            items_volume_column_name,
            items_x_column_name,
            items_y_column_name,
            items_z_column_name,
            items_target_value,
            items_min_value,
            items_max_value,
            group_name_column_name,
            group_short_desc_column_name,
            items_label_column_name,
            items_short_desc_column_name,
            custom_column_name,
            aggregate_function,
            color,
            q2_color,
            q3_color,
            line_style,
            line_width,
            line_type,
            marker_rendered,
            marker_shape,
            assigned_to_y2,
            items_label_rendered,
            items_label_position,
            items_label_display_as,
            items_label_css_classes,
            gantt_start_date_source,
            gantt_start_date_column,
            gantt_start_date_item,
            gantt_end_date_source,
            gantt_end_date_column,
            gantt_end_date_item,
            gantt_row_id,
            gantt_row_name,
            gantt_task_id,
            gantt_task_name,
            gantt_task_start_date,
            gantt_task_end_date,
            gantt_task_css_style,
            gantt_task_css_class,
            gantt_predecessor_task_id,
            gantt_successor_task_id,
            gantt_baseline_start_column,
            gantt_baseline_end_column,
            gantt_baseline_css_class,
            gantt_progress_column,
            gantt_progress_css_class,
            gantt_viewport_start_source,
            gantt_viewport_start_column,
            gantt_viewport_start_item,
            gantt_viewport_end_source,
            gantt_viewport_end_column,
            gantt_viewport_end_item,
            task_label_position,
            link_target,
            link_target_type,
            security_scheme,
            required_patch,
            series_comment,
            display_when_cond_type,
            display_when_condition,
            display_when_condition2 )
        values (
            :new.id,
            :new.chart_id,
            wwv_flow_security.g_security_group_id,
            :new.static_id,
            :new.flow_id,
            :new.page_id,
            :new.seq,
            :new.name,
            :new.data_source_type,
            :new.data_source,
            :new.max_row_count,
            :new.ajax_items_to_submit,
            :new.location,
            :new.remote_server_id,
            :new.web_src_module_id,
            :new.query_owner,
            :new.query_table,
            :new.query_where,
            :new.query_order_by,
            :new.source_post_processing,
            :new.include_rowid_column,
            :new.optimizer_hint,
            :new.remote_sql_caching,
            :new.remote_sql_invalidate_when,
            :new.external_filter_expr,
            :new.external_order_by_expr,
            :new.series_type,
            :new.series_name_column_name,
            :new.items_value_column_name,
            :new.items_low_column_name,
            :new.items_high_column_name,
            :new.items_open_column_name,
            :new.items_close_column_name,
            :new.items_volume_column_name,
            :new.items_x_column_name,
            :new.items_y_column_name,
            :new.items_z_column_name,
            :new.items_target_value,
            :new.items_min_value,
            :new.items_max_value,
            :new.group_name_column_name,
            :new.group_short_desc_column_name,
            :new.items_label_column_name,
            :new.items_short_desc_column_name,
            :new.custom_column_name,
            :new.aggregate_function,
            :new.color,
            :new.q2_color,
            :new.q3_color,
            :new.line_style,
            :new.line_width,
            :new.line_type,
            :new.marker_rendered,
            :new.marker_shape,
            :new.assigned_to_y2,
            :new.items_label_rendered,
            :new.items_label_position,
            :new.items_label_display_as,
            :new.items_label_css_classes,
            :new.gantt_start_date_source,
            :new.gantt_start_date_column,
            :new.gantt_start_date_item,
            :new.gantt_end_date_source,
            :new.gantt_end_date_column,
            :new.gantt_end_date_item,
            :new.gantt_row_id,
            :new.gantt_row_name,
            :new.gantt_task_id,
            :new.gantt_task_name,
            :new.gantt_task_start_date,
            :new.gantt_task_end_date,
            :new.gantt_task_css_style,
            :new.gantt_task_css_class,
            :new.gantt_predecessor_task_id,
            :new.gantt_successor_task_id,
            :new.gantt_baseline_start_column,
            :new.gantt_baseline_end_column,
            :new.gantt_baseline_css_class,
            :new.gantt_progress_column,
            :new.gantt_progress_css_class,
            :new.gantt_viewport_start_source,
            :new.gantt_viewport_start_column,
            :new.gantt_viewport_start_item,
            :new.gantt_viewport_end_source,
            :new.gantt_viewport_end_column,
            :new.gantt_viewport_end_item,
            :new.task_label_position,
            :new.link_target,
            :new.link_target_type,
            :new.security_scheme,
            :new.required_patch,
            :new.series_comment,
            :new.display_when_cond_type,
            :new.display_when_condition,
            :new.display_when_condition2 );
    elsif updating then
        update wwv_flow_jet_chart_series
           set static_id                    = :new.static_id,
               seq                          = :new.seq,
               name                         = :new.name,
               data_source_type             = :new.data_source_type,
               data_source                  = :new.data_source,
               max_row_count                = :new.max_row_count,
               ajax_items_to_submit         = :new.ajax_items_to_submit,
               location                     = :new.location,
               remote_server_id             = :new.remote_server_id,
               web_src_module_id            = :new.web_src_module_id,
               query_owner                  = :new.query_owner,
               query_table                  = :new.query_table,
               query_where                  = :new.query_where,
               query_order_by               = :new.query_order_by,
               source_post_processing       = :new.source_post_processing,
               include_rowid_column         = :new.include_rowid_column,
               optimizer_hint               = :new.optimizer_hint,
               remote_sql_caching           = :new.remote_sql_caching,
               remote_sql_invalidate_when   = :new.remote_sql_invalidate_when,
               external_filter_expr         = :new.external_filter_expr,
               external_order_by_expr       = :new.external_order_by_expr,
               series_type                  = :new.series_type,
               series_name_column_name      = :new.series_name_column_name,
               items_value_column_name      = :new.items_value_column_name,
               items_low_column_name        = :new.items_low_column_name,
               items_high_column_name       = :new.items_high_column_name,
               items_open_column_name       = :new.items_open_column_name,
               items_close_column_name      = :new.items_close_column_name,
               items_volume_column_name     = :new.items_volume_column_name,
               items_x_column_name          = :new.items_x_column_name,
               items_y_column_name          = :new.items_y_column_name,
               items_z_column_name          = :new.items_z_column_name,
               items_target_value           = :new.items_target_value,
               items_min_value              = :new.items_min_value,
               items_max_value              = :new.items_max_value,
               group_name_column_name       = :new.group_name_column_name,
               group_short_desc_column_name = :new.group_short_desc_column_name,
               items_label_column_name      = :new.items_label_column_name,
               items_short_desc_column_name = :new.items_short_desc_column_name,
               custom_column_name           = :new.custom_column_name,
               aggregate_function           = :new.aggregate_function,
               color                        = :new.color,
               q2_color                     = :new.q2_color,
               q3_color                     = :new.q3_color,
               line_style                   = :new.line_style,
               line_width                   = :new.line_width,
               line_type                    = :new.line_type,
               marker_rendered              = :new.marker_rendered,
               marker_shape                 = :new.marker_shape,
               assigned_to_y2               = :new.assigned_to_y2,
               items_label_rendered         = :new.items_label_rendered,
               items_label_position         = :new.items_label_position,
               items_label_display_as       = :new.items_label_display_as,
               items_label_css_classes      = :new.items_label_css_classes,
               gantt_start_date_source      = :new.gantt_start_date_source,
               gantt_start_date_column      = :new.gantt_start_date_column,
               gantt_start_date_item        = :new.gantt_start_date_item,
               gantt_end_date_source        = :new.gantt_end_date_source,
               gantt_end_date_column        = :new.gantt_end_date_column,
               gantt_end_date_item          = :new.gantt_end_date_item,
               gantt_row_id                 = :new.gantt_row_id,
               gantt_row_name               = :new.gantt_row_name,
               gantt_task_id                = :new.gantt_task_id,
               gantt_task_name              = :new.gantt_task_name,
               gantt_task_start_date        = :new.gantt_task_start_date,
               gantt_task_end_date          = :new.gantt_task_end_date,
               gantt_task_css_style         = :new.gantt_task_css_style,
               gantt_task_css_class         = :new.gantt_task_css_class,
               gantt_predecessor_task_id    = :new.gantt_predecessor_task_id,
               gantt_successor_task_id      = :new.gantt_successor_task_id,
               gantt_baseline_start_column  = :new.gantt_baseline_start_column,
               gantt_baseline_end_column    = :new.gantt_baseline_end_column,
               gantt_baseline_css_class     = :new.gantt_baseline_css_class,
               gantt_progress_column        = :new.gantt_progress_column,
               gantt_progress_css_class     = :new.gantt_progress_css_class,
               gantt_viewport_start_source  = :new.gantt_viewport_start_source,
               gantt_viewport_start_column  = :new.gantt_viewport_start_column,
               gantt_viewport_start_item    = :new.gantt_viewport_start_item,
               gantt_viewport_end_source    = :new.gantt_viewport_end_source,
               gantt_viewport_end_column    = :new.gantt_viewport_end_column,
               gantt_viewport_end_item      = :new.gantt_viewport_end_item,
               task_label_position          = :new.task_label_position,
               link_target                  = :new.link_target,
               link_target_type             = :new.link_target_type,
               security_scheme              = :new.security_scheme,
               required_patch               = :new.required_patch,
               series_comment               = :new.series_comment,
               display_when_cond_type       = :new.display_when_cond_type,
               display_when_condition       = :new.display_when_condition,
               display_when_condition2      = :new.display_when_condition2
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_jet_chart_series
         where id                = :old.id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err

--==============================================================================
-- view+iot for calendar series
--==============================================================================
prompt ...wwv_flow_cals_dev
create or replace force view wwv_flow_cals_dev
as
select c.id,
       c.flow_id,
       r.page_id,
       c.plug_id,
       c.date_item,
       c.end_date_item,
       c.display_type,
       c.item_format,
       c.date_column,
       c.display_column,
       nvl( c.begin_at_start_of_interval, 'N' ) as begin_at_start_of_interval,
       c.template_id,
       nvl( c.item_link_open_in, 'W' )   as item_link_open_in,
       c.item_link,
       c.day_link,
       nvl( c.start_time, 0 )            as start_time,
       nvl( c.end_time,  23 )            as end_time,
       nvl( c.time_format,    '12HOUR' ) as time_format,
       nvl( c.start_of_week,  19721105 ) as start_of_week,
       nvl( c.week_start_day, 19721105 ) as week_start_day,
       nvl( c.week_end_day,   19721111 ) as week_end_day,
       c.date_type_column,
       c.primary_key_column,
       c.drag_drop_required_role,
       c.drag_drop_process_id,
       c.data_background_color,
       c.data_text_color,
       c.include_time_with_date,
       c.agenda_cal_days_type,
       c.agenda_cal_days,
       c.security_group_id,
       c.last_updated_by,
       c.last_updated_on
  from wwv_flow_cals c,
       wwv_flow_page_plugs r
 where c.security_group_id = (select nv('WORKSPACE_ID') from sys.dual)
   and r.id                = c.plug_id
   and r.security_group_id = c.security_group_id
/
create or replace trigger wwv_flow_cals_dev_iot
instead of insert or update or delete on wwv_flow_cals_dev
for each row
begin
    if inserting then
        insert into wwv_flow_cals (
            id,
            flow_id,
            plug_id,
            display_as,
            date_item,
            end_date_item,
            display_type,
            item_format,
            date_column,
            display_column,
            begin_at_start_of_interval,
            template_id,
            item_link_open_in,
            item_link,
            day_link,
            start_time,
            end_time,
            start_of_week,
            week_start_day,
            week_end_day,
            date_type_column,
            primary_key_column,
            drag_drop_required_role,
            drag_drop_process_id,
            data_background_color,
            data_text_color,
            include_time_with_date,
            time_format,
            agenda_cal_days_type,
            agenda_cal_days )
        values (
            :new.id,
            :new.flow_id,
            :new.plug_id,
            'M',
            :new.date_item,
            :new.end_date_item,
            :new.display_type,
            :new.item_format,
            :new.date_column,
            :new.display_column,
            :new.begin_at_start_of_interval,
            :new.template_id,
            :new.item_link_open_in,
            :new.item_link,
            :new.day_link,
            :new.start_time,
            :new.end_time,
            :new.start_of_week,
            :new.week_start_day,
            :new.week_end_day,
            :new.date_type_column,
            :new.primary_key_column,
            :new.drag_drop_required_role,
            :new.drag_drop_process_id,
            :new.data_background_color,
            :new.data_text_color,
            nvl( :new.include_time_with_date, 'N' ),
            nvl( :new.time_format, '24HOUR' ),
            :new.agenda_cal_days_type,
            :new.agenda_cal_days );
    elsif updating then
        update wwv_flow_cals
           set date_item                  = :new.date_item,
               end_date_item              = :new.end_date_item,
               display_type               = :new.display_type,
               item_format                = :new.item_format,
               date_column                = :new.date_column,
               display_column             = :new.display_column,
               begin_at_start_of_interval = :new.begin_at_start_of_interval,
               template_id                = :new.template_id,
               item_link_open_in          = :new.item_link_open_in,
               item_link                  = :new.item_link,
               day_link                   = :new.day_link,
               start_time                 = :new.start_time,
               end_time                   = :new.end_time,
               start_of_week              = :new.start_of_week,
               week_start_day             = :new.week_start_day,
               week_end_day               = :new.week_end_day,
               date_type_column           = :new.date_type_column,
               primary_key_column         = :new.primary_key_column,
               drag_drop_required_role    = :new.drag_drop_required_role,
               drag_drop_process_id       = :new.drag_drop_process_id,
               data_background_color      = :new.data_background_color,
               data_text_color            = :new.data_text_color,
               include_time_with_date     = nvl( :new.include_time_with_date, 'N' ),
               time_format                = nvl( :new.time_format, '24HOUR' ),
               agenda_cal_days_type       = :new.agenda_cal_days_type,
               agenda_cal_days            = :new.agenda_cal_days
         where id                = :old.id
           and flow_id           = :old.flow_id
           and security_group_id = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_cals
         where id                = :old.id
           and security_group_id = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err

--==============================================================================
-- view+iot for Dynamic Action events
--==============================================================================
prompt ...wwv_flow_page_da_events_dev
create or replace force view wwv_flow_page_da_events_dev
as
select e.id,
       e.flow_id,
       e.page_id,
       e.security_group_id,
       e.name,
       e.event_sequence,
       e.triggering_element,
       e.triggering_element_type,
       e.triggering_region_id,
       e.triggering_button_id,
       e.condition_element_type,
       e.condition_element,
       e.triggering_condition_type,
       e.triggering_expression,
       e.bind_type,
       e.bind_delegate_to_selector,
       e.bind_event_type,
       e.bind_event_type_custom,
       e.bind_event_data,
       e.display_when_type,
       e.display_when_cond,
       e.display_when_cond2,
       e.required_patch,
       e.security_scheme,
       e.da_event_comment,
       e.created_on,
       e.created_by,
       e.last_updated_on,
       e.last_updated_by,
       case when r.plug_source_type = 'NATIVE_IG' then r.id end as ig_region_id
  from wwv_flow_page_da_events e,
       wwv_flow_page_plugs r
 where e.security_group_id     = (select nv('WORKSPACE_ID') from sys.dual)
   and e.triggering_region_id  = r.id (+)
   and e.security_group_id     = r.security_group_id(+)
/
create or replace trigger wwv_flow_page_da_events_iot
instead of insert or update or delete on wwv_flow_page_da_events_dev
for each row
begin
    if inserting then
        insert into wwv_flow_page_da_events (
            id,
            flow_id,
            page_id,
            name,
            event_sequence,
            triggering_element,
            triggering_element_type,
            triggering_region_id,
            triggering_button_id,
            condition_element_type,
            condition_element,
            triggering_condition_type,
            triggering_expression,
            bind_type,
            bind_delegate_to_selector,
            bind_event_type,
            bind_event_type_custom,
            bind_event_data,
            display_when_type,
            display_when_cond,
            display_when_cond2,
            required_patch,
            security_scheme,
            da_event_comment )
        values (
            :new.id,
            :new.flow_id,
            :new.page_id,
            :new.name,
            :new.event_sequence,
            :new.triggering_element,
            :new.triggering_element_type,
            :new.triggering_region_id,
            :new.triggering_button_id,
            :new.condition_element_type,
            :new.condition_element,
            :new.triggering_condition_type,
            :new.triggering_expression,
            :new.bind_type,
            :new.bind_delegate_to_selector,
            :new.bind_event_type,
            :new.bind_event_type_custom,
            :new.bind_event_data,
            :new.display_when_type,
            :new.display_when_cond,
            :new.display_when_cond2,
            :new.required_patch,
            :new.security_scheme,
            :new.da_event_comment );
    elsif updating then
        update wwv_flow_page_da_events
           set page_id                    = :new.page_id,
               name                       = :new.name,
               event_sequence             = :new.event_sequence,
               triggering_element         = :new.triggering_element,
               triggering_element_type    = :new.triggering_element_type,
               triggering_region_id       = :new.triggering_region_id,
               triggering_button_id       = :new.triggering_button_id,
               condition_element_type     = :new.condition_element_type,
               condition_element          = :new.condition_element,
               triggering_condition_type  = :new.triggering_condition_type,
               triggering_expression      = :new.triggering_expression,
               bind_type                  = :new.bind_type,
               bind_delegate_to_selector  = :new.bind_delegate_to_selector,
               bind_event_type            = :new.bind_event_type,
               bind_event_type_custom     = :new.bind_event_type_custom,
               bind_event_data            = :new.bind_event_data,
               display_when_type          = :new.display_when_type,
               display_when_cond          = :new.display_when_cond,
               display_when_cond2         = :new.display_when_cond2,
               required_patch             = :new.required_patch,
               security_scheme            = :new.security_scheme,
               da_event_comment           = :new.da_event_comment
         where id                 = :old.id
           and flow_id            = :old.flow_id
           and security_group_id  = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_page_da_events
         where id                 = :old.id
           and security_group_id  = wwv_flow_security.g_security_group_id;
    end if;
end;
/
show err



--==============================================================================
-- view+iot for Dynamic Action actions
--==============================================================================
prompt ...wwv_flow_page_da_actions_dev
create or replace force view wwv_flow_page_da_actions_dev
as
select a.*,
       case when r.plug_source_type = 'NATIVE_IG' then r.id end as ig_region_id
  from wwv_flow_page_da_actions a,
       wwv_flow_page_da_events e,
       wwv_flow_page_plugs r
 where a.security_group_id    = (select nv('WORKSPACE_ID') from sys.dual)
   and a.event_id             = e.id
   and a.security_group_id    = e.security_group_id
   and e.triggering_region_id = r.id (+)
   and e.security_group_id    = r.security_group_id (+)
/
create or replace trigger wwv_flow_page_da_actions_iot
instead of insert or update or delete on wwv_flow_page_da_actions_dev
for each row
begin
    if inserting then
        insert into wwv_flow_page_da_actions (
            id,
            event_id,
            flow_id,
            page_id,
            event_result,
            action_sequence,
            execute_on_page_init,
            wait_for_result,
            action,
            affected_elements_type,
            affected_region_id,
            affected_button_id,
            affected_elements,
            attribute_01,
            attribute_02,
            attribute_03,
            attribute_04,
            attribute_05,
            attribute_06,
            attribute_07,
            attribute_08,
            attribute_09,
            attribute_10,
            attribute_11,
            attribute_12,
            attribute_13,
            attribute_14,
            attribute_15,
            stop_execution_on_error,
            da_action_comment,
            plugin_init_javascript_code )
        values (
            :new.id,
            :new.event_id,
            :new.flow_id,
            :new.page_id,
            :new.event_result,
            :new.action_sequence,
            :new.execute_on_page_init,
            :new.wait_for_result,
            :new.action,
            :new.affected_elements_type,
            :new.affected_region_id,
            :new.affected_button_id,
            :new.affected_elements,
            :new.attribute_01,
            :new.attribute_02,
            :new.attribute_03,
            :new.attribute_04,
            :new.attribute_05,
            :new.attribute_06,
            :new.attribute_07,
            :new.attribute_08,
            :new.attribute_09,
            :new.attribute_10,
            :new.attribute_11,
            :new.attribute_12,
            :new.attribute_13,
            :new.attribute_14,
            :new.attribute_15,
            :new.stop_execution_on_error,
            :new.da_action_comment,
            :new.plugin_init_javascript_code );
    elsif updating then
        update wwv_flow_page_da_actions
           set id                           = :new.id,
               event_id                     = :new.event_id,
               flow_id                      = :new.flow_id,
               page_id                      = :new.page_id,
               event_result                 = :new.event_result,
               action_sequence              = :new.action_sequence,
               execute_on_page_init         = :new.execute_on_page_init,
               wait_for_result              = :new.wait_for_result,
               action                       = :new.action,
               affected_elements_type       = :new.affected_elements_type,
               affected_region_id           = :new.affected_region_id,
               affected_button_id           = :new.affected_button_id,
               affected_elements            = :new.affected_elements,
               attribute_01                 = :new.attribute_01,
               attribute_02                 = :new.attribute_02,
               attribute_03                 = :new.attribute_03,
               attribute_04                 = :new.attribute_04,
               attribute_05                 = :new.attribute_05,
               attribute_06                 = :new.attribute_06,
               attribute_07                 = :new.attribute_07,
               attribute_08                 = :new.attribute_08,
               attribute_09                 = :new.attribute_09,
               attribute_10                 = :new.attribute_10,
               attribute_11                 = :new.attribute_11,
               attribute_12                 = :new.attribute_12,
               attribute_13                 = :new.attribute_13,
               attribute_14                 = :new.attribute_14,
               attribute_15                 = :new.attribute_15,
               stop_execution_on_error      = :new.stop_execution_on_error,
               da_action_comment            = :new.da_action_comment,
               plugin_init_javascript_code  = :new.plugin_init_javascript_code
         where id                 = :old.id
           and flow_id            = :old.flow_id
           and security_group_id  = wwv_flow_security.g_security_group_id;
    elsif deleting then
        delete from wwv_flow_page_da_actions
         where id                 = :old.id
           and security_group_id  = wwv_flow_security.g_security_group_id;
    end if;

end;
/
show err


--==============================================================================
-- utility view for applications in the current workspace that are visible to
-- the current user
--==============================================================================
prompt ...wwv_flow_visible_flows
create or replace force view wwv_flow_visible_flows
as
select f.*
  from wwv_flows f
 where f.security_group_id = ( select nv('WORKSPACE_ID') from sys.dual )
   and not exists ( select 1
                      from wwv_flow_language_map m
                     where m.translation_flow_id = f.id
                       and m.security_group_id   = f.security_group_id
                       and f.authentication_id   <> trunc(f.authentication_id) )
   and exists ( select 1
                  from wwv_flow_developers d
                 where d.security_group_id = f.security_group_id
                   and d.userid            = ( select  v('APP_USER') from sys.dual )
                   and ( d.flow_id is null or d.flow_id = f.id ))
/

--==============================================================================
-- utility view for wwv_flow_company_filestats, for development environment
-- related file stats. see also wwv_flow_company_filestats_dev in view.sql.
--==============================================================================
prompt ...wwv_flow_company_filestats_dev
create or replace view wwv_flow_company_filestats_dev (
    security_group_id,
    file_type,
    file_newest,
    file_oldest,
    file_bytes,
    file_count )
as
select security_group_id, 'MIGRATION FILES', max(created_on), min(created_on), nvl(sum(sys.dbms_lob.getlength(FILE_CONTENT)),0), count(*)
from WWV_MIG_FORMS
group by security_group_id
union all
select security_group_id, 'MIGRATION FILES', max(created_on), min(created_on), nvl(sum(sys.dbms_lob.getlength(FILE_CONTENT)),0), count(*)
from WWV_MIG_FRM_MENUS
group by security_group_id
union all
select security_group_id, 'MIGRATION FILES', max(created_on), min(created_on), nvl(sum(sys.dbms_lob.getlength(FILE_CONTENT)),0), count(*)
from WWV_MIG_OLB
group by security_group_id
union all
select security_group_id, 'MIGRATION FILES', max(created_on), min(created_on), nvl(sum(sys.dbms_lob.getlength(FILE_CONTENT)),0), count(*)
from WWV_MIG_PLSQL_LIBS
group by security_group_id
union all
select security_group_id, 'MIGRATION FILES', max(created_on), min(created_on), nvl(sum(sys.dbms_lob.getlength(FILE_CONTENT)),0), count(*)
from WWV_MIG_RPTS
group by security_group_id
/

--==============================================================================
-- view for schemas that have database objects which are accessible to the
-- currently edited application in app 4000. this includes
-- - the app owner itself
-- - objects where SELECT or READ has been granted to the app owner
--==============================================================================
prompt ...wwv_flow_object_owners_dev
create or replace view wwv_flow_object_owners_dev (
    owner )
as
select f.owner
  from wwv_flows f,
       ( select nv('FB_FLOW_ID') fb_flow_id,
                nv('FLOW_SECURITY_GROUP_ID') flow_security_group_id
           from sys.dual ) ss
 where f.id                = ss.fb_flow_id
   and f.security_group_id = ss.flow_security_group_id
 union
select p.owner
  from sys.dba_tab_privs p,
       wwv_flows f,
       ( select nv('FB_FLOW_ID') fb_flow_id,
                nv('FLOW_SECURITY_GROUP_ID') flow_security_group_id
           from sys.dual ) ss
 where f.id                = ss.fb_flow_id
   and f.security_group_id = ss.flow_security_group_id
   and p.grantee           = f.owner
   and p.owner             not in ('SYS', 'SYSTEM')
   and p.privilege         in ('SELECT', 'READ')
/

--==============================================================================
-- view for objects that the app owner has access to
--==============================================================================
prompt ...wwv_flow_objects_dev
create or replace view wwv_flow_objects_dev (
    owner,
    object_type,
    object_name )
as
with flow as (
    select owner,
           fb_flow_id,
           flow_security_group_id
      from wwv_flows f,
           ( select nv('FB_FLOW_ID') fb_flow_id,
                    nv('FLOW_SECURITY_GROUP_ID') flow_security_group_id
               from sys.dual ) ss
     where f.id                =    ss.fb_flow_id
       and f.security_group_id =    ss.flow_security_group_id
)
select o.owner,
       o.object_type,
       o.object_name
  from ( select o.owner,o.object_type, o.object_name
           from sys.dba_objects o
          where o.owner = ( select /*+ cardinality (f 1) */
                                   f.owner
                              from flow f )
          union
         select p.owner,o.object_type, p.table_name
           from sys.dba_objects o,
                sys.dba_tab_privs p
          where o.owner       = p.owner
            and o.object_name = p.table_name
            and p.grantee     = ( select /*+ cardinality (f 1) */
                                         f.owner
                                    from flow f )) o
 where o.object_name not like 'BIN$%'
/

--==============================================================================
-- view for tables and views that can be used in the currently edited
-- application in app 4000.
--==============================================================================
prompt ...wwv_flow_tables_views_dev
create or replace view  wwv_flow_tables_views_dev (
    owner,
    object_type,
    object_name_esc,
    object_name,
    has_date_column )
as 
  select o.owner,
       o.object_type,
       o.object_name||' '||
       case o.object_type
           when 'TABLE' then l.t
           else l.v
           end  object_name_esc,
       o.object_name,
       case
       when 0 < ( select count(*)
                    from sys.dba_tab_columns c
                   where o.owner = c.owner
                     and o.object_name = c.table_name
                     and (   c.data_type = 'DATE'
                          or c.data_type like 'TIMESTAMP%' ))
       then 'Y'
       else 'N'
       end has_date_column
  from wwv_flow_objects_dev o
  ,    (select /*+no_merge*/ wwv_flow_lang.system_message ('TABLE_IN_PAREN') t, wwv_flow_lang.system_message ('VIEW_IN_PAREN') v from sys.dual) l
 where o.object_type in ('TABLE', 'VIEW')
order by o.owner, o.object_name
/

--==============================================================================
-- view for master/detail tables in app 4000.
--
-- The view dba_constraints can not be efficiently queried, because the owner
-- column is based on an expression (see cdcore.sql). Going via distinct
-- dba_cons_columns is the best alternative. The IS NOT NULL expressions below
-- avoid some outer joins.
--==============================================================================
prompt ...wwv_flow_detail_tables_dev
create or replace view wwv_flow_detail_tables_dev (
    master_owner,
    master_table_name,
    detail_owner,
    detail_table_name )
as
with flow as (
    select owner
      from wwv_flows f,
           ( select nv('FB_FLOW_ID') fb_flow_id,
                    nv('FLOW_SECURITY_GROUP_ID') flow_security_group_id
               from sys.dual ) ss
     where f.id                =    ss.fb_flow_id
       and f.security_group_id =    ss.flow_security_group_id
)
select distinct
       master_cc.owner,
       master_cc.table_name,
       detail_cc.owner,
       detail_cc.table_name
  from sys.dba_cons_columns master_cc,
       sys.dba_constraints  detail,
       sys.dba_cons_columns detail_cc,
       flow
 where master_cc.owner                 =    detail.r_owner
   and master_cc.constraint_name       =    detail.r_constraint_name
   and detail.owner                    =    detail_cc.owner
   and detail.constraint_name          =    detail_cc.constraint_name
   and detail.table_name               =    detail_cc.table_name
--
   and detail.constraint_type          =    'R'
   and master_cc.table_name        not like 'BIN$%'
   and detail_cc.table_name        not like 'BIN$%'
--
   and detail.r_owner           is not null
   and detail.r_constraint_name is not null
   and detail.owner             is not null
   and detail.table_name        is not null
   and detail.constraint_name   is not null
--
   and (   master_cc.owner = flow.owner
        or (master_cc.owner, master_cc.table_name) in ( select owner, table_name
                                                          from sys.dba_tab_privs p
                                                         where p.grantee = flow.owner ))
   and (   detail_cc.owner = flow.owner
        or (detail_cc.owner, detail_cc.table_name) in ( select owner, table_name
                                                          from sys.dba_tab_privs p
                                                         where p.grantee = flow.owner ))
/
--==============================================================================
-- view for table/view columns that can be used in the currently edited
-- application in app 4000.
--==============================================================================
prompt ...wwv_flow_table_columns_dev
create or replace view wwv_flow_table_columns_dev (
    owner,
    table_name,
    column_id,
    data_type,
    column_name_esc,
    column_name )
as
select c.owner,
       c.table_name,
       c.column_id,
       c.data_type,
       c.column_name||' ('||initcap(c.data_type)||')',
       c.column_name
  from sys.dba_tab_columns c,
       wwv_flow_objects_dev o
 where c.owner       =  o.owner
   and c.table_name  =  o.object_name
   and o.object_type in ('TABLE', 'VIEW')
 order by c.column_id
/

--==============================================================================
-- view for sequences that can be used in the currently edited
-- application in app 4000.
--==============================================================================
prompt ...wwv_flow_sequences_dev
create or replace view wwv_flow_sequences_dev (
    owner,
    sequence_name_esc,
    sequence_name )
as
select o.owner,
       o.object_name,
       o.object_name
  from wwv_flow_objects_dev o
 where o.object_type = 'SEQUENCE'
 order by 1, 2
/

--==============================================================================
-- view for the source code of triggers that can be used in the currently edited
-- application in app 4000.
--==============================================================================
prompt ...wwv_flow_trigger_source_dev
create or replace view wwv_flow_trigger_source_dev (
    owner,
    table_name,
    trigger_name,
    source_line,
    source_text )
as
select t.owner,
       t.table_name,
       t.trigger_name,
       s.line,
       rtrim(s.text, unistr('\000a\000d'))
  from wwv_flow_objects_dev o,
       sys.dba_triggers t,
       sys.dba_source   s
 where o.owner        =  t.owner
   and o.object_name  =  t.table_name
   and t.owner        =  s.owner
   and t.trigger_name =  s.name
   and s.type         =  'TRIGGER'
   and o.object_type  in ('TABLE', 'VIEW')
/

--==============================================================================
-- view for the Scheduler Jobs that can be monitored in the currently edited
-- application in app 4000. (used on p259 and 1315)
--==============================================================================
prompt ...wwv_flow_jobs_dev
create or replace view wwv_flow_jobs_dev (
    owner,
    job_name )
as
select owner,
       job_name
  from sys.dba_scheduler_jobs
/

--==============================================================================
-- view for application builder and page designer to maintain credential stores
-- instead-of trigger takes care for encryption of client secret
--==============================================================================
prompt ...wwv_credentials_dev
create or replace view wwv_credentials_dev
as
select
    id,
    security_group_id,
    name,
    static_id,
    authentication_type,
    client_id,
    cast( 
        case 
            when client_secret is null then null 
            else '******'
        end as varchar2(255) )    as client_secret,
    cast( null as varchar2(255) ) as client_secret_verify,
    prompt_on_install,
    credential_comment,
    last_updated_by,
    last_updated_on,
    created_by,
    created_on
from wwv_credentials
/

--==============================================================================
-- instead-of trigger for WWV_FLOW_CREDENTIAL_DEV.
-- automatically encrypt the client secret before storing in the table.
--==============================================================================
prompt ...wwv_credentials_dev_iot
create or replace trigger wwv_credentials_dev_iot
instead of insert or update or delete
on wwv_credentials_dev
for each row
declare
    l_client_secret wwv_credentials.client_secret%type;
begin
    if inserting or updating then 
        if :new.client_secret = :new.client_secret_verify then
            l_client_secret := wwv_flow_credential.encrypt_value( :new.client_secret );
        end if;
    end if;

    if inserting then
        insert into wwv_credentials (
            id, 
            security_group_id, 
            name, 
            static_id,
            authentication_type, 
            client_id,
            client_secret,
            prompt_on_install,
            credential_comment
        ) values (
            :new.id, 
            :new.security_group_id, 
            :new.name,
            :new.static_id,
            :new.authentication_type, 
            :new.client_id,
            l_client_secret,
            :new.prompt_on_install,
            :new.credential_comment );

    elsif updating then
        update wwv_credentials c set
            security_group_id   = :new.security_group_id, 
            name                = :new.name, 
            static_id           = :new.static_id,
            authentication_type = :new.authentication_type, 
            client_id           = :new.client_id,
            client_secret       = coalesce( l_client_secret, c.client_secret ),
            prompt_on_install   = :new.prompt_on_install,
            credential_comment  = :new.credential_comment
        where id                = :old.id 
          and security_group_id = :old.security_group_id;

    elsif deleting then
        delete wwv_credentials
         where id                = :old.id 
           and security_group_id = :old.security_group_id;
    end if;
end;
/
sho err

--===================================================================================
-- view WWV_FLOW_REMOTESQL_SERVERS_DEV to maintain servers for Remote SQL Data Access
-- within Application Builder. The view provides remote servers of REMOTE_SQL type 
-- together with details about the assigned credential store. 
--===================================================================================
prompt ...wwv_remotesql_servers_dev
create or replace view wwv_remotesql_servers_dev
as
select r.id,
       r.security_group_id,
       r.name                                         as server_name,
       r.static_id                                    as server_static_id,
       r.base_url,
       r.https_host,
       r.credential_id,
       case 
           when credential_id is null then 'N' 
           else                            'Y' 
       end                                            as auth_required,
       c.name                                         as credential_name,
       c.static_id                                    as credential_static_id,
       c.authentication_type,
       c.client_id,
       cast( 
           case 
               when c.client_secret is null then null 
               else '******'
           end as varchar2(255) )                     as client_secret,
       cast( null as varchar2(255) )                  as client_secret_verify,
       r.ords_timezone                                as ords_timezone,
       r.ords_init_code, 
       r.ords_cleanup_code,
       r.prompt_on_install                            as prompt_on_install,
       r.server_comment,
       r.last_updated_by,
       r.last_updated_on,
       r.created_by,
       r.created_on
  from wwv_remote_servers r, wwv_credentials c
 where r.credential_id = c.id (+)
   and r.server_type   = 'REMOTE_SQL'
/

--===================================================================================
-- instead-of trigger WWV_FLOW_REMOTESQL_SRV_DEV_IOT to implement DML on the 
-- WWV_FLOW_REMOTESQL_SERVERS_DEV view. Remote Server information is maintained in
-- the WWV_FLOW_REMOTE_SERVERS table, credentials in the WWV_FLOW_CREDENTIALS table.
-- The Client Secret is being encrypted before storage.
--===================================================================================
prompt ...wwv_remotesql_srv_dev_iot
create or replace trigger wwv_remotesql_srv_dev_iot
instead of insert or update or delete
on wwv_remotesql_servers_dev
for each row
declare
    l_client_secret wwv_credentials.client_secret%type;
    l_credential_id wwv_credentials.id%type;
    l_action        varchar2(1);
begin
    -- maintain audit table for the WWV_FLOW_REMOTESQL_SERVERS_DEV view to have separate
    -- entries for ORDS Remote SQL Access servers.
    l_action := case
                    when inserting then 'I'
                    when updating  then 'U'
                    else                'D'
                end;
    begin
        wwv_flow_audit.audit_action (
            p_table_name  => 'WWV_REMOTESQL_SERVERS_DEV',
            p_action      => l_action,
            p_table_pk    => nvl(:old.id,         :new.id),
            p_object_name => nvl(:new.server_name,:old.server_name) );
        exception when others then null;
    end;

    -- check whether we have a Client Secret and it's identical to the verify value. If yes,
    -- encrypt the client secret - otherwise keep as NULL.
    if inserting or updating then 
        if :new.client_secret is not null and :new.client_secret = :new.client_secret_verify then
            l_client_secret := wwv_flow_credential.encrypt_value( :new.client_secret );
        end if;
    end if;

    l_credential_id := :new.credential_id;

    if inserting or updating then
        -- when we have a Client Secret and *no* primary key of an existing credential, create a new
        -- row in WWV_FLOW_CREDENTIALS
        if l_credential_id is null and l_client_secret is not null then
            insert into wwv_credentials (
                security_group_id, 
                name, 
                static_id,
                authentication_type, 
                client_id,
                client_secret,
                prompt_on_install
            ) values (
                :new.security_group_id, 
                coalesce( :new.credential_name, :new.client_id || '@' || :new.server_name ),
                :new.credential_static_id,
                :new.authentication_type, 
                :new.client_id,
                l_client_secret,
                :new.prompt_on_install )
            returning id into l_credential_id;
        end if;

        if inserting then

            insert into wwv_remote_servers (
                security_group_id,
                name,
                static_id,
                base_url,
                https_host,
                server_type,
                ords_timezone,
                ords_init_code,
                ords_cleanup_code,
                credential_id,
                prompt_on_install,
                server_comment ) 
            values (
                :new.security_group_id,
                :new.server_name,
                :new.server_static_id,
                :new.base_url,
                :new.https_host,
                'REMOTE_SQL',
                :new.ords_timezone,
                :new.ords_init_code,
                :new.ords_cleanup_code,
                l_credential_id,
                :new.prompt_on_install,
                :new.server_comment );

        elsif updating then

            update wwv_remote_servers set
                   name              = :new.server_name,
                   static_id         = :new.server_static_id,
                   base_url          = :new.base_url,
                   https_host        = :new.https_host,
                   credential_id     = l_credential_id,
                   prompt_on_install = :new.prompt_on_install,
                   ords_timezone     = :new.ords_timezone,
                   ords_init_code    = :new.ords_init_code,
                   ords_cleanup_code = :new.ords_cleanup_code,
                   server_comment    = :new.server_comment
             where id                = :old.id
               and security_group_id = :old.security_group_id;

        end if;

    elsif deleting then
        -- delete only remote server, do not delete credential row
        delete wwv_remote_servers 
         where id                = :old.id 
           and security_group_id = :old.security_group_id;
    end if;
end;
/
sho err

--==============================================================================
-- utility view to show session state in builder
--==============================================================================
prompt ...wwv_flow_data_view
create or replace view wwv_flow_data_view (
    session_id,
    security_group_id,
    data_item_id,
    item_scope,
    item_name,
    item_display_as,
    item_prompt,
    item_value,
    is_encrypted,
    item_value_decrypted,
    session_state_status,
    application_id,
    application_name,
    page_id,
    page_name )
as
select
       d.flow_instance,
       d.security_group_id,
       d.item_id,
       d.scope,
       d.item_name,
       d.item_display_as,
       d.item_prompt,
       case
         when d.is_encrypted = 'Y' then '*****'
         when d.item_value_clob is not null then
           sys.dbms_lob.substr(d.item_value_clob,4000)
         else
           d.item_value_vc2
       end item_value,
       decode(is_encrypted,'Y',m_yes, m_no) is_encrypted,
       case
         when d.is_encrypted = 'Y' then
           wwv_flow_security.decrypt_session_value (
               d.item_name,
               d.item_value_vc2,
               null,
               d.crypto_salt )
         when d.item_value_clob is not null then
           sys.dbms_lob.substr(d.item_value_clob,4000)
         else
           d.item_value_vc2
       end item_value_decrypted,
       case
         when session_state_status='I' then m_inserted
         when session_state_status='U' then m_updated
         when session_state_status='R' then m_reset_to_null
         when flow_id is null          then m_internal
         else                               m_unknown||' '||session_state_status
       end session_state_status,
       d.flow_id,
       (select name from wwv_flows where id = d.flow_id) application_name,
       page_id,
       page_name
  from ( select wwv_flow_lang.system_message('F4350.INSERTED') m_inserted,
                wwv_flow_lang.system_message('F4350.UPDATED')  m_updated,
                wwv_flow_lang.system_message('RESET_TO_NULL_VALUE')  m_reset_to_null,
                wwv_flow_lang.system_message('INTERNAL')       m_internal,
                wwv_flow_lang.system_message('F4350.UNKNOWN')  m_unknown,
                wwv_flow_lang.system_message('F4000.YES')      m_yes,
                wwv_flow_lang.system_message('F4000.NO')       m_no
           from sys.dual ),
       ( select d.flow_instance,
                d.item_id,
                d.item_value_vc2,
                d.item_value_clob,
                d.is_encrypted,
                d.flow_id,
                d.session_state_status,
                s.security_group_id,
                s.crypto_salt,
                i.scope,
                i.name item_name,
                null item_display_as,
                null item_prompt,
                to_number(null) page_id,
                null page_name,
                row_number() over (
                    partition by d.flow_instance,
                                 d.item_id
                        order by i.flow_id )
                    item_ident_nr
           from wwv_flow_data d,
                wwv_flow_sessions$ s,
                wwv_flow_items i
          where d.flow_instance                                   = s.id
            and i.security_group_id                               = s.security_group_id
            and i.scope                                           = 'GLOBAL'
            and wwv_flow_session_state.get_global_item_id(i.name) = d.item_id
            and d.item_id                                         < 0
          union all
         select d.flow_instance,
                d.item_id,
                d.item_value_vc2,
                d.item_value_clob,
                d.is_encrypted,
                d.flow_id,
                d.session_state_status,
                s.security_group_id,
                s.crypto_salt,
                i.scope,
                i.name item_name,
                null,
                null,
                to_number(null),
                null,
                1
           from wwv_flow_data d,
                wwv_flow_sessions$ s,
                wwv_flow_items i
          where d.flow_instance     = s.id
            and i.security_group_id = s.security_group_id
            and i.scope             = 'APP'
            and i.id                = d.item_id
          union all
         select d.flow_instance,
                d.item_id,
                d.item_value_vc2,
                d.item_value_clob,
                d.is_encrypted,
                d.flow_id,
                d.session_state_status,
                s.security_group_id,
                s.crypto_salt,
                'PAGE',
                i.name item_name,
                i.display_as,
                i.prompt,
                i.flow_step_id,
                ( select steps.name
                    from wwv_flow_steps steps
                   where steps.flow_id           = i.flow_id
                     and steps.id                = i.flow_step_id
                     and steps.security_group_id = i.security_group_id ),
                1
           from wwv_flow_data d,
                wwv_flow_sessions$ s,
                wwv_flow_step_items i
          where d.flow_instance     = s.id
            and i.security_group_id = s.security_group_id
            and i.id                = d.item_id ) d
 where item_ident_nr = 1
/
show error
