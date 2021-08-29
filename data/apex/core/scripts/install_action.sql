set define '^' verify off
--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
-- NAME
--   install_action.sql
--
-- DESCRIPTION
--   Utility script to log an install action
--
-- RUNTIME DEPLOYMENT: NO
-- PUBLIC:             NO
--
-- MODIFIED   (MM/DD/YYYY)
--   cneumuel  06/26/2018 - Created
--
--------------------------------------------------------------------------------

prompt
timing stop
prompt #
prompt # ^1
prompt #
timing start "^1"
exec ^APPUN..wwv_install_api.action('^1')
