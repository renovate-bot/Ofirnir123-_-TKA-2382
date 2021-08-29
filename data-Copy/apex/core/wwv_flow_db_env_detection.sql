set define '^' verify off
prompt ...wwv_flow_db_env_detection.sql
create or replace package wwv_flow_db_env_detection is
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_db_env_detection.sql
--
--    DESCRIPTION
--      This script is to detect database the detailed database version and
--      selected database features (SQL/JSON) and make that information
--      available as constants in the wwv_flow_db_version package for
--      conditional compilation.
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    09/07/2017 - Created
-- 
--------------------------------------------------------------------------------

--==============================================================================
-- dynamically creates the WWV_FLOW_DB_VERSION package containing the following
-- constants:
--
--     c_full_version    constant varchar2(4000) := sys.dbms_registry.release_version;
--     c_ver_le_11_2_0_1 constant boolean        := c_full_version < '11.2.0.2.';
--     c_ver_le_11_2_0_2 constant boolean        := c_full_version < '11.2.0.3.';
--     c_ver_le_12_1_0_1 constant boolean        := c_full_version < '12.1.0.2.';
--
--     c_has_sql_json    constant boolean        := {JSON_TABLE SQL function is avaiable};
--     c_has_locator     constant boolean        := {MDSYS.SDO_GEOMETRY type is available};  
--==============================================================================
procedure generate_wwv_flow_db_version;

end wwv_flow_db_env_detection;
/
show err

set define '^'

