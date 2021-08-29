Rem
Rem $Header: ctx_src_2/src/dr/admin/d1202020.sql /main/17 2017/10/26 11:13:59 nspancha Exp $
Rem
Rem d1202020.sql
Rem
Rem Copyright (c) 2016, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1202020.sql
Rem
Rem    DESCRIPTION
Rem      
Rem
Rem    NOTES
Rem      
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1202020.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE: DOWNGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nspancha    09/01/17 - Bug 26225601: Downgrade script failure
Rem    aczarlin    08/16/17 - bug 26633319 change default stage_itab_max_rows
Rem    demukhin    06/20/17 - bug 26051570: keep $R for legacy indexes
Rem    rodfuent    05/09/17 - Bug 25217590: dml-bypass for TextIndexMethods
Rem    nspancha    03/26/17 - Bug 25661502: Duplicate tokens due to truncation
Rem    snetrava    03/14/17 - Add FILE_ACCESS_ROLE 
Rem    boxia       03/13/17 - Bug 25468759: rm idx_auto_opt_para_degree,
Rem                           ixp_auto_opt_para_degree
Rem    nspancha    02/27/17 - Bug 25353917:Convert token tables back to 64bytes
Rem    demukhin    02/20/17 - prj 68638: remove $R
Rem    rodfuent    02/06/17 - Bug 25422217: $DI storage clause
Rem    boxia       01/17/17 - Proj 68638: rm dbms_scheduler privileges 
Rem    boxia       01/12/17 - Bug 25390928: alter dr$index_partition,
Rem                           ctx_index_partitions, ctx_user_index_partitions
Rem    snetrava    01/05/17 - Storage clauses for Wildcard index
Rem    rodfuent    12/15/16 - Bug 25028151: revoke dba_tab_subpartitions
Rem    boxia       12/09/16 - correct last line of running sqlsessend.sql
Rem    boxia       11/19/16 - Bug 25172618: rm stage_itab_auto_opt
Rem                           alter dr$index, ctx_indexes, ctx_user_indexes
Rem    snetrava    11/02/16 - Bug 25035481 WILDCARD_INDEX, WILDCARD_INDEX_K
Rem    shuroy      10/13/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

@@?/rdbms/admin/sqlsessstart.sql

--IMP NOTE: The following temp functions are copies of functions from
--non-upg/dwgrd code. Please check if changes or fixes to the following
--temp functions require corresponding fixes in their original functions.

--------------TEMP FUNCTIONS FOR DOWNGRADE-------------------
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
  elsif (which in ('KD', 'KR')) then
    -- new objects with full length names
    pfx := dr$temp_make_pfx(idx_owner, idx_name, sep, part_id, 
                            FALSE, idxid, TRUE);
    pfx := pfx || which || '"';
  else
    raise temp_utl_pkg.textile_error;
  end if;

  return pfx;
end dr$temp_get_object_name;
/


REM
REM BEGIN creating a 12.1 version dummy impl. type and operator
REM

create or replace type DummyindexMethods authid definer as object
(
   key          RAW(4),
   objid        RAW(4),
   tmpobjid     RAW(4),

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
            return number
);
/

PROMPT Create dummy implementation type body
PROMPT

create or replace type body DummyIndexMethods is

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
        return OCINumber
      );
end ctx_dummyop;
/

PROMPT Create dummy operator
PROMPT

create or replace operator dummyop binding
  (varchar2, varchar2) return number
     with index context, scan context DummyIndexMethods
without column data using ctx_dummyop.dummyop;

grant execute on dummyop to public;

REM
REM END creating a dummy impl. type  and operator
REM

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT_V2 FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;


REM
REM BEGIN DOWN-GRADING CONTEXT INDEXTYPE
REM

PROMPT Remove existing indextype operator bindings ...
PROMPT

