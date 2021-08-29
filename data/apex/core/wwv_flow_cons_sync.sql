set define '^' verify off
prompt ...wwv_flow_cons_sync
create or replace package wwv_flow_cons_sync as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_cons_sync.sql
--
--    DESCRIPTION
--      Cache referential integrity information to speed meta data queries.
--
--    RUNTIME DEPLOYMENT: 
--
--    MODIFIED  (MM/DD/YYYY)
--     mhichwa   07/17/2017 - Created
--     mhichwa   07/18/2017 - Added insert_schema and truncate_cache
--     mhichwa   07/19/2017 - Reworked print summaries
--     cbcho     11/21/2017 - Renamed the package by removing the version post fix (feature #2228)
--
--------------------------------------------------------------------------------

--
-- monitoring and testing
--

procedure print_sync_schema_summary (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;
procedure print_hard_sync_summary (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;
procedure print_dictionary_qry_summary (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;
procedure print_cached_qry_summary (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;
procedure print_count_of_cached_rows
    ;
function count_all_cached_rows
    return number
    ;
procedure count_query_dictionary_rows  (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;

--
-- sync APIs
--

procedure last_changed_cached_rows (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;

procedure last_changed_dictionary_rows  (
    p_schema          in varchar2 default null,
    p_constraint_type in varchar2 default null)
    ;

function constraints_have_changed (
    p_schema            in varchar2,
    p_constraint_type   in varchar2 default null) 
    return boolean
    ;

procedure insert_schema (
    p_schema          in varchar2,
    p_constraint_type in varchar2 default null)
    ;

procedure sync_all_schemas 
    ;

procedure update_sync_all_schemas
    ;

procedure sync_schema (
    p_schema          in varchar2,
    p_constraint_type in varchar2 default null)
    ;

procedure sync_schema_if_changed (
    p_schema          in varchar2,
    p_constraint_type in varchar2 default null)
    ;

function  constraints_exist (
    p_schema          in varchar2,
    p_constraint_type in varchar2 default null)
    return boolean
    ;

procedure truncate_cache;

end wwv_flow_cons_sync;
/
show errors
