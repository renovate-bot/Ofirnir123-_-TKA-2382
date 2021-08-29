@echo off
REM #
REM # Copyright (c) 2007 Oracle Corporation. All rights reserved.
REM #
REM # PRODUCT
REM #    EMDW - Enterprise Manager Control script   
REM #
REM # FILENAME
REM #    emdwgrd.bat
REM #
REM # DESCRIPTION
REM #     Script that saves and restores dbControl information if the database 
REM #     was downgraded.  Run this script prior to upgrade to save DB Control 
REM #     information.  After downgrading the database run this script again to 
REM #     restore the DB Control information.
REM #
REM MODIFIED   (MM/DD/YY)
REM    idai       06/02/08 - fix bug 7131048: remove 10g home version check
REM    sadattaw   12/10/07 - forward merging fixes for NT
REM    rpattabh   05/17/07 - bug 6058689: emdwgrd fails from $OH/bin dir
REM    rpattabh   04/26/07 - Created
REM

setlocal

REM if exist %ORACLE_HOME%\bin\emdwgrd.pl goto emdwgrdFailed
REM goto contEmdwgrd1

REM :contEmdwgrd1

if not exist %ORACLE_HOME%\bin\sqlplus.exe goto emdwgrdFailed
goto contEmdwgrd2

:contEmdwgrd2

REM windows adds . to path by default cd out of $ORACLE_HOME/bin
cd %ORACLE_HOME%

REM No more overriding of EMDROOT through the environment - see bug 3217672
REM Instead, allow overriding through REMOTE_EMDROOT variable for state only
REM installs
if not defined REMOTE_EMDROOT (set EMDROOT=%ORACLE_HOME%)
if defined REMOTE_EMDROOT (set ORACLE_HOME=%REMOTE_EMDROOT%)
if defined REMOTE_EMDROOT (set EMDROOT=%ORACLE_HOME%)

REM # Set common environment settings
call %EMDROOT%\bin\commonenv

REM Make sure certain environment variables are set
set PERL_BIN=%ORACLE_HOME%\%EMPERLOHBIN%
set PERL_HOME=%ORACLE_HOME%\perl
set JAVA_HOME=%ORACLE_HOME%\jdk

set PERL5LIB=%ORACLE_HOME%\%EMPERLOHBIN%;%ORACLE_HOME%\perl\lib;%ORACLE_HOME%\perl\lib\site_perl;%ORACLE_HOME%\perl\site\lib;%EMDROOT%\sysman\admin\scripts;%EMDROOT%\sysman\admin\scripts\Net-DNS-0.48\lib;%ORACLE_HOME%\bin;%EMDROOT%\bin

set PATH=%ORACLE_HOME%\%EMPERLOHBIN%;%ORACLE_HOME%\bin;%EMDROOT%\bin;%ORACLE_HOME%\oui\lib\win32;%PATH%;%SystemRoot%;%SystemRoot%\system32

%PERL_BIN%\perl.exe %~p0\emdwgrd.pl %*
set RETVAL=%errorlevel%
goto :EOF

:emdwgrdFailed
echo Error: please ensure that ORACLE_HOME is set to the source home you upgrade from and the sqlplus utility is present in the home. 

goto :EOF

endlocal

