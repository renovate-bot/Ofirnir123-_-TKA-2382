Rem  Copyright (c) Oracle Corporation 1999 - 2015. All Rights Reserved.
Rem
Rem    NAME
Rem      coreins4.sql
Rem
Rem    DESCRIPTION
Rem      This is a primary installation script for Oracle APEX, but this should never be invoked directly.
Rem      This file should only be invoked by apexins.sql, the primary installation script for APEX.
Rem
Rem    NOTES
Rem      Ensure that all arguments (except image prefix) are entered in UPPERCASE.
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 10.2.0.3 or later
Rem      - PL/SQL Web Toolkit
Rem
Rem    Arguments:
Rem      1 - CDB_ROOT     = CDB installation into root
Rem      2 - UPGRADE      = Upgrade flag (1 = NO, 2 = YES)
Rem      3 - APPUN        = APEX schema name
Rem      4 - UFROM        = The prior APEX schema in an upgrade installation
Rem      5 - PREFIX       = The path to the file
Rem      6 - INSTALL_TYPE = Full development environment or runtime only
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   02/20/2015 - Split from coreins.sql
Rem      jstraub   02/25/2015 - Removed p_cdb_install parameter from call to enable_ws_constraints
Rem      cneumuel  09/13/2016 - Added apex schema suffix to wwv_dbms_sql.
Rem      cneumuel  07/05/2018 - Improve logging for zero downtime (feature #2355)
Rem      cneumuel  07/11/2018 - Added PREFIX parameter
Rem      cneumuel  07/20/2018 - Set serveroutput format to wrapped
Rem      jstraub   08/16/2018 - Added set errorlogging off at end of phase 2 (bug 28488523)
Rem      cneumuel  08/23/2018 - Added INSTALL_TYPE parameter (bug #28542126)

set define '^'
set concat on
set concat .
set verify off
set autocommit off
set serveroutput on size unlimited format wrapped

define CDB_ROOT     = '^1'
define UPGRADE      = '^2'
define APPUN        = '^3'
define UFROM        = '^4'
define PREFIX       = '^5'
define INSTALL_TYPE = '^6'

set errorlogging on table ^APPUN..WWV_INSTALL_ERRORS

--==============================================================================
begin
    if '^UPGRADE' = '2' Then
        ^APPUN..wwv_flow_upgrade.enable_ws_constraints (
            p_to => '^APPUN' );
    end if;
end;
/

--==============================================================================
@^PREFIX.core/scripts/apxsqler.sql ^INSTALL_TYPE
begin
    if ^APPUN..wwv_install_api.get_error_count > 0 then
        ^APPUN..wwv_flow_upgrade.rollback_phase2 (
            p_from => '^UFROM' );
        sys.dbms_output.put_line('Errors found. Drop ^APPUN before re-starting the installation.');
    end if;

    ^APPUN..wwv_install_api.end_phase (
        p_phase => 2 );
end;
/
set errorlogging off

whenever sqlerror continue
timing stop
