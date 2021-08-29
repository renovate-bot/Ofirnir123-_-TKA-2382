@echo off

rem Jar file classpath changes should be made in this file as well as classes/manifestDbua

setlocal

@set OH=C:\WINDOWS.X64_193000_db_home
@set EWT_CLASSPATH=%OH%\jlib\ewt3.jar;%OH%\jlib\ewtcompat-3_3_15.jar
@set BALISHARE_CLASSPATH=%OH%\jlib\share.jar
@set SWING_CLASSPATH=%OH%\jlib\swingall-1_1_1.jar
@set ICE_BROWSER_CLASSPATH=%OH%\jlib\oracle_ice.jar
@set HELP_CLASSPATH=%OH%\jlib\help4.jar;%OH%\jlib\jewt4.jar
@set XMLPARSER_CLASSPATH=%OH%\lib\xmlparserv2.jar
@set GDK_CLASSPATH=%OH%\jlib\orai18n.jar
@set JDBC_CLASSPATH=%OH%\jdbc\lib\ojdbc6.jar
@set NETCFG_CLASSPATH=%OH%\jlib\ldapjclnt19.jar;%OH%\jlib\%cs_netAPIName%;%OH%\jlib\oraclepki.jar
@set ORB_CLASSPATH=%OH%\lib\vbjorb.jar;%OH%\lib\vbjtools.jar;%OH%\lib\vbjapp.jar
@set SRVM_CLASSPATH=%OH%\jlib\srvm.jar;%OH%\jlib\srvmhas.jar;%OH%\jlib\srvmasm.jar;%OH%\jlib\cvu.jar
@set ASSISTANTS_COMMON_CLASSPATH=%OH%\assistants\jlib\assistantsCommon.jar
@set DBMA_CLASSPATH=%OH%\assistants\dbua\jlib\dbma.jar
@set HELPJAR_CLASSPATH=%OH%\assistants\dbua\doc\dbmahelp.jar;%OH%\assistants\dbua\doc\dbmahelp_es.jar;%OH%\assistants\dbua\doc\dbmahelp_de.jar;%OH%\assistants\dbua\doc\dbmahelp_fr.jar;%OH%\assistants\dbua\doc\dbmahelp_it.jar;%OH%\assistants\dbua\doc\dbmahelp_ko.jar;%OH%\assistants\dbua\doc\dbmahelp_pt_BR.jar;%OH%\assistants\dbua\doc\dbmahelp_zh_CN.jar;%OH%\assistants\dbua\doc\dbmahelp_zh_TW.jar
@set INSTALLER_CLASSPATH=%OH%\oui\jlib\OraInstaller.jar
@set DVCA_CLASSPATH=%OH%\dv\jlib\dvca.jar
@set PRE_UPGRADE_CLASSPATH=%OH%\rdbms\admin\preupgrade.jar

@set CLASSPATH=%OH%\assistants\dbua\jlib\dbua.jar;%OH%\assistants\jlib\asstcommonext.jar;%DBMA_CLASSPATH%;%ORACLE_OEM_CLASSPATH%;%OH%\install\jlib\instcommon.jar;%PRE_UPGRADE_CLASSPATH%
@set MAIN_CLASS=oracle.assistants.dbua.driver.StartDBUA
@set PATH=%OH%\bin;%PATH%

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
    "C:\WINDOWS.X64_193000_db_home\jdk\jre\BIN\JAVA" -Dsun.java2d.noddraw=true -DORACLE_HOME="%OH%" -Doracle.installer.not_bootstrap=true -XX:-OmitStackTraceInFastThrow -XX:CompileCommand=quiet -XX:CompileCommand=exclude,javax/swing/text/GlyphView,getBreakSpot %MAIN_CLASS% %*
) else (
    "%CUSTOM_JRE%\BIN\JAVA" -Dsun.java2d.noddraw=true -DORACLE_HOME="%OH%" -Doracle.installer.not_bootstrap=true -XX:-OmitStackTraceInFastThrow -XX:CompileCommand=quiet -XX:CompileCommand=exclude,javax/swing/text/GlyphView,getBreakSpot %MAIN_CLASS% %*
)

exit /B %ERRORLEVEL%
