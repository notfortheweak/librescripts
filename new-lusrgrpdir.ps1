$createuserResponse = Read-Host "Do you want to create a new user? (Y/N)"

while ($createuserResponse -eq "Y") {
    #prompt for user creds.
    $Username = Read-Host "Enter username"
    $Password = Read-Host -AsSecureString "Enter Password"
    $Description = Read-Host "Enter Description"
    New-LocalUser -Name $Username -Password $Password -Description $Description
    
    $createuserResponse = Read-Host "Do you want to create another user? (Y/N)"
}

Write-Host "User creation completed."

$Response = Read-Host "Do you want to create a new group? (Y/N)"
while ($Response -eq "Y") {
    # Ask for the group name
    $GroupName = Read-Host "Enter desired group name."

    # Attempt Group Creation
    try {
        New-LocalGroup -Name $GroupName
        Write-Host "Group '$GroupName' created successfully."
    } catch {
        Write-Error "Group creation failed: $_"
    }
    
    $Response = Read-Host "Do you want to create another group? (Y/N)"
}

Write-Host "Group creation completed."

$createNewFolder = Read-Host "Create new Folder? (Y/N)"
while ($createNewFolder -eq "Y") {
    $folderPath = Read-Host "Enter the path for the new folder"
    try {
        New-Item -Path $folderPath -ItemType Directory
        Write-Host "Folder created successfully at $folderPath"
    } catch {
        Write-Error "Folder creation failed: $_"
    }
    
    $createNewFolder = Read-Host "Create another folder? (Y/N)"
}

Write-Host "Folder creation completed."

$addUserGroup = Read-Host "Assign users to groups? (Y/N)"
while ($addUserGroup -eq "Y") {
    $targetGroup = Read-Host "Enter group name"
    
    $addAnotherUser = Read-Host "Add a user to '$targetGroup'? (Y/N)"
    while ($addAnotherUser -eq "Y") {
        $targetUser = Read-Host "Enter username to add to '$targetGroup'"
        try {
            Add-LocalGroupMember -Group $targetGroup -Member $targetUser
            Write-Host "User '$targetUser' added to group '$targetGroup' successfully."
        } catch {
            Write-Error "User group assignment failed: $_"
        }
        
        $addAnotherUser = Read-Host "Add another user to '$targetGroup'? (Y/N)"
    }
    
    $addUserGroup = Read-Host "Assign users to another group? (Y/N)"
}

Write-Host "User group assignment completed."
