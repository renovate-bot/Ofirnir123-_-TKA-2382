set define '^' verify off
prompt ...wwv_qs_design_schema_pub
create or replace package wwv_qs_design_schema_pub as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_qs_design_schema_pub.sql
--
--    DESCRIPTION
--     Primary package that facilitates Quick SQL functionality within APEX
--
--    NOTES
--      This API is unsupported.    
--
--    MODIFIED    (MM/DD/YYYY)
--     mhichwa     10/12/2017 - Created
--     mhichwa     02/13/2017 - removed get_example_desc, general clean up of help text and samples
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------
--

g_enable_inserts         boolean := true;
g_clob                   clob := null;
g_gen_mode               varchar2(30) := 'HTP';    -- valid values are HTP and CLOB
g_debug                  varchar2(32767) := null;
g_settings_override      varchar2(32767) := null;
   
-- global settings   
g_prefix                 varchar2(30) default null; -- prefix all objects with this text, if not proved an underscore will be added
g_api                    varchar2(1)  default 'N';  -- generate a PL/SQL API for each table
g_AUDIT_COLS             varchar2(1)  default 'N';  -- add created, updated, created_by and updated_by columns and trigger logic per table to track who created or updated rows
g_COMPRESSED             varchar2(1)  default 'N';  -- make tables compressed by adding compression option
g_DATE_DATATYPE          varchar2(60) := 'DATE';    -- generate date columns using DATE, TIMESTAMP, TIMESTAMP WITH TIMEZONE, TIMESTAMP WITH LOCAL TIME ZONE
g_ON_DELETE              varchar2(60) := 'CASCADE'; -- for foreign keys perform on delete CASCADE, RESTRICT, or SET NULL
g_ROW_KEY                varchar2(1)  default 'N';  -- generate a rowkey using a compress ID function on a sequence to provide a human readable key colunn
g_SGID                   varchar2(1)  default 'N';  -- generate a security group ID column to support multi-tenant apps
g_ROW_VERSION            varchar2(1)  default 'N';  -- add a row version column to each table and the trigger logic to populate it, starts at 1 and increments by 1 for each update
g_TRIGGER_METHOD         varchar2(60) := 'TRIG';    -- method of creating triggers to set primary key values, TRIG gets a GUID numeric id, IDENTITY use 12c identities
g_INCLUDE_DROPS          varchar2(1)  default 'N';  -- for all objects created generate drop scripts on top of the generated output
g_LONGER_IDENTIFIERS     varchar2(1)  default 'N';  -- support longer 128 byte object identifiers if Y, if N restrict to 30 bytes
g_HISTORY_TABLES         varchar2(1)  default 'N';  -- create a history table and view to track column changes
g_DB_VERSION             varchar2(6) := '12c';      -- generate syntax for database version 11g or 12c
g_AUTO_GEN_PK            varchar2(1) := 'Y';        -- automatically add a primary key column to tables 
g_editionable            varchar2(1) := 'N';        -- make PL/SQL objects editionable
g_language               varchar2(2)  := 'EN';      -- language control for generated data
g_apex                   varchar2(1) := 'N';        -- generate triggers that set updated_by and inserted_by using SYS_CONTEXT to obtain app user
--
g_prefix_pk_with_tname    varchar2(1)  := 'N';           --mike
g_created_column_name     varchar2(50) := 'created';     --mike
g_created_by_column_name  varchar2(50) := 'created_by';  --mike
g_updated_column_name     varchar2(50) := 'updated';     --mike
g_updated_by_column_name  varchar2(50) := 'updated_by';  --mike
--
g_audit                  varchar2(1) := 'N';        -- generated oracle audit on all tables
g_longer_varchars_yn     varchar2(1) := 'N';        -- support for varchar2(32767) if Y, if N maximum is varchar2(4000)
g_verbose_yn             varchar2(1) := 'N';        -- show all settings at end of generated scripts if Y, if N only show non default settings
g_schema                 varchar2(128) := null;     -- prefix object names with this schema dot
g_inserts                number := 0;               -- show SQL insert examples for all tables
g_selects                varchar2(1) := 'N';        -- show SQL select examples for all tables
g_uncomment              varchar2(1) := 'Y';        -- uncomment SQL insert and select examples
g_decimal_character      varchar2(1) := '.';        -- under development
g_group_seperator        varchar2(1) := ',';        -- under development
g_tags_fw                varchar2(1) := 'N';        -- generate tag framework

