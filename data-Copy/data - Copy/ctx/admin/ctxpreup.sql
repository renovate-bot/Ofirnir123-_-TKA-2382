Rem
Rem ctxpreup.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxpreup.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script contains common pre-upgrade steps.  Developers
Rem      should keep this up-to-date so that it is compatible with
Rem      the latest versions of everything.  But, because it runs 
Rem      before any data dictionary changes, be careful that it is 
Rem      also compatible with the lowest supported starting version!
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxpreup.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxpreup.sql
Rem      SQL_PHASE: UTILITY
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxpatch.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    rodfuent    08/09/18 - LRG 21480965: mismatch between upgrade/install
Rem    surman      05/04/18 - 27464252: Set phase to UTILITY
Rem    nspancha    01/14/16 - Adding copies of function for use in upgrade
Rem    rkadwe      10/06/16 - Change default stoplist for JSON
Rem    rkadwe      08/29/16 - XbranchMerge rkadwe_bug-24427155 from
Rem                           st_ctx_12.2.0.1.0
Rem    nspancha    08/08/16 - Changing lexer options for JSON and SODA support
Rem    nspancha    06/15/16 - Reverting range search to include TS, not BD
Rem    nspancha    04/07/16 - 22267587:Fixing range search and timestamp opts
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    thbaby      06/25/14 - 19064729: remove sharing=object from dr$ tables
Rem    rkadwe      01/29/14 - Add dr$temp_setsecgrpatt
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    rpalakod    01/10/08 - add temp version of ddl.set_attribute
Rem    wclin       03/02/07 - lrg 2885465: cleanup dummy impl type and ops
Rem                           first
Rem    gkaminag    10/28/05 - 
Rem    ehuang      08/02/02 - ehuang_component_upgrade_2
Rem    ehuang      07/30/02 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

--------------------------------------------------------------------------
-- 19064729: remove sharing=object flag bit on DR$ tables
--------------------------------------------------------------------------
update sys.obj$ o
set o.flags=o.flags-131072
where bitand(o.flags, 131072)=131072 
and o.name in ('DR$CLASS', 'DR$OBJECT', 'DR$OBJECT_ATTRIBUTE', 
               'DR$OBJECT_ATTRIBUTE_LOV')
and o.owner# in (select user# from sys."_BASE_USER" where name='CTXSYS')
/
commit;

REM ========================================================================
REM temporary versions of ctx_ddl routines
REM ========================================================================
create or replace procedure dr$temp_crepref(
  p_pre_name in varchar2,
  p_obj_name in varchar2
) is
 l_owner# number;
 l_pre_id number;
 l_obj_id number;
 l_cla_id number;
