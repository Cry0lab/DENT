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



Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$InputFromUser = Read-Host -Prompt 'Ask for something'



#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#

Write-Output $UserCredential
Write-Output $InputFromUser


#Log into Exchange Server through Powershell. Run as Administrator
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Command
Set-MailboxFolderPermission "Room1:\calendar" -User Default -AccessRights LimitedDetails