set define '^' verify off
prompt ...wwv_flow_app_setting_api
create or replace package wwv_flow_app_setting_api as
------------------------------------------------------------------------------------------------------------------------
--
--   Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
-- 
--     NAME
--       wwv_flow_app_setting_api.sql
--
--     DESCRIPTION
--      Public API for managing application settings.
-- 
--     MODIFIED (MM/DD/YYYY)
--      mhichwa  12/21/2017 - Created (feature #2257)
--      cbcho    01/31/2018 - Renamed the package
--
------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------

procedure set_value (
    p_name         in varchar2,
    p_value        in varchar2 default null);

function get_value (
    p_name         in varchar2)
    return varchar2;

end wwv_flow_app_setting_api;
/
show errors;
