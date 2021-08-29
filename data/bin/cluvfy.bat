@echo off
REM
REM WINDOWS file
REM
REM $Header: opsm/cvutl/cluvfyrac.sbs /nt/8 2012/04/04 09:31:42 xesquive Exp $
REM
REM cluvfyrac.sbs
REM
REM Copyright (c) 2004, 2012, Oracle and/or its affiliates. 
REM All rights reserved. 
REM
REM    NAME
REM      cluvfyrac.sbs 
REM
REM    DESCRIPTION
REM      This file gets copied into OH/bin as cluvfyrac.bat
REM
REM    NOTES
REM      This is a WINDOWS file
REM
REM

setlocal

REM Note: Because of the way windows sets exit status (i.e. ERRORLEVEL the
REM 'getcrshome.exe' command must be the last command within the 'if' 
REM statement. Because of this the status actually has to be in a second 
REM 'if' statement...

REM retrieving the batch file directory
@set BATDIR=%~dp0


if exist %BATDIR%\getcrshome.exe (

  %BATDIR%\getcrshome.exe>nul
  if "%ERRORLEVEL%" EQU "0" (
    REM Assign the output of the getcrshome.exe image to CRSHOME

    for /f "tokens=1* delims=#" %%a in ('%BATDIR%\bin\getcrshome.exe') do set CRSHOME=%%a
  )
)

if (%CRSHOME%)==() (
  @echo Unable to determine location of CRSHOME. Exiting...
  goto ERROR
)


CALL %CRSHOME%\bin\cluvfy %*
goto done

:ERROR
exit /B 1

:done

endlocal

