Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefs.sql /main/10 2018/08/08 15:49:34 nspancha Exp $
Rem
Rem drdefs.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefs.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Swedish
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    05/28/18 - Bug 27084954: Safe Schema Loading
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    surman      06/10/05 - 4003390: Change comments 
Rem    surman      12/08/04 - 4003390: Remove dependency on NLS_LANG 
Rem    gkaminag    05/18/04 - refresh
Rem    gkaminag    11/20/01 - policy name to default_policy_oracontains
Rem    gkaminag    10/23/01 - default policy
Rem    ehuang      04/12/01 - add description
Rem    mfaisal     10/05/98 - change default stemmer to NULL
Rem    ehuang      09/04/98 -
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT  Creating lexer preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','BASIC_LEXER');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_LEXER','ALTERNATE_SPELLING','SWEDISH');
end;
/

PROMPT  Creating wordlist preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'NULL');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'GENERIC');
end;
/


PROMPT Creating stoplist...
  
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
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ab');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aldrig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','all');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alla');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','allt');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alltid');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','allting');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','andra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','andre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','annan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','annat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','att');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','av');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','avse');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','avsedd');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','avsedda');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','avser');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','avses');
  add_utf8_stopword('C3A46E'); /* än   */
  add_utf8_stopword('C3A46E6E75'); /* ännu   */
  add_utf8_stopword('C3A472'); /* är   */
  add_utf8_stopword('C3A5746572'); /* åter   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bakom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bara');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bredvid');
  add_utf8_stopword('62C3A47374'); /* bäst   */
  add_utf8_stopword('62C3A474747265'); /* bättre   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','de');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','den');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','denna');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','deras');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dess');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dessa');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','det');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','detta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','du');
  add_utf8_stopword('64C3A472'); /* där   */
  add_utf8_stopword('64C3A47266C3B672'); /* därför   */
  add_utf8_stopword('64C3A5'); /* då   */
  add_utf8_stopword('64C3A56C6967'); /* dålig   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','efter');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eftersom');
  add_utf8_stopword('6566746572C3A574'); /* efteråt   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ej');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eller');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','emot');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','en');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','endast');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','er');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','era');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ert');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ett');
  add_utf8_stopword('66617374C3A46E'); /* fastän   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','flest');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','flesta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','fort');
  add_utf8_stopword('6672616D66C3B672'); /* framför   */
  add_utf8_stopword('6672C3A56E'); /* från   */
  add_utf8_stopword('66C3A4727265'); /* färre   */
  add_utf8_stopword('66C3A5'); /* få   */
  add_utf8_stopword('66C3B672'); /* för   */
  add_utf8_stopword('66C3B6727374'); /* först   */
  add_utf8_stopword('66C3B672737461'); /* första   */
  add_utf8_stopword('66C3B672737465'); /* förste   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','genom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','god');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','goda');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gott');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ha');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hade');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','haft');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','han');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hans');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hellre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','henne');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hennes');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','heta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','heter');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hette');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','honom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hur');
  add_utf8_stopword('68C3A472'); /* här   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','i');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','i fall');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ifall');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','in');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','inga');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ingen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ingenting');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','inget');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','innan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','inte');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ja');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jag');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kort');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','korta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunde');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunna');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','lite');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','liten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','litet');
  add_utf8_stopword('6CC3A56E67'); /* lång   */
  add_utf8_stopword('6CC3A56E6761'); /* långa   */
  add_utf8_stopword('6CC3A56E6773616D'); /* långsam   */
  add_utf8_stopword('6CC3A56E6773616D6D61'); /* långsamma   */
  add_utf8_stopword('6CC3A56E6773616D74'); /* långsamt   */
  add_utf8_stopword('6CC3A56E6774'); /* långt'   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','man');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','med');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','medan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mellan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','men');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mera');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mest');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mesta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mindre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','minst');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','minsta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mot');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mycket');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ned');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nej');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ner');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nere');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ni');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nu');
  add_utf8_stopword('6EC3A472'); /* när   */
  add_utf8_stopword('6EC3A47261'); /* nära   */
  add_utf8_stopword('6EC3A5676F6E'); /* någon   */
  add_utf8_stopword('6EC3A5676F6E74696E67'); /* någonting   */
  add_utf8_stopword('6EC3A5676F74'); /* något   */
  add_utf8_stopword('6EC3A5677261'); /* några   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','och');
  add_utf8_stopword('6F636B73C3A5'); /* också   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','om');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','oss');
  add_utf8_stopword('C3B6766572'); /* över   */
  add_utf8_stopword('C3B67665727374'); /* överst   */
  add_utf8_stopword('C3B6766572737461'); /* översta   */
  add_utf8_stopword('C3B6767265'); /* övre   */
  add_utf8_stopword('70C3A5'); /* på   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sist');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sista');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ska');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','skall');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','skulle');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','som');
  add_utf8_stopword('73C3A46761'); /* säga   */
  add_utf8_stopword('73C3A4676572'); /* säger   */
  add_utf8_stopword('73C3A46773'); /* sägs   */
  add_utf8_stopword('73C3A46D7265'); /* sämre   */
  add_utf8_stopword('73C3A46D7374'); /* sämst   */
  add_utf8_stopword('73C3A5'); /* så   */
  add_utf8_stopword('73C3A564616E'); /* sådan   */
  add_utf8_stopword('73C3A564616E61'); /* sådana   */
  add_utf8_stopword('73C3A564616E74'); /* sådant   */
  add_utf8_stopword('73C3A56E'); /* sån   */
  add_utf8_stopword('73C3A56E74'); /* sånt   */
  add_utf8_stopword('73C3A5736F6D'); /* såsom   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','till');
  add_utf8_stopword('74696C6C72C3A4636B6C6967'); /* tillräcklig   */
  add_utf8_stopword('74696C6C72C3A4636B6C696761'); /* tillräckliga   */
  add_utf8_stopword('74696C6C72C3A4636B6C696774'); /* tillräckligt   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tillsammans');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tog');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','trots att');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','under');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','underst');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','undre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','upp');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','uppe');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ut');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','utan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ute');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','utom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vad');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','var');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vara');
  add_utf8_stopword('76617266C3B672'); /* varför   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vart');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vems');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','veta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vid');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vilken');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vill');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ville');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','visste');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vore');
  add_utf8_stopword('76C3A46C'); /* väl   */
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
