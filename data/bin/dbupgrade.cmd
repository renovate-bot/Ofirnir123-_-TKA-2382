REM Header: rdbms/admin/dbupgrade.cmd bymotta_bug-19171538/10 2015/04/20 13:10:24 bymotta Exp $
REM
REM dbupgrade.cmd
REM
REM Copyright (c) 2015, 2016, Oracle and/or its affiliates. 
REM All rights reserved.
REM
REM    NAME
REM      dbupgrade.cmd -  Database Upgrade wrapper Windows batch script 
REM
REM    DESCRIPTION
REM      Windows command script program that allows to execute catctl.pl without
REM      the need to write the full path for it 
REM
REM    NOTES
REM      To execute it: dbupgrade <parameters are the same as catctl.pl>
REM
REM    MODIFIED   (MM/DD/YY)
REM    frealvar    03/10/16 - Bug 22826562 problem parsing inclusion list
REM    bymotta     02/03/16 - Fixing PERL LIB path
REM    bymotta     07/01/15 - Fix for bug 21324164 - UPGRADE:CATCTL SHOULD
REM                           SUPPORT TWO OR MORE PDBS UPGRADE TOGETHER
REM    bymotta     05/04/15 - Adding user capability to manually add
REM                           ORACLE_HOME and run it everywhere. Also as last
REM                           resort try to determine ORACLE_HOME if the script
REM                           is run from rdbms/admin -- Bug # 19171538
REM    bymotta     03/25/15 - Windows batch script for catctl.pl: name catctl.bat
REM			      -- Bug # 19171538
REM    bymotta     03/25/15 - Creation

REM Batch file to execute catctl.pl

@echo off
setlocal enableDelayedExpansion
set allargs=%*
set first_arg=%1

::
:: setting ORACLE_HOME using Oracle image if running from admin dir.
if exist orahome.exe (
	FOR /F "tokens=* delims= " %%i IN ('orahome.exe') DO ( set ORACLE_HOME=%%i)
)

::
:: If Oracle image was not found, then see if the user
:: is sending the Oracle home directory and then search 
:: the image in there and execute it and assign Oracle home
:: accordingly
::

:: Parse Args
:CATCTL_DARG

 IF not defined ORACLE_HOME (
	set "catctl_option="
	for %%a in (%*) do (
	   if not defined catctl_option (
		  set arg=%%a
		  if "!arg:~0,2!" equ "-d" set "catctl_option=!arg!"
	   ) else (

		  set "catctl_option!catctl_option!=%%a"
		  set "catctl_option="
	   )
	)
)

:: Main program.
:: Program will process -d ORACLE_HOME first as it is being sent by user.
:: If Oracle home is set it will send to catctl.pl all the parameters (if any).

:MAIN
if defined catctl_option-d (
	FOR %%i IN ("%catctl_option-d%\..\..") DO SET ORACLE_HOME=%%~fi

	echo %ORACLE_HOME%
)

IF defined ORACLE_HOME (
	%ORACLE_HOME%\perl\bin\perl.exe -I%ORACLE_HOME%\perl\lib  %ORACLE_HOME%\rdbms\admin\catctl.pl   %* %ORACLE_HOME%\rdbms\admin\catupgrd.sql
	goto :END
) else (
	echo Could not set ORACLE_HOME, please go to ORACLE_HOME\rdbms\admin or add -d ORACLE_HOME\rdbms\admin arguments.
	exit /b -1
)


:END
exit /b %ERRORLEVEL%
