REM #
REM # Copyright (c) 2001 , 2005 Oracle Corporation.  All rights reserved.
REM #
REM # PRODUCT
REM #   DIP
REM #
REM # FILENAME
REM #   odisrvreg.bat
REM #
REM # DESCRIPTION
REM #   This script is used to register the DIP Server on NT
REM #
REM # NOTE:

@echo off

set ORACLE_HOME=C:\WINDOWS.X64_193000_db_home
set JAVA_HOME=C:\WINDOWS.X64_193000_db_home\jdk

set PATH=C:\WINDOWS.X64_193000_db_home\bin;%PATH%

SET CLASSPATH="C:\WINDOWS.X64_193000_db_home\jlib\oraclepki103.jar;C:\WINDOWS.X64_193000_db_home\ldap\odi\jlib\sync.jar;C:\WINDOWS.X64_193000_db_home\jlib\ldapjclnt10.jar;C:\WINDOWS.X64_193000_db_home\jlib\ojmisc.jar"

%JAVA_HOME%\bin\java -classpath %CLASSPATH% oracle.ldap.odip.engine.OdiReg C:\WINDOWS.X64_193000_db_home %*
