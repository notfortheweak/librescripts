# Define variables
$groupName = Read-Host "Enter Group Name"
$folderPath = Read-Host "Enter Folder Path"
$accessLevel = "Read" # Example: Read, Modify, FullControl, etc.
$action = "Allow" # Allow or Deny

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
