@echo off

setlocal

set OHOME=C:\WINDOWS.X64_193000_db_home
if (%OHOME%) == () (
      echo ORACLE_HOME environment variable is not set.
      echo ORACLE_HOME should be set to the main
      echo directory that contains Oracle products.
      echo Set ORACLE_HOME, then re-run.
goto end
)
set ORACLE_HOME=%OHOME%
set PATH=C:\WINDOWS.X64_193000_db_home\bin;%PATH%

:begin

Rem Gather command-line arguments.
:arg
@set USER_ARGS=
:loop
if (%1)==() goto parsed
 @set USER_ARGS=%USER_ARGS% %1
 shift
goto loop
:parsed

:runcmd

set CMD=%OHOME%/bin/oradnfs.exe %USER_ARGS% 

%CMD%

exit /b %ERRORLEVEL%

:end
endlocal
