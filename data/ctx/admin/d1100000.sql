Rem
Rem $Header: ctx_src_2/src/dr/admin/d1100000.sql /main/21 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1100000.sql
Rem
Rem Copyright (c) 2007, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1100000.sql - downgrade from 11.2 to 11.1.0.6
Rem
Rem    DESCRIPTION
Rem      downgrade data dictionary from any patchset to 11.1
Rem      first production version
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1100000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1100000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    boxia       01/21/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rpalakod    08/06/10 - Bug 9973683
Rem    rpalakod    04/30/10 - remove autooptimize and doclexer
Rem    rkadwe      04/04/10 - Document Level Lexer
Rem    ssethuma    03/30/10 - XbranchMerge ssethuma_bug-9048930 from main
Rem    rpalakod    02/18/09 - change name of near_realtime
Rem    rpalakod    02/05/09 - nrtidx api
Rem    nenarkhe    01/22/09 - reverse MVDATA changes
Rem    rpalakod    01/07/09 - separate_offsets
Rem    rpalakod    01/05/09 - Reverse BIG IO changes
Rem    igeller     10/07/08 - Reverse changes made by 7353283
Rem    shorwitz    06/18/08 - Bug 4198410: Remove new languages
Rem    rpalakod    01/10/08 - Entity Extraction 
Rem    wclin       09/28/07 - Created
Rem

REM ===================================================================
REM Reverse changes made for Bug 9048930 fix
REM ===================================================================

update dr$index_cdi_column
  set cdi_column_name = ltrim(rtrim(cdi_column_name, '"'),'"');
commit;

REM ================================================================== 
REM Reverse Change from bug 7353283 to disallow bigram attribute
REM   in Japanese_Lexer.
REM ==================================================================

delete from dr$object_attribute 
  where OAT_ID=60210 and OAT_CLA_ID=6 and OAT_OBJ_ID=2 and OAT_ATT_ID=10 
    and OAT_NAME='BIGRAM';

REM ==================================================================
REM Reverse Change from BIG_IO txn to disallow BIG_IO storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90110 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=10
    and OAT_NAME='BIG_IO';
commit;

REM ==================================================================
REM Reverse Change from SEP_OFF txn to disallow SEPARATE_OFFSETS
REM    storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90111 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=11
    and OAT_NAME='SEPARATE_OFFSETS';
commit;


REM ==================================================================
REM Reverse Change from MVDATA txn to disallow MV_TABLE_CLAUSE
REM    storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90112 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=12
    and OAT_NAME='MV_TABLE_CLAUSE';
commit;

delete from dr$object_attribute
  where OAT_ID=50212 and OAT_CLA_ID=5 and OAT_OBJ_ID=2 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

delete from dr$object_attribute
  where OAT_ID=50312 and OAT_CLA_ID=5 and OAT_OBJ_ID=3 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

delete from dr$object_attribute
  where OAT_ID=50512 and OAT_CLA_ID=5 and OAT_OBJ_ID=5 and OAT_ATT_ID=12
    and OAT_NAME='MVDATA';
commit;

REM ==================================================================
REM Reverse Change from NRTIDX txn to disallow NEAR_REALTIME storage attribute
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90113 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=13
    and OAT_NAME='STAGE_ITAB';

delete from dr$object_attribute
  where OAT_ID=90114 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=14
    and OAT_NAME='G_TABLE_CLAUSE';

delete from dr$object_attribute
  where OAT_ID=90115 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=15
    and OAT_NAME='G_INDEX_CLAUSE';

commit;

REM ================================================================== 
REM Reverse Change from bug 6449287 to disallow special sections
REM   in auto_section_group.
REM ==================================================================

delete from dr$object_attribute 
  where OAT_ID=50703 and OAT_CLA_ID=5 and OAT_OBJ_ID=7 and OAT_ATT_ID=3 
    and OAT_NAME='SPECIAL';


REM ================================================================== 
REM Reverse Entity Extraction Changes
REM ==================================================================

REM delete default extract lexer

begin
  delete from dr$preference where pre_id = 1024;
  delete from dr$preference_value where prv_pre_id = 1024;
  delete from dr$parameter where par_name='DEFAULT_EXTRACT_LEXER';
end;
/

REM delete default extraction engines
begin
  delete from dr$preference where PRE_OBJ_ID=4 and PRE_CLA_ID=9;
  delete from dr$preference_value where PRV_OAT_ID=90401;
  delete from dr$preference_value where PRV_OAT_ID=90402;
end;
/

REM delete default extraction dictionary policy object
declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'ENT_EXT_DICT_OBJ' and
    idx_owner# = l_owner#;
  delete from dr$index_object where ixo_idx_id = l_pol_id;
  delete from dr$index_value where ixv_idx_id = l_pol_id;
  delete from dr$index where idx_id = l_pol_id;
  delete from dr$stats where idx_id = l_pol_id;
  delete from dr$index_error where err_idx_id = l_pol_id;
  commit;
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/

delete from dr$object_attribute
  where OAT_ID=90401 and OAT_CLA_ID=9 and OAT_OBJ_ID=4 and OAT_ATT_ID=1
    and OAT_NAME='INCLUDE_DICTIONARY';

delete from dr$object_attribute
  where OAT_ID=90401 and OAT_CLA_ID=9 and OAT_OBJ_ID=4 and OAT_ATT_ID=2
    and OAT_NAME='INCLUDE_RULES';


delete from dr$object
  where OBJ_CLA_ID=9 and OBJ_ID=4 and OBJ_NAME='ENTITY_STORAGE';

drop public synonym ctx_user_extract_rules;
drop public synonym ctx_user_extract_stop_entities;
drop public synonym ctx_user_extract_policies;
drop public synonym ctx_user_extract_policy_values;
drop view ctx_user_extract_rules;
drop view drv$user_extract_rule;
drop view ctx_user_extract_stop_entities;
drop view drv$user_extract_stop_entity;
drop view drv$user_extract_tkdict;
drop view drv$user_extract_entdict;
drop view ctx_extract_policies;
drop view ctx_extract_policy_values;
drop view ctx_user_extract_policies;
drop view ctx_user_extract_policy_values;
drop table dr$user_extract_rule;
drop table dr$user_extract_stop_entity;
drop table dr$user_extract_tkdict;
drop table dr$user_extract_entdict;

REM ==================================================================
REM Remove new languages (4198410)
REM ==================================================================

delete from dr$object_attribute_lov
  where oal_oat_id = 60117 and
        (
          oal_value = 47 or
          oal_value = 48 or
          oal_value = 49 or
          oal_value = 50 or
          oal_value = 51 or
          oal_value = 52 or
          oal_value = 53 or
          oal_value = 54 or
          oal_value = 55 or
          oal_value = 56 or
          oal_value = 57 or
          oal_value = 58 or
          oal_value = 59 or
          oal_value = 60 or
          oal_value = 61 or
          oal_value = 62
        ) ;
 
commit;
 
REM ===================================================================
REM REVERSE WILDCARD_MAXTERMS CHANGE
REM ===================================================================

update dr$object_attribute
  set oat_val_min = 1
  where oat_id = 70106;
commit;

REM ==================================================================
REM Reverse Changes from stop_opt_list
REM ==================================================================

declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'STOP_OPT_LIST' and
    idx_owner# = l_owner#;
  delete from dr$index_object where ixo_idx_id = l_pol_id;
  delete from dr$index_value where ixv_idx_id = l_pol_id;
  delete from dr$index where idx_id = l_pol_id;
  delete from dr$stats where idx_id = l_pol_id;
  delete from dr$index_error where err_idx_id = l_pol_id;
  commit;
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/


