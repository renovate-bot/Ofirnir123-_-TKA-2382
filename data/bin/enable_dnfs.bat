@echo off
rem %ORACLE_HOME% must be set; if not, print error and exit.
if "%ORACLE_HOME%"=="" (
  echo Dnfs_Enable: The environment variable ORACLE_HOME is not set.
  goto end
)

IF NOT EXIST %ORACLE_HOME%\rdbms\lib\odm\NUL mkdir %ORACLE_HOME%\rdbms\lib\odm
call copy /Y %ORACLE_HOME%\bin\oranfsodm19.dll %ORACLE_HOME%\rdbms\lib\odm\oranfsodm19.dll

:end 
