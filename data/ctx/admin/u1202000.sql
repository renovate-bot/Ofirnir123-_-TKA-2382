Rem
Rem $Header: ctx_src_2/src/dr/admin/u1202000.sql /main/50 2018/08/13 10:38:58 rodfuent Exp $
Rem
Rem u1202000.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1202000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade from 12.1.0.2 to 12.2.0.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1202000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1202000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    rodfuent    08/09/18 - LRG 21480965: mismatch between upgrade/install
Rem    aczarlin    08/16/17 - modify SQL_PHASE so file passes RCCS check
Rem    ataracha    12/14/16 - call ctxview122.sql before revoke/grant on views
Rem    boxia       12/12/16 - change the call of ctxview.sql to ctxview122.sql
Rem    boxia       09/08/16 - Bug 24656765: fwd merge boxia_b24590462_12201
Rem                           from st_ctx_12.2.0.1.0
Rem    nspancha    09/08/16 - Bug24607832:Checking 240110 Optim For values >= 1
Rem    rkadwe      08/29/16 - XbranchMerge rkadwe_bug-24427155 from
Rem                           st_ctx_12.2.0.1.0
Rem    nspancha    08/03/16 - Adding default basic lexers as required by JSON
Rem    nspancha    07/20/16 - Bug 19546649 - Correcting optimized_for values
Rem    nspancha    07/06/16 - Bug 23501267: Security vulnerability
Rem    boxia       06/30/16 - Bug 23732847: remove duplicate rows and add
Rem                           unique constraint for dr$section_group_attribute
Rem    nspancha    05/30/16 - Bug 23345024: Fixing upgrade SDATA queries
Rem    nspancha    05/20/16 - Reverting range_search back to support JSON types
Rem    yinlu       05/05/16 - bug 23104534: remove 90132 as it exists in 12.1
Rem    aczarlin    04/13/16 - bug 23091665 max_row
Rem    nspancha    04/08/16 - Bug 22267587:Removing CTXSYS & fixing rangesearch
Rem    aczarlin    04/06/16 - bug 23062671 dup vals for PKVAL,SENTIMENT
Rem    nspancha    12/22/15 - Bug 22445358:Replacing select with read privelege
Rem    nspancha    12/02/15 - Bug 22267587 - Json index creation fails due to
Rem                           defaults not set properly
Rem    rkadwe      10/23/15 - bug 22086644
Rem    shuroy      10/21/15 - Adding NUM_ITERATIONS attribute
Rem    rkadwe      09/23/15 - Bug 21701234
Rem    rkadwe      08/05/15 - READ privilege instead of SELECT
Rem    aczarlin    08/07/15 - bug 21562436 ctxagg parallel
Rem    boxia       07/10/15 - Lrg 16100415: idx_opt 's',sortable SDATA metadata
Rem    shuroy      05/27/15 - Bug 20475880: long identifier upgrade changes
Rem    shuroy      05/13/15 - Bug 21086558: Adding U_TABLE_CLAUSE
Rem    rkadwe      04/21/15 - Alter index for simple syntax
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rkadwe      01/23/15 - dataguide changed datatype, add TEXT
Rem    boxia       12/05/14 - Add PRINTJOINS, SKIPJOINS for World lexer
Rem    shuroy      12/04/14 - MultiColumn Datastore changes
Rem    shuroy      11/10/14 - Adding SENTIMENT_CLASSIFIER preference
Rem    gauryada    03/19/14 - Fix RANGE_SEARCH_ENABLE
Rem    gauryada    03/14/14 - Fix exception check
Rem    rkadwe      03/10/14 - more index options
Rem    zliu        02/17/14 - add BSON_ENABLE
Rem    zliu        02/02/14 - fix bug 1817966 use range_search_enable
Rem    boxia       11/26/13 - Add S*_TABLE/INDEX_CLAUSE, 
Rem                           xml_save_copy & xml_forward_enable
Rem    shuroy      11/07/13 - Fusion Security Project: PKVAL section attribute
Rem    boxia       11/04/13 - Bug 17635127: mv PJ&SJ part to u1201020.sql 
Rem    hsarkar     12/16/11 - Asynchronous update project
Rem    zliu        10/20/13 - add xml_structure_enable
Rem    zliu        10/01/13 - json path section support for 12.2
Rem    boxia       09/25/13 - Add attribute OPTIMIZED_FOR
Rem    boxia       09/05/13 - boxia_printskipjoins: add PRINTJOINS, SKIPJOINS
Rem                           for Japanese_Vgram_lexer
Rem    boxia       09/05/13 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Bug 24590462
grant select on SYS."_BASE_USER" to ctxsys with grant option;