alter indextype context add dummyop(varchar2, varchar2);
alter indextype context drop contains(varchar2, varchar2);
alter indextype context drop contains(varchar2, clob);
alter indextype context drop contains(clob, varchar2);
alter indextype context drop contains(clob, clob);
alter indextype context drop contains(blob, varchar2);
alter indextype context drop contains(blob, clob);
alter indextype context drop contains(bfile, varchar2);
alter indextype context drop contains(bfile, clob);
alter indextype context drop contains(sys.xmltype, varchar2);
alter indextype context drop contains(sys.xmltype, clob);
alter indextype context drop contains(sys.uritype, varchar2);
alter indextype context drop contains(sys.uritype, clob);

alter indextype context_v2 add dummyop(varchar2, varchar2);
alter indextype context_v2 drop contains(varchar2, varchar2);
alter indextype context_v2 drop contains(varchar2, clob);
alter indextype context_v2 drop contains(clob, varchar2);
alter indextype context_v2 drop contains(clob, clob);
alter indextype context_v2 drop contains(blob, varchar2);
alter indextype context_v2 drop contains(blob, clob);
alter indextype context_v2 drop contains(bfile, varchar2);
alter indextype context_v2 drop contains(bfile, clob);
alter indextype context_v2 drop contains(sys.xmltype, varchar2);
alter indextype context_v2 drop contains(sys.xmltype, clob);
alter indextype context_v2 drop contains(sys.uritype, varchar2);
alter indextype context_v2 drop contains(sys.uritype, clob);


PROMPT Drop SCORE and CONTAINS operators
PROMPT

drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;
drop package driscore;

PROMPT Shift indextype implementation to dummy implementation type
PROMPT
alter indextype context using DummyIndexMethods;
alter indextype context_v2 using DummyIndexMethods;

PROMPT Create new version of TextIndexMethods and TextOptStats
PROMPT
drop type TextIndexMethods;
drop type TextOptStats;

PROMPT Create 12.2 version of TextIndexMethods and TextOptStats
PROMPT
REM    (this is copied directly from old dr0type.pkh)

