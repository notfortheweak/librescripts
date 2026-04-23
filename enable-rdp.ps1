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

Write-Host "Exiting script... 'A wiseman once said nothing at all.' - Unknown Proverb"
