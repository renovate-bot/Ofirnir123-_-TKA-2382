Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefpt.sql /main/9 2018/08/08 15:49:34 nspancha Exp $
Rem
Rem drdefpt.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefpt.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Portuguese
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    05/28/18 - Bug 27084954: Safe Schema Loading
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    surman      06/10/05 - 4003390: Change comments 
Rem    surman      12/08/04 - 4003390: Remove dependency on NLS_LANG 
Rem    druthven    01/09/02 - 
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
end;
/

PROMPT  Creating wordlist preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'SPANISH');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'SPANISH');
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
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','a');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','abaixo');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','adiante');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','agora');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ali');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','antes');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aqui');
  add_utf8_stopword('6174C3A9'); /* até   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','atras');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bastante');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','com');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','como');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','contra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','debaixo');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','demais');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','depois');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','depressa');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','devagar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','direito');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','e');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ela');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','elas');
  add_utf8_stopword('C3AA6C65'); /* êle   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eles');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','em');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','entre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eu');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','fora');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','junto');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','longe');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mais');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','menos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','muito');
  add_utf8_stopword('6EC3A36F'); /* não   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ninguem');
  add_utf8_stopword('6EC3B373'); /* nós   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nunca');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','onde');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ou');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','para');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','por');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','porque');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','pouco');
  add_utf8_stopword('7072C3B378696D6F'); /* próximo   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','qual');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','quando');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','quanto');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','que');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','quem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','se');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sempre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sim');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sob');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sobre');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','talvez');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','todas');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','todos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vagarosamente');
  add_utf8_stopword('766F63C3AA'); /* você   */
  add_utf8_stopword('766F63C3AA73'); /* vocês   */
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
