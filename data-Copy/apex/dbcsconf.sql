Rem  Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      dbcsconf.sql
Rem
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem      Assumes the SYS user is connected.
Rem
Rem    REQUIREMENTS
Rem      - Oracle Database 11.2.0.4 or later
Rem
Rem    Arguments:
Rem     Position 1: DBCS password
Rem     Position 2: Virtual directory for APEX images
Rem
Rem    Example:
Rem
Rem    1)Local
Rem      sqlplus "sys/syspass as sysdba" @dbcsconf Passw0rd! /i/
Rem
Rem    2)With connect string
Rem      sqlplus "sys/syspass@10g as sysdba" @dbcsconf Passw0rd! /i/
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jstraub   04/02/2018 - Created
Rem      cneumuel  07/11/2018 - Added prefix parameter to apex_rest_config_core.sql (bug #28315666)

set define '^'
set concat on
set concat .
set verify off


define OPC_PASSWORD      = '^1'
define IMGPRE            = '^2'

define PREFIX            = '@'


@^PREFIX.core/scripts/set_appun.sql
@^PREFIX.core/scripts/apxpreins.sql
@^PREFIX.core/scripts/set_ufrom_and_upgrade.sql

set define '^'

Rem from dbtools_apex_schema_passwords_reset.sql

ALTER USER APEX_PUBLIC_USER IDENTIFIED BY "^^OPC_PASSWORD" ACCOUNT UNLOCK;
ALTER USER APEX_REST_PUBLIC_USER IDENTIFIED BY "^^OPC_PASSWORD" ACCOUNT UNLOCK;
ALTER USER APEX_LISTENER IDENTIFIED BY "^^OPC_PASSWORD" ACCOUNT UNLOCK;

Rem from dbtools_apxchpwd.sql

alter session set current_schema = ^APPUN;

col user_id       noprint new_value M_USER_ID
col email_address noprint new_value M_EMAIL_ADDRESS
set termout off
select rtrim(min(user_id))       user_id,
       nvl (
           rtrim(min(email_address)),
           'ADMIN' )        email_address
  from wwv_flow_fnd_user
 where security_group_id = 10
   and user_name         = upper('ADMIN')
/

declare
    c_user_id  constant number         := to_number( '^M_USER_ID.' );
    c_username constant varchar2(4000) := 'ADMIN';
    c_email    constant varchar2(4000) := 'dummy@foo.com';
    c_password constant varchar2(4000) := '^OPC_PASSWORD';
    c_old_sgid constant number := wwv_flow_security.g_security_group_id;
    c_old_user constant varchar2(255) := wwv_flow_security.g_user;

    procedure cleanup
    is
    begin
        wwv_flow_security.g_security_group_id := c_old_sgid;
        wwv_flow_security.g_user              := c_old_user;
    end cleanup;
begin
    wwv_flow_security.g_security_group_id := 10;
    wwv_flow_security.g_user              := c_username;

    wwv_flow_fnd_user_int.create_or_update_user( p_user_id  => c_user_id,
                                                 p_username => c_username,
                                                 p_email    => c_email,
                                                 p_password => c_password );
    commit;
    cleanup();
exception
    when others then
        cleanup();
        raise;
end;
/

Rem from dbtools_apex_access_list_config.sql

DECLARE
    ACL_PATH  VARCHAR2(4000);
    APEX_USER VARCHAR2(200);
BEGIN
    BEGIN
        SELECT
            SCHEMA
        INTO
            APEX_USER
        FROM
            DBA_REGISTRY
        WHERE
            COMP_ID = 'APEX';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            APEX_USER := NULL;
    END;

    IF APEX_USER IS NOT NULL THEN
        -- Look for the ACL currently assigned to '*' and give the APEX user "connect" privilege if it does not have the privilege yet
        SELECT
            ACL
        INTO
            ACL_PATH
        FROM
            DBA_NETWORK_ACLS
        WHERE
            HOST = '*' AND
            LOWER_PORT IS NULL AND
            UPPER_PORT IS NULL;

        IF DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE(
            ACL_PATH,
            APEX_USER,
            'connect'
        ) IS NULL THEN
            DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
                ACL_PATH,
                APEX_USER,
                TRUE,
                'connect'
            );
        END IF;
    END IF;
EXCEPTION
    -- When no ACL has been assigned to '*'.
    WHEN NO_DATA_FOUND THEN
        DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
            'power_users.xml',
            'ACL that lets power users to connect to everywhere',
            APEX_USER,
            TRUE,
            'connect'
        );
        DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL('power_users.xml', '*');
END;
/
COMMIT;

Rem from dbtools_apex_password_policy_config.sql

PROMPT Starting APEX Password Policy Configuration

BEGIN
    APEX_INSTANCE_ADMIN.SET_PARAMETER( 'PASSWORD_MIN_LENGTH', 8 );
    APEX_INSTANCE_ADMIN.SET_PARAMETER( 'STRONG_SITE_ADMIN_PASSWORD', 'Y' );
    COMMIT;
END;
/

PROMPT APEX password policy configuration complete

Rem from dbtools_apex_rest_config_cdb.sql
@^PREFIX.apex_rest_config_core.sql ^PREFIX. ^OPC_PASSWORD ^OPC_PASSWORD

set define '^'

prompt
prompt ...Recompiling the Application Express schemas
prompt
begin
    sys.dbms_utility.compile_schema( schema => wwv_flow.g_flow_schema_owner, compile_all => false );
    sys.dbms_utility.compile_schema( schema => 'FLOWS_FILES', compile_all => false );
end;
/

Rem from dbtools_reset_image_prefix_con.sql
@^PREFIX.utilities/reset_image_prefix_core.sql ^IMGPRE x


