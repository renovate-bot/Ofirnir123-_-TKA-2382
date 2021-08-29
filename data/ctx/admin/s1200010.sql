Rem
Rem $Header: ctx_src_2/src/dr/admin/s1200010.sql /main/6 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1200010.sql
Rem
Rem Copyright (c) 2012, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1200010.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      SYS changes for CTXSYS upgrade from 12R1 
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1200010.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/s1200010.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    ssethuma    07/12/12 - Bug 13861939: Support drop user cascade
Rem    yiqi        06/08/12 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM ========================================================================
REM Bug 13861939: Support DROP USER CASCADE
REM ========================================================================
DELETE FROM sys.duc$
  WHERE owner = 'CTXSYS'
    AND pack = 'CTX_ADM'
    AND proc = 'DROP_USER_OBJECTS'
    AND operation# = 1;

INSERT INTO sys.duc$ (owner, pack, proc, operation#, seq, com)
  VALUES ('CTXSYS', 'CTX_ADM', 'DROP_USER_OBJECTS', 1, 1,
          'Drops any Text objects for this user');

COMMIT;

@?/rdbms/admin/sqlsessend.sql
