Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxdef.sql /st_rdbms_19/1 2018/09/25 14:20:53 ccwei Exp $
Rem $Header: ctx_src_2/src/dr/admin/ctxdef.sql /st_rdbms_19/1 2018/09/25 14:20:53 ccwei Exp $
Rem
Rem ctxdef.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxdef.sql - CTX DEFault objects
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem 
Rem    BEGIN SQL_FILE_METADATA
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxdef.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxdef.sql
Rem      SQL_PHASE: CTXDEF
Rem      SQL_STARTUP_MODE: NORMAL
Rem      SQL_IGNORABLE_ERRORS: NONE
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ccwei       09/07/18 - XbranchMerge ccwei_network_datastore from main
Rem    ccwei       07/11/18 - add network datastore: bug 25604054
Rem    ccwei       03/29/18 - add directory datastore: bug 25795669
Rem    snetrava    01/19/17 - Remove FILE_ACCESS_ROLE from dr$parameter
Rem    rkadwe      10/06/16 - Change default stoplist for JSON
Rem    rkadwe      08/29/16 - XbranchMerge rkadwe_bug-24427155 from
Rem                           st_ctx_12.2.0.1.0
Rem    nspancha    08/02/16 - Updating default lexer and language preferences
Rem    nspancha    04/07/16 - Reverting range_search back as req for JSON types
Rem    nspancha    04/07/16 - 22267587:Fixing range search and timestamp opts
Rem    rkadwe      11/04/15 - Bug 21223752
Rem    rkadwe      10/23/15 - Bug 22086644
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rkadwe      11/17/14 - Simplified Syntax
Rem    shuroy      11/11/14 - Adding DEFAULT_SENT_CLASSIFIER
Rem    rkadwe      08/19/14 - default lexers for json rest/soda
Rem    zliu        02/17/14 - add bson_section_group
Rem    zliu        02/05/14 - change xml_structure_enable to
Rem                           range_search_enable
Rem    rkadwe      01/22/14 - Add default JSON section group
Rem    rkadwe      12/09/13 - Default entity extraction lexer language
Rem    boxia       11/19/13 - sdata_def:add new default secgrp and storage pref 
Rem    rkadwe      04/12/13 - Disable timeout for default entity extraction
Rem                           lexer
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    gauryada    06/07/12 - Bug#14109170
Rem    rkadwe      04/06/12 - Printjoin in DEFAULT_EXTRACT_LEXER
Rem    surman      02/08/12 - 13431201: Add functional_cache_size
Rem    thbaby      06/14/11 - section group attribute table
Rem    ssethuma    12/28/10 - Section specific attribute
Rem    rpalakod    08/05/10 - Bug 9973683
Rem    rpalakod    04/29/10 - Bug 9669751
Rem    rpalakod    08/17/09 - Bug 8809055
Rem    rpalakod    07/17/09 - autooptimize
Rem    rpalakod    12/13/07 - ENT_EXT_DICT_OBJ policy
Rem    rpalakod    10/16/07 - Entity Extraction Engine
Rem    rpalakod    10/16/07 - Entity Extraction Default Lexer
Rem    mfaisal     08/04/04 - keyview html export release 8.0.0 
Rem    surman      09/24/03 - 3152625: Up MAX_INDEX_MEMORY to 1G 
Rem    daliao      01/13/03 - set KMEAN as default clustering
Rem    daliao      10/25/02 - add DEFAULT_CLUSTERING
Rem    gshank      09/30/02 - Remove ext theme api
Rem    ehuang      09/27/02 - remove set statements
Rem    gshank      08/31/02 - Theme lexing
Rem    gshank      08/20/02 - Theme lexing
Rem    ehuang      07/11/02 - ehuang_component_upgrade_020626
Rem    ehuang      07/02/02 - Created - component upgrade
Rem     ehuang     05/21/02 - add mail_filter_config_file parameter.
Rem     gkaminag   06/06/02 - keycomp_ok has moved.
Rem     ehuang     04/20/02 - add mail filter.
Rem     daliao     01/29/02 - add DEFAULT_CLASSIFIER
Rem     gkaminag   02/06/02 - handle key compression not available.
Rem     wclin      10/11/01 -
Rem     wclin      09/26/01 - new objects for xpath index
Rem     ehuang     09/29/01 - uritype indexing.
Rem     gkaminag   09/20/00 - use path section group by default for xmltyp
Rem     gkaminag   07/24/00 - auto_xml_section_group->path_section_group
Rem     salpha     06/26/00 - ctxrule implementation
Rem     ehuang     06/16/00 - add xmltype_datatype
Rem     gkaminag   06/12/00 - add auto_xml_section preference
Rem     gkaminag   04/20/00 - DIRECT_DATASTORE preference
Rem     ehuang     04/11/00 - change in datastore roles
Rem     gkaminag   03/29/00 - better storage defaults
Rem     ehuang     03/08/00 - add new system parameters
Rem     gkaminag   02/22/00 - ctxcat implementation
Rem     gkaminag   10/13/99 - bug 1032894
Rem     gkaminag   04/22/99 - add default auto section group
Rem     ehuang     04/15/99 - add system parameter CTX_DOC_KEY_TYPE
Rem     ehuang     10/21/98 - add function datastore preference
Rem     gkaminag   09/24/98 - add basic lexer preference
Rem     ehuang     09/16/98 - bug 726897
Rem     ehuang     09/14/98 - bug 726898
Rem     ehuang     09/02/98 - default pref change
Rem     jachen     09/04/98 - command out Chinese lexer
Rem     gkaminag   08/11/98 - add system parameter LOG_DIRECTORY
Rem     jachen     07/23/98 - add new Chinese lexer
Rem     ymatsuda   06/19/98 - remove HANZI_INDEXING attribute
Rem     ymatsuda   06/04/98 - remove kanji index mode
Rem     ehuang     06/03/98 - change DEFAULT_EIGINE to DEFAULT_STORAGE
Rem     gkaminag   06/03/98 - default for inso filter
Rem     gkaminag   05/19/98 - system parameters
Rem     gkaminag   05/15/98 - rename default html section group
Rem     gkaminag   05/11/98 - add default html section group
Rem     dyu        04/15/98 - Remove duplicate section group creation
Rem     jliu       04/09/98 - add async_datax
Rem     gkaminag   04/03/98 - no more html filter
Rem     gkaminag   04/02/98 - add default section group
Rem     gkaminag   04/03/98 - no more html filter
Rem     gkaminag   04/02/98 - add default section group
Rem     gkaminag   03/24/98 - soundex
Rem     gkaminag   03/23/98 - preference renaming
Rem     gkaminag   03/18/98 - null values not allowed
Rem     dyu        03/18/98 - Fix merge error
Rem     gkaminag   03/12/98 - object name change
Rem     ehuang     03/10/98 - new pref system change
Rem     ehuang     02/25/98 - stoplist pref change
Rem     jlee       03/08/98 - attributes for korean lexer
Rem     ehuang     02/25/98 - stpolist pref change
Rem     ehuang     01/16/98 - rename datastore name for 8.1
Rem     dyu        01/15/98 - Fix Template name
Rem     gkaminag   12/15/97 - add new data types
Rem     gkaminag   12/08/97 - datastore conversion
Rem     dyu        12/08/97 - remove thai lexer
Rem     cbhavsar   11/19/97 - Adding Portuguese stemmer
Rem     dyu        09/26/97 - Update spanish stopword
Rem     gshank     09/24/97 - Change mised case attribute name
Rem     gshank     09/12/97 - Case sensitivity
Rem     jliu       07/29/97 -  url_ftp merge
Rem     cbhavsar   07/23/97 -  Support for German composites
Rem     gkaminag   07/31/97 -  remove thai lexer
Rem     ehuang     07/24/97 -  Bug 517274
Rem     ikourtid   06/26/97 -  make stat. scoring alg. default
Rem     gshank     07/15/97 -  Fuzzy languages
Rem     gkaminag   07/10/97 -  startjoin should be </
Rem     jliu       07/10/97 -  Remove merge comments
Rem     gkaminag   07/09/97 -  fix diff
Rem     jliu       07/09/97 -  Add FTP_PROXY Preference Attribute
Rem     ehuang     06/26/97 -  add new stop lists preferences
Rem     gkaminag   06/24/97 -  add HTML defaults
Rem     cbhavsar   06/15/97 -  Statistical scoring
Rem     gkaminag   06/11/97 -  add keep_tag attribute to HTML filter
Rem     gkaminag   06/06/97 -  add new master-detail object
Rem     syang      06/06/97 -  startjoin/endjoin support
Rem     kkasemsa   05/15/97 -  Add Thai lexer
Rem     gkaminag   04/17/97 -  add SECTION_GROUP attribute
Rem     gkaminag   04/08/97 -  Forgot engine_nop
Rem     gkaminag   04/04/97 -  use new functions
Rem     ehuang     04/02/97 -  fix typo
Rem     jachen     01/15/97 -  put Chinese lexer behind Theme lexer
Rem     jachen     01/04/97 -  add Chinese lexer
Rem     mfaisal    12/19/96 -  Adding base letter support
Rem     atisdale   12/19/96 -  add defaults to loader objects
Rem     mfaisal    11/11/96 -  Multiple UDF with Autorec
Rem     dyu        11/07/96 -  fix drdfwda for reset_db error
Rem     cbhavsar   10/16/96 -  Theme Lexer
Rem     atisdale   10/02/96 -  typo
Rem     gkaminag   10/01/96 -  add loader objects
Rem     droberts   09/26/96 -  Adding proxy attributes for URL data store
Rem     ehuang     09/17/96 -  add class, object and pref to support CTXLSRV
Rem     bkang      08/08/96 -  add Korean lexer
Rem     droberts   08/15/96 -  Adding URL attributes
Rem     ymatsuda   08/07/96 -  vgram mode
Rem     droberts   08/06/96 -  deleting SERVER, URLPATH attributes
Rem     gkaminag   08/01/96 -  add user-defined filters
Rem     sbedarka   08/01/96 -  fix bug 383489
Rem     ymatsuda   08/01/96 -  big stoplist
Rem     ymatsuda   07/17/96 -  add SQE attributes
Rem     droberts   07/17/96 -  Changing name of url validate procedure
Rem     droberts   07/08/96 -  Added DEFAULT_URL preference, URL tile attribute
Rem     wkeese     04/29/96 -  better stoplist 
Rem     rnori      04/12/96 -  Remove ON_SWITCH attribute from STOPLIST object 
Rem     mbhavsar   03/29/96 -  add validation procedure for ENGINE NOP object 
Rem     ymatsuda   03/27/96 -  HTML code conversion 
Rem     rnori      03/20/96 -  Add Validation Procedures to objects 
Rem     ymatsuda   03/18/96 -  v-gram fuzzy match 
Rem     wkeese     03/14/96 -  add pdf and xvf 
Rem     gshank     02/26/96 -  Change BINARY attribute of datastore preference 
Rem     wkeese     02/21/96 -  fix filter preferences 
Rem     wkeese     02/14/96 -  list of values for attributes 
Rem     wkeese     02/05/96 -  change default OSFILE preference 
Rem     gshank     01/30/96 -  Add stemmer preference 
Rem     wkeese     01/23/96 -  add HTML 
Rem     wkeese     01/11/96 -  lower index_memory until 64K bug fix 
Rem     wkeese     01/11/96 -  put _ in no_soundex 
Rem     wkeese     01/10/96 -  default policy 
Rem     wkeese     01/06/96 -  DR->CTX 
Rem     wkeese     12/09/95 -  stoplist stuff 
Rem     wkeese     12/06/95 -  remove unneeded wordlist parameters 
Rem     ymatsuda   12/05/95 -  add Japanese lexer 
Rem     wkeese     11/30/95 -  remove unneeded preferences 
Rem     wkeese     11/28/95 -  default preferences 
Rem     jxwang     11/02/95 -  keep only one stop list object 
Rem     jxwang     10/31/95 -  Add sequence number to stopwords 
Rem     jxwang     10/18/95 -  Adding stop word preference
Rem     jxwang     10/05/95 -  Adding user defined stop list 
Rem     wkeese     08/04/95 -  add soundex preference 
Rem     wkeese     05/09/95 -  transfer from old environment 
Rem     wkeese     05/07/95 -  pretty up error messages 
Rem     jhyde      05/02/95 -  Add Engine preferences.
Rem     qtran      04/29/95 -  change polname to policy_name
Rem     qtran      04/27/95 -  add a template policies and stoplist settings
Rem     wkeese     04/24/95 -  fix stoplist preferences
Rem     wkeese     04/23/95 -  create/drop index/policy API change
Rem     wkeese     04/22/95 -  create_policy api change
Rem     wkeese     04/22/95 -  comments
Rem     qtran      04/20/95 -  add prefrence attribute for the engine, stopword
Rem     jhyde      04/20/95 -  Add MasterSoft blaster filter.
Rem     wkeese     04/14/95 -  fix osfile attribute
Rem     wkeese     04/11/95 -  datastore
Rem     qtran      03/14/95 -  add object attribute definitions
Rem     qtran      01/04/95 -  merge dr_dict into CTX_DDL
Rem     qtran      12/30/94 -  explicit reserved name for template policy
Rem     qtran      11/18/94 -  No reason specified
Rem     mkremer    11/11/94 -  shorten the preference name
Rem     qtran      11/10/94 -  to add a number of template policies
Rem     qtran      10/14/94 -  Creation

