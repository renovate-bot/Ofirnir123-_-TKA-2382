set define off verify off
prompt ...wwv_flow_region
create or replace package wwv_flow_region as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2012-2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_region.sql
--
--    DESCRIPTION
--      This package is responsible for handling regions in the
--      runtime engine.
--
--    MODIFIED   (MM/DD/YYYY)
--      pawolf    04/12/2012 - Created
--      cneumuel  04/08/2014 - Added set_component, clear_component, init, is_ok_to_display, is_read_only (feature #1314)
--      cneumuel  04/28/2014 - In purge_cache: added p_current_session_only (feature #1401)
--      pawolf    12/22/2015 - Added new wrapping apis to support interactive grids
--      pawolf    03/03/2016 - Added add_error and perform_basic_validations (feature #1956)
--      pawolf    03/18/2016 - Added get_column_label
--      cneumuel  02/20/2018 - Moved runtime engine globals from flow.sql to meta.sql (bug #27523529)
--
--------------------------------------------------------------------------------

--==============================================================================
-- make wwv_flow.g_plugs(p_region_idx) the current component. this procedure
-- should be used instead of the more generic wwv_flow.set_component, because
-- it performs additional initialization.
--==============================================================================
procedure set_component (
    p_region in wwv_flow_meta_data.t_plug );

--==============================================================================
-- clean up after region specific code that has been initiated with
-- set_component().
--==============================================================================
procedure clear_component;

--==============================================================================
-- initialize p_region before rendering. this configures references between the
-- region and it's parent and initializes subcomponents of the region (items,
-- buttons, sub-regions) if it can be displayed.
--
-- ARGUMENTS
-- * p_parent_region_idx  index of p_region's parent region in wwv_flow.g_plugs
-- * p_region             the region
--==============================================================================
procedure init (
    p_parent_region_idx in pls_integer,
    p_region            in out nocopy wwv_flow_meta_data.t_plug );

--==============================================================================
-- return whether the region can be displayed
--==============================================================================
function is_ok_to_display (
    p_region in out nocopy wwv_flow_meta_data.t_plug )
    return boolean;

--==============================================================================
-- return whether the region is read-only.
--
-- ARGUMENTS
-- * p_region              the region
-- * p_parent_is_read_only read-only status of the parent region (for
--                         sub-regions) or the page (for top level regions).
--                         if null, the parent's read only status is computed
--                         by looking up the parent region's or page's status.
--==============================================================================
function is_read_only (
    p_region              in out nocopy wwv_flow_meta_data.t_plug,
    p_parent_is_read_only in boolean default null )
    return boolean;

--==============================================================================
-- Returns TRUE if the current region is rendered read only and FALSE if not.
-- If the function is called from a context where no region is currently
-- processed it will return NULL.
--
-- The current region is the one that has been configured by calling
-- set_component().
--==============================================================================
function is_read_only return boolean;

--==============================================================================
-- Purge the region cache of the specified application, page and region.
--
-- Parameters:
--   p_application_id Id of the application where the region caches should be purged.
--   p_page_id        Id of the page where the region caches should be purged.
--                    If no value is specified all regions of the specified application
--                    will be purged.
--   p_region_id      Id of a specific region on a page which should be purged.
--                    If no value is specified all regions of the specified page
--                    will be purged.
--   p_current_session_only If true, only purges cache for the current session.
--==============================================================================
procedure purge_cache (
    p_application_id       in number,
    p_page_id              in number default null,
    p_region_id            in number default null,
    p_current_session_only in boolean default false );

--==============================================================================
-- Function returns the region plug-in type (incl. NATIVE_ or PLUGIN_ prefix).
--==============================================================================
function get_type (
    p_region_id in number )
    return wwv_flow_page_plugs.plug_source_type%type;

--==============================================================================
-- Function returns the number of submitted rows of the specified region.
--==============================================================================
function get_row_count (
    p_region_id in number )
    return pls_integer;

--==============================================================================
-- Function returns the status (C=create, U=update, D=delete or NULL) of the specified
-- region row. 
--==============================================================================
function get_row_status (
    p_region_id in number,
    p_row_num   in pls_integer )
    return varchar2;

--==============================================================================
-- Function returns TRUE if the specified row has been created or modified.
-- Returns FALSE if the submitted values have not changed.
--==============================================================================
function has_row_changed (
    p_region_id in number,
    p_row_num   in pls_integer )
    return boolean;

--==============================================================================
-- Function returns an array, indexed by column alias which contains the
-- column values of the specified region. This array can be used to
-- call set_component_values.
--
-- The "Row Selector" column is returned as "APEX$ROW_SELECTOR" and contains
-- the value X if checked.
-- The "Record Status" column is returned as "APEX$ROW_STATUS".
--==============================================================================
function get_row_values (
    p_region_id in number,
    p_row_num   in pls_integer )
    return wwv_flow_global.vc_map;

--==============================================================================
-- Procedure which updates the region internal session state with the values
-- of the p_value_map. p_value_map is index by column alias.
--==============================================================================
procedure set_row_values (
    p_region_id in number,
    p_value_map in wwv_flow_global.vc_map,
    p_row_num   in pls_integer );

--==============================================================================
-- Performs the basic and predefined validations
--==============================================================================
procedure perform_basic_validations (
    p_region_id in number,
    p_row_num   in pls_integer );

--==============================================================================
-- Adds an error message onto the error stack.
-- Note: This procedure has to be called before APEX has performed the
--       last validation/process, otherwise it will not take the error into account
--       when the inline errors are displayed.
--==============================================================================
procedure add_error (
    p_message          in varchar2,
    p_display_location in varchar2,
    p_region_id        in number,
    p_column_alias     in varchar2,
    p_row_num          in pls_integer,
    p_ignore_ora_error in boolean );

--==============================================================================
-- Function returns the format mask of the tabular form/interactive grid column.
--==============================================================================
function get_column_format_mask (
    p_region_id   in number,
    p_column_name in varchar2 )
    return varchar2;

--==============================================================================
-- Function returns the label/heading of the tabular form/interactive grid column.
--==============================================================================
function get_column_label (
    p_region_id   in number,
    p_column_name in varchar2 )
    return varchar2;

--==============================================================================
-- Resets all global variables.
-- Note: Always call this procedure if the current page/region changes!
--==============================================================================
procedure reset;

--
end wwv_flow_region;
/
show errors

set define '^'
