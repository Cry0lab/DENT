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

#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#



Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$InputFromUser = Read-Host -Prompt 'Ask for something'



#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#

Write-Output $UserCredential
Write-Output $InputFromUser
