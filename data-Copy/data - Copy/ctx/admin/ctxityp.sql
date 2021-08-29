Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxityp.sql /main/5 2017/02/06 21:05:03 stanaya Exp $
Rem
Rem ctxityp.sql
Rem
Rem Copyright (c) 2002, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxityp.sql
Rem
Rem    DESCRIPTION
Rem      create index types
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxityp.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctityp.sql
Rem      SQL_PHASE: CTXITYP
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    ehuang      07/09/02 - 
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/12/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

PROMPT ... creating CONTEXT index type
@@dr0itype.sql

PROMPT ... creating CTXCAT index type
@@dr0itypc.sql

PROMPT ... creating CTXRULE index type
@@dr0itypr.sql

PROMPT ... creating CTXXPATH index type
@@dr0itypx.sql

@?/rdbms/admin/sqlsessend.sql
