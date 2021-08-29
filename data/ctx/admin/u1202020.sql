Rem
Rem Copyright (c) 2016, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1202020.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1202020.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/u1202020.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: UPGRADE
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aczarlin    08/16/17 - bug 26633319 default stage_itab_max_rows
Rem    demukhin    06/30/17 - bug 26051570: keep $R for legacy indexes
Rem    raeburns    06/12/17 - RTI 20258949: signature mismatches
Rem    nspancha    03/22/17 - Bug 25723660 : Identifier too long
Rem    snetrava    03/14/17 - Remove FILE_ACCESS_ROLE
Rem    boxia       03/13/17 - Bug 25468759: add idx_auto_opt_para_degree,
Rem                           ixp_auto_opt_para_degree
Rem    demukhin    02/20/17 - prj 68638: remove $R
Rem    nspancha    02/06/17 - Fixing upgrade for 64 byte issue
Rem    rodfuent    02/06/17 - Bug 25422217: $DI, $NI, $KI, $UI storage clauses
Rem    nspancha    01/31/17 - Widening stopword token column during upgrade
Rem    boxia       01/12/17 - Bug 25390928: alter dr$index_partition,
Rem                           ctx_index_partitions, ctx_user_index_partitions
Rem    nspancha    01/06/17 - Bug 22068230: Temp removing 255 upgrade code
Rem    snetrava    01/05/17 - Storage clauses for Wildcard index
Rem    nspancha    12/16/16 - Bug 22068230: Widening token columns to 255 bytes
Rem    boxia       11/19/16 - Bug 25172618: add stage_itab_auto_opt
Rem                           alter dr$index, ctx_indexes, ctx_user_indexes
Rem    snetrava    11/02/16 - Bug 25035481 WILDCARD_INDEX, WILDCARD_INDEX_K
Rem    snetrava    10/27/16 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