@@?/rdbms/admin/sqlsessstart.sql
set echo on
rem cleanout tables
delete from ctxsys.dr$preference_value;
delete from ctxsys.dr$preference;
delete from ctxsys.dr$stoplist;
delete from ctxsys.dr$stopword;
delete from ctxsys.dr$section;
delete from ctxsys.dr$section_group_attribute;
delete from ctxsys.dr$section_group;
delete from ctxsys.dr$section_attribute;
delete from ctxsys.dr$parameter;
delete from ctxsys.dr$index_set_index;
delete from ctxsys.dr$index_set;
commit;

ALTER SESSION SET CURRENT_SCHEMA = SYS;

REM =====================================================================
PROMPT Create default preference procedure
REM =====================================================================
CREATE OR REPLACE PROCEDURE default_create_preference(prefname IN VARCHAR2,
                                                      preftype IN VARCHAR2)
IS
  cur   NUMBER;
  rc    NUMBER;
  created NUMBER := 1;
  uid     number;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.create_preference(:prefname, :preftype);
              EXCEPTION WHEN OTHERS THEN
                :created := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':prefname', prefname);
  dbms_sql.bind_variable(cur, ':preftype', preftype);
  dbms_sql.bind_variable(cur, ':created', created);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':created', created);
  dbms_sql.close_cursor(cur);

  IF (created = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: ' || UPPER(preftype) || ' '
                                    || UPPER(prefname) || ' not created');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT default_set_attribute
