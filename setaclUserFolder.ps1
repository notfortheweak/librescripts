$NewAcl = Get-Acl -Path Read-Host "Enter Folder Path"
#(Get-Acl -Path ").Access
# Set properties
$identity = Read-Host "Enter user"
$fileSystemRights = Read-Host "Read, ReadandExecute, Write, Modify, FullControl"
$type = Read-Host "Allow or Deny"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path Read-Host "Enter Folder Path" -AclObject $NewAcl
