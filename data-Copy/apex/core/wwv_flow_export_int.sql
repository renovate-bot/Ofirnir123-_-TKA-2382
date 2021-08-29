set define '^' verify off
prompt ...wwv_flow_export_int.sql
create or replace package wwv_flow_export_int as
--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
-- NAME
--   wwv_flow_export_int.sql
--
-- DESCRIPTION
--   Implementation of wwv_flow_export_api
--
-- RUNTIME DEPLOYMENT: YES
-- PUBLIC:             NO
--
-- MODIFIED   (MM/DD/YYYY)
--   cneumuel  09/29/2017 - Created (feature #2224)
--   cneumuel  02/06/2018 - In get_application: added p_with_acl_assignments
--
--------------------------------------------------------------------------------

type t_app_info is record (
    app_type          varchar2(2), -- WS or DB
    id                number,
    security_group_id number,
    owner             wwv_flows.owner%type );

--==============================================================================
function get_app_info (
    p_application_id in number,
    p_calling_user   in varchar2 )
    return t_app_info;

--==============================================================================
procedure set_workspace (
    p_security_group_id in number,
    p_calling_user      in varchar2 );

--##############################################################################
--#
--# LEGACY INTERFACE ( FROM WWV_FLOW_UTILITIES )
--#
--##############################################################################

--==============================================================================
procedure init_gen_api_clob;

--==============================================================================
function get_gen_api_clob return clob;

--##############################################################################
--#
--# WWV_FLOW_EXPORT_API IMPLEMENTATION
--#
--##############################################################################

--==============================================================================
function get_application (
    p_app_info                in t_app_info,
    p_split                   in boolean,
    p_with_date               in boolean,
    p_with_ir_public_reports  in boolean,
    p_with_ir_private_reports in boolean,
    p_with_ir_notifications   in boolean,
    p_with_translations       in boolean,
    p_with_pkg_app_mapping    in boolean,
    p_with_original_ids       in boolean,
    p_with_no_subscriptions   in boolean,
    p_with_comments           in boolean,
    p_with_supporting_objects in varchar2,
    p_with_acl_assignments    in boolean )
    return wwv_flow_t_export_files;

--==============================================================================
function get_workspace_files (
    p_workspace_id in number,
    p_with_date    in boolean )
    return wwv_flow_t_export_files;

--==============================================================================
function get_feedback (
    p_workspace_id      in number,
    p_with_date         in boolean,
    p_since             in date,
    p_deployment_system in varchar2 )
    return wwv_flow_t_export_files;

--==============================================================================
function get_workspace (
    p_workspace_id          in number,
    p_with_date             in boolean,
    p_with_team_development in boolean,
    p_with_misc             in boolean )
    return wwv_flow_t_export_files;

end wwv_flow_export_int;
/
show err