--function get_data_example (p_example_number in number default 1) return varchar2;

procedure get_model_worksheets (
    p_saved_model_id   in number default null)
    ;
    
procedure save_model_worksheets (
    p_saved_model_id   in number default null)
    ;
    
procedure log_status (
   p_status   in varchar2 default null,
   p_context  in varchar2 default null,
   p_sqlerrm  in varchar2 default null)
   ;
   
procedure remove_ws_not_in_use (
    p_markdown_sql  in varchar2 default null)
    ;
    
function worksheet_collection_exists (
    p_worksheet_name in varchar2 default null)
    return boolean
    ;
    
function is_number (p_string in varchar2 default null) return boolean;

function get_column_datatype (
    p_collection            in  varchar2 default null,
    p_column                in  varchar2 default null,
    p_date_format_mask      in  varchar2 default null)
    return varchar2;
    
function get_worksheet_structure (
   p_table_name             in varchar2 default null,
   p_collection_name        in varchar2 default null,
   p_first_row_is_header_yn in varchar2 default 'Y',
   p_date_format_mask       in varchar2 default 'DD-MON-YYYY')
   return varchar2
   ;
   
procedure set_settings_overrides (
    p_string             in varchar2 default null);

procedure get_default_settings (
    p_TABLE_PREFIX           out varchar2,
    p_ON_DELETE              out varchar2,
    p_COMPRESSED             out varchar2,
    p_PRIMARY_KEY            out varchar2,
    p_TRIGGER_METHOD         out varchar2,
    p_DATE_DATATYPE          out varchar2,
    p_API                    out varchar2,
    p_AUDIT_COLS             out varchar2,
    p_ROW_KEY                out varchar2,
    p_SGID                   out varchar2,
    p_ROW_VERSION            out varchar2,
    p_DB_VERSION             out varchar2,
    p_INCLUDE_DROPS          out varchar2,
    p_LONGER_IDENTIFIERS     out varchar2,
    p_HISTORY_TABLES         out varchar2,
    p_AUTO_GEN_PK            out varchar2,
    p_EDITIONABLE            out varchar2,
    p_language               out varchar2,
    p_APEX                   out varchar2,
    --
    p_prefix_pk_with_tname   out varchar2, --mike
    p_created_column_name    out varchar2, --mike
    p_created_by_column_name out varchar2, --mike
    p_updated_column_name    out varchar2, --mike
    p_updated_by_column_name out varchar2, --mike
    --
    p_audit                out varchar2,
    p_longer_varchars_yn   out varchar2,
    p_verbose_yn           out varchar2,
    p_schema               out varchar2,
    p_inserts              out number,
    p_selects              out varchar2,
    p_uncomment            out varchar2,
    p_tags_fw              out varchar2,
    p_semantics            out varchar2
    )
    ;
    
function trim_identifier_length (
    p_object_name     in varchar2 default null,
    p_length_override in number default 0)
    return varchar2;
    
function get_settings return varchar2 ;

function get_about return varchar2 ;

function get_model (p_id in number) return varchar2 ;
function get_model_from_history (p_id in number) return varchar2 ;
function get_view_syntax return varchar2 ;
procedure print_generated;
procedure print_settings (p_text in varchar2 default null);
procedure print_settings2 (p_text in varchar2 default null);
procedure log_history (
    p_str    in varchar2 default null)
    ;
