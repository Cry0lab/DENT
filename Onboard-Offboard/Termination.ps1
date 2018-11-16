<#

.SYNOPSIS
    A one sentence explanation of the script.

.DESCRIPTION
    Search AD for User
    Disable User in AD
    Remove from all Groups with an email associated with them
    Do emails need to be shared?
        |->Yes
            |-> Convert to Shared Mailbox
                Share with user(s)
                Edit Description to include 'Shared Mailbox - Terminated Date'
                Move to Shared Mailboxes OU
        |->No
            |-> Edit Description to include 'Terminated Date'
                Move to Disabled Users
    Remove O365 License
    Remove Azure App Access

.EXAMPLE
    Example

.NOTES
    General notes
#>


#<<<<<<<<<<<<<<<<<<<<      Functions and Parameters     >>>>>>>>>>>>>>>>>>>#

<#
param (
    [string]$server = "http://defaultserver", #Parameter of -server with a default value
    [Parameter(Mandatory = $true)][string]$default, #Parameter that the script will not run without getting. User will be prompted if not given
    [switch]$force = $false #switch that can be checked for later
)
#>

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

<#function name {
    param ([type]$parameter1, [type]$parameter2) #Function Parameters
    #Function Body
}#>

#<<<<<<<<<<<<<<<<<<<<      Admin Check      >>>>>>>>>>>>>>>>>>>#

if (-NOT (Test-Administrator)) {
    Write-Host 'Error : Permission Denied : Elevation is required' -ForegroundColor Red
    Write-Host 'Please run as Administrator' -ForegroundColor Red
    exit
}

#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#

#$UserCredential = Get-Credential
$EmployeeSearch = Read-Host -Prompt 'Enter the Last Name of the User'

#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#
Set-ExecutionPolicy RemoteSigned
#Write-Output $UserCredential
Write-Output $EmployeeSearch
$Employee = Get-ADuser -Filter {SurName -eq $EmployeeSearch} | Select-Object givenName, Surname, name, DistinguishedName, SamAccountName, l
Write-Output $Employee
foreach ($person in $Employee) {
    Write-Host "Name: "$person.name
    Write-Host "Username: "$person.SamAccountName
    Write-Host "Location: "$person.l
    Write-Host
}

#Write-Output $server
#Write-Output $default