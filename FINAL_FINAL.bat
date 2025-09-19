@echo off
title System Setup Menu
mode con: cols=80 lines=30
color 07

:menu
cls
echo ============================================================
echo                       System Setup Menu
echo ============================================================
echo.
echo  [1] Wi-Fi Configuration
echo  [2] Program Installation
echo  [3] Enable Desktop Icons
echo  [4] Disable Quick Access
echo  [5] Adjust Power Settings
echo  [6] Create Shortcuts
echo.
echo  [0] Exit
echo.
echo ============================================================
set /p choice="Choose a menu option [1-6,0]: "

if "%choice%"=="1" goto wifi
if "%choice%"=="2" goto programs
if "%choice%"=="3" goto icons
if "%choice%"=="4" goto quickaccess
if "%choice%"=="5" goto power
if "%choice%"=="6" goto shortcuts
if "%choice%"=="0" exit
goto menu


:: --- Wi-Fi CONFIGURATION ---
:wifi
cls
echo ================================
echo       Wi-Fi Configuration
echo ================================
set "PROFILE=MERCUSYS_250E.xml"
set "SSID=MERCUSYS_250E"
echo Adding Wi-Fi profile for "%SSID%" ...
netsh wlan add profile filename="%PROFILE%" user=current
echo Connecting to "%SSID%" ...
netsh wlan connect name="%SSID%"
timeout /t 5 >nul
netsh wlan show interfaces | findstr "State SSID"
pause
goto menu


:: --- PROGRAM INSTALLATION ---
:programs
cls
echo ================================
echo     Program Installation
echo ================================
choice /m "Do you want to run ADOBE.EXE?"
if errorlevel 2 (
    echo Skipping ADOBE.EXE
) else (
    start "" "ADOBE.EXE"
    pause
)

choice /m "Do you want to run NINITE.EXE?"
if errorlevel 2 (
    echo Skipping NINITE.EXE
) else (
    start "" "NINITE.EXE"
    pause
)
pause
goto menu


:: --- ENABLE DESKTOP ICONS ---
:icons
cls
echo ================================
echo   Enabling Desktop Icons
echo ================================
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
pause
goto menu


:: --- DISABLE QUICK ACCESS ---
:quickaccess
cls
echo ================================
echo   Disabling Quick Access
echo ================================
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_ShowCloudFiles /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
pause
goto menu


:: --- POWER SETTINGS ---
:power
cls
echo ================================
echo   Adjusting Power Settings
echo ================================
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
pause
goto menu


:: --- CREATE SHORTCUTS ---
:shortcuts
cls
echo ================================
echo   Creating Shortcuts
echo ================================
set "source=C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
set "desktop=%USERPROFILE%\Desktop"

powershell -command "if (Test-Path '%source%\PowerPoint.lnk') { Copy-Item '%source%\PowerPoint.lnk' '%desktop%' -Force }"
powershell -command "if (Test-Path '%source%\Word.lnk') { Copy-Item '%source%\Word.lnk' '%desktop%' -Force }"
powershell -command "if (Test-Path '%source%\Excel.lnk') { Copy-Item '%source%\Excel.lnk' '%desktop%' -Force }"

pause
goto menu
