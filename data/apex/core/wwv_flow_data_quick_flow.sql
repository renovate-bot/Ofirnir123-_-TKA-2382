set define '^'
set verify off
prompt ...wwv_flow_data_quick_flow


Rem     NAME
Rem      wwv_flow_data_quick_flow.sql
Rem     Arguments:
Rem      1:  
Rem      2:
Rem      3:  Flow user
Rem     MODIFIED (MM/DD/YYYY)
Rem      cbcho    05/14/2004 - Created
Rem      cbcho    05/21/2004 - Changed create_modules parameter
Rem      cbcho    05/26/2004 - Removed commented p_flow_id
Rem      cbcho    06/04/2004 - Added p_user_mgmt to create_modules
Rem      cbcho    06/07/2004 - Added p_aggregate_function to create_modules
Rem      cbcho    06/09/2004 - Removed p_user_mgmt since user management feature moved to 2.0
Rem      cbcho    06/15/2004 - Added p_create_type in create_modules to create application either from new table or existing table
Rem      cbcho    06/18/2004 - Added p_save_ui_default in create_modules
Rem      cbcho    06/21/2004 - Added p_group_by and p_aggregate_by in create_modules
Rem      cbcho    06/23/2004 - Added logic to create application either read only or read and write mode
Rem      cbcho    07/01/2004 - Added additional parameter to get PK source
Rem      cbcho    08/10/2004 - Added p_load_id to create_modules
Rem      sspadafo 10/19/2005 - Added p_authentication to create_modules (Bug 4673279)
Rem      cbcho    08/31/2007 - Changed create_modules to accept p_string as clob to support copy paste spreadsheet data load > 32KB
Rem      cbcho    12/28/2007 - Added p_report_type to create_modules
Rem      hfarrell 03/29/2010 - Updated create_modules to refer to update authentication scheme name 'Application Express'
Rem      hfarrell 11/07/2014 - In create_modules: added p_theme_style_id (bug #19977361)
Rem      hfarrell 01/07/2015 - In create_modules: added p_navigation_type (bug #20264020)
Rem      cbcho    05/20/2016 - Removed obsolete parameters from create_modules and added p_page_type (feature #2001)
Rem      cbcho    05/25/2016 - Removed p_singular_name, p_plural_name from create_modules as they are no longer asked in the wizard (feature #2001)

create or replace package wwv_flow_data_quick_flow
as
--  Copyright (c) Oracle Corporation 2004. All Rights Reserved.
--
--
--    DESCRIPTION
--      This package creates application on a table from spreadsheet to finished application.
--
--    NOTES
--      
--      
--    SECURITY
--      No grants, must be run as FLOW schema owner.
--
--    NOTES
--
--    INTERNATIONALIZATION
--      unknown
--
--    MULTI-CUSTOMER
--      unknown
--
--    CUSTOMER MAY CUSTOMIZE
--      NO
--
--    RUNTIME DEPLOYMENT: YES
--


g_flow_id   number := null;
g_page_id   number := null; -- report page
g_run_link  varchar2(32767) := null;

procedure create_modules (             
    p_owner                  in varchar2,
    p_table_name             in varchar2,
    p_page_type              in varchar2 default 'REPORT_AND_FORM', -- used only for IG
    p_flow_name              in varchar2 default 'Quick Flow',
    p_collection             in varchar2 default 'EXCEL_IMPORT',
    p_report_type            in varchar2 default 'CLASSIC',
    p_string                 in clob default empty_clob(),
    p_file_name              in varchar2 default null, 
    p_file_charset           in varchar2 default null, 
    p_separator              in varchar2 default '\t',
    p_enclosed_by            in varchar2 default null,
    p_currency               in varchar2 default '$',
    p_numeric_chars          in varchar2 default '.,',
    p_first_row_is_col_name  in boolean default false,
    p_load_id                in number default null,
    p_authentication         in varchar2 default 'Application Express' );

end wwv_flow_data_quick_flow;
/
show error;