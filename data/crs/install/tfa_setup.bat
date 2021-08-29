@echo OFF

set crs_home=
set perl=
set searchString=
set searchItem=
set perlpath=
set tfahome_build=%~dp0

set BASE_KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Oracle

:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)

:64BIT
set REGISTRY_QUERY_TYPE=/reg:64
GOTO CheckOSEND

:32BIT
set REGISTRY_QUERY_TYPE=/reg:32
GOTO CheckOSEND

:CheckOSEND

REM Unnecessary loading of external PERL5LIB modules may lead to conflict
REM Hence setting it to null for current sessions
set PERL5LIB=

:Loop
IF "%~1"=="" GOTO ArgParseComplete
	IF "%~1"=="-h" (
		GOTO printhelp
	)
	IF "%~1"=="-perlhome" (
		for /f "usebackqdelims=" %%k in ('%2\bin\perl.exe') do (
			IF EXIST "%%k" (
				echo.
				echo Found perl from argument : %2\bin\perl.exe 
				set perl=%2\bin\perl.exe
			) ELSE (
				echo.
				echo Could not locate perl from argument : %2\bin\perl.exe 
				GOTO EOF
			)
		)
        SHIFT
    )
    IF "%~1"=="-crshome" (
        SET crs_home=%2
        SHIFT
    )
SHIFT
GOTO Loop
:ArgParseComplete

echo Parameters provided : %*
IF NOT "%crs_home%"=="" (
	GOTO perlThroughCRS
)

set len=0
call :strlen len perl
IF "%len%"=="0" (
	echo.
	echo Checking if CRS Installed ... 

	for /f "tokens=3* delims= " %%k in ('reg query %BASE_KEY%\olr /s /e /f crs_home %REGISTRY_QUERY_TYPE% ^| findstr crs_home') do (
		set crs_home=%%k
		setlocal enabledelayedexpansion
		set crs_home=!crs_home: =!
		endlocal
	)
	GOTO perlThroughCRS
)

:perlThroughCRSComplete
set len=0
call :strlen len perl
IF NOT "%len%"=="0" (
	echo.
	echo FOUND PERL : %perl%
	echo.
	echo INSTALLING TFA with arguments %*
	IF EXIST %tfahome_build%\tfa_home (
		%perl% %tfahome_build%\tfa_home\bin\installTFA.pl -perl %perl% %*
	) ELSE (
		%perl% %crs_home%\suptools\tfa\release\tfa_home\bin\installTFA.pl -perl %perl% %*
	)
	echo.
	echo Exiting TFA Installation
	GOTO :EOF
) ELSE (
	echo.
	echo Could not locate perl
	echo.
	echo Exiting TFA Installation
	GOTO :EOF
)

:printhelp
echo.
echo Usage for %0
echo.
echo    "%0 [-crshome <CRS Home> | -tfabase <Install Directory>] | [-javahome <Java Install Location>] | [-perlhome <Perl Install Location>] | [-deferdiscovery | -local | -silent | -debug]"
echo.
echo    -local            -    Only install on the local node 
echo    -deferdiscovery   -    Discover Oracle trace directories after installation completes 
echo    -tfabase          -    Install into the directory supplied
echo    -crshome          -    CRS Home Location
echo    -javahome         -    Use this directory for the JRE 
echo    -silent           -    Do not ask any install questions 
echo    -debug            -    Print debug tracing and do not remove TFA_HOME on install failure 
echo    -perlhome         -    Use given perl binary for execution of perl programs 
echo.
echo    - If path contains spaces surround it with double quotes
GOTO EOF

:perlThroughCRS
echo "CRS HOME : %crs_home%"

set len=0
REM Here two "%crs_home%"=="" conditions to make sure len variable is set properly
IF "%crs_home%"=="" (
	for %%G in (perl.exe) do @set perl=%%~$PATH:G
	call :strlen len perl
)
IF "%crs_home%"=="" (
	IF "%len%" == "0" (
		echo.
		echo Perl binaries are not available. Set perl path as shown below :
		GOTO printhelp
	)
)
IF NOT "%crs_home%"=="" (
	echo perl=%crs_home%\perl\bin\perl.exe
	set perl=%crs_home%\perl\bin\perl.exe
)
GOTO perlThroughCRSComplete

:strlen <resultVar> <stringVar>
(   
    setlocal EnableDelayedExpansion
    set "s=!%~2!#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" ( 
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)

:EOF