REM =====================================================================
CREATE OR REPLACE PROCEDURE default_set_attribute(prefname IN VARCHAR2,
                                                  attrname IN VARCHAR2,
                                                  attrval  IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  attrset NUMBER := 1;
  uid     NUMBER;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.set_attribute(:prefname, :attrname, :attrval);
              EXCEPTION WHEN OTHERS THEN
                :attrset := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':prefname', prefname);
  dbms_sql.bind_variable(cur, ':attrname', attrname);
  dbms_sql.bind_variable(cur, ':attrval', attrval);
  dbms_sql.bind_variable(cur, ':attrset', attrset);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':attrset', attrset);
  dbms_sql.close_cursor(cur);

  IF (attrset = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: ' || 
                                    ' ATTRIBUTE ' || UPPER(attrname) || 
                                    ' OF PREFERENCE ' || UPPER(prefname) ||
                                    ' not set');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT default_create_sgp
REM =====================================================================
CREATE OR REPLACE PROCEDURE default_create_sgp(sgpname IN VARCHAR2,
                                               sgptype IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  sgpcreated NUMBER := 1;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.create_section_group(:sgpname, :sgptype);
              EXCEPTION WHEN OTHERS THEN
                :sgpcreated := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':sgpname', sgpname);
  dbms_sql.bind_variable(cur, ':sgptype', sgptype);
  dbms_sql.bind_variable(cur, ':sgpcreated', sgpcreated);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':sgpcreated', sgpcreated);
  dbms_sql.close_cursor(cur);

  IF (sgpcreated = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: ' 
                                    || UPPER(sgpname) ||' not created');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT set_sgp_attr
