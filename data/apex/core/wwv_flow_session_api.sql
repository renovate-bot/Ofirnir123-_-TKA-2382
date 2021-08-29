set define '^' verify off
prompt ...wwv_flow_session_api.sql
create or replace package wwv_flow_session_api authid current_user as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_session_api.sql - APEX_SESSION
--
--    DESCRIPTION
--      This package enables you to configure Application Express sessions.
--
--    RUNTIME DEPLOYMENT: YES
--    PUBLIC:             YES
--
--    MODIFIED   (MM/DD/YYYY)
--      cneumuel  01/26/2016 - Created
--      cneumuel  09/12/2017 - Added create_session, delete_session, attach, detach (feature #1558)
--      cneumuel  09/15/2017 - In create_session, attach: added p_page_id (feature #1558)
--
--------------------------------------------------------------------------------

--==============================================================================
-- Set debug level for all future requests in a session.
--
-- ARGUMENTS
--   * p_session_id: The session id. The session must belong to the current
--                   workspace or the caller must be able to set the session's
--                   workspace.
--   * p_level:      The debug level. NULL disables debug, 1-9 sets a debug level.
--
-- EXAMPLE
--   Set debug for session 1234 to INFO level.
--
--   apex_session.set_debug (
--       p_session_id => 1234,
--       p_level      => apex_debug.c_log_level_info );
--   commit;
--
-- EXAMPLE
--   Disable debug in session 1234.
--
--     apex_session.set_debug (
--         p_session_id => 1234,
--         p_level      => null );
--     commit;
--
-- SEE ALSO
--   apex_debug.enable, apex_debug.disable
--==============================================================================
procedure set_debug (
    p_session_id in number default wwv_flow.g_instance,
    p_level      in wwv_flow_debug_api.t_log_level );

--==============================================================================
-- Set trace mode in all future requests of a session.
--
-- ARGUMENTS
--   * p_session_id: The session id. The session must belong to the current
--                   workspace or the caller must be able to set the session's
--                   workspace.
--   * p_trace:      The trace mode. NULL disables trace, SQL enables SQL trace.
--
-- EXAMPLE
--   Enable trace in requests for session 1234.
--
--   apex_session.set_trace (
--       p_session_id => 1234,
--       p_mode       => 'SQL' );
--   commit;
--
-- EXAMPLE
--   Disable trace in requests for session 1234.
--
--     apex_session.set_trace (
--         p_session_id => 1234,
--         p_mode       => null );
--     commit;
--==============================================================================
procedure set_trace (
    p_session_id in number default wwv_flow.g_instance,
    p_mode       in varchar2 );

--==============================================================================
-- Create a new session for the given application, set environment and run the
-- application's Initialization PL/SQL Code.
--
-- ARGUMENTS
--   * p_app_id:   The application id.
--   * p_page_id:  The application page.
--   * p_username: The session user.
--
-- RAISES
--   * WWV_FLOW.APP_NOT_FOUND_ERR: The application does not exist or the caller
--     has no access to the workspace.
--
-- EXAMPLE
--   Create a session for EXAMPLE USER in application 100 page 1, then print the
--   app id and session id.
--
--     begin
--         apex_session.create_session (
--             p_app_id   => 100,
--             p_page_id  => 1,
--             p_username => 'EXAMPLE USER' );
--         sys.dbms_output.put_line (
--             'App is '||v('APP_ID)||', session is '||v('APP_SESSION'));
--     end;
--
-- SEE ALSO
--   delete_session, attach, detach
--==============================================================================
procedure create_session (
    p_app_id   in number,
    p_page_id  in number,
    p_username in varchar2 );

--==============================================================================
-- Delete the session with the given ID. If the session is currently attached,
-- call the application's Cleanup PL/SQL Code and reset the environment.
--
-- This procedure does nothing if the given session does not exist or if the
-- caller can not access the session's workspace.
--
-- ARGUMENTS
--   * p_session_id: The session id.
--
-- RAISES
--   * APEX.SESSION.EXPIRED: The session does not exist.
--   * SECURITY_GROUP_ID_INVALID: Current workspace does not match session
--     workspace.
--
-- EXAMPLE
--   Delete session 12345678.
--
--     begin
--         apex_session.delete_session (
--             p_session_id => 12345678 );
--     end;
--
-- SEE ALSO
--   create_session, attach, detach
--==============================================================================
procedure delete_session (
    p_session_id in number default wwv_flow.g_instance );

--==============================================================================
-- Based on the given application and session current, set environment and run
-- the Initialization PL/SQL Code.
--
-- ARGUMENTS
--   * p_app_id:     The application id.
--   * p_page_id:    The application page.
--   * p_session_id: The session id.
--
-- RAISES
--   * WWV_FLOW.APP_NOT_FOUND_ERR: Application does not exist or caller has no
--     access to the workspace.
--   * APEX.SESSION.EXPIRED: The session does not exist.
--   * SECURITY_GROUP_ID_INVALID: Current workspace does not match session
--     workspace.
--
-- EXAMPLE
--   Attach to session 12345678 for application 100 page 1, then print the app
--   id and session id.
--
--     begin
--         apex_session.attach (
--             p_app_id     => 100,
--             p_page_id    => 1,
--             p_session_id => 12345678 );
--         sys.dbms_output.put_line (
--             'App is '||v('APP_ID)||', session is '||v('APP_SESSION'));
--     end;
--
-- SEE ALSO
--   create_session, delete_session, detach
--==============================================================================
procedure attach (
    p_app_id     in number,
    p_page_id    in number,
    p_session_id in number );

--==============================================================================
-- Detach from the current session, reset the environment and run the
-- application's Cleanup PL/SQL Code.
--
-- This procedure does nothing if no session is attached.
--
-- EXAMPLE
--   Detach from the current session.
--
--     begin
--         apex_session.detach;
--     end;
--
-- SEE ALSO
--   create_session, delete_session, attach
--==============================================================================
procedure detach;

end wwv_flow_session_api;
/
show err
