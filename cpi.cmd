:::::::::::::::::::::::::::::::::
::Custom Package Installer v1.0::
::Written by Baikil            ::
::https://github.com/baikil/cpi::
:::::::::::::::::::::::::::::::::

:00 Initialization
@echo off
setlocal EnableDelayedExpansion
for %%a in (%0) do (set cpiDir=%%~da%%~pa)
set appv=1.0
if "%1" neq "" goto
md %UserProfile%\.cpi\tmp
md %UserProfile%\.cpi\install
md %UserProfile%\.cpi\pkg

:01 Home
title Custom Package Installer - Home
cls
echo Welcome to Custom Package Installer (cpi) v%appv%
echo.
echo 1. Install a package
echo 2. Remove a package
echo 3. Check for updates
choice /n /c 123
goto %errorlevel%0
goto 01

:10 Install a package
title Custom Package Installer - Install a package
cls
echo Install a package
echo.
echo 1. Select package to install
echo 2. Go back (Home)
choice /n /c 12
goto 1%errorlevel%

:11 Select package
title Custom Package Installer - Install package
cls
echo Install package
echo.
echo Input the desired package to install (ex.: profile/repo-name)
set /p "pkg=Install : "
powershell -command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/%pkg%/raw/main/install.cpi','%UserProfile%\.cpi\tmp\%pkg:/=-%.install.cpi')"
<"%UserProfile%\.cpi\tmp\%pkg:/=-%.install.cpi" set /p tmpver=
set tmpver=%tmpver%
if exist "%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi" (<"%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi" set /p installedver=) else (set installedver=0)
if not "%installedver%" geq "%tmpver%" (goto 110)
echo.
echo The same or a newer version of "%pkg%" is already installed
echo Installed : %installedver% ^| Fetched : %tmpver%
echo Do you want to install it anyways and replace the installed version [Y/N]?
choice /c yn /n
if %errorlevel% == 2 goto 10
goto 11

:110 Skip "Already installed" prompt
move /y "%UserProfile%\.cpi\tmp\%pkg:/=-%.install.cpi" "%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi"
for /f "usebackq" %%b in (`type %UserProfile%\.cpi\install\%pkg:/=-%.install.cpi ^| find "" /v /c`) do (set ln=%%b)
set inc=0
title Custom Package Installer - Reading and processing "%pkg:/=-%.install.cpi"...
echo Reading and processing "%pkg:/=-%.install.cpi"...

:111 Read & Process "install.cpi"
set /a "inc+=1"
for /f "skip=%inc% delims=" %i in (%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi) do set "read=%%i"
if "%read:~0,6%" == "cpi-md" (md "%read:~7%"&goto 112) ::Make Directory
if "%read:~0,9%" == "cpi-pkgmd" (md "%UserProfile%\.cpi\pkg\%pkg:/=-%\%read:~10%"&goto 112) ::Make Directory in "%UserProfile%\.cpi\pkg\package-name\"
if "%read:~0,6%" == "cpi-dl" (
	set "url=%read:~7%"
	set /a "inc+=1"
	for /F "skip=%inc% delims=" %i in (%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi) do set "dir=%%i"
	powershell -command "(New-Object System.Net.WebClient).DownloadFile('%url%','%dir%')"
	goto 112
	) ::Download from the internet to anywhere
if "%read:~0,9%" == "cpi-pkgdl" (
	set "url=%read:~10%"
	set /a "inc+=1"
	for /F "skip=%inc% delims=" %i in (%UserProfile%\.cpi\install\%pkg:/=-%.install.cpi) do set "dir=%%i"
	powershell -command "(New-Object System.Net.WebClient).DownloadFile('%url%','%UserProfile%\.cpi\pkg\%pkg:/=-%\%dir%')"
	goto 112
	) ::Download from the internet to "%UserProfile%\.cpi\pkg\package-name\"

:112 Loop selector
if not %inc% geq %ln% goto 111
echo Finished reading and processing "%pkg:/=-%.install.cpi"

:12 Go back (Home)
goto 01

:20 Remove a package
title Custom Package Installer - Remove a package
cls
echo Remove a package
echo.
echo 1. Select package to remove
echo 2. Go back (Home)
choice /n /c 12
goto 2%errorlevel%

:21 Select package


:22 Go back (Home)
goto 01

:30 Check for updates
title Custom Package Installer - Check for updates
cls
echo Check for updates
echo.

:31 Install updates

