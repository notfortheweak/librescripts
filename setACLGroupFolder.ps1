# This script sets ACL permissions for a specified group on a folder.
$groupName = Read-Host "Enter Group Name"
$folderPath = Read-Host "Enter Folder Path"
$accessLevel = Read-Host "Read, ReadandExecute, Write, Modify, FullControl"
$action = Read-Host "Allow or Deny"

# Create a new FileSystemAccessRule object
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $groupName,
    $accessLevel,
    "ContainerInherit,ObjectInherit", # Inheritance flags
    "None", # Propagation flags
    $action
)

# Get the current ACL for the folder
$acl = Get-Acl -Path $folderPath

# Add the new access rule
$acl.AddAccessRule($accessRule)

# Set the modified ACL back to the folder
Set-Acl -Path $folderPath -AclObject $acl