set define '^' verify off
prompt ...wwv_flow_app_def_v3
create or replace package wwv_flow_app_def_v3  as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_app_def_v3.sql
--
--    DESCRIPTION
--      Provides application default feature and JSON based implementation
--
--    RUNTIME DEPLOYMENT: no required
--
--    MODIFIED  (MM/DD/YYYY)
--     mhichwa   04/13/2017 - Created
--     mhichwa   04/18/2017 - added gen_apply_app_defaults_sql2 clob signiture
--     mhichwa   04/21/2017 - added gen_standard_app_defaults
--     mhichwa   04/21/2017 - added gen_app_defaults_from_coll1
--     mhichwa   04/22/2017 - added collection APIs, added p_table_prefix to sync_app_defaults
--     cbcho     05/02/2017 - exposed get_json_page_component_name
--     cbcho     05/03/2017 - added c_app_def_collection
--     cbcho     05/10/2017 - changed logic to use clob writer
--     cbcho     05/10/2017 - in synch_app_defaults: added p_learn_app_def
--     mhichwa   05/11/2017 - added get_JSON_pagniation_type
--     mhichwa   05/17/2017 - added p_is_required_yn
--     mhichwa   05/17/2017 - added p_orderByColumn
--     mhichwa   05/18/2017 - added p_seed_from_app_id
--     mhichwa   05/24/2017 - added p_schema to sync_app_defaults
--     mhichwa   06/02/2017 - added p_learn_existing_apps to sync_app_defaults
--     mhichwa   06/08/2017 - added columns to add_table_column
--     cbcho     08/07/2017 - In add_table_column: added p_column_type
--     cbcho     02/08/2018 - Removed table prefix
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_app_def_collection  constant varchar2(255) := 'APEX$ATTRIBUTE_DEFAULTS';

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function get_json_page_component_name (
   p_name in varchar2 default null )
   return varchar2;

function app_defaults_get_name return varchar2;

function app_defaults_get_desc return varchar2;

function gen_app_defaults_from_coll return clob;

function app_defaults_get_coll_rows return number;

function gen_sample_app_defaults return clob;

procedure gen_apply_app_defaults_sql (
    p_app_defaults in clob );

function get_JSON_pagniation_type (
    p_pagination_type in varchar2 default 'ROWS_X_TO_Y' )
    return varchar2;

--------------------------------------------------------------------------
-- collection API
--
--

procedure sync_app_defaults (
    p_schema              in varchar2 default null,
    p_learn_app_def       in boolean  default true,
    p_learn_existing_apps in boolean  default true,
    p_base_table_prefix   in varchar2 default null,
    p_seed_from_app_id    in number   default null );

function table_exists (
    p_table in varchar2 )
    return boolean;

procedure add_table (
    p_table                   in varchar2,
    p_labelSingular           in varchar2 default null,
    p_labelPlural             in varchar2 default null,
    p_primaryDisplayColumn    in varchar2 default null,
    p_secondaryDisplayColumn  in varchar2 default null,
    p_primaryKeyColumn        in varchar2 default null,
    p_primaryParentTable      in varchar2 default null,
    p_description             in varchar2 default null );

function table_column_exists (
    p_table  in varchar2,
    p_column in varchar2)
    return boolean;

procedure add_table_column (
    p_table                   in varchar2,
    p_column                  in varchar2,
    p_column_type             in varchar2,
    p_label                   in varchar2 default null,
    p_formControl             in varchar2 default null,
    p_listOfValues            in varchar2 default null,
    p_includeOnForms          in varchar2 default null,
    p_includeOnReports        in varchar2 default null,
    p_formatMask              in varchar2 default null,
    p_staticDefault           in varchar2 default null,
    p_help                    in varchar2 default null,
    p_comments                in varchar2 default null,
    p_is_required_yn          in varchar2 default 'N',
    p_lov_display_null        in varchar2 default null,
    p_lov_display_extra       in varchar2 default null,
    p_lov_null_value          in varchar2 default null
    );

procedure add_dynamic_lov (
   p_name           in varchar2,
   p_query          in varchar2 );

procedure add_structured_lov (
   p_name            in varchar2,
   p_table           in varchar2,
   p_displayColumn   in varchar2,
   p_keyColumn       in varchar2,
   p_orderByColumn   in varchar2 );

end wwv_flow_app_def_v3;
/
show errors

