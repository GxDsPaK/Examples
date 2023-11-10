
#The main function presents the choices. The user would press the number representing their choice, then the if statement calls the specific function depending on the choice.
function main(){
    Write-Host("1. Check the inbox rules for a specified user")
    Write-Host("2. Add a user to a distribution list")
    Write-Host("3. Check shared mailboxes and users who have permisions to them")
    Write-Host("0. Press 0 to exit the script")
    $option=Read-Host("Choose an option: ")

    #Calling specific function based on the choice input 
    if($option -eq "1"){            
        checkRules
    }elseif($option -eq "2"){
        addToDistro
    }elseif($option -eq "3"){
        sharedMembers
    }elseif($option="0"){
        return 0        #Ends the function 
    }
    else{
        #If an invalid character is entered, the script will display an error and will restart the main function
        Write-Host("That is an invalid option, please choose again")
        main        
    }


}


#This function checks the inbox rules on the specified account and displays them. 
function checkRules(){

    $user=Read-Host("Enter the email address of the user")
    Get-InboxRule -Mailbox "$user" | Format-Table
    $choice=Read-Host("Would you like to check another user? (y/n)")
    #If the user wants to check another, the script calls this function again. Otherwise it returns to the main function.
    if($choice -eq "y"){
        checkRules
    }
    else{
        return main
    }

}

function addToDistro(){
    Get-DistributionGroup | Select-Object DisplayName, MailEnabled | Format-Table
    $distro=Read-Host("Enter the name of the distro")
    Get-DistributionGroupMember -Identity "$distro" | Format-Table
    $name=Read-Host("Check the list above to see if the user is already a member, if not enter the email of the user to be added")
    Add-DistributionGroupMember -Identity "$distro" -Member "$name"
    $checkanotherDistro=Read-Host("Would you like to check another distribution list? (y/n) ")
    if($checkanotherDistro -eq "y"){
        addToDistro
    }else{
        return main
    }
}

function sharedMembers(){
    Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | Format-Table
    $smailbox=Read-Host("Enter the email of the specific shared mailbox to check membership")
    Get-MailboxPermission -Identity "$smailbox" | Where-Object {($_.User -notlike "NT AUTHORITY\SELF")} | Select-Object Identity,User,AccessRights | Format-Table #Get a list of users who have permissions. Do not display the user called NTAUTHORITY\SELF.
    $checkAnother=Read-Host("Would you like to check another mailbox? (y/n)")
    if($checkAnother -eq "y"){
        sharedMembers
    }else{
        return main
    }
}

Connect-ExchangeOnline      #Connect to Exchange 
main        #Start the main function 