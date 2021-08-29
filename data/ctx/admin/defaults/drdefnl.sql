Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/drdefnl.sql /main/6 2018/08/08 15:49:33 nspancha Exp $
Rem
Rem drdefnl.sql
Rem
Rem Copyright (c) 1998, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drdefnl.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      default preference for Dutch
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
Rem    ehuang      09/04/98 - language-specific defaults
Rem    ehuang      09/04/98 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

PROMPT  Creating lexer preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_LEXER','BASIC_LEXER');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_LEXER','COMPOSITE', 'DUTCH');
end;
/

PROMPT  Creating wordlist preference...

begin
  CTX_DDL.create_preference('CTXSYS.DEFAULT_WORDLIST','BASIC_WORDLIST');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','STEMMER', 'DUTCH');
  CTX_DDL.set_attribute('CTXSYS.DEFAULT_WORDLIST','FUZZY_MATCH', 'DUTCH');
end;
/

PROMPT  Creating stoplist...
  
begin
  ctx_ddl.create_stoplist('CTXSYS.DEFAULT_STOPLIST');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aangaande');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aangezien');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','achter');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','achterna');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','afgelopen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','al');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aldaar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','aldus');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alhoewel');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alias');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alle');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','allebei');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alleen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','alsnog');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','altijd');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','altoos');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ander');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','andere');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','anders');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','anderszins');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','behalve');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','behoudens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','beide');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','beiden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ben');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','beneden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bent');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bepaald');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','betreffende');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','binnen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','binnenin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','boven');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bovenal');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bovendien');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bovengenoemd');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bovenstaand');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','bovenvermeld');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','buiten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarheen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarin');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarna');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarnet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarop');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','daarvanlangs');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','de');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','die');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dikwijls');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dit');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','door');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','doorgaand');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','dus');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','echter');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eerdat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eerder');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eerlang');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eerst');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','elk');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','elke');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','en');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','enig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','enigszins');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','enkel');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','er');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','erdoor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','even');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','eveneens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','evenwel');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gauw');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gedurende');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','geen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gehad');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gekund');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','geleden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gelijk');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gemoeten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gemogen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','geweest');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gewoon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','gewoonweg');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','haar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','had');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hadden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hare');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','heb');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hebben');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hebt');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','heeft');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hem');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','het');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hierbeneden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hierboven');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hoe');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hoewel');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hun');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','hunne');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ik');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ikzelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','in');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','inmiddels');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','inzake');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','is');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jezelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jijzelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jou');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jouw');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jouwe');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','juist');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','jullie');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','klaar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','konden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','krachtens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunnen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','kunt');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','later');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','liever');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','maar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mag');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','meer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','met');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mezelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mijn');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mijnent');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mijner');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mijzelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','misschien');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mocht');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mochten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','moest');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','moesten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','moet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','moeten');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','mogen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','na');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','naar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nadat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','net');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','niet');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','noch');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nog');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nogal');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','nu');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','of');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ofschoon');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','om');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omdat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omhoog');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omlaag');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omstreeks');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omtrent');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','omver');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','onder');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ondertussen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ongeveer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ons');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','onszelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','onze');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ook');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','op');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','opnieuw');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','opzij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','over');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','overeind');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','overigens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','pas');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','precies');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','reeds');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','rond');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','rondom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sedert');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sinds');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sindsdien');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','slechts');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','sommige');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','spoedig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','steeds');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tamelijk');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tenzij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','terwijl');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','thans');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tijdens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','toch');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','toen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','toenmaals');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','toenmalig');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tot');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','totdat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','tussen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','uit');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','uitgezonderd');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vaak');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','van');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vandaan');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vanuit');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vanwege');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','veeleer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','verder');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vervolgens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vol');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','volgens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voor');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vooraf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vooral');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vooralsnog');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voorbij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voordat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voordezen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voordien');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voorheen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','voorop');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vooruit');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vrij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','vroeg');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','waar');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','waarom');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wanneer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','want');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','waren');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','was');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','weer');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','weg');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wegens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wel');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','weldra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','welk');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','welke');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wie');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wiens');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wier');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','wijzelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zal');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','ze');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zelfs');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zichzelf');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zij');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zijn');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zijne');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zo');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zodra');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zonder');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zou');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zouden');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zowat');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zulke');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zullen');
  ctx_ddl.add_stopword('CTXSYS.DEFAULT_STOPLIST','zult');
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
