set define '^' verify off
prompt ...wwv_flow_exec_remote.sql
create or replace package wwv_flow_exec_remote is
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_remote_exec.sql
--
--    DESCRIPTION
--      SQL Data Access for remote ORDS instances (feature #2109).
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    03/14/2017 - Created
--    hfarrell    04/07/2017 - Changed set define off setting to resolve build issue
--    pawolf      07/26/2017 - Added optimizer_hint (feature #1107)
--    cczarski    03/14/2017 - Added p_test_for_rowid argument to "describe" functions
--    cczarski    09/12/2017 - Added constants for conditional compilation
--    cczarski    09/28/2017 - Moved wwv_flow_exec_api.t_context to wwv_flow_exec
--    cczarski    10/06/2017 - moved test_remote_sql_server to wwv_flow_exec_remote and added p_update_timezone
--    cczarski    10/09/2017 - Added test_authentication function to check whether credentials are valid
--    cczarski    11/10/2017 - Change wwv_flow_exec_api to AUTHID CURRENT_USER; so this internal API will be DEFINER
--    cczarski    11/15/2017 - change wwv_flow_remote_servers to store remote servers at workspace level (feature #2109, #2092)
--    cczarski    12/18/2017 - Added caching for Remote SQL
--    cczarski    12/20/2017 - Added find_remote_server_id by static ID
--    cczarski    02/05/2018 - code changes in order to allow wrapped SQL queries growing larger than 32K
--    cczarski    03/13/2018 - add p_columns parameter to open_query_context ( bug #27682518)
--
--------------------------------------------------------------------------------
--==============================================================================
-- Constants
--==============================================================================

--======================================================================================================================
-- finds the remote server ID by name
--
-- PARAMETERS
--     p_server_name             IN remote server name
--======================================================================================================================
function find_remote_server_id(
    p_server_name in varchar2 ) return wwv_remote_servers.name%type;

--======================================================================================================================
-- finds the remote server ID by static ID
--
-- PARAMETERS
--     p_server_static_id        IN remote server static ID
--======================================================================================================================
function find_remote_server_id(
    p_server_static_id in varchar2 ) return wwv_remote_servers.static_id%type;

--==============================================================================
-- Performs the "open_query_context" operation for execution on a remote server.
--
-- For a DML context, the procedure does nothing; a query context will be
-- executed so that the component can continue with fetching rows.
--
-- p_context: context object with execution details
--==============================================================================
procedure open_query_context ( 
    p_context              in out nocopy wwv_flow_exec.t_context,
    p_columns              in            wwv_flow_exec_api.t_columns default wwv_flow_exec_api.c_empty_columns,
    p_cache                in            varchar2                    default null,
    p_cache_invalidation   in            varchar2                    default null,
    p_cache_component_id   in            number                      default null,
    p_cache_component_type in            number                      default null); 

--==============================================================================
-- Performs a describe operation for the query on the remote server and 
-- populates the context object with result set metadata
--
-- p_context: context object with execution details
--==============================================================================
procedure describe_statement (
    p_context        in out nocopy wwv_flow_exec.t_context,
    p_test_for_rowid in            boolean default false );

--==============================================================================
-- Performs a describe operation for the query on the remote server and 
-- populates the context object with result set metadata
--
-- p_sql_query: SQL    Query to describe
-- p_remote_server_id: Remote Server ID to execute the describe on
-- p_columns:          Array of columns
--==============================================================================
function describe_query (
    p_remote_server_id in number,
    p_sql_query        in varchar2,
    p_test_for_rowid   in boolean  default false,
    p_optimizer_hint   in varchar2 default null )
    return wwv_flow_exec_api.t_columns;

function describe_query (
    p_remote_server_id in number,
    p_sql_query        in wwv_flow_global.vc_arr2,
    p_test_for_rowid   in boolean  default false,
    p_optimizer_hint   in varchar2 default null )
    return wwv_flow_exec_api.t_columns;

--==============================================================================
-- Executes the query on the remote server. This function must only be called
-- if a query is to be executed another time (e.g. with different bind variables).
--
-- p_context: context object with execution details
--==============================================================================
procedure execute_query (
    p_context in out nocopy wwv_flow_exec.t_context,
    p_columns in            wwv_flow_exec_api.t_columns default wwv_flow_exec_api.c_empty_columns );

--==============================================================================
-- Executes the PL/SQL operation on the remote server. 
--
-- p_context: context object with execution details
--==============================================================================
procedure execute_plsql (
    p_context in out nocopy wwv_flow_exec.t_context );

--==============================================================================
-- Fetches the next page for a query context.
--
-- p_context: context object with execution details
--==============================================================================
function next_page (
    p_context in out nocopy wwv_flow_exec.t_context )
    return boolean; 

--==============================================================================
-- Tests whether credentials for this remote server are correct
--
-- p_remote_server_id: Remote Server ID to execute the describe on
--==============================================================================
function test_authentication(
    p_remote_server_id in number ) return boolean; 

--==============================================================================
-- Executes a PL/SQL expression and returns a VARCHAR2 result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns string.
--==============================================================================
function get_plsql_expr_result_varchar2(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return varchar2;

--==============================================================================
-- Executes a PL/SQL expression and returns a NUMBER result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns string.
--==============================================================================
function get_plsql_expr_result_number(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return number;

--==============================================================================
-- Executes a PL/SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns boolean.
--==============================================================================
function get_plsql_expr_result_boolean(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return boolean;

--==============================================================================
-- Executes a PL/SQL function code block and returns a VARCHAR2 result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns string.
--                   For example:
--                   declare
--                       l_test varchar2(10);
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================

function get_plsql_func_result_varchar2(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return varchar2;

--==============================================================================
-- Executes a PL/SQL function code block and returns a CLOB result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns string.
--                   For example:
--                   declare
--                       l_test varchar2(10);
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================

function get_plsql_func_result_clob(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return clob;

--==============================================================================
-- Executes a PL/SQL function code block and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns boolean.
--                   For example:
--                   declare
--                       l_test boolean;
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================
function get_plsql_func_result_boolean(
    p_plsql_expression in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return boolean;

--==============================================================================
-- Executes a SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_expression: SQL expression which will be wrapped by
--                   select count(*) from dual where <p_sql_expression>.
--                   a row count of 0 returns FALSE otherwise TRUE.
--==============================================================================
function get_sql_expr_result_boolean(
    p_sql_expression   in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return boolean;

--==============================================================================
-- Executes a SQL statement and returns TRUE if rows exist and FALSE if no row
-- is returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement which will be wrapped by
--                  select count(*) from dual where exists (<p_sql_statement>).
--==============================================================================
function do_rows_exist(
    p_sql_statement    in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return boolean;

--==============================================================================
-- Executes a SQL statement which contains one VARCHAR2 column and returns the
-- value of the first row. If the SQL statement doesn't return any rows or the
-- SQL statement itself is NULL then NULL will be returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement with one VARCHAR2 column.
--==============================================================================
function get_first_row_result_varchar2 (
    p_sql_statement    in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return varchar2; 

--==============================================================================
-- Executes a SQL statement which contains one NUMBER column and returns the
-- value of the first row. If the SQL statement doesn't return any rows or the
-- SQL statement itself is NULL then NULL will be returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement with one NUMBER column.
--==============================================================================
function get_first_row_result_number (
    p_sql_statement    in varchar2,
    p_remote_server_id in number,
    p_binds            in wwv_flow_exec_api.t_parameters  default wwv_flow_exec_api.c_empty_parameters 
) return varchar2;

--==============================================================================
-- Checks PL/SQL code in the remote database
--
-- PARAMETERS
--    p_plsql_code        PL/SQL code to verify
--    p_remote_server_id  The ID of the remote server
--
-- RETURNS
--    the error message in case of an error, NULL on success
--==============================================================================
function check_plsql(
    p_plsql_code       in varchar2,
    p_remote_server_id in number ) return varchar2;

--==============================================================================
-- Tests a ORDS Remote SQL server. 
--
-- PARAMETERS:
--    * p_remote_sql_server_id  The ID of the remote server
--    * p_update_timezone       Update the time zone information based on the server response
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

end wwv_flow_exec_remote;
/
show err
set define '^'