REM =====================================================================
CREATE OR REPLACE PROCEDURE set_sgp_attr(sgpname IN VARCHAR2,
                                                 sgpattr IN VARCHAR2,
                                                 sgpattrval IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  attrset NUMBER := 1;
  uid     NUMBER;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.set_sec_grp_attr(:sgpname, :sgpattr, :sgpattrval);
              EXCEPTION WHEN OTHERS THEN
                :attrset := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':sgpname', sgpname);
  dbms_sql.bind_variable(cur, ':sgpattr', sgpattr);
  dbms_sql.bind_variable(cur, ':sgpattrval', sgpattrval);
  dbms_sql.bind_variable(cur, ':attrset', attrset);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':attrset', attrset);
  dbms_sql.close_cursor(cur);

  IF (attrset = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: ' ||
                                    ' ATTRIBUTE ' || UPPER(sgpattr) ||
                                    ' OF SECTION_GROUP ' || UPPER(sgpname) ||
                                    ' not set');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT default_create_policy
REM =====================================================================
CREATE OR REPLACE PROCEDURE default_create_policy(polname IN VARCHAR2,
                                                  filter  IN VARCHAR2,
                                                  section_group IN VARCHAR2,
                                                  lexer    IN VARCHAR2,
                                                  stoplist IN VARCHAR2,
                                                  wordlist IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  polcreated NUMBER := 1;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.create_policy(:polname, filter => :filter, 
                                          section_group => :section_group,
                                          lexer => :lexer, 
                                          stoplist => :stoplist, 
                                          wordlist => :wordlist);
              EXCEPTION WHEN OTHERS THEN
                :polcreated := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':polname', polname);
  dbms_sql.bind_variable(cur, ':filter', filter);
  dbms_sql.bind_variable(cur, ':section_group', section_group);
  dbms_sql.bind_variable(cur, ':lexer', lexer);
  dbms_sql.bind_variable(cur, ':stoplist', stoplist);
  dbms_sql.bind_variable(cur, ':wordlist', wordlist);
  dbms_sql.bind_variable(cur, ':polcreated', polcreated);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':polcreated', polcreated);
  dbms_sql.close_cursor(cur);

  IF (polcreated = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: ' 
                                    || UPPER(polname) ||' not created');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT default_create_stoplist
REM =====================================================================
CREATE OR REPLACE PROCEDURE default_create_stoplist(stoplistname IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  stpcreated NUMBER := 1;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.create_stoplist(:stoplistname);
              EXCEPTION WHEN OTHERS THEN
                :stpcreated := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':stoplistname', stoplistname);
  dbms_sql.bind_variable(cur, ':stpcreated', stpcreated);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':stpcreated', stpcreated);
  dbms_sql.close_cursor(cur);

  IF (stpcreated = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: '
                                    || UPPER(stoplistname) ||' not created');
  END IF;
