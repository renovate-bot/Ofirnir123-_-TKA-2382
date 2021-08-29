set define '^' verify off
prompt ...apxsdorm.sql
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2017. All Rights Reserved.
--
--    NAME
--      apxsdorm.sql
--
--    REQUIREMENTS
--      - This script has to be executed as SYS
--      - The spatial extension of Oracle Application Express has to be
--        installed (APEX_SPATIAL)
--
--    SYNOPSIS
--      sqlplus / as sysdba @apxsdorm APEX_nnnnnn
--
--    ARGUMENTS
--      1 .... the APEX schema name
--
--    DESCRIPTION
--      Uninstall script for APEX spatial (SDO) extensions. Use this script to
--      remove APEX_SPATIAL and it's implementation packages, e.g. when you
--      uninstalled Spatial. You have to run the script as SYS, with the APEX
--      schema as single parameter.
--
--    RUNTIME DEPLOYMENT: NO
--    PUBLIC:             NO
--
--    MODIFIED   (MM/DD/YYYY)
--    cneumuel    06/06/2014 - Created
--      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
--    hfarrell    01/31/2017 - Changed APEX_050100 reference to APEX_050200
--    cneumuel    01/17/2018 - Removed hard coded schema reference
--
--------------------------------------------------------------------------------

define APPUN=^1

drop public synonym apex_spatial
/
drop package ^APPUN..wwv_flow_spatial_api
/
drop package ^APPUN..wwv_flow_spatial_int
/
revoke execute on mdsys.sdo_meta from ^APPUN
/
revoke execute on mdsys.mderr from ^APPUN
/
revoke select, insert, delete on mdsys.sdo_geom_metadata_table from ^APPUN
/
