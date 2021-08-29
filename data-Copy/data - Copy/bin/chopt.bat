@echo off
REM     NAME
REM       chopt
REM 
REM     DESCRIPTION 
REM       invoke ORACLE_HOME\bin\chopt.pl to enable/disable DB options
REM 
set OHOME=C:\WINDOWS.X64_193000_db_home
SETLOCAL
set PERL5LIB=%OHOME%\perl\lib;%PERL5LIB%
%OHOME%\perl\bin\perl %OHOME%\bin\chopt.pl %*
ENDLOCAL
