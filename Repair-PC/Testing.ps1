param (
    #[Parameter(Mandatory = $true)][string]$default, #Parameter that the script will not run without getting. User will be prompted if not given
    [switch]$NoFlushDns = $false,
    [switch]$NoIPRenew = $false,
    [switch]$KeepCreds = $false,
    [switch]$SkipNetlogon = $false,
    [switch]$SkipGPOUpdate = $false,
    [switch]$NoReboot = $false
)

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
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

if (-NOT (Test-Administrator)) {
    Write-Host 'Error : Permission Denied : Elevation is required' -ForegroundColor Red
    Write-Host 'Please run this Script as Administrator' -ForegroundColor Red
    exit
}
renew-dhcp