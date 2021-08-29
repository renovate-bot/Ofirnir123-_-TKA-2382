Rem
Rem $Header: ctx/sample/script/drkorean.sql /main/4 2016/03/10 12:53:01 rkadwe Exp $
Rem
Rem drkorean.sql
Rem
Rem Copyright (c) 2005, 2016, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drkorean.sql - korean_lexer migration 
Rem
Rem    DESCRIPTION
Rem      This script will 
Rem        1. Migrate all KOREAN_LEXER preferences to KOREAN_MORPH_LEXER 
Rem           preferences, including those sub lexers. The preference 
Rem           names stay the same as before migration. All the attributes
Rem           associated with KOREAN_LEXER are dropped. KOREAN_MORPH_LEXER
Rem           preferences use default attributes.
Rem
Rem        2. Migrate all indexes using KOREAN_LEXER to KOREAN_MORPH_LEXER 
Rem           with default attributes. The script will  update data dictionary
Rem           first, the rebuild the indexes that use KOREAN_LEXER as
Rem           top level lexer. For indexes that use KOREAN_LEXER as a
Rem           non-default sub_lexer in multi_lexer, only documents 
Rem           that use korean_lexer will be reindexed through sync. 
Rem    USAGE NOTES: 
Rem        1.Must run as sys or system.
Rem        2.Cannot migrate CTXRULE indexes. If the system has CTXRULE
Rem          indexes that use KOREAN_LEXER, we recommend customers
Rem          drop those indexes first, then run this script. 
Rem        3.Both "alter index" and "sync_index" use default memory
Rem          and run in serial. Users can change this script to
Rem          customize.
Rem        4.This script uses some CTX internal function/procedure calls and 
Rem          should generally run in the same version of CTX that it comes
Rem          with. The only supported exceptions are that the script that comes
Rem          with CTX version 10.2.0.3 can run on CTX version 10.2.0.1 and 10.2.0.2.
Rem       
Rem
Rem    NOTES
Rem      This script should be run as sys 
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    rkadwe      08/04/10 - Bug 9964279
Rem    wclin       04/26/06 - ODCIIndexInfo type change 
Rem    yucheng     11/23/05 - Print warnings when see ctxrule 
Rem    yucheng     11/16/05 - creation
Rem    yucheng     11/16/05 - creation
Rem    yucheng     11/16/05 - Created
Rem


set serveroutput on size 20000
set linesize 120
set feedback off;

alter session set current_schema = SYS;

CREATE OR REPLACE PROCEDURE exec_sql(stm   IN VARCHAR2,
                                     owner IN VARCHAR2)
IS 
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  synced  NUMBER := 1;
BEGIN
  cur := dbms_sql.open_cursor;

  select user_id into uid from all_users where username = owner;
  sys.dbms_sys_sql.parse_as_user(cur, stm, dbms_sql.v7, uid);

  rc := dbms_sql.execute(cur);
  dbms_sql.close_cursor(cur);

END;
/
show err

REM =====================================================================
PROMPT test_sync_index
REM =====================================================================
CREATE OR REPLACE PROCEDURE test_sync_index(idxname  IN VARCHAR2, 
                                            partname IN VARCHAR2)
IS
  cur     NUMBER;
  rc      NUMBER;
  uid     NUMBER;
  synced  NUMBER := 1;
  stm     VARCHAR2(800);
BEGIN
  cur := dbms_sql.open_cursor;
  select user_id into uid from all_users where username = 'CTXSYS';

  if (partname is null) then
    stm := 'BEGIN ctx_ddl.sync_index(idx_name => :idxname);';
  else
    stm := 'BEGIN ctx_ddl.sync_index(idx_name => :idxname,
                                     part_name => :partname);';
  end if;
  stm := stm || ' EXCEPTION WHEN OTHERS THEN
                    :synced := 0;
                  END;';

  sys.dbms_sys_sql.parse_as_user(cur, stm, dbms_sql.v7, uid);
 
  dbms_sql.bind_variable(cur, ':idxname', idxname);

  if (partname is not null) then
    dbms_sql.bind_variable(cur, ':partname', partname);
  end if;

  dbms_sql.bind_variable(cur, ':synced', synced);

  rc := dbms_sql.execute(cur);

  dbms_sql.variable_value(cur, ':synced', synced);
  dbms_sql.close_cursor(cur);
  IF (synced = 0) THEN
    raise_application_error(-20000, 'Oracle Text Error: '
                                    || UPPER(idxname) ||' not synced');
  END IF;
END;
/
show err

