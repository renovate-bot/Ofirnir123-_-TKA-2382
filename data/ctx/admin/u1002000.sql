Rem
Rem $Header: ctx_src_2/src/dr/admin/u1002000.sql /main/36 2018/07/25 13:49:07 surman Exp $
Rem
Rem u1002000.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1002000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      upgrade ctxsys from 10.2.0.X to 11
Rem
Rem    NOTES
Rem      This script upgrades a 10.2.0.X ctxsys data dictionary to latest  
Rem      This script should be run as ctxsys on an 10.2.0 ctxsys schema
Rem      (or as SYS with ALTER SESSION SET SCHEMA = CTXSYS)
Rem      No other users or schema versions are supported.
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1002000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1002000.sql
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
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    nenarkhe    08/25/09 - ctx_tree
Rem    rpalakod    08/17/09 - Bug 8809055
Rem    rpalakod    08/09/09 - autooptimize
Rem    rpalakod    02/06/08 - Bug 6798472: ent-ext views show all users data
Rem    rpalakod    01/22/08 - Reduce maximum entity length to 512
Rem    rpalakod    01/12/08 - Entity Extraction
Rem    wclin       05/11/07 - bug5996259: support sql92 security
Rem    ymatsuda    01/18/07 - ndata
Rem    wclin       12/11/06 - clob query support
Rem    ymatsuda    10/13/06 - commit at the end
Rem    oshiowat    10/08/06 - inxight integration (cont.) 
Rem    surman      09/27/06 - 5438110: Add filename_charset
Rem    skabraha    08/24/06 - add dr$activelogs
Rem    wclin       08/11/06 - bug5401928: fix pending view hints
Rem    wclin       08/08/06 - add section id to cdi views
Rem    skabraha    08/03/06 - add dr$slowqrys
Rem    rigandhi    07/14/06 - name search 
Rem    skabraha    07/07/06 - add changed views 
Rem    oshiowat    06/22/06 - inxight integration 
Rem    skabraha    06/13/06 - add dr$freqtoks
Rem    wclin       05/22/06 - add cdi orderby col sort order 
Rem    ymatsuda    02/20/06 - add sec_datatype column 
Rem    wclin       02/16/06 - modify dr$sdata_update 
Rem    mfaisal     02/08/06 - bug 4742903 
Rem    wclin       02/02/06 - rm indextype public synonyms 
Rem    yucheng     01/20/06 - upgrade dr$index 
Rem    gkaminag    10/24/05 - sdata update 
Rem    gkaminag    10/16/05 - mdata column 
Rem    gkaminag    09/29/05 - cdi indexing 
Rem    oshiowat    08/10/05 - Feature usage tracking 
Rem    gkaminag    02/21/05 - gkaminag_test_050217
Rem    gkaminag    02/17/05 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

REM
REM  IF YOU ADD ANYTHING TO THIS FILE REMEMBER TO CHANGE DOWNGRADE SCRIPT
REM

REM CDI

ALTER TABLE dr$index add (
  idx_src_name varchar2(30) default NULL,
  idx_src_id   number       default 0
);

CREATE TABLE dr$index_cdi_column (
  cdi_idx_id          number,
  cdi_column_position number,
  cdi_column_name     varchar2(256),
  cdi_column_type     varchar2(30),
  cdi_column_type#    number,
  cdi_column_length   number,
  cdi_section_name    varchar2(30),
  cdi_section_type    number,
  cdi_section_id      number,
  cdi_sort_order      varchar2(8),
  primary key (cdi_idx_id, cdi_column_position, cdi_column_name)
)
organization index;

create or replace view ctx_filter_by_columns as
select 
  u.name   fbc_index_owner
 ,idx_name fbc_index_name
 ,u2.name  fbc_table_owner
 ,o.name   fbc_table_name
 ,cdi_column_name fbc_column_name
 ,cdi_column_type fbc_column_type
 ,cdi_section_name    fbc_section_name
 ,decode(cdi_section_type,8,'SDATA',9,'MDATA','UNKNOWN')    fbc_section_type
 ,cdi_section_id      fbc_section_id
 from dr$index_cdi_column, dr$index, sys."_BASE_USER" u, sys.obj$ o, 
      sys."_BASE_USER" u2
where cdi_idx_id = idx_id
  and cdi_column_position = 0
  and idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
/

create or replace view ctx_user_filter_by_columns as
select 
  idx_name fbc_index_name
 ,u.name   fbc_table_owner
 ,o.name   fbc_table_name
 ,cdi_column_name fbc_column_name
 ,cdi_column_type fbc_column_type
 ,cdi_section_name    fbc_section_name
 ,decode(cdi_section_type,8,'SDATA',9,'MDATA','UNKNOWN')    fbc_section_type
 ,cdi_section_id      fbc_section_id
 from dr$index_cdi_column, dr$index, sys.obj$ o, 
      sys."_BASE_USER" u
where cdi_idx_id = idx_id
  and cdi_column_position = 0
  and idx_table_owner# = u.user#
  and idx_table# = o.obj#
  and idx_owner# = userenv('SCHEMAID')
