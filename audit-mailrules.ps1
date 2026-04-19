# Check execution policy, set to unrestricted if not already set to allow script execution.
$executionPolicy = Get-ExecutionPolicy -ErrorAction SilentlyContinue
if ($executionPolicy.ToString() -ne "Unrestricted") {
    Write-Host "Current Execution Policy: $executionPolicy"
    Write-Host "Setting Execution Policy to Unrestricted..."
    Set-ExecutionPolicy Unrestricted -Force -Confirm:$false
    Write-Host "Execution Policy set successfully."
} else {
    Write-Host "Execution Policy is already set to Unrestricted."
}

# Check to see if PSGallery is installed and if not install it.
$psGalleryProvider = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
if (-not $psGalleryProvider) {
    Write-Host "NuGet Package Provider not found. Installing..."
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Write-Host "NuGet Package Provider installed successfully."
} else {
    Write-Host "NuGet Package Provider is already installed."
}

# Check to see if PSGallery is set as a trusted repository, set it to trusted if not already set.
$psGalleryRepository = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
if (-not $psGalleryRepository.IsTrusted) {
    Write-Host "PSGallery repository not trusted. Setting to trusted..."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Write-Host "PSGallery repository set to trusted."
} else {
    Write-Host "PSGallery repository is already trusted."
}

# Check to see if PowershellGet is installed, install if not installed.
$powerShellGetModule = Get-Module -ListAvailable -Name PowerShellGet -ErrorAction SilentlyContinue
if (-not $powerShellGetModule) {
    Write-Host "PowerShellGet module not found. Installing..."
    Install-Module -Name PowerShellGet -Force -Confirm:$false
    Write-Host "PowerShellGet module installed successfully."
} else {
    Write-Host "PowerShellGet module is already installed."
}

# Check to see if PackageManagement is installed, install if not installed.
$packageManagementModule = Get-Module -ListAvailable -Name PackageManagement -ErrorAction SilentlyContinue
if (-not $packageManagementModule) {
    Write-Host "PackageManagement module not found. Installing..."
    Install-Module -Name PackageManagement -Force -Confirm:$false
    Write-Host "PackageManagement module installed successfully."
} else {
    Write-Host "PackageManagement module is already installed."
}

# Check to see if ExchangeOnlineManagement is installed, install if not installed.
$exchangeOnlineManagementModule = Get-Module -ListAvailable -Name ExchangeOnlineManagement -ErrorAction SilentlyContinue
if (-not $exchangeOnlineManagementModule) {
    Write-Host "ExchangeOnlineManagement module not found. Installing..."
    Install-Module -Name ExchangeOnlineManagement -Force -Confirm:$false
    Write-Host "ExchangeOnlineManagement module installed successfully."
} else {
    Write-Host "ExchangeOnlineManagement module is already installed."
}

# Connect to Exchange Online, prompt for credentials if not already connected.
try {
    Get-PSSession | Out-Null
    Write-Host "Already connected to Exchange Online."
} catch {
    $UserCredential = Get-Credential
    Write-Host "Connecting to Exchange Online..."
    Connect-ExchangeOnline -UserPrincipalName $UserCredential.UserName -ShowProgress $true
    Write-Host "Connected to Exchange Online successfully."
}

# Get all inbox rules including hidden for a user which is prompted for, display the rules inluding their creation date& time, the rule details, and the rule's enabled status.
$Mailbox = Read-Host "Enter the email address of the mailbox"
Write-Host "Retrieving Inbox Rules for $Mailbox..."
$Rules = Get-InboxRule -Mailbox $Mailbox
if ($Rules.Count -gt 0) {
    Write-Host "Found $($Rules.Count) inbox rules for $Mailbox."
    $Rules | Select-Object Name, CreationTime, Enabled, Conditions, Actions
} else {
    Write-Host "No inbox rules found for $Mailbox."
}

# Export the Exchange Online inbox rules to a CSV file, the file name should include the user's name and the date of export.
$ExportPath = "C:\ExchangeOnlineRules_{0}_{1}.csv" -f $Mailbox.Split("@")[0], (Get-Date).ToString("yyyy-MM-dd_HH-mm")
Write-Host "Exporting rules to $ExportPath..."
$Rules | Select-Object Name, CreationTime, Enabled, Conditions, Actions | Export-Csv -Path $ExportPath -NoTypeInformation
Write-Host "Rules exported successfully."

# Anticipate end user wanting to delete all recently created inbox rules within the last 72 hours and provide an option to do so.
$DeleteRecentlyCreatedRules = Read-Host "Do you want to delete all recently created inbox rules within the last 72 hours? (y/n)"
if ($DeleteRecentlyCreatedRules.ToLower() -eq "y") {
    $DeletedRules = Get-InboxRule -Mailbox $Mailbox | Where-Object { $_.CreationTime -gt (Get-Date).AddHours(-72) }
    if ($DeletedRules.Count -gt 0) {
        Write-Host "Found $($DeletedRules.Count) recently created inbox rules for deletion."
        foreach ($Rule in $DeletedRules) {
            Remove-InboxRule -Identity $Rule.Identity
            Write-Host "Deleted rule: $($Rule.Name)"
        }
    } else {
        Write-Host "No recently created inbox rules found to delete."
    }
} else {
    Write-Host "Skipping deletion of recently created inbox rules."
}

# Check for sweep rules and display the names of any sweep rules found, if the user wants to delete the sweep rules, delete all sweep rules and display the names of the deleted sweep rules.
$SweepRules = Get-InboxRule -Mailbox $Mailbox | Where-Object { $_.Actions.SweepOrphanedItems }
if ($SweepRules.Count -gt 0) {
    Write-Host "Found $($SweepRules.Count) sweep rules."
    $DeleteSweepRules = Read-Host "Do you want to delete all sweep rules? (y/n)"
    if ($DeleteSweepRules.ToLower() -eq "y") {
        foreach ($Rule in $SweepRules) {
            Remove-InboxRule -Identity $Rule.Identity
            Write-Host "Deleted rule: $($Rule.Name)"
        }
    } else {
        Write-Host "Skipping deletion of sweep rules."
    }
} else {
    Write-Host "No sweep rules found."
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
Write-Host "Script completed."
