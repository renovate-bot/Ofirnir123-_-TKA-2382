Rem
Rem $Header: ctx_src_2/src/dr/admin/supnote_u1202020.sql /main/2 2018/07/25 13:49:08 surman Exp $
Rem
Rem supnote_u1202020.sql
Rem
Rem Copyright (c) 2017, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      supnote_u1202020.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script is meant to run after upgrade from 12.2.0.1 to 12.2.0.2,
Rem      to identify which indexes require a rebuild to be valid.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/supnote_u1202020.sql
Rem    SQL_SHIPPED_FILE: ctx/admin/supnote_u1202020.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    nspancha    04/05/17 - Bug 25661502: Script to check token lengths
Rem    nspancha    04/10/17 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET SERVEROUTPUT ON
ALTER SESSION SET CURRENT_SCHEMA=CTXSYS;

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
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE', 4,'CONTEXT2') idx_type
 ,idx_sync_type          idx_sync_type
 ,idx_sync_memory        idx_sync_memory
 ,idx_sync_para_degree   idx_sync_para_degree
 ,idx_sync_interval      idx_sync_interval
 ,idx_sync_jobname       idx_sync_jobname
 ,decode(instr(idx_option, 'Z'), 0, 'NO', NULL, 'NO', 'YES')
                         idx_query_stats_enabled
 ,idx_auto_opt_type      idx_auto_opt_type
 ,idx_auto_opt_interval  idx_auto_opt_interval
 from dr$index, sys."_BASE_USER" u, sys.obj$ o, sys."_BASE_USER" u2
where idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
;

create or replace view ctx_index_partitions as
select
  ixp_id
 ,u1.name                ixp_index_owner
 ,idx_name               ixp_index_name
 ,ixp_name               ixp_index_partition_name
 ,u2.name                ixp_table_owner
 ,o1.name                ixp_table_name
 ,o2.subname             ixp_table_partition_name
 ,ixp_docid_count        ixp_docid_count
 ,ixp_status             ixp_status
 ,ixp_sync_type          ixp_sync_type
 ,ixp_sync_memory        ixp_sync_memory
 ,ixp_sync_para_degree   ixp_sync_para_degree
 ,ixp_sync_interval      ixp_sync_interval
 ,ixp_sync_jobname       ixp_sync_jobname
 ,ixp_auto_opt_type      ixp_auto_opt_type
 ,ixp_auto_opt_interval  ixp_auto_opt_interval
 from dr$index_partition, dr$index, sys."_BASE_USER" u1, sys."_BASE_USER" u2,
      sys.obj$ o1, sys.obj$ o2
where idx_owner# = u1.user#
  and idx_table_owner# = u2.user#
  and ixp_table_partition# = o2.obj#
  and idx_table# = o1.obj#
  and ixp_idx_id = idx_id
/

--Loop over all indexes and widen token columns (Runs as sys, in CTXSYS schema)
DECLARE
     table_name VARCHAR2(128);
     event_level NUMBER;
     token_length_check NUMBER;
     query_str  VARCHAR2(500);
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

   BEGIN
    -- Checking $I table --
   table_name := drvxtab.get_object_name(r_index_partitions.idx_owner,
                                         r_index_partitions.idx_name,
                                         r_index_partitions.idx_id,
                                         r_index_partitions.ixp_id,
                                         'I');
                                                                           
         
   dbms_output.put_line('Table Name: ' ||  table_name);                         
                                                                
   token_length_check := 0;

   EXECUTE IMMEDIATE 'select count(token_text) from '||table_name
                     ||' where length(token_text) >= 64'
                     ||' or token_text like ''DR$LONGTOK'' and rownum < 2' 
                INTO token_length_check;
  
   if token_length_check > 0 then
  
     dbms_output.put_line('INDEX '||r_index_partitions.idx_owner||'.'||
                          r_index_partitions.idx_name||
                          ' IS IN AN UNUSABLE STATE AS IT CONTAINS LONG '||
                          'TOKENS. PLEASE REBUILD THIS INDEX.');     
    
     --Index has been logged as unusable, skip other tables
     CONTINUE;

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
      
  -- Checking $G table --
  BEGIN    
    table_name := drvxtab.get_object_name(r_index_partitions.idx_owner,
                                          r_index_partitions.idx_name,
                                          r_index_partitions.idx_id,
                                          r_index_partitions.ixp_id,
                                          'G');                       

    dbms_output.put_line('Table Name ' ||  table_name);                        
                                                         
    token_length_check := 0;



    EXECUTE IMMEDIATE 'select count(token_text) from '
                      ||table_name||' where length(token_text) >= 64 '
                      ||'or token_text like ''DR$LONGTOK'' and rownum < 2' 
                 INTO token_length_check;

    if token_length_check > 0 then

      dbms_output.put_line('INDEX '||r_index_partitions.idx_owner||'.'||
                           r_index_partitions.idx_name||
                           ' IS IN AN UNUSABLE STATE AS IT CONTAINS LONG '||
                           'TOKENS. PLEASE REBUILD THIS INDEX.');
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
-----------------------
  END;

 END LOOP;

END;
/
show errors;


@?/rdbms/admin/sqlsessend.sql
 
