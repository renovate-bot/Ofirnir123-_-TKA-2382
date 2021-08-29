@echo off
setlocal ENABLEDELAYEDEXPANSION

set ORE_VER=1.5.1
set R_MAJOR_VER=3
set R_MINOR_VER=3

REM check the existence of R
set "R_IN_PATH="
for %%i in (R.exe) do set "R_IN_PATH=%%~$PATH:i"

if not "%R_IN_PATH%"=="" (
  set "R_HOME="
  for /f "delims=" %%a in ('R.exe RHOME') do set "R_HOME=%%a"
)

if "%R_HOME%"=="" (
  for /f "tokens=2* delims= " %%a in (
   'REG QUERY HKLM\Software\R-Core\R64 /s ^| find "InstallPath " ^| sort') do (
    set "R_HOME=%%b"
  )
)

set "ORE_LIBS_USER=C:\WINDOWS.X64_193000_db_home\R\library"
if "%R_LIBS_USER%"=="" (
  set "R_LIBS_USER=%ORE_LIBS_USER%"
) else (
  set "R_LIBS_USER=%ORE_LIBS_USER%;%R_LIBS_USER%"
)

set "RCMD="
if not "%R_HOME%"=="" (
  set "RCMD=%R_HOME%\bin\x64\R.exe"
)

if exist "%RCMD%" (
  set "R_HOME="
  for /f "delims=" %%a in ('"%RCMD%" RHOME') do set "R_HOME=%%a"
) else (
  echo.Fail
  echo.  ERROR: R not found
  exit /b 1
)

REM verify R version meets the minimum required
set "R_CHK=as.integer(R.Version()[['major']]) > %R_MAJOR_VER%L || (as.integer(R.Version()[['major']])==%R_MAJOR_VER%L && as.integer(R.Version()[['minor']]) >= %R_MINOR_VER%L)"
for /f delims^=^]^ tokens^=2 %%a in (
 '%RCMD% --vanilla --slave -e "%R_CHK%"') do (
  set "rver_chk=%%a"
)

if "%rver_chk%" == " FALSE" (
  echo.Fail
  echo.  ERROR: ORE %ORE_VER% requires R %R_MAJOR_VER%.%R_MINOR_VER%.0 or later
  exit /b 1
)

setlocal
set R_LIBS_USER=%R_LIBS_USER%
%RCMD% %*
