
function getUser{
    $userList=@(Get-MgUser -All)
    foreach ($user in $userList){
        Write-Host $user.DisplayName
    }

    $name=Read-Host ("Enter the name of the user to edit")

    foreach ($user in $userList){
        if ($user.DisplayName.Contains($name)){
            $selectedUser=$user
        }
    }
    Write-Host $selectedUser.DisplayName, $selectedUser.UserPrincipalName
    return $selectedUser
}

function disableUser{
    param (
        $selectedUser
    )
    $share=Read-Host "Convert the mailbox to a shared? (Y/N)"
    if ($share -eq "Y" -or "y"){
        Connect-ExchangeOnline
        Set-Mailbox -Identity $selectedUser.UserPrincipalName -HiddenFromAddressListsEnabled:$true
        Set-Mailbox -Identity $selectedUser.UserPrincipalName -Type Shared
        Disconnect-ExchangeOnline
    }
    Update-MgUser -UserId $selectedUser.Id -AccountEnabled:$false
    $license= Get-MgUserLicenseDetail -UserId $selectedUser.Id 
    Set-MgUserLicense -UserId $selectedUser.Id -AddLicenses @() -RemoveLicenses @($license.SkuId)
}


Connect-MGGraph -Scopes "User.ReadWrite.All"
$selectedUser=getUser
disableUser($selectedUser)
Disconnect-MgGraph
Write-Host "Done"