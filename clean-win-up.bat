del /F C:\cleanwinup.log
>C:\cleanwinup.log (
echo "Installing Chocolatey..."
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo "Installing Handle with Choco..."
choco install handle -ym --force

reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Sysinternals\Handle" /v EulaAccepted /d 1 /f

echo "Killing wuauserv..."
for /f "tokens=2 delims=: " %%A in ('sc queryex wuauserv ^| find /i "PID"') do set UpdatePID=%%A
taskkill.exe /f /PID %UpdatePID%

echo "Disabling wuaserv..."
sc config wuauserv start= disabled

echo "Stopping N-able Windows Agent Service and Disabling..."
net stop "Windows Agent Service"
sc config "Windows Agent Service" start= disabled

echo "Searching for open handles to windowsupdate.log and closing them..."
for /f "tokens=3,6 delims=: " %%A in ('handle windowsupdate.log ^| find "pid"') do (
    echo "Found process %%A with open handle %%B"
    handle -p %%A -c %%B -y )

echo "Emptying windowsupdate.log"
copy /y nul c:\Windows\Windowsupdate.log

echo "Deleting Software Distribution Folders..."
del c:\Windows\SoftwareDistribution\Datastore\*.* /S /Q
del c:\Windows\SoftwareDistribution\Download\*.* /S /Q

echo "Restoring wuauserv..."
sc config wuauserv start= auto
net start wuauserv

echo "Restoring Windows Agent Service"
sc config "Windows Agent Service" start= auto
net start "Windows Agent Service"

echo "Windows Update Cleanup finished."
)
