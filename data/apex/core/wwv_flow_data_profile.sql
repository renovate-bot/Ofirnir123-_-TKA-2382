set define '^' verify off
prompt ...wwv_flow_data_profile.sql
create or replace package wwv_flow_data_profile as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_data_profile
--
--    DESCRIPTION
--      Data Profile processing logic
--
--
--    MODIFIED   (MM/DD/YYYY)
--    cczarski    05/24/2017 - Created
--    cczarski    06/01/2017 - changed data profile record structure 
--    cczarski    08/31/2017 - In describe_profile: Added p_include_hidden parameter
--    cczarski    09/04/2017 - Added "derived" columns
--    cczarski    09/06/2017 - Added "column name index" attribute to t_data_profile for easy column name lookups
--    cczarski    09/13/2017 - Added support for CLOB data type for services with XML payloads
--    cczarski    10/18/2017 - Pass p_columns to "get_response_parsing_sql" in order to optimize generated SQL query
--    cczarski    01/10/2018 - in get_response_parsing_sql: Added p_optimize_columns to prevent column elimination
--    cczarski    01/15/2018 - in get_response_parsing_sql: Added p_clob_to_varchar2 attribute
--    cczarski    02/09/2018 - Allow data profile column type "Document Section"
--
--------------------------------------------------------------------------------

--======================================================================================================================
-- Global types
--======================================================================================================================

subtype t_data_format is pls_integer range 1..2;

type t_column_name_idx is table of pls_integer index by varchar2(255);

type t_column is record(
    name                  varchar2(255),
    is_primary_key        boolean       default false,
    data_type             varchar2(255),
    max_length            number,
    format_mask           varchar2(255),
    is_hidden             boolean       default false,
    has_time_zone         boolean       default false,
    selector              varchar2(255),
    sql_expression        varchar2(4000),
    remote_attribute_name varchar2(255) );

type t_columns is table of t_column index by pls_integer;

type t_data_profile is record(
    name               varchar2(255),
    format             t_data_format,
    encoding           varchar2(255),
    decimal_characters varchar2(2),
    row_selector       varchar2(255),
    single_row         boolean default false,
    xml_namespaces     varchar2(32767),
    data_columns       t_columns,
    column_name_idx    t_column_name_idx );

--======================================================================================================================
-- constants
--======================================================================================================================
c_datatype_number_vc        constant varchar2(6)   := 'NUMBER';
c_datatype_varchar2_vc      constant varchar2(8)   := 'VARCHAR2';
c_datatype_date_vc          constant varchar2(4)   := 'DATE';
c_datatype_timestamp_vc     constant varchar2(9)   := 'TIMESTAMP';
c_datatype_timestamp_tz_vc  constant varchar2(24)  := 'TIMESTAMP WITH TIME ZONE';
c_datatype_timestamp_ltz_vc constant varchar2(30)  := 'TIMESTAMP WITH LOCAL TIME ZONE';
c_datatype_clob_vc          constant varchar2(4)   := 'CLOB';
c_datatype_document_vc      constant varchar2(17)  := 'DOCUMENT_FRAGMENT';

c_sql_varchar2_max_len      constant pls_integer   := 4000;

c_clob_bind_name            constant varchar2(14)  := 'APX$CLOB_VALUE';
c_clobarray_bind_prefix     constant varchar2(9)   := 'APX$CLARR';

c_format_xml                constant t_data_format := 1;
c_format_json               constant t_data_format := 2;

c_xml_ns_prefix             constant pls_integer   := 1;
c_xml_ns_value              constant pls_integer   := 2;

--======================================================================================================================
-- Helper function: fetches data profile data from WWV_FLOW_DATA_PROFILES based on ID. Uses OUT parameters in order
-- to get all information with one call.
--
-- PARAMETERS:
--    p_data_profile_id      IN  the ID of the data profile
--    p_data_profile         OUT data profile details
--    p_data_profile_cols    OUT data profile column details
--======================================================================================================================
procedure fetch_data_profile(
    p_data_profile_id   in  number,
    p_data_profile      out t_data_profile );