begin
 select user# into l_owner# from sys."_BASE_USER" where name = 'CTXSYS';
 select dr_id_seq.nextval into l_pre_id from dual;
 select obj_id, obj_cla_id into l_obj_id, l_cla_id from dr$object
  where obj_name = p_obj_name;
 insert into dr$preference
   (pre_id, pre_name, pre_owner#, pre_obj_id, pre_cla_id, pre_valid)
    values
   (l_pre_id, p_pre_name, l_owner#, l_obj_id, l_cla_id, 'Y');

 commit;
exception
  when dup_val_on_index then
    commit;
  when others then
    raise;
end;
/

create or replace procedure dr$temp_cresg(
  p_pre_name in varchar2,
  p_obj_name in varchar2
) is
 l_owner# number;
 l_pre_id number;
 l_obj_id number;
 l_cla_id number;
begin
 select user# into l_owner# from sys."_BASE_USER" where name = 'CTXSYS';
 select dr_id_seq.nextval into l_pre_id from dual;
 select obj_id into l_obj_id from dr$object where obj_name = p_obj_name;
 insert into dr$section_group(sgp_id, sgp_owner#, sgp_name, sgp_obj_id) 
 values                      (l_pre_id, l_owner#, p_pre_name, l_obj_id);
 commit;
exception
  when dup_val_on_index then
    commit;
  when others then
    raise;
end;
/

/* Simple version of set_attribute - for default preferences ONLY
 * Restrictions:  
   1.) NO ERROR CHECKING!!!
   2.) For boolean values, enter '0' or '1' only
 */

create or replace procedure dr$temp_setatt(
  p_pre_name in varchar2,
  p_att_name in varchar2,
  p_att_val  in varchar2
) is
 l_owner# number;
 l_pre_id number;
 l_obj_id number;
 l_cla_id number;
 l_oat_id number;
 l_datatype char(1);
 l_aval varchar2(500);
begin

 l_aval := upper(p_att_val);

 select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
 select pre_id, pre_obj_id, pre_cla_id into 
        l_pre_id, l_obj_id, l_cla_id
   from dr$preference where pre_name = p_pre_name and
                            pre_owner# = l_owner#;
 begin
   select oat_id, oat_datatype into 
          l_oat_id, l_datatype
     from dr$object_attribute
    where oat_cla_id = l_cla_id
      and oat_obj_id = l_obj_id
      and oat_name   = p_att_name
      and oat_system = 'N';
 exception
    when no_data_found then
       null;
 end;

 /* insert into dr$preference_value */

 begin
   insert into dr$preference_value(prv_pre_id, prv_oat_id, prv_value)
       values(l_pre_id, l_oat_id, l_aval);
 exception
   when dup_val_on_index then
     update dr$preference_value 
        set prv_value = l_aval
      where prv_oat_id = l_oat_id
        and prv_pre_id = l_pre_id;
 end;

 update dr$preference
    set pre_valid = 'N'
  where pre_id = l_pre_id;

 commit;

exception
  when others then
    null;
end;
/
/* Simple version of set_sec_grp_attr - for default preferences ONLY
 * Restrictions:  
   1.) NO ERROR CHECKING!!!
   2.) For boolean values, enter '0' or '1' only
 */
create or replace procedure dr$temp_setsecgrpatt(
  p_grp_name in varchar2,
  p_att_name in varchar2,
  p_att_val  in varchar2
) is
 l_owner# number;
 l_oat_id number;
 l_sgp_id number;
 l_attr_name   varchar2(30);
 l_aval        varchar2(500);
 l_secid  binary_integer;
 errnum   number;
 stmt_ins_sec  varchar2(1000);
 stmt_ins_attr varchar2(1000);
 isJsonEnable varchar2(1);

begin
  l_attr_name := upper(p_att_name);
  l_aval := upper(p_att_val);

  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';

  /* get section group id */
  select sgp_id into l_sgp_id from dr$section_group 
    where sgp_owner# = l_owner# and sgp_name = p_grp_name;

  /* get l_oat_id */
  begin
    select oat_id into l_oat_id from dr$object_attribute
      where oat_cla_id = 5
        and oat_obj_id = 8
        and oat_name   = l_attr_name
        and oat_system = 'N';
  exception
    when no_data_found then
      null;
  end;
     
  if (l_oat_id = 50818 and l_aval = 'ALL') then
    
    begin
      execute immediate 'select SGA_VALUE 
        from dr$section_group_attribute
      where sga_id = '||l_sgp_id||' and
           sga_sgat_id = 50817' into isJsonEnable;
    exception
      when no_data_found then
      	isJsonEnable := 0;
      when others then
       raise;
    end;

    if (isJsonEnable = 1) then
      l_aval := ',N,TS';    
    else 
      l_aval := ',N,B,TS';
    end if;
    
  elsif (l_oat_id = 50818 and l_aval = 'NUMBER') then
    l_aval := ',N';
  end if;

  /* insert into dr$section_group_attribute */
  begin
    execute immediate 'insert into dr$section_group_attribute
      (sga_id, sga_sgat_id, sga_value)
      values('||l_sgp_id||','||l_oat_id||','''||l_aval||''')';
  exception
    when dup_val_on_index then
     null;
    when others then
      errnum := SQLCODE;
      if (errnum = -00492) then
        null;
      else
        raise;
      end if;
  end;

  begin
  if (l_oat_id = 50818) then
    /* add sections for 5 types */
    /*template to insert into dr$section */
    stmt_ins_sec := 'insert into dr$section (' ||
                    'sec_id,' || 
                    'sec_type,' || 
                    'sec_name,' ||
                    'sec_sgp_id,' ||
                    'sec_tag,' ||
                    'sec_fid,' ||
                    'sec_visible,' ||
                    'sec_datatype' ||
                    ') values (';

    /* template to insert into dr$section_attribute */
    stmt_ins_attr := 'insert into dr$section_attribute values(';

    /* 1. number */
    if(INSTR(l_aval, ',N') > 0) then
      select dr_id_seq.nextval into l_secid from dual;
      execute immediate (
        stmt_ins_sec || l_secid || ',10,''' || p_grp_name || 
        'NUM*'',' || l_sgp_id || ',''num*'',101,''N'',2)'
      );

      /* section_name */
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' ||l_secid || 
        ', 240102, ''' || p_grp_name || 'NUM*'')'
      );
      /* tag */
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240103, ''num*'')'
      );
      /* token_type */
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240104, ''101'')'
      );
      /* visible */
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240105, ''0'')'
      );
      /* datatype */
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240107, ''2'')'
      );
      /* optimized_for*/
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240110, ''2'')'
      );
    end if;
    
    -- 2. binary double
    if(INSTR(l_aval, ',B') > 0) then    
      select dr_id_seq.nextval into l_secid from dual;
      execute immediate (
        stmt_ins_sec || l_secid || ',10,''' || p_grp_name ||
        'DB*'',' || l_sgp_id || ',''db*'',102,''N'',101)'
      );
      --section_name
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' ||l_secid ||
        ', 240102, ''' || p_grp_name || 'DB*'')'
      );
      --tag
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240103, ''db*'')'
      );
      --token_type
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240104, ''102'')'
      );
      --visible
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240105, ''0'')'
      );
      --datatype
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240107, ''101'')'
      );
      --optimized_for
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240110, ''2'')'
      );
    end if;

    --3. timestamp
    if(INSTR(l_aval, ',TS') > 0) then
      select dr_id_seq.nextval into l_secid from dual;
      execute immediate (
        stmt_ins_sec || l_secid || ',10,''' || p_grp_name ||
        'TS*'',' || l_sgp_id || ',''ts*'',103,''N'',187)'
      );

      --section_name
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' ||l_secid ||
        ', 240102, ''' || p_grp_name || 'TS*'')'
      );
      --tag
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240103, ''ts*'')'
      );
      --token_type
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240104, ''103'')'
      );
      --visible
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240105, ''0'')'
      );
      --datatype
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240107, ''187'')'
      );
      --optimized_for
      execute immediate (
        stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240110, ''2'')'
      );
    end if;
    /*
    --4. interval year to month 
    select dr_id_seq.nextval into l_secid from dual;
    execute immediate (
      stmt_ins_sec || l_secid || ',10,''' || p_grp_name ||
      'IYM*'',' || l_sgp_id || ',''iym*'',104,''N'',189)'
    );

    --section_name
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' ||l_secid ||
      ', 240102, ''' || p_grp_name || 'IYM*'')'
    );
    --tag
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240103, ''iym*'')'
    );
    --token_type
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240104, ''104'')'
    );
    --visible
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240105, ''0'')'
    );
    --datatype
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240107, ''189'')'
    );
    --optimized_for
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240110, ''2'')'
    );

    --5. interval day to second
    select dr_id_seq.nextval into l_secid from dual;
    execute immediate (
      stmt_ins_sec || l_secid || ',10,''' || p_grp_name ||
      'IDS*'',' || l_sgp_id || ',''ids*'',105,''N'',190)'
    );

    --section_name
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' ||l_secid ||
      ', 240102, ''' || p_grp_name || 'IDS*'')'
    );
    --tag 
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240103, ''ids*'')'
    );
    --token_type
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240104, ''105'')'
    );
    --visible
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240105, ''0'')'
    );
    --datatype
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240107, ''190'')'
    );
    --optimized_for
    execute immediate (
      stmt_ins_attr || l_sgp_id || ', ' || l_secid || ', 240110, ''2'')'
    );
  */
 end if;
