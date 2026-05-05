# Prompt the user to get TPM information
$tpmInfo = Read-Host "Do you want to get TPM Information? (Y/N)"

if ($tpmInfo -eq 'Y' -or $tpmInfo -eq 'y') {
    # Get TPM Information
    Write-Output "Getting TPM Information..."
    
    try {
        $tpmPresetn = Get-TpmProperty -Path "TpmPresetn"
        $tpmReady = Get-TpmProperty -Path "TpmReady"
        $tpmEnabled = Get-TpmProperty -Path "TpmEnabled"

        Write-Output "TPM Presetn: $($tpmPresetn)"
        Write-Output "TPM Ready: $($tpmReady)"
        Write-Output "TPM Enabled: $($tpmEnabled)"

    } catch {
        Write-Error "Failed to get TPM information. Error: $_"
    }

    # Get TpmEndorsementKeyInfo
    try {
        $endorsementKey = Get-TpmProperty -Path "TpmEndorsementKeyInfo"
        Write-Output "TPM Endorsement Key Info: $($endorsementKey)"
        
    } catch {
        Write-Error "Failed to get TPM endorsement key information. Error: $_"
    }
}

# Prompt the user if they want to check Secure Boot
$secureBoot = Read-Host "Do you want to check if secure boot is enabled? (Y/N)"

if ($secureBoot -eq 'Y' -or $secureBoot -eq 'y') {
    # Check if Secure Boot is enabled with confirm-securebootUEFI
    try {
        $secureBootEnabled = Confirm-SecureBootUEFI
        Write-Output "Secure Boot Enabled: $($secureBootEnabled)"
        
    } catch {
        Write-Error "Failed to check secure boot. Error: $_"
    }
}

# Prompt the user if they want to get UEFI variable values related to Secure Boot
$uefiVariables = Read-Host "Do you want to get UEFI variable values related to Secure Boot? (Y/N)"

if ($uefiVariables -eq 'Y' -or $uefiVariables -eq 'y') {
    # Get UEFI variables related to Secure Boot
    try {
        $variables = Get-SecureBootUEFIVariable -Name PK, KEK, db, dbx

        foreach ($variable in $variables) {
            Write-Output "Variable Name: $($variable.Name)"
            Write-Output "Value: $($variable.Value)"
        }
        
    } catch {
        Write-Error "Failed to get UEFI variable values. Error: $_"
    }
}
