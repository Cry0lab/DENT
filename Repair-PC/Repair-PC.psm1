<#

.SYNOPSIS
    A module to automatically repair common issues on a Domain Joined Windows 10 machine.

.DESCRIPTION
    This module will accomplish the following functions in the following order unless specified not to execute:
        Flush Dns
        DHCP Renew
        Windows Credentials Flush
        Enable Netlogon Service and set to automatic
        Reset IE settings
        Gpupdate /force
        Reboot

.EXAMPLE
    Example

.NOTES
    General notes
#>


#<<<<<<<<<<<<<<<<<<<<      Functions and Parameters     >>>>>>>>>>>>>>>>>>>#


param (
    [Parameter(Mandatory = $true)][string]$default, #Parameter that the script will not run without getting. User will be prompted if not given
    [switch]$force = $false #switch that can be checked for later
)




<#function name {
    param ([type]$parameter1, [type]$parameter2) #Function Parameters
    #Function Body
}#>

#<<<<<<<<<<<<<<<<<<<<      Admin Check      >>>>>>>>>>>>>>>>>>>#



#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#



#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#


# switch example using $force
if ($force) {
    Write-Host 'I did the thing'
}