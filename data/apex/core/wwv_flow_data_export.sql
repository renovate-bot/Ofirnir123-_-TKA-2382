set define '^' verify off
prompt ...wwv_flow_data_export
create or replace package wwv_flow_data_export as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2016. All Rights Reserved.
--
--    NAME
--      wwv_flow_data_export.sql
--
--    DESCRIPTION
--      This package is responsible for handling report data download.
--
--    MODIFIED   (MM/DD/YYYY)
--    cbcho       01/14/2016 - Created
--    cbcho       01/15/2016 - Removed htp writer and changed the writer to emit to clob always
--    pawolf      08/12/2016 - Made changes to support IG
--    cbcho       08/25/2016 - Added overall_label in t_aggregate, p_title in init
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------
 type t_column is record (
    heading           varchar2(255),
    label             varchar2(255),
    heading_alignment varchar2(6),
    value_alignment   varchar2(6),
    width             number,
    data_type         varchar2(128),
    format_mask       varchar2(255),
    is_escaped        boolean,
    group_idx         pls_integer, -- references an entry in t_column_groups
    is_column_break   boolean,
    value_idx         pls_integer  -- references the column value in the p_column_list or p_value_list arrays passed into emit_row, ...
                                   -- This allows that t_columns has a different display order than the data fetched from wwv_flow_plugin_util.get_data*
    );

type t_column_group is record (
    heading           varchar2(255),
    label             varchar2(255),
    alignment         varchar2(6),
    parent_group_idx  pls_integer -- references the parent entry in t_column_groups
    );

type t_aggregate is record (
    label             varchar2(255),
    column_idx        pls_integer,   -- references an entry in t_columns
    value_idx         pls_integer,   -- references the aggregate value in the p_column_list or p_value_list arrays passed into finish_column_break
    overall_label     varchar2(255),
    overall_value_idx pls_integer    -- references the overall value in the p_column_list or p_value_list arrays passed into emit_overall
    );

type t_highlight is record (
    column_idx        pls_integer,  -- references an entry in t_columns. Used only for column highlight
    text_color        varchar2(15),
    background_color  varchar2(15)
    );

type t_columns       is table of t_column       index by pls_integer;
type t_column_groups is table of t_column_group index by pls_integer;
type t_aggregates    is table of t_aggregate    index by pls_integer;
type t_highlights    is table of t_highlight    index by pls_integer;

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------
c_format_csv            constant varchar2(20) := 'CSV';
c_format_html           constant varchar2(20) := 'HTML';
c_output_as_file        constant varchar2(20) := 'FILE';
c_output_as_clob        constant varchar2(20) := 'CLOB';

c_empty_column_groups   t_column_groups;
c_empty_aggregates      t_aggregates;
c_empty_highlights      t_highlights;
c_empty_highlight_idx   wwv_flow_global.n_arr;
c_empty_value_list      wwv_flow_plugin_util.t_value_list;
c_empty_column_list     wwv_flow_plugin_util.t_column_list;

--------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------

--==============================================================================
-- The procedure initializes attributes needed for data export.
--
-- p_format           Export format (CSV or HTML)
-- p_columns          Collection of column attributes with column breaks in the beginning and rest in the order of display. 
-- p_column_groups    Collection of column group attributes in the order of levels and display.
-- p_aggregates       Collection of report aggregates
-- p_highlights       Collection of report highlights
-- p_header           Top header
-- p_footer           Bottom footer
-- p_output_as        Output as file or clob.  If CLOB, get_clob_output must be called to retrieve.
-- p_file_name        If p_output_as = c_file, required
-- p_csv_enclosed_by  Used for p_format = c_format_csv to enclose the output
-- p_csv_separator    Used for p_format = c_format_csv to separate the column values
--==============================================================================
procedure init (
    p_format           in varchar2,        
    p_columns          in t_columns,
    p_column_groups    in t_column_groups default c_empty_column_groups,
    p_aggregates       in t_aggregates    default c_empty_aggregates,
    p_highlights       in t_highlights    default c_empty_highlights,
    p_header           in varchar2        default null,
    p_footer           in varchar2        default null,
    --
    p_output_as        in varchar2        default c_output_as_file, -- FILE, CLOB
    p_title            in varchar2        default null,
    p_file_name        in varchar2        default null,
    --
    p_csv_enclosed_by  in varchar2        default null,
    p_csv_separator    in varchar2        default null );

--==============================================================================
-- The procedure emits top header and necessary logic to emit headings
--==============================================================================
procedure emit_header;

--==============================================================================
-- The procedure emits bottom footer and necessary logic to finish
--==============================================================================
procedure emit_footer;

--==============================================================================
-- The procedure emits a row with highlights if defined.
-- p_value_list / p_column_list   Array of column values index by t_column.value_idx
-- p_row_idx                      References the row value in p_column_list.value_list
--                                and has to be specified if p_column_list is passed in.
-- p_highlights                   List of highlights which evaluated to true.  It references g_hights index.
--==============================================================================
procedure emit_row (
    p_value_list  in wwv_flow_plugin_util.t_value_list  default c_empty_value_list,
    p_column_list in wwv_flow_plugin_util.t_column_list default c_empty_column_list,
    p_row_idx     in pls_integer                        default null,
    p_highlights  in wwv_flow_global.n_arr              default c_empty_highlight_idx );

--==============================================================================
-- The procedure emits previous column break aggregate values.
-- p_value_list / p_column_list   The aggregate values are indexed by t_aggregates.value_idx
-- p_row_idx                      References the row value in p_column_list.value_list
--                                and has to be specified if p_column_list is passed in.
--==============================================================================
procedure finish_column_break (
    p_value_list  in wwv_flow_plugin_util.t_value_list  default c_empty_value_list,
    p_column_list in wwv_flow_plugin_util.t_column_list default c_empty_column_list,
    p_row_idx     in pls_integer                        default null );

--==============================================================================
-- The procedure emits the overall aggregate values.
-- p_value_list / p_column_list   The overall aggregate values are indexed by t_aggregates.overall_value_idx
-- p_row_idx                      References the row value in p_column_list.value_list
--                                and has to be specified if p_column_list is passed in.
--==============================================================================
procedure emit_overall (
    p_value_list  in wwv_flow_plugin_util.t_value_list  default c_empty_value_list,
    p_column_list in wwv_flow_plugin_util.t_column_list default c_empty_column_list,
    p_row_idx     in pls_integer                        default null );

--==============================================================================
-- The procedure gets the clob buffer.
--==============================================================================
procedure get_clob_output( p_clob in out nocopy clob);

end  wwv_flow_data_export;
/
show errors