exception
  when no_data_found then
    null;
  when dup_val_on_index then
    null;
  when others then
    errnum := SQLCODE;
    if (errnum = -00492) then
      null;
    else
      raise;
    end if;
end;
end;
/
show errors;

--IMP NOTE: The following temp functions are copies of functions from
--non-upg/dwgrd code. Please check if changes or fixes to the following
--temp functions require corresponding fixes in their original functions.
create or replace package temp_utl_pkg authid definer as

-- exceptions used by all components
textile_error  EXCEPTION;

POL_INDEX_ONLY      constant number := 0;
POL_POLICY_ONLY     constant number := 1;
POL_INDEX_OR_POLICY constant number := 2;

SEC_NONE            constant number := 0;
SEC_CONTAINS        constant number := 1;
SEC_OWNER           constant number := 2;
SEC_ALTER           constant number := 3;
SEC_DROP            constant number := 4;


subtype dr_id   is dbms_id_128;              /* use: id         */
subtype dr_id2  is varchar2(257);            /* use: id.id      */
subtype dr_id3  is varchar2(386);            /* use: id.id.id   */

subtype dr_qid  is dbms_quoted_id_128;       /* use: quoted id   */
subtype dr_qid2 is varchar2(261);            /* use: qid.qid     */
subtype dr_qid3 is varchar2(392);            /* use: qid.qid.qid */

subtype dr_lid  is dbms_id_128;             /* use: long id lid */
subtype dr_lid2 is varchar2(257);           /* use: lid.lid     */
subtype dr_lid3 is varchar2(386);           /* use: lid.lid.lid */

subtype dr_qlid  is dbms_quoted_id_128;     /* use: quoted long id qlid */
subtype dr_qlid2 is varchar2(261);          /* use: qlid.qlid           */
subtype dr_qlid3 is varchar2(392);          /* use: qlid.qlid.qlid      */
subtype dr_longpart is varchar2(403);       /* use: qlid.qlid partition(qlid) */

subtype dr_shortbuf is varchar2(32);         /* use: small scratch buff  */
subtype dr_medbuf   is varchar2(128);        /* use: medium scratch buff */
subtype dr_longbuf  is varchar2(512);        /* use: long scratch buff   */
subtype dr_extrabuf is varchar2(4000);       /* use: 4000 bytes          */
subtype dr_maxbuf   is varchar2(32767);      /* use: max len allowed     */

type idx_rec is record (
  IDX_ID              NUMBER(38)
, IDX_TYPE            NUMBER
, IDX_OWNER           VARCHAR2(128)
, IDX_OWNER#          NUMBER
, IDX_NAME            VARCHAR2(128)
, IDX_TABLE_OWNER     VARCHAR2(128)
, IDX_TABLE           VARCHAR2(128)
, IDX_TABLE#          NUMBER
, IDX_KEY_NAME        VARCHAR2(256)
, IDX_KEY_TYPE        NUMBER
, IDX_TEXT_NAME       VARCHAR2(256)
, IDX_TEXT_TYPE       NUMBER
, IDX_TEXT_LENGTH     NUMBER
, IDX_DOCID_COUNT     NUMBER
, IDX_STATUS          VARCHAR2(12)
, IDX_VERSION         NUMBER
, IDX_NEXTID          NUMBER
, IDX_LANGUAGE_COLUMN VARCHAR2(256)
, IDX_FORMAT_COLUMN   VARCHAR2(256)
, IDX_CHARSET_COLUMN  VARCHAR2(256)
, IDX_CONFIG_COLUMN   VARCHAR2(256)
, IDX_OPTION          VARCHAR2(64)
, IDX_OPT_TOKEN       VARCHAR2(255)
, IDX_OPT_TYPE        NUMBER
, IDX_OPT_COUNT       NUMBER
, IDX_SYNC_TYPE       VARCHAR2(20)
, IDX_SYNC_MEMORY     VARCHAR2(100)
, IDX_SYNC_PARA_DEGREE NUMBER
, IDX_SYNC_INTERVAL   VARCHAR2(4000)
);

