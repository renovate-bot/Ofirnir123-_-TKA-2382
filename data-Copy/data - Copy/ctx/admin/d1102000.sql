Rem
Rem $Header: ctx_src_2/src/dr/admin/d1102000.sql /main/14 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1102000.sql
Rem
Rem Copyright (c) 2010, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1102000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Downgrade from 11.2.0.X to 11.2.0.1
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1102000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1102000.sql
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
Rem    yiqi        12/12/12 - Bug 15960782
Rem    hsarkar     03/24/11 - Date and Pattern Stopclass project
Rem    rpalakod    02/08/11 - fuzzy change should be in d12
Rem    surman      11/11/10 - 9950719: Min value for fuzzy_score
Rem    rpalakod    08/06/10 - Bug 9973683
Rem    surman      05/27/10 - 9523887: Make dr$waiting an IOT
Rem    rpalakod    04/30/10 - autooptimize and doclexer
Rem    surman      02/19/10 - 9162906: auto lexer timeout
Rem    surman      01/28/10 - 9305120: Creation
Rem    surman      01/28/10 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


REM ===================================================================
REM Bug 9523887: dr$waiting is now an IOT
REM ===================================================================
alter table dr$waiting rename to dr$waiting_old;
create table dr$waiting (
  wtg_cid       number,
  wtg_rowid     rowid,
  wtg_pid       number default 0
);
insert into dr$waiting
  select *
    from dr$waiting_old;
drop table dr$waiting_old;


REM ===================================================================
REM DIRECT_IO
REM ===================================================================

delete from dr$object_attribute
  where oat_id = 10303 and oat_name = 'DIRECT_IO';

REM ===================================================================
REM 9162906: TIMEOUT
REM ===================================================================

delete from dr$object_attribute
  where oat_id = 2061254 and oat_name = 'TIMEOUT';

REM ==================================================================
REM Reverse Changes from ctx_tree
REM ==================================================================

drop view drv$tree;
drop table dr$tree;

delete from dr$object_attribute
  where OAT_ID=90116 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=16
    and OAT_NAME='F_TABLE_CLAUSE';

delete from dr$object_attribute
  where OAT_ID=90117 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=17
    and OAT_NAME='A_TABLE_CLAUSE';

commit;

REM ==================================================================
REM Reverse Changes from autooptimize
REM ==================================================================

drop view ctx_auto_optimize_indexes;
drop view drv$autoopt;
drop synonym ctx_user_auto_optimize_indexes;
drop view ctx_user_auto_optimize_indexes;
drop view ctx_auto_optimize_status;
drop table dr$autoopt;

delete from dr$parameter where par_name='AUTO_OPTIMIZE';
delete from dr$parameter where par_name='AUTO_OPTIMIZE_LOGFILE';

declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'AUTO_OPT_OBJ' and
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

declare
  errnum number; 
begin
  dbms_scheduler.drop_job('DR$BGOPTJOB', TRUE);
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -27475) then
      null;
    else
      raise;
    end if;
end;
/

declare
  errnum number;
begin
  dbms_scheduler.drop_program('DR$BGOPTPRG', TRUE);
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -27476) then
      null;
    else
      raise;
    end if;
end;
/

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

REM ------------------------------------------------------------------
REM drop column slx_lang_dependent dr$sub_lexer
REM ------------------------------------------------------------------

declare
  errnum number;
begin
  execute immediate('
  alter table dr$sub_lexer drop column slx_lang_dependent');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00904) then
      null;
    else
      raise;
    end if;
end;
/

REM ------------------------------------------------------------------
REM  drop column spw_lang_dependent dr$stopword
REM ------------------------------------------------------------------

declare
  errnum number;
begin
  execute immediate('
  alter table dr$stopword drop (spw_lang_dependent, spw_pattern)');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00904) then
      null;
    else
      raise;
    end if;
end;
/
REM ------------------------------------------------------------------
REM ctx_stopwords
REM ------------------------------------------------------------------

create or replace view ctx_stopwords as
select 
  u.name         spw_owner,
  spl_name       spw_stoplist,
  decode(spw_type, 1, 'STOP_CLASS', 2, 'STOP_WORD', 3, 'STOP_THEME', null)
                 spw_type,
  spw_word       spw_word,
  decode(spw_language, 'ALL', null, spw_language)   spw_language
from dr$stoplist, dr$stopword, sys."_BASE_USER" u
where spl_id = spw_spl_id
  and spl_owner# = u.user#
/

create or replace public synonym ctx_stopwords for CTXSYS.CTX_STOPWORDS;
grant select on CTX_STOPWORDS to PUBLIC;

REM ------------------------------------------------------------------
REM ctx_user_stopwords
REM ------------------------------------------------------------------

create or replace view CTX_USER_STOPWORDS as
select 
  spl_name       spw_stoplist,
  decode(spw_type, 1, 'STOP_CLASS', 2, 'STOP_WORD', 3, 'STOP_THEME', null)
                 spw_type,
  spw_word       spw_word,
  decode(spw_language, 'ALL', null, spw_language)   spw_language
from dr$stoplist, dr$stopword
where spl_id = spw_spl_id
  and spl_owner# = userenv('SCHEMAID')
/

create or replace public synonym CTX_USER_STOPWORDS
for CTXSYS.CTX_USER_STOPWORDS;
grant select on CTX_USER_STOPWORDS to PUBLIC;

REM ------------------------------------------------------------------
REM ctx_sub_lexers 
REM ------------------------------------------------------------------

CREATE OR REPLACE VIEW ctx_sub_lexers AS
select  u1.name            slx_owner
       ,p1.pre_name        slx_name
       ,slx_language       slx_language
       ,slx_alt_value      slx_alt_value
       ,u2.name            slx_sub_owner
       ,p2.pre_name        slx_sub_name
from   dr$sub_lexer
      ,dr$preference p1
      ,dr$preference p2
      ,sys."_BASE_USER" u1
      ,sys."_BASE_USER" u2 
where p2.pre_owner# = u2.user#
  and p1.pre_owner# = u1.user#
  and slx_sub_pre_id = p2.pre_id
  and slx_pre_id = p1.pre_id
/

create or replace public synonym CTX_SUB_LEXERS for CTXSYS.CTX_SUB_LEXERS;
grant select on CTX_SUB_LEXERS to PUBLIC;

REM ------------------------------------------------------------------
REM ctx_user_sub_lexers
REM ------------------------------------------------------------------

CREATE OR REPLACE VIEW ctx_user_sub_lexers AS
select  p1.pre_name       slx_name
       ,slx_language      slx_language
       ,slx_alt_value     slx_alt_value
       ,u2.name           slx_sub_owner
       ,p2.pre_name       slx_sub_name
from   dr$sub_lexer
      ,dr$preference p1
      ,dr$preference p2
      ,sys."_BASE_USER" u2
where p2.pre_owner# = u2.user#
  and p1.pre_owner# = userenv('SCHEMAID')
  and slx_sub_pre_id = p2.pre_id
  and slx_pre_id = p1.pre_id
/

create or replace public synonym CTX_USER_SUB_LEXERS
for CTXSYS.CTX_USER_SUB_LEXERS;
grant select on CTX_USER_SUB_LEXERS to PUBLIC;

rem The following types and function are used when $P is populated
drop type dr$substring force;
create or replace type dr$substring as object
(
  part_1 varchar2(61),
  part_2 varchar2(64)
);
/
grant execute on dr$substring to public;

drop type dr$substring_set force;
create or replace type dr$substring_set as table of dr$substring;
/
