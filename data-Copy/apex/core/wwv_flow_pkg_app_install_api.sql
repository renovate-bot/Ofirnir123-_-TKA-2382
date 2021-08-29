set define '^' verify off
prompt ...wwv_flow_pkg_app_install_api
create or replace package wwv_flow_pkg_app_install_api as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2016. All Rights Reserved.
--
--    NAME
--      wwv_flow_pkg_app_install_api.sql
--
--    DESCRIPTION
--      This package is responsible for installing packaged app (database app type only) from the command line.
--
--    MODIFIED   (MM/DD/YYYY)
--    cbcho       03/09/2016 - Created
--    cbcho       08/02/2016 - Added overloaded procedure to accept p_app_name to install, upgrade, deinstall (feature #1937)
--    cbcho       07/24/2018 - Use new view apex_pkg_app_available (bug #26022592)
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------

-- 
-- The function installs packaged application using passed in app_id and returns installed application ID.  The security_group_id must be set b/f the call.
--
-- p_app_id                The packaged application ID.  Get this from apex_pkg_app_available.app_id view.
-- p_authentication_type   The authentication type to use.  If not passed, builder authentication type used.  The value must be apex_authentication.t_authentication_type.
-- p_schema                The schema the application is being installed to.  If not passed, the first schema provisioned used.
--
function install( 
    p_app_id              in number,
    p_authentication_type in wwv_flow_authentication_api.t_authentication_type default null,
    p_schema              in varchar2 default null ) return number;


-- 
-- The function installs packaged application using passed in app_name and returns installed application ID.  The security_group_id must be set b/f the call.
--
-- p_app_name              The case insensitive packaged application name.  Get this from apex_pkg_app_available.app_name view.
-- p_authentication_type   The authentication type to use.  If not passed, builder authentication type used.  The value must be apex_authentication.t_authentication_type.
-- p_schema                The schema the application is being installed to.  If not passed, the first schema provisioned used.
--
function install( 
    p_app_name            in varchar2,
    p_authentication_type in wwv_flow_authentication_api.t_authentication_type default null,
    p_schema              in varchar2 default null ) return number;

-- 
-- The procedure upgrades packaged application using passed in app_id.  The security_group_id must be set b/f the call.
--
-- p_app_id           The packaged application ID.  Get this from apex_pkg_app_available.app_id view.
--
procedure upgrade(
    p_app_id in number );

-- 
-- The procedure upgrades packaged application using passed in app_name.  The security_group_id must be set b/f the call.
--
-- p_app_name         The packaged application name.  Get this from apex_pkg_app_available.app_name view.
--
procedure upgrade(
    p_app_name in varchar2 );

-- 
-- The procedure deinstalls packaged application using passed in app_id.  The security_group_id must be set b/f the call.
--
-- p_app_id           The packaged application ID.  Get this from apex_pkg_app_available.app_id view.
--
procedure deinstall(
    p_app_id in number );

-- 
-- The procedure deinstalls packaged application using passed in app_name.  The security_group_id must be set b/f the call.
--
-- p_app_name         The packaged application name.  Get this from apex_pkg_app_available.app_name view.
--
procedure deinstall(
    p_app_name in varchar2 );
--
--
end  wwv_flow_pkg_app_install_api;
/
show errors