set define '^' verify off
prompt ...wwv_flow_exec_web_src_adfbc.sql
create or replace package wwv_flow_exec_web_src_adfbc as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_web_src_adfbc.sql
--
--    DESCRIPTION
--      Web source implementation for ORDS REST Services
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    01/08/2018 Created
--    cczarski    01/09/2018 moved discover_data_profile to new wwv_flow_web_src_adfbc_dev package
--
--------------------------------------------------------------------------------

--======================================================================================================================
-- returns the capabilities of this ADF BC REST Service
-- 
-- RETURNS
--     wwv_flow_exec_web_src record structure containing web source capabilities
--======================================================================================================================
function get_capabilities( p_web_src_module_id in number ) return wwv_flow_exec_api.t_source_capabilities;

--======================================================================================================================
-- Invokes a GET COLLECTION REST request on an ORDS REST service. This procedure executes the HTTP request and 
-- retrieves the response data as a CLOB. p_context.web_source_result is populated with response data.
-- 
-- PARAMETERS
--     p_context              IN     context object with execution details
--     p_web_source_operation IN     web source operation details (to look up the data profile) 
--======================================================================================================================
procedure invoke_query(
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_first_row            in            pls_integer default null,
    p_max_rows             in            pls_integer default null,
    p_web_source_operation in            wwv_flow_exec_web_src.t_web_source_operation,
    p_first_page           in            boolean default true,
    p_response_clob        in out nocopy clob );

procedure invoke_query(
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_web_source_operation in            wwv_flow_exec_web_src.t_web_source_operation,
    p_result_array         in out nocopy wwv_flow_t_clob );

end wwv_flow_exec_web_src_adfbc;
/
show err

set define '^'
