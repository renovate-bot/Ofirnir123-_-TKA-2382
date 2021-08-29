--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
-- NAME
--   apxsqler.sql
--
-- DESCRIPTION
--   This script calls
--
--     whenever sqlerror exit sql.sqlcode rollback
--
--   if parameter 1 (INSTALL_TYPE) is MANUAL, RUNTIME or APPCONTAINER.
--   Otherwise, it calls
--
--     whenever sqlerror continue
--
-- ARGUMENTS
--   * 1: INSTALL_TYPE
--
-- MODIFIED  (MM/DD/YYYY)
--   cneumuel 07/02/2018 - Created
--
--------------------------------------------------------------------------------

set define '^' termout off
col apxsqler_arguments new_val apxsqler_arguments
select case
       when '^1' in ( 'MANUAL',
                      'RUNTIME',
                      'APPCONTAINER' )
       then 'exit sql.sqlcode rollback'
       else 'continue'
       end apxsqler_arguments
  from sys.dual
/
set termout on
whenever sqlerror ^apxsqler_arguments
