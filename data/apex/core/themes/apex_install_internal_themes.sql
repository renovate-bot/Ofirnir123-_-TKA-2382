Rem  Copyright (c) Oracle Corporation 2012 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      apex_install_internal_themes.sql
Rem
Rem    DESCRIPTION
Rem      Install internal themes into theme repository (SGID=12)
Rem
Rem    MODIFIED     (MM/DD/YYYY)
Rem    jkallman      03/26/2012 - Created
Rem    msewtz        03/27/2012 - Added theme 25
Rem    vuvarov       05/05/2012 - Call set_workspace_id() first to satisfy check for reserved App ID ranges.
Rem    msewtz        03/27/2012 - Added themes 1-11 and 13-24
Rem    jkallman      06/01/2012 - Clear out globals at end of script
Rem    msewtz        06/19/2012 - Added theme 25
Rem    msewtz        07/23/2012 - Added theme 12
Rem    shrahman      08/17/2012 - Added theme 26
Rem    msewtz        08/28/2013 - Added theme 31
Rem    jstraub       10/21/2013 - Changed SGID 11 references to 12
Rem    msewtz        11/13/2013 - Added themes 51 and 42
Rem    msewtz        01/07/2014 - Removed theme 30
Rem    msewtz        06/02/2014 - Replace theme 31 with 42
Rem    msewtz        10/24/2014 - Added THEME_OFFSET to ensure themes always get installed with the same template and theme IDs
Rem    cneumuel      10/28/2014 - Set define '^' before installing each theme file, because the themese set define to "on"
Rem    msewtz        01/25/2017 - Removed install of themes 1-26 and 50 (feature 2104)


define THEME_OFFSET = 1447581811918206904;

prompt Application Express internal themes

prompt
prompt ...Installing Theme 42
prompt
set feedback off define '^' verify off
begin
    wwv_flow_application_install.set_workspace_id(12);
    wwv_flow_api.set_security_group_id(12);
    wwv_flow_application_install.set_application_id(8842);
    wwv_flow_application_install.set_offset(^THEME_OFFSET);
    wwv_flow_application_install.set_schema(wwv_flow.g_flow_schema_owner);
end;
/
@@theme_42.sql

prompt
prompt ...Installing Theme 51
prompt
set feedback off define '^' verify off
begin
    wwv_flow_application_install.set_workspace_id(12);
    wwv_flow_api.set_security_group_id(12);
    wwv_flow_application_install.set_application_id(8851);
    wwv_flow_application_install.set_offset(^THEME_OFFSET);
    wwv_flow_application_install.set_schema(wwv_flow.g_flow_schema_owner);
end;
/
@@theme_51.sql

begin
    update wwv_flows
       set application_type = 'THEME'
     where security_group_id = 12
       and id between 8800 and 8900;
    commit;
end;
/
--
--  Clear out application globals, so this avoids any downstream effect
begin
    wwv_flow_application_install.clear_all;
end;
/

set feedback on define '^' verify off
prompt
prompt ...done
