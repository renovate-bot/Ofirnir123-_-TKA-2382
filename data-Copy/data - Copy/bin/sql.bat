@echo off
REM
REM   Copyright 2016 by Oracle Corporation,
REM   500 Oracle Parkway, Redwood Shores, California, 94065, U.S.A.
REM   All rights reserved.
REM 
REM   This software is the confidential and proprietary information
REM   of Oracle Corporation.
REM
REM   NAME    %ORACLE_HOME%\bin\sql.bat
REM
REM   DESC Wrapper for sqlcl to be called from $OH\bin
REM

pushd ../sqldeveloper/sqldeveloper/bin && sql %*
popd
