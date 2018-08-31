<#
.SYNOPSIS
A one sentence explanation of the script.

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>


#<<<<<<<<<<<<<<<<<<<<      Functions      >>>>>>>>>>>>>>>>>>>#
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

#<<<<<<<<<<<<<<<<<<<<      Admin Check      >>>>>>>>>>>>>>>>>>>#

if (-NOT (Test-Administrator)) {
    Write-Host 'Error: Permission Denied' -ForegroundColor Red
    Write-Host 'Please run this Script as Administrator' -ForegroundColor Red
    exit
}

#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#

Set-ExecutionPolicy RemoteSigned -Force
$UserCredential = Get-Credential -Message 'Your login is (username)@arrow.org'
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
get-crt

#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#

#Log into Exchange Server through Powershell. Run as Administrator
Import-PSSession $Session

#To Set duration as unlimited, set duration hold to "Unlimited"
Get-Mailbox -Filter {LitigationHoldEnabled -eq $false} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 90