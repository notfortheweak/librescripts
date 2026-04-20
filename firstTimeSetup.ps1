# Check execution policy, set to unrestricted if not already set to allow script execution.
$executionPolicy = Get-ExecutionPolicy -ErrorAction SilentlyContinue
if ($executionPolicy.ToString() -ne "Unrestricted") {
    Write-Host "Current Execution Policy: $executionPolicy"
    Write-Host "Setting Execution Policy to Unrestricted..."
    Set-ExecutionPolicy Unrestricted -Force -Confirm:$false
    Write-Host "Execution Policy set successfully."
} else {
    Write-Host "Execution Policy is already set to $executionPolicy."
}

# Check to see if PSGallery is installed and if not install it.
$psGalleryProvider = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
if (-not $psGalleryProvider) {
    Write-Host "NuGet Package Provider not found. Installing..."
    Install-PackageProvider -Name NuGet -Force -Confirm:$false
    Write-Host "NuGet Package Provider installed successfully."
} else {
    Write-Host "$psGalleryProvider Package Provider is already installed."
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

# Check and Install PSWindowsUpdate Module:
$pswindowsupdateModule = Get-Module -ListAvailable -Name PSWindowsUpdate -ErrorAction SilentlyContinue
if (-not $pswindowsupdateModule) {
    Write-Host "PSWindowsUpdate module not found. Do you want to install it? [Y/N]"
    $installPsWindowsUpdate = Read-Host
    if ($installPsWindowsUpdate.ToLower() -eq 'y') {
        Write-Host "Installing PSWindowsUpdate module..."
        Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
        Write-Host "PSWindowsUpdate module installed successfully."
    } else {
        Write-Host "PSWindowsUpdate module not installed."
    }
} else {
    Write-Host "PSWindowsUpdate module is already installed."
}

# Check and Install Az Module:
$azModule = Get-Module -ListAvailable -Name Az -ErrorAction SilentlyContinue
if (-not $azModule) {
    Write-Host "Az module not found. Do you want to install it? [Y/N]"
    $installAz = Read-Host
    if ($installAz.ToLower() -eq 'y') {
        Write-Host "Installing Az module..."
        Install-Module -Name Az -AllowClobber -Force -SkipPublisherCheck -Confirm:$false
        Write-Host "Az module installed successfully."
    } else {
        Write-Host "Az module not installed."
    }
} else {
    Write-Host "Az module is already installed."
}

# Check and Install ActiveDirectory Module:
$activeDirectoryModule = Get-Module -ListAvailable -Name ActiveDirectory -ErrorAction SilentlyContinue
if (-not $activeDirectoryModule) {
    Write-Host "ActiveDirectory module not found. Do you want to install it? [Y/N]"
    $installActiveDirectory = Read-Host
    if ($installActiveDirectory.ToLower() -eq 'y') {
        Write-Host "Installing ActiveDirectory module..."
        Install-Module -Name ActiveDirectory -Force -Confirm:$false
        Write-Host "ActiveDirectory module installed successfully."
    } else {
        Write-Host "ActiveDirectory module not installed."
    }
} else {
    Write-Host "ActiveDirectory module is already installed."
}
