# Function to prompt user for TPM information
function Prompt-TpmInfo {
    $tpmInfoPrompt = "Do you want to get TPM information? (y/n): "
    
    if ($PSDefaultParameterValues['Confirm:Yes':'y']) {
        $tpmInfoResult = Read-Host $tpmInfoPrompt -Prompt "Please confirm your response"
        if (-Not [String]::IsNullOrEmpty($tpmInfoResult)) {
            if ($tpmInfoResult -eq 'y') {
                Write-Output "Getting TpmPresetn, TpmReady, TPM Enabled."
                Get-Tpm | Select-Object -Property TpmPresetn, TpmReady, TPMEnabled
            }
        }
    } else {
        Write-Host "TPM information prompt failed due to missing confirm function."
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
        $secureBootResult = Read-Host $secureBootPrompt -Prompt "Please confirm your