--======================================================================================================================
-- generates the SQL query to parse a REST response using the data profile
-- 
-- PARAMETERS
--     p_data_profile_id     ID of the data profile
--
-- RETURNS
--     the SQL query to parse the REST response
--
-- EXAMPLE
--
--     declare
--         l_sql clob;
--     begin
--         l_sql := wwv_flow_data_profile.get_response_parsing_sql(
--             p_data_profile_id => 3124897796314756235874 );
--     end;
--======================================================================================================================
function get_response_parsing_sql(
    p_data_profile_id   in number,
    p_columns           in wwv_flow_exec_api.t_columns default wwv_flow_exec_api.c_empty_columns,
    p_array_cnt         in pls_integer                 default null,
    p_optimize_columns  in boolean                     default true,
    p_clob_to_varchar2  in boolean                     default false )
return clob;

--======================================================================================================================
-- generates the SQL query to parse a REST response using the data profile
-- 
-- PARAMETERS
--     p_data_profile_id     ID of the data profile
--
-- RETURNS
--     the SQL query to parse the REST response
--
-- EXAMPLE
--
--     declare
--         l_sql clob;
--     begin
--         l_sql := wwv_flow_data_profile.get_response_parsing_sql(
--             p_data_profile_id => 3124897796314756235874 );
--     end;
--======================================================================================================================
function get_response_parsing_sql(
    p_data_profile      in t_data_profile,
    p_columns           in wwv_flow_exec_api.t_columns default wwv_flow_exec_api.c_empty_columns,
    p_array_cnt         in pls_integer                 default null,
    p_optimize_columns  in boolean                     default true,
    p_clob_to_varchar2  in boolean                     default false )
return clob; 

--======================================================================================================================
-- return the REST service response attribute for a given column name. 
--
-- PARAMETERS
--     P_COLUMN_NAME       IN column name
--  
-- RETURNS
--     name of the service response attribute representing the column
--
--======================================================================================================================
function get_attribute_for_column(
    p_data_profile in t_data_profile,
    p_column_name  in varchar2 ) return varchar2;

--======================================================================================================================
-- Helper Function: append a '_' when input value is a reserved word
--
-- PARAMETERS
--     P_STRING      IN column, table or other name
-- 
-- RETURNS
--     '_' appended to input value when the input value is a reserved word.-- EXAMPLE
--
-- EXAMPLE
--
--     declare
--         l_column_name varchar2(255);
--     begin
--         l_column_name := wwv_flow_data_profile.handle_reserved_word( 'NESTED_TABLE_ID' );
--     end;
--======================================================================================================================
function handle_reserved_word( p_string in varchar2 ) return varchar2;

--======================================================================================================================
-- Helper Function: create the XMLNAMESPACES clause for XMLTABLE from the contents of the
--                  WWV_FLOW_DATA_PROFILES.XML_NAMESPACES column.
-- 
--                  http://www.w3.org/some/namespace=ns1
--                  http://www.some.other.com/namespace=ns2
--
--                  ... becomes ...
--
--                  'http://www.w3.org/some/namespace' as "ns1", 'http://www.some.other.com/namespace' as "ns2"
--
-- PARAMETERS
--     P_STRING     XML Namespaces in "WWV_FLOW_DATA_PROFILES.XML_NAMESPACES" format
-- 
-- RETURNS
--     XML Namespaces in XMLNAMESPACES format for usage within SQL XMLTABLE function
--======================================================================================================================
function create_xmlnamespaces_string( p_metadata_namespaces in varchar2 ) return varchar2;

--======================================================================================================================
-- returns the columns of the data profile as wwv_flow_exec_api.t_columns type
-- 
-- PARAMETERS
--     p_data_profile_id     ID of the data profile
--
-- RETURNS
--     column information for the data profile
--======================================================================================================================
function describe_profile( 
    p_data_profile_id in wwv_flow_data_profiles.id%type,
    p_include_hidden  in boolean default false
) return wwv_flow_exec_api.t_columns; 

end wwv_flow_data_profile;
/
sho err

set define '^'
