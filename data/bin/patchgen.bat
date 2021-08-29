@echo off
rem $Header: rdbms/src/client/tools/patchgen/jsrc/patchgen.bat /main/1 2012/03/21 23:47:46 danagara Exp $
rem
rem asmcmd.bat
rem
rem Copyright (c) 2004, 2012, Oracle and/or its affiliates. 
rem All rights reserved. 
rem
rem    NAME
rem      patchgen.bat - This is a wrapper for patchgen utility.
rem
rem    DESCRIPTION
rem      Use java from oracle home and invokes patchgen.jar from oracle/jlib 
rem      with  with -jar and user provide arguments.
rem
rem    NOTES
rem
rem    MODIFIED   (MM/DD/YY)
rem    darshan     08/11/11 - Creation


rem %ORACLE_HOME% must be set; if not, print error and exit.
if "%ORACLE_HOME%"=="" (
  echo "patchgen: the environment variable ORACLE_HOME is not set."
  goto end
)

rem Construct path to java. 
set JRE=%ORACLE_HOME%\jdk\bin\java
set PERLBIN=%ORACLE_HOME%\perl\bin\perl.exe

rem echo %LD_LIBRARY_PATH%

set JARPATH=%ORACLE_HOME%\jlib\patchgen.jar

rem Now run patchgen.jar!
%JRE% -jar %JARPATH% %* -Djava.library.path=%ORACLE_HOME%\bin

set exit_code=%ERRORLEVEL% 
exit /B exit_code

:end