function pre_process_lines (
    p_tables in varchar2 default null,
    p_name   in varchar2 default null)
    return varchar2
    ;
function clean_name (p_name in varchar2)
    return varchar2;
procedure extract_comments (
    p_string           in varchar2 default null,
    p_new_string       out varchar2,
    p_comments         out varchar2
    );
    
function get_pound_options return varchar2;
function get_additional_syntax return varchar2;
    
function get_column_datatypes return varchar2;
function get_column_directives return varchar2;
function get_table_directives return varchar2;
    
function get_rules return varchar2;
procedure init_collections ;

procedure add_tables (
    p_table_prefix       in varchar2 default null,
    p_date_datatype      in varchar2 default null,
    p_inc_auditing       in varchar2 default null,
    p_primary_key        in varchar2 default null,
    p_tables             in varchar2 default null,
    p_row_version        in varchar2 default 'N',
    p_row_key            in varchar2 default 'N',
    p_sgid               in varchar2 default 'N',
    p_compressed         in varchar2 default 'N',
    p_longer_identifiers in varchar2 default 'N',
    p_auto_gen_pk        in varchar2 default 'Y',
    p_history_tables     in varchar2 default 'N',
    p_apis               in varchar2 default 'N',
    p_audit_cols         in varchar2 default 'N',
    p_audit              in varchar2 default 'N',
    p_longer_varchars_yn in varchar2 default 'N',
    p_verbose_yn         in varchar2 default 'N',
    p_schema             in varchar2 default null,
    p_inserts            in number   default 0,
    p_selects            in varchar2 default 'N',
    p_uncomment          in varchar2 default 'Y',
    p_tags_fw_yn         in varchar2 default 'N',
    p_semantics          in varchar2 default 'DEFAULT'
    );
    
procedure save_as_sql (
    p_app_user           in varchar2 default null,
    p_app_session        in varchar2 default null,
    p_trigger_method     in varchar2 default 'STANDARD',
    p_fk                 in varchar2 default 'RESTRICT',
    P_row_version        in varchar2 default 'N',
    p_row_key            in varchar2 default 'N',
    p_sgid               in varchar2 default 'N',
    P_TABLE_PREFIX       in varchar2 default null,
    p_compressed         in varchar2 default 'N',
    p_db_version         in varchar2 default '12c',
    p_include_drops      in varchar2 default 'N',
    p_LONGER_IDENTIFIERS in varchar2 default 'N',
    p_history_tables     in varchar2 default 'N',
    p_apis               in varchar2 default 'N',
    p_AUTO_GEN_PK        in varchar2 default 'Y',
    p_audit_cols         in varchar2 default 'N',
    p_DATE_DATATYPE      in varchar2 default 'DATE',
    p_editionable        in varchar2 default 'N',
    p_language           in varchar2 default 'EN',
    p_apex               in varchar2 default 'N',
    --
    p_prefix_pk_with_tname   in varchar2, --mike
    p_created_column_name    in varchar2, --mike
    p_created_by_column_name in varchar2, --mike
    p_updated_column_name    in varchar2, --mike
    p_updated_by_column_name in varchar2, --mike
    --
    p_audit              in varchar2 default 'N',
    p_longer_varchars_yn in varchar2 default 'N',
    p_verbose_yn         in varchar2 default 'N',
    p_schema             in varchar2 default null,
    p_inserts            in number   default 0,
    p_selects            in varchar2 default 'N',
    p_uncomment          in varchar2 default 'Y',
    p_format_mask        in varchar2 default 'MM/DD/RR HH24:MI',
    p_tags_fw_yn         in varchar2 default 'N',
    p_semantics           in varchar2 default 'DEFAULT',
    --
    p_message            out varchar2,
    p_script_id          out varchar2
    );
end wwv_qs_design_schema_pub;
/
show errors

set define '^'
