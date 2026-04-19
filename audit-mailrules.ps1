# Check execution policy, set to unrestricted if not already set to allow script execution.
if ((Get-ExecutionPolicy).ToString() -ne "Unrestricted") {
    Set-ExecutionPolicy Unrestricted -Force
}

# Check to see if PSGallery is installed and if not install it.
if (-not (Get-PackageProvider -Name NuGet)) {
    Install-PackageProvider -Name NuGet -Force
}

# Check to see if PSGallery is set as a trusted repository, set it to trusted if not already set.
if (-not (Get-PSRepository -Name PSGallery).IsTrusted) {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# Check to see if PowershellGet is installed, install if not installed.
if (-not (Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Force
}

# Check to see if PackageManagement is installed, install if not installed.
if (-not (Get-Module -ListAvailable -Name PackageManagement)) {
    Install-Module -Name PackageManagement -Force
}

# Check to see if ExchangeOnlineManagement is installed, install if not installed.
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force
}

# Connect to Exchange Online, prompt for credentials if not already connected.
try {
    Get-ExchangeSession | Out-Null
} catch {
    $UserCredential = Get-Credential
    Connect-ExchangeOnline -UserPrincipalName $UserCredential.UserName -ShowProgress $true
}

# Get all mail rules including hidden for a user which is prompted for, display the rules inluding their creation date& time, the rule details, and the rule's enabled status.
$Mailbox = Read-Host "Enter the email address of the mailbox"
$Rules = Get-InboxRule -Identity $Mailbox
$Rules | Select-Object Name, CreationTime, Enabled, Conditions, Actions

# Export the Exchange Online mail rules to a CSV file, the file name should include the user's name and the date of export.
$ExportPath = "C:\ExchangeOnlineRules_{0}_{1}.csv" -f $Mailbox.Split("@")[0], (Get-Date).ToString("yyyy-MM-dd_HH-mm")
$Rules | Select-Object Name, CreationTime, Enabled, Conditions, Actions | Export-Csv -Path $ExportPath -NoTypeInformation

# Anticipate end user wanting to delete all recently created mail rules within the last 72 hours and provide an option to do so, if the user opts to delete the recently created mail rules, delete all mail rules created within the last 72 hours and display the names of the deleted rules
$DeleteRecentlyCreatedRules = Read-Host "Do you want to delete all recently created mail rules within the last 72 hours? (y/n)"
if ($DeleteRecentlyCreatedRules.ToLower() -eq "y") {
    $DeletedRules = Get-InboxRule -Identity $Mailbox | Where-Object { $_.CreationTime -gt (Get-Date).AddHours(-72) }
    foreach ($Rule in $DeletedRules) {
        Remove-InboxRule -Identity $Rule.Identity
        Write-Host "Deleted rule: $($Rule.Name)"
    }
}

# Check for sweep rules and display the names of any sweep rules found, if the user wants to delete the sweep rules, delete all sweep rules and display the names of the deleted sweep rules.
$SweepRules = Get-MailRule -Identity $Mailbox | Where-Object { $_.Actions.SweepOrphanedItems }
if ($SweepRules.Count -gt 0) {
    Write-Host "Sweep rules found:"
    $SweepRules.Name
    $DeleteSweepRules = Read-Host "Do you want to delete all sweep rules? (y/n)"
    if ($DeleteSweepRules.ToLower() -eq "y") {
        foreach ($Rule in $SweepRules) {
            Remove-InboxRule -Identity $Rule.Identity
            Write-Host "Deleted rule: $($Rule.Name)"
        }
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

Write-Host "Script completed."