alter session set current_schema = CTXSYS;
declare 

  type idx_rec is record(
    idx_owner        varchar2(30),
    idx_name         varchar2(30),
    idx_id           number(38),
    idx_option       varchar2(40));

  type idx_rec_sub is record(
    idx_owner        varchar2(30),
    idx_name         varchar2(30),
    idx_id           number(38),
    idx_table_owner  varchar2(30),
    idx_table        varchar2(30),
    idx_lang_col     varchar2(256),
    idx_text_name    varchar2(256),
    idx_option       varchar2(40));

  type ixv_rec is record(
    abb2  varchar2(4),
    lang  varchar2(30),
    lalt  varchar2(30));
 
  type idx_tab is table of idx_rec index by binary_integer;
  type idx_tab_sub is table of idx_rec_sub index by binary_integer;
  type ixv_tab is table of ixv_rec index by binary_integer;

  cursor get_idx is
   select u.name idx_owner, idx_name, idx_id, idx_option, idx_type
      from dr$index_object, dr$index, sys."_BASE_USER" u
     where idx_owner# = u.user#  and
           idx_id = ixo_idx_id and
           ixo_cla_id = 6 and ixo_obj_id = 3
      order by idx_owner, idx_name;

  cursor get_ipart(idxid binary_integer) is
    select ixp_name from dr$index_partition
      where ixp_idx_id =idxid;

  cursor get_idx_sub is
   select unique u1.name idx_owner, idx_name, idx_id, 
                 u2.name idx_table_owner, o.name idx_table,
                 idx_language_column, idx_text_name, idx_option 
      from dr$index, sys."_BASE_USER" u1, dr$index_value, sys."_BASE_USER" u2,sys.obj$ o
     where u1.user# = idx_owner# and
           idx_id = ixv_idx_id and
           u2.user# = idx_table_owner# and
           o.obj# = idx_table# and
            substr(substr(ixv_value,instr(ixv_value,':')+1,
                     instr(ixv_value, ':', -1) - instr(ixv_value,':') - 1),
              1,30) = 'KOREAN_LEXER' and
            ixv_oat_id = 60601
      order by idx_owner, idx_name;

   cursor get_ixv(idxid binary_integer) is
    select ixv_value from dr$index_value 
      where ixv_idx_id = idxid and
            ixv_oat_id = 60601;

  ia       sys.ODCIIndexInfo;
  cnt      binary_integer := 0;
  cnt_sub  binary_integer := 0;
  itab     idx_tab;
  itab_sub idx_tab_sub;
  k_val    ixv_tab;
  o_val    ixv_tab;
  stm      varchar2(32000);
  colpos1 number;
  colpos2 number;
  labbr   varchar2(4);
  abb2    varchar2(4);
  lang    varchar2(30);
  slobj   varchar2(30);
  lalt    varchar2(30);
  k_cnt   binary_integer := 0;
  o_cnt   binary_integer := 0;
  k_df    boolean := FALSE;
  stm_alter varchar2(32000);

