@echo off

SET JRE_HOME=C:\WINDOWS.X64_193000_db_home\jdk\jre\
SET JLIBDIR=C:\WINDOWS.X64_193000_db_home\rdbms\jlib
SET LIBDIR=C:\WINDOWS.X64_193000_db_home\jdbc\lib
SET OJDBC=ojdbc8.jar

%JRE_HOME%\bin\java -classpath %JLIBDIR%\extusrupgrade.jar;%LIBDIR%\%OJDBC%;C:\WINDOWS.X64_193000_db_home\jlib\oraclepki.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_cert.jar;C:\WINDOWS.X64_193000_db_home\jlib\osdt_core.jar oracle.security.rdbms.server.ExtUsrUpgrade.upgrade.ExtUsrUpgrade %*
