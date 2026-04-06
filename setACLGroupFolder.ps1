# Prompt for the target object (file or folder path)
$path = Read-Host "Enter the full path of the file or folder to modify (e.g., C:\Folder)"

# Validate the path exists
if (-not (Test-Path -Path $path)) {
    Write-Host "Error: Path '$path' does not exist. Exiting." -ForegroundColor Red
    exit
}

# Prompt for user/group
$userOrGroup = Read-Host "Enter the user or group (e.g., 'DOMAIN\User' or 'GroupName')"

# Prompt for Allow/Deny
$typeInput = Read-Host "Enter 'Allow' or 'Deny'"
if ($typeInput -notin @('Allow', 'Deny')) {
    Write-Host "Error: Must be 'Allow' or 'Deny'. Exiting." -ForegroundColor Red
    exit
}
$type = [System.Security.AccessControl.AccessControlType]::$typeInput

# Prompt for permissions (comma-separated for multiple)
$rightsInput = Read-Host "Enter permissions (comma-separated, e.g., 'Read,Write' or 'FullControl'). Valid options: Read, ReadAndExecute, Write, Modify, FullControl"
$rightsList = $rightsInput -split ',' | ForEach-Object { $_.Trim() }

# Validate and combine permissions
$validRights = [System.Security.AccessControl.FileSystemRights].GetEnumNames()
$invalidRights = $rightsList | Where-Object { $_ -notin $validRights }
if ($invalidRights) {
    Write-Host "Error: Invalid permissions: $($invalidRights -join ', '). Valid options: $($validRights -join ', '). Exiting." -ForegroundColor Red
    exit
}
$rights = 0
foreach ($right in $rightsList) {
    $rights = $rights -bor [System.Security.AccessControl.FileSystemRights]::$right
}

# Get the current ACL
$acl = Get-Acl -Path $path

# Create and add the new rule
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($userOrGroup, $rights, $type)
$acl.AddAccessRule($rule)

# Apply the updated ACL
Set-Acl -Path $path -AclObject $acl

Write-Host "ACL updated successfully for '$path'." -ForegroundColor Green
