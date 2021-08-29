Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefru.sql /main/9 2018/08/08 15:49:34 nspancha Exp $
Rem
Rem drdefru.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefru.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Russian
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    05/28/18 - Bug 27084954: Safe Schema Loading
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gkaminag    05/18/04 - refresh
Rem    gkaminag    11/20/01 - policy name to default_policy_oracontains
Rem    gkaminag    10/23/01 - default policy
Rem    ehuang      04/12/01 - add description
Rem    kmahesh     03/03/00 - English stopwords in lcase for mixed index
Rem    mfaisal     10/05/98 - change default stemmer to NULL
Rem    ehuang      09/04/98 - language-specific defaults
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT  Creating lexer preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','BASIC_LEXER');
end;
/

PROMPT  Creating wordlist preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'NULL');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'GENERIC');
end;
/

PROMPT  Creating stoplist...

begin
  CTX_DDL.create_stoplist('CTXSYS.DEFAULT_STOPLIST');

  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','a');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','all');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','almost');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','also');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','although');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','an');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','and');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','any');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','are');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','as');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','at');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','be');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','because');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','been');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','both');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','but');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','by');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','can');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','could');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','d');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','did');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','do');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','does');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','either');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','for');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','from');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','had');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','has');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','have');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','having');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','he');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','her');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hers');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','here');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','him');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','his');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','how');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','however');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','i');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','if');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','in');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','into');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','is');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','it');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','its');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','just');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ll');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','me');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','might');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','Mr');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','Mrs');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','Ms');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','my');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','no');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','non');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','not');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','of');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','on');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','one');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','only');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','onto');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','or');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','our');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ours');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','s');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','shall');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','she');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','should');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','since');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','so');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','some');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','still');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','such');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','t');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','than');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','that');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','the');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','their');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','them');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','then');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','there');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','therefore');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','these');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','they');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','this');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','those');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','though');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','through');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','thus');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','to');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','too');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','until');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ve');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','very');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','was');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','we');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','were');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','what');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','when');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','where');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','whether');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','which');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','while');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','who');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','whose');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','why');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','will');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','with');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','would');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','yet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','you');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','your');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','yours');
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
