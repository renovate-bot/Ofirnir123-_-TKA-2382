Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxsys.sql /st_rdbms_19/1 2018/08/29 16:13:58 nspancha Exp $
Rem
Rem ctxsys.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxsys.sql <tablespc> <temptblspc> <LOCK|NOLOCK>
Rem
Rem    DESCRIPTION
Rem      schema creation and granting privileges (schema name CTXSYS,
Rem      grant EXECUTE on dbms_registry, alter user lock account
Rem      expire password
Rem
Rem    NOTES
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxsys.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxsys.sql
Rem      SQL_PHASE: UTILITY
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/20/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    nspancha    03/28/18 - Bug 27084954: Safe Schema Loading
Rem    boxia       01/17/17 - Proj 68638: rm dbms_scheduler privilege to ctxapp
Rem    snetrava    01/09/17 - Moved the file access trigger to ctxtab.sql
Rem    snetrava    01/04/17 - Bug 25266492,25266515 FILE_ACCESS_ROLE security
Rem    boxia       11/19/16 - Bug 25172618: grant create job, manage
Rem                           scheduler to ctxapp
Rem    rodfuent    11/03/16 - Bug 25028151: composite partition for context_v2
Rem    nspancha    06/30/16 - Bug 23501267: Security Bug
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    rkadwe      09/23/15 - Bug 21701234
Rem    rkadwe      09/23/15 - Bug 21701234
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yinlu       05/09/14 - grant select on sys.opqtype
Rem    boxia       12/12/13 - Bug 16989137: grant select on dba_procedures to
Rem                           CTXSYS
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    dalpern     02/15/12 - proj 32719: INHERIT PRIVILEGES privilege
Rem    rpalakod    11/10/11 - add grants on dba_indexes, dba_triggers
Rem    bhristov    10/30/11 - grant set container to ctxsys
Rem    hsarkar     08/12/11 - Bug 12867992: grant inherit any privileges to
Rem                           CTXSYS
Rem    jmadduku    02/23/11 - Proj32507: Grant Unlimited Tablespace with
Rem                           RESOURCE role
Rem    rpalakod    02/08/10 - Bug 9310235
Rem    rpalakod    08/03/09 - autooptimize
Rem    oshiowat    05/13/05 - feature usage tracking 
Rem    yucheng     11/09/04 - grant ctxsys privs on MV table/views 
Rem    gkaminag    08/02/04 - deprecation of connect 
Rem    ekwan       10/03/03 - Bug 3161706: cannot get column type for nested 
Rem    surman      09/04/03 - 3101316: Update duc$ for drop user cascade 
Rem    gkaminag    08/19/03 - grant ctxsys permissions on ctxapp role 
Rem    ekwan       07/01/03 - Bug 2999760: grant dba_tab_cols
Rem    gkaminag    01/07/03 - dba_indextypes
Rem    gkaminag    12/03/02 - make ctxsys a normal user
Rem    ehuang      09/09/02 - grant more sys tables
Rem    gkaminag    08/22/02 - 
Rem    ehuang      07/08/02 - migrate from dr* scripts
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/11/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

define pass   = "&1"
define tbs    = "&2"
define ttbs   = "&3"
define dolock = "&4"

prompt ...creating user CTXSYS

@@ctxsys_user.sql &tbs &ttbs
show errors

prompt ...granting privileges to user CTXSYS

@@ctxsys_schema.sql
show errors

@?/rdbms/admin/sqlsessend.sql
