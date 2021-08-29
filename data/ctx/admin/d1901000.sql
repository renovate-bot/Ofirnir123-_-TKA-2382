Rem
Rem $Header: ctx_src_2/src/dr/admin/d1901000.sql /st_rdbms_19/1 2018/09/25 14:20:53 ccwei Exp $
Rem
Rem d1901000.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      d1901000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Downgrade from 19.1 to 18.1(12.2.0.2.0)
Rem
Rem    NOTES
Rem      This file is called by ctxeXXX.sql downgrade scripts.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1901000.sql
Rem    SQL_SHIPPED_FILE:ctx/admin/d1901000.sql
Rem    SQL_PHASE: DOWNGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ccwei       09/07/18 - XbranchMerge ccwei_network_datastore from main
Rem    ccwei       08/02/18 - Add network DS downgrade info
Rem    ccwei       08/02/18 - Add more directory DS downgrade info
Rem    ccwei       04/06/18 - Add directory datastore downgrade
Rem    boxia       02/08/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql


BEGIN

delete from dr$object
where obj_cla_id = 1 and obj_id = 8
and obj_name = 'DIRECTORY_DATASTORE'; 

delete from dr$object_attribute
where oat_id = 10801 and oat_cla_id = 1 and oat_att_id = 1
and oat_name = 'DIRECTORY';

delete from dr$object_attribute
where oat_id = 10802 and oat_cla_id = 1 and oat_att_id = 2 
and oat_name = 'FILENAME_CHARSET';

delete from dr$object_attribute
where oat_id = 10803 and oat_cla_id = 1 and oat_att_id = 3 
and oat_name = 'DIRECT_IO';

delete from dr$object
where obj_cla_id = 1 and obj_id = 9
and obj_name = 'NETWORK_DATASTORE'; 

delete from dr$object_attribute
where oat_id = 10904 and oat_cla_id = 1 and oat_att_id = 4
and oat_name = 'TIMEOUT';

delete from dr$object_attribute
where oat_id = 10905 and oat_cla_id = 1 and oat_att_id = 5
and oat_name = 'MAXTHREADS';

delete from dr$object_attribute
where oat_id = 10906 and oat_cla_id = 1 and oat_att_id = 6
and oat_name = 'URLSIZE';

delete from dr$object_attribute
where oat_id = 10907 and oat_cla_id = 1 and oat_att_id = 7
and oat_name = 'MAXURLS';

delete from dr$object_attribute
where oat_id = 10908 and oat_cla_id = 1 and oat_att_id = 8
and oat_name = 'MAXDOCSIZE';

delete from dr$object_attribute
where oat_id = 10909 and oat_cla_id = 1 and oat_att_id = 9
and oat_name = 'HTTP_PROXY';

delete from dr$object_attribute
where oat_id = 10910 and oat_cla_id = 1 and oat_att_id = 10
and oat_name = 'FTP_PROXY';

delete from dr$object_attribute
where oat_id = 10911 and oat_cla_id = 1 and oat_att_id = 11
and oat_name = 'NO_PROXY';

commit;
END;
/


@?/rdbms/admin/sqlsessend.sql

