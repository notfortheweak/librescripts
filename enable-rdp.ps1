# Check if Remote Desktop is enabled
$remoteDesktopEnabled = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections').fDenyTSConnections
if ($remoteDesktopEnabled) {
    Write-Host "Remote Desktop is currently disabled."
    $enable = Read-Host "Do you wish to enable it? (y/n)"
    
    if ($enable.ToLower() -eq "y") {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
        Write-Host "Remote Desktop has been enabled."
        
        # Prompt for network-level authentication
        $networkAuth = Read-Host "Enable network-level authentication? (y/n)"
        
        if ($networkAuth.ToLower() -eq "y") {
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name 'UserAuthentication' -Value 1
            Write-Host "Network-level authentication has been enabled."
        }
    } else {
        Write-Host "Remote Desktop remains disabled."
    }
} else {
    Write-Host "Remote Desktop is already enabled."
}
# Display the current registry values
$rdpSettings = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
$fDenyTSConnectionsValue = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections').fDenyTSConnections
Write-Host "Current Remote Desktop settings:"
Write-Host "fDenyTSConnections: $fDenyTSConnectionsValue"
$rdpTcpSettings = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp'
$userAuthValue = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name 'UserAuthentication').UserAuthentication
Write-Host "RDP-Tcp settings:"
Write-Host "UserAuthentication: $userAuthValue"
# Display current firewall rules for Remote Desktop Protocol
$rdpFirewallRules = Get-NetFirewallRule -DisplayGroup "Remote Desktop"
if ($rdpFirewallRules.Count -eq 0) {
    Write-Host "No firewall rules are currently configured for Remote Desktop."
} else {
    Write-Host "Current firewall rules for Remote Desktop:"
    $rdpFirewallRules | Format-Table -AutoSize
}

# Prompt to allow RDP through the firewall
$allowFirewall = Read-Host "Do you wish to run the command Enable-NetFirewallRules -DisplayGroup 'Remote Desktop' to allow RDP sessions through the firewall? (y/n)"
if ($allowFirewall.ToLower() -eq "y") {
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Write-Host "RDP has been allowed through the firewall."
} else {
    $exitScript = Read-Host "Do you wish to exit the script? (y/n)"
    
    if ($exitScript.ToLower() -eq "y") {
        Write-Host "Exiting script..."
        exit
    }
}
# Add users to Remote Desktop Users group
$addUsers = Read-Host "Do you wish to add users to the Remote Desktop Users group? (y/n)"
if ($addUsers.ToLower() -eq "y") {
    do {
        $username = Read-Host "Enter the username of the user to add (or type 'exit' to finish):"
        
        if ($username.ToLower() -eq "exit") {
            break
        }
        
        # Check if the user exists in local users
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            Add-LocalGroupMember -Group "Remote Desktop Users" -Member $username
            Write-Host "$username has been added to the Remote Desktop Users group."
        } else {
            Write-Host "The user $username does not exist. Please check the username and try again."
        }
        
        # Ask if they want to add another user
        $addAnother = Read-Host "Do you wish to add another user? (y/n)"
    } while ($addAnother.ToLower() -eq "y")
}
Write-Host "Exiting script... 'A wiseman once said nothing at all.' - Unknown Proverb"