DEFAULT_SEPARATOR   constant varchar2(1) := '$';

-- These object types are used by max_name_length to determine the maximum
-- length of an object.  This list must match the same list that appears in
-- dret.h.
OBJTYPE_INDEX      constant number := 1; -- Index name
OBJTYPE_POLICY     constant number := 2; -- Policy name
OBJTYPE_CONSTRAINT constant number := 3; -- Constraint (within internal objs)
OBJTYPE_THESAURUS  constant number := 4; -- Thesaurus name
OBJTYPE_SECTION    constant number := 5; -- Section name
OBJTYPE_PARAM      constant number := 6; -- Parameter
OBJTYPE_FEEDBACK   constant number := 7; -- Feedback column
OBJTYPE_SQE        constant number := 8; -- SQE name
OBJTYPE_LEXER      constant number := 9; -- Lexer name
OBJTYPE_TBS        constant number := 10; -- TBS name
OBJTYPE_ATTR       constant number := 11; -- Attribute
OBJTYPE_IDXSET     constant number := 12; -- Index set name
OBJTYPE_FILENAME   constant number := 13; -- File name
OBJTYPE_COLUMN     constant number := 14; -- Column name
OBJTYPE_LANGUAGE   constant number := 15; -- Language name
OBJTYPE_CHARSET    constant number := 16; -- Charset name
OBJTYPE_PREFERENCE constant number := 17; -- Preference name
OBJTYPE_STOPLIST   constant number := 18; -- Stoplist name
OBJTYPE_DICTIONARY constant number := 19; -- Dictionary name

DR_ID_LEN_30       constant number := 30;
DR_ID_LEN          constant number := 128;

/* Length of an object name after the final $ */
DR_INDEX_OBJECT_NAME_LEN constant number := 5;

/* This is the maximum length of a language name. */
MAX_LANGUAGE_LEN constant number := 30;


end temp_utl_pkg;
/

CREATE OR REPLACE FUNCTION dr$temp_enquote_parts(p_spec IN VARCHAR2,
                                       capitalize IN BOOLEAN := TRUE)
  RETURN VARCHAR2 IS
  l_spec temp_utl_pkg.dr_qlid3;
  l_period1 number;
  l_period2 number;
BEGIN
  IF INSTR(p_spec, '"') = 1 THEN
    -- Already start with a quote, so we're good
    l_spec := p_spec;
  ELSIF INSTR(p_spec, '.') = 0 THEN
    -- No period found, so just enquote the entire string
    l_spec := dbms_assert.enquote_name(p_spec, capitalize);
  ELSE
    -- Find the location(s) of the period(s)
    l_period1 := INSTR(p_spec, '.');
    l_period2 := INSTR(p_spec, '.', l_period1 + 1);
    -- Enquote between the periods
    l_spec :=
      dbms_assert.enquote_name(SUBSTR(p_spec, 1, l_period1 - 1), capitalize) 
                  || '.';
    IF l_period2 = 0 THEN
      l_spec := l_spec ||
       dbms_assert.enquote_name(SUBSTR(p_spec, l_period1 + 1), capitalize);
    ELSE
      l_spec := l_spec ||
       dbms_assert.enquote_name(SUBSTR(p_spec, l_period1 + 1,
                                      (l_period2 - l_period1 - 1)),
                                       capitalize) || '.' ||
       dbms_assert.enquote_name(SUBSTR(p_spec, l_period2 + 1), capitalize);
    END IF;
  END IF;

  RETURN l_spec;
END dr$temp_enquote_parts;
/

CREATE OR REPLACE PROCEDURE dr$temp_parse_object_name(
  spec    in     varchar2, 
  uname   in out varchar2, 
  oname   in out varchar2
)
is
  l_uname      temp_utl_pkg.dr_qid;
  l_oname      temp_utl_pkg.dr_qid;
  l_dblink     temp_utl_pkg.dr_lid;
  dummy        temp_utl_pkg.dr_shortbuf;
  pos          binary_integer;  
begin
  if spec is null then
    uname := NULL;
    oname := NULL;
