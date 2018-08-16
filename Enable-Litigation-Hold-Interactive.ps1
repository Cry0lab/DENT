<#
.SYNOPSIS
Interactive Script to change the Litigation Hold Duration one, multiple, or all accounts in Exchange Server.

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
function Enable-All {
    if ($Duration -is [int]) {
        if (-NOT ($Duration = 0)) {
            Get-Mailbox -Filter {LitigationHoldEnabled -eq $false}
            #Enable Litigation Hold for all accounts that don't currently have it enabled, duration 90 days
            #To Set duration as unlimited, set duration hold to "Unlimited"
            Get-Mailbox -Filter {LitigationHoldEnabled -eq $false} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration $Duration
        }
        elseif ($Duration = 0) {

        }
    }
}

#<<<<<<<<<<<<<<<<<<<<      Variables and Interaction      >>>>>>>>>>>>>>>>>>>#

Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential #Your Credentials are (username)@arrow.org
$Duration = Read-Host -Prompt 'How many days would  you like Litigation Hold to be enabled for? (Enter 0 for Unlimited)'
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session


#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#