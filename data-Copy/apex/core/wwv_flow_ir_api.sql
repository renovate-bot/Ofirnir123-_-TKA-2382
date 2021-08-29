set define '^' verify off
prompt ...wwv_flow_ir_api
create or replace package wwv_flow_ir_api
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2012. All Rights Reserved.
--
--    NAME
--      wwv_flow_ir_api.sql
--
--    DESCRIPTION
--      This package is the public API for handling Interactive Report settings
--
--    NOTES
--  
--    MODIFIED (MM/DD/YYYY)
--    cczarski  08/11/2017 - Created based on wwv_flow_worksheet_util
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------
type t_report is record (
    sql_query     varchar2(32767),
    binds         wwv_flow_plugin_util.t_bind_list);

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_view_report           constant varchar2(20) := 'REPORT';
c_view_groupby          constant varchar2(20) := 'GROUP_BY';
c_view_pivot            constant varchar2(20) := 'PIVOT';

--==============================================================================
-- Function returns last viewed base report_id for specified page and region.
--==============================================================================
function get_last_viewed_report_id (
    p_page_id       in number,
    p_region_id     in number)
    return number;
    
--==============================================================================
-- Function returns Interactive report runtime query with binds.
-- If p_report_id is null, it gets last viewed report information.
--
-- Note: This function works within the same application where the Interactive report exists 
--       and cannot be called outside of APEX environment.
--==============================================================================
function get_report (
    p_page_id        in number,
    p_region_id      in number,
    p_report_id      in number default null,
    p_view           in varchar2 default c_view_report )
    return t_report;

--==============================================================================
-- Procedure adds Interactive report column filter using report_id.
-- If p_report_id is null, it adds filter to the last viewed report.
--==============================================================================
procedure add_filter (
    p_page_id       in number,
    p_region_id     in number,
    p_report_column in varchar2,
    p_filter_value  in varchar2,
    p_operator_abbr in varchar2 default null,
    p_report_id     in number default null
    );
    
--==============================================================================
-- Procedure adds Interactive report column filter using report_alias.
-- If p_report_alias is null, it adds filter to the last viewed report.
--==============================================================================
procedure add_filter (
    p_page_id       in number,
    p_region_id     in number,
    p_report_column in varchar2,
    p_filter_value  in varchar2,
    p_operator_abbr in varchar2 default null,
    p_report_alias  in varchar2 default null
    );
    
--==============================================================================
-- Procedure resets Interactive report to the factory default settings using report_id.
-- If p_report_id is null, it resets the last viewed report.
--==============================================================================
procedure reset_report (
    p_page_id      in number,
    p_region_id    in number,
    p_report_id    in number default null);
    
--==============================================================================
-- Procedure resets Interactive report to the factory default settings using report_alias.
-- If p_report_alias is null, it resets the last viewed report.
--==============================================================================
procedure reset_report (
    p_page_id      in number,
    p_region_id    in number,
    p_report_alias in varchar2 default null);
    
--==============================================================================
-- Procedure clears Interactive report settings using report_id as follows:
--     control break, aggregate, flashback, chart, number of rows to display, 
--      filter, highlight, computation, group by
-- Procedure does NOT clear the following:
--     display column list, sorting, 
--     report preference (view mode, display nulls in detail view, expand/collapse of report settings).
-- If p_report_id is null, it clears the last viewed report settings.
--==============================================================================
procedure clear_report (
    p_page_id      in number,
    p_region_id    in number,
    p_report_id    in number default null);
    
--==============================================================================
-- Procedure clears Interactive report settings using report_alias as follows:
--     control break, aggregate, flashback, chart, number of rows to display, 
--      filter, highlight, computation, group by
-- Procedure does NOT clear the following:
--     display column list, sorting, 
--     report preference (view mode, display nulls in detail view, expand/collapse of report settings).
-- If p_report_alias is null, it clears the last viewed report settings.
--==============================================================================
procedure clear_report (
    p_page_id      in number,
    p_region_id    in number,
    p_report_alias in varchar2 default null);

--==============================================================================
-- Procedure deletes saved reports.  
-- It deletes all saved reports except the Primary Default.
--==============================================================================
procedure delete_report (
    p_report_id          in number);
    
--==============================================================================
-- Procedure deletes Interactive report subscriptions.
--==============================================================================
procedure delete_subscription (
    p_subscription_id    in number);

--==============================================================================
-- Procedure changes Interactive report subscriptions langugae.
-- When email sends out, subscription sends message in the defined language
--==============================================================================
procedure change_subscription_lang (
    p_subscription_id    in number,
    p_language           in varchar2);

--==============================================================================
-- Procedure changes Interactive report subscriptions email address.
-- When email sends out, subscription sends message to the defined email address.
--==============================================================================
procedure change_subscription_email (
    p_subscription_id    in number,
    p_email_address      in varchar2);

--==============================================================================
-- Procedure changes owner of all non-default saved reports (public, private) for the current application.
--==============================================================================
procedure change_report_owner (
    p_report_id    in number,
    p_old_owner    in varchar2,
    p_new_owner    in varchar2);
end wwv_flow_ir_api;
/
show errors;