-- Remove duplicate rows in dr$section_group_attribue
begin
  delete from dr$section_group_attribute sga_a
   where sga_a.rowid >
         any (select sga_b.rowid from dr$section_group_attribute sga_b
               where sga_a.sga_id = sga_b.sga_id
                 and sga_a.sga_sgat_id = sga_b.sga_sgat_id
             );
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/

commit;

-- add unique constraint to dr$section_group_attribute
alter table dr$section_group_attribute
  add constraint drc$sga_uniqe unique (sga_id, sga_sgat_id);

----------------------------------------------------------------------
-- SDATA: rm attr SORTABLE & SEARCHABLE, add attr OPTIMIZED_FOR
----------------------------------------------------------------------
-- Remove sortable & searchable
delete from dr$object_attribute
  where oat_id=240110 and oat_cla_id=24 and oat_obj_id=1 and oat_att_id=10
    and oat_name='SEARCHABLE';

delete from dr$object_attribute
  where oat_id=240111 and oat_cla_id=24 and oat_obj_id=1 and oat_att_id=11
    and oat_name='SORTABLE';

commit;

-- Add optimized_for
begin
insert into dr$object_attribute values
  (240110, 24, 1, 10,
   'OPTIMIZED_FOR', 'SDATA operations to be optimized for',
   'N', 'N', 'Y', 'I',
   'SORT', null, null, 'Y');

insert into dr$object_attribute_lov values
  (240110, 'NONE', 0, 'None');

insert into dr$object_attribute_lov values
  (240110, 'SORT', 1, 'Sortable');

insert into dr$object_attribute_lov values
  (240110, 'SEARCH', 2, 'Seachable');

insert into dr$object_attribute_lov values
  (240110, 'SORT_AND_SEARCH', 3, 'Sortable and searchable');

commit;
exception
when dup_val_on_index then
  null;
end;
/

------------------------------------------------------------------------
-- bug 23104534: 
-- QUERY_FACET_PIN_PERM was 90132 in 12.1 and changed to 90150 in 12.2
------------------------------------------------------------------------
BEGIN

delete from dr$object_attribute
where OAT_ID=90132 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=32 
and OAT_NAME='QUERY_FACET_PIN_PERM';

commit;
END;
/

----------------------------------------------------------------------
-- SDATA: add S*_TABLE_CLAUSE & S*_INDEX_CLAUSE
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90132, 9, 1, 32,
   'SV_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90133, 9, 1, 33,
   'SV_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90134, 9, 1, 34,
   'SD_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90135, 9, 1, 35,
   'SD_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90136, 9, 1, 36,
   'SR_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90137, 9, 1, 37,
   'SR_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90138, 9, 1, 38,
   'SBF_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90139, 9, 1, 39,
   'SBF_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90140, 9, 1, 40,
   'SBD_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90141, 9, 1, 41,
   'SBD_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90142, 9, 1, 42,
   'ST_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90143, 9, 1, 43,
   'ST_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90144, 9, 1, 44,
   'STZ_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90145, 9, 1, 45, 
   'STZ_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
   
