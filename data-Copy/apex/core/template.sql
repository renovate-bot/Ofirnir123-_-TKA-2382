set define '^' verify off
prompt ...wwv_flow_templates_util
create or replace package wwv_flow_templates_util as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2015. All Rights Reserved.
--
--    DESCRIPTION
--      Flow template rendering engine
--
--    SECURITY
--      Publicly executable
--
--    RUNTIME DEPLOYMENT: YES
--
--    NOTES
--      This program shows an html page header and footer.
--      Templates can have the following pound sign "#" based substitutions:
--      1. #TITLE#           -- HTML body title
--      2. #NAVIGATION_BAR#  -- Location of navigation Bar
--      3. #FORM_OPEN#       -- Opens HTML form used by flows
--      4. #FORM_CLOSE#      -- Closes HTML form opened
--      5. #SUCCESS_MESSAGE# -- If set by flow engine display here
--      Templates can also reference any flow variable using &VARIABLE syntax
--      Tab templates use #TAB_TEXT#
--
--    MODIFIED   (MM/DD/YYYY)
--     mhichwa    08/18/1999 - Created
--     mhichwa    11/08/1999 - Added fetch_tab_info
--     mhichwa    11/29/1999 - Added copy_template procedure
--     mhichwa    11/30/1999 - Added template_success_procedure assignment
--     mhichwa    12/02/1999 - Moved g_template from body to spec
--     mhichwa    12/12/1999 - Added set_user_template_preference, get_user_template_preference
--     mhichwa    12/28/2000 - Added p_copy_from_flow_id to copy_template
--     mhichwa    02/01/2000 - Added copy plug template
--     mhichwa    02/06/2000 - Added copy row template
--     mhichwa    12/03/2000 - Added copy list template
--     mhichwa    12/17/2000 - Added get_template_id to break dependancy on template_name
--     mhichwa    12/17/2000 - Changed datatype of g_template from varchar2 to number
--     mhichwa    12/17/2000 - Changed fetch_tab_info to take a number in
--     mhichwa    12/17/2000 - Added procedure set_page_template_names_2_ids
--     mhichwa    01/21/2001 - Added get_template_name
--     mhichwa    03/11/2001 - Added grant to public
--     mhichwa    10/08/2001 - Added copy field template
--     cbcho      02/18/2002 - Added p_to_template_id on copy_plug
--     cbcho      02/22/2002 - Added p_to_template_id on all copy template procedures
--     cbcho      05/06/2002 - Added copy menu template
--     cbcho      06/06/2002 - Added replace procedures to replace templates
--     mhichwa    06/06/2002 - Added p_show_error arguments
--     cbcho      07/02/2002 - Added page_template_popup_preview
--     cbcho      07/18/2002 - Added copy and replace button template
--     krlice     05/25/2004 - Added Calendar
--     skutz      06/14/2004 - Added theme_id and theme_class_id to copy procedures
--     skutz      06/14/2004 - Added copy_popup_api
--     sspadafo   12/17/2005 - Removed procedures set_flow_template_names_2_ids, migrate_region_template_names, migrate_page_template_names (Bugs 4873426,4873405)
--     cbcho      04/06/2006 - Added procedure substitution_strings (large PL/SQL move from 4000:4655)
--     cbcho      04/06/2006 - Renamed substitution_strings to list_template_sub_str
--     cbcho      04/06/2006 - Added breadcrumb_template_sub_str (large PL/SQL move from 4000:289)
--     cbcho      04/07/2006 - Added label_template_sub_str (large PL/SQL move from 4000:85)
--     cbcho      04/07/2006 - Added button_template_sub_str (large PL/SQL move from 4000:204)
--     cbcho      04/07/2006 - Added page_template_utilization (large PL/SQL move from 4000:4029)
--     sspadafo   01/02/2009 - Removed "grant execute to public" from end of file
--     mhichwa    11/04/2009 - support ACCESSIBILITY_TOGGLE
--     pawolf     05/08/2012 - Removed get_header and get_footer
--     msewtz     06/15/2014 - Fixed copying of template options to include theme level tempalte options
--     msewtz     07/22/2014 - Added theme subscriptions (feature 823) 
--     arayner    08/01/2014 - Added types and functions in support of easier template substitution string usage table rendering
--     msewtz     12/03/2014 - Added remove_template_opt_classes
--     msewtz     12/04/2014 - Added function to compute template references
--     msewtz     12/05/2014 - Added remove_ununsed_templates
--     msewtz     12/08/2015 - Updated template option push and removal logic to integrate with template subscription
--     msewtz     02/18/2015 - Added template option preset sync procedures 
--     msewtz     03/05/2015 - Added get_default_template_id
--     msewtz     03/13/2015 - Added is_template_readonly (bug 20702049)
--     cneumuel   09/17/2015 - Dropped obsolete set_user_template_preference, get_user_template_preference (bug #20197863)
--     msewtz     08/05/2016 - Adding internal template name (feature 2040)
--
--------------------------------------------------------------------------------


-------------------
-- Global Variables
--
g_template  number := null;

-- Template substitution string details
type substitution_string_detail is record(
    description     varchar2(4000),
    is_referenced   boolean);

-- Array of template substitution string details, indexed by the name
type substitution_string_by_name is table of substitution_string_detail index by varchar2(4000);

-- Array of substitution string arrays, indexed by the 'Referenced From' value
type template_string_usage is table of substitution_string_by_name index by varchar2(4000);


------------------------------------
-- Template Procedures and Functions
--


-- Function to determine if a varchar2 value (p_from) contains another value (p_str)
--
function is_ref(
    p_from  in varchar2,
    p_str   in varchar2 default null)
    return boolean;

-- Function to determine if a clob value (p_from) contains another value (p_str)
--
function is_ref(
    p_from  in clob,
    p_str   in varchar2 default null)
    return boolean;

-- Procedure to add a substitution string to the record structure used to render the template usage table
-- Template passed as a clob
--
procedure add_usage_string(
    p_sub_str_by_name   in out  substitution_string_by_name,
    p_name              in      varchar2,
    p_description       in      varchar2,
    p_template          in      clob);

-- Procedure to add a substitution string to the record structure used to render the template usage table
-- Template passed as a varchar2
--
procedure add_usage_string(
    p_sub_str_by_name   in out  substitution_string_by_name,
    p_name              in      varchar2,
    p_description       in      varchar2,
    p_template          in      varchar2);

function is_template_readonly (
    p_template_id in number
) return boolean;

function get_template_id (
    p_template_name    in varchar2)
    return number
    ;

function get_default_template_id (
    p_flow_id       in number,
    p_theme_id      in number,
    p_template_type in varchar2        
) return number;    

function get_page_template_name (
    p_template_id      in varchar2 default null)
    return varchar2
    ;

function get_internal_template_name (
    p_internal_name in varchar2,
    p_template_name in varchar2    
) return varchar2;

procedure fetch_tab_info (
    p_template_id      in number)
    ;

procedure sync_page_tmplopt_presets (
    p_page_template_id in number
);

procedure sync_region_tmplopt_presets (
    p_region_template_id in number
);

procedure sync_report_tmplopt_presets (
    p_report_template_id in number
);

procedure sync_list_tmplopt_presets (
    p_list_template_id in number
);

procedure sync_bc_tmplopt_presets (
    p_bc_template_id in number
);

procedure sync_field_tmplopt_presets (
    p_field_template_id in number
);

procedure sync_button_tmplopt_presets (
    p_button_template_id in number
);

function template_option_exists (
    p_flow_id              in number,
    p_theme_id             in number,
    p_template_option_css  in varchar2,
    p_template_option_type in varchar2
) return boolean;

procedure remove_template_opt_classes (
    p_flow_id             in number,
    p_template_types      in varchar2,
    p_region_template_id  in number default null,
    p_button_template_id  in number default null,
    p_list_template_id    in number default null,
    p_field_template_id   in number default null,
    p_page_template_id    in number default null,
    p_bc_template_id      in number default null,
    p_report_template_id  in number default null,
    p_old_css_classes     in varchar2
);

procedure push_template_opt_classes (
    p_flow_id             in number,
    p_template_types      in varchar2,
    p_virtual_template_id in number default null,
    p_region_template_id  in number default null,
    p_button_template_id  in number default null,
    p_list_template_id    in number default null,
    p_field_template_id   in number default null,
    p_page_template_id    in number default null,
    p_bc_template_id      in number default null,
    p_report_template_id  in number default null,
    p_old_css_classes     in varchar2,
    p_new_css_classes     in varchar2
);

procedure copy_theme_template_options (
    p_from_flow_id      number,
    p_to_flow_id        number,
    p_from_theme_id     number,
    p_to_theme_id       number
);

procedure copy_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

procedure copy_plug (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

procedure copy_row_template (
    p_copy_from_flow_id    in number,
    p_to_flow_id           in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);
    
procedure copy_list_template (
    p_copy_from_flow_id    in number,
    p_to_flow_id           in number,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);
  
procedure copy_field_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);    

procedure copy_menu_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,    
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

procedure copy_button_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

procedure copy_calendar_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

procedure copy_popup_template (
    p_copy_from_flow_id    in number,
    p_flow_id              in varchar2,
    p_from_template_id     in number,
    p_to_theme_id          in number default null,
    p_to_template_name     in varchar2 default null,
    p_to_internal_name     in varchar2 default null,
    p_to_template_id       in number default null,
    p_show_errors          in boolean default true,
    p_include_subscription in boolean default true
);

--------------------------------------------------------------------
-- utility functions for backward compatability and upgrade services
--

procedure set_page_template_names_2_ids (
    p_flow_id               in number,
    p_page_id               in number)
    ;

procedure set_page_region_names_2_ids (
    p_flow_id               in number,
    p_page_id               in number)
    ;

procedure replace_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_region_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_report_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_list_template (
    p_from_flow_id       in number,
    p_to_flow_id         in number,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_field_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_menu_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_popup_lov_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_button_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure replace_calendar_template (
    p_from_flow_id       in number,
    p_to_flow_id         in varchar2,
    p_from_template_id   in number,
    p_to_template_id     in number)
    ;

procedure page_template_popup_preview (
    p_flow               in number,
    p_template           in varchar2 default null,
    p_template_id        in number default null,
    p_passback           in varchar2 default null)
    ;

procedure list_template_sub_str (
    p_list_template_id in number default null)
    ;

procedure breadcrumb_template_sub_str (
    p_template_id   in number default null)
    ;
    
procedure label_template_sub_str (
    p_template_id in number default null)
    ;
    
procedure button_template_sub_str (
    p_template_id in number default null)
    ;
    
procedure page_template_utilization (
    p_flow_id      in number default null,
    p_template_id  in number default null)
    ;    

function breadcrumb_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number;

function button_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number;

function label_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number;

function calendar_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number;

function list_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number;

function page_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
    ) return number; 

function region_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
) return number;

function report_template_ref_count (
    p_flow_id      in number default null,
    p_template_id  in number default null
) return number;

procedure remove_ununsed_templates (
    p_flow_id in number,
    p_theme_id in number
);

end wwv_flow_templates_util;
/
show errors
