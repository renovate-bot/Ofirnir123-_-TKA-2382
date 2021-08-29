@echo off

REM #
REM # Copyright (c) 2001 Oracle Corporation.  All rights reserved.
REM #
REM # PRODUCT
REM #   OID Provisioning Tool
REM #
REM # FILENAME
REM #   oidprovtool.bat
REM #
REM # DESCRIPTION
REM #   This script is used to launch the provisioning tool
REM #
REM # NOTE:
REM #   This script is typically invoked as follows:
REM #
REM #

SETLOCAL

REM  Make sure that our JRE is used for this invocation.
IF Windows_NT == %OS% SET PATH=%s_JRE_LOCATION%\bin;C:\WINDOWS.X64_193000_db_home\bin;%PATH%
IF not Windows_NT == %OS% SET PATH="%s_JRE_LOCATION%\bin;C:\WINDOWS.X64_193000_db_home\bin;%PATH%"

REM Set class path
SET CLASSROOT=C:\WINDOWS.X64_193000_db_home\classes
SET LDAPJCLNT19=C:\WINDOWS.X64_193000_db_home\jlib\ldapjclnt19.jar
SET NETCFG=C:\WINDOWS.X64_193000_db_home\jlib\netcfg.jar
SET JNDIJARS=C:\WINDOWS.X64_193000_db_home\jlib\ldap.jar;C:\WINDOWS.X64_193000_db_home\jlib\jndi.jar;C:\WINDOWS.X64_193000_db_home\jlib\providerutil.jar

REM make sure ldapjclnt19.jar is present
IF NOT EXIST %LDAPJCLNT19% GOTO NO_LDAPJCLNT19JAR_FILE

SET CLASSPATHADD=%LDAPJCLNT19%;%JNDIJARS%;%CLASSROOT%;%NETCFG%;

SET JRE=jre -nojit
SET CLASSPATH_QUAL=cp

IF "%ORACLE_OEM_JAVARUNTIME%x" == "x" GOTO JRE_START
SET JRE=%ORACLE_OEM_JAVARUNTIME%\bin\java -nojit
SET CLASSPATH_QUAL=classpath
SET CLASSPATHADD=%CLASSPATHADD%;%ORACLE_OEM_JAVARUNTIME%\lib\classes.zip
SET CLASSPATHADD=%CLASSPATHADD%;C:\WINDOWS.X64_193000_db_home\jlib\javax-ssl-1_2.jar
SET CLASSPATHADD=%CLASSPATHADD%;C:\WINDOWS.X64_193000_db_home\jlib\jssl-1_2.jar
SET CLASSPATHADD=%CLASSPATHADD%;C:\WINDOWS.X64_193000_db_home\j2ee\home\jps-api.jar;C:\WINDOWS.X64_193000_db_home\j2ee\home\jps-internal.jar

:JRE_START

C:\WINDOWS.X64_193000_db_home\jdk\bin\java -Xms48m -Xmx256m -%CLASSPATH_QUAL% %CLASSPATHADD% -DORACLE_HOME=C:\WINDOWS.X64_193000_db_home  oracle.ldap.util.provisioning.ProvisioningProfile %*

GOTO THE_END

:NO_LDAPJCLNT19JAR_FILE
   ECHO Missing jar file
   ECHO %LDAPJCLNT19% not found
   GOTO THE_END

:THE_END
   ENDLOCAL
