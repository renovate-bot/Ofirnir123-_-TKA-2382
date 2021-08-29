set define '^' verify off
create or replace package sys.wwv_dbms_sql_APEX_180200 authid current_user
$if sys.dbms_db_version.version >= 12 $then
accessible by (APEX_180200.WWV_FLOW_DYNAMIC_EXEC,APEX_180200.WWV_FLOW_SESSION_RAS,APEX_180200.WWV_FLOW_UPGRADE)
$end
as
--------------------------------------------------------------------------------
--
--    MODIFIED   (MM/DD/YYYY)
--      jkallman  01/28/2008 - Created
--      mhichwa   01/30/2008 - Added procedure parse_as_user and open cursor
--      sspadafo  01/30/2008 - Make package invoker's rights
--      jkallman  01/31/2008 - Change parse_as_user arguments to take username and not id, remove open_cursor
--      jkallman  02/04/2008 - Change all names and values arrays to be of type sys.wwv_dbms_sql.vc_arr2
--      jkallman  03/15/2010 - Added function is_ws_query_valid
--      jstraub   03/24/2010 - Removed is_ws_query_valid
--      jkallman  03/30/2010 - Added procedure kill_session
--      hfarrell  04/05/2011 - Fix for bug 7048187: replaced all occurrences of varchar2s with varchar2a
--      jstraub   11/23/2011 - Added back signatures for run_ddl and parse_as_user with varchar2s for 3.2 compat (bug 13415471)
--      pawolf    12/22/2011 - Added clear/get_error_backtrace to remove dependency to wwv_flow_error package
--      pawolf    01/10/2012 - Added new parameters to select_vc, select_num and select_date (bug# 13576517)
--      cneumuel  05/08/2012 - Removed get_userid, valueof_vc, valueof_num, valueof_date, func_returning_cursor
--      cneumuel  06/25/2012 - Added back get_userid, valueof_vc, valueof_num, valueof_date, func_returning_cursor with dummy implementations, to avoid errors in APEX_030200
--      cneumuel  02/08/2013 - get_parallel_requests: function returns v$session info for requests to a workspace. In kill_session: added p_reason (bug #15893138)
--      cneumuel  02/25/2013 - In get_parallel_requests: use wwv_flow_gv$session, removed event column (bug #15893138)
--      cneumuel  06/26/2013 - Obsoleted parse_as_user(varchar2s), run_ddl(varchar2s)
--      cneumuel  07/17/2013 - Added get_error_statement
--      cneumuel  05/05/2014 - Replaced wwv_flow_gv$session with sys.gv_$session
--      cneumuel  11/04/2014 - Added get_version_identifier (feature #1153)
--      cneumuel  01/15/2015 - Added overloaded get_parallel_requests (bug #20364030)
--      cneumuel  09/09/2016 - Moved run_block%, etc to wwv_flow_dynamic_exec. Added APEX schema suffix.
--      cneumuel  10/10/2016 - Removed get_version_identifier, can not be used because of ACCESSIBLE BY
--      hfarrell  01/05/2017 - Changed APEX_050100 references to APEX_050200
--
--------------------------------------------------------------------------------

subtype t_ras_sessionid is raw(16);
g_ras_sessionid t_ras_sessionid;

type vc_arr2 is table of varchar2(32767) index by binary_integer;

c_empty_vc_arr2 vc_arr2;

--==============================================================================
-- Procedure to clear the current stored error backtrace.
--==============================================================================
procedure clear_error_backtrace;

--==============================================================================
-- Procedure to get the current stored error backtrace in case
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
-- Procedure to close an open cursor and set the error backtrace in case of an
-- error. This is necessary, because as soon as an exception is handled,
-- dbms_utility.format_error_backtrace returns a wrong result (bug# 13510548).
-- If a backtrace is already saved, this procedure does nothing. Therefore, it
-- always has to be called in combination with clear_error_state, either
-- directly or indirectly (parse_as_user procedures already call
-- clear_error_state).
--==============================================================================
procedure on_error (
    p_cursor_to_close in out number,
    p_error_statement in varchar2 );
procedure on_error (
    p_cursor_to_close in out number,
    p_error_statement in sys.dbms_sql.varchar2a );

--==============================================================================
procedure parse_as_user (
    p_cursor    in integer,
    p_query     in varchar2,
    p_username  in varchar2,
    p_use_roles in boolean default FALSE);

--==============================================================================
procedure parse_as_user (
    p_cursor    in integer,
    p_statement in sys.dbms_sql.varchar2a,
    p_username  in varchar2,
    p_lfflg     in boolean default FALSE,
    p_use_roles in boolean default FALSE);

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
    p_reason  in varchar2 default null );

end wwv_dbms_sql_APEX_180200;
/
show errors
