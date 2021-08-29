Rem
Rem $Header: ctx_src_2/src/dr/admin/u1901000.sql /st_rdbms_19/1 2018/09/25 14:20:53 ccwei Exp $
Rem
Rem u1901000.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      u1901000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade from 18.1(12.2.0.2.0) to 19.1
Rem
Rem    NOTES
Rem      This file is called by ctxuXXXX.sql upgrade scripts.
Rem      Data dictionary upgrade.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/u1901000.sql
Rem    SQL_SHIPPED_FILE:ctx/admin/u1901000.sql
Rem    SQL_PHASE: UPGRADE
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ccwei       09/07/18 - XbranchMerge ccwei_network_datastore from main
Rem    ccwei       08/02/18 - add network DS upgrade info
Rem    ccwei       08/02/18 - add more directory ds upgrade info
Rem    ccwei       04/06/18 - add directory datastore upgrade
Rem    boxia       02/08/18 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql


BEGIN

insert into dr$object values
  (1, 8, 'DIRECTORY_DATASTORE', 'Documents are stored in OS files, column file name', 'N');

insert into dr$object_attribute values
  (10801, 1, 8, 1, 
   'DIRECTORY', 'directory object name to find files in operating system',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (10802, 1, 8, 2, 
   'FILENAME_CHARSET', 'Character set to which filenames will be converted',
   'N', 'N', 'Y', 'S', 
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (10803, 1, 8, 3, 
   'DIRECT_IO', 'Controls direct I/O behavior for supported platforms',
   'N', 'N', 'Y', 'B', 
   'FALSE', null, null, 'N');

insert into dr$object values
  (1, 9, 'NETWORK_DATASTORE', 'Documents are web pages, column is URL link', 'N');

insert into dr$object_attribute values
  (10904, 1, 9, 4,
   'TIMEOUT', 'Timeout in seconds',
   'N', 'N', 'Y', 'I',
   '30', 1, 3600, 'N');

insert into dr$object_attribute values
  (10905, 1, 9, 5,
   'MAXTHREADS', 'Maximum number of threads',
   'N', 'N', 'Y', 'I',
   '8', 1, 1024, 'N');

insert into dr$object_attribute values
  (10906, 1, 9, 6,
   'URLSIZE', 'Maximum size of URL buffer',
   'N', 'N', 'Y', 'I',
   '256', 32, 65535, 'N');

insert into dr$object_attribute values
  (10907, 1, 9, 7,
   'MAXURLS', 'Maximum size of URL buffer',
   'N', 'N', 'Y', 'I',
   '256', 32, 65535, 'N');

insert into dr$object_attribute values
  (10908, 1, 9, 8,
   'MAXDOCSIZE', 'Maximum amount of document to get',
   'N', 'N', 'Y', 'I',
   '2097152', 256, 2147483647, 'N');

insert into dr$object_attribute values
  (10909, 1, 9, 9,
   'HTTP_PROXY', 'HTTP proxy server to use',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (10910, 1, 9, 10,
   'FTP_PROXY', 'FTP proxy server to use',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

insert into dr$object_attribute values
  (10911, 1, 9, 11,
   'NO_PROXY', 'Do not use proxy for this domain',
   'N', 'N', 'Y', 'S',
   'NONE', null, null, 'N');

commit;
exception
when dup_val_on_index then 
  null;
END;
/


----------------------------------------------------------------------
-- SDATA: add default preferences and default section group
----------------------------------------------------------------------
BEGIN

  dr$temp_crepref('CTXSYS.NETWORK_DATASTORE','NETWORK_DATASTORE');
  dr$temp_setatt('CTXSYS.NETWORK_DATASTORE', 'TIMEOUT',         '30');
  dr$temp_setatt('CTXSYS.NETWORK_DATASTORE', 'MAXTHREADS',       '8');
  dr$temp_setatt('CTXSYS.NETWORK_DATASTORE', 'URLSIZE',        '256');
  dr$temp_setatt('CTXSYS.NETWORK_DATASTORE', 'MAXURLS',        '256');
  dr$temp_setatt('CTXSYS.NETWORK_DATASTORE', 'MAXDOCSIZE', '2097152');

END;
/
 
@?/rdbms/admin/sqlsessend.sql