insert into dr$object_attribute values
  (90146, 9, 1, 46, 
   'SIYM_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
   
insert into dr$object_attribute values
  (90147, 9, 1, 47, 
   'SIYM_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
   
insert into dr$object_attribute values
  (90148, 9, 1, 48, 
   'SIDS_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
   
insert into dr$object_attribute values
  (90149, 9, 1, 49, 
   'SIDS_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90150, 9, 1, 50,
   'QUERY_FACET_PIN_PERM', '',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

commit;
EXCEPTION
when dup_val_on_index then
  null;
END;
/

----------------------------------------------------------------------
-- SDATA: add storage attribute xml_save_copy & xml_forward_enable
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90151, 9, 1, 51,
   'XML_SAVE_COPY', '',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (90152, 9, 1, 52,
   'XML_FORWARD_ENABLE', '',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

commit;
EXCEPTION
when dup_val_on_index then
  null;
END;
/

----------------------------------------------------------------------
-- RANGE_ENABLE support
-- for xml enabled text index and json enabled text index
-- added in dr0obj.txt, generated in ctxobj.sql as 50818
-- 18 is defined in drn.c, 50818 is referenced in drisgp.pkb
----------------------------------------------------------------------
BEGIN
   insert into dr$object_attribute values
   (50818, 5, 8, 18, 
    'RANGE_SEARCH_ENABLE', 'support range value search query',
    'N', 'N', 'Y', 'S', 
    'NONE', null, null, 'N');
    commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/  

----------------------------------------------------------------------
-- SDATA: add default preferences and default section group
----------------------------------------------------------------------
BEGIN
  dr$temp_crepref('XQFT_LOW', 'BASIC_STORAGE');
  dr$temp_setatt('XQFT_LOW', 'xml_save_copy', '0');
  dr$temp_setatt('XQFT_LOW', 'xml_forward_enable', '0');

  dr$temp_crepref('XQFT_MEDIUM', 'BASIC_STORAGE');
  dr$temp_setatt('XQFT_MEDIUM', 'xml_save_copy', '1');
  dr$temp_setatt('XQFT_MEDIUM', 'xml_forward_enable', '0');

  dr$temp_crepref('XQFT_HIGH', 'BASIC_STORAGE');
  dr$temp_setatt('XQFT_HIGH', 'xml_save_copy', '1');
  dr$temp_setatt('XQFT_HIGH', 'xml_forward_enable', '1');
  
  -- Default lexer settings for JSON search index
  dr$temp_crepref('JSON_DEFAULT_LEXER', 'BASIC_LEXER');
  dr$temp_setatt('JSON_DEFAULT_LEXER', 'mixed_case', '0');
  dr$temp_setatt('JSON_DEFAULT_LEXER', 'base_letter', '1');
  dr$temp_setatt('JSON_DEFAULT_LEXER', 'index_themes', '0');

  -- Default settings for JSON search group
  dr$temp_cresg('JSON_SEARCH_GROUP', 'PATH_SECTION_GROUP');
  dr$temp_setsecgrpatt('JSON_SEARCH_GROUP', 'json_enable', '1');
  dr$temp_setsecgrpatt('JSON_SEARCH_GROUP', 'range_search_enable','all');

  dr$temp_cresg('XQUERY_SEC_GROUP', 'PATH_SECTION_GROUP');
  dr$temp_setsecgrpatt('XQUERY_SEC_GROUP', 'xml_enable', '1');
  dr$temp_setsecgrpatt('XQUERY_SEC_GROUP', 'range_search_enable','all');

  dr$temp_cresg('BSON_SECTION_GROUP', 'PATH_SECTION_GROUP');
  dr$temp_setsecgrpatt('BSON_SECTION_GROUP', 'bson_enable', '1');
  
END;
/

----------------------------------------------------------------------
-- JSON_ENABLE support
-- for JSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50817
-- 17 is defined in drn.c, 50817 is referenced in drisgp.pkb
----------------------------------------------------------------------
BEGIN
  insert into dr$object_attribute values
  (50817, 5, 8, 17, 
   'JSON_ENABLE', 'json aware path section group',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
  commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/  


----------------------------------------------------------------------
-- BSON_ENABLE support
-- for BSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50819
-- 19 is defined in drn.c, 50819 is referenced in drisgp.pkb
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50819, 5, 8, 19,
   'BSON_ENABLE', 'bson aware path section group',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
    commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/  

-------------------------------------------------------------------------
--- dr$delete
-------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$delete add del_updated char(1) default ' ||
  dbms_assert.enquote_literal('N'));
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
--- drv$delete
-------------------------------------------------------------------------
CREATE OR REPLACE VIEW drv$delete as
select * from dr$delete;

grant select on drv$delete to public;

-------------------------------------------------------------------------
--- drv$delete2
-------------------------------------------------------------------------
CREATE OR REPLACE VIEW drv$delete2 as
select * from dr$delete
where del_idx_id = SYS_CONTEXT('DR$APPCTX','IDXID')
with check option;

grant insert on drv$delete2 to public;

--------------------------------------------------------------------------
--- PKVAL Section Attribute for Filter Section
--------------------------------------------------------------------------

BEGIN
insert into dr$object_attribute values
  (240111, 24, 1, 11,
   'PKVAL', 'Is mdata section defined for pk values',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

----------------------------------------------------------------------
--- Dataguide
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50820, 5, 8, 20,
   'DATAGUIDE', 'generate dataguide view',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

----------------------------------------------------------------------
--- Text
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50821, 5, 8, 21,
   'TEXT', 'full text indexing',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

----------------------------------------------------------------------
--- alter_index_transition
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50822, 5, 8, 22,
   'ALTER_INDEX_TRANSITION', 'alter index transition info',
   'N', 'N', 'Y', 'I',
   'NONE', null, null, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

--------------------------------------------------------------------------
--- Increase the number of index options to 64 in 12.2
--------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_option varchar2(64)');
exception
  when others then
    null;
end;
/
---------------------------------------------------------------------------
--- Sentiment Analysis
---------------------------------------------------------------------------

BEGIN
insert into dr$object values
  (12, 3, 'SENTIMENT_CLASSIFIER', 'SVM classifier for sentiment analysis', 'N');

insert into dr$object_attribute values
  (120301, 12, 3, 1,
   'MAX_DOCTERMS', 'Maximun number of distinct terms representing one document',
   'N', 'N', 'Y', 'I',
   '50', 10, 8192, 'N');

insert into dr$object_attribute values
  (120302, 12, 3, 2,
   'MAX_FEATURES', 'Maximun number of distinct features used in text mining',
   'N', 'N', 'Y', 'I',
   '3000', 1, 100000, 'N');

insert into dr$object_attribute values
  (120303, 12, 3, 3,
   'THEME_ON', 'Theme feature',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (120304, 12, 3, 4,
   'TOKEN_ON', 'Token feature',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (120305, 12, 3, 5,
   'STEM_ON', 'Stemmed Token feature',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (120306, 12, 3, 6,
   'MEMORY_SIZE', 'Typical memory size in MB',
   'N', 'N', 'Y', 'I',
   '500', 10, 4000, 'N');

insert into dr$object_attribute values
  (120307, 12, 3, 7,
   'SECTION_WEIGHT', 'the multiplier of term occurrence within field section',
   'N', 'N', 'Y', 'I',
   '2', 0, 100, 'N');

insert into dr$object_attribute values
  (120308, 12, 3, 8,
   'NUM_ITERATIONS', 'max number of iterations to run svm training algorithm',
   'N', 'N', 'Y', 'I',
   '600', 0, 1000, 'N');

commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

begin
  dr$temp_crepref('DEFAULT_SENT_CLASSIFIER','SENTIMENT_CLASSIFIER');
end;
/

BEGIN
insert into dr$parameter (par_name, par_value)
         values ('DEFAULT_SENT_CLASSIFIER', 'CTXSYS.DEFAULT_SENT_CLASSIFIER');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/


-------------------------------------------------------------------------
-- Adding NUM_ITERATIONS to SVM_CLASSIFIER in 12.2
-------------------------------------------------------------------------
begin
insert into dr$object_attribute values
  (120208, 12, 2, 8,
   'NUM_ITERATIONS', 'max number of iterations to run svm training algorithm',
   'N', 'N', 'Y', 'I',
   '500', 0, 1000, 'N');
commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/
--------------------------------------------------------------------------
--- Increase prv_value to varchar2(4000) in 12.2
--------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$preference_value  modify prv_value varchar2(4000)');
exception
  when others then
    null;
end;
/

--------------------------------------------------------------------------
--- Increase ixv_value to varchar2(4000) in 12.2
--------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_value  modify ixv_value varchar2(4000)');
exception
  when others then
    null;
end;
/
----------------------------------------------------------------------------
--- Increase COLUMNS attribute of MULTI_COLUMN_DATASTORE to varchar2(4000)
----------------------------------------------------------------------------

BEGIN
update dr$object_attribute
set oat_val_max = 4000
where oat_id = 10701 and oat_name = 'COLUMNS';
END;
/
commit;

----------------------------------------------------------------------
-- Printjoins & Skipjoins for WORLD_LEXER 
----------------------------------------------------------------------
begin
insert into dr$object_attribute values
  (61102, 6, 11, 2,
   'PRINTJOINS', 'Characters which join words together',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61103, 6, 11, 3,
   'SKIPJOINS', 'Non-printing join characters',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

commit;
exception
when dup_val_on_index then
  null;
end;
/
-------------------------------------------------------------------------
-- U_TABLE_CLAUSE
-------------------------------------------------------------------------

begin
insert into dr$object_attribute values
  (90154, 9, 1, 54,
   'U_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/

--------------------------------------------------------------------------
-- Single Byte Index Option
--------------------------------------------------------------------------

begin
insert into dr$object_attribute values
  (90153, 9, 1, 53,
   'SINGLE_BYTE', '',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
commit;
exception
when dup_val_on_index then
  null;
end;
/
--------------------------------------------------------------------------
-- Long Identifier Upgrade Changes for CTX objects
--------------------------------------------------------------------------
-- dr$parameter
declare
  errnum number;
begin
  execute immediate('
  alter table dr$parameter modify par_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$class
declare
  errnum number;
begin
  execute immediate('
  alter table dr$class modify cla_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$object
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object modify obj_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$object_attribute
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object_attribute modify oat_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$object_attribute_lov
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object_attribute_lov modify oal_label varchar2(128)');
exception
  when others then
    null; 
end;
/

-- dr$preference
declare
  errnum number;
begin
  execute immediate('
  alter table dr$preference modify pre_name varchar2(128)');
exception
  when others then
    null; 
end;
/

-- dr$index
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_name varchar2(128)');
exception
  when others then
    null; 
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_sync_jobname varchar2(128)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_src_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$index_partition

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_partition modify ixp_name varchar2(128)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_partition modify ixp_sync_jobname varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$sqe
declare
  errnum number;
begin
  execute immediate('
  alter table dr$sqe modify sqe_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$ths
declare
  errnum number;
begin
  execute immediate('
  alter table dr$ths modify ths_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$section_group
declare
  errnum number;
begin
  execute immediate('
  alter table dr$section_group modify sgp_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$section
declare
  errnum number;
begin
  execute immediate('
  alter table dr$section modify sec_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$stoplist
declare
  errnum number;
begin
  execute immediate('
  alter table dr$stoplist modify spl_name varchar2(128)');
exception
  when others then
    null;
end;
/ 

-- dr$index_set
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_set modify ixs_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$online_pending
declare
  errnum number;
begin
  execute immediate('
  alter table dr$online_pending modify onl_indexpartition varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$parallel
declare
  errnum number;
begin
  execute immediate('
  alter table dr$parallel modify p_partition varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$dbo
declare
  errnum number;
begin
  execute immediate('
  alter table dr$dbo modify dbo_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$index_cdi_column
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_cdi_column modify cdi_section_name varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$autoopt
declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_ownname varchar2(128)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_idxname varchar2(128)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_partname varchar2(128)');
exception
  when others then
    null;
end;
/

-- dr$dictionary
declare
  errnum number;
begin
  execute immediate('
  alter table dr$dictionary modify dict_name varchar2(128)');
exception
  when others then
    null;
end;
/

----------------------------------------------------------------------
-- Index Option, add 's', DRDPL_OPT_SORTSTAB
----------------------------------------------------------------------
declare
  sql_q varchar2(100);
begin
  for r in (select idx_id, idx_option from dr$index
             where idx_option like '%C%')
  loop
    sql_q := 'update dr$index set idx_option=''' || r.idx_option || 's''' ||
            ' where idx_id=' || r.idx_id;
    execute immediate(sql_q);
  end loop;
exception
  when others then
    null;
end;
/

----------------------------------------------------------------------
-- Change sortable SDATA metadata
----------------------------------------------------------------------
--ixv_sub_oat_id = 240111 indicates sortable sdata attribute values
--ixv_sub_oat_id = 240110 indicates searchable sdata attribute values
--These ID values above are for 12.1.0.2. In 12.2 onward, we only use attribute
--ID 240110 for the value "optimized for". Below, we look at both these values 
--to preserve the existing "optimized for" value and populate them into the 
--value for ID 240110

declare
   isSortable varchar(1);
   isSearchable varchar(1);
   optimized_for varchar(1);
   isNoDataFound number;
   cntRowsAdded number;
begin
  
  --Update dr$index_value. Preserve the existing "optimize for" value
  for sdataValue in (
  	select DISTINCT IXV_IDX_ID,IXV_OAT_ID,IXV_SUB_GROUP from dr$index_value 
    	where  ixv_sub_oat_id = 240110 OR ixv_sub_oat_id = 240111
    )
  loop
    begin
    
    isNoDataFound := 0;

    begin          
      select IXV_VALUE
            into isSortable
      from dr$index_value
      where IXV_IDX_ID = sdataValue.IXV_IDX_ID
            and IXV_SUB_GROUP = sdataValue.IXV_SUB_GROUP 
            and ixv_sub_oat_id = 240111;
    exception
            when no_data_found then
            isSortable := 0;                    
    end;

    begin          
      select IXV_VALUE
             into isSearchable
      from dr$index_value
      where IXV_IDX_ID = sdataValue.IXV_IDX_ID
            and IXV_SUB_GROUP = sdataValue.IXV_SUB_GROUP 
            and ixv_sub_oat_id = 240110;
    exception
            when no_data_found then
            isSearchable := 0;        
            isNoDataFound := 1;
    end;

    --Both Sortable and Searchable are true
    if (isSortable = 1 and isSearchable >= 1)
    then
       optimized_for := '3';       
    
    -- Searchable SDATA, NOT Sortable
    elsif (isSortable = 0 and isSearchable >= 1)
    then
       optimized_for := '2';

    -- Sortable SDATA, NOT Searchable
    elsif (isSortable = 1 and isSearchable = 0)
    then
       optimized_for := '1';
    
    --If neither value is set, update by default to sortable SDATA
    else
       optimized_for := '1';
    end if;
    
    cntRowsAdded := 0;  --Counting the rows added to add to dr$index_object

    if(isNoDataFound = 0) then 
       update dr$index_value set ixv_value = optimized_for 
              where IXV_SUB_OAT_ID = 240110
   		        and IXV_IDX_ID = sdataValue.IXV_IDX_ID
   		        and IXV_SUB_GROUP = sdataValue.IXV_SUB_GROUP;
    else
       insert into dr$index_value (IXV_IDX_ID, IXV_OAT_ID, IXV_SUB_GROUP,
                                   IXV_SUB_OAT_ID, IXV_VALUE) 
       values (sdataValue.IXV_IDX_ID, sdataValue.IXV_OAT_ID,
               sdataValue.IXV_SUB_GROUP, 240110, optimized_for);

       cntRowsAdded := cntRowsAdded + 1;
    end if;
    
    end;
  end loop;

  update dr$index_object
    set ixo_acnt = ixo_acnt + cntRowsAdded 
    			            - (select count(*) from dr$index_value
                                 where ixv_idx_id = ixo_idx_id
                                       and ixv_sub_oat_id = 240111)
    where ixo_idx_id in (select distinct ixv_idx_id from dr$index_value
                       where ixv_sub_oat_id = 240111)
    and ixo_cla_id = 5;
  
  --Clear values for 240111 as they have been consolidated into 240110 for 12.2
  delete from dr$index_value where ixv_sub_oat_id = 240111;  
  
  --Update dr$section_attribute. Preserve the existing "optimize for" value
  for sdataValue in (
  	select DISTINCT SCA_SGP_ID,SCA_SEC_ID from dr$section_attribute
    	where  sca_sat_id = 240110 OR sca_sat_id = 240111
    )
  loop
    begin
    
    isNoDataFound := 0;

    begin          
      select SCA_VALUE
      into isSortable
      from dr$section_attribute
      where SCA_SGP_ID = sdataValue.SCA_SGP_ID
            and SCA_SEC_ID = sdataValue.SCA_SEC_ID 
            and sca_sat_id = 240111;
      exception
          when no_data_found then
            isSortable := 0;                   
     end;

     begin          
      select SCA_VALUE
      into isSearchable
      from dr$section_attribute
      where SCA_SGP_ID = sdataValue.SCA_SGP_ID
            and SCA_SEC_ID = sdataValue.SCA_SEC_ID 
            and sca_sat_id = 240110;
      exception
          when no_data_found then
            isSearchable := 0;
            isNoDataFound := 1;   
     end;

    --Both Sortable and Searchable are true
    if (isSortable = 1 and isSearchable >= 1)
    then
       optimized_for := '3';

    -- Searchable SDATA, NOT Sortable
    elsif (isSortable = 0 and isSearchable >= 1)
    then
       optimized_for := '2';
       
    -- Sortable SDATA, NOT Searchable
    elsif (isSortable = 1 and isSearchable = 0)
    then
       optimized_for := '1';

    --If neither value is set, update by default to sortable SDATA
    else
       optimized_for := '1';
       
    end if;   
   
    if(isNoDataFound = 0) then 
       update dr$section_attribute set SCA_VALUE = optimized_for 
           where SCA_SGP_ID = sdataValue.SCA_SGP_ID
            and SCA_SEC_ID = sdataValue.SCA_SEC_ID 
            and sca_sat_id = 240110;
    else
       insert into dr$section_attribute (SCA_SGP_ID, SCA_SEC_ID, 
                                         SCA_SAT_ID, SCA_VALUE) 
       values (sdataValue.SCA_SGP_ID, sdataValue.SCA_SEC_ID,
               240110, optimized_for);    
    
    end if;

    end;
  end loop;
  
  --Clear values for 240111 as they have been consolidated into 240110 for 12.2
  delete from dr$section_attribute where sca_sat_id = 240111;

  commit;

exception
when dup_val_on_index then
  null;
end;
/



----------------------------------------------------------------------
-- Remove storage option for stage itab target size
----------------------------------------------------------------------
delete from dr$object_attribute
 where OAT_ID=90128 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=28
 and OAT_NAME='STAGE_ITAB_TARGET_SIZE';
commit;

----------------------------------------------------------------------
-- Add storage option for stage itab max rows
----------------------------------------------------------------------
begin
  insert into dr$object_attribute values
  (90128, 9, 1, 28,
   'STAGE_ITAB_MAX_ROWS', '',
   'N', 'N', 'Y', 'I',
   '1000000', null, null, 'N');
  commit;
exception
when dup_val_on_index then
  null;
end;
/

----------------------------------------------------------------------
-- Add storage option for stage itab parallel degree
----------------------------------------------------------------------
begin
  insert into dr$object_attribute values
  (90155, 9, 1, 55,
   'STAGE_ITAB_PARALLEL', '',
   'N', 'N', 'Y', 'I',
   '2', null, null, 'N');
  commit;
exception
when dup_val_on_index then
  null;
end;
/

----------------------------------------------------------------------
-- READ Privilege instead of SELECT
----------------------------------------------------------------------
-- Bug 24590462
-- call ctxview122.sql to recreate ctx views using 12.2 definition
@@ctxview122.sql

revoke select on ctx_trace_values from public;
revoke select on ctx_parameters from public;
revoke select on ctx_classes from public;
revoke select on ctx_objects from public;
revoke select on ctx_object_attributes from public;
revoke select on ctx_object_attribute_lov from public;
revoke select on ctx_preferences from public;
revoke select on ctx_user_preferences from public;
revoke select on ctx_preference_values from public;
revoke select on ctx_user_preference_values from public;
revoke select on ctx_user_indexes from public;
revoke select on ctx_user_index_partitions from public;
revoke select on ctx_user_index_values from public;
revoke select on ctx_user_index_sub_lexers from public;
revoke select on ctx_user_index_sub_lexer_vals from public;
revoke select on ctx_user_index_objects from public;
revoke select on ctx_sqes from public;
revoke select on ctx_user_sqes from public;
revoke select on ctx_thesauri from public;
revoke select on ctx_user_thesauri from public;
revoke select on ctx_thes_phrases from public;
revoke select on ctx_user_thes_phrases from public;
revoke select on ctx_section_groups from public;
revoke select on ctx_user_section_groups from public;
revoke select on ctx_sections from public;
revoke select on ctx_user_sections from public;
revoke select on ctx_stoplists from public;
revoke select on ctx_user_stoplists from public;
revoke select on ctx_stopwords from public;
revoke select on ctx_user_stopwords from public;
revoke select on ctx_sub_lexers from public;
revoke select on ctx_user_sub_lexers from public;
revoke select on ctx_index_sets from public;
revoke select on ctx_user_index_sets from public;
revoke select on ctx_index_set_indexes from public;
revoke select on ctx_user_index_set_indexes from public;
revoke select on ctx_user_pending from public;
revoke select on ctx_filter_cache_statistics from public;
revoke select on ctx_user_filter_by_columns from public;
revoke select on ctx_user_order_by_columns from public;
revoke select on ctx_user_extract_rules from public;
revoke select on ctx_user_extract_stop_entities from public;
revoke select on ctx_user_extract_policies from public;
revoke select on ctx_user_extract_policy_values from public;
revoke select on ctx_index_sections from public;
revoke select on ctx_user_auto_optimize_indexes from public;
revoke select on ctx_user_index_sections from public;
revoke select on ctx_user_session_sqes from public;
revoke select on SYS.HIST_HEAD$ from ctxsys;

grant read on ctx_trace_values to public;
grant read on ctx_parameters to public;
grant read on ctx_classes to public;
grant read on ctx_objects to public;
grant read on ctx_object_attributes to public;
grant read on ctx_object_attribute_lov to public;
grant read on ctx_preferences to public;
grant read on ctx_user_preferences to public;
grant read on ctx_preference_values to public;
grant read on ctx_user_preference_values to public;
grant read on ctx_user_indexes to public;
grant read on ctx_user_index_partitions to public;
grant read on ctx_user_index_values to public;
grant read on ctx_user_index_sub_lexers to public;
grant read on ctx_user_index_sub_lexer_vals to public;
grant read on ctx_user_index_objects to public;
grant read on ctx_sqes to public;
grant read on ctx_user_sqes to public;
grant read on ctx_thesauri to public;
grant read on ctx_user_thesauri to public;
grant read on ctx_thes_phrases to public;
grant read on ctx_user_thes_phrases to public;
grant read on ctx_section_groups to public;
grant read on ctx_user_section_groups to public;
grant read on ctx_sections to public;
grant read on ctx_user_sections to public;
grant read on ctx_stoplists to public;
grant read on ctx_user_stoplists to public;
grant read on ctx_stopwords to public;
grant read on ctx_user_stopwords to public;
grant read on ctx_sub_lexers to public;
grant read on ctx_user_sub_lexers to public;
grant read on ctx_index_sets to public;
grant read on ctx_user_index_sets to public;
grant read on ctx_index_set_indexes to public;
grant read on ctx_user_index_set_indexes to public;
grant read on ctx_user_pending to public;
grant read on ctx_filter_cache_statistics to public;
grant read on ctx_user_filter_by_columns to public;
grant read on ctx_user_order_by_columns to public;
grant read on ctx_user_extract_rules to public;
grant read on ctx_user_extract_stop_entities to public;
grant read on ctx_user_extract_policies to public;
grant read on ctx_index_sections to public;
grant read on ctx_user_auto_optimize_indexes to public;
grant read on ctx_user_extract_policy_values to public;
grant read on ctx_user_index_sections to public;
grant read on ctx_user_session_sqes to public;

--Bug 22445358: DOS ATTACK POSSIBLE FOR SELECT GRANTED TO PUBLIC

revoke select on DR$OBJECT_ATTRIBUTE from public;
revoke select on DR$THS from public;
revoke select on DR$THS_PHRASE from public;
revoke select on DR$NUMBER_SEQUENCE from public;

grant read on DR$OBJECT_ATTRIBUTE to public;
grant read on DR$THS to public;
grant read on DR$THS_PHRASE to public;
grant read on DR$NUMBER_SEQUENCE to public;

-- Bug 21701234
REM ===================================================================
REM EXECUTE on DBMS_PRIV_CAPTURE to ctxsys
REM ===================================================================
grant execute on DBMS_PRIV_CAPTURE to ctxsys;


begin
  execute immediate 'revoke select on SYS.USER$ from ctxsys';
exception
  when others then
    if (SQLCODE = -1927) then null;
    else raise;
    end if;
end;
/

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

exec dr$temp_crepref('CTXSYS.JSONREST_GENERIC_LEXER', 'BASIC_LEXER');

exec dr$temp_crepref('CTXSYS.JSONREST_DANISH_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_DANISH_LEXER','ALTERNATE_SPELLING','DANISH');

exec dr$temp_crepref('CTXSYS.JSONREST_FINNISH_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_FINNISH_LEXER', 'ALTERNATE_SPELLING', 'SWEDISH');

exec dr$temp_crepref('CTXSYS.JSONREST_DUTCH_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_DUTCH_LEXER', 'COMPOSITE','DUTCH');

exec dr$temp_crepref('CTXSYS.JSONREST_GERMAN_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_LEXER',  'ALTERNATE_SPELLING', 'GERMAN');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_LEXER',  'COMPOSITE', 'GERMAN');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_LEXER', 'MIXED_CASE', 'YES');

exec dr$temp_crepref('CTXSYS.JSONREST_SCHINESE_LEXER', 'CHINESE_VGRAM_LEXER');

exec dr$temp_crepref('CTXSYS.JSONREST_TCHINESE_LEXER', 'CHINESE_VGRAM_LEXER');

exec dr$temp_crepref('CTXSYS.JSONREST_KOREAN_LEXER', 'KOREAN_MORPH_LEXER');

exec dr$temp_crepref('CTXSYS.JSONREST_SWEDISH_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_SWEDISH_LEXER','ALTERNATE_SPELLING','SWEDISH');

exec dr$temp_crepref('CTXSYS.JSONREST_JAPANESE_LEXER', 'JAPANESE_VGRAM_LEXER');

exec dr$temp_crepref('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'ALTERNATE_SPELLING', 'GERMAN');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'COMPOSITE', 'GERMAN');
exec dr$temp_setatt('CTXSYS.JSONREST_GERMAN_DIN_LEXER', 'MIXED_CASE', 'YES');

exec dr$temp_crepref('CTXSYS.JSONREST_NORWEGIAN_LEXER', 'BASIC_LEXER');
exec dr$temp_setatt('CTXSYS.JSONREST_NORWEGIAN_LEXER', 'ALTERNATE_SPELLING','SWEDISH');

@?/rdbms/admin/sqlsessend.sql 
