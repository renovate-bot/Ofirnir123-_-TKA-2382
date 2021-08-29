set define '^' verify off
prompt ...wwv_qs_data
create or replace package wwv_qs_data as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_qs_data.sql
--
--    DESCRIPTION
--     Provide sample data generation for Quick SQL functionality within APEX
--
--    NOTES
--      This API is unsupported.    
--
--    MODIFIED    (MM/DD/YYYY)
--     mhichwa     10/12/2017 - Created
--
--------------------------------------------------------------------------------

function get_count(
    p_language in varchar2 default 'en')
    return number
    ;

procedure load (
    p_language in varchar2 default 'en')
    ;
    
procedure remove (
    p_language in varchar2 default 'en')
    ;
    
function get_random_text (
    p_language in varchar2 default 'en',
    p_words    in number   default 10)
    return varchar2;
    
function get_random_project (
    p_language in varchar2 default 'en')
    return varchar2;
    
function get_random_job (
    p_language in varchar2 default 'en')
    return varchar2;
    
function get_random_dept_name (
    p_language in varchar2 default 'en')
    return varchar2;
    
function get_random_tags (
    p_language in varchar2 default 'en')
    return varchar2;

end wwv_qs_data;
/
show errors

set define '^' 
