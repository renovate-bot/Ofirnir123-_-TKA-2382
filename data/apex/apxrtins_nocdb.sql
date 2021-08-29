Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      apxrtins_nocdb.sql
Rem
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem      Assumes the SYS user is connected.
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 10.2.0.3 or later
Rem
Rem
Rem      DO NOT RUN THIS SCRIPT DIRECTLY. It is invoked by apxrtins.sql and apxrtins[123].sql.
Rem
Rem    Arguments:
Rem     Position 1: Name of tablespace for Application Express application user
Rem     Position 2: Name of tablespace for Application Express files user
Rem     Position 3: Name of temporary tablespace or tablespace group
Rem     Position 4: Virtual directory for APEX images
Rem     Position 5: Upgrade phases to run. Comma separated list with values
Rem                 1 ... just install APEX schema and objects
Rem                 2 ... limited access: disable builder in old schema, copy metadata and install new internal apps
Rem                 3 ... no access: copy user and file related objects
Rem
Rem    Example:
Rem
Rem    1)Local
Rem      sqlplus "sys/syspass as sysdba" @apxrtins_nocdb SYSAUX SYSAUX TEMP /i/ 1,2,3
Rem
Rem    2)With connect string
Rem      sqlplus "sys/syspass@10g as sysdba" @apxrtins_nocdb SYSAUX SYSAUX TEMP /i/ 1,2,3
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   07/11/2007 - Created
Rem      jkallman  08/02/2007 - Change FLOWS_030000 references to FLOWS_030100
Rem      jstraub   08/16/2007 - Removed password as positional parameter and made random
Rem      jstraub   09/17/2007 - Updated comments to reflect correct number of arguments and updated example
Rem      jstraub   11/26/2007 - Added runtime_grant_revoke.sql
Rem      jstraub   12/19/2007 - Added logic to exit if not connected as SYSDBA
Rem      jstraub   02/08/2008 - Added alter session set nls_length_semantics = byte
Rem      jkallman  07/08/2008 - Change FLOWS_030100 references to FLOWS_040000
Rem      jkallman  10/02/2008 - Change FLOWS_040000 references to APEX_040000
Rem      jstraub   03/24/2009 - Added spool off, removed from coreins.sql for catupgrd
Rem      jkallman  06/01/2009 - Added DB version check
Rem      jkallman  06/08/2009 - Removed DB version check
Rem      jstraub   07/14/2010 - Added DB version check
Rem      jkallman  11/22/2010 - Change APEX_040000 references to APEX_040100
Rem      jstraub   12/05/2011 - Added checks for tablespace arguments
Rem      pawolf    02/21/2012 - Changed APEX_040100 references to APEX_040200
Rem      jstraub   04/16/2012 - Changed temporary tablespace check to include tablespace groups (bug 13857152)
Rem      jkallman  06/08/2012 - Change NLS_LENGTH_SEMANTICS = CHAR (Feature 770)
Rem      vuvarov   06/26/2012 - Call apxprereq.sql to check installation prerequisites (bug 14211939)
Rem      jstraub   08/14/2012 - Removed exit
Rem      jstraub   08/16/2012 - Made exit conditional
Rem      jkallman  08/16/2012 - Reverted NLS_LENGTH_SEMANTICS = CHAR modifications
Rem      jkallman  11/08/2012 - Avoid multiple bind variables in same block (Bug 12381658)
Rem      jkallman  12/17/2012 - Changed APEX_040200 references to APEX_050000
Rem      arayner   01/17/2013 - Replaced ORACLE ASCII art with plain ORACLE text (bug #14556985)
Rem      jstraub   11/21/2014 - Adapted from apxrtins.sql
Rem      jstraub   02/20/2015 - Modified to call coreins[2345].sql (bug 20381781)
Rem      jstraub   02/25/2015 - Added passing INSTALL_TYPE to coreins.sql and coreins5.sql (bug 20381781)
Rem      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
Rem      hfarrell  02/05/2016 - Add APEX_050000 to list of schemas to upgrade from
Rem      cneumuel  11/28/2016 - Compute UFROM
Rem      cneumuel  11/28/2016 - 3-phase install
Rem      hfarrell  01/05/2017 - Changed APEX_050100 references to APEX_050200; added APEX_050100 to upgrade list
Rem      cneumuel  05/23/2017 - Use gen_adm_pwd.sql (bug #25790200)
Rem      jstraub   08/16/2017 - Removed CDB_ROOT substitution
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem      cneumuel  07/11/2018 - Added PREFIX parameter to coreins[24].sql
Rem      cneumuel  08/23/2018 - Call coreins.sql with UFROM parameter and coreins4 with INSTALL_TYPE (bug #28542126)

alter session set nls_length_semantics = byte;

set define '^'
set concat on
set concat .
set verify off
set termout off
spool off
set termout on

define DATTS        = '^1'
define FF_TBLS      = '^2'
define TEMPTBL      = '^3'
define IMGPR        = '^4'
define PHASES       = '^5'

define PREFIX       = '@'
define DB_VERSION   = '10'
define INSTALL_TYPE = 'RUNTIME'


column foo3 new_val LOG1
select 'installrt'||to_char(sysdate,'YYYY-MM-DD_HH24-MI-SS')||'.log' as foo3 from sys.dual;

define LOG2 = ^LOG1.english.log
define LOG3 = ^LOG1.english.bad
spool ^LOG1

prompt . ORACLE
prompt .
prompt . Application Express Runtime Installation.
prompt ...........................................
prompt .

Rem  Check prerequisites. Installation will not continue if prerequisites are not met.
@^PREFIX.core/scripts/set_appun.sql
@^PREFIX.core/scripts/apxprereq.sql ^INSTALL_TYPE ^APPUN ^DATTS ^FF_TBLS ^TEMPTBL ^PHASES
@^PREFIX.core/scripts/set_ufrom_and_upgrade.sql
@^PREFIX.core/scripts/gen_adm_pwd.sql

timing start "Complete Installation"

column SCRIPT noprint new_value SCRIPT
--==============================================================================
-- phase 1
--==============================================================================
prompt Phase 1 (Installation)
timing start "Phase 1 (Installation)"
set termout off
select case when instr('^PHASES','1') > 0 then 'coreins.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT ^LOG1 ^UPGRADE ^APPUN ^UFROM ^TEMPTBL ^IMGPR ^DATTS ^FF_TBLS ^ADM_PWD ^PREFIX ^INSTALL_TYPE
timing stop
--==============================================================================
-- phase 2
--==============================================================================
prompt Phase 2 (Upgrade)
timing start "Phase 2 (Upgrade)"
set termout off
select case when instr('^PHASES','2') > 0 then 'coreins2.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT NO ^UPGRADE ^APPUN ^UFROM ^PREFIX
set termout off
select case when instr('^PHASES','2') > 0 then 'coreins3.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT NO ^UPGRADE ^APPUN ^UFROM ^INSTALL_TYPE ^PREFIX ^ADM_PWD
set termout off
select case when instr('^PHASES','2') > 0 then 'coreins4.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT NO ^UPGRADE ^APPUN ^UFROM ^PREFIX ^INSTALL_TYPE
timing stop
--==============================================================================
-- phase 3
--==============================================================================
prompt Phase 3 (Switch)
timing start "Phase 3 (Switch)"
set termout off
select case when instr('^PHASES','3') > 0 then 'coreins5.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT NO ^UPGRADE ^APPUN ^UFROM ^PREFIX ^INSTALL_TYPE
set termout off
select case when instr('^PHASES','3') > 0 then 'core/runtime_grant_revoke.sql' else 'core/null1.sql' end SCRIPT from sys.dual;
set termout on
@^PREFIX.^SCRIPT
timing stop

timing stop -- complete installation
spool off

column :SCRIPT_NAME new_value comp_file noprint
variable SCRIPT_NAME varchar2(50)
declare
    l_script_name varchar2(100);
begin
    if ^APPUN..wwv_flow_global.g_12c or :script_name = 'core/null1.sql' then
        l_script_name := 'core/null1.sql';
    else
        l_script_name := 'apxexit.sql';
    end if;
    :script_name := l_script_name;
end;
/

select :script_name from sys.dual;

@^PREFIX.^comp_file