--    dblink := NULL;
    return;
  end if;

  begin
    -- Parse spec which is assumed to be in quoted form.  Double quotes
    -- are stripped, or name is converted to upper case if there are no
    -- quotes.
    dbms_utility.name_tokenize(spec, l_uname, l_oname, dummy, l_dblink, pos);
    if pos <> lengthb(spec) then
      raise temp_utl_pkg.textile_error;
    end if;
  exception
    when others then
      --drue.text_on_stack(sqlerrm);
      --drue.push(DRIG.DL_ILL_POL_NAME);
      raise;
  end;
    
  if dummy is not null then
    --drue.push(DRIG.DL_ILL_POL_NAME);
    raise temp_utl_pkg.textile_error;
  end if;

  if l_dblink is not null and instr(l_dblink,'.') = 0 then
    select l_dblink||'.'||value into l_dblink from v$parameter
    where name = 'db_domain';

    if lengthb(l_dblink) > 128 THEN
      -- TODO: better error message
      --drue.push(DRIG.DL_OBJ_NAME_TOO_LONG);
      raise temp_utl_pkg.textile_error;
    end if;
  end if;

  if l_oname is null then
    l_oname := l_uname;
    l_uname := 'CTXSYS';--drvutl.GetCurrentSchema;

    if l_dblink is not null then
      -- get remote user name
      for r in (select username from dba_db_links
                where db_link = upper(l_dblink) and
                      owner in (l_uname, 'PUBLIC')
                order by decode(owner,'PUBLIC',1,0))
      loop
        l_uname := nvl(r.username,l_uname);
        exit;
      end loop;
    end if;
  end if;

  uname := l_uname;
  oname := l_oname;
--  dblink := l_dblink;

exception
  --when dr_def.textile_error then
    --driutl.druebrk;  -- Break on the error
    --raise;
  when others then
      --drue.text_on_stack(sqlerrm, 'driutl.parse_object_name');
      raise;
end dr$temp_parse_object_name;
/

/*---------------------------- ChkIndexOption -----------------------------*/
CREATE OR REPLACE function dr$temp_ChkIndexOption (
  p_idxid  in number,
  p_opt    in varchar2
) return number
is
  l_opt varchar2(40);

begin

  select idx_option into l_opt from ctxsys.dr$index where idx_id = p_idxid;
  if (l_opt like '%'||p_opt||'%') then
    return 1;
  else
    return 0;
  end if;

/*Bug 10405766 Add exception if table does not have value with given index */
exception
  when NO_DATA_FOUND then
    return 0;
  when others then
    raise;
end dr$temp_ChkIndexOption;
/
/*----------------------- IndexHasFullLengthObjects ------------------------*/

CREATE OR REPLACE FUNCTION dr$temp_IndexHasFullLengthObj(
  p_idx_id in number)
RETURN boolean is
  ret boolean := false;
begin
  for c1 in (select null from ctxsys.dr$index
              where idx_option like '%f%'
                and idx_id = p_idx_id)
  loop
    ret := TRUE;
  end loop;

  return ret;

exception
  when others then    
    raise;
end dr$temp_IndexHasFullLengthObj;
/

/*--------------------------- GetIndexRec  -------------------------------*/


CREATE OR REPLACE FUNCTION dr$temp_GetIndexRec(
  p_idx_name in         varchar2,
  f_ispolicy in number  default temp_utl_pkg.POL_INDEX_ONLY,
  f_security in number  default temp_utl_pkg.SEC_CONTAINS
) return temp_utl_pkg.idx_rec
is
  l_name        temp_utl_pkg.dr_qid2;
  l_table       temp_utl_pkg.dr_id;
  l_owner       temp_utl_pkg.dr_qid2;
  l_idx         temp_utl_pkg.idx_rec;
  lv_datasrc    temp_utl_pkg.dr_longbuf;
  lv_index_name temp_utl_pkg.dr_qid2;
  lv_user       temp_utl_pkg.dr_qid2;
  l_owner#      number;
begin
  -- 20952246: We can be called with any of the following formats:
  -- indexname "indexname" user.indexname "user"."indexname"
  -- We need to end up with a quoted value to pass to parse_object_name.
  lv_index_name := dr$temp_enquote_parts(p_idx_name);

  lv_user := 'CTXSYS';

  -- required to resolve synonyms on policies 

  dr$temp_parse_object_name(lv_index_name, l_owner, l_name);
  
  select user_id into l_owner# from SYS.all_users where username = ''||l_owner;
  
  select /*+ ORDERED USE_NL(o) */ idx_id, idx_type, 
           l_owner#, l_owner, idx_name, 
           u.name, o.name, idx_table#,
           idx_key_name, idx_key_type, 
           idx_text_name, idx_text_type, idx_text_length,
           idx_docid_count, idx_status, 
           idx_version, idx_nextid, 
           idx_language_column, idx_format_column, 
           idx_charset_column, idx_config_column, idx_option,
           idx_opt_token, idx_opt_type, idx_opt_count,
           idx_sync_type, idx_sync_memory, idx_sync_para_degree,
           idx_sync_interval
     into  l_idx.idx_id, l_idx.idx_type, 
           l_idx.idx_owner#, l_idx.idx_owner, l_idx.idx_name, 
           l_idx.idx_table_owner, l_idx.idx_table, l_idx.idx_table#,
           l_idx.idx_key_name, l_idx.idx_key_type, 
           l_idx.idx_text_name, l_idx.idx_text_type, l_idx.idx_text_length,
           l_idx.idx_docid_count, l_idx.idx_status, 
           l_idx.idx_version, l_idx.idx_nextid, 
           l_idx.idx_language_column, l_idx.idx_format_column,
           l_idx.idx_charset_column, l_idx.idx_config_column, 
           l_idx.idx_option,
           l_idx.idx_opt_token, l_idx.idx_opt_type, l_idx.idx_opt_count,
           l_idx.idx_sync_type, l_idx.idx_sync_memory, 
           l_idx.idx_sync_para_degree, l_idx.idx_sync_interval
     from ctxsys.dr$index, sys."_BASE_USER" u, sys.obj$ o
    where idx_name = l_name
     and  idx_owner# = l_owner#
     and  idx_table_owner# = u.user#
     and  idx_table# = o.obj#;

    -- 6654757: Check for null idx_option
    if (f_ispolicy = temp_utl_pkg.POL_POLICY_ONLY and 
        (l_idx.idx_option is null or l_idx.idx_option not like '%O%')) then
      --drue.push(DRIG.D2_ISIDX_NOT_POL);
      raise temp_utl_pkg.textile_error;
    end if;

    if (f_ispolicy = temp_utl_pkg.POL_INDEX_ONLY and l_idx.idx_option like '%O%') then
      --drue.push(DRIG.D2_ISPOL_NOT_IDX);
      raise temp_utl_pkg.textile_error;
    end if;

    return l_idx;

