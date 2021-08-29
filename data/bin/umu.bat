Rem    risgupta    03/26/18 - Bug 27637921 - Update classpath to support SEPS
Rem    risgupta    09/28/17 - Bug 26734447 - Remove hardcoded reference

@echo off
SET OJDBC=ojdbc8.jar

"C:\WINDOWS.X64_193000_db_home\jdk\jre\\bin\java" -DORACLE_HOME="C:\WINDOWS.X64_193000_db_home" -classpath "C:\WINDOWS.X64_193000_db_home\jdk\jre\\lib\rt.jar;C:\WINDOWS.X64_193000_db_home\jdk\jre\\lib\i18n.jar;C:\WINDOWS.X64_193000_db_home\jdk\jre\\lib\jsse.jar;C:\WINDOWS.X64_193000_db_home\jdbc\lib\%OJDBC%;C:\WINDOWS.X64_193000_db_home\jlib\verifier8.jar;C:\WINDOWS.X64_193000_db_home\jlib\jssl-1_1.jar;C:\WINDOWS.X64_193000_db_home\jlib\ldapjclnt19.jar;C:\WINDOWS.X64_193000_db_home\jlib\oraclepki.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_core.jar;C:\WINDOWS.X64_193000_db_home\rdbms\jlib\usermigrate-1_0.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_cert.jar" oracle.security.rdbms.server.UserMigrate.umu.UserMigrate %*


