set define '^' verify off
prompt ...wwv_flow_export_api.sql
create or replace package wwv_flow_export_api authid current_user as
--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
-- NAME
--   wwv_flow_export_api.sql - APEX_EXPORT
--
-- DESCRIPTION
--   This package provides APIs to export the definitions of applications,
--   files, feedback and workspaces to text files.
--
--   APEX_EXPORT uses utility types APEX_T_EXPORT_FILE and APEX_T_EXPORT_FILES.
--   The former is a tuple of (name, contents) where name is the file name and
--   contents is a clob containing the export object's definition.
--   APEX_T_EXPORT_FILES is a table of APEX_T_EXPORT_FILE.
--
-- RUNTIME DEPLOYMENT: YES
-- PUBLIC:             YES
--
-- MODIFIED   (MM/DD/YYYY)
--   cneumuel  09/28/2017 - Created (feature #2224)
--   cneumuel  11/27/2017 - In get_workspace_files: doc changes
--   cneumuel  02/06/2018 - In get_application: added p_with_acl_assignments
--
--------------------------------------------------------------------------------

--==============================================================================
-- Export the given application. Optionally, split the application definition
-- into multiple files. The optional p_with_% parameters can be used to include
-- additional information in the export.
--
-- PARAMETERS
--   * p_application_id: The application id.
--   * p_split: If true, split the definition into discrete elements that can be
--     stored in separate files. If false, the result is a single file.
--   * p_with_date: If true, include export date and time in the result.
--   * p_with_public_reports: If true, include public reports that a user saved.
--   * p_with_private_reports: If true, include private reports that a user
--     saved.
--   * p_with_notifications: If true, include report notifications.
--   * p_with_translations: If true, include application translation mappings
--     and all text from the translation repository.
--   * p_with_pkg_app_mapping: If true, export installed packaged applications
--     with references to the packaged application definition. If false, export
--     them as normal applications.
--   * p_with_original_ids: If true, export with the IDs as they were when the
--     application was imported.
--   * p_with_no_subscriptions: If true, components contain subscription
--     references.
--   * p_with_comments: If true, include developer comments.
--   * p_with_supporting_objects: If 'Y', export supporting objects. If 'I',
--     automatically install on import. If 'N', do not export supporting
--     objects. If null, the application's Include in Export deployment value is
--     used.
--   * p_with_acl_assignments: If true, export ACL user role assignments.
--
-- RETURNS
--   A table of apex_t_export_file. Unless the caller passes p_split=>true to
--   the function, the result will be a single file.
--
-- EXAMPLE
--   This sqlplus code fragment spools the definition of application 100 into
--   file f100.sql.
--
--     variable name     varchar2(255)
--     variable contents clob
--     declare
--         l_files apex_t_export_files;
--     begin
--         l_files   := apex_export.get_application(p_application_id => 100);
--         :name     := l_files(1).name;
--         :contents := l_files(1).contents;
--     end;
--     /
--     set feed off echo off head off flush off termout off trimspool on
--     set long 100000000 longchunksize 32767
--     col name new_val name
--     select :name name from sys.dual;
--     spool &name.
--     print contents
--     spool off
--==============================================================================
function get_application (
    p_application_id          in number,
    p_split                   in boolean  default false,
    p_with_date               in boolean  default false,
    p_with_ir_public_reports  in boolean  default false,
    p_with_ir_private_reports in boolean  default false,
    p_with_ir_notifications   in boolean  default false,
    p_with_translations       in boolean  default false,
    p_with_pkg_app_mapping    in boolean  default false,
    p_with_original_ids       in boolean  default false,
    p_with_no_subscriptions   in boolean  default false,
    p_with_comments           in boolean  default false,
    p_with_supporting_objects in varchar2 default null,
    p_with_acl_assignments    in boolean  default false )
    return wwv_flow_t_export_files;

--==============================================================================
-- Export the given workspace's static files.
--
-- PARAMETERS
--   * p_workspace_id: The workspace id.
--   * p_with_date: If true, include export date and time in the result.
--
-- RETURNS
--   A table of apex_t_export_file. The result is a single file, splitting
--   into multiple files will be implemented in a future release.
--
-- EXAMPLE
--   Export the workspace files of the workspace with id 12345678.
--
--     declare
--         l_file apex_t_export_files;
--     begin
--         l_file := apex_export.get_workspace_files (
--                       p_workspace_id => 12345678 );
--     end;
--==============================================================================
function get_workspace_files (
    p_workspace_id in number,
    p_with_date    in boolean default false )
    return wwv_flow_t_export_files;

--==============================================================================
-- Export user feedback to the development environment or developer feedback to
-- the deployment environment.
--
-- PARAMETERS
--   * p_workspace_id: The workspace id.
--   * p_with_date: If true, include export date and time in the result.
--   * p_since: If set, only export feedback that has been gathered since the
--     given date.
--   * p_deployment_system: If null, export user feedback. If not null, export
--     developer feedback for the given deployment system.
--
-- RETURNS
--   A table of apex_t_export_file.
--
-- EXAMPLE
--   Export feedback to development environment.
--
--     declare
--         l_file apex_t_export_files;
--     begin
--         l_file := apex_export.get_feedback(p_workspace_id => 12345678);
--     end;
--
--   Export developer feedback in workspace 12345678 since 8-MAR-2010 to
--   deployment environment EA2.
--
--     declare
--         l_file apex_t_export_files;
--     begin
--         l_file := apex_export.get_feedback (
--                       p_workspace_id      => 12345678,
--                       p_since             => date'2010-03-08',
--                       p_deployment_system => 'EA2' );
--     end;
--==============================================================================
function get_feedback (
    p_workspace_id      in number,
    p_with_date         in boolean  default false,
    p_since             in date     default null,
    p_deployment_system in varchar2 default null )
    return wwv_flow_t_export_files;

--==============================================================================
-- Export the given workspace's definition and users. The optional p_with_%
-- parameters which all default to false can be used to include additional
-- information in the export.
--
-- PARAMETERS
--   * p_workspace_id: The workspace id.
--   * p_with_date: If true, include export date and time in the result.
--   * p_with_team_development: If true, include team development data.
--   * p_with_misc: If true, include data from SQL Workshop, mail logs, etc. in
--     the export.
--
-- RETURNS
--   A table of apex_t_export_file.
--
-- EXAMPLE
--   Export the definition of workspace #12345678.
--
--     declare
--         l_files apex_t_export_files;
--     begin
--         l_files := apex_export.get_workspace(p_workspace_id => 12345678);
--     end;
--==============================================================================
function get_workspace (
    p_workspace_id          in number,
    p_with_date             in boolean default false,
    p_with_team_development in boolean default false,
    p_with_misc             in boolean default false )
    return wwv_flow_t_export_files;

end wwv_flow_export_api;
/
show err
