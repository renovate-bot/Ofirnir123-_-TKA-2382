@echo off
setlocal

Rem Utility for configuring the raw device.

Rem Gather command-line arguments.
:arg
set USER_ARGS=
:loop
if (%1)==() goto parsed
 set USER_ARGS=%USER_ARGS% %1
 shift
goto loop
:parsed

Rem SRVM TRACING
if not (%SRVM_TRACE%)==() (
  if /I '%SRVM_TRACE%' == 'false' (
    set SRVM_PROPERTY_DEFS=%SRVM_PROPERTY_DEFS% -DTRACING.ENABLED=false
  ) else (
    if not '%SRVM_TRACE_LEVEL%' == '' (
      set SRVM_PROPERTY_DEFS=%SRVM_PROPERTY_DEFS% -DTRACING.ENABLED=true -DTRACING.LEVEL=%SRVM_TRACE_LEVEL%
    ) else (
      set SRVM_PROPERTY_DEFS=%SRVM_PROPERTY_DEFS% -DTRACING.ENABLED=true -DTRACING.LEVEL=2
    )
  )
)

Rem SRVCONFIG TRACEFILE
if not (%SRVM_SRVCONFIG_TRACEFILE%)==() (
   set SRVM_PROPERTY_DEFS=%SRVM_PROPERTY_DEFS% -Dsrvm.srvconfig.tracefile=%SRVM_SRVCONFIG_TRACEFILE%
) 

Rem External variables set by the Installer
set JREDIR=C:\WINDOWS.X64_193000_db_home\jdk\jre\
set JRE="%JREDIR%\bin\java"
set JREJAR=%JREDIR%\lib\rt.jar


set PATH=C:\WINDOWS.X64_193000_db_home\bin;%PATH%

set CLASSPATH="C:\WINDOWS.X64_193000_db_home\jlib\srvm.jar;C:\WINDOWS.X64_193000_db_home\jlib\srvmhas.jar;%JREJAR%"

set CMD=%JRE% -classpath %CLASSPATH% %SRVM_PROPERTY_DEFS% oracle.ops.mgmt.rawdevice.RawDeviceUtil %USER_ARGS%

Rem Show the complete command.

Rem Execute the command now.
%CMD%
endlocal