exception
    when no_data_found then
      --if (f_ispolicy = POL_POLICY_ONLY) then
        --drue.push(DRIG.D2_POLICY_NOTXIST, 
          --        driutl.NormalizeObjectName(p_idx_name));
      --else
        --drue.push(DRIG.DL_POLICY_NOTXIST, 
          --        driutl.NormalizeObjectName(p_idx_name));
      --end if;
      raise;
    when others then
      --drue.text_on_stack(sqlerrm, 'drixmd.GetIndexRec');
      raise;
end dr$temp_GetIndexRec;
/

/*------------------------------- MaxNameLength -----------------------------*/
/*
  NAME
    max_name_length - Compute and return the maximum length of an object's name
  DESCRIPTION
    Returns the maximum length of the object, based on the object type,
    database compatible settings, and whether full length index names are
    enabled.
  NOTES
    Full length index names are disabled by setting level 4 for event 30580.
  ARGUMENTS
    p_obj_type   - One of the OBJTYPE constants defined in the package header
    p_partition  - If TRUE, return the maximum length assuming the object is
                   partitioned
    p_full_length_objs - If TRUE, consider full length objects enabled
    p_pfx_check  - If TRUE, we are called from make_pfx.  In this case return
                   the point at which the name needs to be truncated.
    p_30_char_names - If TRUE, consider the maximum length of a database object
                   to be 30, even if compatible >= 12.2
  EXCEPTIONS
    dr_def.textile_error if p_obj_type is not one of the OBJTYPE constants
  RETURNS
    Maximum length for the given object
*/
CREATE OR REPLACE FUNCTION dr$temp_max_name_length(
  p_obj_type IN NUMBER,
  p_partition IN BOOLEAN,
  p_full_length_objs IN BOOLEAN,
  p_30_char_names IN BOOLEAN,
  p_pfx_check IN BOOLEAN := FALSE)
RETURN NUMBER IS
  dr_id_len    NUMBER;
  partid_len   NUMBER;
  object_name_len NUMBER;
  compatible_param varchar2(20);
