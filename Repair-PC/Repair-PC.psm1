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
    The executable will exist on the C: Drive with a shortcut on the Desktop
.EXAMPLE
    Example

.NOTES
    General notes
#>


#<<<<<<<<<<<<<<<<<<<<      Functions and Parameters     >>>>>>>>>>>>>>>>>>>#


param (
    #    [Parameter(Mandatory = $true)][string]$default, #Parameter that the script will not run without getting. User will be prompted if not given
    [switch]$NoFlushDns = $false,
    [switch]$NoIPRenew = $false,
    [switch]$KeepCreds = $false,
    [switch]$SkipNetlogon = $false,
    [switch]$SkipGPOUpdate = $false,
    [switch]$NoReboot = $false
)

function check-module {
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

function flush-dns {
    if ($NoFlushDns) {
        Write-Host
        Write-Host "Skipping DNS Flush" -ForegroundColor Green
        Write-Host
    }
    else {
        Write-Host "Flushing DNS" -ForegroundColor Yellow
        Clear-DnsClientCache
        Write-Host "DNS Flushed" -ForegroundColor Green
    }
}

function renew-dhcp {
    if ($NoIPRenew) {
        Write-Host "Skipping DHCP renewal" -ForegroundColor Yellow
    }
    else {
        #Change ip and dns to dhcp from static
        $static_ethernet = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $false}
        foreach ($adapter in $static_ethernet) {
            Write-Host
            Write-Host "Static IP found for the following interface: "$adapter.description -ForegroundColor Red
            Write-Host "Enabling DHCP..." -ForegroundColor Yellow
            $adapter | Set-NetIPInterface -Dhcp Enabled
            Write-Host "DHCP now enabled for interface: "$adapter.description -ForegroundColor Green
            Write-Host
        }
        $ethernet = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $true}
        foreach ($lan in $ethernet) {
            Write-Host
            Write-Host "Disabling IPv6 for "$lan.description -ForegroundColor Yellow
            Disable-NetAdapterBinding -InterfaceDescription $lan.description -ComponentID ms_tcpip6
            Write-Host "Reseting DNS Servers for "$lan.description -ForegroundColor Yellow
            Start-Sleep 2
            $lan | Set-DnsClientServerAddress -ResetServerAddresses
            Start-Sleep 2
            Write-Host "Renewing IP Addresses for "$lan.description -ForegroundColor Yellow
            $lan.RenewDHCPLease() | out-Null
            Start-Sleep 2
            #$lanIP = Get-NetIPAddress -InterfaceAlias $lan.InterfaceAlias
            #Write-Host "The New Ip Address for "$lan.description" is "$lanIP.IPAddress" with Subnet " -ForegroundColor Green
            Write-Host
        }
    }
    Write-Host "Displaying Current IP Configuration: " -ForegroundColor Green
    ipconfig.exe
    Write-Host "Script will continue repair in 5 seconds..." -ForegroundColor Green
    Start-Sleep 5
    Write-Host

}

function flush-creds {
    cmdkey /list | ForEach-Object {if ($_ -like "*Ziel:*") {cmdkey /del:($_ -replace " ", "" -replace "Ziel:", "")}}
}

function set-Netlogon {
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
