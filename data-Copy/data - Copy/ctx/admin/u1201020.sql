Rem
Rem $Header: ctx_src_2/src/dr/admin/u1201020.sql /main/13 2018/07/25 13:49:08 surman Exp $
Rem
Rem u1201020.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      u1201020.sql - Upgrade to 12.1.0.2.0
Rem
Rem    DESCRIPTION
Rem      Upgrade from 12.1.0.1 to 12.1.0.2
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1201020.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/u1201020.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    nspancha    04/07/16 - 22267587: Removing unrequired CTXSYS. qualifier
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    zliu        02/19/14 - add json, bson enable for 12.1.0.2
Rem    rkadwe      01/23/14 - JSON Default section group
Rem    boxia       11/26/13 - Rm Btree backed SDATA changes
Rem    boxia       11/04/13 - Bug 17635127: Added PJ&SJ attributes
Rem    rkadwe      04/18/13 - Btree backed SDATA
Rem    shuroy      07/19/13 - Bug 16979188: Added REVERSE_INDEX attribute
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    ssethuma    01/14/13 - Upgrade to 12.1.0.2
Rem    ssethuma    01/14/13 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Adding REVERSE_INDEX attribute for WORDLIST preference

begin

insert into dr$object_attribute values
  (70114, 7, 1, 14,
   'REVERSE_INDEX', 'Reverse Index for Left Truncated Queries',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');

commit;
exception
when dup_val_on_index then
  null;
end;
/

----------------------------------------------------------------------
-- Printjoins & Skipjoins for JAPANESE_VGRAM_LEXER 
----------------------------------------------------------------------
begin
insert into dr$object_attribute values
  (60202, 6, 2, 2,
   'PRINTJOINS', 'Characters which join words together',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (60203, 6, 2, 3,
   'SKIPJOINS', 'Non-printing join characters',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

commit;
exception
when dup_val_on_index then
  null;
end;
/

----------------------------------------------------------------------
-- JSON_ENABLE support
-- for JSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50817
-- 17 is defined in drnp.h, 50817 is referenced in drisgp.pkb
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50817, 5, 8, 17,
   'JSON_ENABLE', 'json aware path section group',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/

----------------------------------------------------------------------
-- BSON_ENABLE support
-- for BSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50819
-- 19 is defined in drn.c, 50819 is referenced in drisgp.pkb
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (50819, 5, 8, 19,
   'BSON_ENABLE', 'bson aware path section group',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
    commit;
EXCEPTION
  when dup_val_on_index then
    null;
  when others then
    raise;
END;
/



-- JSON default section group
exec dr$temp_cresg('JSON_SECTION_GROUP', 'PATH_SECTION_GROUP');
exec dr$temp_setsecgrpatt('JSON_SECTION_GROUP', 'JSON_ENABLE', '1');

-- XML default section group
exec dr$temp_cresg('XQFT_SEC_GROUP', 'PATH_SECTION_GROUP');
exec dr$temp_setsecgrpatt('XQFT_SEC_GROUP', 'XML_ENABLE', '1');

@?/rdbms/admin/sqlsessend.sql
