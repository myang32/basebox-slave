echo Extend drive C to maximum 
echo select volume 0 >%TEMP%\extendC.txt
echo extend >>%TEMP%\extendC.txt
diskpart.exe /s %TEMP%\extendC.txt

if exist %WinDir%\microsoft.net\framework\v4.0.30319 goto :have_net4
echo Ensuring .NET 4.0 is installed
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/StefanScherer/arduino-ide/install/InstallNet4.ps1'))"
:have_net4
if "%ChocolateyInstall%x"=="x" set ChocolateyInstall=%SystemDrive%\Chocolatey
if exist %ChocolateyInstall% goto :have_chocolatey
echo Installing Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
:have_chocolatey

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

call cinst wget

call cinst msysgit
where git
if ERRORLEVEL 1 call :addGitToUserPath
goto GIT_DONE
:addGitToUserPath
for /F "tokens=2* delims= " %%f IN ('reg query "HKCU\Environment" /v Path ^| findstr /i path') do set OLD_USER_PATH=%%g
reg add HKCU\Environment /v Path /d "%OLD_USER_PATH%;C:\Program Files (x86)\Git\cmd" /f
set PATH=%PATH%;C:\Program Files (x86)\Git\cmd
exit /b
:GIT_DONE


call cinst packer
where packer
if ERRORLEVEL 1 call :addPackerToUserPath
goto PACKER_DONE
:addPackerToUserPath
for /F "tokens=2* delims= " %%f IN ('reg query "HKCU\Environment" /v Path ^| findstr /i path') do set OLD_USER_PATH=%%g
reg add HKCU\Environment /v Path /d "%OLD_USER_PATH%;C:\hashicorp\packer" /f
set PATH=%PATH%;C:\hashicorp\packer
exit /b
:PACKER_DONE


:packer_firewall
netsh advfirewall firewall add rule name="packer-builder-vmware-iso" dir=in program="c:\HashiCorp\packer\packer-builder-vmware-iso.exe" action=allow
netsh advfirewall firewall add rule name="packer-builder-virtualbox-iso" dir=in program="c:\HashiCorp\packer\packer-builder-virtualbox-iso.exe" action=allow
netsh advfirewall firewall add rule name="packer-builder-vmware-iso" dir=in program="c:\Users\vagrant\go\bin\packer-builder-vmware-iso.exe" action=allow
netsh advfirewall firewall add rule name="packer-builder-virtualbox-iso" dir=in program="c:\Users\vagrant\go\bin\packer-builder-virtualbox-iso.exe" action=allow

echo "Installing Jenkins Swarm Client"
call c:\vagrant\scripts\install-jenkins-slave.bat virtualbox

if exist "c:\Program Files\Oracle\VirtualBox" goto :have_vbox
echo Installing VirtualBox - delayed - guest will reboot
start c:\vagrant\scripts\install-virtualbox-and-reboot.bat
:have_vbox