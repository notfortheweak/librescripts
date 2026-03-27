# Define the path to the folder you want to modify
$FolderPath = ""

# Define the name of the group you want to grant permissions to
$GroupName = ""

# Get the existing ACL for the folder
$Acl = Get-Acl -Path $FolderPath

# Create a new access rule that grants full control to the specified group
$AccessRule = New-Object
System.Security.AccessControl.FileSystemAccessRule($GroupName,
"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")

# Add the access rule to the ACL
$Acl.AddAccessRule($AccessRule)

# Set the modified ACL back on the folder
Set-Acl -Path $FolderPath -AclObject $Acl

Write-Host "Full control has been granted to the group '$GroupName' for the
folder '$FolderPath'."
