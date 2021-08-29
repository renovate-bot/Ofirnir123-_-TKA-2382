Rem
Rem $Header: ctx_src_2/src/dr/admin/u1102000.sql /main/16 2018/07/25 13:49:07 surman Exp $
Rem
Rem u1102000.sql
Rem
Rem Copyright (c) 2008, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1102000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade from 11.2.0.1 to latest version of 11.2.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1102000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1102000.sql
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
Rem    aczarlin    01/26/12 - bug 13470616
Rem    rpalakod    02/08/11 - fuzzy change should be in u12
Rem    surman      11/11/10 - 9950719: Min value for fuzzy_score
Rem    surman      05/27/10 - 9523887: Make dr$waiting an IOT
Rem    rpalakod    04/30/10 - Document Level Lexer
Rem    surman      02/19/10 - 9162906: auto lexer timeout
Rem    surman      01/28/10 - 9305120: Add direct_io
Rem    ssethuma    01/27/10 - Bug 9048930
Rem    ssethuma    03/30/10 - XbranchMerge ssethuma_bug-9048930 from main
Rem    rpalakod    06/07/08 - 11.2
Rem    rpalakod    06/07/08 - Created
Rem

REM ===================================================================
REM Bug 9523887: dr$waiting is now an IOT
REM Bug 13470616: empty dr$waiting before upgrade 
REM ===================================================================

drop table dr$waiting;
create table dr$waiting (
  wtg_cid       number  NOT NULL,
  wtg_rowid     rowid,
  wtg_pid       number default 0,
  primary key (wtg_cid, wtg_pid, wtg_rowid)
)
organization index;

REM ===================================================================
REM Bug 9048930
REM ===================================================================

update dr$index_cdi_column
  set cdi_column_name = '"' || cdi_column_name || '"'
    where regexp_instr(cdi_column_name, '^["](.+)["]$') != 1;
commit;

REM ===================================================================
REM DIRECT_IO
REM ===================================================================

BEGIN
  insert into dr$object_attribute values
    (10303, 1, 3, 3, 
     'DIRECT_IO', 'Controls direct I/O behavior for supported platforms',
     'N', 'N', 'Y', 'B', 
     'FALSE', null, null, 'N');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    NULL;
END;
/


REM ===================================================================
REM 9162906: TIMEOUT
REM ===================================================================

BEGIN
  insert into dr$object_attribute values
    (2061254, 6, 12, 254, 
     'TIMEOUT', 'Timeout (in seconds) for auto lexer tokenization',
     'N', 'N', 'Y', 'I', 
     '60', 0, 600, 'N');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    NULL;
END;
/

REM ===================================================================
REM CTX_TREE Tables AND Views
REM ===================================================================
PROMPT ... upgrade steps for CTX_TREE

begin
 insert into dr$object_attribute values
  (90116, 9, 1, 16,
   'F_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

 insert into dr$object_attribute values
  (90117, 9, 1, 17,
   'A_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

 commit;

exception
when dup_val_on_index then
  null;
end;
/

declare
  errnum number;
begin
  execute immediate('
create table dr$tree (
    idxid    number, 
    secid number,       
    node_seq  number,
    primary key(idxid, secid)
   )organization index');
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

create or replace view drv$tree as 
select * from ctxsys.dr$tree 
where idxid = SYS_CONTEXT('DR$APPCTX', 'IDXID')
with check option;

grant select, insert, update, delete on drv$tree to public;

/

REM ===================================================================
REM autooptimize
REM ===================================================================

PROMPT ... upgrade steps for autooptimize

begin
  insert into dr$parameter (par_name, par_value)
  values ('AUTO_OPTIMIZE', 'ENABLE');
  insert into dr$parameter (par_name, par_value)
  values ('AUTO_OPTIMIZE_LOGFILE', NULL);
commit;
exception
when dup_val_on_index then
  null;
end;
/

declare
  errnum number;
begin
  execute immediate('
create table dr$autoopt(
  aoi_idxid number,
  aoi_partid number, 
  aoi_ownid number, 
  aoi_ownname varchar2(30), 
  aoi_idxname varchar2(30), 
  aoi_partname varchar2(30), 
  constraint drc$autoopt_un unique (aoi_idxid, aoi_partid, aoi_ownid))');
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

-------------------------------------------------------------------------
--- dr$sub_lexer
-------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$sub_lexer add slx_lang_dependent char(1)');
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

update dr$sub_lexer
set    slx_lang_dependent = 'Y'
where  slx_lang_dependent is NULL;

commit;
           
-------------------------------------------------------------------------
--- dr$stopword
-------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$stopword add spw_lang_dependent char(1)');
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

update dr$stopword
set    spw_lang_dependent = 'Y'
where  spw_lang_dependent is NULL;

commit;

-------------------------------------------------------------------------
--- ctx_auto_optimize_indexes
-------------------------------------------------------------------------
create or replace view ctx_auto_optimize_indexes as
select
  o.aoi_ownname aoi_index_owner,
  o.aoi_idxname aoi_index_name,
  o.aoi_partname aoi_partition_name
  from dr$autoopt o;

create or replace view drv$autoopt as select * from dr$autoopt;
grant select on drv$autoopt to public;

-------------------------------------------------------------------------
--- ctx_user_auto_optimize_indexes
-------------------------------------------------------------------------
create or replace view ctx_user_auto_optimize_indexes as
select
  o.aoi_idxname aoi_index_name,
  o.aoi_partname aoi_partition_name
  from dr$autoopt o where o.aoi_ownid = userenv('SCHEMAID');

create or replace public synonym ctx_user_auto_optimize_indexes
for ctxsys.ctx_user_auto_optimize_indexes;
grant select on ctx_user_auto_optimize_indexes to public;

-------------------------------------------------------------------------
--- ctx_auto_optimize_status
-------------------------------------------------------------------------
create or replace view ctx_auto_optimize_status as
select l.log_date aos_timestamp, 
       l.status   aos_status,
       d.additional_info aos_error
  from user_scheduler_job_log l, user_scheduler_job_run_details d
  where l.log_id = d.log_id and
        l.owner = d.owner and
        l.owner = 'CTXSYS';

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
  spw_lang_dependent   spw_lang_dependent
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
  spw_lang_dependent   spw_lang_dependent
from dr$stoplist, dr$stopword
where spl_id = spw_spl_id
  and spl_owner# = userenv('SCHEMAID')
/

create or replace public synonym CTX_USER_STOPWORDS 
for CTXSYS.CTX_USER_STOPWORDS;
grant select on CTX_USER_STOPWORDS to PUBLIC;

-------------------------------------------------------------------------
--- ctx_sub_lexers 
-------------------------------------------------------------------------
CREATE OR REPLACE VIEW ctx_sub_lexers AS 
select  u1.name            slx_owner
       ,p1.pre_name        slx_name
       ,slx_language       slx_language
       ,slx_alt_value      slx_alt_value
       ,u2.name            slx_sub_owner
       ,p2.pre_name        slx_sub_name
       ,slx_lang_dependent slx_lang_dependent
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

-------------------------------------------------------------------------
--- ctx_user_sub_lexers 
-------------------------------------------------------------------------
CREATE OR REPLACE VIEW ctx_user_sub_lexers AS 
select  p1.pre_name       slx_name
       ,slx_language      slx_language
       ,slx_alt_value     slx_alt_value
       ,u2.name           slx_sub_owner
       ,p2.pre_name       slx_sub_name
       ,slx_lang_dependent slx_lang_dependent
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

/

REM ===================================================================
REM Drop types
REM ===================================================================

drop type dr$substring force;
drop type dr$substring_set force;

commit;
