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

function name {
    param ([type]$parameter1, [type]$parameter2) #Function Parameters
    #Function Body
}

#<<<<<<<<<<<<<<<<<<<<      Admin Check      >>>>>>>>>>>>>>>>>>>#

if (-NOT (Test-Administrator)) {
    Write-Host 'Error: Permission Denied' -ForegroundColor Red
    Write-Host 'Please run this Script as Administrator' -ForegroundColor Red
    exit
}

#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#

$UserCredential = Get-Credential
$InputFromUser = Read-Host -Prompt 'Ask for something'

#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#
Set-ExecutionPolicy RemoteSigned
Write-Output $UserCredential
Write-Output $InputFromUser