create or replace type TextIndexMethods authid current_user as object
(
   key          RAW(4),
   objid        RAW(4),
   tmpobjid     RAW(4),

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
            return number,
   static function ODCIIndexCreate(ia sys.odciindexinfo, parms varchar2,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexAlter(ia sys.odciindexinfo,
                          parms in out varchar2,
                          altopt number, env sys.ODCIEnv)
            return number,
   static function ODCIIndexTruncate(ia sys.odciindexinfo,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexDrop(ia sys.odciindexinfo,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexInsert(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "insert"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),
   static function ODCIIndexUpdate(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "update"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),

   static function ODCIIndexDelete(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "delete"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),

   static function ODCIIndexStart(sctx in out TextIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg varchar2,
                          env SYS.ODCIEnv)
            return number is language C
            name "start"
            library dr$lib
            with context
            parameters(
               context,
               sctx,
               sctx INDICATOR STRUCT,
               ia,
               ia INDICATOR STRUCT,
               op,
               op INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               valarg LENGTH,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),

   static function ODCIIndexStart(sctx in out TextIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg clob,
                          env SYS.ODCIEnv)
            return number is language C
            name "start_clob"
            library dr$lib
            with context
            parameters(
               context,
               sctx,
               sctx INDICATOR STRUCT,
               ia,
               ia INDICATOR STRUCT,
               op,
               op INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   member function ODCIIndexFetch(nrows number,
                          rids OUT sys.odciridlist, env SYS.ODCIEnv)
            return number is language C
            name "fetch"
            library dr$lib
            with context
            parameters(
               context,
               self,
               self INDICATOR STRUCT,
               nrows,
               nrows INDICATOR,
               rids,
               rids INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   member function ODCIIndexClose(env sys.ODCIEnv)
            return number is language C
            name "close"
            library dr$lib
            with context
            parameters(
               context,
               self,
               self INDICATOR STRUCT,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   static function ODCIIndexGetMetaData(ia        IN  sys.odciindexinfo,
                                        version   IN  varchar2,
                                        new_block OUT PLS_INTEGER,
                                        env       IN  sys.ODCIEnv)
            return varchar2,
  static function ODCIIndexUpdPartMetaData(ia     IN  sys.odciindexinfo,
                                           palist IN   sys.ODCIPartInfoList,
                                           env    IN  sys.ODCIEnv)
            return NUMBER,
   static function ODCIIndexUtilGetTableNames(ia        IN  sys.odciindexinfo,
                                              read_only IN  PLS_INTEGER,
                                              version   IN  varchar2,
                                              context   OUT PLS_INTEGER)
            return boolean,
   static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER),
   static function ODCIIndexSplitPartition(ia         IN SYS.ODCIIndexInfo,
                                           part_name1 IN SYS.ODCIPartInfo,
                                           part_name2 IN SYS.ODCIPartInfo,
                                           parms      IN varchar2,
                                           env        IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexMergePartition(ia         IN SYS.ODCIIndexInfo,
                                           part_name1 IN SYS.ODCIPartInfo,
                                           part_name2 IN SYS.ODCIPartInfo,
                                           parms      IN varchar2,
                                           env        IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexExchangePartition(ia  IN SYS.ODCIIndexInfo,
                                              ia1 IN SYS.ODCIIndexInfo,
                                              env IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexUpdate(ia         sys.odciindexinfo,
                                   ridlist    sys.odciridlist,
                                   oldvallist sys.odcicolarrayvallist,
                                   newvallist sys.odcicolarrayvallist,
                                   env        sys.ODCIEnv)
            return number
);
/

----------------------------------------------
-- CREATE EIX OPTIMIZER IMPLEMENTATION TYPE --
----------------------------------------------
create or replace type TextOptStats authid definer as object
(
   stats_ctx RAW(4),
   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
       return number,
   static function ODCIStatsCollect(idx sys.ODCIIndexInfo,
                                    options sys.ODCIStatsOptions,
                                    statistics OUT RAW,
                                    env sys.ODCIEnv)
            return number is language C
            name "st_coll"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               options,
               options INDICATOR STRUCT,
               statistics,
               statistics INDICATOR,
               statistics LENGTH,
               env,
               env     INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsDelete(idx sys.ODCIIndexInfo, statistics OUT RAW,
                                   env sys.ODCIEnv)
            return number is language C
            name "st_delv2"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               statistics,
               statistics INDICATOR,
               statistics LENGTH,
               env,
               env     INDICATOR STRUCT,
               return OCINumber
            ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval varchar2,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval varchar2,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval clob,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval clob,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval blob,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval blob,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval bfile,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval bfile,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.xmltype,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.xmltype,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.uritype,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.uritype,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval varchar2,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval varchar2,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval clob,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval clob,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval blob,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval blob,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval bfile,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval bfile,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.xmltype,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.xmltype,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.uritype,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.uritype,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsIndexCost(idx sys.ODCIIndexInfo,
                                      sel NUMBER,
                                      cost IN OUT sys.ODCICost,
                                      qi sys.ODCIQueryInfo,
                                      pred sys.ODCIPredInfo,
                                      args sys.ODCIArgDescList,
                                      strt NUMBER,
                                      stop NUMBER,
                                      valarg varchar2,
                                      env  sys.ODCIEnv)
            return number is language C
            name "st_icost"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               cost,
               cost INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               pred,
               pred INDICATOR STRUCT,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env    INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsIndexCost(idx sys.ODCIIndexInfo,
                                      sel NUMBER,
                                      cost IN OUT sys.ODCICost,
                                      qi sys.ODCIQueryInfo,
                                      pred sys.ODCIPredInfo,
                                      args sys.ODCIArgDescList,
                                      strt NUMBER,
                                      stop NUMBER,
                                      valarg clob,
                                      env  sys.ODCIEnv)
            return number is language C
            name "st_icost_clob"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               cost,
               cost INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               pred,
               pred INDICATOR STRUCT,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env    INDICATOR STRUCT,
               return OCINumber
             ),

  pragma restrict_references(ODCIStatsSelectivity, WNDS, WNPS),
  pragma restrict_references(ODCIStatsFunctionCost, WNDS, WNPS),
  pragma restrict_references(ODCIStatsIndexCost, WNDS, WNPS)
);
/

REM create a dummy type body.

create or replace type body TextIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number
is
begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2'));
  return sys.ODCIConst.Success;
end ODCIGetInterfaces;

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo,
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo,
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo,
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUpdPartMetaData(
  ia      in  sys.odciindexinfo,
  palist  in  sys.ODCIPartInfoList,
  env     in  sys.ODCIEnv
) return NUMBER
is
begin
 return sys.odciconst.fatal;
end ODCIIndexUpdPartMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

static function ODCIIndexUpdate(
  ia         sys.odciindexinfo,
  ridlist    sys.odciridlist,
  oldvallist sys.odcicolarrayvallist,
  newvallist sys.odcicolarrayvallist,
  env        sys.ODCIEnv)
return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

end;
/

select text from dba_errors
 where owner = 'CTXSYS' and name = 'TEXTINDEXMETHODS';

show errors;

create or replace type body TextOptStats is

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
       return number is
   begin
       ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCISTATS2'));
       return ODCIConst.Success;
   end ODCIGetInterfaces;

end;
/

select text from dba_errors
 where owner = 'CTXSYS' and name = 'TEXTOPTSTATS';

show errors;

PROMPT Shift indextype implementation to TextIndexMethods and add
PROMPT    support for composite index.
PROMPT

alter indextype context using TextIndexMethods;
alter indextype context_v2 using TextIndexMethods;

REM
REM recreate 12.2 version contains and score operators
REM following copied directly from dr0itype.sql
REM

create or replace package ctx_contains authid current_user as
    -- varchar2 column type, varchar2 query string type
    function Textcontains(Colval in varchar2,
                             Text in varchar2, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
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
        return OCINumber
      );
    -- varchar2 column type, clob query string type
    function Textcontains(Colval in varchar2,
                             Text in clob, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- clob column type, varchar2 query string type
    function Textcontains(Colval in clob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    -- clob column type, clob query string type
    function Textcontains(Colval in clob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- blob column type, varchar2 query string type
    function Textcontains(Colval in blob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
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
        return OCINumber
      );
    -- blob column type, clob query string type
    function Textcontains(Colval in blob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- bfile column type, varchar2 query string type
    function Textcontains(Colval in bfile,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    -- bfile column type, clob query string type
    function Textcontains(Colval in bfile,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Xmltype column type, varchar2 query string type
    function Textcontains(Colval in sys.xmltype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
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
        return OCINumber
      );
    -- Xmltype column type, clob query string type
    function Textcontains(Colval in sys.xmltype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Uritype column type, varchar2 query string type
    function Textcontains(Colval in sys.uritype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Uritype column type, clob query string type
    function Textcontains(Colval in sys.uritype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

end ctx_contains;
/

--------------------------------------
-- CREATE CONTAINS PRIMARY OPERATOR --
--------------------------------------
---  CREATE TEXT OPERATOR
create or replace operator contains binding
  (varchar2, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (varchar2, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (clob, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (clob, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (blob, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (blob, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (bfile, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (bfile, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.xmltype, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.xmltype, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.uritype, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.uritype, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
;

grant execute on contains to public;

drop public synonym contains;
create public synonym contains for ctxsys.contains;
-------------------------------
-- CREATE ANCILLARY FUNCTION --
-------------------------------
create or replace package driscore authid current_user as
    function TextScore(Colval in varchar2,
                             Text in varchar2, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    function TextScore(Colval in varchar2,
                             Text in clob, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in clob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    function TextScore(Colval in clob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in blob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    function TextScore(Colval in blob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in bfile,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    function TextScore(Colval in bfile,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.xmltype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
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
        return OCINumber
      );
    function TextScore(Colval in sys.xmltype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.uritype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.uritype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end driscore;
/

-------------------------------
-- CREATE ANCILLARY OPERATOR --
-------------------------------
---  CREATE Score OPERATOR
create or replace operator score binding
   (number) return number
     ancillary to contains(varchar2, varchar2),
                  contains(varchar2, clob),
                  contains(clob, varchar2),
                  contains(clob, clob),
                  contains(blob, varchar2),
                  contains(blob, clob),
                  contains(bfile, varchar2),
                  contains(bfile, clob),
                  contains(sys.xmltype, varchar2),
                  contains(sys.xmltype, clob),
                  contains(sys.uritype, varchar2),
                  contains(sys.uritype, clob)
     without column data using driscore.TextScore;

grant execute on score to public;

drop public synonym score;
create public synonym score for ctxsys.score;

grant execute on ConText to public;

grant execute on ConText_V2 to public;


PROMPT Rebind operators and remove the dummyop
PROMPT

alter indextype context add contains(varchar2, varchar2);
alter indextype context add contains(varchar2, clob);
alter indextype context add contains(clob, varchar2);
alter indextype context add contains(clob, clob);
alter indextype context add contains(blob, varchar2);
alter indextype context add contains(blob, clob);
alter indextype context add contains(bfile, varchar2);
alter indextype context add contains(bfile, clob);
alter indextype context add contains(sys.xmltype, varchar2);
alter indextype context add contains(sys.xmltype, clob);
alter indextype context add contains(sys.uritype, varchar2);
alter indextype context add contains(sys.uritype, clob);
alter indextype context drop dummyop(varchar2, varchar2);

alter indextype context_v2 add contains(varchar2, varchar2);
alter indextype context_v2 add contains(varchar2, clob);
alter indextype context_v2 add contains(clob, varchar2);
alter indextype context_v2 add contains(clob, clob);
alter indextype context_v2 add contains(blob, varchar2);
alter indextype context_v2 add contains(blob, clob);
alter indextype context_v2 add contains(bfile, varchar2);
alter indextype context_v2 add contains(bfile, clob);
alter indextype context_v2 add contains(sys.xmltype, varchar2);
alter indextype context_v2 add contains(sys.xmltype, clob);
alter indextype context_v2 add contains(sys.uritype, varchar2);
alter indextype context_v2 add contains(sys.uritype, clob);
alter indextype context_v2 drop dummyop(varchar2, varchar2);

-- Added for bug 2695369
alter indextype context using textindexmethods
  with order by score(number);
alter indextype context_v2 using textindexmethods
  with order by score(number);

REM RE-ASSOCIATE EIX OPTIMIZER IMPLEMENTATION TYPE

ASSOCIATE STATISTICS WITH INDEXTYPES ConText USING TextOptStats;
ASSOCIATE STATISTICS WITH INDEXTYPES ConText_V2 USING TextOptStats 
  WITH SYSTEM MANAGED STORAGE TABLES;
ASSOCIATE STATISTICS WITH PACKAGES ctx_contains USING TextOptStats;

REM
REM END DOWN-GRADING CONTEXT INDEXTYPE
REM

delete from dr$object_attribute
where oat_id = 70116 and oat_cla_id = 7 and oat_att_id = 16
and oat_name = 'WILDCARD_INDEX';

delete from dr$object_attribute
where oat_id = 70117 and oat_cla_id = 7 and oat_att_id = 17
and oat_name = 'WILDCARD_INDEX_K';

delete from dr$object_attribute
where oat_id = 90156 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'KG_TABLE_CLAUSE';

delete from dr$object_attribute
where oat_id = 90158 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'KG_INDEX_CLAUSE';

-- delete STAGE_ITAB_AUTO_OPT
delete from dr$object_attribute
where oat_id = 90157 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'STAGE_ITAB_AUTO_OPT';

delete from dr$object_attribute
where oat_id = 90159 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'D_INDEX_CLAUSE';

delete from dr$object_attribute
where oat_id = 90160 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'N_INDEX_CLAUSE';

delete from dr$object_attribute
where oat_id = 90161 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'K_INDEX_CLAUSE';

delete from dr$object_attribute
where oat_id = 90162 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'U_INDEX_CLAUSE';

delete from dr$object_attribute
where oat_id = 90163 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'KD_INDEX_CLAUSE';

delete from dr$object_attribute
where oat_id = 90164 and oat_cla_id = 9 and oat_att_id = 1
and oat_name = 'KR_INDEX_CLAUSE';

--change back to old stage_itab_max_rows default (100K -> 1M)
update dr$object_attribute
  set oat_default = 1000000
  where oat_id = 90128 and oat_cla_id = 9 and oat_obj_id = 1 and
        oat_att_id = 28 and oat_name = 'STAGE_ITAB_MAX_ROWS';

commit;

REM ========================================================
REM  Alter dr$index, ctx_indexes, ctx_user_indexes
REM  Drop column idx_auto_opt_type, idx_auto_opt_interval
REM ========================================================

SET SERVEROUTPUT ON

DECLARE
  errnum number;
BEGIN
  execute immediate('
    alter table dr$index drop (idx_auto_opt_type,
                               idx_auto_opt_interval,
                               idx_auto_opt_para_degree)');
EXCEPTION
  when others then
    errnum := SQLCODE;
    if (errnum = -00904) then
      null;
    else
      raise;
    end if;
END;
/

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
;

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
;

REM ==========================================================================
REM  alter dr$index_partition, ctx_index_partitions, ctx_user_index_partitions
REM  drop column ixp_auto_opt_type, ixp_auto_opt_interval
REM ==========================================================================
DECLARE
  errnum number;
BEGIN
  execute immediate('
    alter table dr$index_partition
     drop (ixp_auto_opt_type, ixp_auto_opt_interval,
           ixp_auto_opt_para_degree)');
EXCEPTION
  when others then
    errnum := SQLCODE;
    if (errnum = -00904) then
      null;
    else
      raise;
    end if;
END;
/

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
 from dr$index_partition, dr$index, sys."_BASE_USER" u2,
      sys.obj$ o1, sys.obj$ o2
where idx_owner# = userenv('SCHEMAID')
  and idx_table_owner# = u2.user#
  and ixp_table_partition# = o2.obj#
  and idx_table# = o1.obj#
  and ixp_idx_id = idx_id
/

REM ========================================================================
REM Add FILE_ACCESS_ROLE
REM ========================================================================
delete from ctxsys.dr$parameter where par_name = 'FILE_ACCESS_ROLE';
insert into ctxsys.dr$parameter(par_name, par_value)
values('FILE_ACCESS_ROLE',   NULL);

--Loop over all indexes and widen token columns (Runs as sys, in CTXSYS schema)
DECLARE
     table_name VARCHAR2(128);
     event_level NUMBER;
     token_length_check NUMBER;
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
    -- Widening $I table --
   table_name := dr$temp_get_object_name(r_index_partitions.idx_owner,
                                         r_index_partitions.idx_name,
                                         r_index_partitions.idx_id,
                                         r_index_partitions.ixp_id,
                                         'I');
                                                                           
         
   dbms_output.put_line('Table Name: ' ||  table_name);                         
                                                                
   token_length_check := 0;

   execute immediate ('select count(token_text) from '||table_name||
                     ' where length(token_text) > 64 and rownum < 2')
                into token_length_check;
  
   if token_length_check > 0 then
  
   dbms_output.put_line('Index '||r_index_partitions.idx_owner||'.'
                        ||r_index_partitions.idx_name||' is unusable,' 
                        ||'as it contains longer than 64 byte tokens.'
                        ||' Please rebuild.');

   execute immediate('alter index '||r_index_partitions.idx_owner||'.'
                     ||r_index_partitions.idx_name||' UNUSABLE');
    
   --Index has been marked UNUSABLE, skip other tables
   CONTINUE;

  else 
    --Context V2 tables were widened to 255 bytes in 12.2.0.1
    if r_index_partitions.idx_type LIKE 'CONTEXT' then 
      execute immediate('alter table ' || table_name ||
                      ' modify TOKEN_TEXT VARCHAR2(64)');
    end if;
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
      
   -- Widening $P table --
   BEGIN    
    table_name := dr$temp_get_object_name(r_index_partitions.idx_owner,
                                          r_index_partitions.idx_name,
                                          r_index_partitions.idx_id,
                                          r_index_partitions.ixp_id,
                                          'P');
                                                                              
         
    dbms_output.put_line('Table Name ' || table_name);

    sys.dbms_system.read_ev(30579,event_level);       
                        
    if(bitand(event_level, 2097152) = 0) then
 
      token_length_check := 0;

      execute immediate ('select count(*) from '||table_name||' where '||
                        'length(pat_part1) > 61'||  --Checking for 61 here
                        'or length(pat_part2) > 64 and rownum < 2') 
                   into token_length_check;

      if token_length_check > 0 then

      dbms_output.put_line('Index '||r_index_partitions.idx_owner||'.'
                            ||r_index_partitions.idx_name||' is unusable,'
                            ||'as it contains longer than 64 byte tokens.'
                            ||' Please rebuild.');

      execute immediate('alter index '||r_index_partitions.idx_owner||'.'
                        ||r_index_partitions.idx_name||' UNUSABLE');

      --Index has been marked UNUSABLE, skip other tables
      CONTINUE;      
      
      else
        execute immediate(
         'alter table ' || table_name ||
         ' modify (pat_part1 VARCHAR2(61), pat_part2 VARCHAR2(64))');
      end if;

    else 

      token_length_check := 0;

      execute immediate ('select count(*) from '||
                        table_name||' where length(pat_part1) > 64 '||
                        'or length(pat_part2) > 64 and rownum < 2')
                   into token_length_check;

      if token_length_check > 0 then

        dbms_output.put_line('Index '||r_index_partitions.idx_owner||'.'
                              ||r_index_partitions.idx_name||' is unusable,'
                              ||'as it contains longer than 64 byte tokens.'
                              ||' Please rebuild.');

        execute immediate('alter index '||r_index_partitions.idx_owner||'.'
                          ||r_index_partitions.idx_name||' UNUSABLE');

        --Index has been marked UNUSABLE, skip other tables
        CONTINUE;

      else
        execute immediate(
         'alter table ' || table_name ||
         ' modify (pat_part1 VARCHAR2(64), pat_part2 VARCHAR2(64))');
      end if;
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
                                                         
    token_length_check := 0;

    execute immediate ('select count(*) from '
                      ||table_name||' where length(token_text) > 64 '||
                      ' and rownum < 2')
                 into token_length_check;

    if token_length_check > 0 then

    dbms_output.put_line('Index '||r_index_partitions.idx_owner||'.'
                         ||r_index_partitions.idx_name||' is unusable,'
                         ||'as it contains longer than 64 byte tokens.'
                         ||' Please rebuild.');

    execute immediate('alter index '||r_index_partitions.idx_owner||'.'
                      ||r_index_partitions.idx_name||' UNUSABLE');

    --Index has been marked UNUSABLE, skip other tables
    CONTINUE;

    else 
      --Context V2 tables were widened to 255 bytes in 12.2.0.1
      if r_index_partitions.idx_type LIKE 'CONTEXT' then 
        execute immediate('alter table ' || table_name ||
                          ' modify TOKEN_TEXT VARCHAR2(64)');
      end if;
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
--------------END TEMP FUNCTIONS FOR DOWNGRADE-------------------

-- Widen columns that hold tokens to 255 bytes

UPDATE dr$index SET idx_opt_token = substr(idx_opt_token,1,64);
ALTER TABLE dr$index MODIFY idx_opt_token varchar2(64);

UPDATE dr$index_partition SET ixp_opt_token = substr(ixp_opt_token,1,64);
ALTER TABLE dr$index_partition MODIFY ixp_opt_token varchar2(64);

UPDATE dr$freqtoks SET fqt_token = substr(fqt_token,1,64);
ALTER TABLE dr$freqtoks MODIFY fqt_token varchar2(64);

--Used to be 80, reverting to that length
UPDATE dr$stopword SET spw_word = substr(spw_word,1,80);
ALTER TABLE dr$stopword MODIFY spw_word varchar2(80);

--Dropping all the temp functions created above
drop function dr$temp_get_object_name;
drop function dr$temp_get_object_prefix;
drop function dr$temp_make_pfx;
drop function dr$temp_max_name_length;
drop function dr$temp_GetIndexRec;
drop function dr$temp_IndexHasFullLengthObj;
drop function dr$temp_ChkIndexOption;
drop procedure dr$temp_parse_object_name;
drop function dr$temp_enquote_parts;
drop package temp_utl_pkg;

REM ========================================================================
REM SYS changes
REM ========================================================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;

revoke select on SYS.DBA_TAB_SUBPARTITIONS from ctxsys;

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

@?/rdbms/admin/sqlsessend.sql
 


