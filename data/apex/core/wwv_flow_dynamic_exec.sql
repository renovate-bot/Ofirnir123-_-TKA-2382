set define '^' verify off
prompt ...wwv_flow_dynamic_exec
create or replace package wwv_flow_dynamic_exec authid current_user as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_dynamic_exec.sql
--
--    DESCRIPTION
--      This package is responsible for handling processes.
--
--    RUNTIME DEPLOYMENT: YES
--    PUBLIC:             NO
--
--    MODIFIED   (MM/DD/YYYY)
--      pawolf    05/03/2011 - Created
--      pawolf    05/05/2011 - Added grant execute to sys
--      pawolf    05/05/2011 - Removed grant execute to sys
--      pawolf    05/06/2011 - Added/modified description of some procedures/functions
--      pawolf    05/20/2011 - Added bind variable support for get_plsql_* functions
--      pawolf    01/10/2012 - Added new parameters to do_rows_exists, get_first_row_result_varchar2 and get_first_row_result_number (bug# 13576517)
--      vuvarov   07/19/2012 - Added execute() and fetch_rows() (feature #978)
--      vuvarov   08/15/2012 - Added reset_nls_environment() (feature #978)
--      cbcho     02/27/2013 - Added get_dependency_objects (bug #16397724)
--      cneumuel  07/11/2013 - Added execute_ddl
--                           - Added p_is_user_schema to parse_sql_statement, get_first_row_result_%
--      pawolf    06/13/2015 - In parse_sql_statement, get_plsql_func_result_varchar2: added p_do_substitutions (bug #21247877)
--      cneumuel  12/03/2015 - Added t_varchar2_table (bug #22173641)
--      pawolf    01/22/2016 - In parsed_sql_statement: added parameter p_is_dml_statement
--      cneumuel  07/15/2016 - Overloaded parse_sql_statement with out variable for t_bind_variables
--      cneumuel  09/08/2016 - Moved wwv_dbms_sql APIs except essentials (parse, kill) to wwv_flow_dynamic_exec
--      pawolf    11/24/2016 - In execute_plsql_code: added p_commit_session_state
--      hfarrell  01/05/2017 - Changed APEX_050100 reference to APEX_050200
--      pawolf    03/22/2017 - Added get_ora_06550 (moved from wwv_flow_f4000_util.plb)
--      pawolf    10/10/2017 - Added overloaded check_plsql, in execugte_plsql_code: added p_is_user_schema
--      cczarski  02/05/2018 - code changes in order to allow wrapped SQL queries growing larger than 32K
--      pawolf    02/08/2018 - Added resolve_synonym
--      cczarski  02/08/2018 - fix #OWNER# substitution sometimes not done: Move into trim_sql_array procedure
--      cczarski  02/22/2018 - expose trim_sql_array
--      cczarski  03/16/2018 - support writing auto_bind_items automatically written to session state (IR backwards compatibility, bug #27704626)
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================
type t_bind_variable is record (
    name          varchar2(255),
    original_name varchar2(255) );

type t_bind_variables is table of t_bind_variable index by pls_integer;

type t_bind_value is record (
    name  varchar2(255),
    value varchar2(32767) );

type t_bind_values is table of t_bind_value index by pls_integer;

subtype vc_arr2                      is sys.wwv_dbms_sql_APEX_180200.vc_arr2;

type t_dependent_object is record (
    owner              sys.user_dependencies.referenced_owner%type,
    object_type        sys.user_dependencies.referenced_type%type,
    object_name        sys.user_dependencies.referenced_name%type );

type t_dependent_object_list is table of t_dependent_object index by binary_integer;

--==============================================================================
-- t_varchar2_table should be used for dbms_sql array operations instead of
-- the dbms_sql base types, because dbms_sql.varchar2_table does not support 32k
-- columns on 12c. they introduced new overloaded procedures with a different
-- type for 32k support.
--==============================================================================
$if sys.dbms_db_version.version < 12 $then
subtype t_varchar2_table is sys.dbms_sql.varchar2_table;
$else
subtype t_varchar2_table is sys.dbms_sql.varchar2a;
$end

--==============================================================================
-- Global constants
--==============================================================================
c_empty_names       vc_arr2;
c_empty_values      vc_arr2;

--==============================================================================
-- Global variables
--==============================================================================

--==============================================================================
-- Returns the 'real' owner and table name of a database object/synonym.
--==============================================================================
procedure resolve_synonym (
    p_owner           in out varchar2,
    p_name            in out varchar2,
    p_parse_as_schema in     varchar2 default wwv_flow_security.g_parse_as_schema );

--==============================================================================
-- The procedure parses the SQL or PL/SQL statement to get all used
-- bind variables. It supports regular bind variables :item where 'item'
-- is made of ascii characters A-Z, 0-9 or _, $ and #. It also supports
-- bind variables in quotes :"item" where 'item' can be any unicode character
-- except of linefeed or a colon. Because PL/SQL doesn't support such quoted
-- bind variables yet, the quoted bind variables are replaced by
-- :p$_quoted_bind_x where 'x' is a sequence.
--
-- p_names_to_ignore is a list of bind variables which should not be returned
-- in the p_bind_variables array. That can for example be used if the original
-- SQL statement is rewritten to contain additional binds like p$_max_rows,
-- p$_first_row or p$_search_string. Because p_bind_variables is most of the
-- time used to read or write items from session state, it's not desireable that
-- above bind variables are contained in p_bind_variables.
--
-- After execution of the procedure, p_statement contains the modified statement
-- which can then be used to call wwv_dbms_sql.parse_as_user.
--
-- Note: This procedure should almost never be called, just use the functions
--       below which will take care of all the binding, ...
--==============================================================================
procedure prepare_statement (
    p_statement       in out nocopy varchar2,
    p_bind_variables  in out nocopy t_bind_variables,
    p_names_to_ignore in            vc_arr2 default c_empty_names );

procedure prepare_array_statement (
    p_statement         in out nocopy wwv_flow_global.vc_arr2,
    p_bind_variables    in out nocopy t_bind_variables,
    p_names_to_ignore   in            vc_arr2                  default c_empty_names );


--==============================================================================
-- This function gets a SQL statement ready for execution
-- Function is overloaded; p_owner may be provided in order overwrite the
-- defined parsing schema of the current application.

-- This is the equivalent to wwv_flow.trim_sql, but for a SQL statement 
-- in a WWV_FLOW_GLOBAL.VC_ARR2 array
--==============================================================================
procedure trim_sql_array (
    p_sql_statement     in out nocopy wwv_flow_global.vc_arr2,
    p_ends_in_semicolon in            boolean default false,
    p_do_substitutions  in            boolean default true,
    p_owner             in            varchar2 );

--==============================================================================
-- Parses a SQL or DML statement with the passed in cursor.
--
-- The procedure automatically performs the necessary binding of bind variables.
--
-- p_cursor:        Cursor which has been opened with sys.dbms_sql.open_cursor
-- p_sql_statement: SQL statement.
--==============================================================================
procedure parse_sql_statement (
    p_cursor                    in integer,
    p_sql_statement             in varchar2,
    p_auto_bind_items           in boolean                  default true,
    p_names                     in vc_arr2                  default c_empty_names,
    p_values                    in vc_arr2                  default c_empty_values,
    p_parse_as_schema           in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema            in boolean                  default null,
    p_do_substitutions          in boolean                  default true,
    p_is_dml_statement          in boolean                  default false,
    p_write_items_session_state in boolean                  default false );
procedure parse_sql_statement (
    p_cursor                    in integer,
    p_sql_statement             in varchar2,
    p_bind_variables            in out nocopy t_bind_variables,
    p_auto_bind_items           in boolean                  default true,
    p_names                     in vc_arr2                  default c_empty_names,
    p_values                    in vc_arr2                  default c_empty_values,
    p_parse_as_schema           in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema            in boolean                  default null,
    p_do_substitutions          in boolean                  default true,
    p_is_dml_statement          in boolean                  default false,
    p_write_items_session_state in boolean                  default false );

--==============================================================================
-- Parses a SQL or DML statement with the passed in cursor.
--
-- The procedure automatically performs the necessary binding of bind variables.
--
-- p_cursor:        Cursor which has been opened with sys.dbms_sql.open_cursor
-- p_sql_statement: SQL statement as WWV_FLOW_GLOBAL.VC_ARR2. If the SQL statement
--                  (concatenation of all array elements) is larger than 32k,
--                  it will be passed to WWV_DBMS_SQL as SYS.DBMS_SQL.VARCHAR2A, 
--                  otherwise as VARCHAR2.
--==============================================================================
procedure parse_sql_statement (
    p_cursor                    in integer,
    p_sql_statement             in out nocopy wwv_flow_global.vc_arr2,
    p_auto_bind_items           in boolean                  default true,
    p_names                     in vc_arr2                  default c_empty_names,
    p_values                    in vc_arr2                  default c_empty_values,
    p_parse_as_schema           in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema            in boolean                  default null,
    p_do_substitutions          in boolean                  default true,
    p_is_dml_statement          in boolean                  default false,
    p_write_items_session_state in boolean                  default false );

procedure parse_sql_statement (
    p_cursor                    in integer,
    p_sql_statement             in out nocopy wwv_flow_global.vc_arr2,
    p_bind_variables            in out nocopy t_bind_variables,
    p_auto_bind_items           in boolean                  default true,
    p_names                     in vc_arr2                  default c_empty_names,
    p_values                    in vc_arr2                  default c_empty_values,
    p_parse_as_schema           in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema            in boolean                  default null,
    p_do_substitutions          in boolean                  default true,
    p_is_dml_statement          in boolean                  default false,
    p_write_items_session_state in boolean                  default false );

--==============================================================================
-- Clears out cached NLS values used by execute() and fetch_rows() from
-- package state. The values will be populated next time they are accessed.
--==============================================================================
procedure reset_nls_environment;

--==============================================================================
-- A wrapper for sys.dbms_sql.execute() that sets NLS session environment
-- (e.g. NLS_SORT) for the duration of the call. NLS environment is retrieved
-- from the current application definition (e.g. wwv_flow.g_nls_sort).
--
-- p_cursor: Cursor which has been opened (sys.dbms_sql.open_cursor) and
--           parsed (sys.dbms_sql.parse).
--==============================================================================
function execute (
    p_cursor in integer )
    return integer;

--==============================================================================
-- A wrapper for sys.dbms_sql.fetch_rows() that sets NLS session environment
-- (e.g. NLS_SORT) for the duration of the call. NLS environment is retrieved
-- from the current application definition (e.g. wwv_flow.g_nls_sort).
--
-- p_cursor: Cursor which has been executed (sys.dbms_sql.execute).
--==============================================================================
function fetch_rows (
    p_cursor in integer )
    return integer;

--==============================================================================
-- Executes a PL/SQL expression and returns a VARCHAR2 result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns string.
--==============================================================================
function get_plsql_expr_result_varchar2 (
    p_plsql_expression in varchar2,
    p_auto_bind_items  in boolean                  default true,
    p_names            in vc_arr2                  default c_empty_names,
    p_values           in vc_arr2                  default c_empty_values,
    p_parse_as_schema  in varchar2                 default wwv_flow_security.g_parse_as_schema )
    return varchar2;

--==============================================================================
-- Executes a PL/SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_expression: PL/SQL expression which returns boolean.
--==============================================================================
function get_plsql_expr_result_boolean (
    p_plsql_expression in varchar2,
    p_auto_bind_items  in boolean                  default true,
    p_names            in vc_arr2                  default c_empty_names,
    p_values           in vc_arr2                  default c_empty_values,
    p_parse_as_schema  in varchar2                 default wwv_flow_security.g_parse_as_schema )
    return boolean;

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
function get_plsql_func_result_varchar2 (
    p_plsql_function   in varchar2,
    p_auto_bind_items  in boolean                  default true,
    p_names            in vc_arr2                  default c_empty_names,
    p_values           in vc_arr2                  default c_empty_values,
    p_parse_as_schema  in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_do_substitutions in boolean                  default true )
    return varchar2;

--==============================================================================
-- Executes a PL/SQL function code block and returns a CLOB result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_plsql_function: PL/SQL function which returns a clob.
--                   For example:
--                   declare
--                       l_test clob;
--                   begin
--                       -- do something
--                       return l_test;
--                   end;
--==============================================================================
function get_plsql_func_result_clob (
    p_plsql_function  in varchar2,
    p_auto_bind_items in boolean                  default true,
    p_names           in vc_arr2                  default c_empty_names,
    p_values          in vc_arr2                  default c_empty_values,
    p_parse_as_schema in varchar2                 default wwv_flow_security.g_parse_as_schema )
    return clob;

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
function get_plsql_func_result_boolean (
    p_plsql_function  in varchar2,
    p_auto_bind_items in boolean                  default true,
    p_names           in vc_arr2                  default c_empty_names,
    p_values          in vc_arr2                  default c_empty_values,
    p_parse_as_schema in varchar2                 default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a PL/SQL code block.
--
-- The procedure automatically performs the necessary binding of bind variables.
--==============================================================================
procedure execute_plsql_code (
    p_plsql_code           in varchar2,
    p_auto_bind_items      in boolean  default true,
    p_names                in vc_arr2  default c_empty_names,
    p_values               in vc_arr2  default c_empty_values,
    p_parse_as_schema      in varchar2 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema       in boolean  default null,
    p_commit_session_state in boolean  default true );

--==============================================================================
-- Executes a SQL expression and returns a BOOLEAN result.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_expression: SQL expression which will be wrapped by
--                   select count(*) from dual where <p_sql_expression>.
--                   a row count of 0 returns FALSE otherwise TRUE.
--==============================================================================
function get_sql_expr_result_boolean (
    p_sql_expression  in varchar2,
    p_parse_as_schema in varchar2 default wwv_flow_security.g_parse_as_schema )
    return boolean;

--==============================================================================
-- Executes a SQL statement and returns TRUE if rows exist and FALSE if no row
-- is returned.
--
-- The function automatically performs the necessary binding of bind variables.
--
-- p_sql_statement: SQL statement which will be wrapped by
--                  select count(*) from dual where exists (<p_sql_statement>).
--==============================================================================
function do_rows_exist (
    p_sql_statement   in varchar2,
    p_auto_bind_items in boolean                  default true,
    p_names           in vc_arr2                  default c_empty_names,
    p_values          in vc_arr2                  default c_empty_values,
    p_parse_as_schema in varchar2                 default wwv_flow_security.g_parse_as_schema )
    return boolean;

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
    p_sql_statement   in varchar2,
    p_auto_bind_items in boolean                  default true,
    p_names           in vc_arr2                  default c_empty_names,
    p_values          in vc_arr2                  default c_empty_values,
    p_parse_as_schema in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema  in boolean                  default null )
    return varchar2;

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
    p_sql_statement   in varchar2,
    p_auto_bind_items in boolean                  default true,
    p_names           in vc_arr2                  default c_empty_names,
    p_values          in vc_arr2                  default c_empty_values,
    p_parse_as_schema in varchar2                 default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema  in boolean                  default null )
    return number;

--==============================================================================
-- Executes a SQL statement to find dependency objects.
--
-- p_schema: The schema to run the query as.
-- p_sql: SQL statement.
-- p_parse_as_schema_override: Internal use only. Set it to true to avoid parsing as application schema.
--==============================================================================
function get_dependency_objects (
    p_schema                   in varchar2,
    p_sql                      in varchar2,
    p_parse_as_schema_override in boolean         default false )
    return t_dependent_object_list;
    
--==============================================================================
-- Execute a DDL statement - no binds and execute, just parse
--
-- p_ddl:                      DDL statement
-- p_schema:                   The schema to run the query as.
-- p_is_user_schema:           Set it to true to avoid parsing as application schema, but ensure that p_schema is valid in the user's workspace
--                             If null, the value is determined by wwv_flow_security.g_parse_as_schema_override
--==============================================================================
procedure execute_ddl (
    p_ddl                      in varchar2,
    p_schema                   in varchar2        default wwv_flow_security.g_parse_as_schema,
    p_is_user_schema           in boolean         default null );

--##############################################################################
--#
--# WWV_DBMS_SQL LOW LEVEL INTERFACE
--#
--##############################################################################

--==============================================================================
-- Procedure to clear the current stored error backtrace.
--==============================================================================
procedure clear_error_backtrace;

--==============================================================================
-- Function to get the current stored error backtrace in case
-- of an error. Storing the error backtrace is necessary, because as soon as an
-- exception is handled, dbms_utility.format_error_backtrace returns a
-- wrong result (bug# 13510548).
--==============================================================================
function get_error_backtrace return varchar2;

--==============================================================================
-- Function to get the last statement where parsing raised an error
--==============================================================================
function get_error_statement return varchar2;

--==============================================================================
procedure parse_as_user (
    p_cursor    in integer,
    p_query     in varchar2,
    p_username  in varchar2,
    p_use_roles in boolean default FALSE);

--==============================================================================
procedure parse_array_as_user (
    p_cursor    in integer,
    p_query     in out nocopy wwv_flow_global.vc_arr2,
    p_username  in varchar2,
    p_use_roles in boolean default FALSE );

--==============================================================================
procedure parse_as_user (
    p_cursor    in integer,
    p_statement in sys.dbms_sql.varchar2a,
    p_username  in varchar2,
    p_lfflg     in boolean default FALSE,
    p_use_roles in boolean default FALSE);

--==============================================================================
-- runs long DDL statements that are stored in the
-- varchar2a table. Usage:
--
-- flows@DEV816> declare
-- 2  x dbms_sql.varchar2a;
-- 3  begin
-- 4     x(1) := 'create table ';
-- 5     x(2) := ' test ( x int )';
-- 6     sys.wwv_dbms_sql_APEX_050200.run_ddl( x, 'SCOTT' );
-- 7  end;
-- 8  /
--==============================================================================
procedure run_ddl (
    p_sql    in sys.dbms_sql.varchar2a,
    p_user   in varchar2 );

--==============================================================================
-- No inputs or outputs -- just execute
-- a block of code,
-- will autobind using GET_BINDS and V() function
--
-- p_sql can be anything except a SELECT (well, it can be
-- a select but nothing will happen if it is)
--==============================================================================
procedure run_block (
    p_sql       in varchar2,
    p_user      in varchar2,
    p_use_roles in boolean default FALSE);

--==============================================================================
-- No outputs - same as run_block except the bind
-- names are a varchar array and not a dbms_sql
-- data type.  If state is to be preserved then
-- bind vars that change during execution will be
-- written back to the flows session state cache.
--==============================================================================
procedure run_block2 (
    p_sql    in    varchar2,
    p_names  in vc_arr2,
    p_values in vc_arr2,
    p_user   in varchar2,
    p_preserve_state in boolean default TRUE );

--==============================================================================
-- No outputs - same as run_block except the bind
-- names are a varchar array and not a dbms_sql
-- data type.  If state is to be preserved then
-- bind vars that change during execution will be
-- written back to the flows session state cache.
--==============================================================================
procedure run_block3 (
    p_sql    in varchar2,
    p_names  in vc_arr2,
    p_values in vc_arr2,
    p_types  in vc_arr2,
    p_masks  in vc_arr2,
    p_user   in varchar2,
    p_preserve_state in boolean default TRUE );

--==============================================================================
-- No outputs - same as run_block2 but this not specify an outside and
-- binding variables.  This only binds using arrays and does not support
-- autobinds (bind variables directly in the statement but not in the array).
-- State will *not* be preserved.  Thus, any assignments to items or bind variables
-- performed in SQL in run_block4 will not persist.  For now, run_block4
-- should only be used for wwv_flow_dml.insert_row and wwv_flow_dml.update_row.
--==============================================================================
procedure run_block4 (
    p_sql    in    varchar2,
    p_names  in vc_arr2,
    p_values in vc_arr2,
    p_user   in varchar2 );

--==============================================================================
-- PL/SQL syntax check
-- wraps begin return null; end; around p_sql and executes
-- using run_block
--==============================================================================
function check_plsql (
    p_plsql_code      in varchar2,
    p_parse_as_schema in varchar2 )
    return varchar2;

--==============================================================================
-- PL/SQL syntax check
-- wraps begin return null; end; around p_sql and executes
-- using run_block
--==============================================================================
function check_plsql (
    p_sql               in varchar2,
    p_flow_id           in number,
    p_security_group_id in number
) return varchar2;

--==============================================================================
-- p_sql should be a query that selects A single row and A single
--  column and that column should be a NUMBER.
-- same as select_num below.
--==============================================================================
function countem (
    p_sql  in varchar2,
    p_user in varchar2 )
    return varchar2;

--==============================================================================
-- kill the session (p_sid, p_serial#)
--
-- ARGUMENTS
-- * p_sid       sid of the to be killed session
-- * p_serial#   serial# of the to be killed session
-- o p_inst_id   instance id of the to be killed session
-- o p_reason    textual description why the session has to be killed. if not
--               null, this will be logged to the alert file
--==============================================================================
procedure kill_session (
    p_sid     in number,
    p_serial# in number,
    p_inst_id in number   default null,
    p_reason  in varchar2 default wwv_flow.g_flow_id||':'||wwv_flow.g_flow_step_id||' '||wwv_flow_security.g_context );

--==============================================================================
-- Returns an ORA-06550: line %0, column %1 based on the SQL query and the error position.
--==============================================================================
function get_ora_06550 (
    p_sql_query      in varchar2,
    p_error_position in integer )
    return varchar2;

end wwv_flow_dynamic_exec;
/
show errors