/

create or replace public synonym ctx_user_filter_by_columns 
for ctxsys.ctx_user_filter_by_columns;
grant select on ctx_user_filter_by_columns to public;

create or replace view ctx_order_by_columns as
select 
  u.name   obc_index_owner
 ,idx_name obc_index_name
 ,u2.name  obc_table_owner
 ,o.name   obc_table_name
 ,cdi_column_name     obc_column_name
 ,cdi_column_position obc_column_position
 ,cdi_column_type     obc_column_type
 ,cdi_section_name    obc_section_name
 ,decode(cdi_section_type,8,'SDATA',9,'MDATA','UNKNOWN')    obc_section_type
 ,cdi_section_id      obc_section_id
 ,cdi_sort_order      obc_sort_order
 from dr$index_cdi_column, dr$index, sys."_BASE_USER" u, sys.obj$ o, 
      sys."_BASE_USER" u2
where cdi_idx_id = idx_id
  and cdi_column_position != 0
  and idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
/

create or replace view ctx_user_order_by_columns as
select 
  idx_name obc_index_name
 ,u.name   obc_table_owner
 ,o.name   obc_table_name
 ,cdi_column_name     obc_column_name
 ,cdi_column_position obc_column_position
 ,cdi_column_type     obc_column_type
 ,cdi_section_name    obc_section_name
 ,decode(cdi_section_type,8,'SDATA',9,'MDATA','UNKNOWN')   obc_section_type
 ,cdi_section_id      obc_section_id
 ,cdi_sort_order      obc_sort_order
 from dr$index_cdi_column, dr$index, sys.obj$ o, 
      sys."_BASE_USER" u
where cdi_idx_id = idx_id
  and cdi_column_position != 0
  and idx_table_owner# = u.user#
  and idx_table# = o.obj#
  and idx_owner# = userenv('SCHEMAID')
/
create or replace public synonym ctx_user_order_by_columns 
for ctxsys.ctx_user_order_by_columns;
grant select on ctx_user_order_by_columns to public;

insert into dr$object_attribute values
  (90109, 9, 1, 9, 
   'S_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');
insert into dr$object_attribute values
  (50108, 5, 1, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50109, 5, 1, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50208, 5, 2, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50209, 5, 2, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50210, 5, 2, 10, 
   'SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50211, 5, 2, 11, 
   'NDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50308, 5, 3, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50309, 5, 3, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50310, 5, 3, 10, 
   'SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50311, 5, 3, 11, 
   'NDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50508, 5, 5, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50509, 5, 5, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50510, 5, 5, 10, 
   'SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50511, 5, 5, 11, 
   'NDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50608, 5, 6, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50609, 5, 6, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50610, 5, 6, 10, 
   'SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50611, 5, 6, 11, 
   'NDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50708, 5, 7, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50709, 5, 7, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50808, 5, 8, 8, 
   'COLUMN_SDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');
