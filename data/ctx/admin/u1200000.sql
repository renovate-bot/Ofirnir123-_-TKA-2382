Rem
Rem $Header: ctx_src_2/src/dr/admin/u1200000.sql /main/51 2018/07/25 13:49:07 surman Exp $
Rem
Rem u1200000.sql
Rem
Rem Copyright (c) 2011, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1200000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      upgrade from 11.2.0.2 to 12.1
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1200000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1200000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    nspancha    02/22/17 - Bug 23473590 : Fixing buffer too small at upgrade
Rem    yinlu       05/03/16 - bug 23117537: delete oat_id 90127-90129 from
Rem                           dr$object_attribute
Rem    boxia       01/21/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    yinlu       08/28/15 - lrg 18241069: grant create sequence to ctxapp
Rem    surman      04/20/15 - 20741195: Check object type
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    gpodila     11/06/14 - Bug 14254610 index optimization in rebuild fails
Rem    gpodila     10/22/12 - Bug 13640676 cannot exchange table partition
Rem    zliu        09/16/14 - fix bug 19576737
Rem    boxia       11/26/13 - Modify btree-backed sdata part
Rem    shuroy      06/03/13 - LRG 8581684: Adding SAVE_COPY
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    rkadwe      10/31/12 - Bug 14797086
Rem    yiqi        10/16/12 - Bug 14459127 and lrg 7293054
Rem    surman      08/24/12 - 14038163: Add a_index_clause and f_index_clause
Rem    shrtiwar    07/28/12 - Bug 14111356
Rem    gauryada    07/16/12 - bug#14109170
Rem    rkadwe      07/09/12 - Bug 13942561
Rem    yiqi        06/06/12 - Bug 13606137
Rem    ssethuma    04/25/12 - Bug 13901327
Rem    yiqi        04/11/12 - add small_r_row storage attribute
Rem    yiqi        04/03/12 - 13724070: add stage_itab_target_size
Rem    yinlu       03/20/12 - allow sdata in path section group
Rem    surman      03/02/12 - 13610777: Default value of read_only should be
Rem                           FALSE
Rem    surman      02/08/12 - 13431201: Add functional_cache_size
Rem    ataracha    01/18/12 - remove <lang>_sentence_starts
Rem    thbaby      01/11/12 - include oat_id 16 in update
Rem    thbaby      01/10/12 - create index drx$sga_id
Rem    thbaby      01/10/12 - remove primary key on dr$section_group_attribute
Rem    thbaby      01/10/12 - increase sga_value size from 500 to 4000
Rem    thbaby      01/06/12 - add prefix_ns_mapping section group attribute
Rem    shrtiwar    01/03/12 - Remove Sentence token limit attribute from auto
Rem                           lexer
Rem    rkadwe      12/12/11 - ATG Dictionary attributes
Rem    rkadwe      11/14/11 - ATG upgrade changes
Rem    aczarlin    12/13/11 - btree sdata dtypes
Rem    rpalakod    10/14/11 - range postings
Rem    thbaby      08/24/11 - add E_TABLE_CLAUSE
Rem    thbaby      08/24/11 - add ns_enable section group attribute
Rem    rkadwe      07/14/11 - Forward index upgrade bug
Rem    rkadwe      06/27/11 - Upgrade diffs
Rem    gauryada    06/14/11 - Added SN_TABLE_CLAUSE and SN_INDEX_CLAUSE
Rem    thbaby      06/14/11 - add xml_enable section group attribute
Rem    thbaby      06/14/11 - create dr$section_group_attribute
Rem    hsarkar     06/01/11 - Bug 12615145
Rem    rkadwe      05/20/11 - Fix lrgs for btree backed SDATA
Rem    ssethuma    05/06/11 - Section specific stoplist
Rem    gauryada    05/02/11 - Corrected o_table_clause,o_index_clause,
Rem                           d_table_clause, d_index_clause, to be of 
Rem                           type string and added save_copy
Rem    rpalakod    03/29/11 - Bug 11867068
Rem    rpalakod    03/28/11 - Bug 11907388
Rem    hsarkar     03/24/11 - Date and Pattern Stopclass project
Rem    rpalakod    02/08/11 - upgrade to 12.1
Rem    rpalakod    02/08/11 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ===================================================================
REM Bug 9950719: fuzzy_score has a mininum value of 1
REM ===================================================================

