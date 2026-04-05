# 1  Prompt for group creation
$Response = Read-Host "Do you want to create a new group? (Y/N)"

if ($Response -eq "Y") {
    # 2. Ask for the group name
    $GroupName = Read-Host "Enter desired group name."

    # 3. Attempt Group Creation
    try {
        New-LocalGroup -Name $GroupName
        Write-Host "Group '$GroupName' created successfully."
    } catch {
        Write-Error "Group creation failed: $_"
    }
} else {
    Write-Host "Group creation canceled."
}

# 2.  Create the new local user
$Username = Read-Host "Enter username"
$Password = Read-Host -AsSecureString "Enter Password"
$Group = Read-Host "Enter user group assignment"
$Description = Read-Host "Enter Description"
New-LocalUser -Name $Username -Password $Password -Description $Description



# 3. Add the user to a group (e.g., Administrators or Users)
Add-LocalGroupMember -Group $Group -Member $Username
