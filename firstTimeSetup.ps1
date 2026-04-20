# Enable verbose output for detailed logging
$VerbosePreference = 'Continue'

try {
    # Prompt the user to set the execution policy
    $policyOptions = @("Unrestricted", "RemoteSigned", "AllSigned", "Restricted")
    Write-Host "Please select an execution policy:"
    foreach ($policy in $policyOptions) {
        Write-Host "[$($policyOptions.IndexOf($policy) + 1)] $policy"
    }
    
    while (-not $validPolicySelected) {
        $selectedPolicyIndex = Read-Host -Prompt "Enter the number corresponding to your choice"
        
        if ($selectedPolicyIndex -ge 1 -and $selectedPolicyIndex -le $policyOptions.Length) {
            $selectedPolicy = $policyOptions[$selectedPolicyIndex - 1]
            Write-Verbose "User selected policy: $selectedPolicy"
            $validPolicySelected = $true
        } else {
            Write-Warning "Invalid selection. Please choose a valid number."
        }
    }

    # Check and set execution policy to the user's choice
    $executionPolicy = Get-ExecutionPolicy -ErrorAction Stop
    if ($executionPolicy.ToString() -ne $selectedPolicy) {
        Write-Host "Current Execution Policy: $executionPolicy"
        Write-Verbose "Setting Execution Policy to $selectedPolicy..."
        Set-ExecutionPolicy $selectedPolicy -Force -Confirm:$false
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

    # Update help for all modules
    try {
        Update-Help -ErrorAction Stop
        Write-Host "Help files updated successfully."
    } catch {
        Write-Warning "Failed to update help files: $_"
    }

} catch {
    Write-Error "An error occurred: $_"
    exit 1
}