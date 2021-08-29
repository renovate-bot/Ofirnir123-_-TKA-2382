Rem
Rem $Header: ctx_src_2/src/dr/admin/u1100000.sql /main/26 2018/07/25 13:49:07 surman Exp $
Rem
Rem u1100000.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1100000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      upgrade ctxsys from 11.0.0.X to 11.2.0.1
Rem
Rem    NOTES
Rem      This script upgrades a 11.0.0.X ctxsys data dictionary to 11.2.0.1  
Rem      This script should be run as ctxsys on an 11.0.0.X ctxsys schema
Rem      (or as SYS with ALTER SESSION SET SCHEMA = CTXSYS)
Rem      No other users or schema versions are supported.
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1100000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1100000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    boxia       01/21/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    yiqi        12/12/12 - Bug 15960782
Rem    rpalakod    04/30/10 - Split off 11.2.0.1 to 11.2.0.2 changes
Rem    rkadwe      04/04/10 - Document Level Lexer
Rem    ssethuma    03/30/10 - XbranchMerge ssethuma_bug-9048930 from main
Rem    nenarkhe    08/25/09 - ctx_tree
Rem    rpalakod    08/17/09 - Bug 8809055
Rem    rpalakod    08/11/09 - dup_val_on_index
Rem    rpalakod    08/09/09 - autooptimize
Rem    rpalakod    02/18/09 - change name of near_realtime
Rem    rpalakod    02/05/09 - nrtidx api
Rem    nenarkhe    01/22/09 - mvdata section
Rem    rpalakod    01/07/09 - separate_offsets
Rem    rpalakod    01/05/09 - big io
Rem    igeller     10/07/08 - bug 7353283, add bigram japanese lexer attribute
Rem    shorwitz    06/18/08 - Bug 4198410: Add new languages
Rem    rpalakod    02/06/08 - Bug 6798472: ent-ext views show all users data
Rem    rpalakod    01/22/08 - Reduce maximum entity length to 512
Rem    rpalakod    01/12/08 - Entity Extraction
Rem    wclin       09/27/07 - allow special section in auto section group
Rem    gkaminag    10/10/05 - gkaminag_fixlrg_051010
Rem    gkaminag    10/10/05 - Created
Rem

REM
REM  IF YOU ADD ANYTHING TO THIS FILE REMEMBER TO CHANGE DOWNGRADE SCRIPT
REM

REM ===================================================================
REM Bug 9048930
REM ===================================================================


update dr$index_cdi_column
  set cdi_column_name = '"' || cdi_column_name || '"'
    where regexp_instr(cdi_column_name, '^["](.+)["]$') != 1;
commit;

