@echo off
setlocal

:: save the current working dir in PWD variable
set PWD=%CD%
:: save the current working drive in PWDDRIVE variable
set PWDDRIVE=%CD:~0,2%
:: save the relative path of the ORACLE_HOME in OH variable
set OH=%~dp0\..
:: save the drive of the ORACLE_HOME path in OHDRIVE variable
set OHDRIVE=%OH:~0,2%
:: change the drive to the OHDRIVE to be able to change the working dir to the OH path
%OHDRIVE%
:: change the working dir to the OH path
chdir %OH%
:: save the canonical path of ORACLE_HOME in the ORACLE_HOME variable
set ORACLE_HOME=%CD%
:: change the working drive back to the original
%PWDDRIVE%
:: change the working dir back to the original
chdir %PWD%
:: unset the unnecessary variables
set PWD=
set PWDDRIVE=
set OH=
set OHDRIVE=

set PATH=C:\WINDOWS.X64_193000_db_home\bin;C:\WINDOWS.X64_193000_db_home\oui\lib\win32\;C:\WINDOWS.X64_193000_db_home\oui\lib\win64\;%PATH%
C:\WINDOWS.X64_193000_db_home\perl\bin\perl.exe -IC:\WINDOWS.X64_193000_db_home\perl\lib -IC:\WINDOWS.X64_193000_db_home\bin C:\WINDOWS.X64_193000_db_home\addnode\addnode.pl %*

endlocal