END;
/
show err

REM =====================================================================
PROMPT default_create_index_set
REM =====================================================================

CREATE OR REPLACE PROCEDURE default_create_index_set(idxsetname IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  idxsetcreated NUMBER := 1;
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  sys.dbms_sys_sql.parse_as_user(cur,
             'BEGIN ctx_ddl.create_index_set(:idxsetname);
              EXCEPTION WHEN OTHERS THEN
                :idxsetcreated := 0;
              END;',
              dbms_sql.v7, uid);

  dbms_sql.bind_variable(cur, ':idxsetname', idxsetname);
  dbms_sql.bind_variable(cur, ':idxsetcreated', idxsetcreated);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':idxsetcreated', idxsetcreated);
  dbms_sql.close_cursor(cur);

  IF (idxsetcreated = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: '
                                    || UPPER(idxsetname) ||' not created');
  END IF;
END;
/
show err

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;
REM =========================================================================
PROMPT Create default preferences
REM =========================================================================
begin
  -------------------------------------------------------------------------
  -- DATASTORE PREFS
  -------------------------------------------------------------------------
  sys.default_create_preference('CTXSYS.DEFAULT_DATASTORE','DIRECT_DATASTORE');
  sys.default_create_preference('CTXSYS.DIRECT_DATASTORE','DIRECT_DATASTORE');

  /* no more Master-Detail default preferences in 8.1 */
  sys.default_create_preference('CTXSYS.FILE_DATASTORE','FILE_DATASTORE');
  sys.default_create_preference('CTXSYS.DIRECTORY_DATASTORE',
                                'DIRECTORY_DATASTORE');

  sys.default_create_preference('CTXSYS.URL_DATASTORE', 'URL_DATASTORE');
  sys.default_set_attribute('CTXSYS.URL_DATASTORE', 'TIMEOUT',         '30');
  sys.default_set_attribute('CTXSYS.URL_DATASTORE', 'MAXTHREADS',       '8');
  sys.default_set_attribute('CTXSYS.URL_DATASTORE', 'URLSIZE',        '256');
  sys.default_set_attribute('CTXSYS.URL_DATASTORE', 'MAXURLS',        '256');
  sys.default_set_attribute('CTXSYS.URL_DATASTORE', 'MAXDOCSIZE', '2097152');

  sys.default_create_preference('CTXSYS.NETWORK_DATASTORE','NETWORK_DATASTORE');
  sys.default_set_attribute('CTXSYS.NETWORK_DATASTORE', 'TIMEOUT',        '30');
  sys.default_set_attribute('CTXSYS.NETWORK_DATASTORE', 'MAXTHREADS',      '8');
  sys.default_set_attribute('CTXSYS.NETWORK_DATASTORE', 'URLSIZE',       '256');
  sys.default_set_attribute('CTXSYS.NETWORK_DATASTORE', 'MAXURLS',       '256');
  sys.default_set_attribute('CTXSYS.NETWORK_DATASTORE', 'MAXDOCSIZE','2097152');


  -------------------------------------------------------------------------
  -- MISC DATASTORE PREFS
  -------------------------------------------------------------------------
  sys.default_create_preference('CTXSYS.ASYNCH_DATAX','ASYNCH_DATAX');
  sys.default_create_preference('CTXSYS.SYNCH_DATAX','SYNCH_DATAX');
  sys.default_create_preference('CTXSYS.CHAR_DATATYPE','CHAR_DATATYPE');
  sys.default_create_preference('CTXSYS.RAW_DATATYPE','CHAR_DATATYPE');
  sys.default_create_preference('CTXSYS.LONG_DATATYPE','LONG_DATATYPE');
  sys.default_create_preference('CTXSYS.LOB_DATATYPE','LOB_DATATYPE');
  sys.default_create_preference('CTXSYS.NONE_DATATYPE','NONE_DATATYPE');
  sys.default_create_preference('CTXSYS.XMLTYPE_DATATYPE', 'XMLTYPE_DATATYPE');
  sys.default_create_preference('CTXSYS.URITYPE_DATATYPE', 'URITYPE_DATATYPE');

  -------------------------------------------------------------------------
  -- FILTER PREFS
  -------------------------------------------------------------------------

  sys.default_create_preference('CTXSYS.NULL_FILTER','NULL_FILTER');
  sys.default_create_preference('CTXSYS.INSO_FILTER','INSO_FILTER');
  sys.default_create_preference('CTXSYS.MAIL_FILTER','MAIL_FILTER');
  sys.default_create_preference('CTXSYS.AUTO_FILTER','AUTO_FILTER');

  -------------------------------------------------------------------------
  -- ENGINE PREFS
  -------------------------------------------------------------------------

  sys.default_create_preference('CTXSYS.DEFAULT_STORAGE','BASIC_STORAGE');
  sys.default_set_attribute('CTXSYS.default_storage', 'r_table_clause',
                        'lob (data) store as (cache)');

  if (driutl.keycomp_ok) then
    sys.default_set_attribute('CTXSYS.default_storage', 'i_index_clause', 
                        'compress 2');
  end if;

  sys.default_create_preference('CTXSYS.XQFT_LOW', 'BASIC_STORAGE');
  sys.default_set_attribute('CTXSYS.XQFT_LOW', 'xml_save_copy', 'f');
  sys.default_set_attribute('CTXSYS.XQFT_LOW', 'xml_forward_enable', 'f');

  sys.default_create_preference('CTXSYS.XQFT_MEDIUM', 'BASIC_STORAGE');
  sys.default_set_attribute('CTXSYS.XQFT_MEDIUM', 'xml_save_copy', 't');
  sys.default_set_attribute('CTXSYS.XQFT_MEDIUM', 'xml_forward_enable', 'f');

  sys.default_create_preference('CTXSYS.XQFT_HIGH', 'BASIC_STORAGE');
  sys.default_set_attribute('CTXSYS.XQFT_HIGH', 'xml_save_copy', 't');
  sys.default_set_attribute('CTXSYS.XQFT_HIGH', 'xml_forward_enable', 't');

  -------------------------------------------------------------------------
  -- ENGINE PREFS (entity extraction)
  -------------------------------------------------------------------------

  sys.default_create_preference('CTXSYS.ENTITY_STORAGE_DR', 'ENTITY_STORAGE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_DR', 'include_dictionary',
                        'TRUE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_DR', 'include_rules', 'TRUE');

  sys.default_create_preference('CTXSYS.ENTITY_STORAGE_D', 'ENTITY_STORAGE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_D', 'include_dictionary', 
                        'TRUE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_D', 'include_rules', 'FALSE');

  sys.default_create_preference('CTXSYS.ENTITY_STORAGE_R', 'ENTITY_STORAGE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_R', 'include_dictionary', 
                        'FALSE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE_R', 'include_rules', 'TRUE');

  sys.default_create_preference('CTXSYS.ENTITY_STORAGE', 'ENTITY_STORAGE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE', 'include_dictionary', 
                        'FALSE');
  sys.default_set_attribute('CTXSYS.ENTITY_STORAGE', 'include_rules', 'FALSE');

  -------------------------------------------------------------------------
  -- LEXER PREFS (most lexers are language-specific)
  -------------------------------------------------------------------------

  sys.default_create_preference('CTXSYS.BASIC_LEXER', 'BASIC_LEXER');
  sys.default_create_preference('CTXSYS.NULL_LEXER', 'NULL_LEXER');
 
  sys.default_create_preference('CTXSYS.DEFAULT_EXTRACT_LEXER', 'AUTO_LEXER');
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 
                        'alternate_spelling', 'NONE');
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 'base_letter', 'NO');
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 'mixed_case', 'YES');
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 'printjoins', '-*');
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 'timeout', 0);
  sys.default_set_attribute('CTXSYS.DEFAULT_EXTRACT_LEXER', 'language', 
                        'english');

  -------------------------------------------------------------------------
  -- WORDLIST PREFS
  -------------------------------------------------------------------------

  sys.default_create_preference('CTXSYS.BASIC_WORDLIST', 'BASIC_WORDLIST');

  -------------------------------------------------------------------------
  -- Default classifier
  -------------------------------------------------------------------------
  sys.default_create_preference('CTXSYS.DEFAULT_CLASSIFIER', 'RULE_CLASSIFIER');

  sys.default_create_preference('CTXSYS.DEFAULT_SENT_CLASSIFIER',
                            'SENTIMENT_CLASSIFIER');

  -------------------------------------------------------------------------
  -- Default clustering
  -------------------------------------------------------------------------
  sys.default_create_preference('CTXSYS.DEFAULT_CLUSTERING', 'KMEAN_CLUSTERING');
  
