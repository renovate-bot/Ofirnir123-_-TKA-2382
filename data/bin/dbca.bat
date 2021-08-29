@echo off

rem Jar file classpath changes should be made in this file as well as classes/manifestDbca

setlocal

@set OH=C:\WINDOWS.X64_193000_db_home
@set EWT_CLASSPATH=%OH%\jlib\ewt3.jar;%OH%\jlib\ewtcompat-3_3_15.jar
@set BALISHARE_CLASSPATH=%OH%\jlib\share.jar
@set ICE_BROWSER_CLASSPATH=%OH%\jlib\oracle_ice.jar
@set HELP_CLASSPATH=%OH%\jlib\help4.jar;%OH%\jlib\jewt4.jar
@set KODIAK_CLASSPATH=%OH%\jlib\kodiak.jar
@set XMLPARSER_CLASSPATH=%OH%\lib\xmlparserv2.jar
@set GDK_CLASSPATH=%OH%\jlib\orai18n.jar
@set JDBC_CLASSPATH=%OH%\jdbc\lib\ojdbc8.jar
@set NETCFG_CLASSPATH=%OH%\jlib\ldapjclnt19.jar;%OH%\jlib\%cs_netAPIName%;%OH%\jlib\ojmisc.jar;%OH%\jlib\oraclepki.jar;%OH%\jlib\opm.jar
@set SRVM_CLASSPATH=%OH%\jlib\srvm.jar;%OH%\jlib\srvmhas.jar;%OH%\jlib\srvmasm.jar;%OH%\jlib\cvu.jar
@set ASSISTANTS_COMMON_CLASSPATH=%OH%\assistants\jlib\assistantsCommon.jar;%OH%\assistants\jlib\asstcommonext.jar
@set DBCA_CLASSPATH=%OH%\assistants\dbca\jlib\dbca.jar;%OH%\assistants\dbca\jlib\dbcaext.jar
@set HELPJAR_CLASSPATH=%OH%\assistants\dbca\doc\dbcahelp.jar;%OH%\assistants\dbca\doc\dbcahelp_es.jar;%OH%\assistants\dbca\doc\dbcahelp_de.jar;%OH%\assistants\dbca\doc\dbcahelp_fr.jar;%OH%\assistants\dbca\doc\dbcahelp_it.jar;%OH%\assistants\dbca\doc\dbcahelp_ko.jar;%OH%\assistants\dbca\doc\dbcahelp_pt_BR.jar;%OH%\assistants\dbca\doc\dbcahelp_zh_CN.jar;%OH%\assistants\dbca\doc\dbcahelp_zh_TW.jar
@set INSTALLER_CLASSPATH=%OH%\oui\jlib\OraInstaller.jar;%OH%\oui\jlib\OraCheckPoint.jar;%OH%\oui\jlib\ssh.jar;%OH%\oui\jlib\jsch.jar
@set DVCA_CLASSPATH=%OH%\dv\jlib\dvca.jar
@set COMMONS_COMPRESS_PATH=%OH%\jlib\commons-compress-1.18.jar

@set CLASSPATH=%DBCA_CLASSPATH%;%ORACLE_OEM_CLASSPATH%

@set PATH=%OH%\bin;%PATH%

@set TWO_TASK=
@set LOCAL=

@set USE_CUSTOM_JRE=false
@set CUSTOM_JRE=

:LOOP
@if x%1==x GOTO CONTINUE

@set ARG=%1

@if %USE_CUSTOM_JRE%==true (
    @set CUSTOM_JRE=%ARG%
    @goto CONTINUE
)
@if %ARG%==-jreLoc set USE_CUSTOM_JRE=true

@shift
@goto LOOP
:CONTINUE

if [%CUSTOM_JRE%]==[] (
    "C:\WINDOWS.X64_193000_db_home\jdk\jre\BIN\JAVA" -DORACLE_HOME="%OH%" -DCV_HOME="%OH%" -Doracle.installer.not_bootstrap=true -DJDBC_PROTOCOL=thin -mx512m  -XX:-OmitStackTraceInFastThrow -XX:CompileCommand=quiet -XX:CompileCommand=exclude,javax/swing/text/GlyphView,getBreakSpot oracle.assistants.dbca.driver.DBConfigurator  %*
) else (
    "%CUSTOM_JRE%\BIN\JAVA" -DORACLE_HOME="%OH%" -DCV_HOME="%OH%" -Doracle.installer.not_bootstrap=true -DJDBC_PROTOCOL=thin -mx512m -XX:-OmitStackTraceInFastThrow -XX:CompileCommand=quiet -XX:CompileCommand=exclude,javax/swing/text/GlyphView,getBreakSpot oracle.assistants.dbca.driver.DBConfigurator  %*
)

exit /B %ERRORLEVEL%
