@echo off
for /f "delims=" %%x in ('powershell -Command "$principal = new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent()); $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)"') do set "admin=%%x"
if %admin% == False cls & echo you need to run it as administrator & pause & exit
cd C:\Users\%username%\Desktop
color a
if not exist C:\Users\%username%\Desktop\sendbox md C:\Users\%username%\Desktop\sendbox
title mail
pushd \\%computername%\sendbox & if %errorlevel% NEQ 0 goto create > nul
popd
:create
cls
net share sendbox=C:\Users\%username%\Desktop\sendbox /GRANT:Everyone,FULL > nul
goto start
:start
cls
cmdmenusel f971 "send" "box" "open" "exit"
if %errorlevel% == 1 goto send
if %errorlevel% == 2 goto box
if %errorlevel% == 3 goto open
if %errorlevel% == 4 net share sendbox /DELETE > nul & exit
:box
cls
pushd \\%computername%\sendbox > nul
dir /b /a
popd
timeout 1 > nul
goto box
:error
cls
echo error
pause
net share sendbox /DELETE > nul
goto start
:send
cls
echo NEW MAIL
echo -------------------------------------------
set /p id=send to:
echo -------------------------------------------
set /p title=mail title:
echo -------------------------------------------
set /p add=message:
echo -------------------------------------------
pushd \\%id%\sendbox > nul
echo %add% > %title%.txt
popd
goto start
:open
cls
pushd \\%computername%\sendbox > nul
dir /b /a
set /p open=
start %open%
popd
if %open% == exit goto start
goto open