update dr$object_attribute
  set oat_val_min = 1
  where oat_id = 70103;

REM ========================================================================
REM Enable query_filter_cache_size attribute for basic_storage
REM Add FORWARD_INDEX, O_TABLE_CLAUSE, O_INDEX_CLAUSE, D_TABLE_CLAUSE
Rem and D_INDEX_CLAUSE
REM ========================================================================

begin

insert into dr$object_attribute values
  (90132, 9, 1, 32,
   'QUERY_FACET_PIN_PERM', null,
   'N', 'N', 'Y', 'B',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90118, 9, 1, 18,
   'QUERY_FILTER_CACHE_SIZE', null,
   'N', 'N', 'Y', 'I',
   '0', 0, null, 'N');

insert into dr$object_attribute values
  (90119, 9, 1, 19,
   'FORWARD_INDEX', '',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
   
insert into dr$object_attribute values
  (90120, 9, 1, 20,
   'O_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90121, 9, 1, 21,
   'O_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90122, 9, 1, 22,
   'SAVE_COPY', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
   
insert into dr$object_attribute values
  (90123, 9, 1, 23,
   'D_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90124, 9, 1, 24, 
   'SAVE_COPY_MAX_SIZE', '',
   'N', 'N', 'Y', 'I', 
   '0', null, null, 'N');

insert into dr$object_attribute values
  (90125, 9, 1, 25,
   'SN_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90126, 9, 1, 26,
   'SN_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

commit;
exception
when dup_val_on_index then
  null;
end;
/

REM ========================================================================
REM filter cache stats view stub
REM ========================================================================
REM this is a dummy until the types and packages we need get created

create or replace view ctx_filter_cache_statistics as
select 0 fcs_index_owner,
       0 fcs_index_name,
       0 fcs_partition_name,
       0 fcs_size,
       0 fcs_entries,
       0 fcs_requests,
       0 fcs_hits from dual where 1 = 2;
create or replace public synonym ctx_filter_cache_statistics for
ctxsys.ctx_filter_cache_statistics;
grant select on ctx_filter_cache_statistics to public;

REM ===================================================================
REM Section specific attributes
REM ===================================================================

rem This table holds section specific attribute values
declare
  errnum number;
begin
  execute immediate('
                     alter table dr$class add constraint drc$cla_key
                     PRIMARY KEY (cla_id)
                     USING INDEX STORAGE (INITIAL 5K NEXT 5K)');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -02260) then
      null;
    else
      raise;
    end if;
end;
/

PROMPT ... creating table dr$section_attribute
declare
  errnum number;
begin
  execute immediate('
create table dr$section_attribute
(
  sca_sgp_id number,
  sca_sec_id number,
  sca_sat_id number,
  sca_value  varchar2(500),
  primary key(sca_sgp_id, sca_sec_id, sca_sat_id)
) organization index');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00955) then
      null;
    else
      raise;
    end if;
end;
/

-- fix bug 19576737
-- 17,19 are json_enable and bson_enable, they shall remains as
-- boolean attributes, so are 14,15,16 for xml_enable, ns_enables, 
-- prefix_ns_mapping boolean attributes.
update dr$object_attribute
  set oat_datatype = 'I'
  where oat_cla_id = 5 and oat_att_Id not in (14,15,16, 17, 19);

BEGIN

insert into dr$object_attribute values
  (50113, 5, 1, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50213, 5, 2, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50313, 5, 3, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50513, 5, 5, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50613, 5, 6, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50713, 5, 7, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50813, 5, 8, 13, 
   'SECTION_ATTRIBUTE', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, 500, 'N');

EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (50810, 5, 8, 10, 
   'SDATA', '',
   'N', 'N', 'Y', 'I', 
   'NONE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

BEGIN
insert into dr$object_attribute values
  (50814, 5, 8, 14, 
   'XML_ENABLE', 'xml aware path section group',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

BEGIN
insert into dr$object_attribute values
  (50815, 5, 8, 15, 
   'NS_ENABLE', 'namespace aware path section group',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

BEGIN
insert into dr$object_attribute values
  (50816, 5, 8, 16, 
   'PREFIX_NS_MAPPING', 'prefix to namespace mapping',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

BEGIN
  insert into dr$class values
    (24, 'SECTION', 'Section', 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
  insert into dr$object values
    (24, 1, 'BASIC_SECTION', 'basic section', 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN

insert into dr$object_attribute values
  (240101, 24, 1, 1, 
   'SECTION_ID', 'unique identifier for this section in index',
   'N', 'N', 'Y', 'I', 
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240102, 24, 1, 2, 
   'SECTION_NAME', 'section name',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240103, 24, 1, 3, 
   'TAG', 'tag mapping to this section',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240104, 24, 1, 4, 
   'TOKEN_TYPE', 'token_type for this section',
   'N', 'N', 'Y', 'I', 
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240105, 24, 1, 5, 
   'VISIBLE', 'Is this section visible to body',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240106, 24, 1, 6, 
   'READ_ONLY', 'Is this section read_only (non-updateable)',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240107, 24, 1, 7, 
   'DATATYPE', 'section datatype',
   'N', 'N', 'Y', 'I', 
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240110, 24, 1, 10, 
   'SEARCHABLE', 'SDATA values stored in the $Sn tables',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (240111, 24, 1, 11, 
   'SORTABLE', 'SDATA values stored in the $S table',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

Rem =====================================================================
Rem Lrg 8581684 : Added SAVE_COPY 
Rem =====================================================================

BEGIN

insert into dr$object_attribute values
  (240108, 24, 1, 8,
   'SAVE_COPY', 'Store this section in $D?',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/


REM ===================================================================
REM Bug 13610777: Default value of read_only should be FALSE
REM ===================================================================

update dr$object_attribute
  set oat_default = 'FALSE'
  where oat_id = 240106;

-------------------------------------------------------------------------
--- dr$stopword
-------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$stopword add spw_pattern varchar2(512) default NULL');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -01430) then
      null;
    else
      raise;
    end if;
end;
/

-------------------------------------------------------------------------
--- ctx_stopwords 
-------------------------------------------------------------------------
create or replace view ctx_stopwords as
select
  u.name         spw_owner,
  spl_name       spw_stoplist,
  decode(spw_type, 1, 'STOP_CLASS', 2, 'STOP_WORD', 3, 'STOP_THEME', null)
                 spw_type,
  spw_word       spw_word,
  decode(spw_language, 'ALL', null, spw_language)   spw_language,
  spw_lang_dependent   spw_lang_dependent,
  spw_pattern          spw_pattern
from dr$stoplist, dr$stopword, sys."_BASE_USER" u
where spl_id = spw_spl_id
  and spl_owner# = u.user#
/

create or replace public synonym ctx_stopwords for CTXSYS.CTX_STOPWORDS;
grant select on CTX_STOPWORDS to PUBLIC;

-------------------------------------------------------------------------
--- ctx_user_stopwords
-------------------------------------------------------------------------
create or replace view CTX_USER_STOPWORDS as
select
  spl_name       spw_stoplist,
  decode(spw_type, 1, 'STOP_CLASS', 2, 'STOP_WORD', 3, 'STOP_THEME', null)
                 spw_type,
  spw_word       spw_word,
  decode(spw_language, 'ALL', null, spw_language)   spw_language,
  spw_lang_dependent   spw_lang_dependent,
  spw_pattern          spw_pattern
from dr$stoplist, dr$stopword
where spl_id = spw_spl_id
  and spl_owner# = userenv('SCHEMAID')
/

create or replace public synonym CTX_USER_STOPWORDS
for CTXSYS.CTX_USER_STOPWORDS;
grant select on CTX_USER_STOPWORDS to PUBLIC;

-------------------------------------------------------------------------
--- Section specific stoplist
-------------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (240109, 24, 1, 9,
   'STOPLIST', 'section specific stoplist',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

-------------------------------------------------------------------------
--- Added configuration column 
-------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index add idx_config_column VARCHAR2(256) default NULL');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -01430) then
      null;
    else
      raise;
    end if;
end;
/

-------------------------------------------------------------------------
--- Added SN_TABLE_CLAUSE and SN_INDEX_CLAUSE 
-------------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90125, 9, 1, 25, 
   'SN_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (90126, 9, 1, 26, 
   'SN_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

----------------------------------------------------------------------
--- bug 23117537: delete existing oat_id 90127-90129
--- as they already exist in 11.2 and are resued in 12.1
----------------------------------------------------------------------
BEGIN

delete from dr$object_attribute
where OAT_ID=90127 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=27 
and OAT_NAME='SMALL_R_ROW';  
 
delete from dr$object_attribute
where OAT_ID=90128 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=28 
and OAT_NAME='A_INDEX_CLAUSE'; 
 
delete from dr$object_attribute 
where OAT_ID=90129 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=29 
and OAT_NAME='F_INDEX_CLAUSE'; 

commit; 
END;
/


-------------------------------------------------------------------------
--- E_TABLE_CLAUSE
-------------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90127, 9, 1, 27, 
   'E_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

-------------------------------------------------------------------------
--- SMALL_R_ROW
-------------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90129, 9, 1, 29, 
   'SMALL_R_ROW', '',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/


-------------------------------------------------------------------------
--- STAGE_ITAB_TARGET_SIZE
-------------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90128, 9, 1, 28, 
   'STAGE_ITAB_TARGET_SIZE', '',
   'N', 'N', 'Y', 'I', 
   '0', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

-------------------------------------------------------------------------
--- dr$section_group_attribute
-------------------------------------------------------------------------
declare
  stmt varchar2(4000);
  cnt  number;
begin
  stmt := 'select count(*) from user_tables where table_name=''' || 
          'DR$SECTION_GROUP_ATTRIBUTE' ||
          '''';
  execute immediate stmt into cnt;
  if (cnt = 0) then
    stmt := 'create table dr$section_group_attribute' || 
            '(' ||
            'sga_id        number,' ||
            'sga_sgat_id   number,' ||
            'sga_value     varchar2(4000)' || 
            ')';
    execute immediate stmt;
    stmt := 'create index drx$sga_id on ' || 
            'dr$section_group_attribute(sga_id, sga_sgat_id)';
    execute immediate stmt;
  end if;
  exception 
    when others then
      null;
end;
/

-------------------------------------------------------------------------
--- dr$dictionary
-------------------------------------------------------------------------

PROMPT ... creating table dr$dictionary
declare
  errnum number;
begin
  execute immediate('
create table DR$DICTIONARY(
  dict_owner# NUMBER,
  dict_name  VARCHAR2(30),
  dict_lang  VARCHAR2(30),
  dict_lob   CLOB,
  primary key(dict_owner#, dict_name, dict_lang))');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00955) then
      null;
    else
      raise;
    end if;
end;
/

grant select on dr$dictionary to ctxapp;
grant delete on dr$dictionary to ctxapp;
grant insert on dr$dictionary to ctxapp;
grant update on dr$dictionary to ctxapp;

-------------------------------------------------------------------------
--- dr$idx_dictionaries
-------------------------------------------------------------------------

PROMPT ... creating table dr$idx_dictionaries
declare
  errnum number;
begin
  execute immediate('
  create table DR$IDX_DICTIONARIES(
  idx_id     NUMBER,
  dict_lang  VARCHAR2(30),
  dict_lob   CLOB,
  primary key(idx_id, dict_lang))');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00955) then
      null;
    else
      raise;
    end if;
end;
/

--------------------------------------------------------------------
-- CTX_USER_ALEXER_DICTS 
--------------------------------------------------------------------
create or replace view CTX_USER_ALEXER_DICTS  as
select dict_name ald_name, dict_lang ald_lang
  from DR$DICTIONARY
  where dict_owner# = userenv('SCHEMAID');

--------------------------------------------------------------------
-- CTX_ALEXER_DICTS  
--------------------------------------------------------------------
create or replace view CTX_ALEXER_DICTS  as
select idx.idx_owner# as ald_owner, b.dict_name as ald_name,
  a.dict_lang as ald_lang
  from DR$IDX_DICTIONARIES a, DR$DICTIONARY b, dr$index idx
  where idx.idx_owner# = b.dict_owner# and a.dict_lang = b.dict_lang;

BEGIN
insert into dr$object_attribute values
  (2061255, 6, 12, 255,
   'PRINTJOINS', 'Characters which join words together',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

BEGIN
insert into dr$object_attribute values
  (2061256, 6, 12, 256,
   'SKIPJOINS', 'Non-printing join characters',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

EXCEPTION
  when dup_val_on_index then
    null;
END;
/


declare
type lang_tab is table of varchar2(30) index by binary_integer;
langtab lang_tab;
dict varchar2(20);
sent_starts varchar2(20);
abbr_dict varchar2(20);
tag_dict varchar2(20);
tagstem_dict varchar2(20);
stem_dict varchar2(20);
ccjt_dict varchar2(20);

begin
langtab(0) := 'ARABIC';
langtab(1) := 'CATALAN';
langtab(2) := 'SIMP_CHINESE';
langtab(3) := 'TRAD_CHINESE';
langtab(4) := 'CROATIAN';
langtab(5) := 'CZECH';
langtab(6) := 'DANISH';
langtab(7) := 'DUTCH';
langtab(8) := 'ENGLISH';
langtab(9) := 'FINNISH';
langtab(10) := 'FRENCH';
langtab(11) := 'GERMAN';
langtab(12) := 'GREEK';
langtab(13) := 'HEBREW';
langtab(14) := 'HUNGARIAN';
langtab(15) := 'ITALIAN';
langtab(16) := 'JAPANESE';
langtab(17) := 'KOREAN';
langtab(18) := 'BOKMAL';
langtab(19) := 'NYNORSK';
langtab(20) := 'PERSIAN';
langtab(21) := 'POLISH';
langtab(22) := 'PORTUGUESE';
langtab(23) := 'ROMANIAN';
langtab(24) := 'RUSSIAN';
langtab(25) := 'SERBIAN';
langtab(26) := 'SLOVAK';
langtab(27) := 'SLOVENIAN';
langtab(28) := 'SPANISH';
langtab(29) := 'SWEDISH';
langtab(30) := 'THAI';
langtab(31) := 'TURKISH';

dict := '_DICTIONARY';
sent_starts := '_SENTENCE_STARTS';
abbr_dict := '_ABBR_DICT';
tag_dict := '_TAG_DICT';
tagstem_dict := '_TAGSTEM_DICT';
stem_dict := '_STEM_DICT';
ccjt_dict := '_CCJT_DICT';

for i in 0..31
loop
  begin
-- INSERT <lang>_DICTIONARY
   insert into dr$object_attribute values
    (2061257+i, 6, 12, 257+i,
     langtab(i)||dict, lower(langtab(i))||' dictionary',
    'N', 'N', 'Y', 'S', 
    'NONE', null, null, 'N');

-- DELETE old <lang> attributes
--decrease value of ixo_acnt where attribute name is sent_starts
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||sent_starts)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is sent_starts 
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||sent_starts);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||sent_starts;

--decrease value of ixo_acnt where attribute name is abbr_dict 
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||abbr_dict)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is abbr_dict
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||abbr_dict);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||abbr_dict;


--decrease value of ixo_acnt where attribute name is tag_dict 
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||tag_dict)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is tag_dict
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||tag_dict);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||tag_dict;


--decrease value of ixo_acnt where attribute name is tagstem_dict
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||tagstem_dict)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is tagstem_dict
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||tagstem_dict);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||tagstem_dict;



--decrease value of ixo_acnt where attribute name is stem_dict
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||stem_dict)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is stem_dict
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||stem_dict);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||stem_dict;



--decrease value of ixo_acnt where attribute name is ccjt_dict
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||ccjt_dict)) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is ccjt_dict
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
langtab(i)||ccjt_dict);

   delete from dr$object_attribute where oat_cla_id=6 and oat_obj_id = 12 and oat_name=langtab(i)||ccjt_dict;
  EXCEPTION
    when dup_val_on_index then
      null;
  end;
end loop;
end;
/

-- Remove SENTENCE_TOKEN_LIMIT (Drprecated from 12.1)
--decrease value of ixo_acnt where attribute name is sentence_token_limit
update dr$index_object set IXO_ACNT = IXO_ACNT-1 where IXO_IDX_ID in (select
IXV_IDX_ID from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
'SENTENCE_TOKEN_LIMIT')) and IXO_CLA_ID = 6 and IXO_OBJ_ID = 12;

--remove rows from dr$index_value where attribute is sentence_token_limit 
delete from dr$index_value where IXV_OAT_ID = (select OAT_ID from
dr$object_attribute where OAT_CLA_ID = 6 and OAT_OBJ_ID = 12 and OAT_NAME =
'SENTENCE_TOKEN_LIMIT');

--remove attribute sentence_token_limit
delete from dr$object_attribute where
oat_cla_id = 6 and
oat_obj_id = 12 and
oat_name in ('SENTENCE_TOKEN_LIMIT');

-- 13431201: Add functional_cache_size
BEGIN
  insert into dr$parameter (par_name, par_value)
    values ('FUNCTIONAL_CACHE_SIZE',  '20971520');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/


--------------------------------------------------------------------
-- CTX_INDEX_VALUES 
--------------------------------------------------------------------

create or replace view ctx_index_values as
select /*+ ORDERED */
       u.name    ixv_index_owner,
       idx_name  ixv_index_name,
       cla_name  ixv_class,
       obj_name  ixv_object,
       oat_name  ixv_attribute,
       decode(oat_datatype, 'B', decode(ixv_value, 1, 'YES', 'NO'),
         nvl(oal_label, ixv_value)) ixv_value
from dr$index,
     sys."_BASE_USER" u,
     dr$index_value,
     dr$object_attribute,
     dr$object,
     dr$class,
     dr$object_attribute_lov
where ixv_value = nvl(oal_value, ixv_value)
  and oat_id = oal_oat_id (+)
  and oat_system = 'N'
  and oat_cla_id = obj_cla_id
  and oat_obj_id = obj_id
  and cla_system = 'N'
  and oat_cla_id = cla_id
  and ixv_oat_id = oat_id
  and idx_id     = ixv_idx_id
  and idx_owner# = u.user#
/

--------------------------------------------------------------------
-- CTX_USER_INDEX_VALUES 
--------------------------------------------------------------------

create or replace view ctx_user_index_values as
select /*+ ORDERED */
       idx_name  ixv_index_name,
       cla_name  ixv_class,
       obj_name  ixv_object,
       oat_name  ixv_attribute,
       decode(oat_datatype, 'B', decode(ixv_value, 1, 'YES', 'NO'),
         nvl(oal_label, ixv_value)) ixv_value
from dr$index,
     dr$index_value,
     dr$object_attribute,
     dr$object,
     dr$class,
     dr$object_attribute_lov
where ixv_value = nvl(oal_value, ixv_value)
  and oat_id = oal_oat_id (+)
  and oat_system = 'N'
  and oat_cla_id = obj_cla_id
  and oat_obj_id = obj_id
  and cla_system = 'N'
  and oat_cla_id = cla_id
  and ixv_oat_id = oat_id
  and idx_id     = ixv_idx_id
  and idx_owner# = userenv('SCHEMAID')
/

-- Increase default value of DEFAULT_INDEX_MEMORY to 64 MB  
update dr$parameter set par_value=67108864 
                    where par_name='DEFAULT_INDEX_MEMORY';

CREATE OR REPLACE PUBLIC SYNONYM ctx_user_index_values FOR
  ctxsys.ctx_user_index_values;
GRANT select ON ctx_user_index_values to public;

REM -------------------------------------------------------------------
REM CTX_INDEX_SECTIONS
REM -------------------------------------------------------------------

PROMPT ... creating view ctx_index_sections

create or replace view ctx_index_sections as
  select idx_name      as isc_idx_name,
         idx_owner     as isc_idx_owner,
         max(sec_type) as isc_sec_type,
     max(nvl(decode(oatid, 240102, sec_name), '')) isc_sec_name,
     max(nvl(decode(oatid, 240103, sec_name), '')) isc_sec_tag,
     max(nvl(decode(oatid, 240105,
                    decode(sec_name, 0, 'N', 1, 'Y')), '')) isc_sec_visible,
     max(nvl(decode(oatid, 240107,
                    decode(sec_name, 2, 'NUMBER', 5, 'VARCHAR2',
                           12, 'DATE', 23, 'RAW', 96, 'CHAR',
                           null)), '')) isc_sec_datatype
  from(
       select c.idx_name idx_name, u.name idx_owner,
              a.ixv_value sec_name, a.ixv_sub_group subg,
              a.ixv_sub_oat_id oatid,
              decode(mod(b.ixv_oat_id, 100), 1, 'ZONE', 2, 'FIELD',
                     3, 'SPECIAL', 4, 'STOP', 5, 'ATTR', 7, 'MDATA',
                     8, 'COLUMN SDATA', 9, 'COLUMN MDATA', 10, 'SDATA',
                     11, 'NDATA', null) sec_type
       from dr$index_value a, dr$index_value b, dr$index c, sys."_BASE_USER" u
       where
                b.ixv_idx_id     = c.idx_id
            and b.ixv_value      = to_char(a.ixv_sub_group)
            and b.ixv_sub_oat_id = 0
            and b.ixv_sub_group  = 0
            and c.idx_owner#     = u.user#
      )
  group by subg, idx_name, idx_owner
  order by isc_idx_name, isc_sec_type;

create or replace public synonym CTX_INDEX_SECTIONS for
  CTXSYS.CTX_INDEX_SECTIONS;
grant select on CTX_INDEX_SECTIONS to PUBLIC;

REM -------------------------------------------------------------------
REM  CTX_USER_INDEX_SECTIONS
REM -------------------------------------------------------------------

PROMPT ... creating view ctx_user_index_sections

create or replace view ctx_user_index_sections as
  select idx_name      isc_idx_name,
         max(sec_type) isc_sec_type,
         max(nvl(decode(oatid, 240102, sec_name), '')) isc_sec_name,
         max(nvl(decode(oatid, 240103, sec_name), '')) isc_sec_tag,
         max(nvl(decode(oatid, 240105,
                    decode(sec_name, 0, 'N', 1, 'Y')), '')) isc_sec_visible,
         max(nvl(decode(oatid, 240107,
                        decode(sec_name, 2, 'NUMBER', 5, 'VARCHAR2',
                               12, 'DATE', 23, 'RAW', 96, 'CHAR',
                               null)), '')) isc_sec_datatype
  from(
       select c.idx_name idx_name, c.idx_owner#, a.ixv_value sec_name,
              a.ixv_sub_group subg, a.ixv_sub_oat_id oatid,
              decode(mod(b.ixv_oat_id, 100), 1, 'ZONE', 2, 'FIELD',
                     3, 'SPECIAL', 4, 'STOP', 5, 'ATTR', 7, 'MDATA',
                     8, 'COLUMN SDATA', 9, 'COLUMN MDATA', 10, 'SDATA',
                     11, 'NDATA', null) sec_type
       from dr$index_value a, dr$index_value b, dr$index c
       where
              b.ixv_value      = to_char(a.ixv_sub_group)
          and b.ixv_sub_oat_id = 0
          and b.ixv_sub_group  = 0
          and b.ixv_idx_id     = c.idx_id
          and c.idx_owner#     = userenv('SCHEMAID')
      )
  group by subg, idx_name, idx_owner#
  order by isc_idx_name, isc_sec_type;

create or replace public synonym CTX_USER_INDEX_SECTIONS for
  CTXSYS.CTX_USER_INDEX_SECTIONS;
grant select on CTX_USER_INDEX_SECTIONS to PUBLIC;

REM -------------------------------------------------------------------
REM  14038163: a_index_clause and f_index_clause
REM -------------------------------------------------------------------

BEGIN
  insert into dr$object_attribute values
    (90130, 9, 1, 30, 'A_INDEX_CLAUSE', '', 'N', 'N', 'Y', 'S', 
    'NONE', null, 500, 'N');
EXCEPTION
  WHEN dup_val_on_index THEN
    NULL;
END;
/

BEGIN
  insert into dr$object_attribute values
    (90131, 9, 1, 31, 'F_INDEX_CLAUSE', '', 'N', 'N', 'Y', 'S', 
     'NONE', null, 500, 'N');
EXCEPTION
  WHEN dup_val_on_index THEN
    NULL;
END;
/

commit;

REM -------------------------------------------------------------------
REM  14459127 recreate procedure syncrn
REM -------------------------------------------------------------------

create or replace procedure syncrn (
  ownid IN binary_integer,
  oname IN varchar2,
  idxid IN binary_integer,
  ixpid IN binary_integer,
  rtabnm IN varchar2,
  srcflg IN binary_integer,
  smallr IN binary_integer       
)
  authid definer
  as external
  name "comt_cb"
  library dr$lib
  with context
  parameters(
    context,
    ownid  ub4,
    oname  OCISTRING,
    idxid  ub4,
    ixpid  ub4,
    rtabnm OCISTRING,
    srcflg ub1,
    smallr ub1
);
/

REM -------------------------------------------------------------------
REM Bug  13640676 
REM -------------------------------------------------------------------

DECLARE
  sql_q VARCHAR2(200);
BEGIN
  -- 20741195: Restrict to objects of type TABLE
  FOR rec IN (SELECT a.object_name, a.object_type, a.owner
                FROM all_objects a, all_tab_columns c
                WHERE a.object_name LIKE 'DR$%$I'
                  AND a.object_type = 'TABLE'
                  AND a.object_name = c.table_name
                  AND c.column_name = 'TOKEN_TYPE') LOOP
    sql_q := 'ALTER TABLE ' || rec.owner || '.' || rec.object_name || 
             '  MODIFY (token_type NUMBER(10))';
    EXECUTE IMMEDIATE sql_q;
  END LOOP;
END;
/

declare 
sql_q varchar2(100);
begin
FOR r in (select idx_id , idx_option from dr$index)
LOOP
 if(r.idx_option='P') then
  sql_q:= 'update dr$index set idx_option=''PY'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 /* Bug 14254610 - Index optimization in rebuild mode fails with ORA-14097 
    after 11.2.0.3 DB upgrade */
 elsif(r.idx_option='C') then
  sql_q:= 'update dr$index set idx_option=''CY'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 elsif(r.idx_option='TQ') then
  sql_q:= 'update dr$index set idx_option=''TQY'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 elsif(r.idx_option='QT') then
  sql_q:= 'update dr$index set idx_option=''QTY'' where idx_id='||r.idx_id;
  execute immediate(sql_q); 
 elsif(r.idx_option is null) then
  sql_q:= 'update dr$index set idx_option=''Y'' where idx_id=' ||r.idx_id;
  execute immediate(sql_q);
 end if;
END LOOP;
END;
/

REM -------------------------------------------------------------------
REM lrg 18241069
REM -------------------------------------------------------------------

grant create sequence to ctxapp;

@?/rdbms/admin/sqlsessend.sql
