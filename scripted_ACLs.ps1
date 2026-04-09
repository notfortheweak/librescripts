function Get-FileSystemRights {
    param([string]$inputRights)

    $rights = 0
    $values = $inputRights -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    foreach ($value in $values) {
        try {
            $enumValue = [System.Security.AccessControl.FileSystemRights]::$value
            $rights = $rights -bor $enumValue
        } catch {
            Write-Host "Invalid permission: '$value'" -ForegroundColor Yellow
            return $null
        }
    }

    return $rights
}



function Read-YesNo {
    param([string]$prompt)

    do {
        $answer = Read-Host $prompt
        $normalized = $answer.Trim().ToLower()
    } while ($normalized -notin @('y', 'n', 'yes', 'no'))

    return $normalized -in @('y', 'yes')
}

$path = Read-Host "Enter the full path of the file or folder to modify"
if (-not (Test-Path -Path $path)) {
    Write-Host "Path '$path' does not exist." -ForegroundColor Red
    exit 1
}

$acl = Get-Acl -Path $path
Write-Host "Current access rules for '$path':" -ForegroundColor Cyan
$acl.Access | Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited -AutoSize

$mode = Read-Host "Choose mode ('Add' to append rules, 'Replace' to remove existing explicit rules before adding new ones)"
if ($mode -notin @('Add', 'Replace')) {
    Write-Host "Mode must be 'Add' or 'Replace'. Exiting." -ForegroundColor Red
    exit 1
}

if ($mode -eq 'Replace') {
    $existingRules = $acl.Access | Where-Object { -not $_.IsInherited }
    foreach ($existingRule in $existingRules) {
        $acl.RemoveAccessRuleAll($existingRule)
    }
    Write-Host "Cleared existing explicit access rules." -ForegroundColor Cyan
}

$continue = $true
while ($continue) {
    $identity = Read-Host "Enter the user or group to modify (e.g. 'DOMAIN\\User' or 'GroupName')"
    if (-not $identity) {
        Write-Host "Identity cannot be empty." -ForegroundColor Yellow
        continue
    }

    $typeInput = Read-Host "Enter access type ('Allow' or 'Deny')"
    if ($typeInput -notin @('Allow', 'Deny')) {
        Write-Host "Access type must be 'Allow' or 'Deny'." -ForegroundColor Yellow
        continue
    }

    $rightsInput = Read-Host "Enter permissions (comma-separated). Examples: Read, ReadAndExecute, Write, Modify, FullControl"
    $rights = Get-FileSystemRights -inputRights $rightsInput
    if ($rights -eq $null -or $rights -eq 0) {
        Write-Host "Invalid or empty permissions specified." -ForegroundColor Yellow
        continue
    }

    $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::None
    $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
    if (Test-Path -Path $path -PathType Container) {
        if (Read-YesNo "Apply this rule to child objects as well? (Yes/No)") {
            $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
            $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
        }
    }

    $accessType = [System.Security.AccessControl.AccessControlType]::$typeInput
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, $rights, $inheritFlags, $propagationFlags, $accessType)
    $acl.AddAccessRule($rule)

    $continue = Read-YesNo "Add another rule? (Yes/No)"
}

Set-Acl -Path $path -AclObject $acl
Write-Host "ACL updated successfully for '$path'." -ForegroundColor Green

Write-Host "Updated access rules:" -ForegroundColor Cyan
Get-Acl -Path $path | Select-Object -ExpandProperty Access | Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited -AutoSize
