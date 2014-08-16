
if "%ChocolateyInstall%x"=="x" set ChocolateyInstall=%ALLUSERSPROFILE%\Chocolatey
if exist %ChocolateyInstall% goto :have_choco
echo Installing Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
:have_choco

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

:install_packer

if exist c:\go\bin goto :have_golang
call cinst golang
set PATH=%PATH%;c:\go\bin
:have_golang

call cinst git
where git
if ERRORLEVEL 1 call :addGitToUserPath
goto GIT_DONE
:addGitToUserPath
for /F "tokens=2* delims= " %%f IN ('reg query "HKCU\Environment" /v Path ^| findstr /i path') do set OLD_USER_PATH=%%g
reg add HKCU\Environment /v Path /d "%OLD_USER_PATH%;C:\Program Files (x86)\Git\cmd" /f
set PATH=%PATH%;C:\Program Files (x86)\Git\cmd
exit /b
:GIT_DONE

call cinst bzr
set PATH=%PATH%;c:\program files (x86)\Bazaar

call cinst hg
set PATH=%PATH%;c:\program files\Mercurial

set GOPATH=C:\users\vagrant\go
setx GOPATH C:\users\vagrant\go

mkdir %GOPATH%\bin

call :addGoPathToSystemPath
goto GOPATH_DONE
:addGoPathToSystemPath
for /F "tokens=2* delims= " %%f IN ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i path') do set OLD_SYSTEM_PATH=%%g
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v Path /d "%OLD_SYSTEM_PATH%;%GOPATH%\bin" /f
set PATH=%PATH%;%GOPATH%\bin
exit /b
:GOPATH_DONE


if exist %GOPATH%\bin\packer.exe goto :packer_compiled
echo Downloading and compiling packer
go get github.com/mitchellh/packer
cd /D %GOPATH%\src\github.com\mitchellh\packer
go get ./...
cd /D %GOPATH%\bin
for /f "tokens=1" %%i in ('dir /b builder* command* post* provision*') DO if exist packer-%%i del packer-%%i
for /f "tokens=1" %%i in ('dir /b builder* command* post* provision*') DO ren %%i packer-%%i
:packer_compiled

echo Downloading and compiling packer-post-processor-vagrant-vmware-ovf
go get github.com/gosddc/packer-post-processor-vagrant-vmware-ovf

set packerconfig=%AppData%\packer.config
echo { > %packerconfig%
echo  "post-processors": { >> %packerconfig%
echo      "vagrant-vmware-ovf": "packer-post-processor-vagrant-vmware-ovf" >> %packerconfig%
echo  } >> %packerconfig%
echo } >> %packerconfig%

cd /D %USERPROFILE%
where packer
packer --version

