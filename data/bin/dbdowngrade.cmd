@setlocal enableextensions enabledelayedexpansion
@echo off
rem Header: rdbms/admin/dbdowngrade.cmd frealvar_bug-24320609/1 2016/09/10 13:10:24 frealvar Exp $
rem
rem dbdowngrade.cmd
rem
rem Copyright (c) 2015, 2018, Oracle and/or its affiliates. 
rem All rights reserved.
rem
rem    NAME
rem      dbdowngrade.cmd -  Database Downgrade wrapper Windows batch script 
rem
rem    DESCRIPTION
rem      Windows command script program that allows to execute catcon.pl and catdwgrd.sql
rem      the only parameter accepted is the inclussion list with -c
rem
rem    NOTES
rem      To execute it: dbdowngrade
rem
rem    MODIFIED   (MM/DD/YY)
rem    frealvar    07/29/16 - Creation for bug 24320609

rem
rem Gathering information from environment
rem
rem bin to use in a regex check.
set BIN_DIR=bin
rem Current directory name
for %%* in (.) do set ACTUAL_DIR=%%~nx*
rem storing value of ORACLE_HOME if exists.
set OH=%ORACLE_HOME%
rem storing value of ORACLE_SID if exists.
set OS=%ORACLE_SID%
set OH_NOT_SET=Please set Oracle Home before script is run.
set OS_NOT_SET=Please set Oracle SID before script is run.
set NOMGTE_PDB=Please make sure that all the containers are open in migrate mode.
set INV_ARG=Invalid argument found.
set INV_INC_LIST=CDB$ROOT is not allowed within the inclussion list.
set DEFAULT_OH=ORACLE_HOME not defined, using orahome to set it.
rem Destination of downgrade logs
set DWN_DEST=\cfgtoollogs\downgrade
set CDB=-1
set PDBLIST=-1
set NPDBS=0
rem Value of -n
set NVAL=0

rem
rem If ORACLE_HOME is not empty, we will use it as our OH
rem else if, we try to get the OH by using orahome.exe
rem else if, we try to get the OH by deriving from current path
rem else , no OH was found, thus exiting with error.
rem
if not defined OS (
   echo %OS_NOT_SET%
   exit /B 1
)

if defined OH (
   set ORACLE_HOME=%OH%
) else (
   if /i "%ACTUAL_DIR%"=="%BIN_DIR%" (
      for /F "tokens=* delims= " %%i IN ('..\rdbms\admin\orahome.exe') do set ORACLE_HOME=%%i
      set PATH=%ORACLE_HOME%\bin;%PATH%
      echo %DEFAULT_OH%
   ) else (
      echo %OH_NOT_SET%
      exit /B 1
   )
)

rem
rem In case of inclussion list, we need to ensure cdb$root is not
rem being used and that the parameters have the following form -c "pdb1 pdbx"
rem for unplug&plug scenarios
rem
set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
)

if not "%argCount%" == "0" (
   rem yes, thus we expect 2, -c, a string
   set error=false
   set incl=%1
   if not "!incl!" == "-c" (
     set error=true
   )
   if "!argCount!" == "1" (
     set error=true
   )
   if "!error!" == "true" (
      echo %INV_ARG%
      exit /B 1
   )
   set mytmp1=%~2
   set mytmp2=!mytmp1:cdb$root=!
   rem the second must be a list of pdbs space separated
   rem where cdb$root is not allowed
   if not "!mytmp1!" == "!mytmp2!" (
      echo %INV_INC_LIST%
      exit /B 1
   )
   set PDBLIST=!mytmp2!
)

rem
rem the logs will be send to
rem 1-orabasehome as first choice
rem 2-orabase as second option
rem 3-oracle_home if non of the above worked out
rem
rem file exists?
if exist %ORACLE_HOME%/bin/orabasehome.exe (
   rem first choice
   for /f %%i IN ('%ORACLE_HOME%/bin/orabasehome.exe') do set TMPPATH=%%i
) else (
   rem file exists?
   if exist %ORACLE_HOME%/bin/orabase.exe (
      rem second choice
      for /f %%i IN ('%ORACLE_HOME%/bin/orabase.exe') do set TMPPATH=%%i
   ) else (
      rem last option, using temp directory
      set TMPPATH=%TEMP%\downgrade%RANDOM%
      mkdir !TMPPATH!
   )
)
set DWN_DEST=!TMPPATH!!DWN_DEST!

rem
rem To continue with the same approach, lets use cfgtoollogs
rem
if not exist "!DWN_DEST!" (
   mkdir !DWN_DEST!
)

rem
rem Gathering information from database
rem
@echo SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF SERVEROUTPUT ON  > %DWN_DEST%\f.sql
@echo VAR CDB VARCHAR2^(10^)^;                                                    >> %DWN_DEST%\f.sql
@echo BEGIN                                                                       >> %DWN_DEST%\f.sql
@echo    BEGIN                                                                    >> %DWN_DEST%\f.sql
@echo       EXECUTE IMMEDIATE ^'SELECT CDB FROM V$DATABASE^' INTO ^:CDB^;         >> %DWN_DEST%\f.sql
@echo    EXCEPTION WHEN OTHERS THEN                                               >> %DWN_DEST%\f.sql
@echo       IF SQLCODE IN ^( -904 ^) THEN                                         >> %DWN_DEST%\f.sql
@echo          ^:CDB^:=^'NO^'^;                                                   >> %DWN_DEST%\f.sql
@echo       END IF^;                                                              >> %DWN_DEST%\f.sql
@echo    END^;                                                                    >> %DWN_DEST%\f.sql
@echo END^;                                                                       >> %DWN_DEST%\f.sql
@echo /                                                                           >> %DWN_DEST%\f.sql
@echo SELECT ^:CDB FROM DUAL^;                                                    >> %DWN_DEST%\f.sql
@echo exit                                                                        >> %DWN_DEST%\f.sql
for /f %%i IN ('sqlplus -silent / as sysdba @%DWN_DEST%\f.sql') do set CDB=%%i
del %DWN_DEST%\f.sql

