import-module PSGit
import-module PSWindowsUpdate
import-module PackageManagement
import-module NTFSSecurity
import-module AzureAD

function prompt {
    $UserProf = $env:USERPROFILE -replace '[A-Za-z]:\\' -replace '([\\\.\(\)\{\}\?])','\$1'
    $Location = "$(Get-Location)" -replace "([A-Za-z][:\$]\\)$UserProf",'$1~' -replace '(?<=^[A-Za-z\~]:{0,1}\\([^\\~]+\\){2})([^\\~]+\\)+(?=[^\\]+\\[^\\]+$)','..\' -replace '(?<=^)C:\\~','~'
    $isAdmin  = [Security.Principal.WindowsPrincipal]::New(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole(
        [Security.Principal.WindowsBuiltinRole]::Administrator
    ) 
    if($isAdmin){
        $NameColor = "Red"
    }else{
        $NameColor = 'White'
    }
    $Domain = $env:UserDNSDomain, $env:UserDomain | 
        Sort-Object Length -Descending | 
        Select-Object -First 1
    Write-Host -ForegroundColor $NameColor "$env:USERNAME@$Domain".toLower() -NoNewline
    Write-Host -NoNewline ':'
    Write-Host -ForegroundColor DarkCyan $Location -NoNewline
    "`$$('>' * ($nestedPromptLevel)) "
    $Host.UI.RawUI.WindowTitle = "$((Get-Location).Path)>"
    "PS $($executionContext.SessionState.Path.CurrentLocation)> "
    Write-Host ("[" + (Get-Date -Format "HH:mm:ss") + "] ") -NoNewline -ForegroundColor Cyan
}
