@echo off

REM #
REM # Copyright (c) 2001, 2003 Oracle Corporation.  All rights reserved.
REM #
REM # PRODUCT
REM #   OID LDIF Migration to OID
REM #
REM # FILENAME
REM #   LDIFMigrator.bat
REM #
REM # DESCRIPTION
REM #   This script is used to launch the LIDF Migration.
REM #
REM # NOTE:
REM #
REM #   ldifmigrator -help prints usage
REM #
REM #   Note that parameters containing an '=' sign must be 
REM #   double-quoted when invoking this script, else they will 
REM #   be broken up into separate parameters at the = sign
REM #   and errors will result.
REM #

SETLOCAL

REM # Check ORACLE_HOME is defined
IF "C:\WINDOWS.X64_193000_db_homex" == "x" GOTO NO_ORACLE_HOME
SET JAVAEXE=C:\WINDOWS.X64_193000_db_home\jdk\bin\java

REM Set class path
SET LDAPJCLNT19=C:\WINDOWS.X64_193000_db_home\jlib\ldapjclnt19.jar
SET NETCFG=C:\WINDOWS.X64_193000_db_home\jlib\netcfg.jar

REM make sure ldapjclnt19.jar is present
IF NOT EXIST %LDAPJCLNT19% GOTO NO_LDAPJCLNT19JAR_FILE

SET CLASSPATH=%LDAPJCLNT19%;%NETCFG%;C:\WINDOWS.X64_193000_db_home\j2ee\home\jps-api.jar;C:\WINDOWS.X64_193000_db_home\j2ee\home\jps-internal.jar;

%JAVAEXE% -classpath %CLASSPATH% -DORACLE_HOME=C:\WINDOWS.X64_193000_db_home oracle.ldap.util.LDIFMigration %*

GOTO THE_END

:NO_LDAPJCLNT19JAR_FILE
   ECHO Missing jar file
   ECHO %LDAPJCLNT19% not found
   GOTO THE_END

:NO_ORACLE_HOME
  ECHO ORACLE_HOME is not defined

:THE_END
   ENDLOCAL
