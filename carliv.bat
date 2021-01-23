::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::                                                    :::
:::          Carliv Image Kitchen for Android          :::
:::  boot ^& recovery images copyright-2020 carliv.eu   :::
:::   including support for MTK powered phones images  :::
:::                                                    :::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
cd "%~dp0"
IF EXIST "%~dp0\bin" SET PATH="%~dp0\bin";%PATH%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Setlocal EnableDelayedExpansion
attrib +h "bin" >nul 2>&1
attrib +h "scripts" >nul 2>&1
attrib +h "working" >nul 2>&1
ufind "%~dp0\bin" "%~dp0\scripts" -regex ".*\.\(exe\|bat\)" -exec chmod +x {} ;
if %errorlevel% neq 0 goto error
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:main
cls
ver > nul
echo( 
ecco {1B}
echo ***************************************************
echo *                                                 *
echo *      Carliv Image Kitchen for Android v2.1      *
echo *    boot ^& recovery images (c)2020 carliv.eu     *
echo * including support for MTK powered phones images *
echo *               WINDOWS x86 version               *
echo *                                                 *
ecco ***************************************************{0F}{\n}
echo(
echo  Choose what kind of image you need to work on.
echo(
echo ][**********************][
ecco ][ {0B}I.  IMAGE MENU {#}      ][{\n}
echo ][**********************][
ecco ][ {0A}C.  CLEAR FOLDER {#}    ][{\n}
echo ][**********************][
ecco ][ {0D}O.  CLEAR OUTPUT {#}    ][{\n}
echo ][**********************][
echo ][ P.  SEE INSTRUCTIONS ][
echo ][**********************][
ecco ][ {0C}E.  EXIT {#}            ][{\n}
echo ][**********************][
echo(
choice /C ICOPE /N /M "Choose your option [ I - C - O - P - E ]"
if %errorlevel% equ 1 goto setimg
if %errorlevel% equ 2 goto delete_all
if %errorlevel% equ 3 goto delete_output
if %errorlevel% equ 4 goto instructions
if %errorlevel% equ 5 goto end
echo(
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:imgmenu
cls
ver > nul
ecco {1B}
echo ***************************************************
echo *                                                 *
echo *      Carliv Image Kitchen for Android v2.1      *
echo *    boot ^& recovery images (c)2020 carliv.eu     *
echo * including support for MTK powered phones images *
echo *               WINDOWS x86 version               *
echo *                                                 *
ecco ***************************************************{0F}{\n}
ecco *               {0B}IMG scripts{#} section               *{\n}
echo ***************************************************
echo(
ecco Your selected image is {0A}%workfile%{#}.{\n}
for %%i in ("%workfile%") do set "workfolder=%%~ni"
if not exist "%workfolder%" goto imgmenulist
ecco The folder for repack will be {0A}%workfolder%{#}.{\n}
echo Make sure that folder exists and you didn't delete it, because if you did, it will give you an error.
:imgmenulist
echo(
echo ][*************************][*************************][
ecco ][  {0B}1. Unpack image{#}        ][  {0E}I. Other image{#}         ][{\n}
echo ][*************************][*************************][
ecco ][  {0A}2. Repack image{#}        ][  Q. Go to main menu     ][{\n}
echo ][*************************][*************************][
echo(
choice /C 12IQ /N /M "Choose your option [ 1 - 2 - I - Q ]"
if %errorlevel% equ 1 goto img_unpack
if %errorlevel% equ 2 goto img_repack
if %errorlevel% equ 3 goto setimg
if %errorlevel% equ 4 goto main
echo(
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:setimg
set workfile=
set workfolder=
cls
ver > nul
ecco {1B}
echo ***************************************************
echo *                                                 *
echo *      Carliv Image Kitchen for Android v2.1      *
echo *    boot ^& recovery images (c)2020 carliv.eu     *
echo * including support for MTK powered phones images *
echo *               WINDOWS x86 version               *
echo *                                                 *
ecco ***************************************************{0F}{\n}
echo(
for /f %%g in ('dir /b "input\*.img"') do (
   goto loadimages
)
echo ---------------------------------------------------
echo -  I. - Refresh.
echo ---------------------------------------------------
echo -  Q. - Go to Main menu.
echo ---------------------------------------------------
echo(
choice /C IQ /N /M "There is no image in your [input] folder. Place some in there and then press [I] to refresh or choose [Q] to go to main menu:"
if %errorlevel% equ 1 goto setimg
if %errorlevel% equ 2 goto main
:loadimages
echo(
set j=0
set maxb=0
echo ---------------------------------------------------
echo -  I. - Refresh.
echo ---------------------------------------------------
echo -  Q. - Go to Main menu.
for %%h in ("input\*.img") do (
	set /a j+=1
	echo ---------------------------------------------------
	echo -  !j!. - %%~nxh
	set imglist!j!=%%~nxh
	if !j! gtr !maxb! set maxb=!j!
)
echo ---------------------------------------------------
echo(
set /p imgopt=Type an image number then press ENTER: || set imgopt="0"
if %imgopt%=="0" goto imgerror
if /I %imgopt%==B goto setimg
if /I %imgopt%==Q goto main
if %imgopt% gtr %maxb% goto imgerror
set imglist=!imglist%imgopt%!
set workfile=%imglist%
for /l %%i in (1,1,48) do set workfile=!workfile:  = !
set workfile=%workfile: =_%
for /l %%j in (1,1,12) do set workfile=!workfile:..=.!
set workfile=%workfile:.=_%
set workfile=%workfile:_img=.img%
copy "input\%imglist%" "working\%workfile%" >nul 2>&1
goto imgmenu
:imgerror
echo(
ecco {0C}That is not a valid option. Please try again! {#}{\n}
PING -n 3 127.0.0.1>nul 2>&1
goto setimg
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:img_unpack
cls
copy "scripts\unpack_img.bat" "unpack_img.bat" >nul 2>&1
copy "working\%workfile%" cl.img >nul 2>&1
call unpack_img.bat cl.img %workfolder%
if exist cl.img del cl.img >nul 2>&1
if exist unpack_img.bat del unpack_img.bat >nul 2>&1
if exist "%workfolder%\ramdisk\sbin\recovery" ( 
	echo recovery > "%workfolder%\recovery.txt"
)
if not exist "%workfolder%\ramdisk\sbin\recovery" ( 
	if exist "%workfolder%\ramdisk\system\bin\recovery" ( 
		echo boot_as_recovery > "%workfolder%\boot.txt"
	) else (
		echo boot > "%workfolder%\boot.txt"
	)
)
pause
goto imgmenu
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:img_repack
cls
copy "scripts\repack_img.bat" "repack_img.bat" >nul 2>&1
call repack_img.bat %workfolder%
ecco You can find it in {0E}[output]{#} folder.{\n}
if exist repack_img.bat del repack_img.bat >nul 2>&1
pause
goto imgmenu
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:instructions
cls
type "scripts\Instructions.txt"
pause
goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:delete_all
cls
copy "scripts\clean_all.bat" "clean_all.bat" >nul 2>&1
call clean_all.bat
if exist clean_all.bat del clean_all.bat >nul 2>&1
PING -n 2 127.0.0.1>nul 2>&1
goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:delete_output
cls
copy "scripts\clean_output.bat" "clean_output.bat" >nul 2>&1
call clean_output.bat
if exist clean_output.bat del clean_output.bat >nul 2>&1
PING -n 2 127.0.0.1>nul 2>&1
goto main
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:error
echo(
ecco {0C}The scripts and executables can't get execution permissions! The kitchen won't run this way. {#}{\n}
PING -n 3 127.0.0.1>nul 2>&1
goto end
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:end
echo(
for /f %%a in ("%~dp0\working\*") do del /q "%%a" >nul 2>&1
PING -n 1 127.0.0.1>nul 2>&1
exit /b 0
