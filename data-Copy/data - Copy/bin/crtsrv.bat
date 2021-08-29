@echo off
if "%1" == "" goto usage
ORADIM -NEW -SID %1 -INTPWD oracle
CREATDEP /s OracleService%1 /d OracleCMService9i
goto done
:usage
echo Usage: crtsrv [sid]  
:done
