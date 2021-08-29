@ echo off
Rem Copyright (c) 2003, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem    olsadmintool - Shell script to run the OID enabled OLS Administration
Rem                     Tool
Rem
Rem    DESCRIPTION
Rem      Runs the OID enabled OLS Administration Tool.
Rem
Rem    risgupta    03/23/18 - Bug 27770794: Update classpath to support SEPS

Rem External Directory Variables set by the Installer
SET JRE_HOME=C:\WINDOWS.X64_193000_db_home\jdk\jre\
SET JLIBDIR=C:\WINDOWS.X64_193000_db_home\jlib

%JRE_HOME%\bin\java -classpath %JLIBDIR%\opm.jar;C:\WINDOWS.X64_193000_db_home\jlib\oraclepki.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_cert.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_core.jar oracle.security.ols.policy.policyLDAP %*
