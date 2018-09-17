<#

.SYNOPSIS
    A module to automatically repair common issues on a Domain Joined Windows 10 machine.

.DESCRIPTION
    This module will accomplish the following functions in the following order unless specified not to execute:
        Flush Dns
        DHCP Renew
        Windows Credentials Flush
        Enable Netlogon Service and set to automation
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
    [switch]$NoFlushDns = $false,
    [switch]$NOIPRenew = $false,
    [switch]$KeepCreds = $false,
    [switch]$SkipNetlogon = $false,
    [switch]$SkipIEReset = $false,
    [switch]$SkipGPOUpdate = $false,
    [switch]$NoReboot = $false
)

is-static {
    #Function to return True or False depending on whether a static IP is set
}

check-module {
    param {
        [Parameter(Mandatory = $true)][string]$moduleName
    }
    Write-Host 'Veryifing that $moduleName is installed....' -ForegroundColor Yellow

    if (Get-Module -ListAvailable -Name $moduleName) {
        Write-Host 'Success: $moduleName is installed' -ForegroundColor Green
    }
    else {
        Write-Host "Failure: $moduleName does not exist" -ForegroundColor Red
        Write-Host "Installing $moduleName Module...." -ForegroundColor Yellow
        Install-Module $moduleName -force
        Write-Host "Module installed" -ForegroundColor Green
    }
}

flush-dns {
    if ($NoFlushDns) {
        Write-Host "Skipping DNS Flush" -ForegroundColor Yellow
    }
    else {
        Write-Host "Flushing DNS" -ForegroundColor Yellow
        Clear-DnsClientCache
        Write-Host "DNS Flushed" -ForegroundColor Green
    }
}

renew-dhcp {
    if ($NoIPRenew) {
        Write-Host "Skipping DHCP renewal" -ForegroundColor Yellow
    }
    elseif (is-static) {
        #Change ip and dns to dhcp from static
    }
    else {
        $ethernet = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $true}


        foreach ($lan in $ethernet) {
            Write-Host "Flushing IP addresses" -ForegroundColor Yellow
            Sleep 2
            $lan.ReleaseDHCPLease() | out-Null
            Write-Host "Renewing IP Addresses" -ForegroundColor Green
            $lan.RenewDHCPLease() | out-Null
            Write-Host "The New Ip Address is "$lan.IPAddress" with Subnet "$lan.IPSubnet"" -ForegroundColor Yellow
        }
    }
}

flush-creds {
    if (check-module "CredentialManager") {
        #Flush the Creds
    }
    else {
        #Install the Module
        #Flush the creds
    }
}

set-Netlogon {
    Set-Service -Name Netlogon -StartupType Automatic
    Start-Service -Name Netlogon
}


function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

#<<<<<<<<<<<<<<<<<<<<      Admin Check      >>>>>>>>>>>>>>>>>>>#

if (-NOT (Test-Administrator)) {
    Write-Host 'Error : Permission Denied : Elevation is required' -ForegroundColor Red
    Write-Host 'Please run this Script as Administrator' -ForegroundColor Red
    exit
}


#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#



#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#
