set define '^' verify off
prompt ...wwv_flow_sw_script
create or replace package wwv_flow_sw_script as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2005 - 2015. All Rights Reserved.
--
--    NAME
--      wwv_flow_sw_script.sql
--
--    DESCRIPTION
--      This package is used to manage script files from SQL Workshop Script Repository.
--
--      Some existing procedures from sw_api and wwv_flow_parser has been moved to this package.
--
--      This package has following limitation:
--      1.  Cannot run SELECT statement greater than 32KB.
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED  (MM/DD/YYYY)
--     cbcho     01/05/2005 - created
--     cbcho     01/31/2005 - Added function valid_script_name
--     cbcho     01/31/2005 - Removed run_job
--     cbcho     01/31/2005 - Added print_result,print_stmt
--     cbcho     02/04/2005 - Added submit_to_run,cancel_script
--     cbcho     02/11/2005 - Added p_error_raised in run_file
--     cbcho     02/14/2005 - Added getlengthb function to get clob length in bytes
--     cbcho     02/21/2005 - Added escape_sc_clob
--     cbcho     02/23/2005 - Changed update_script_file to accept script in clob to support > 32K
--     cbcho     02/25/2005 - Added overload procedure create_script_file to accept clob
--     cbcho     02/25/2005 - Added get_free_space function
--     cbcho     02/25/2005 - Added display_run_confirm procedure
--     cbcho     02/28/2005 - Exposed script_w_warning in the spec.
--     cbcho     03/04/2005 - Changed overloaded procedure create_script_file to create_script_from_clob
--     tmuth     03/25/2005 - Added draw_quotameter2
--     cbcho     05/04/2005 - Added get_success_cnt, get_failure_cnt functions
--     cbcho     05/13/2005 - Added print_clob to print string without escaping (Bug 4369143)
--     cbcho     05/20/2005 - Added p_session to run_file
--     cbcho     07/05/2005 - Added p_browser_language argument to run_file to set NLS (Bug 4472722)
--     cbcho     07/11/2005 - Backed out bug fix 4472722 since NLS is getting set from built in job process
--     mhichwa   12/02/2005 - Removed references to product name
--     cbcho     02/01/2006 - Added comment, Cannot run SELECT statement greater than 32KB, as package limitation.
--     hfarrell  04/05/2011 - Fix for bug 7048187: replaced all occurrences of varchar2s with varchar2a
--     cneumuel  04/17/2012 - Prefix sys objects with schema (bug #12338050)
--     cneumuel  07/30/2012 - In escape_sc_clob: added p_max_length
--     cneumuel  09/07/2015 - Removed cancel_script, job based execution was non-functional anyway (bug #21571379)
--
--------------------------------------------------------------------------------

g_result_id              number := null;

function get_success_cnt(p_result_id in number) return varchar2;

function get_failure_cnt(p_result_id in number) return varchar2;

function get_free_space return number;

function script_w_warning (p_file_id in number) return boolean;

function array_element(
    p_vcarr in wwv_flow_global.vc_arr2,
    p_index in number )
    return varchar2;

function invalid_script(p_file_id in number) return number;

function chunk_lines(p_stmt in  varchar2) return sys.dbms_sql.varchar2a;

function getlengthb (
    p_clob in clob) return number;

function valid_script_name (
    p_script_name in varchar2
    ) return boolean;

function create_script_file (
    p_script_name in varchar2,
    p_description in varchar2 default null,
    p_script      in varchar2 default null
    ) return number;

function draw_quotameter2(
         p_max_size     in number,
         p_current_size in number)
         return varchar2;

function draw_quotameter return varchar2;

procedure clean_out_orphan_long_op;

--==============================================================================
-- print html-escaped p_str
--
-- ARGUMENTS
-- * p_str        the string that should be printed
-- * p_max_length if not null, the number of characters in p_str that should be
--                printed
--==============================================================================
procedure escape_sc_clob (
    p_str        in clob,
    p_max_length in number default null );

--==============================================================================
procedure print_clob (p_str in clob);

procedure display_invalid_stmt(
    p_file_id          in number,
    p_date_time_format in varchar2);

procedure display_run_confirm (
    p_file_id          in number,
    p_date_time_format in varchar2);

procedure print_result (
    p_id in number);

procedure print_stmt (
    p_id in number);

procedure create_script_file (
    p_script_name in varchar2,
    p_script      in varchar2,
    p_description in varchar2 default null,
    p_file_id     in number   default null
    );

procedure create_script_from_clob (
    p_script_name in varchar2,
    p_script      in clob,
    p_description in varchar2 default null,
    p_file_id     in number   default null
    );

procedure save_file_attrib (
    p_flow_id           in number,
    p_security_group_id in number,
    p_name              in varchar2,
    p_created_by        in varchar2,
    p_filename          in varchar2 default null,
    p_description       in varchar2 default null,
    p_file_type         in varchar2 default 'SCRIPT',
    p_file_charset      in varchar2 default null
    );

procedure update_script_file (
    p_file_id     in number,
    p_script_name in varchar2,
    p_script      in clob
    );

procedure delete_file (
    p_id in number
    );

procedure run_file(
    p_result_id        in number,
    p_file_id          in number,
    p_schema           in varchar2,
    p_run_by           in varchar2,
    p_session          in number default null,
    p_job_id           in number default null,
    p_error_raised     in varchar2 default 'N'
    );

function submit_to_run (
    p_file_id  in number,
    p_run_by   in varchar2,
    p_run_as   in varchar2
    ) return number;

end wwv_flow_sw_script;
/
show error;
