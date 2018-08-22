List of desired features

Parameters
    Credentials (Required)
    New Domain Name (Required)
    Current Domain Name
    Single Computer Name (Required*)
    List of Names from file (Required*)
    IP Range in CIDR notation (Required*)
    IP Range from file (Required*)
    IP Addr List from file (Required*)
    OU to add machines to
    Sequential Machine Name Change Prefix (string)
    Sequential Machine Name Change Starting Value (Must be int; default is 1)
    Export CSV Path
    Force Reboot Boolean (Default is $False)

Functions
    Verification of whether Name is already taken for Sequential Name Changes
    Check what the current Domain is, if it matches desired domain, do nothing.
    Functions to read each type of file for input information
    Function to export domain join results to csv
    Function to force machine to leave domain (remove-computer force)
    Function to join machine to Domain
    Function to move machine to correct OU
    Function to Rename machine
