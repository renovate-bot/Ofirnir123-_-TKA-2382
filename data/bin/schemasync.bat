@echo off
REM #   DIP
REM #
REM # FILENAME
REM #   schemasync.bat
REM #
REM # DESCRIPTION
REM #   This script is used to synchronize schema on NT
REM #
REM # NOTE:


set ORACLE_HOME=C:\WINDOWS.X64_193000_db_home
set JAVA_HOME=C:\WINDOWS.X64_193000_db_home\jdk

set CLASSPATH="C:\WINDOWS.X64_193000_db_home/ldap/odi/jlib/dmu.jar;C:\WINDOWS.X64_193000_db_home/jlib/ldapjclnt12.jar;C:\WINDOWS.X64_193000_db_home/ldap/odi/jlib/sync.jar"

%JAVA_HOME%\bin\java -classpath %CLASSPATH% oracle.ldap.dmu.SchemaMigrater C:\WINDOWS.X64_193000_db_home %*


