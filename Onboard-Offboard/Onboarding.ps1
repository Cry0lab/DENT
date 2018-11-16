<#

.SYNOPSIS
    A one sentence explanation of the script.

.DESCRIPTION
    Information Collected
    |-> First Name
        Last Name
        Location and Department (Dropdown)
        Fax Access? (Multiple Choice)

    Cycle through existing users until one is open for the username
    Create User with Name and EV1 password, set to change next login
    Assign email address based on name
    Assign Address, Fax, and Phone based on Location/Department
    Assign description based on Title/Location
    Fill in Organization, Title, Office, Web Page, Department
    Assign Groups and Distribution based on Model account based on Location/Department
    Move to OU based on Description
    Sync with Azure
    Assign Licsense
    Give Fax Memberships
    Add zoom basic


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

$UserCredential = Get-Credential
$InputFromUser = Read-Host -Prompt 'Ask for something'

#<<<<<<<<<<<<<<<<<<<<      Script Body      >>>>>>>>>>>>>>>>>>>#
Set-ExecutionPolicy RemoteSigned
Write-Output $UserCredential
Write-Output $InputFromUser
Write-Output $server
Write-Output $default

# switch example using $force
if ($force) {
    Write-Host 'I did the thing'
}


#Create Window
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'ACFM Onboarding Employee Script'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
$main_form.ShowDialog()

#Create Label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "AD users"
$Label.Location = New-Object System.Drawing.Point(0, 10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

#Create Dropdown menu with all Ad Users
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 300
$Users = get-aduser -filter * -Properties SamAccountName
Foreach ($User in $Users) {
    $ComboBox.Items.Add($User.SamAccountName);
}
$ComboBox.Location = New-Object System.Drawing.Point(60, 10)
$main_form.Controls.Add($ComboBox)

#Create new label
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Last Password Set:"
$Label2.Location = New-Object System.Drawing.Point(0, 40)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)

#Create Empty label for Button Click
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = ""
$Label3.Location = New-Object System.Drawing.Point(110, 40)
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)

#Create button
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400, 10)
$Button.Size = New-Object System.Drawing.Size(120, 23)
$Button.Text = "Check"
$main_form.Controls.Add($Button)

#Control the Button Click
$Button.Add_Click(
    {
        $Label3.Text = [datetime]::FromFileTime((Get-ADUser -identity $ComboBox.selectedItem -Properties pwdLastSet).pwdLastSet).ToString('MM dd yy : hh ss')
    }
)