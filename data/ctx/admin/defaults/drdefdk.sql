Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefdk.sql /main/8 2018/08/08 15:49:32 nspancha Exp $
Rem
Rem drdefdk.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefdk.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Danish
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    05/28/18 - Bug 27084954: Safe Schema Loading
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    surman      06/10/05 - 4003390: Change comments 
Rem    surman      12/08/04 - 4003390: Remove dependency on NLS_LANG 
Rem    gkaminag    11/20/01 - policy name to default_policy_oracontains
Rem    gkaminag    10/23/01 - default policy
Rem    ehuang      04/12/01 - add description
Rem    ehuang      09/04/98 - language-specific defaults
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT  Creating lexer preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','BASIC_LEXER');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_LEXER','ALTERNATE_SPELLING','DANISH');
end;
/

PROMPT  Creating wordlist preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'GERMAN');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'GERMAN');
end;
/

PROMPT  Creating stoplist...

declare
  db_charset VARCHAR2(500);

  procedure add_utf8_stopword(hexstring in VARCHAR2) is
  begin
    CTX_DDL.add_stopword('CTXSYS.DEFAULT_STOPLIST', UTL_RAW.cast_to_varchar2(
      UTL_RAW.convert(HEXTORAW(hexstring), db_charset,
                                           'AMERICAN_AMERICA.UTF8')));
  end add_utf8_stopword;

begin
  SELECT 'AMERICAN_AMERICA.' || value
    INTO db_charset
    FROM v$nls_parameters
    WHERE parameter = 'NLS_CHARACTERSET';

  /* Why the extra spaces around the comments?  If the client character set
   * (as identified by NLS_LANG) is AL32UTF8 (or possibly others as well)
   * then the accented characters in the comments, which are in ISO8859-1,
   * are interpreted as multibyte characters.  Thus up to 3 characters after
   * the accented character are mis-interpreted.  If one of these characters
   * happens to be the end comment marker, then the following line or lines
   * is commented out, which leads to missing stopwords and/or PL/SQL parse
   * errors.  End result - the extra spaces before the end comment markers
   * are necessary to ensure that the marker is processed correctly. 
   */
  ctx_ddl.create_stoplist('CTXSYS.DEFAULT_STOPLIST');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','af');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aldrig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alle');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','altid');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bagved');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','de');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','der');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','du');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','efter');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eller');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','en');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','et');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','endnu');
  add_utf8_stopword('66C3A5'); /* få   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','lidt');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','fjernt');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','for');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','foran');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','fra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gennem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','god');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','han');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','her');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hovfor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hun');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hvad');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hvem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hvor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hvorhen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hvordan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','I');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','De');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','i');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','imod');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ja');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jeg');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','langsom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mange');
  add_utf8_stopword('6DC3A5736B65'); /* måske   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','med');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','meget');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mellem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mere');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mindre');
  add_utf8_stopword('6EC3A572'); /* når   */
  add_utf8_stopword('68766F6EC3A572'); /* hvonår   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nede');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nej');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nu');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','og');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','oppe');
  add_utf8_stopword('70C3A5');  /* på   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','rask');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hurtig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sammen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','temmelig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nok');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','til');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','uden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','udenfor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','under');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ved');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vi');
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
