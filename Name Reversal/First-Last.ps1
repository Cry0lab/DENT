#Get all AD Users
$Users = Get-ADUser -SearchBase "OU=Users,OU=Arrow,DC=arrow,DC=org" -Filter {(GivenName -Like "*") -And (Surname -Like "*")} -Properties DisplayName | Select-Object DisplayName, givenName, Surname, name, DistinguishedName

#Cycle through each AD User
ForEach ($User In $Users) {

    #Gather Information about User
    $DN = $User.DistinguishedName
    $First = $User.givenName
    $Last = $User.Surname
    $CN = $User.name
    $Display = $User.DisplayName
    $NewName = "$First" + " " + "$Last"

    #Debug Print Outs
    Write-Output "Current Display Name is $Display"
    Write-Output "Current CN is $CN"

    #If the Current Display Name is not the New Name, change it to the New Name
    If ($Display -ne $NewName) {Set-ADUser -Identity $DN -DisplayName $NewName}
    #If the Current CN is not the New Name, change it to the New Name
    If ($CN -ne $NewName) {Rename-ADObject -Identity $DN -NewName $NewName}

}

#Debug Print Outs
$Users = Get-ADUser -SearchBase "OU=Users,OU=Arrow,DC=arrow,DC=org" -Filter {(GivenName -Like "*") -And (Surname -Like "*")} -Properties DisplayName | Select-Object DisplayName, givenName, Surname, name, DistinguishedName
ForEach ($User In $Users) {
    $CN = $User.name
    $Display = $User.DisplayName
    Write-Output "New Display Name is $Display"
    Write-Output "New CN is $CN"
}