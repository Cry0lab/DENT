<#

.SYNOPSIS
    A one sentence explanation of the script.

.DESCRIPTION
    Long description

.EXAMPLES
    Example

.NOTES
    General notes
#>


#<<<<<<<<<<<<<<<<<<<<      Functions and Parameters     >>>>>>>>>>>>>>>>>>>#

param (
    [string]$server = "http://defaultserver", #Parameter of -server with a default value
    [Parameter(Mandatory = $true)][string]$default, #Parameter that the script will not run without getting. User will be prompted if not given
    [switch]$force = $false #switch that can be checked for later
)

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
Write-Output $server
Write-Output $default

if ($force){
    Write-Host 'I did the thing'
}