begin

  -- get all the indexes that has KOREAN_Lexer
  dbms_output.put_line(
      'List of indexes that use KOREAN_LEXER as top level lexer:'); 
  
  for irec in get_idx loop
    dbms_output.put_line(dbms_assert.enquote_name(irec.idx_owner)||'.'||
                         dbms_assert.enquote_name(irec.idx_name));
    if (irec.idx_type = 2) then 
      dbms_output.put(dbms_assert.enquote_name(irec.idx_owner)||'.'||
                      dbms_assert.enquote_name(irec.idx_name));
      dbms_output.put_line(
          ' is CTXRULE index, it cannot be migrated properly.');
    else
      cnt := cnt+1;
      itab(cnt).idx_owner := irec.idx_owner;
      itab(cnt).idx_name  := irec.idx_name;
      itab(cnt).idx_id    := irec.idx_id;
      itab(cnt).idx_option := irec.idx_option;
    end if;
  end loop;

  -- get all the indexes that has korean_lexer as sub_lexer
  dbms_output.put_line(
       'List of indexes that use KOREAN_LEXER as a sub lexer:'); 
  for irec_sub in get_idx_sub loop
    cnt_sub := cnt_sub +1;
    itab_sub(cnt_sub).idx_owner := irec_sub.idx_owner;
    itab_sub(cnt_sub).idx_name  := irec_sub.idx_name;
    itab_sub(cnt_sub).idx_id    := irec_sub.idx_id;
    itab_sub(cnt_sub).idx_table_owner := irec_sub.idx_table_owner;
    itab_sub(cnt_sub).idx_table       := irec_sub.idx_table;
    itab_sub(cnt_sub).idx_lang_col    := irec_sub.idx_language_column;
    itab_sub(cnt_sub).idx_text_name   := irec_sub.idx_text_name;
    itab_sub(cnt_sub).idx_option      := irec_sub.idx_option;
    dbms_output.put_line(dbms_assert.enquote_name(itab_sub(cnt_sub).idx_owner)
                         ||'.'||
                         dbms_assert.enquote_name(itab_sub(cnt_sub).idx_name));
  end loop;

  -- update all KOREAN_LEXER to KOREAN_MORPH_LEXER

  dbms_output.put_line('Migrate KOREAN_LEXER to KOREAN_MORPH_LEXER');
  DELETE FROM dr$preference_value
    WHERE prv_pre_id IN
      (SELECT pre_id
         FROM dr$preference
         WHERE pre_cla_id = 6
           AND pre_obj_id = 3);

  UPDATE dr$preference
    SET pre_obj_id = 7
    WHERE pre_cla_id = 6
      AND pre_obj_id = 3;

  UPDATE dr$index_object
    SET ixo_acnt = 0, ixo_obj_id = 7
    WHERE ixo_cla_id = 6
      AND ixo_obj_id = 3;

  DELETE FROM dr$index_value
    WHERE EXISTS
     (SELECT oat_id FROM dr$object_attribute
      WHERE oat_id = ixv_oat_id AND oat_cla_id = 6
            and oat_obj_id =3);

  DELETE FROM dr$index_value
    WHERE ixv_oat_id = 60602 and EXISTS
     (SELECT oat_id FROM dr$object_attribute
      WHERE oat_id = ixv_sub_oat_id AND oat_cla_id = 6
            AND oat_obj_id =3);

  UPDATE dr$index_value 
    SET ixv_value = replace(ixv_value,'KOREAN_LEXER','KOREAN_MORPH_LEXER')
    WHERE ixv_oat_id = 60601;

  UPDATE dr$index_object
    SET ixo_acnt = (select count(*) from
                    dr$index_value where
                   ixv_oat_id in (60601, 60602) and 
                   ixv_idx_id = ixo_idx_id)
    WHERE ixo_cla_id = 6
      AND ixo_obj_id = 6;

  commit;

  -- purge because we change the preferences
  for i in 1..cnt loop
    ia := sys.ODCIIndexInfo(itab(i).idx_owner, itab(i).idx_name,
                            null,null,null, null, 0, 0);
    -- this is dummy, just to start a transaction
    update dr$index  set idx_id = idx_id where idx_id = itab(i).idx_id;
    drixmd.PurgeKGL(itab(i).idx_id, ia);
    -- commit to release the kgl lock and pin
    commit;
  end loop;

  -- rebuild all indexes that use korean_lexer
  dbms_output.put_line
     ('Rebuild all indexes that use korean lexer as top level lexer:'); 
  for i in 1..cnt loop
    
    dbms_output.put('rebuilding : ');
    dbms_output.put(dbms_assert.enquote_name(itab(i).idx_owner)||'.'||
                    dbms_assert.enquote_name(itab(i).idx_name));

    if (itab(i).idx_option like '%P%') then
      -- local partitioned index
      for prec in get_ipart(itab(i).idx_id) loop
        stm_alter :=
          'alter index '||dbms_assert.enquote_name(itab(i).idx_owner, FALSE)
          ||'.'||dbms_assert.enquote_name(itab(i).idx_name, FALSE)||
          ' rebuild partition '||
          dbms_assert.enquote_name(prec.ixp_name, FALSE); 

-- CUSTOMIZATION:  You can edit the memory size and parallel degree
-- in the following two lines, then uncomment them.
--   stm_alter := stm_alter||
--      'parameters(''replace memory 50m'') parallel 2';

        
      sys.exec_sql(stm_alter, itab(i).idx_owner);
      end loop;
    -- non-partitioned index
    else 
      stm_alter :=
        'alter index '||dbms_assert.enquote_name(itab(i).idx_owner, FALSE)
        ||'.'||dbms_assert.enquote_name(itab(i).idx_name, FALSE)||' rebuild';

