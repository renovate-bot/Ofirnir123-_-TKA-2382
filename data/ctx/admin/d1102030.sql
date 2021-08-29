Rem
Rem $Header: ctx_src_2/src/dr/admin/d1102030.sql /main/7 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1102030.sql
Rem
Rem Copyright (c) 2012, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1102030.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 11203 to 11202
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1102030.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/d1102030.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    gpodila     11/06/14 - Bug 14254610 index optimization in rebuild fails
Rem    gpodila     10/22/14 - Bug 13640676 cannot exchange table partition
Rem    yiqi        04/17/12 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ------------------------------------------------------------------
REM  drop column spw_pattern dr$stopword
REM ------------------------------------------------------------------

declare
  errnum number;
begin
  execute immediate('
  alter table dr$stopword drop (spw_pattern)');
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

REM ===================================================================
REM Drop configuration column from dr$index 
REM ===================================================================
alter table dr$index drop column idx_config_column;

REM ==================================================================
REM Reverse Change from filter cache
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90118 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=18
    and OAT_NAME='QUERY_FILTER_CACHE_SIZE';
commit;

delete from dr$object_attribute
  where OAT_ID=90132 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=32
    and OAT_NAME='QUERY_FACET_PIN_PERM';
commit;


drop public synonym ctx_filter_cache_statistics;
drop view ctx_filter_cache_statistics;


REM -------------------------------------------------------------------
REM  13640676
REM -------------------------------------------------------------------

declare 
sql_q varchar2(120);
begin
FOR r in (select a.object_name , a.owner  from all_objects a , all_tab_columns  c where 
a.object_name like '%$I' and a.object_name = c.table_name and  c.column_name='TOKEN_TEXT')
LOOP
  sql_q:= 'create table dr$bug_13640676$ as SELECT * FROM '||r.owner||'.'||r.object_name;
  execute immediate(sql_q);
  sql_q:= 'truncate table '||r.owner||'.'||r.object_name ;
  execute immediate(sql_q);
  sql_q:= 'alter table '||r.owner||'.'||r.object_name||' modify (TOKEN_TYPE number(3))';
  execute immediate(sql_q);
  sql_q:= 'INSERT INTO '||r.owner||'.'||r.object_name||' SELECT * FROM dr$bug_13640676$';
  execute immediate(sql_q);
  execute immediate('drop table dr$bug_13640676$');
END LOOP;
exception
  when others then
     execute immediate('drop table dr$bug_13640676$');
     raise;
end;
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
  sql_q:= 'update dr$index set idx_option='''' where idx_id='||r.idx_id;
  execute immediate(sql_q);
 end if;
END LOOP;
END;
/

