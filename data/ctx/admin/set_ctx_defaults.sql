Rem
Rem $Header: ctx_src_2/src/dr/admin/set_ctx_defaults.sql /st_rdbms_19/1 2018/08/29 16:13:58 nspancha Exp $
Rem
Rem set_ctx_defaults.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      set_ctx_defaults.sql - Setting Oracle Text installation defaults
Rem
Rem    DESCRIPTION
Rem      Setting language and other defaults for Oracle Text
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/set_ctx_defaults.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/set_ctx_defaults.sql
Rem    SQL_PHASE:UTILITY
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    08/28/18 - XbranchMerge nspancha_lrg-21522480 from main
Rem    nspancha    08/16/18 - RTI 21521911:Phase Metadata needed to be changed
Rem    nspancha    08/06/18 - Bug 28445918: Script from Roger for CTX prefs
Rem    nspancha    08/06/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

-- create a SQL*Plus substitution variable mylang and fill it with next COLVAL
column colval new_value mylang

-- fetch 1,2 or 3-char language value into mylang

select decode ( userenv('lang'),
'ZHT', 'zht',
'ZHS', 'zhs',
'VN', 'vn',
'UK', 'uk',
'TR', 'tr',
'TH', 'th',
'S', 's',
'SL', 'sl',
'SK', 'sk',
'SF', 'sf',
'RU', 'ru',
'RO', 'ro',
'PT', 'pt',
'PTB', 'ptb',
'PL', 'pl',
'N', 'n',
'NL', 'nl',
'MS', 'ms',
'LV', 'lv',
'LT', 'lt',
'KO', 'ko',
'JA', 'ja',
'IW', 'iw',
'IS', 'is',
'I', 'i',
'IN', 'in',
'HU', 'hu',
'HR', 'hr',
'GB', 'gb',
'F', 'f',
'FRC', 'frc',
'ET', 'et',
'E', 'e',
'ESM', 'esm',
'ESA', 'esa',
'EL', 'el',
'EG', 'eg',
'D', 'd',
'DK', 'dk',
'DIN', 'din',
'CS', 'cs',
'CA', 'ca',
'BN', 'bn',
'BG', 'bg',
'AR', 'ar',
'US', 'us',
'us') as colval from dual;

-- execute the relevant file
@?/ctx/admin/defaults/drdef&mylang;

@?/rdbms/admin/sqlsessend.sql
 