end;
/

-------------------------------------------------------------------------
-- Default section group
-------------------------------------------------------------------------
          
exec sys.default_create_sgp('CTXSYS.null_section_group','null_section_group');
exec sys.default_create_sgp('CTXSYS.html_section_group','html_section_group');
exec sys.default_create_sgp('CTXSYS.auto_section_group', 'auto_section_group');
exec sys.default_create_sgp('CTXSYS.path_section_group', 'path_section_group');
exec sys.default_create_sgp('CTXSYS.ctxxpath_section_group', 'ctxxpath_section_group');

exec sys.default_create_sgp('CTXSYS.XQUERY_SEC_GROUP', 'PATH_SECTION_GROUP');
exec sys.set_sgp_attr('CTXSYS.XQUERY_SEC_GROUP', 'xml_enable', 't');
exec sys.set_sgp_attr('CTXSYS.XQUERY_SEC_GROUP', 'range_search_enable', 'all');
                           
exec sys.default_create_sgp('CTXSYS.JSON_SECTION_GROUP', 'PATH_SECTION_GROUP');
exec sys.set_sgp_attr('CTXSYS.JSON_SECTION_GROUP', 'JSON_ENABLE', 'T');

exec sys.default_create_sgp('CTXSYS.JSON_SEARCH_GROUP', 'PATH_SECTION_GROUP');
exec sys.set_sgp_attr('CTXSYS.JSON_SEARCH_GROUP', 'json_enable', 't');
exec sys.set_sgp_attr('CTXSYS.JSON_SEARCH_GROUP', 'range_search_enable', 'all');
 
