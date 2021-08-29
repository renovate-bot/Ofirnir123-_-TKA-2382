Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxsys_user.sql /st_rdbms_19/1 2018/08/29 16:13:58 nspancha Exp $
Rem
Rem ctxsys_user.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      ctxsys_user.sql - Creates CTXSYS user
Rem
Rem    DESCRIPTION
Rem      This script is creates the CTXSYS user, and checks for DV access.
Rem      After this script is run, ctxsys_schema.sql is called for privilege 
Rem      grants to the CTXSYS user.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxsys_user.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/ctxsys_user.sql
Rem    SQL_PHASE:CTXSYS_USER
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/16/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    nspancha    03/28/18 - Bug 27084954: Safe Schema Loading
Rem    nspancha    03/28/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

define tbs     = &1
define ttbs    = &2

declare
  dv_enabled varchar2(6);
  l_priv     number := 1;
begin

SELECT value into dv_enabled
  FROM V$OPTION
  WHERE PARAMETER = 'Oracle Database Vault';

if dv_enabled = 'TRUE' then
    
    l_priv := 0;

    SELECT count(*) into l_priv 
      FROM USER_ROLE_PRIVS 
      where granted_role = 'DV_ACCTMGR';  

end if;

--If data vault enabled, and user does not have account manager role, raise.
if (l_priv = 0) then
  raise_application_error(-20000, 'Oracle Text Error: 
  	CTXSYS user could not be created due to restricted privileges.');
else
  execute immediate 'create user ctxsys
  no authentication default tablespace &tbs temporary tablespace &ttbs';

end if;
end;
/

@?/rdbms/admin/sqlsessend.sql
