Command=("C:\WINDOWS.X64_193000_db_home\jdk\jre\BIN\JAVA" -Dsun.java2d.font.DisableAlgorithmicStyles=true -DCV_HOME="C:\WINDOWS.X64_193000_db_home" -DORACLE_HOME="C:\WINDOWS.X64_193000_db_home" -Doracle.installer.not_bootstrap=true -DJDBC_PROTOCOL=thin %s_policyFile% -mx512m -classpath "C:\WINDOWS.X64_193000_db_home\assistants\dbca\jlib\dbca.jar;C:\WINDOWS.X64_193000_db_home\assistants\dbca\jlib\dbcaext.jar;%s_ohAsstJlibLocation%\assistantsCommon.jar;%s_ohAsstJlibLocation%\asstcommonext.jar;%s_ohJlibLocation%\ewt3.jar;%s_ohJlibLocation%\ewtcompat-3_3_15.jar;%s_ohJlibLocation%\share.jar;%s_ohJlibLocation%\swingall-1_1_1.jar;%s_ohJlibLocation%\oracle_ice5.jar;%s_ohJlibLocation%\jewt4.jar;%s_ohJlibLocation%\help4.jar;%s_ohJlibLocation%\kodiak.jar;C:\WINDOWS.X64_193000_db_home\lib\xmlparserv2.jar;%s_ohJlibLocation%\orai18n.jar;C:\WINDOWS.X64_193000_db_home\jlib\srvm.jar;C:\WINDOWS.X64_193000_db_home\jlib\srvmhas.jar;C:\WINDOWS.X64_193000_db_home\jlib\srvmasm.jar;%s_ohJlibLocation%\%cs_netAPIName%;C:\WINDOWS.X64_193000_db_home\jdbc\lib\ojdbc8.jar;%s_ohJlibLocation%\ojmisc.jar;%s_ohJlibLocation%\oraclepki.jar;%s_ohJlibLocation%\ldapjclnt19.jar;%s_ohJlibLocation%\opm.jar;%ORACLE_OEM_CLASSPATH%;C:\WINDOWS.X64_193000_db_home\oui\jlib\OraInstaller.jar;C:\WINDOWS.X64_193000_db_home/dv/jlib/dvca.jar;C:\WINDOWS.X64_193000_db_home\oui\jlib\ssh.jar;C:\WINDOWS.X64_193000_db_home\oui\jlib\jsch.jar;C:\WINDOWS.X64_193000_db_home\jlib\commons-compress-1.18.jar" oracle.assistants.dbca.driver.DBConfigurator)