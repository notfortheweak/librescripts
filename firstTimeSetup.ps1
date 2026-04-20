# Check and display the current execution policy
$executionPolicy = Get-ExecutionPolicy -ErrorAction Stop
Write-Host "Current Execution Policy: $executionPolicy"

# Set execution policy to Unrestricted if not already set
if ($executionPolicy.ToString() -ne "Unrestricted") {
    Write-Host "Setting Execution Policy to Unrestricted..."
    Set-ExecutionPolicy Unrestricted -Force -Confirm:$false
    Write-Host "Execution Policy set successfully."
} else {
    Write-Host "Execution Policy is already set to $executionPolicy."
}

# Check and install NuGet Package Provider if not already installed
$psGalleryProvider = Get-PackageProvider -Name NuGet -ErrorAction Stop
if (-not $psGalleryProvider) {
    Write-Host "NuGet Package Provider not found. Installing..."
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Write-Host "NuGet Package Provider installed successfully."
} else {
    Write-Host "$psGalleryProvider Package Provider is already installed."
}

# Check and set PSGallery as a trusted repository if not already trusted
$psGalleryRepository = Get-PSRepository -Name PSGallery -ErrorAction Stop
if (-not $psGalleryRepository.IsTrusted) {
    Write-Host "PSGallery repository not trusted. Setting to trusted..."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Write-Host "PSGallery repository set to trusted."
} else {
    Write-Host "PSGallery repository is already trusted."
}

# Refresh the PSGallery repository settings
try {
    Unregister-PSRepository -Name PSGallery
    Register-PSRepository -Default
    Write-Host "PSGallery repository refreshed successfully."
} catch {
    Write-Error "Failed to refresh PSGallery repository: $_"
}

# Check and install PowerShellGet module if not already installed
$powerShellGetModule = Get-Module -ListAvailable -Name PowerShellGet -ErrorAction Stop
if (-not $powerShellGetModule) {
    Write-Host "PowerShellGet module not found. Installing..."
    Install-Module -Name PowerShellGet -Force -Confirm:$false
    Write-Host "PowerShellGet module installed successfully."
} else {
    Write-Host "PowerShellGet module is already installed."
}

# Check and install PackageManagement module if not already installed
$packageManagementModule = Get-Module -ListAvailable -Name PackageManagement -ErrorAction Stop
if (-not $packageManagementModule) {
    Write-Host "PackageManagement module not found. Installing..."
    Install-Module -Name PackageManagement -Force -Confirm:$false
    Write-Host "PackageManagement module installed successfully."
} else {
    Write-Host "PackageManagement module is already installed."
}

# Ask the user if they want to update the help files
$updateHelp = Read-Host "Do you want to update help files? (y/n)"
if ($updateHelp.ToLower() -eq 'y') {
    try {
        Update-Help -ErrorAction Stop
        Write-Host "Help files updated successfully."
    } catch {
        Write-Warning "Failed to update help files: $_"
    }
} else {
    Write-Host "Update of help files skipped."
}

# Catch and handle any errors gracefully
catch {
    Write-Error "An error occurred: $_"
    exit 1
}