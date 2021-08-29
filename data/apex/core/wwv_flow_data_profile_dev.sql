set define '^' verify off
prompt ...wwv_flow_data_profile_dev.sql
create or replace package wwv_flow_data_profile_dev as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_data_profile_dev
--
--    DESCRIPTION
--      Data Profile processing logic specific to the APEX builder
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    05/30/2017 - Created
--    cczarski    09/04/2017 - Added check_sql_expression
--    cczarski    09/08/2017 - Added copy_data_profile
--------------------------------------------------------------------------------

--==============================================================================
-- Copy a remote server, between applications p_from_application_id to p_to_application_id.
--
-- p_subscribe:
--     if true then the new remote server gets a subscription to the old one.
-- p_if_existing_raise_dupval:
--     if true and a remote_server with the same name already exists in
--     p_to_flow_id then DUP_VAL_ON_INDEX gets thrown.
--==============================================================================
function copy_data_profile (
    p_from_application_id      in number,
    p_name                     in varchar2,
    p_to_application_id        in number,
    p_to_name                  in varchar2 default null,
    p_subscribe                in boolean default false,
    p_if_existing_raise_dupval in boolean default false )
    return number;

--==============================================================================
-- Samples a JSON response and generates a data profile as wwv_flow_data_profile.t_data_profile
-- record structure. When P_AUTO_DETECT is set to false, ROW_SELECTOR and SINGLE_ROW attributes
-- the the P_DATA_PROFILE record structure should be set. When P_AUTO_DETECT is true, the procedure
-- will auto-detect them from the JSON data.
--
-- PARAMETERS
--     p_web_service_response IN        CLOB with the JSON service response to sample
--     p_data_profile         IN OUT    data profile record structure to populate
--     p_auto_detect          IN        whether to auto-detect the row selector (true) or not (false)
--==============================================================================
procedure sample_data_profile_json(
    p_web_service_response in out nocopy clob,
    p_data_profile         in out nocopy wwv_flow_data_profile.t_data_profile,
    p_auto_detect          in            boolean default false );

--==============================================================================
-- Samples an XML response and generates a data profile as wwv_flow_data_profile.t_data_profile
-- record structure. When P_AUTO_DETECT is set to false, ROW_SELECTOR and SINGLE_ROW attributes
-- the the P_DATA_PROFILE record structure should be set. When P_AUTO_DETECT is true, the procedure
-- will auto-detect them from the XML data.
--
-- PARAMETERS
--     p_web_service_response IN        CLOB with the JSON service response to sample
--     p_data_profile         IN OUT    data profile record structure to populate
--     p_auto_detect          IN        whether to auto-detect the row selector (true) or not (false)
--==============================================================================
procedure sample_data_profile_xml(
    p_web_service_response in out nocopy clob,
    p_data_profile         in out nocopy wwv_flow_data_profile.t_data_profile,
    p_auto_detect          in            boolean default false );

--==============================================================================
-- Resequences the columns of a data profile.
--
-- PARAMETERS
--     p_data_profile_id IN   ID of the data profile to resequence the columns
--     p_interval        IN   New sequence interval     
--==============================================================================
procedure resequence_columns(
    p_data_profile_id in number,
    p_interval        in number default 10 );

--==============================================================================
-- Checks whether a SQL expression is valid within the data profile
--
-- PARAMETERS
--     p_data_profile_id IN   ID of the data profile to resequence the columns
--     p_sql_expression  IN   SQL Expression to check
--==============================================================================

function check_sql_expression( 
    p_data_profile_id in number,
    p_sql_expression  in varchar2 ) return varchar2;

--==============================================================================
-- Returns the resulting data type for a SQL expression
--
-- PARAMETERS
--     p_data_profile_id IN   ID of the data profile to resequence the columns
--     p_sql_expression  IN   SQL Expression to check
--==============================================================================
function get_sql_expr_datatype( 
    p_data_profile_id in number,
    p_sql_expression  in varchar2 ) return varchar2;

end wwv_flow_data_profile_dev;
/
sho err

set define '^'
