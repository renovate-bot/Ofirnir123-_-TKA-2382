Rem
Rem $Header: ctx_src_2/src/dr/admin/defaults/dr0defin.sql /main/3 2018/08/08 15:49:32 nspancha Exp $
Rem
Rem dr0defin.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0defin.sql - dr0 DEFault preference INstall
Rem
Rem    DESCRIPTION
Rem      based on passed-in language name, run the appropriate
Rem      language-specific default preference install script
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    03/18/18 - Bug 27084954: Safe Schema Loading
Rem    gkaminag    03/29/02 - gkaminag_bug-2283146
Rem    gkaminag    03/29/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

alter session set CURRENT_SCHEMA=CTXSYS;

DEFINE nls_language = "&1"
COLUMN lang_abbr NEW_VALUE lang_abbr

SELECT DECODE('&nls_language',
'AMERICAN', 'us',
'ARABIC', 'ar',
'BANGLA', 'bn',
'BRAZILIAN PORTUGUESE', 'ptb',
'BULGARIAN', 'bg',
'CANADIAN FRENCH', 'frc',
'CATALAN', 'ca',
'CROATIAN', 'hr',
'CZECH', 'cs',
'DANISH', 'dk',
'DUTCH', 'nl',
'EGYPTIAN', 'eg',
'ENGLISH', 'gb',
'ESTONIAN', 'et',
'FINNISH', 'sf',
'FRENCH', 'f',
'GERMAN DIN', 'din',
'GERMAN', 'd',
'GREEK', 'el',
'HEBREW', 'iw',
'HUNGARIAN', 'hu',
'ICELANDIC', 'is',
'INDONESIAN', 'in',
'ITALIAN', 'i',
'JAPANESE', 'ja',
'KOREAN', 'ko',
'LATIN AMERICAN SPANISH', 'esa',
'LATVIAN', 'lv',
'LITHUANIAN', 'lt',
'MALAY', 'ms',
'MEXICAN SPANISH', 'esm',
'NORWEGIAN', 'n',
'POLISH', 'pl',
'PORTUGUESE', 'pt',
'ROMANIAN', 'ro',
'RUSSIAN', 'ru',
'SIMPLIFIED CHINESE', 'zhs',
'SLOVAK', 'sk',
'SLOVENIAN', 'sl',
'SPANISH', 'e',
'SWEDISH', 's',
'THAI', 'th',
'TRADITIONAL CHINESE', 'zht',
'TURKISH', 'tr',
'UKRAINIAN', 'uk',
'VIETNAMESE', 'vn',
'us') 
lang_abbr FROM dual;

@@drdef&lang_abbr..sql

@?/rdbms/admin/sqlsessend.sql
