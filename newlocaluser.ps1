# 1. Create the new local user
$Username = Read-Host "Enter username"
$Password = Read-Host -AsSecureString "Enter Password"
$Group = Read-Host "Enter user group assignment"
$Description = Read-Host "Enter Description"
New-LocalUser -Name $Username -Password $Password -Description $Description

# 2. Add the user to a group (e.g., Administrators or Users)
Add-LocalGroupMember -Group $Group -Member $Username

