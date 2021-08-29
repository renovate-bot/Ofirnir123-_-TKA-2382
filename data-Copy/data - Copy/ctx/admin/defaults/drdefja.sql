Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefja.sql /main/7 2018/08/08 15:49:33 nspancha Exp $
Rem
Rem drdefja.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefja.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Japanese
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    05/28/18 - Bug 27084954: Safe Schema Loading
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gkaminag    11/20/01 - policy name to default_policy_oracontains
Rem    gkaminag    10/23/01 - default policy
Rem    ehuang      04/12/01 - add description
Rem    mfaisal     10/05/98 - change default stemmer to NULL
Rem    ehuang      09/04/98 - language-specific defaults
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT Creating lexer preference...
begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','JAPANESE_VGRAM_LEXER');
end;
/

PROMPT Creating wordlist preference...
begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST'); 
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'NULL');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'JAPANESE_VGRAM');
end;
/

PROMPT Creating stoplist...
begin
  CTX_DDL.create_stoplist('CTXSYS.DEFAULT_STOPLIST');
end;
/

PROMPT Creating default policy...
begin
  CTX_DDL.create_policy('CTXSYS.DEFAULT_POLICY_ORACONTAINS',
    filter        => 'CTXSYS.NULL_FILTER',
    section_group => 'CTXSYS.NULL_SECTION_GROUP',
    lexer         => 'CTXSYS.DEFAULT_LEXER',
    stoplist      => 'CTXSYS.DEFAULT_STOPLIST',
    wordlist      => 'CTXSYS.DEFAULT_WORDLIST'
);
end;
/

@?/rdbms/admin/sqlsessend.sql
