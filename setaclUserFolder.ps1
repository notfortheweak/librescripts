$NewAcl = Get-Acl
#(Get-Acl -Path ").Access
# Set properties
$identity = Read-Host "Enter user"
$fileSystemRights = Read-Host "Read, ReadandExecute, Write, Modify, FullControl"
$type = Read-Host "Allow or Deny"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.AddAccessRule($fileSystemAccessRule)
Set-Acl -AclObject $NewAcl
