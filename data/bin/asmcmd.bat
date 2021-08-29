@echo off
rem $Header: rdbms/src/client/tools/asmcmd/asmcmd.bat /main__nt/11 2017/06/05 09:32:32 diguzman Exp $
rem
rem asmcmd.bat
rem
rem Copyright (c) 2004, 2017, Oracle and/or its affiliates. 
rem All rights reserved.
rem
rem    NAME
rem      asmcmd.bat - ASM CoMmanD line interface (Wrapper)
rem
rem    DESCRIPTION
rem
rem      This program is a wrapper for asmcmdcore.  It takes the same
rem      parameters as asmcmdcore.  It first checks to see if %ORACLE_HOME% is
rem      set.  If not, it tries to set it based on the path to this script.  If
rem      %ORACLE_HOME% cannot be set anyway, it prints an error message and
rem      exits.  It then invokes asmcmdcore at %ORACLE_HOME%/bin/asmcmdcore
rem      with the Perl interpreter at %ORACLE_HOME%/perl/<version>/bin/perl.
rem
rem    NOTES
rem      usage: asmcmd [-p] [command]
rem
rem      This wrapper program now supports only Windows platforms.  Use 
rem      the asmcmd Bourne Shell script for UNIX platforms.
rem
rem    MODIFIED   (MM/DD/YY)
rem    diguzman   05/23/17 - rti20036195:get ORACLE_HOME from script's location
rem    diguzman   11/09/16 - 24741167: update ASMCMD-00001 error message
rem    pvenkatr   11/20/12 - Adding $OH\PERL\LIB, $OH\PERL\SITE\lib to -I to
rem                          avoid 5.10.x & 5.14.x conflict issues.
rem    shmubeen   04/27/10 - remove -T option
rem    heyuen     02/03/09 - support perl 5.10
rem    heyuen     07/08/08 - add $ORACLE_HOME\bin to @INC
rem    hqian      03/27/06 - #4939032: use perl -I, use perl -T; include 
rem                          oracle/lib 
rem    hqian      01/17/06 - #4945583: merge in Win64 changes, including IA64 
rem    hqian      10/28/05 - Support 64-bit Perl on Win64 
rem    hqian      12/27/04 - hqian_bug-4027167_nt
rem    hqian      12/10/04 - Creation: wrapper batch file for ASMCMD on NT.

if "%ORACLE_HOME%"=="" (
  set ASMCMDDIR=%~dp0
  set ORACLE_HOME=%ASMCMDDIR:\bin\=%
  set ASMCMDDIR=
)

rem %ORACLE_HOME% must be set; if not, print error and exit.
%ORACLE_HOME%\bin\sqlplus -v 1> NUL 2> NUL
if %errorlevel% neq 0 (
  echo ASMCMD-00001: ORACLE_HOME environment variable not set
  goto end
)

rem Construct path to Perl. Assume version 5.10 first
set PERLBIN=%ORACLE_HOME%\perl\bin\perl.exe

rem If no, default to 5.8.3
rem Construct path to Perl.  Assume version 5.8.3 for win32 first.
if not exist %PERLBIN% (
  set PERLBIN=%ORACLE_HOME%\perl\5.8.3\bin\MSWin32-x86-multi-thread\perl.exe
)

rem If version 5.8.3 for win32 is not there, try X64.
if not exist %PERLBIN% (
  set PERLBIN=%ORACLE_HOME%\perl\5.8.3\bin\MSWin32-X64-multi-thread\perl.exe
)

rem If version 5.8.3 for X64 is not there, try IA64.
if not exist %PERLBIN% (
  set PERLBIN=%ORACLE_HOME%\perl\5.8.3\bin\MSWin32-IA64-multi-thread\perl.exe
)

rem If version 5.8.3 for IA64 is not there, assume version 5.6.1.
if not exist %PERLBIN% (
  set PERLBIN=%ORACLE_HOME%\perl\5.6.1\bin\MSWin32-x86\perl.exe
)

rem If version 5.6.1 is not there, then assume Perl is in %PATH%.
if not exist %PERLBIN% (
  set PERLBIN=perl.exe
)

rem Construct path to ASMCMDCORE.
set ASMCMDCORE=%ORACLE_HOME%\bin\asmcmdcore

rem Now run asmcmdcore with all arguments!
rem removing -T option  bug fix #7193021
%PERLBIN% -I %ORACLE_HOME%\perl\lib -I %ORACLE_HOME%\perl\site\lib -I %ORACLE_HOME%\lib -I %ORACLE_HOME%\bin %ASMCMDCORE% %*

:end