BEGIN

  select value into compatible_param from v$parameter  
  			   where name like 'compatible';

  -- 22097228: Maximum length is 30 if compatible < 12.2 or p_30_char_names
  -- is true
  IF compatible_param >= '12.2' AND NOT p_30_char_names THEN
    dr_id_len := temp_utl_pkg.DR_ID_LEN;
  ELSE
    dr_id_len := temp_utl_pkg.DR_ID_LEN_30;
  END IF;

  -- Partition string is 4 characters if full length index names are disabled
  -- (just the partid itself), 5 characters if full length index names are
  -- enabled (# and the partid).
  IF p_partition THEN
    IF p_full_length_objs THEN
      partid_len := 5;
    ELSE
      partid_len := 4;
    END IF;
  ELSE
    partid_len := 0;
  END IF;

  -- Determine length of the object name (I, R, ERROR, etc.) that is found
  -- after the final $.  This is dependent on full length index names.
  IF p_full_length_objs THEN
    object_name_len := temp_utl_pkg.DR_INDEX_OBJECT_NAME_LEN;
  ELSE
    object_name_len := 1;  -- Only single character objects
  END IF;

  -- Switch based on object type.  For now, only database objects such as 
  -- table and index names support long identifiers.  Other Text objects such
  -- as preferences are limited to the original 30 characters.
  CASE p_obj_type
    WHEN temp_utl_pkg.OBJTYPE_INDEX THEN
      IF NOT p_pfx_check AND p_full_length_objs THEN
        RETURN dr_id_len;
      ELSE
        RETURN dr_id_len
               - 3                -- Initial DR$ or DR#
               - 1                -- Final $
               - object_name_len  -- Object name (I, R, ERROR, etc.)
               - partid_len;      -- Partition string
      END IF;
    WHEN temp_utl_pkg.OBJTYPE_POLICY THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_CONSTRAINT THEN
      IF NOT p_pfx_check AND p_full_length_objs THEN
        RETURN dr_id_len;
      ELSE
        RETURN dr_id_len
               - 4                -- Initial DRC$
               - 1                -- Final $
               - object_name_len  -- Object name (I, R, ERROR, etc.)
               - partid_len;      -- Partition string
      END IF;
    WHEN temp_utl_pkg.OBJTYPE_THESAURUS THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_SECTION THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_PARAM THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_FEEDBACK THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_SQE THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_LEXER THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_TBS THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_ATTR THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_IDXSET THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_FILENAME THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_COLUMN THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_LANGUAGE THEN
      RETURN temp_utl_pkg.MAX_LANGUAGE_LEN;
    WHEN temp_utl_pkg.OBJTYPE_CHARSET THEN
      RETURN dr_id_len;
    WHEN temp_utl_pkg.OBJTYPE_PREFERENCE THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_STOPLIST THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    WHEN temp_utl_pkg.OBJTYPE_DICTIONARY THEN
      -- Limited to original 30 characters, regardless of partitions
      RETURN temp_utl_pkg.DR_ID_LEN_30;
    ELSE
      --drue.push_internal('max_name_length', p_obj_type);
      RAISE temp_utl_pkg.textile_error;
  END CASE;

END dr$temp_max_name_length;
/

CREATE OR REPLACE FUNCTION dr$temp_make_pfx(idx_owner in varchar2, 
	               idx_name in varchar2,
                   pfx_type  in varchar2 default '$', 
                   part_id   in number default null,
                   constraint_pfx in boolean default FALSE,
                   idx_id    in number default null,
                   full_length_objs in boolean default null,
                   thirty_char_names in boolean default null)
return varchar2 
is
  partidstr      varchar2(5);
  init_sep       char(1);
  lpid           number := part_id;
  l_idx_owner    temp_utl_pkg.dr_qlid;
  l_idx_name     temp_utl_pkg.dr_qlid;
  l_pfx_type     varchar(1);
  l_pfx_str      varchar(4);
  lvl            number;
  l_max_name_len number;
  l_idx_id       number;
  l_idx          temp_utl_pkg.idx_rec;
  q_idx_name     temp_utl_pkg.dr_qlid;
  l_full_length_objs boolean;
  l_30_char_names boolean;
begin
  -- 6786088: Validate idx_owner and idx_name
  if (idx_owner is null) then
    l_idx_owner := null;
  else
    l_idx_owner := dbms_assert.enquote_name(idx_owner, FALSE);
  end if;

  if (constraint_pfx = TRUE) then
    l_pfx_str := 'DRC';
  else
    l_pfx_str := 'DR';
  end if;

  -- 20671782: Validate q_idx_name not idx_name
  l_idx_name := ltrim(rtrim(idx_name, '"'), '"');
  q_idx_name :=
    dbms_assert.simple_sql_name(dbms_assert.enquote_name(idx_name, FALSE));

  -- 7425113: Validate pfx_type
  if (length(pfx_type) != 1) then
    --drue.push(DRIG.AG_BAD_VALUE, 'pfx_type');
    raise temp_utl_pkg.textile_error;
  else
    l_pfx_type := dbms_assert.noop(pfx_type);
  end if;

  -- Determine index ID so we can truncate if needed.  If the index ID is
  -- passed in (i.e. we are renaming) use that.  Add quotes if not present.
  if idx_id is not null then
    l_idx_id := idx_id;
  elsif l_idx_owner is null then
    l_idx := dr$temp_GetIndexRec(q_idx_name, 
    	                         f_security => temp_utl_pkg.SEC_NONE);
    l_idx_id := l_idx.idx_id;
  else
    l_idx := 
      dr$temp_GetIndexRec(l_idx_owner || '.' || q_idx_name,
                         f_security => temp_utl_pkg.SEC_NONE);
    l_idx_id := l_idx.idx_id;
  end if;

  -- Determine l_full_length_objs.  If it is passed in, use that.  Otherwise
  -- we will use the settings for the index in question.
  if full_length_objs is not null then
    l_full_length_objs := full_length_objs;
  else
    l_full_length_objs := dr$temp_IndexHasFullLengthObj(l_idx_id);
  end if;

  -- 22097228: Determine 30_char_names.  If it is passed in, use that.
  -- Otherwise we will use the setting for the index in question.
  if thirty_char_names is not null then
    l_30_char_names := thirty_char_names;
  else
    l_30_char_names := (dr$temp_ChkIndexOption(l_idx_id, 't') = 1);
  end if;
  
  if (constraint_pfx and not l_full_length_objs) then
    l_pfx_str := 'DRC';
  else
    l_pfx_str := 'DR';
  end if;

  -- Determine partidstr and init_sep
  if (part_id is null or part_id = 0) then
    partidstr := '';
    init_sep := '$';
  else
    if (lpid >= 10000) then
      lpid := lpid - 10000;
      partidstr := '';
   --Removed OLS Bug Fix 13783516, unrequired for upgrade. Breaks sync etc.
      
    else
      partidstr := ltrim(to_char(part_id,'0000'));
    end if;

    if l_full_length_objs then
      partidstr := '#' || partidstr;
      init_sep := '$';
    else
      init_sep := '#';
    end if;
  end if;

  if constraint_pfx and not l_full_length_objs then
    -- 20952246: Truncate constraint name if needed
    l_max_name_len :=
      dr$temp_max_name_length(temp_utl_pkg.OBJTYPE_CONSTRAINT,
                      p_partition => (part_id is not null and part_id != 0),
                      p_full_length_objs => l_full_length_objs,
                      p_30_char_names => l_30_char_names,
                      p_pfx_check => TRUE);

    l_idx_name := rtrim(substrb(l_idx_name, 1, l_max_name_len));
  elsif l_full_length_objs then
    -- Adjust l_idx_name so that it will fit
    -- 20952246: use max_name_length
    l_max_name_len :=
      dr$temp_max_name_length(temp_utl_pkg.OBJTYPE_INDEX,
                      p_partition => (part_id is not null and part_id != 0), 
                      p_full_length_objs =>l_full_length_objs,
                      p_30_char_names => l_30_char_names,
                      p_pfx_check => TRUE);

    if lengthb(l_idx_name) > l_max_name_len then
      l_idx_name := rtrim(substrb(l_idx_name, 1,
                           l_max_name_len - lengthb(l_idx_id))) ||
                    l_idx_id;
    end if;
  end if;

  if ((l_idx_owner is null) OR (constraint_pfx = TRUE)) then
    return '"' || l_pfx_str || init_sep || l_idx_name ||
           partidstr || l_pfx_type;
  else
    return l_idx_owner || '.' ||
           '"' || l_pfx_str || init_sep || l_idx_name ||
           partidstr || l_pfx_type;
  end if;

end dr$temp_make_pfx;
/

/*------------------------ get_object_prefix -----------------------------*/
CREATE OR REPLACE FUNCTION dr$temp_get_object_prefix(
  idx_owner in varchar2,
  idx_name  in varchar2,
  part_id   in number default null,
  sep       in varchar2 default temp_utl_pkg.DEFAULT_SEPARATOR,
  full_length_objs in boolean default null
) RETURN VARCHAR2 IS
  pfx   temp_utl_pkg.dr_qlid2;
begin
  -- 20952246: Pass full_length_objs
  pfx :=  dr$temp_make_pfx(idx_owner, idx_name, sep, part_id, false, null,
                          full_length_objs);
  return pfx;
end dr$temp_get_object_prefix;
/

/*-------------------------- get_object_name ------------------------------*/
CREATE OR REPLACE FUNCTION dr$temp_get_object_name(
  idx_owner in varchar2,
  idx_name  in varchar2,
  idxid     in number,
  part_id   in number default null,
  which     in varchar2,
  sep       in varchar2 default temp_utl_pkg.DEFAULT_SEPARATOR,
  full_length_objs in boolean default null
) RETURN VARCHAR2 IS
  pfx    temp_utl_pkg.dr_qlid2;
begin
  pfx := dr$temp_get_object_prefix(idx_owner, idx_name, part_id, sep);

  --RC is for local index on $R table, NI is for local index on $N table
  --KI is for index on $K table, UI is for index on $U table
  --with system partition, we can not have global primary/unique index on
  --partitioned $R and $N tables
  if (which in ('A', 'D', 'DG', 'E', 'F', 'G', 'H', 'I', 'K', 'KI', 'L', 'M',
                'N', 'NI', 'O', 'P', 'PP', 'R', 'RC', 'S', 'SBD', 'SBDI',
                'SBF', 'SBFI', 'SD', 'SDI', 'SIDS', 'SIDSI', 'SIYM',
                'SN', 'SNI', 'ST', 'STI', 'STZ', 'STZI', 'SIYMI', 'SV',
                'SVI', 'SR', 'SRI', 'T', 'U', 'UI','V', 'W',
                'X', 'Y', 'Z', 'KG', 'KGI')) then
    -- 20952246: Pass full_length_objs
    pfx := dr$temp_get_object_prefix(idx_owner, idx_name, 
      	                             part_id, sep, full_length_objs);
    if (which = 'PP') then
      pfx := pfx || 'P' || '"'; -- special case
    else
      pfx := pfx || which || '"';
    end if;
  else
    raise temp_utl_pkg.textile_error;
  end if;

  return pfx;
end dr$temp_get_object_name;
/

REM ========================================================================
REM drop DummyIndexMethods, dummyop, and ctx_dummyop
REM ========================================================================
drop type DummyIndexMethods force;
drop operator dummyop force;
drop package ctx_dummyop;


REM ========================================================================
REM dummy index implementation type in case t scripts need it
REM ========================================================================

create or replace type DummyIndexMethods authid definer as object
(
   key          RAW(4),
   objid        RAW(4),
   tmpobjid     RAW(4),

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
            return number
);
/

PROMPT Create dummy implementation type body ...
PROMPT

create or replace type body DummyIndexMethods is

/* ----------------------- ODCIGetInterfaces ------------------------------ */

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number 
is 
begin 
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 
end;
/
show errors


REM ========================================================================
REM dummy operator in case t scripts need it
REM ========================================================================

create or replace package ctx_dummyop authid definer as
    function dummyop(Colval in varchar2, 
                             Text in varchar2, ia sys.odciindexctx, 
                             sctx IN OUT DummyIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
end ctx_dummyop;
/

PROMPT Create dummy operator ...
PROMPT

create or replace operator dummyop binding 
  (varchar2, varchar2) return number 
     with index context, scan context DummyIndexMethods
without column data using ctx_dummyop.dummyop;

grant execute on dummyop to public;

@?/rdbms/admin/sqlsessend.sql