insert into dr$object_attribute values
  (50809, 5, 8, 9, 
   'COLUMN_MDATA', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

REM 5438110: Add filename_charset
begin
  insert into dr$object_attribute values
    (10302, 1, 3, 2, 
     'FILENAME_CHARSET', 'Character set to which filenames will be converted',
     'N', 'N', 'Y', 'S', 
     'NONE', null, null, 'N');
exception
  when dup_val_on_index then
    null;  -- Ignore error since this attribute may have been backported
end;
/

commit;

alter table dr$section modify(sec_tag varchar2(256));
alter table dr$section add (sec_datatype number);

create or replace view ctx_sections as
select
   u.name            sec_owner,
   sgp_name          sec_section_group,
   decode(sec_type, 1, 'ZONE', 2, 'FIELD', 3, 'SPECIAL', 4, 'STOP', 
                    5, 'ATTR', 7, 'MDATA', 8, 'COLUMN SDATA', 
                    9, 'COLUMN MDATA', 10, 'SDATA', null)
                     sec_type,
   sec_id            sec_id,
   decode(sec_type, 4, null, sec_name)
                     sec_name,
   sec_tag           sec_tag,
   sec_visible       sec_visible,
   decode(sec_datatype, 2, 'NUMBER', 5, 'VARCHAR2', 12, 'DATE', 23, 'RAW', 
                        null)
                     sec_datatype
from dr$section sec, dr$section_group sgp, sys."_BASE_USER" u
where sgp.sgp_id = sec.sec_sgp_id
  and sgp_owner# = u.user#
/
create or replace view ctx_user_sections as
select
   sgp_name          sec_section_group,
   decode(sec_type, 1, 'ZONE', 2, 'FIELD', 3, 'SPECIAL', 4, 'STOP', 
                    5, 'ATTR', 7, 'MDATA', 8, 'COLUMN SDATA', 
                    9, 'COLUMN MDATA', 10, 'SDATA', null)
                     sec_type,
   sec_id            sec_id,
   decode(sec_type, 4, null, sec_name)
                     sec_name,
   sec_tag           sec_tag,
   sec_visible       sec_visible,
   decode(sec_datatype, 2, 'NUMBER', 5, 'VARCHAR2', 12, 'DATE', 23, 'RAW', 
                        null)
                     sec_datatype
from dr$section sec, dr$section_group sgp
where sgp.sgp_id = sec.sec_sgp_id
  and sgp_owner# = userenv('SCHEMAID')
/

REM CTX_INDEXES and CTX_USER_INDEXES have changed

create or replace view ctx_indexes as
select
  idx_id
 ,u.name                 idx_owner
 ,idx_name               idx_name
 ,u2.name                idx_table_owner
 ,o.name                 idx_table
 ,idx_key_name           idx_key_name
 ,idx_text_name          idx_text_name
 ,idx_docid_count        idx_docid_count
 ,idx_status             idx_status
 ,idx_language_column    idx_language_column
 ,idx_format_column      idx_format_column
 ,idx_charset_column     idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE') idx_type
 ,idx_sync_type          idx_sync_type
 ,idx_sync_memory        idx_sync_memory
 ,idx_sync_para_degree   idx_sync_para_degree
 ,idx_sync_interval      idx_sync_interval
 ,idx_sync_jobname       idx_sync_jobname
 ,decode(instr(idx_option, 'Z'), 0, 'NO', NULL, 'NO', 'YES')
                         idx_query_stats_enabled
 from dr$index, sys."_BASE_USER" u, sys.obj$ o, sys."_BASE_USER" u2
where idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
/

create or replace view ctx_user_indexes as
select
  idx_id
 ,idx_name               idx_name
 ,u.name                 idx_table_owner
 ,o.name                 idx_table
 ,idx_key_name           idx_key_name
 ,idx_text_name          idx_text_name
 ,idx_docid_count        idx_docid_count
 ,idx_status             idx_status
 ,idx_language_column    idx_language_column
 ,idx_format_column      idx_format_column
 ,idx_charset_column     idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE') idx_type
 ,idx_sync_type          idx_sync_type
 ,idx_sync_memory        idx_sync_memory
 ,idx_sync_para_degree   idx_sync_para_degree
 ,idx_sync_interval      idx_sync_interval
 ,idx_sync_jobname       idx_sync_jobname
 ,decode(instr(idx_option, 'Z'), 0, 'NO', NULL, 'NO', 'YES')
                         idx_query_stats_enabled
 from dr$index, sys."_BASE_USER" u, sys.obj$ o
where idx_owner# = userenv('SCHEMAID')
  and idx_table_owner# = u.user#
  and idx_table# = o.obj#
/

CREATE OR REPLACE VIEW ctx_pending AS
select /*+ ORDERED USE_NL(i p d) */
       u.name      pnd_index_owner,
       idx_name    pnd_index_name,
       ixp_name    pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from sys."_BASE_USER" u, dr$index i, dr$index_partition p, dr$pending d
 where idx_owner# = u.user#
   and idx_id = ixp_idx_id
   and pnd_pid = ixp_id
   and pnd_pid != 0
   and pnd_cid = idx_id
UNION ALL
select /*+ ORDERED USE_NL(i d) */
       u.name      pnd_index_owner,
       idx_name    pnd_index_name,
       null        pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from sys."_BASE_USER" u, dr$index i, dr$pending d
 where idx_owner# = u.user#
   and pnd_pid = 0
   and pnd_cid = idx_id
/

CREATE OR REPLACE VIEW ctx_user_pending AS
select /*+ ORDERED USE_NL(i p d)*/
       idx_name  pnd_index_name,
       ixp_name  pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$index i, dr$index_partition p, dr$pending d
 where idx_id = ixp_idx_id
   and pnd_pid = ixp_id
   and pnd_cid != 0
   and pnd_cid = idx_id
   and idx_owner# = userenv('SCHEMAID')
UNION ALL
select /*+ ORDERED USE_NL(i d) */
       idx_name  pnd_index_name,
       null      pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$index i, dr$pending d 
 where pnd_pid = 0
   and pnd_cid = idx_id
   and idx_owner# = userenv('SCHEMAID')
/


REM ========================================================================
REM dr$sdata_update
REM ========================================================================

create table dr$sdata_update (
  sdu_idx_id    number,
  sdu_ixp_id    number,
  sdu_sdata_id  number,
  sdu_docid     number,
  sdu_nv_type   varchar2(30),
  sdu_nv_ndata  number,
  sdu_nv_ddata  date,
  sdu_nv_cdata  varchar2(250),
  sdu_nv_rdata  raw(250),
  constraint drc$sdu_key 
    primary key (sdu_idx_id, sdu_ixp_id, sdu_sdata_id, sdu_docid)
)
organization index;


CREATE OR REPLACE VIEW drv$sdata_update as
select * from dr$sdata_update;

grant select on drv$sdata_update to public;

CREATE OR REPLACE VIEW drv$sdata_update2 as 
select * from dr$sdata_update
where sdu_idx_id = SYS_CONTEXT('DR$APPCTX','IDXID')
with check option;

grant select, insert, delete on drv$sdata_update2 to public;

-- bug 5996259, support sql92_security=true
grant select on drv$unindexed2 to public;

create or replace procedure syncrn (
  ownid IN binary_integer,
  oname IN varchar2,
  idxid IN binary_integer,
  ixpid IN binary_integer,
  rtabnm IN varchar2,
  srcflg IN binary_integer
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
    srcflg ub1
);
/

REM ===================================================================
REM Drop public synonym for the indextypes
REM ===================================================================
drop public synonym context;
drop public synonym ctxcat;
drop public synonym ctxrule;
drop public synonym ctxxpath;

REM ===================================================================
REM WILDCARD_MAXTERMS
REM ===================================================================
update dr$object_attribute
  set oat_default = 20000
  where oat_id = 70106;
update dr$object_attribute
  set oat_val_max = 50000
  where oat_id = 70106;
commit;
REM ===================================================================
REM Feature Usage Table
REM ===================================================================
create table dr$feature_used
(
feature_name varchar2(1000),
feature_type integer,
feature_used integer,
constraint dr$feat_key primary key (feature_name, feature_type)
); 

REM -------------------------------------------------------------------
REM dr$freqtoks
REM -------------------------------------------------------------------

rem This table stores away the information on frequently queried tokens.

create table dr$freqtoks (
   fqt_idx_id     number,
   fqt_ixp_id     number,
   fqt_flush_id   number,
   fqt_token      varchar2(64),
   fqt_tktype     number,
   fqt_numocc     number
);

create index idx1_dr$freqtoks on dr$freqtoks(fqt_idx_id, fqt_ixp_id);

create index idx2_dr$freqtoks on dr$freqtoks(fqt_flush_id);

REM -------------------------------------------------------------------
REM dr$slowqrys
REM -------------------------------------------------------------------

rem This table stores away the information on slowest running queries.

create table dr$slowqrys (
   sq_idx_id     number,
   sq_ixp_id     number,
   sq_qry_hash   number,
   sq_text_qry   varchar2(100),
   sq_tqry_len   number,
   sq_when_run   date,
   sq_time_taken number,
   sq_query      varchar2(4000),
   sq_qry_len    number
);

create index idx1_dr$slowqrys on dr$slowqrys(sq_idx_id, sq_ixp_id);

REM -------------------------------------------------------------------
REM dr$activelogs
REM -------------------------------------------------------------------

rem This table stores away the information on logs which are currently active

create table dr$activelogs (
   alogs_sid           number,         /* session id */
   alogs_sno           number,         /* serial no: */
   alogs_filename      varchar2(4000)
);

REM ===================================================================
REM dr$sqe - clob support
REM ===================================================================
-- since we cannot alter sqe_query type directly from varchar to clob
-- we need to make a copy of it.
alter table dr$sqe rename to dr$sqe_sav;
CREATE TABLE dr$sqe(
 sqe_owner#               NUMBER         NOT NULL,
 sqe_name                 VARCHAR2(30)   NOT NULL,
 sqe_query                CLOB NOT NULL,
 PRIMARY KEY (sqe_owner#, sqe_name)
)
organization index overflow
/
insert into dr$sqe select sqe_owner#, sqe_name, to_clob(sqe_query) 
  from dr$sqe_sav;
commit;

drop table dr$sqe_sav purge;

create or replace view ctx_sqes as
select u.name     sqe_owner,
       sqe_name,   
       sqe_query   
  from dr$sqe sqe, sys."_BASE_USER" u
 where sqe_owner# = u.user# 
/

create or replace view ctx_user_sqes as
select u.name     sqe_owner,
       sqe_name, 
       sqe_query
  from dr$sqe sqe, sys."_BASE_USER" u
 where sqe_owner# = u.user#
   and u.user# = userenv('SCHEMAID')
/


REM ===================================================================
REM Inxight Integration Proj.
REM ===================================================================

insert into dr$object values
  (6, 12, 'AUTO_LEXER', 'Auto Lexer', 'N');

insert into dr$object_attribute values
  (61201, 6, 12, 1, 
   'BASE_LETTER', 'Base-letter conversion',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (61202, 6, 12, 2, 
   'BASE_LETTER_TYPE', 'Type of base_letter',
   'N', 'N', 'Y', 'I', 
   'GENERIC', null, null, 'Y');

insert into dr$object_attribute_lov values
  (61202, 'GENERIC', 0, 'Works in all languages');

insert into dr$object_attribute_lov values
  (61202, 'SPECIFIC', 1, 'NLS_LANG specific');

insert into dr$object_attribute values
  (61203, 6, 12, 3, 
   'OVERRIDE_BASE_LETTER', 'Alternate Spelling override Base Letter for umlauts',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (61204, 6, 12, 4, 
   'MIXED_CASE', 'Preserve mixed-case',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (61205, 6, 12, 5, 
   'ALTERNATE_SPELLING', 'Language for alternate spelling',
   'N', 'N', 'Y', 'I', 
   'NONE', null, null, 'Y');

insert into dr$object_attribute_lov values
  (61205, 'NONE', 0, 'None');

insert into dr$object_attribute_lov values
  (61205, 'GERMAN', 1, 'German');

insert into dr$object_attribute_lov values
  (61205, 'DANISH', 2, 'Danish');

insert into dr$object_attribute_lov values
  (61205, 'SWEDISH', 3, 'Swedish');

insert into dr$object_attribute values
  (61206, 6, 12, 6, 
   'LANGUAGE', 'Language for Auto Lexer',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61207, 6, 12, 7, 
   'INDEX_STEMS', 'Perform index stems',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (61208, 6, 12, 8, 
   'DERIV_STEMS', 'Perform derivational index stems',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (61209, 6, 12, 9, 
   'GERMAN_DECOMPOUND', 'Perform german decompounding',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (61210, 6, 12, 10, 
   'SENTENCE_TOKEN_LIMIT', 'The Maximum number of tokens allowed in a sentence',
   'N', 'N', 'Y', 'I', 
   '100', null, null, 'N');

insert into dr$object_attribute values
  (61211, 6, 12, 11, 
   'ARABIC_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61212, 6, 12, 12, 
   'CATALAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61213, 6, 12, 13, 
   'CROATIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61214, 6, 12, 14, 
   'CZECH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61215, 6, 12, 15, 
   'DANISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61216, 6, 12, 16, 
   'DUTCH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61217, 6, 12, 17, 
   'ENGLISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61218, 6, 12, 18, 
   'FINNISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61219, 6, 12, 19, 
   'FRENCH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61220, 6, 12, 20, 
   'GERMAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61221, 6, 12, 21, 
   'GREEK_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61222, 6, 12, 22, 
   'HEBREW_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61223, 6, 12, 23, 
   'HUNGARIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61224, 6, 12, 24, 
   'ITALIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61225, 6, 12, 25, 
   'KOREAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61226, 6, 12, 26, 
   'BOKMAL_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61227, 6, 12, 27, 
   'NYNORSK_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61228, 6, 12, 28, 
   'PERSIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61229, 6, 12, 29, 
   'POLISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61230, 6, 12, 30, 
   'PORTUGUESE_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61231, 6, 12, 31, 
   'ROMANIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61232, 6, 12, 32, 
   'RUSSIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61233, 6, 12, 33, 
   'SERBIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61234, 6, 12, 34, 
   'SLOVAK_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61235, 6, 12, 35, 
   'SLOVENIAN_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61236, 6, 12, 36, 
   'SPANISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61237, 6, 12, 37, 
   'SWEDISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61238, 6, 12, 38, 
   'TURKISH_PREFIX_MORPHEMES', 'Space-delimited list of inflectional prefixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61239, 6, 12, 39, 
   'ARABIC_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61240, 6, 12, 40, 
   'CATALAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61241, 6, 12, 41, 
   'CROATIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61242, 6, 12, 42, 
   'CZECH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61243, 6, 12, 43, 
   'DANISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61244, 6, 12, 44, 
   'DUTCH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61245, 6, 12, 45, 
   'ENGLISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   's es er', null, null, 'N');

insert into dr$object_attribute values
  (61246, 6, 12, 46, 
   'FINNISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61247, 6, 12, 47, 
   'FRENCH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'ne e', null, null, 'N');

insert into dr$object_attribute values
  (61248, 6, 12, 48, 
   'GERMAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'in innen', null, null, 'N');

insert into dr$object_attribute values
  (61249, 6, 12, 49, 
   'GREEK_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61250, 6, 12, 50, 
   'HEBREW_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61251, 6, 12, 51, 
   'HUNGARIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61252, 6, 12, 52, 
   'ITALIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61253, 6, 12, 53, 
   'KOREAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61254, 6, 12, 54, 
   'BOKMAL_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61255, 6, 12, 55, 
   'NYNORSK_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61256, 6, 12, 56, 
   'PERSIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61257, 6, 12, 57, 
   'POLISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61258, 6, 12, 58, 
   'PORTUGUESE_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   's es', null, null, 'N');

insert into dr$object_attribute values
  (61259, 6, 12, 59, 
   'ROMANIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61260, 6, 12, 60, 
   'RUSSIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61261, 6, 12, 61, 
   'SERBIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61262, 6, 12, 62, 
   'SLOVAK_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61263, 6, 12, 63, 
   'SLOVENIAN_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61264, 6, 12, 64, 
   'SPANISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'ba n s es', null, null, 'N');

insert into dr$object_attribute values
  (61265, 6, 12, 65, 
   'SWEDISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61266, 6, 12, 66, 
   'TURKISH_SUFFIX_MORPHEMES', 'Space-delimited list of inflectional suffixes',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61267, 6, 12, 67, 
   'ARABIC_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61268, 6, 12, 68, 
   'CATALAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61269, 6, 12, 69, 
   'SIMP_CHINESE_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61270, 6, 12, 70, 
   'TRAD_CHINESE_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61271, 6, 12, 71, 
   'CROATIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61272, 6, 12, 72, 
   'CZECH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61273, 6, 12, 73, 
   'DANISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61274, 6, 12, 74, 
   'DUTCH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61275, 6, 12, 75, 
   'ENGLISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61276, 6, 12, 76, 
   'FINNISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61277, 6, 12, 77, 
   'FRENCH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61278, 6, 12, 78, 
   'GERMAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'in innen', null, null, 'N');

insert into dr$object_attribute values
  (61279, 6, 12, 79, 
   'GREEK_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61280, 6, 12, 80, 
   'HEBREW_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61281, 6, 12, 81, 
   'HUNGARIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61282, 6, 12, 82, 
   'ITALIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61283, 6, 12, 83, 
   'JAPANESE_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61284, 6, 12, 84, 
   'KOREAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61285, 6, 12, 85, 
   'BOKMAL_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61286, 6, 12, 86, 
   'NYNORSK_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61287, 6, 12, 87, 
   'PERSIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61288, 6, 12, 88, 
   'POLISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61289, 6, 12, 89, 
   'PORTUGUESE_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61290, 6, 12, 90, 
   'ROMANIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61291, 6, 12, 91, 
   'RUSSIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61292, 6, 12, 92, 
   'SERBIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61293, 6, 12, 93, 
   'SLOVAK_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61294, 6, 12, 94, 
   'SLOVENIAN_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61295, 6, 12, 95, 
   'SPANISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61296, 6, 12, 96, 
   'SWEDISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61297, 6, 12, 97, 
   'THAI_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61298, 6, 12, 98, 
   'TURKISH_PUNCTUATIONS', 'Space-delimited list of punctuations',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (61299, 6, 12, 99, 
   'ARABIC_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061200, 6, 12, 100, 
   'CATALAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061201, 6, 12, 101, 
   'SIMP_CHINESE_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061202, 6, 12, 102, 
   'TRAD_CHINESE_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061203, 6, 12, 103, 
   'CROATIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061204, 6, 12, 104, 
   'CZECH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061205, 6, 12, 105, 
   'DANISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061206, 6, 12, 106, 
   'DUTCH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061207, 6, 12, 107, 
   'ENGLISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061208, 6, 12, 108, 
   'FINNISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061209, 6, 12, 109, 
   'FRENCH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061210, 6, 12, 110, 
   'GERMAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'in innen', null, null, 'N');

insert into dr$object_attribute values
  (1061211, 6, 12, 111, 
   'GREEK_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061212, 6, 12, 112, 
   'HEBREW_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061213, 6, 12, 113, 
   'HUNGARIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061214, 6, 12, 114, 
   'ITALIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061215, 6, 12, 115, 
   'JAPANESE_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061216, 6, 12, 116, 
   'KOREAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061217, 6, 12, 117, 
   'BOKMAL_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061218, 6, 12, 118, 
   'NYNORSK_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061219, 6, 12, 119, 
   'PERSIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061220, 6, 12, 120, 
   'POLISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061221, 6, 12, 121, 
   'PORTUGUESE_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061222, 6, 12, 122, 
   'ROMANIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061223, 6, 12, 123, 
   'RUSSIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061224, 6, 12, 124, 
   'SERBIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061225, 6, 12, 125, 
   'SLOVAK_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061226, 6, 12, 126, 
   'SLOVENIAN_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061227, 6, 12, 127, 
   'SPANISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061228, 6, 12, 128, 
   'SWEDISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061229, 6, 12, 129, 
   'THAI_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061230, 6, 12, 130, 
   'TURKISH_SENTENCE_STARTS', 'Space-delimited list of sentence_starts',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061231, 6, 12, 131, 
   'ARABIC_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061232, 6, 12, 132, 
   'CATALAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061233, 6, 12, 133, 
   'SIMP_CHINESE_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061234, 6, 12, 134, 
   'TRAD_CHINESE_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061235, 6, 12, 135, 
   'CROATIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061236, 6, 12, 136, 
   'CZECH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061237, 6, 12, 137, 
   'DANISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061238, 6, 12, 138, 
   'DUTCH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061239, 6, 12, 139, 
   'ENGLISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061240, 6, 12, 140, 
   'FINNISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061241, 6, 12, 141, 
   'FRENCH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061242, 6, 12, 142, 
   'GERMAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'in innen', null, null, 'N');

insert into dr$object_attribute values
  (1061243, 6, 12, 143, 
   'GREEK_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061244, 6, 12, 144, 
   'HEBREW_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061245, 6, 12, 145, 
   'HUNGARIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061246, 6, 12, 146, 
   'ITALIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061247, 6, 12, 147, 
   'JAPANESE_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061248, 6, 12, 148, 
   'KOREAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061249, 6, 12, 149, 
   'BOKMAL_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061250, 6, 12, 150, 
   'NYNORSK_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061251, 6, 12, 151, 
   'PERSIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061252, 6, 12, 152, 
   'POLISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061253, 6, 12, 153, 
   'PORTUGUESE_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061254, 6, 12, 154, 
   'ROMANIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061255, 6, 12, 155, 
   'RUSSIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061256, 6, 12, 156, 
   'SERBIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061257, 6, 12, 157, 
   'SLOVAK_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061258, 6, 12, 158, 
   'SLOVENIAN_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061259, 6, 12, 159, 
   'SPANISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061260, 6, 12, 160, 
   'SWEDISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061261, 6, 12, 161, 
   'THAI_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061262, 6, 12, 162, 
   'TURKISH_NON_SENT_END_ABBR', 'Space-delimited list of non_sent_end_abbr',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');


insert into dr$object_attribute values
  (1061263, 6, 12, 163, 
   'ARABIC_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061264, 6, 12, 164, 
   'CATALAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061265, 6, 12, 165, 
   'SIMP_CHINESE_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061266, 6, 12, 166, 
   'TRAD_CHINESE_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061267, 6, 12, 167, 
   'CROATIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061268, 6, 12, 168, 
   'CZECH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061269, 6, 12, 169, 
   'DANISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061270, 6, 12, 170, 
   'DUTCH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061271, 6, 12, 171, 
   'ENGLISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061272, 6, 12, 172, 
   'FINNISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061273, 6, 12, 173, 
   'FRENCH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061274, 6, 12, 174, 
   'GERMAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061275, 6, 12, 175, 
   'GREEK_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061276, 6, 12, 176, 
   'HEBREW_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061277, 6, 12, 177, 
   'HUNGARIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061278, 6, 12, 178, 
   'ITALIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061279, 6, 12, 179, 
   'JAPANESE_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061280, 6, 12, 180, 
   'KOREAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061281, 6, 12, 181, 
   'BOKMAL_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061282, 6, 12, 182, 
   'NYNORSK_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061283, 6, 12, 183, 
   'PERSIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061284, 6, 12, 184, 
   'POLISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061285, 6, 12, 185, 
   'PORTUGUESE_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061286, 6, 12, 186, 
   'ROMANIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061287, 6, 12, 187, 
   'RUSSIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061288, 6, 12, 188, 
   'SERBIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061289, 6, 12, 189, 
   'SLOVAK_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061290, 6, 12, 190, 
   'SLOVENIAN_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061291, 6, 12, 191, 
   'SPANISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061292, 6, 12, 192, 
   'SWEDISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061293, 6, 12, 193, 
   'THAI_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061294, 6, 12, 194, 
   'TURKISH_ABBR_DICT', 'Name of abbreviation dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061295, 6, 12, 195, 
   'ARABIC_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061296, 6, 12, 196, 
   'CATALAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061297, 6, 12, 197, 
   'SIMP_CHINESE_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061298, 6, 12, 198, 
   'TRAD_CHINESE_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (1061299, 6, 12, 199, 
   'CROATIAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061200, 6, 12, 200, 
   'DANISH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061201, 6, 12, 201, 
   'DUTCH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061202, 6, 12, 202, 
   'ENGLISH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061203, 6, 12, 203, 
   'FINNISH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061204, 6, 12, 204, 
   'FRENCH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061205, 6, 12, 205, 
   'GERMAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061206, 6, 12, 206, 
   'ITALIAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061207, 6, 12, 207, 
   'JAPANESE_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061208, 6, 12, 208, 
   'KOREAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061209, 6, 12, 209, 
   'BOKMAL_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061210, 6, 12, 210, 
   'NYNORSK_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061211, 6, 12, 211, 
   'PERSIAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061212, 6, 12, 212, 
   'PORTUGUESE_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061213, 6, 12, 213, 
   'RUSSIAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061214, 6, 12, 214, 
   'SLOVAK_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061215, 6, 12, 215, 
   'SLOVENIAN_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061216, 6, 12, 216, 
   'SPANISH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061217, 6, 12, 217, 
   'SWEDISH_TAG_DICT', 'Name of tagging dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061218, 6, 12, 218, 
   'ARABIC_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061219, 6, 12, 219, 
   'CATALAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061220, 6, 12, 220, 
   'SIMP_CHINESE_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061221, 6, 12, 221, 
   'TRAD_CHINESE_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061222, 6, 12, 222, 
   'CROATIAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061223, 6, 12, 223, 
   'DANISH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061224, 6, 12, 224, 
   'DUTCH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061225, 6, 12, 225, 
   'ENGLISH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061226, 6, 12, 226, 
   'FINNISH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061227, 6, 12, 227, 
   'FRENCH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061228, 6, 12, 228, 
   'GERMAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061229, 6, 12, 229, 
   'ITALIAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061230, 6, 12, 230, 
   'JAPANESE_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061231, 6, 12, 231, 
   'KOREAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061232, 6, 12, 232, 
   'BOKMAL_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061233, 6, 12, 233, 
   'NYNORSK_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061234, 6, 12, 234, 
   'PERSIAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061235, 6, 12, 235, 
   'PORTUGUESE_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061236, 6, 12, 236, 
   'RUSSIAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061237, 6, 12, 237, 
   'SLOVAK_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061238, 6, 12, 238, 
   'SLOVENIAN_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061239, 6, 12, 239, 
   'SPANISH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061240, 6, 12, 240, 
   'SWEDISH_TAGSTEM_DICT', 'Name of tagged stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061241, 6, 12, 241, 
   'CZECH_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061242, 6, 12, 242, 
   'GREEK_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061243, 6, 12, 243, 
   'HEBREW_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061244, 6, 12, 244, 
   'HUNGARIAN_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061245, 6, 12, 245, 
   'POLISH_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061246, 6, 12, 246, 
   'ROMANIAN_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061247, 6, 12, 247, 
   'SERBIAN_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061248, 6, 12, 248, 
   'THAI_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061249, 6, 12, 249, 
   'TURKISH_STEM_DICT', 'Name of stemming dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061250, 6, 12, 250, 
   'SIMP_CHINESE_CCJT_DICT', 'Name of CCJT dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061251, 6, 12, 251, 
   'TRAD_CHINESE_CCJT_DICT', 'Name of CCJT dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061252, 6, 12, 252, 
   'JAPANESE_CCJT_DICT', 'Name of CCJT dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (2061253, 6, 12, 253, 
   'THAI_CCJT_DICT', 'Name of CCJT dictionary',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute_lov values
  (60120, 'ARABIC', 8, 'Arabic');

insert into dr$object_attribute_lov values
  (60120, 'BOKMAL', 9, 'Bokmal');

insert into dr$object_attribute_lov values
  (60120, 'CATALAN', 10, 'Catalan');

insert into dr$object_attribute_lov values
  (60120, 'CROATIAN', 11, 'Croatian');

insert into dr$object_attribute_lov values
  (60120, 'CZECH', 12, 'Czech');

insert into dr$object_attribute_lov values
  (60120, 'DANISH', 13, 'Danish');

insert into dr$object_attribute_lov values
  (60120, 'FINNISH', 14, 'Finnish');

insert into dr$object_attribute_lov values
  (60120, 'GREEK', 15, 'Greek');

insert into dr$object_attribute_lov values
  (60120, 'HEBREW', 16, 'Hebrew');

insert into dr$object_attribute_lov values
  (60120, 'HUNGARIAN', 17, 'Hungarian');

insert into dr$object_attribute_lov values
  (60120, 'NYNORSK', 18, 'Nynorsk');

insert into dr$object_attribute_lov values
  (60120, 'POLISH', 19, 'Polish');

insert into dr$object_attribute_lov values
  (60120, 'PORTUGUESE', 20, 'Portuguese');

insert into dr$object_attribute_lov values
  (60120, 'ROMANIAN', 21, 'Romanian');

insert into dr$object_attribute_lov values
  (60120, 'RUSSIAN', 22, 'Russian');

insert into dr$object_attribute_lov values
  (60120, 'SERBIAN', 23, 'Serbian');

insert into dr$object_attribute_lov values
  (60120, 'SLOVAK', 24, 'Slovak');

insert into dr$object_attribute_lov values
  (60120, 'SLOVENIAN', 25, 'Slovenian');

insert into dr$object_attribute_lov values
  (60120, 'SWEDISH', 26, 'Swedish');

insert into dr$object_attribute_lov values
  (60120, 'ENGLISH_NEW', 27, 'English New');

insert into dr$object_attribute_lov values
  (60120, 'DERIVATIONAL_NEW', 28, 'Eng New (Deriv)');

insert into dr$object_attribute_lov values
  (60120, 'DUTCH_NEW', 29, 'Dutch New');

insert into dr$object_attribute_lov values
  (60120, 'FRENCH_NEW', 30, 'French New');

insert into dr$object_attribute_lov values
  (60120, 'GERMAN_NEW', 31, 'German New');

insert into dr$object_attribute_lov values
  (60120, 'ITALIAN_NEW', 32, 'Italian New');

insert into dr$object_attribute_lov values
  (60120, 'SPANISH_NEW', 33, 'Spanish New');

insert into dr$object_attribute values
  (70110, 7, 1, 10, 
   'NDATA_ALTERNATE_SPELLING', 'Alternate spelling for NDATA',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (70111, 7, 1, 11, 
   'NDATA_BASE_LETTER', 'Base letter for NDATA',
   'N', 'N', 'Y', 'B', 
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (70112, 7, 1, 12, 
   'NDATA_JOIN_PARTICLES', 'name particles that can be join with a surname',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (70113, 7, 1, 13, 
   'NDATA_THESAURUS', 'Thesaurus of alternate names for NDATA',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

commit;

rem NDATA

grant select on dr$ths to public;
grant select on dr$ths_phrase to public;


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

REM ===================================================================
REM CTX_TREE Tables AND Views
REM ===================================================================

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

/

@?/rdbms/admin/sqlsessend.sql
