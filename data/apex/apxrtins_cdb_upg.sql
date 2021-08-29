Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      apxrtins_cdb_upg.sql
Rem
Rem    DESCRIPTION
Rem      This script upgrades Application Express in a multitenant container database.
Rem
Rem    NOTES
Rem      Assumes the SYS user is connected. Must be run locally to the database and the
Rem      ORACLE_HOME environment variable must be set.
Rem
Rem      DO NOT RUN THIS SCRIPT DIRECTLY. It is invoked by apxrtins.sql.
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 12.1.0.1 or later
Rem
Rem    Arguments:
Rem     Position 1: Name of tablespace for Application Express application user
Rem     Position 2: Name of tablespace for Application Express files user
Rem     Position 3: Name of temporary tablespace or tablespace group
Rem     Position 4: Virtual directory for APEX images
Rem
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   09/05/2012 - Created
Rem      jstraub   11/24/2014 - Adapted from apexins_con.sql
Rem      jstraub   02/23/2015 - Modified to call coreins[235].sql directly (bug 20381781)
Rem      jstraub   02/25/2015 - Added calling coreins[67].sql and pass INSTALL_TYPE to coreins.sql and coreins5.sql (bug 20381781)
Rem      jstraub   03/11/2015 - Adapted for upgrade of CDB
Rem      msewtz    07/07/2015 - Changed APEX_050000 references to APEX_050100
Rem      hfarrell  02/05/2016 - Add APEX_050000 to list of schemas to upgrade from
Rem      cneumuel  10/20/2016 - Removed calls to coreins[67], constraints are directly handled in wwv_flow_upgrade again (feature #1723)
Rem      hfarrell  01/05/2017 - Changed APEX_050100 references to APEX_050200; added APEX_050100 to upgrade list
Rem      cneumuel  05/23/2017 - Use gen_adm_pwd.sql (bug #25790200)
Rem      cneumuel  01/16/2018 - Unify calls of utility scripts (core/scripts/*.sql)
Rem      cneumuel  07/11/2018 - Added PREFIX parameter to coreins[24].sql
Rem      cneumuel  08/23/2018 - Call coreins.sql with UFROM parameter and coreins4 with INSTALL_TYPE (bug #28542126)

set define '^'
set concat on
set concat .
set verify off
set termout off
spool off
set termout on

whenever sqlerror exit

column :xe_home new_value OH_HOME NOPRINT
variable xe_home varchar2(255)

set serverout on
begin
-- get oracle_home
    sys.dbms_system.get_env('ORACLE_HOME',:xe_home);
    if length(:xe_home) = 0 then
        sys.dbms_output.put_line(lpad('-',80,'-'));
        raise_application_error (
            -20001,
            'Oracle Home environment variable not set' );
    end if;
end;
/
whenever sqlerror continue

set termout off
select :xe_home from sys.dual;
set termout on

alter session set nls_length_semantics = byte;

define DATTS        = '^1'
define FF_TBLS      = '^2'
define TEMPTBL      = '^3'
define IMGPR        = '^4'

define PREFIX       = '@'
define INSTALL_TYPE = 'RUNTIME'


column foo3 new_val LOG1
select 'install'||to_char(sysdate,'YYYY-MM-DD_HH24-MI-SS')||'.log' as foo3 from sys.dual;

define LOG2 = ^LOG1.english.log
define LOG3 = ^LOG1.english.bad
spool ^LOG1

prompt . ORACLE
prompt .
prompt . Application Express (APEX) Installation.
prompt ..........................................
prompt .

Rem  Check prerequisites. Installation will not continue if prerequisites are not met.
@^PREFIX.core/scripts/set_appun.sql
@^PREFIX.core/scripts/apxprereq.sql ^INSTALL_TYPE ^APPUN ^DATTS ^FF_TBLS ^TEMPTBL 1,2,3
@^PREFIX.core/scripts/set_ufrom_and_upgrade.sql
@^PREFIX.core/scripts/gen_adm_pwd.sql

prompt Performing installation in multitenant container database in the background.
prompt The installation progress is spooled into apexins_cdb*.log files.
prompt
prompt Please wait...
prompt

host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b coreins coreins.sql --p^LOG1 --p^UPGRADE --p^APPUN --p^UFROM --p^TEMPTBL --p^IMGPR --p^DATTS --p^FF_TBLS --p^ADM_PWD --p^PREFIX --p^INSTALL_TYPE

--copy metadata
host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b coreins2 coreins2.sql --p^CDB_ROOT --p^UPGRADE --p^APPUN --p^UFROM ^PREFIX

host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b coreins3 coreins3.sql --p^CDB_ROOT --p^UPGRADE --p^APPUN --p^UFROM --p^INSTALL_TYPE --p^PREFIX --p^ADM_PWD

--enable remaining constraints
host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b coreins4 coreins4.sql --p^CDB_ROOT --p^UPGRADE --p^APPUN --p^UFROM ^PREFIX --p^INSTALL_TYPE

host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b coreins5 coreins5.sql --p^CDB_ROOT --p^UPGRADE --p^APPUN --p^UFROM --p^PREFIX --p^INSTALL_TYPE

host ^OH_HOME/perl/bin/perl -I ^OH_HOME/rdbms/admin ^OH_HOME/rdbms/admin/catcon.pl -b runtime_revoke core/runtime_grant_revoke.sql

spool off

prompt
prompt Installation completed. Log files for each container can be found in:
prompt
prompt apexins_cdb*.log
prompt
prompt You can quickly scan for ORA errors or compilation errors by using a utility
prompt like grep:
prompt
prompt grep ORA- *.log
prompt grep PLS- *.log
prompt
