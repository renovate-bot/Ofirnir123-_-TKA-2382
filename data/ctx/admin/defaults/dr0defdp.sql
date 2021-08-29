Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/dr0defdp.sql /main/3 2018/08/08 15:49:32 nspancha Exp $
Rem
Rem dr0defdp.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0defdp.sql
Rem
Rem    DESCRIPTION
Rem      drop default preferences.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha   03/18/18 - Bug 27084954: Safe Schema Loading
Rem    gkaminag   03/27/02 - gkaminag_bug-2283146
Rem    ehuang     03/27/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

PROMPT dropping default lexer preference...

alter session set CURRENT_SCHEMA=CTXSYS;

begin
  CTX_DDL.drop_preference('CTXSYS.DEFAULT_LEXER');
end;
/

PROMPT dropping default wordlist preference...

begin
  CTX_DDL.drop_preference('CTXSYS.DEFAULT_WORDLIST');
end;
/

PROMPT dropping default stoplist preference...

begin
  CTX_DDL.drop_stoplist('CTXSYS.DEFAULT_STOPLIST'); 
end;
/

PROMPT dropping default policy...

begin
  CTX_DDL.drop_policy('CTXSYS.DEFAULT_POLICY_ORACONTAINS'); 
end;
/
@?/rdbms/admin/sqlsessend.sql
