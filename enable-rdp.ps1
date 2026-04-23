# Check if Remote Desktop is enabled
$remoteDesktopEnabled = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections').fDenyTSConnections

if ($remoteDesktopEnabled) {
    Write-Host "Remote Desktop is currently disabled."
    $enable = Read-Host "Do you wish to enable it? (yes/no)"
    
    if ($enable.ToLower() -eq "yes") {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
        Write-Host "Remote Desktop has been enabled."
        
        # Prompt for network-level authentication
        $networkAuth = Read-Host "Do you wish to set best practice by enabling network-level authentication? (yes/no)"
        
        if ($networkAuth.ToLower() -eq "yes") {
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

# Check current RDP port
$portNumber = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').PortNumber

if ($portNumber) {
    Write-Host "RDP is currently hosted on port: $portNumber"
    
    $changePort = Read-Host "Do you wish to change the RDP port number? (yes/no)"
    
    if ($changePort.ToLower() -eq "yes") {
        $portValue = Read-Host "Enter new RDP port number:"
        
        try {
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $portValue
            Write-Host "RDP port has been changed to: $portValue"
            
            # Prompt to allow RDP through the firewall on the new port
            $allowFirewall = Read-Host "Do you wish to run the command Enable-NetFirewallRule -DisplayGroup 'Remote Desktop' to allow RDP sessions through the firewall on the new port? (yes/no)"
            
            if ($allowFirewall.ToLower() -eq "yes") {
                Set-NetFirewallPortRule -DisplayName 'Remote Desktop' -LocalPort $portValue -Protocol TCP -Action Allow
                Write-Host "RDP has been allowed through the firewall on port: $portValue."
            }
        } catch {
            Write-Error "Failed to change RDP port. Please check if you have sufficient permissions and try again."
        }
    } else {
        Write-Host "RDP port remains unchanged."
    }
}

Write-Host "Script completed. Thank you for using this script."