#Log into Exchange Server through Powershell. Run as Administrator
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential #Your Credentials are (username)@arrow.org
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-Mailbox -Filter {LitigationHoldEnabled -eq $false}
#Enable Litigation Hold for all accounts that don't currently have it enabled, duration 90 days
#To Set duration as unlimited, set duration hold to "Unlimited"
Get-Mailbox -Filter {LitigationHoldEnabled -eq $false} | Set-Mailbox -LitigationHoldEnabled $true -LitigationHoldDuration 90