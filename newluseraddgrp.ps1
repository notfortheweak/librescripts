#prompt for user creation.
$createuserResponse = Read-Host "Do you want to create a new user? (Y/N)"

if ($createuserResponse -eq "Y") {
    #prompt for user creds.
    $Username = Read-Host "Enter username"
    $Password = Read-Host -AsSecureString "Enter Password"
    $Description = Read-Host "Enter Description"
    New-LocalUser -Name $Username -Password $Password -Description $Description
}
 else {
    Write-Host "User creation skipped."
}

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


$addUserGroup = Read-Host "Assign users to groups? (Y/N)"
if ($addUserGroup -eq "Y") {
    $targetUser = Read-Host "Enter desired username"
    $targetGroup = Read-Host "Enter group name"
    try {
        Add-LocalGroupMember -Group $targetGroup -Member $targetUser
    } catch {
      Write-Error "User group  assignment failed: $_"
    }
} else {
    Write-Host "Exiting..."
}
