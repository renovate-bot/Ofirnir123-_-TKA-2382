@echo off
rem %ORACLE_HOME% must be set; if not, print error and exit.
if "%ORACLE_HOME%"=="" (
  echo Dnfs_Disable: The environment variable ORACLE_HOME is not set.
  goto end
)

if exist "%ORACLE_HOME%\rdbms\lib\odm\oranfsodm19.dll" (
  call del  %ORACLE_HOME%\rdbms\lib\odm\oranfsodm19.dll  
) 

:end 
