Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefsf.sql /main/10 2018/08/08 15:49:34 nspancha Exp $
Rem
Rem drdefsf.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefsf.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Finnish
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
Rem    ehuang      09/04/98 - language-specific defaults
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT  Creating lexer preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','BASIC_LEXER');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_LEXER','ALTERNATE_SPELLING', 'SWEDISH');
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
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ah');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ai');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aina');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alla');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alle');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ansiosta');
  add_utf8_stopword('6564657373C3A4'); /* edessä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','een');
  add_utf8_stopword('65686BC3A4'); /* ehkä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ei');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eli');
  add_utf8_stopword('656C696B6BC3A4'); /* elikkä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ellei');
  add_utf8_stopword('656C6C656976C3A474'); /* elleivät   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ellemme');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ellen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ellet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ellette');
  add_utf8_stopword('656E656D6DC3A46E'); /* enemmän   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eniten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ennen');
  add_utf8_stopword('6572C3A473'); /* eräs   */
  add_utf8_stopword('657474C3A4'); /* että   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','harva');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','he');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hei');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hitaasti');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hyi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hyvin');
  add_utf8_stopword('68C3A46E'); /* hän   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','iin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ilman');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','itse');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ja');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jahka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jo');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','joka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jokainen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','joku');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jollei');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jolleivat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jollemme');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jollen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jollet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jollette');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','joskin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jotta');
  add_utf8_stopword('6AC3A46C6B65656E'); /* jälkeen   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kaikki');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kanssa');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kaukana');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ken');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','keneksi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kenelle');
  add_utf8_stopword('6B656E6BC3A4C3A46E'); /* kenkään   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kenties');
  add_utf8_stopword('6B65736B656C6CC3A4'); /* keskellä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kesken');
  add_utf8_stopword('6B65746BC3A4'); /* ketkä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kohti');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','koska');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','koskaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ksi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kuin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kuinka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kuka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kukaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kukin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpainen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpainenkaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpainenkin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpikaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kumpikin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kun');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunhan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunnes');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kuten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kylliksi');
  add_utf8_stopword('6B796C6CC3A4'); /* kyllä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','liian');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','lla');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','lle');
  add_utf8_stopword('6C6CC3A4'); /* llä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','lta');
  add_utf8_stopword('6C74C3A4'); /* ltä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','luona');
  add_utf8_stopword('6CC3A468656C6CC3A4'); /* lähellä   */
  add_utf8_stopword('6CC3A47069'); /* läpi   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','me');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mikin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','miksi');
  add_utf8_stopword('6D696BC3A4'); /* mikä   */
  add_utf8_stopword('6D696BC3A46C69'); /* mikäli   */
  add_utf8_stopword('6D696BC3A4C3A46E'); /* mikään   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','milloin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','milloinkaan');
  add_utf8_stopword('6D696EC3A4'); /* minä   */
  add_utf8_stopword('6D697373C3A4'); /* missä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','miten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','molemmat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mutta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','na');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ne');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','niin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nopeasti');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nuo');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nyt');
  add_utf8_stopword('6EC3A4'); /* nä   */
  add_utf8_stopword('6EC3A4696E'); /* näin   */
  add_utf8_stopword('6EC3A46DC3A4'); /* nämä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','oi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olemme');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olette');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','oli');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olimme');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olit');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olitte');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','olivat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ollut');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','on');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','oon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ovat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','paitsi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','paljon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','paremmin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','parhaiten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','pian');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','se');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','seen');
  add_utf8_stopword('73656BC3A4'); /* sekä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sen');
  add_utf8_stopword('7369656C6CC3A4'); /* siellä   */
  add_utf8_stopword('7369656C74C3A4'); /* sieltä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','siin');
  add_utf8_stopword('73696C6CC3A4'); /* sillä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sinne');
  add_utf8_stopword('73696EC3A4'); /* sinä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ssa');
  add_utf8_stopword('7373C3A4'); /* ssä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sta');
  add_utf8_stopword('7374C3A4'); /* stä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','suoraan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ta');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tahi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tai');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','taikka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','takana');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','takia');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tarpeeksi');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','te');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tokko');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tta');
  add_utf8_stopword('7474C3A4'); /* ttä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tuo');
  add_utf8_stopword('74C3A4'); /* tä   */
  add_utf8_stopword('74C3A46864656E'); /* tähden   */
  add_utf8_stopword('74C3A46DC3A4'); /* tämä   */
  add_utf8_stopword('74C3A47373C3A4'); /* tässä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ulkopuolella');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','useammin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','useimmin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','usein');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vaikka');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vailla');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','varten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vastaan');
  add_utf8_stopword('7669656CC3A4'); /* vielä   */
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voi');
  add_utf8_stopword('76C3A468656D6DC3A46E'); /* vähemmän   */
  add_utf8_stopword('76C3A4686974656E'); /* vähiten   */
  add_utf8_stopword('76C3A468C3A46E'); /* vähän   */
  add_utf8_stopword('796D70C3A47269'); /* ympäri   */
  add_utf8_stopword('C3A4C3A46E'); /* ään   */
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
