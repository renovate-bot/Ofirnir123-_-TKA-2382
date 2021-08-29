set define '^' verify off
prompt ...wwv_flow_acl_api
create or replace package wwv_flow_acl_api as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_acl_api.sql
--
--    DESCRIPTION
--      API to application access control shared component
--
--     SECURITY
--       Publicly executable.
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--      mhichwa   01/29/2018 - Created (feature #2268)
--      cbcho     01/31/2018 - Changed wwv_flow_global.vc_arr2 to wwv_flow_t_varchar2
--      pawolf    02/05/2018 - Changed API
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------

procedure add_user_role (
	-- assigns a role to a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_id        in number );

procedure add_user_role (
	-- assigns a role to a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_static_id in varchar2 );

procedure remove_user_role (
	-- removes an assigned role from a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_id        in number );

procedure remove_user_role (
	-- removes an assigned role from a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_static_id in varchar2 );

procedure add_user_roles (
	-- assigns an array of roles to a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_ids       in wwv_flow_t_number );

procedure add_user_roles (
	-- assigns an array of roles to a user
    p_application_id  in number   default wwv_flow_security.g_flow_id,
    p_user_name       in varchar2,
    p_role_static_ids in wwv_flow_t_varchar2 );

procedure replace_user_roles (
	-- replaces any existing assigned roles to new array of roles
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2,
    p_role_ids       in wwv_flow_t_number );

procedure replace_user_roles (
	-- replaces any existing assigned roles to new array of roles
    p_application_id  in number   default wwv_flow_security.g_flow_id,
    p_user_name       in varchar2,
    p_role_static_ids in wwv_flow_t_varchar2 );

procedure remove_all_user_roles (
	-- removes all assigned roles from a user
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2 );

function has_user_role (
    -- returns TRUE if the user is assigned to the specified role
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2 default wwv_flow.g_user,
    p_role_static_id in varchar2 )
    return boolean;

function has_user_any_roles (
    -- returns TRUE if the user is assigned to any application role
    -- this can be used to check if a user is allowed to access an application
    p_application_id in number   default wwv_flow_security.g_flow_id,
    p_user_name      in varchar2 default wwv_flow.g_user )
    return boolean;

end wwv_flow_acl_api;
/
show errors;