-- CUSTOMIZATION:  You can edit the memory size and parallel degree
-- in the following two lines, then uncomment them.
--   stm_alter := stm_alter||
--      'parameters(''replace memory 50m'') parallel 2';

    sys.exec_sql(stm_alter, itab(i).idx_owner);
    end if;


    dbms_output.put_line(' finished.');
  end loop;

  -- purge because we change the preferences
  for i in 1..cnt_sub loop
    -- this is dummy, just to start a transaction
    update dr$index  set idx_id = idx_id where idx_id = itab_sub(i).idx_id;
    ia := sys.ODCIIndexInfo(itab_sub(i).idx_owner,
                            itab_sub(i).idx_name,
                            null,null,null, null, 0, 0);
    drixmd.PurgeKGL(itab_sub(i).idx_id, ia);
    -- commit to release the kgl lock and pin
    commit;
  end loop;

  -- update korean documents for indexes using korean_lexer as
  -- sub_lexer and sync
  dbms_output.put_line
     ('Reindex all documents that use KOREAN_LEXER as sub lexer');
  for i in 1..cnt_sub loop
    dbms_output.put(' reindexing : ');
    dbms_output.put(
      dbms_assert.enquote_name(itab_sub(i).idx_table_owner)||'.'||
      dbms_assert.enquote_name(itab_sub(i).idx_table));

    stm := 'update '||
           dbms_assert.enquote_name(itab_sub(i).idx_table_owner, FALSE)
           ||'.'||dbms_assert.enquote_name(itab_sub(i).idx_table, FALSE)||
           ' set '||dbms_assert.enquote_name(itab_sub(i).idx_text_name, FALSE)
           ||' = '||dbms_assert.enquote_name(itab_sub(i).idx_text_name, FALSE)
           ||' where upper('
           ||dbms_assert.enquote_name(itab_sub(i).idx_lang_col, FALSE)||') ';
    
    k_df := FALSE;
    k_cnt := 0;
    o_cnt := 0;
    for ixvrec in get_ixv(itab_sub(i).idx_id) loop
      colpos1 := instr(ixvrec.ixv_value, ':');
      colpos2 := instr(ixvrec.ixv_value, ':', colpos1 + 1);
      labbr   := substr(ixvrec.ixv_value, 1, colpos1 - 1);
      slobj   := substr(ixvrec.ixv_value, colpos1 + 1, colpos2 - colpos1 - 1); 
      lalt    := substr(ixvrec.ixv_value, colpos2 + 1);
      if (driutl.check_language(labbr, lang, abb2, TRUE)) then
        null;
      end if;

      if (slobj = 'KOREAN_MORPH_LEXER') then 
        k_cnt := k_cnt +1; 
        k_val(k_cnt).lang := lang;
        k_val(k_cnt).abb2 := abb2;
        k_val(k_cnt).lalt := lalt;  
        if (lang='DEFAULT') then
          k_df := TRUE;
        end if;
      else
        o_cnt := o_cnt +1;
        o_val(o_cnt).lang := lang;
        o_val(o_cnt).abb2 := abb2;
        o_val(o_cnt).lalt := lalt;  
      end if; 

    end loop; 

    if (k_df = TRUE) then 
      -- korean lexer is the default sub lexer 
      stm := stm||'not in (''';
      for j in 1..o_cnt loop 
        if (j>1) then
          stm := stm||',''';
        end if;

        if (o_val(j).lalt is not null) then
          stm := stm||o_val(j).lang||''','''||o_val(j).abb2||''','''||
                 o_val(j).lalt||'''';
        else
          stm := stm||o_val(j).lang||''','''||o_val(j).abb2||'''';
        end if;
      end loop;
      stm := stm||') or '||
             dbms_assert.enquote_name(itab_sub(i).idx_lang_col, FALSE)||
             ' is null'; 
    else  -- non default
      -- korean lexer may be on more than one languages (unlikely)
      stm := stm||' in (''';
      for j in 1..k_cnt loop
        if (j>1) then
          stm := stm||',''';
        end if;

        if (k_val(j).lalt is not null) then       
          stm := stm||k_val(j).lang||''','''||k_val(j).abb2||''','''||
                      k_val(j).lalt||''''; 
        else
          stm := stm||k_val(j).lang||''','''||k_val(j).abb2||''''; 
        end if;
      end loop;

      stm := stm||')';
    end if;

    sys.exec_sql(stm, itab_sub(i).idx_table_owner);
    commit;

    if (itab_sub(i).idx_option like '%P%') then
      for prec in get_ipart(itab_sub(i).idx_id) loop
        sys.test_sync_index(
            dbms_assert.enquote_name(itab_sub(i).idx_owner, FALSE)||'.'||
            dbms_assert.enquote_name(itab_sub(i).idx_name, FALSE),
            dbms_assert.enquote_name(prec.ixp_name, FALSE));
      end loop;
    else
      sys.test_sync_index(
       dbms_assert.enquote_name(itab_sub(i).idx_owner, FALSE)||'.'||
       dbms_assert.enquote_name(itab_sub(i).idx_name, FALSE), NULL);

    end if;
    dbms_output.put_line(' finished.');
  end loop;

end;
/

alter session set current_schema = SYS;
drop procedure exec_sql;
drop procedure test_sync_index;
alter session set current_schema = CTXSYS;
