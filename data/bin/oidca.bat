@echo off

set ORACLE_HOME=C:\WINDOWS.X64_193000_db_home
set JLIB_HOME=C:\WINDOWS.X64_193000_db_home\jlib
set PATH=C:\WINDOWS.X64_193000_db_home\ldap\bin;C:\WINDOWS.X64_193000_db_home\bin;C:\WINDOWS.X64_193000_db_home\opmn\bin;%PATH%

set HELPJAR=help4.jar
set ICEJAR=oracle_ice.jar
set SHAREJAR=share.jar
set EWTJAR=ewt3.jar
set EWTCOMPAT=ewtcompat-3_3_15.jar
set NETCFGJAR=netcfg.jar
set DBUIJAR=dbui2.jar



set CLASSPATH="C:\WINDOWS.X64_193000_db_home\ldap\lib\oidca.jar;%JLIB_HOME%\ldapjclnt11.jar;%JLIB_HOME%\%NETCFGJAR%;%JLIB_HOME%\%HELPJAR%;%JLIB_HOME%\%ICEJAR%%JLIB_HOME%\%SHAREJAR%;%JLIB_HOME%\%EWTJAR%;%JLIB_HOME%\%EWTCOMPAT%;%JLIB_HOME%\swingall-1_1_1.jar;%JLIB_HOME%\%DBUIJAR%;C:\WINDOWS.X64_193000_db_home\ldap\odi\jlib\sync.jar;C:\WINDOWS.X64_193000_db_home\ldap\oidadmin\dasnls.jar;%JLIB_HOME%\ojmisc.jar;C:\WINDOWS.X64_193000_db_home\jdbc\lib\classes12.jar;C:\WINDOWS.X64_193000_db_home\assistants\jlib\assistantsCommon.jar;C:\WINDOWS.X64_193000_db_home\jlib\srvm.jar;C:\WINDOWS.X64_193000_db_home\opmn\lib\optic.jar;C:\WINDOWS.X64_193000_db_home\jlib\oraclepki.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_core.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_cert.jar"

C:\WINDOWS.X64_193000_db_home\jdk\bin\java -Xms48m -Xmx128m -Djava.security.policy=%s_java2policyFile% -DORACLE_HOME=C:\WINDOWS.X64_193000_db_home -DLDAP_ADMIN=%LDAP_ADMIN% -classpath %CLASSPATH% oracle.ldap.oidinstall.OIDClientCA orahome=C:\WINDOWS.X64_193000_db_home %*