exec sys.default_create_sgp('CTXSYS.XQFT_SEC_GROUP', 'PATH_SECTION_GROUP');
exec sys.set_sgp_attr('CTXSYS.XQFT_SEC_GROUP', 'XML_ENABLE', 'T');

exec sys.default_create_sgp('CTXSYS.BSON_SECTION_GROUP', 'PATH_SECTION_GROUP');

exec sys.set_sgp_attr('CTXSYS.BSON_SECTION_GROUP', 'BSON_ENABLE', 'T');

-- Default lexer settings for JSON search index
exec sys.default_create_preference('CTXSYS.JSON_DEFAULT_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSON_DEFAULT_LEXER', 'mixed_case', 'NO');
exec sys.default_set_attribute('CTXSYS.JSON_DEFAULT_LEXER', 'base_letter', 'YES');
exec sys.default_set_attribute('CTXSYS.JSON_DEFAULT_LEXER', 'index_themes', 'NO');

begin
    sys.default_create_stoplist('CTXSYS.EMPTY_STOPLIST');
end;
/

begin
    sys.default_create_index_set('CTXSYS.EMPTY_INDEX_SET');
end;
/

REM =========================================================================
PROMPT System Parameters
REM =========================================================================

insert into ctxsys.dr$parameter (par_name, par_value)
values ('MAX_INDEX_MEMORY',     '274877906944');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_INDEX_MEMORY', '67108864');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_DATASTORE',    'CTXSYS.DEFAULT_DATASTORE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_FILTER_TEXT',       'CTXSYS.NULL_FILTER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_FILTER_BINARY',       'CTXSYS.AUTO_FILTER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_FILTER_FILE',       'CTXSYS.AUTO_FILTER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_SECTION_HTML', 'CTXSYS.HTML_SECTION_GROUP');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_SECTION_TEXT', 'CTXSYS.NULL_SECTION_GROUP');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_LEXER',        'CTXSYS.DEFAULT_LEXER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_EXTRACT_LEXER', 'CTXSYS.DEFAULT_EXTRACT_LEXER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_STOPLIST',     'CTXSYS.DEFAULT_STOPLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_WORDLIST',     'CTXSYS.DEFAULT_WORDLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_STORAGE',      'CTXSYS.DEFAULT_STORAGE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('LOG_DIRECTORY',        null);

insert into ctxsys.dr$parameter (par_name, par_value)
values ('CTX_DOC_KEY_TYPE',        'PRIMARY_KEY');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXCAT_LEXER',        'CTXSYS.DEFAULT_LEXER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXCAT_STOPLIST',     'CTXSYS.DEFAULT_STOPLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXCAT_WORDLIST',     'CTXSYS.DEFAULT_WORDLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXCAT_STORAGE',      'CTXSYS.DEFAULT_STORAGE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXCAT_INDEX_SET',     'CTXSYS.EMPTY_INDEX_SET');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXRULE_LEXER',        'CTXSYS.DEFAULT_LEXER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXRULE_STOPLIST',     'CTXSYS.DEFAULT_STOPLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXRULE_WORDLIST',     'CTXSYS.DEFAULT_WORDLIST');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXRULE_STORAGE',      'CTXSYS.DEFAULT_STORAGE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_SECTION_XML',          'CTXSYS.PATH_SECTION_GROUP');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CTXXPATH_STORAGE',     'CTXSYS.DEFAULT_STORAGE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CLASSIFIER',     'CTXSYS.DEFAULT_CLASSIFIER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_SENT_CLASSIFIER',     'CTXSYS.DEFAULT_SENT_CLASSIFIER');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('DEFAULT_CLUSTERING',     'CTXSYS.DEFAULT_CLUSTERING');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('MAIL_FILTER_CONFIG_FILE','drmailfl.txt');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('AUTO_OPTIMIZE', 'ENABLE');

insert into ctxsys.dr$parameter (par_name, par_value)
values ('AUTO_OPTIMIZE_LOGFILE', NULL);

-- 13431201: Add functional_cache_size
insert into ctxsys.dr$parameter (par_name, par_value)
values ('FUNCTIONAL_CACHE_SIZE', '20971520');

commit;