rem
rem Calculate number of pdbs and the -n
rem if this is a cdb and it will be downgraded the whole cdb
rem    get the number of container in migrate mode (no need to worries about
rem    containers in wrong state, they are catched up later)
rem if this is a cdb and we have an inclussion list
rem    count how many containers will be downgraded
rem get the cpu_count/2 value, if it is 0, 1 will be used
rem once we have NPDBS and cpu_count/2 calculate the value of -n
rem there are two cases
rem #pdbs <= cpu_count / 2, then set -n to #pdbs
rem #pdbs > cpu_count / 2, then set -n cpu_count/2
rem 
if "!CDB!"=="YES" (
   if "!PDBLIST!" == "-1" (
      @echo SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF                 > %DWN_DEST%\f.sql
      @echo SELECT COUNT^(*^) FROM V$CONTAINERS WHERE UPPER^(OPEN_MODE^)=^'MIGRATE^'^; >> %DWN_DEST%\f.sql
      @echo EXIT^;                                                                     >> %DWN_DEST%\f.sql
      for /f %%i IN ('sqlplus -silent / as sysdba @%DWN_DEST%\f.sql') do set NPDBS=%%i
      del %DWN_DEST%\f.sql
   ) else (
      set string="!PDBLIST: =|!"
      :again
      set "oldstring=!string!"
      set "string=!string:*|=!"
      set /a NPDBS+=1
      if not "!string!" == "!oldstring!" goto :again
   )
   rem Gathering information to calculate the n param
   @echo SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF       > %DWN_DEST%\f.sql
   @echo SELECT ^(CASE WHEN ^(VALUE/2^) = 0 THEN 1 ELSE ^(VALUE/2^) END^) >> %DWN_DEST%\f.sql
   @echo FROM V$PARAMETER WHERE UPPER^(NAME^)=^'CPU_COUNT^'^;             >> %DWN_DEST%\f.sql
   @echo EXIT^;                                                           >> %DWN_DEST%\f.sql
   for /f %%i IN ('sqlplus -silent / as sysdba @%DWN_DEST%\f.sql') do set CPUCOUNT_DIV_2=%%i
   del %DWN_DEST%\f.sql
   rem two cases
   rem NPDBS <= CPUCOUNT_DIV_2, -n NPDBS
   if !NPDBS! LEQ !CPUCOUNT_DIV_2! (
      set NVAL=!NPDBS!
   )
   rem NPDBS > CPUCOUNT_DIV_2, -n CPUCOUNT_DIV_2
   if !NPDBS! GTR !CPUCOUNT_DIV_2! (
      set NVAL=!CPUCOUNT_DIV_2!
   )
)

rem
rem If the database is cdb we will verify that all the containers
rem are in migrate mode, otherwise, error out
rem
if "!PDBLIST!" == "-1" (
   if "!CDB!"=="YES" (
      @echo SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF SERVEROUTPUT ON  > %DWN_DEST%\r.sql
      @echo SELECT COUNT^(*^) AS NM FROM V$CONTAINERS WHERE OPEN_MODE ^<^> ^'MIGRATE^'; >> %DWN_DEST%\r.sql
      @echo exit                                                                        >> %DWN_DEST%\r.sql
      for /f %%i IN ('sqlplus -silent / as sysdba @%DWN_DEST%\r.sql') do set PDBSNM=%%i
      del %DWN_DEST%\r.sql
   
      rem check containers not in migrate mode
      if not "!PDBSNM!" == "0" (
         echo %NOMGTE_PDB%
         exit /B 1
      )
   )
)

rem
rem issue the downgrade command according to the scenario
rem
if "!CDB!" == "NO" (
   echo Downgrading noncdb
   @echo SPOOL %DWN_DEST%\catdwgrd.log          
   @echo SPOOL %DWN_DEST%\catdwgrd.log           > %DWN_DEST%\f.sql
   @echo SET PAGESIZE 0 LINESIZE 180            >> %DWN_DEST%\f.sql
   @echo @?/rdbms/admin/catdwgrd.sql            >> %DWN_DEST%\f.sql
   @echo SPOOL OFF                              >> %DWN_DEST%\f.sql
   @echo EXIT;                                  >> %DWN_DEST%\f.sql
   for /f %%i IN ('sqlplus / as sysdba @%DWN_DEST%\f.sql') do set PI=3.14
   del %DWN_DEST%\f.sql
) else (
   echo Downgrading containers
   rem unplug&plug downgrade?
   if "!PDBLIST!" == "-1" (
      rem no, run on everything and with -r
      %ORACLE_HOME%\perl\bin\perl -I%ORACLE_HOME%\perl\lib %ORACLE_HOME%\rdbms\admin\catcon.pl -d %ORACLE_HOME%\rdbms\admin -b catdwgrd -l %DWN_DEST% -n !NVAL! -r catdwgrd.sql
   ) else (
      rem yes, run on inclusion list without -r
      %ORACLE_HOME%\perl\bin\perl -I%ORACLE_HOME%\perl\lib %ORACLE_HOME%\rdbms\admin\catcon.pl -d %ORACLE_HOME%\rdbms\admin -b catdwgrd -l %DWN_DEST% -n !NVAL! -c "!PDBLIST!" catdwgrd.sql
   )
)

exit /B %ERRORLEVEL%
