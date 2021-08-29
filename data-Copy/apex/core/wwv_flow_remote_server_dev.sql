set define '^'
set verify off
prompt ...wwv_flow_remote_server_dev
create or replace package wwv_flow_remote_server_dev
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_remote_server_dev.sql
--
--    DESCRIPTION
--      This package is resonsible for handling remote_servers in the APEX Builder.
--
--    MODIFIED   (MM/DD/YYYY)
--    pawolf      03/09/2017 - Created
--    cczarski    04/06/2017 - Added test_remote_sql_server to check availability of an ORDS Remote SQL instance
--    cczarski    10/06/2017 - moved test_remote_sql_server to wwv_flow_exec_remote and added p_update_timezone
--    cczarski    11/15/2017 - move remote servers to the workspace level
--
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
function copy_remote_server (
    p_name                     in varchar2 ) return number;

--==============================================================================
-- Tests a ORDS Remote SQL server. 
--
-- PARAMETERS:
--    * p_remote_sql_server_id  The ID of the remote server
-- 
-- RETURNS
--    * p_sql_response:         The remote SQL server response of the test query
--    * p_http_status:          HTTP Status Code (e.g. 401 for Unauthorized)
--    * p_sqlcode:              Remote SQL ORA Error code, if applicable
--    * p_is_remote_sql:        "1" when the server is a Remote SQL server 0 otherwise
--==============================================================================
procedure test_remote_sql_server(
    p_remote_sql_server_id in  number,
    p_update_timezone      in  boolean default true,
    p_sql_response         out varchar2,
    p_http_status          out number,
    p_sqlcode              out number,
    p_is_remote_sql        out number );

--==============================================================================
-- Table function to return Query Describe results for LOV usage within Builder
--==============================================================================

function get_available_objects(
    p_remote_server_id in number,
    p_object_type      in varchar2,
    p_owner            in varchar2 default null,
    p_max_rows         in number   default 500 ) return wwv_flow_t_varchar2;


end wwv_flow_remote_server_dev;
/
show errors
