# Function to prompt user for TPM information
function Prompt-TpmInfo {
    $tpmInfoPrompt = "Do you want to get TPM info? (y/n): "
    
    if ($PSDefaultParameterValues['Confirm:Yes':'y']) {
        $tpmInfoResult = Read-Host $tpmInfoPrompt -Prompt "Please confirm your response"
        if (-Not [String]::IsNullOrEmpty($tpmInfoResult)) {
            if ($tpmInfoResult -eq 'y') {
                Write-Output "Getting TpmPresent, TpmReady, TPM Enabled."
                Get-Tpm | Select-Object -Property TpmPresent, TpmReady, TPMEnabled
            }
        }
    } else {
        Write-Host "TPM info prompt failed due to missing confirm function."
    }
}

# Function to get TPM Endorsement Key Info and display it
function Prompt-TpmEndorsementKeyInfo {
    $tpmEkiPrompt = "Do you want to get TpmEndorsementKeyInfo? (y/n): "
    
    if ($PSDefaultParameterValues['Confirm:Yes':'y']) {
        $tpmEkiResult = Read-Host $tpmEkiPrompt -Prompt "Please confirm your response"
        if (-Not [String]::IsNullOrEmpty($tpmEkiResult)) {
            if ($tpmEkiResult -eq 'y') {
                Write-Output "Getting TpmEndorsementKeyInfo."
                Get-Tpm | Select-Object -Property TpmEndorsementKeyInfo
            }
        }
    } else {
        Write-Host "TPM Endorsement Key Info prompt failed due to missing confirm function."
    }
}

# Function to check Secure Boot status and display relevant UEFI variables
function Prompt-CheckSecureBootStatus {
    $secureBootPrompt = "Do you want to check if secure boot is enabled? (y/n): "
    
    if ($PSDefaultParameterValues['Confirm:Yes':'y']) {
        $secureBootResult = Read-Host $secureBootPrompt -Prompt "Please confirm your response"
        
        Write-Output "Checking if Secure Boot is enabled."
        
        # Confirm Secure Boot UEFI
        Get-SecurebootUEFI | Select-Object -ExpandProperty SecureBootEnabled
        
        # Get UEFI variable values related to Secure Boot
        $securebootVariables = @(
            @{Name="PK"; Value=(Get-Variable PK)}
            @{Name="KEK"; Value=(Get-Variable KEK)}
            @{Name="db"; Value=(Get-Variable db)}
            @{Name="dbx"; Value=(Get-Variable dbx)}
        )
        
        $securebootVariables | ForEach-Object { Write-Output " - Name: $_.Name; Value: $_.Value" }
    } else {
        Write-Host "Secure Boot status prompt failed due to missing confirm function."
    }
}

# Main script loop
while ($true) {
    # Prompt for TPM info
    Prompt-TpmInfo
    
    # Check if the user wants to get TPM Endorsement Key Info
    Prompt-TpmEndorsementKeyInfo
    
    # Check if the user wants to check Secure Boot status
    Prompt-CheckSecureBootStatus
    
    # Pause before the next prompt loop
    Write-Host "`nPress any key to continue..."
    Read-Host -Prompt ""
}