REM ========================================================================
REM ALOW SPECIAL SECTION FOR AUTO_SECTION_GROUP 
REM ======================================================================== 
begin
insert into dr$object_attribute values
  (50703, 5, 7, 3, 
   'SPECIAL', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/

REM ========================================================================
REM Enable bigram preference attribute for Japanese Lexer
REM ========================================================================
begin
insert into dr$object_attribute values
  (60210, 6, 2, 10, 
   'BIGRAM', 'Use a bigram lexer',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/

REM ========================================================================
REM Enable big_io preference attribute for basic_storage
REM ========================================================================
begin
insert into dr$object_attribute values
  (90110, 9, 1, 10,
   'BIG_IO', null,
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/

REM ========================================================================
REM Enable separate_offsets preference attribute for basic_storage
REM ========================================================================
begin
insert into dr$object_attribute values
  (90111, 9, 1, 11,
   'SEPARATE_OFFSETS', null,
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/


REM ========================================================================
REM Enable $M storage clause preference attribute for basic_storage
REM ========================================================================
begin
insert into dr$object_attribute values
  (90112, 9, 1, 12,
   'MV_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (50212, 5, 2, 12, 
   'MVDATA', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (50312, 5, 3, 12, 
   'MVDATA', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (50512, 5, 5, 12, 
   'MVDATA', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/

REM ========================================================================
REM Enable near_realtime preference attribute for basic_storage
REM ========================================================================
begin
insert into dr$object_attribute values
  (90113, 9, 1, 13,
   'STAGE_ITAB', null,
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (90114, 9, 1, 14,
   'G_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90115, 9, 1, 15,
   'G_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

commit;
exception
when dup_val_on_index then
  null;
end;
/


REM ========================================================================
REM ENTITY EXTRACTION 
REM ======================================================================== 

begin
insert into dr$object values
  (9, 4, 'ENTITY_STORAGE', 'entity extraction storage', 'N');

insert into dr$object_attribute values
  (90401, 9, 4, 1, 
   'INCLUDE_DICTIONARY', 'include oracle supplied dictionary',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (90402, 9, 4, 2, 
   'INCLUDE_RULES', 'include oracle supplied rules',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/


begin
  dr$temp_crepref('ENTITY_STORAGE_DR', 'ENTITY_STORAGE');
  dr$temp_setatt('ENTITY_STORAGE_DR', 'INCLUDE_DICTIONARY','1');
  dr$temp_setatt('ENTITY_STORAGE_DR', 'INCLUDE_RULES','1');

  dr$temp_crepref('ENTITY_STORAGE_D', 'ENTITY_STORAGE');
  dr$temp_setatt('ENTITY_STORAGE_D', 'INCLUDE_DICTIONARY','1');
  dr$temp_setatt('ENTITY_STORAGE_D', 'INCLUDE_RULES','0');

  dr$temp_crepref('ENTITY_STORAGE_R', 'ENTITY_STORAGE');
  dr$temp_setatt('ENTITY_STORAGE_R', 'INCLUDE_DICTIONARY','0');
  dr$temp_setatt('ENTITY_STORAGE_R', 'INCLUDE_RULES','1');

  dr$temp_crepref('ENTITY_STORAGE', 'ENTITY_STORAGE');
  dr$temp_setatt('ENTITY_STORAGE', 'INCLUDE_DICTIONARY','0');
  dr$temp_setatt('ENTITY_STORAGE', 'INCLUDE_RULES','0');

  dr$temp_crepref('DEFAULT_EXTRACT_LEXER', 'AUTO_LEXER');
  dr$temp_setatt('DEFAULT_EXTRACT_LEXER', 'ALTERNATE_SPELLING', '0');
  dr$temp_setatt('DEFAULT_EXTRACT_LEXER', 'BASE_LETTER', '0');
  dr$temp_setatt('DEFAULT_EXTRACT_LEXER', 'MIXED_CASE', '1');
end;
/

begin
  insert into dr$parameter (par_name, par_value)
  values ('DEFAULT_EXTRACT_LEXER', 'CTXSYS.DEFAULT_EXTRACT_LEXER');
commit;
exception
when dup_val_on_index then
  null;
end;
/

REM Entity Extraction Tables and Views
REM entity extraction upgrade is also run in u1002000.sql so we need to 
REM catch duplicate errors

declare
  errnum number;
begin
  execute immediate('
create table dr$user_extract_rule(
  erl_pol_id number(38),
  erl_rule_id integer, 
  erl_language varchar2(30), 
  erl_rule varchar2(512), 
  erl_modifier varchar2(8), 
  erl_type varchar2(4000), 
  erl_status number, 
  erl_comments varchar2(4000), 
  primary key (erl_pol_id, erl_rule_id))');
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

declare
  errnum number;
begin
  execute immediate('
  create table dr$user_extract_stop_entity(
   ese_pol_id number(38),
   ese_name varchar2(512),
   ese_type varchar2(30),
   ese_status number,
   ese_comments varchar2(4000),
   unique (ese_pol_id, ese_name, ese_type))');
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


declare
  errnum number;
begin
  execute immediate('
  create table dr$user_extract_entdict (
  eed_polid number,
  eed_entid number,
  eed_lang varchar2(30),
  eed_mention varchar2(512),
  eed_type varchar2(3000),
  eed_normid number,
  eed_altcnt number,
  eed_status number,
  primary key (eed_polid, eed_entid, eed_normid))');

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

declare
  errnum number;
begin
  execute immediate('
  create table dr$user_extract_tkdict (
  etd_polid number,
  etd_txt varchar2(128),
  etd_soe number,
  etd_eoe number,
  etd_bigram number,
  etd_status number,
  primary key (etd_polid, etd_txt))');

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


create or replace view drv$user_extract_rule as
select * from dr$user_extract_rule
where erl_pol_id = SYS_CONTEXT('DR$APPCTX', 'IDXID')
with check option;

grant select, insert, update, delete  on drv$user_extract_rule to public;

create or replace view ctx_user_extract_rules as
select
  i.idx_name erl_policy_name,
  e.erl_rule_id erl_rule_id,
  e.erl_language erl_language,
  e.erl_rule erl_rule,
  e.erl_modifier erl_modifier,
  e.erl_type erl_type,
  decode(e.erl_status,
         0,'not compiled',
         1, 'to be deleted',
         2, 'compiled') erl_status,
  e.erl_comments erl_comments
  from dr$user_extract_rule e, dr$index i
where i.idx_owner# = userenv('SCHEMAID')
  and e.erl_pol_id = i.idx_id; 


create or replace public synonym ctx_user_extract_rules 
for ctxsys.ctx_user_extract_rules;
grant select on ctx_user_extract_rules to public;


create or replace view drv$user_extract_stop_entity as
select * from dr$user_extract_stop_entity
where ese_pol_id = SYS_CONTEXT('DR$APPCTX', 'IDXID')
with check option;

grant select,insert,update,delete on drv$user_extract_stop_entity to public;

create or replace view ctx_user_extract_stop_entities as
select
  i.idx_name        ese_policy_name,
  e.ese_name        ese_name,
  e.ese_type        ese_type,
  decode(e.ese_status,
         0,'not compiled',
         1, 'to be deleted',
         2, 'compiled',
         3, 'subset') ese_status,
  e.ese_comments    ese_comments
  from dr$user_extract_stop_entity e, dr$index i
where i.idx_owner# = userenv('SCHEMAID')
  and e.ese_pol_id = i.idx_id;


create or replace public synonym ctx_user_extract_stop_entities
for ctxsys.ctx_user_extract_stop_entities;
grant select on ctx_user_extract_stop_entities to public;

create or replace view drv$user_extract_tkdict as
select * from dr$user_extract_tkdict
where etd_polid = SYS_CONTEXT('DR$APPCTX', 'IDXID')
with check option; 

grant select, insert, update, delete on drv$user_extract_tkdict to public;

create or replace view drv$user_extract_entdict as
select * from dr$user_extract_entdict
where eed_polid = SYS_CONTEXT('DR$APPCTX', 'IDXID')
with check option;

grant select, insert, update, delete on drv$user_extract_entdict to public;

create or replace view ctx_extract_policies as
select
  i.idx_name epl_name,
  u.name     epl_owner
  from dr$index i, sys."_BASE_USER" u
  where INSTR(i.idx_option, 'E') > 0
    and i.idx_owner# = u.user#;

create or replace view ctx_extract_policy_values as
select /*+ ORDERED */
  idx_name epv_policy_name,
  u.name epv_policy_owner,
  cla_name epv_class,
  obj_name epv_object,
  oat_name epv_attribute,
  decode(oat_datatype, 'B', decode(ixv_value, 1, 'YES', 'NO'),
    nvl(oal_label, ixv_value)) epv_value
from dr$index,
     sys."_BASE_USER" u,
     dr$index_value,
     dr$object_attribute,
     dr$object,
     dr$class,
     dr$object_attribute_lov
where ixv_sub_group = 0
  and ixv_value = nvl(oal_value, ixv_value)
  and oat_id = oal_oat_id (+)
  and oat_system = 'N'
  and oat_cla_id = obj_cla_id
  and oat_obj_id = obj_id
  and (cla_name = 'STORAGE' or cla_name = 'LEXER')
  and cla_system = 'N'
  and oat_cla_id = cla_id
  and ixv_oat_id = oat_id
  and idx_id     = ixv_idx_id
  and idx_owner# = u.user#
  and  INSTR(idx_option, 'E') > 0;

create or replace view ctx_user_extract_policies as
select
  i.idx_name epl_name
  from dr$index i
  where INSTR(i.idx_option, 'E') > 0
    and i.idx_owner# = userenv('SCHEMAID');

create or replace public synonym ctx_user_extract_policies
for ctxsys.ctx_user_extract_policies;
grant select on ctx_user_extract_policies to public;

create or replace view ctx_user_extract_policy_values as
select /*+ ORDERED */
  idx_name epv_policy_name,
  cla_name epv_class,
  obj_name epv_object,
  oat_name epv_attribute,
  decode(oat_datatype, 'B', decode(ixv_value, 1, 'YES', 'NO'),
    nvl(oal_label, ixv_value)) epv_value
from dr$index,
     dr$index_value,
     dr$object_attribute,
     dr$object,
     dr$class,
     dr$object_attribute_lov
where ixv_sub_group = 0
  and ixv_value = nvl(oal_value, ixv_value)
  and oat_id = oal_oat_id (+)
  and oat_system = 'N'
  and oat_cla_id = obj_cla_id
  and oat_obj_id = obj_id
  and (cla_name = 'STORAGE' or cla_name = 'LEXER')
  and cla_system = 'N'
  and oat_cla_id = cla_id
  and ixv_oat_id = oat_id
  and idx_id     = ixv_idx_id
  and idx_owner# = userenv('SCHEMAID')
  and  INSTR(idx_option, 'E') > 0;


create or replace public synonym ctx_user_extract_policy_values
for ctxsys.ctx_user_extract_policy_values;
grant select on ctx_user_extract_policy_values to public;

/

REM =======================================================================
REM Add new language names
REM =======================================================================

begin
insert into dr$object_attribute_lov values
  (60117, 'ASSAMESE', 47, 'Assamese');

insert into dr$object_attribute_lov values
  (60117, 'CYRILLIC_KAZAKH', 48, 'Cyrillic Kazakh');

insert into dr$object_attribute_lov values
  (60117, 'CYRILLIC_SERBIAN', 49, 'Cyrillic Serbian');

insert into dr$object_attribute_lov values
  (60117, 'CYRILLIC_UZBEK', 50, 'Cyrillic Uzbek');

insert into dr$object_attribute_lov values
  (60117, 'GUJARATI', 51, 'Gujarati');

insert into dr$object_attribute_lov values
  (60117, 'HINDI', 52, 'Hindi');

insert into dr$object_attribute_lov values
  (60117, 'KANNADA', 53, 'Kannada');

insert into dr$object_attribute_lov values
  (60117, 'LATIN_SERBIAN', 54, 'Latin Serbian');

insert into dr$object_attribute_lov values
  (60117, 'LATIN_UZBEK', 55, 'Latin Uzbek');

insert into dr$object_attribute_lov values
  (60117, 'MACEDONIAN', 56, 'Macedonian');

insert into dr$object_attribute_lov values
  (60117, 'MALAYALAM', 57, 'Malayalam');

insert into dr$object_attribute_lov values
  (60117, 'MARATHI', 58, 'Marathi');

insert into dr$object_attribute_lov values
  (60117, 'ORIYA', 59, 'Oriya');

insert into dr$object_attribute_lov values
  (60117, 'PUNJABI', 60, 'Punjabi');

insert into dr$object_attribute_lov values
  (60117, 'TAMIL', 61, 'Tamil');

insert into dr$object_attribute_lov values
  (60117, 'TELUGU', 62, 'Telugu');

commit;

exception
when dup_val_on_index then
  null;
end;
/

REM ===================================================================
REM WILDCARD_MAXTERMS
REM ===================================================================

update dr$object_attribute
  set oat_val_min = 0
  where oat_id = 70106;
commit;

REM ===================================================================
REM Drop types
REM ===================================================================

drop type dr$itab_set_t force;
drop type dr$itab_t force;

drop type dr$itab0_set_t force;
drop type dr$itab0_t force;

drop type dr$opttf_impl_t force;

commit;
