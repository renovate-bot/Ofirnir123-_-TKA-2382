Rem
Rem $Header: ctx_src_2/src/dr/admin/d1200000.sql /main/32 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1200000.sql
Rem
Rem Copyright (c) 2011, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1200000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 12.1 to 11.2.0.2
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1200000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1200000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    yinlu       08/28/15 - lrg 18241069: revoke create sequence privilege
Rem                           from ctxapp
Rem    surman      04/21/15 - 20741195: Check object type
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    gpodila     11/06/14 - Bug 14254610 index optimization in rebuild fails
Rem    gpodila     10/22/14 - Bug 13640676 cannot exchange table partition
Rem    boxia       11/26/13 - modify Btree-backed sdata clauses
Rem    aczarlin    12/13/11 - btree sdata dtypes
Rem    bhristov    11/10/11 - revoke SET CONTAINER from ctxsys
Rem    rkadwe      11/14/11 - ATG downgrade changes
Rem    rpalakod    10/14/11 - range postings
Rem    thbaby      08/24/11 - delete E_TABLE_CLAUSE storage attribute
Rem    thbaby      08/24/11 - delete ns_enable section group attribute
Rem    thbaby      06/14/11 - delete xml_enable section group attribute
Rem    thbaby      06/14/11 - drop table dr$section_group_attribute
Rem    ssethuma    05/06/11 - Section specific stoplist
Rem    rpalakod    02/08/11 - downgrade from 12.1
Rem    rpalakod    02/08/11 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


  
REM ==================================================================
REM Reverse Changes from Forward Index project
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90119 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=19
    and OAT_NAME='FORWARD_INDEX';
delete from dr$object_attribute
  where OAT_ID=90120 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=20
    and OAT_NAME='O_TABLE_CLAUSE';
delete from dr$object_attribute
  where OAT_ID=90121 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=21
    and OAT_NAME='O_INDEX_CLAUSE';
delete from dr$object_attribute
  where OAT_ID=90122 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=22
    and OAT_NAME='SAVE_COPY';
delete from dr$object_attribute
  where OAT_ID=90123 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=23
    and OAT_NAME='D_TABLE_CLAUSE';
delete from dr$object_attribute
  where OAT_ID=90124 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=24
    and OAT_NAME='SAVE_COPY_MAX_SIZE';
commit;

REM ==================================================================
REM Reverse Changes from range postings
REM ==================================================================
delete from dr$object_attribute
  where oat_id=90125 and oat_cla_id=9 and oat_obj_id=1 and oat_att_id=25
    and oat_name='SN_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id=90126 and oat_cla_id=9 and oat_obj_id=1 and oat_att_id=26
    and oat_name='SN_INDEX_CLAUSE';

REM ===================================================================
REM Reverse Section specific stoplist changes
REM ===================================================================

delete from dr$index_value where ixv_sub_oat_id = 240109;


REM ===================================================================
REM Reverse Section specific attributes project changes
REM ===================================================================

REM Migrating back from section specific attributes infrastructure to
REM colon separated infrastructure

declare
  sec_id       number := 0;
  sec_csv      varchar2(500);
  sec_oat_id   number;
  sec_rcnt     number;
  cnt          number := 0;
begin
  for c1 in (select ixv_idx_id, ixv_value, ixv_sub_group, ixv_sub_oat_id
               from dr$index_value, dr$object_attribute
              where ixv_oat_id = oat_id
                and oat_name = 'SECTION_ATTRIBUTE'
           order by ixv_sub_group)
  loop
    if (sec_id <> c1.ixv_sub_group) then
      sec_id := c1.ixv_sub_group;
      select count(*) into sec_rcnt from dr$index_value
        where ixv_idx_id = c1.ixv_idx_id
          and ixv_sub_group = c1.ixv_sub_group;
    end if;

    if (c1.ixv_sub_oat_id = 240107) then
      sec_csv :=  sec_csv || 'T' || c1.ixv_value;
    else
      sec_csv :=  sec_csv || c1.ixv_value ||':';
    end if;
    cnt := cnt + 1;

    if (sec_rcnt = cnt and sec_rcnt <> 0) then
      select ixv_oat_id into sec_oat_id from dr$index_value
        where ixv_idx_id = c1.ixv_idx_id
          and ixv_value = to_char(sec_id);
      insert into dr$index_value values
        (c1.ixv_idx_id, sec_oat_id, rtrim(sec_csv, ':'), 0, 0);
      delete from dr$index_value
        where ixv_idx_id = c1.ixv_idx_id
          and ixv_value = to_char(sec_id);
      delete from dr$index_value
        where ixv_idx_id = c1.ixv_idx_id
          and ixv_sub_group = sec_id;
      update dr$index_object
        set ixo_acnt = ixo_acnt - sec_rcnt
        where ixo_cla_id = 5
          and ixo_idx_id = c1.ixv_idx_id;
      sec_csv := '';
      sec_rcnt := 0;
      cnt := 0;
    end if;

  end loop;
