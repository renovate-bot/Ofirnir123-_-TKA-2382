Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      appins.sql
Rem
Rem    DESCRIPTION
Rem      This is the development installation script for Oracle APEX, but this should never be invoked directly.
Rem      This file should only be invoked by coreins.sql or apxdvins.sql.
Rem
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 11.1.0.7 or later
Rem
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   07/24/2012 - Created
Rem      jstraub   08/22/2012 - Aligned timing start/stops
Rem      pawolf    12/13/2012 - Removed setting of image prefix for internal apps (bug #15969515)
Rem      cneumuel  12/20/2012 - set define to '^' before executing verification_images_load.sql (bug #15969515)
Rem      pawolf    01/15/2014 - Always set Builder authentication to APEX accounts
Rem      cneumuel  01/15/2014 - Moved install of apex_install_pe_data.sql from coreins.sql to appins.sql
Rem                           - Moved compile schema and create synonyms to the top
Rem      jkallman  01/27/2014 - Added f4750.sql
Rem      cneumuel  02/03/2014 - Use wwv_flow_authentication_dev.reset_internal_authentication to reset authentication
Rem      vuvarov   02/26/2014 - Install packaged application metadata before application files (feature #1380)
Rem      vuvarov   03/03/2014 - Renamed wwv_flow_pkg_app_tab_load.sql to packaged_apps/metadata.sql
Rem      pawolf    05/08/2014 - Added calls for apex_install_dictionary_view_data and apex_install_advisor_data.sql
Rem      pawolf    05/13/2014 - Moved apex_install_pe_data.sql to coreins.sql
Rem      jkallman  06/10/2014 - Removed f4600
Rem      jstraub   12/01/2015 - Moved wwv_flow_upgrade.[drop|create|grant]_public_synonyms to coreins3.sql (bug 22105151)
Rem      hfarrell  08/22/2017 - Integrate f4020 for Create Blueprint App wizard (5.2 feature #2198)
Rem      cneumuel  07/05/2018 - Improve logging for zero downtime (feature #2355)

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4000"
@^PREFIX.builder/f4000.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4020"
@^PREFIX.builder/f4020.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4350"
@^PREFIX.builder/f4350.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4050"
@^PREFIX.builder/f4050.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4550"
@^PREFIX.builder/f4550.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4700"
@^PREFIX.builder/f4700.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4750"
@^PREFIX.builder/f4750.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4500"
@^PREFIX.builder/f4500.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4300"
@^PREFIX.builder/f4300.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4400"
@^PREFIX.builder/f4400.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4900"
@^PREFIX.builder/f4900.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4800"
@^PREFIX.builder/f4800.sql
set define '^'

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing 4850"
@^PREFIX.builder/f4850.sql
set define '^' feedback off

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Resetting Internal Authentication"

begin
    wwv_flow_authentication_dev.reset_internal_authentication;
    commit;
end;
/

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Dictionary View Metadata"
@^PREFIX.core/apex_install_dictionary_view_data.sql

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Advisor Metadata"
@^PREFIX.core/apex_install_advisor_data.sql

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Verification Images"
@^PREFIX.core/verification_images_load.sql

--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Packaged Apps Metadata"
@^PREFIX.core/packaged_apps/metadata.sql
set define '^'
--==============================================================================
@^PREFIX.core/scripts/install_action.sql "Installing Packaged Apps"
@^PREFIX.core/packaged_apps/install_packaged_apps.sql
set define '^'
