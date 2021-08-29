set define '^' verify off
prompt ...wwv_flow_exec_web_src_http.sql
create or replace package wwv_flow_exec_web_src_http as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_exec_web_src_http.sql
--
--    DESCRIPTION
--      Web source implementation for simple HTTP data feeds
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    03/14/2017 - Created
--    cczarski    09/04/2017 - code improvements
--    cczarski    09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec
--    cczarski    10/04/2017 - Changed invoke_query to invoke (being used for all kinds of executions)
--
--------------------------------------------------------------------------------

--======================================================================================================================
-- returns the capabilities of this ORDS REST Services
-- 
-- RETURNS
--     wwv_flow_exec_web_src record structure containing web source capabilities
--======================================================================================================================
function get_capabilities return wwv_flow_exec_api.t_source_capabilities;

--======================================================================================================================
-- Invokes a GET COLLECTION REST request on an ORDS REST service. This procedure executes the HTTP request and 
-- retrieves the response data as a CLOB. p_context.web_source_result is populated with response data.
-- 
-- PARAMETERS
--     p_context              IN     context object with execution details
--     p_web_source_operation IN     web source operation details (to look up the data profile) 
--
-- RETURNS
--     p_response_clob        web service response
--======================================================================================================================
procedure invoke(
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_web_source_operation in            wwv_flow_exec_web_src.t_web_source_operation,
    p_response_clob        in out nocopy clob );

end wwv_flow_exec_web_src_http;
/
show err

set define '^'