BEGIN
insert into dr$object_attribute values
  (70116, 7, 1, 16,
   'WILDCARD_INDEX', 'K-Gram Index for wildcard queries',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');

insert into dr$object_attribute values
  (70117, 7, 1, 17,
   'WILDCARD_INDEX_K', 'Number of characters to use for gramming',
   'N', 'N', 'Y', 'I',
   '3', 2, 5, 'N');

insert into dr$object_attribute values
  (90156, 9, 1, 56,
   'KG_TABLE_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90158, 9, 1, 58,
   'KG_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S',
   'NONE', null, 500, 'N');

-- Add STAGE_ITAB_AUTO_OPT
insert into dr$object_attribute values
  (90157, 9, 1, 57,
   'STAGE_ITAB_AUTO_OPT', '',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

insert into dr$object_attribute values
  (90159, 9, 1, 59, 
   'D_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90160, 9, 1, 60, 
   'N_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90161, 9, 1, 61, 
   'K_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90162, 9, 1, 62, 
   'U_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90163, 9, 1, 63, 
   'KD_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

insert into dr$object_attribute values
  (90164, 9, 1, 64, 
   'KR_INDEX_CLAUSE', '',
   'N', 'N', 'Y', 'S', 
   'NONE', null, 500, 'N');

-- default stage_itab_max_rows changed from 1M to 100K
update dr$object_attribute
  set oat_default = 100000
  where oat_id = 90128 and oat_cla_id = 9 and oat_obj_id = 1 and
        oat_att_id = 28 and oat_name = 'STAGE_ITAB_MAX_ROWS';

commit;
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

REM ==================================================================
REM  alter dr$index, ctx_indexes, ctx_user_indexes
REM  add column idx_auto_opt_type, idx_auto_opt_interval
REM ==================================================================

DECLARE
  errnum number;
BEGIN
  execute immediate(
    'alter table dr$index add (' ||
    'idx_auto_opt_type VARCHAR2(20) DEFAULT NULL, ' ||
    'idx_auto_opt_interval VARCHAR2(2000) DEFAULT NULL, ' ||
    'idx_auto_opt_para_degree NUMBER DEFAULT NULL)');
EXCEPTION
  when others then
    errnum := SQLCODE;
    if (errnum = -01430) then
      null;
    else
      raise;
    end if;
END;
/

create or replace view ctx_indexes as
select
  idx_id
 ,u.name                   idx_owner
 ,idx_name                 idx_name
 ,u2.name                  idx_table_owner
 ,o.name                   idx_table
 ,idx_key_name             idx_key_name
 ,idx_text_name            idx_text_name
 ,idx_docid_count          idx_docid_count
 ,idx_status               idx_status
 ,idx_language_column      idx_language_column
 ,idx_format_column        idx_format_column
 ,idx_charset_column       idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE', 4, 'CONTEXT2')
                           idx_type
 ,idx_sync_type            idx_sync_type
 ,idx_sync_memory          idx_sync_memory
 ,idx_sync_para_degree     idx_sync_para_degree
 ,idx_sync_interval        idx_sync_interval
 ,idx_sync_jobname         idx_sync_jobname
 ,decode(instr(idx_option, 'Z'), 0, 'NO', NULL, 'NO', 'YES')
                           idx_query_stats_enabled
 ,idx_auto_opt_type        idx_auto_opt_type
 ,idx_auto_opt_interval    idx_auto_opt_interval
 ,idx_auto_opt_para_degree idx_auto_opt_para_degree
 from dr$index, sys."_BASE_USER" u, sys.obj$ o, sys."_BASE_USER" u2
where idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
/

create or replace view ctx_user_indexes as
select
  idx_id
 ,idx_name                 idx_name
 ,u.name                   idx_table_owner
 ,o.name                   idx_table
 ,idx_key_name             idx_key_name
 ,idx_text_name            idx_text_name
 ,idx_docid_count          idx_docid_count
 ,idx_status               idx_status
 ,idx_language_column      idx_language_column
 ,idx_format_column        idx_format_column
 ,idx_charset_column       idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE', 4, 'CONTEXT2')
                           idx_type
 ,idx_sync_type            idx_sync_type
 ,idx_sync_memory          idx_sync_memory
 ,idx_sync_para_degree     idx_sync_para_degree
 ,idx_sync_interval        idx_sync_interval
 ,idx_sync_jobname         idx_sync_jobname
 ,idx_auto_opt_type        idx_auto_opt_type
 ,idx_auto_opt_interval    idx_auto_opt_interval
 ,idx_auto_opt_para_degree idx_auto_opt_para_degree
 ,decode(instr(idx_option, 'Z'), 0, 'NO', NULL, 'NO', 'YES')
                           idx_query_stats_enabled
 from dr$index, sys."_BASE_USER" u, sys.obj$ o
where idx_owner# = userenv('SCHEMAID')
  and idx_table_owner# = u.user#
  and idx_table# = o.obj#
/

REM ==========================================================================
REM  alter dr$index_partition, ctx_index_partitions, ctx_user_index_partitions
REM  add column ixp_auto_opt_type, ixp_auto_opt_interval
REM ==========================================================================
DECLARE
  errnum number;
BEGIN
  execute immediate(
    'alter table dr$index_partition add (' ||
    'ixp_auto_opt_type VARCHAR2(20) DEFAULT NULL, ' ||
    'ixp_auto_opt_interval VARCHAR2(2000) DEFAULT NULL, ' ||
    'ixp_auto_opt_para_degree NUMBER DEFAULT NULL)');
EXCEPTION
  when others then
    errnum := SQLCODE;
    if (errnum = -01430) then
      null;
    else
      raise;
    end if;
END;
/

create or replace view ctx_index_partitions as
select
  ixp_id
 ,u1.name                  ixp_index_owner
 ,idx_name                 ixp_index_name
 ,ixp_name                 ixp_index_partition_name
 ,u2.name                  ixp_table_owner
 ,o1.name                  ixp_table_name
 ,o2.subname               ixp_table_partition_name 
 ,ixp_docid_count          ixp_docid_count
 ,ixp_status               ixp_status
 ,ixp_sync_type            ixp_sync_type
 ,ixp_sync_memory          ixp_sync_memory
 ,ixp_sync_para_degree     ixp_sync_para_degree
 ,ixp_sync_interval        ixp_sync_interval
 ,ixp_sync_jobname         ixp_sync_jobname
 ,ixp_auto_opt_type        ixp_auto_opt_type
 ,ixp_auto_opt_interval    ixp_auto_opt_interval 
 ,ixp_auto_opt_para_degree ixp_auto_opt_para_degree
 from dr$index_partition, dr$index, sys."_BASE_USER" u1, sys."_BASE_USER" u2, 
      sys.obj$ o1, sys.obj$ o2
where idx_owner# = u1.user#
  and idx_table_owner# = u2.user#
  and ixp_table_partition# = o2.obj#
  and idx_table# = o1.obj#
  and ixp_idx_id = idx_id
/

create or replace view ctx_user_index_partitions as
select
  ixp_id
 ,idx_name                 ixp_index_name
 ,ixp_name                 ixp_index_partition_name
 ,u2.name                  ixp_table_owner
 ,o1.name                  ixp_table_name
 ,o2.subname               ixp_table_partition_name 
 ,ixp_docid_count          ixp_docid_count
 ,ixp_status               ixp_status
 ,ixp_sync_type            ixp_sync_type
 ,ixp_sync_memory          ixp_sync_memory
 ,ixp_sync_para_degree     ixp_sync_para_degree
 ,ixp_sync_interval        ixp_sync_interval
 ,ixp_sync_jobname         ixp_sync_jobname 
 ,ixp_auto_opt_type        ixp_auto_opt_type
 ,ixp_auto_opt_interval    ixp_auto_opt_interval
 ,ixp_auto_opt_para_degree ixp_auto_opt_para_degree
 from dr$index_partition, dr$index, sys."_BASE_USER" u2, 
      sys.obj$ o1, sys.obj$ o2
where idx_owner# = userenv('SCHEMAID')
  and idx_table_owner# = u2.user#
  and ixp_table_partition# = o2.obj#
  and idx_table# = o1.obj#
  and ixp_idx_id = idx_id
/

--Loop over all indexes and widen token columns (Runs as sys, in CTXSYS schema)
DECLARE
     table_name VARCHAR2(128);
     event_level NUMBER;
BEGIN

 FOR r_index_partitions IN
       (SELECT i.idx_owner,
               i.idx_id,
               i.idx_name,
               i.idx_type,
               ixp.ixp_id,
               ixp.ixp_index_partition_name
        FROM CTX_INDEXES i LEFT OUTER JOIN
             CTX_INDEX_PARTITIONS ixp
             ON ixp.ixp_index_name = i.idx_name
        WHERE i.idx_status LIKE 'INDEXED'
          AND (i.idx_type LIKE 'CONTEXT'
          OR i.idx_type LIKE 'CONTEXT2')
        ORDER BY i.idx_id, ixp.ixp_id) LOOP
  BEGIN
 --dbms_output.put_line('Index ' ||  r_index_partitions.idx_owner || '.'
 --|| r_index_partitions.idx_name || ': ' ||r_index_partitions.ixp_id);
   BEGIN
    -- Widening $I table --
   table_name := dr$temp_get_object_name(r_index_partitions.idx_owner,
                                         r_index_partitions.idx_name,
                                         r_index_partitions.idx_id,
                                         r_index_partitions.ixp_id,
                                         'I');
                                                                           
         
  dbms_output.put_line('Table Name ' ||  table_name);                         
                                                                

  execute immediate('alter table ' || table_name ||
  	                ' modify TOKEN_TEXT VARCHAR2(255)');
  EXCEPTION
   when others then
    if (SQLCODE = -00942) then --Table Does Not Exist!
     dbms_output.put_line('Table ' ||  table_name || 
     	                  ' not be found. Skipping.');
     null;
    else
     raise;
    end if;
  END;
      
   -- Widening $P table --
   BEGIN    
        table_name := dr$temp_get_object_name(r_index_partitions.idx_owner,
                                              r_index_partitions.idx_name,
                                              r_index_partitions.idx_id,
                                              r_index_partitions.ixp_id,
                                              'P');
                                                                              
         
    dbms_output.put_line('Table Name ' || table_name);

   
    sys.dbms_system.read_ev(30579,event_level);       
                        
    if(bitand(event_level, 2097152) = 0) 
       then        
        execute immediate(
         'alter table ' || table_name ||
         ' modify (pat_part1 VARCHAR2(252), pat_part2 VARCHAR2(255))');
    else 
        execute immediate(
         'alter table ' || table_name ||
         ' modify (pat_part1 VARCHAR2(255), pat_part2 VARCHAR2(255))');
    end if;

  EXCEPTION
   when others then
    if (SQLCODE = -00942) then --Table Does Not Exist!
     dbms_output.put_line('Table ' ||  table_name || 
     	                  ' not be found. Skipping.');
     null;
    else
     raise;
    end if;         
  END;
      
      -- Widening $G table --
  BEGIN    
    table_name := dr$temp_get_object_name(r_index_partitions.idx_owner,
                                          r_index_partitions.idx_name,
                                          r_index_partitions.idx_id,
                                          r_index_partitions.ixp_id,
                                          'G');                       

   dbms_output.put_line('Table Name ' ||  table_name);                        
                                                                 
   
   execute immediate('alter table ' || table_name ||
                     ' modify TOKEN_TEXT VARCHAR2(255)');
        
  EXCEPTION
    when others then
     if (SQLCODE = -00942) then --Table Does Not Exist!
      dbms_output.put_line('Table ' ||  table_name || 
     	                  ' not be found. Skipping.');
      null;
     else
      raise;
     end if;         
  END;
      
-----------------------
   END;

 END LOOP;

END;
/
show errors;

-- Widen columns that hold tokens to 255 bytes

REM ========================================================================
REM Remove FILE_ACCESS_ROLE
REM ========================================================================

declare
is_public number;
mesg varchar2(500);
mesg_opt varchar2(500);
begin

mesg := 'FILE_ACCESS_ROLE is now ' ||
        'TEXT DATASTORE ACCESS system privilege. '||
        'This privilege needs to be explicitly and directly granted '||
        'to users who wish to create text indexes using '||
        'FILE/URL Datastore.';
         
mesg_opt := 'Granting FILE_ACCESS_ROLE to Public is not a good practice.' ||
            ' This may allow public to read arbitrary files from the OS.'; 

select count(*) into is_public from ctxsys.dr$parameter 
where par_name = 'FILE_ACCESS_ROLE'
and par_value = 'PUBLIC';

if (is_public != 0) then
  dbms_output.put_line(mesg_opt);
end if;
dbms_output.put_line(mesg);
end;
/
delete from ctxsys.dr$parameter where par_name = 'FILE_ACCESS_ROLE';

ALTER TABLE dr$index MODIFY idx_opt_token varchar2(255);
ALTER TABLE dr$index_partition MODIFY ixp_opt_token varchar2(255);
ALTER TABLE dr$freqtoks MODIFY fqt_token varchar2(255);
ALTER TABLE dr$stopword MODIFY spw_word varchar2(255);

-- diagnostic information
column idx_name for a30
column idx_option for a10
select idx_id, idx_owner#, idx_name, idx_option, idx_type
  from dr$index;

-- diagnostic information
column ixp_name for a30
column ixp_option for a10
select ixp_idx_id, ixp_name, ixp_option
  from dr$index_partition;

-- add truncated (30 byte) names index option
--
--   We set 't' option for all indexes when compatible < 12.2 making them self
--   contained for the purpose of naming index objects. For most indexes the
--   behavior will be the same with or wihtout 't' option. However, it is
--   essential when index object names use all 30 bytes. In this case when
--   adding $KD and $KR indexes the name will need 31 bytes and thus will
--   fail. Since $KD and $KR always use full length semantics, by setting 't'
--   option we will be able to generate names that will fit into 30 bytes.
--
declare
  force_t  boolean := false; 
begin
  -- check if we can use more than 30 byte names
  --   since all of the CTX upgrade scripts run before obj$ is altered to
  --   128 bytes during 12.2 upgrade we cannot use 128 byte names just yet.
  --   Unfortunately we cannot rely on the value compatible either since it
  --   could be set to 12.2 during upgrade to 12.2.
  begin
    -- 31 byte name
    execute immediate
      'create table foo4567890_234567890_2345678901 ('||
        'col number)';
    execute immediate
      'drop table foo4567890_234567890_2345678901 purge';
  exception
    when others then
      if sqlcode in (-12899, -972) then
        force_t := true;
      else
        raise;
      end if;
  end;

  -- add 't' option
  if force_t then
    update dr$index set idx_option = idx_option||'t'
    where  instr(nvl(idx_option, ' '), 't') = 0;
    commit;
    
    update dr$index_partition set ixp_option = ixp_option||'t'
    where  instr(nvl(ixp_option, ' '), 't') = 0;
    commit;
  end if;
end;
/

-- diagnostic information
column idx_name for a30
column idx_option for a10
select idx_id, idx_owner#, idx_name, idx_option, idx_type
  from dr$index;

-- diagnostic information
column ixp_name for a30
column ixp_option for a10
select ixp_idx_id, ixp_name, ixp_option
  from dr$index_partition;

-- remove reverse docid index option
-- the 'R' index option is reused for 'no $R' index option
update dr$index set idx_option = replace(idx_option, 'R')
where  instr(idx_option, 'R') > 0;
commit;
update dr$index_partition set ixp_option = replace(ixp_option, 'R')
where  instr(ixp_option, 'R') > 0;
commit;

@?/rdbms/admin/sqlsessend.sql
 
