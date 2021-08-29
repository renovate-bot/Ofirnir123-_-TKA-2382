set define '^' verify off
prompt ...wwv_flow_tree_region
create or replace package wwv_flow_tree_region as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2010-2015. All Rights Reserved.
--
--    NAME
--      wwv_flow_tree_region.sql
--
--    DESCRIPTION
--      This package specification is responsible for the generation of tree regions
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
--    MODIFIED (MM/DD/YYYY)
--    hfarrell  01/11/2010 - Created
--    hfarrell  02/26/2010 - Updated fetch_jstree_attr and save_jstree_attr to correspond with changes to underlying jstree API and table
--    hfarrell  04/21/2010 - Added function is_valid_start_query to validating starting tree query: bug 9531389
--    hfarrell  05/10/2010 - Updated fetch_jstree_attr and save_jstree_attr to include p_selected_node for Selected Node attribute
--    hfarrell  08/23/2013 - In init: added p_region_static_id (feature #1201)
--    cneumuel  01/10/2014 - Changed to tree to native plugin, removed obsolete APIs (feature #1312).
--    hfarrell  01/21/2014 - Reinstated function is_valid_start_query - used by tree creation wizard (bug #18109167)
--    jsnyders  07/22/2014 - Add support for selected node in internal show_tree
--    jsnyders  02/11/2015 - Add support for accessible tree label (bug 20206934)
--    pawolf    06/22/2017 - Changed region based tree to use new wwv_flow_exec apis
--    cczarski  07/13/2017 - moved is_valid_start_query to wwv_flow_f4000_util in order to remove cross-dependencies
--
--------------------------------------------------------------------------------

--==============================================================================
-- Procedure which generates the necessary HTML code for the tree. This is
-- the API used when the tree is used in a region.
--==============================================================================
function render (
    p_plugin              in wwv_flow_plugin_api.t_plugin,
    p_region              in wwv_flow_plugin_api.t_region,
    p_is_printer_friendly in boolean )
    return wwv_flow_plugin_api.t_region_render_result;

--==============================================================================
-- initialize and show tree, independent of tree plugin. this is used by the
-- navigation tree of websheets.
--==============================================================================
procedure show_tree (
    p_tree              in wwv_flow_plugin_util.t_column_value_list,
    p_tree_id           in varchar2,
    p_tree_template     in varchar2,
    p_tree_has_focus    in varchar2,
    p_tree_action       in varchar2,
    p_hints             in varchar2,
    p_hints_text        in varchar2,
    p_selected_node_id  in varchar2 default null,
    p_label             in varchar2 default null);

end wwv_flow_tree_region;
/
show errors
