Rem
Rem $Header: ctx_src_2/src/dr/admin/d1201020.sql /main/10 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1201020.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1201020.sql - Downgrade from 12.1.0.2.0 
Rem
Rem    DESCRIPTION
Rem      Downgrade from 12.1.0.2.0 to 12.1.0.1.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1201020.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1201020.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxe121.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    zliu        02/19/14 - drop json/bson enable for downgrade from 12.1.0.2 
Rem    boxia       11/26/13 - Delete btree-backed sdata part
Rem    boxia       11/05/13 - Bug 17635127: Delete optimized_for part
Rem    boxia       11/04/13 - Bug 17635127: Add file description: 
Rem                           downgrade from 12.1.0.2 to 12.1.0.1
Rem    boxia       10/24/13 - Bug 17635127: Remove PJ&SJ attribute
Rem    boxia       09/25/13 - Rm attribute OPTIMIZED_FOR
Rem    shuroy      07/19/13 - Bug 16979188: Remove REVERSE_INDEX attribute
Rem    ssethuma    01/29/13 - Downgrade to 12.1.0.2 from latest
Rem    ssethuma    01/29/13 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Remove REVERSE_INDEX option

delete from dr$object_attribute
where oat_name = 'REVERSE_INDEX';

commit;

-- Remove JSON and BSON ENABLE when downgrade from 12.1.0.2
----------------------------------------------------------------------
-- for JSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50817
-- 17 is defined in drnp.h, 50817 is referenced in drisgp.pkb
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=50817 and oat_cla_id=5 and oat_obj_id=8 and oat_att_id=17
    and oat_name='JSON_ENABLE';

----------------------------------------------------------------------
-- for BSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50819
-- 19 is defined in drnp.h, 50819 is referenced in drisgp.pkb
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=50819 and oat_cla_id=5 and oat_obj_id=8 and oat_att_id=19
    and oat_name='BSON_ENABLE';

commit;


----------------------------------------------------------------------
-- Printjoins & Skipjoins for JAPANESE_VGRAM_LEXER 
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=60202 and oat_cla_id=6 and oat_obj_id=2 and oat_att_id=2
    and oat_name='PRINTJOINS';

delete from dr$object_attribute
  where oat_id=60203 and oat_cla_id=6 and oat_obj_id=2 and oat_att_id=3
    and oat_name='SKIPJOINS';

commit;