end;
/

alter table dr$class drop constraint drc$cla_key;

drop table dr$section_attribute;

update dr$object_attribute
  set oat_datatype = 'S'
  where oat_cla_id = 5;

delete from dr$object_attribute 
  where oat_name = 'SECTION_ATTRIBUTE';

delete from dr$object_attribute
  where oat_cla_id = 24;

delete from dr$object where obj_cla_id = 24;

delete from dr$class where cla_id = 24;

delete from dr$object_attribute
  where oat_name = 'XML_ENABLE';

delete from dr$object_attribute
  where oat_name = 'NS_ENABLE';

delete from dr$object_attribute
  where oat_name = 'E_TABLE_CLAUSE';

REM ===================================================================
REM Drop configuration column from dr$index 
REM ===================================================================
alter table dr$index drop column idx_config_column;

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
  if (cnt = 1) then
    stmt := 'drop table dr$section_group_attribute';
    execute immediate stmt;
  end if;
  exception 
    when others then
      null;
end;
/

REM ===================================================================
REM Revoke SET CONTAINER privilege granted to ctxsys
REM ===================================================================
revoke set container from ctxsys;

------------------------------------------------------------------------
-- ATG Objects
------------------------------------------------------------------------
drop view CTX_USR_ANL_DICTS;

drop view CTX_AUTO_LEXER_DICTIONARIES;

drop table DR$DICTIONARY;

drop table DR$IDX_DICTIONARIES;

delete from dr$object_attribute where
   oat_cla_id = 6 and
   oat_obj_id = 12 and
   oat_name in ('PRINTJOINS', 'SKIPJOINS');

REM -------------------------------------------------------------------
REM  13640676
REM -------------------------------------------------------------------

DECLARE
  sql_q VARCHAR2(120);
BEGIN
  -- 20741195: Restrict to objects of type TABLE
  FOR rec IN (SELECT a.object_name, a.object_type, a.owner
                FROM all_objects a, all_tab_columns c
                WHERE a.object_name LIKE 'DR$%$I'
                  AND a.object_type = 'TABLE'
                  AND a.object_name = c.table_name
                  AND c.column_name = 'TOKEN_TYPE') LOOP
    sql_q:= 'CREATE TABLE dr$bug_13640676$ AS SELECT * FROM ' ||
      rec.owner || '.' || rec.object_name;
    EXECUTE IMMEDIATE sql_q;
    sql_q:= 'TRUNCATE TABLE ' || rec.owner || '.' || rec.object_name ;
    EXECUTE IMMEDIATE sql_q;
    sql_q:= 'ALTER TABLE ' || rec.owner || '.' || rec.object_name ||
      ' MODIFY (token_type NUMBER(3))';
    EXECUTE IMMEDIATE sql_q;
    sql_q:= 'INSERT INTO ' || rec.owner || '.' || rec.object_name ||
      ' SELECT * FROM dr$bug_13640676$';
    EXECUTE IMMEDIATE sql_q;
    EXECUTE IMMEDIATE 'DROP TABLE dr$bug_13640676$';
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    EXECUTE IMMEDIATE 'drop table dr$bug_13640676$';
      RAISE;
END;
/

declare 
sql_q varchar2(120);
begin
FOR r in (select idx_id , idx_option from dr$index)
LOOP
 if(r.idx_option='PY') then
  sql_q:= 'update dr$index set idx_option=''P'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
/* Bug 14254610 - Index optimization in rebuild mode fails with ORA-14097 
   after 11.2.0.3 DB upgrade */
 elsif(r.idx_option='CY') then
  sql_q:= 'update dr$index set idx_option=''C'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 elsif(r.idx_option='TQY') then
  sql_q:= 'update dr$index set idx_option=''TQ'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 elsif(r.idx_option='QTY') then
  sql_q:= 'update dr$index set idx_option=''QT'' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 elsif(r.idx_option='Y') then
  sql_q:= 'update dr$index set idx_option='''' where idx_id=' ||r.idx_id;
  execute immediate(sql_q);
 end if;
END LOOP;
END;
/

REM -------------------------------------------------------------------
REM lrg 18241069: revoke privileges granted in 12.1
REM -------------------------------------------------------------------

BEGIN
  EXECUTE IMMEDIATE 'revoke create sequence from ctxapp';
EXCEPTION
 WHEN OTHERS THEN NULL;
END;
/
