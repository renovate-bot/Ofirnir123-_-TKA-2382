@echo off
cd C:\WINDOWS.X64_193000_db_home\bin
set PATH=C:\WINDOWS.X64_193000_db_home\bin;%PATH%
call C:\Windows\system32\regsvr32.exe /s %1
exit /B %ERRORLEVEL%