-------------------------------------------------------------------------------
-- Dummy Policy for Entity Extraction Dictionary Loading
-------------------------------------------------------------------------------
begin
  sys.default_create_policy('CTXSYS.ENT_EXT_DICT_OBJ',
    filter        => 'CTXSYS.NULL_FILTER',
    section_group => 'CTXSYS.NULL_SECTION_GROUP',
    lexer         => 'CTXSYS.BASIC_LEXER',
    stoplist      => 'CTXSYS.EMPTY_STOPLIST',
    wordlist      => 'CTXSYS.BASIC_WORDLIST'
);
end;
/

------------------------------------------------------------------------
-- Dummy policy for background autooptimize
------------------------------------------------------------------------

begin
  sys.default_create_policy('CTXSYS.AUTO_OPT_OBJ',
    filter        => 'CTXSYS.NULL_FILTER',
    section_group => 'CTXSYS.NULL_SECTION_GROUP',
    lexer         => 'CTXSYS.BASIC_LEXER',
    stoplist      => 'CTXSYS.EMPTY_STOPLIST',
    wordlist      => 'CTXSYS.BASIC_WORDLIST'
);
end;
/

------------------------------------------------------------------------
-- Dummy policy for stopping optimize
------------------------------------------------------------------------

begin
  sys.default_create_policy('CTXSYS.STOP_OPT_LIST',
    filter        => 'CTXSYS.NULL_FILTER',
    section_group => 'CTXSYS.NULL_SECTION_GROUP',
    lexer         => 'CTXSYS.BASIC_LEXER',
    stoplist      => 'CTXSYS.EMPTY_STOPLIST',
    wordlist      => 'CTXSYS.BASIC_WORDLIST'
);
end;
/

-- Lexers removed. Were present here, but not in dr0defin:
--    NYNORSK, BOKMAL, PERSIAN, Serbian

------------------------------------------------------------------------
-- Lexers for JSON REST services and SODA
------------------------------------------------------------------------

-- Generic Lexers that were already present in this file: 
--   American, Arabic, Croatian, Slovak, SLOVENIAN, Hebrew, Thai,
--   Catalan, Czech, Polish, Portuguese, French, Russian, Romanian, GREEK, 
--   SPANISH, HUNGARIAN, ITALIAN, TURKISH

-- Generic Lexers brough in from file dr0defin: 
--   English, Bangla, Brazilian Portuguese, Bulgarian, Canadian French,
--   Egyptian, Estonian, Icelandic, Indonesian, Latin American Spanish, 
--   Latvian, Lithuanian, Malay, Mexican Spanish, Ukranian, Vietnamese

exec sys.default_create_preference('CTXSYS.JSONREST_GENERIC_LEXER', 'BASIC_LEXER');

exec sys.default_create_preference('CTXSYS.JSONREST_DANISH_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_DANISH_LEXER','ALTERNATE_SPELLING','DANISH');

exec sys.default_create_preference('CTXSYS.JSONREST_FINNISH_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_FINNISH_LEXER',	'ALTERNATE_SPELLING', 'SWEDISH');

exec sys.default_create_preference('CTXSYS.JSONREST_DUTCH_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_DUTCH_LEXER', 'COMPOSITE','DUTCH');

exec sys.default_create_preference('CTXSYS.JSONREST_GERMAN_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_LEXER', 	'ALTERNATE_SPELLING', 'GERMAN');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_LEXER', 	'COMPOSITE', 'GERMAN');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_LEXER', 'MIXED_CASE', 'YES');

exec sys.default_create_preference('CTXSYS.JSONREST_SCHINESE_LEXER', 'CHINESE_VGRAM_LEXER');

exec sys.default_create_preference('CTXSYS.JSONREST_TCHINESE_LEXER', 'CHINESE_VGRAM_LEXER');

exec sys.default_create_preference('CTXSYS.JSONREST_KOREAN_LEXER', 'KOREAN_MORPH_LEXER');

exec sys.default_create_preference('CTXSYS.JSONREST_SWEDISH_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_SWEDISH_LEXER','ALTERNATE_SPELLING','SWEDISH');

exec sys.default_create_preference('CTXSYS.JSONREST_JAPANESE_LEXER', 'JAPANESE_VGRAM_LEXER');

exec sys.default_create_preference('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'ALTERNATE_SPELLING', 'GERMAN');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'COMPOSITE', 'GERMAN');
exec sys.default_set_attribute('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'MIXED_CASE', 'YES');

exec sys.default_create_preference('CTXSYS.JSONREST_NORWEGIAN_LEXER', 'BASIC_LEXER');
exec sys.default_set_attribute('CTXSYS.JSONREST_NORWEGIAN_LEXER', 'ALTERNATE_SPELLING','SWEDISH');

ALTER SESSION SET CURRENT_SCHEMA = SYS;

drop procedure default_create_preference;
drop procedure default_set_attribute;
drop procedure default_create_sgp;
drop procedure set_sgp_attr;
drop procedure default_create_policy;
drop procedure default_create_stoplist;
drop procedure default_create_index_set;

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

@?/rdbms/admin/sqlsessend.sql
