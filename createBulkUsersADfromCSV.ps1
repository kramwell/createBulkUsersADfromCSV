#Written by kramwell.com - 16/JUN/17
#Script to create bulk users in Active Directory from a csv file.

Import-Module activedirectory

#this is to check if username exists
function UserExist {
	Param(
	[string]$UserName
	)
		$UserCheck = Get-ADUser -Filter {sAMAccountName -eq $UserName}
		If ($UserCheck -eq $Null) {}
		Else {"User $UserName found in AD"}
}
#end check username exist

#this is to populate required field to create user with
function CreateUser {
	Param(
	[string]$UserName,
	[string]$Password,
	[string]$Description
	)
		$arrName = @($UserName.split('.'))
		$displayName="$arrName"
		$firstName = $arrName[0]
		$lastName = $arrName[1]
		$ScriptPath="public.bat"
		$PasswordSecure = ConvertTo-SecureString $Password -AsPlainText -Force
		$UserPrincipalName = $UserName + '@domain.local'

	#create user
	New-ADUser -Name "$displayName" -DisplayName "$displayName" -UserPrincipalName "$UserPrincipalName" -Description "$description" -GivenName "$firstName" -Surname "$lastName" -SamAccountName "$UserName" -ScriptPath "$ScriptPath" -enable $True -AccountPassword $PasswordSecure

	write-host 'user' $UserName 'created'
}
#end create user

#this is to add user to groups
function addtoGroup {
	Param(
	[string]$UserName
	)
			#Add users to the groups below.
            Add-ADGroupMember -Identity "Everybody" -Member $UserName
            Add-ADGroupMember -Identity "Internet_Group" -Member $UserName
            Add-ADGroupMember -Identity "windows7" -Member $UserName
}
#end add user to groups




write-host '-start script-' -foreground "blue"

#read csv file and get fields to populate
Import-Csv C:\Intel\powershell\csv.csv | 
    Foreach-Object {
        $Name = $_.UserName
		#create temp password based on staff ID
        $Password = "temp" + $_.staffId
        $Description = $_.staffId + " " + $_.Desc1
         
			#Check if user exists
            UserExist -u $Name #checks if username exists
            
            #create user account
			#CreateUser -u $Name -p $Password -d $Description

			
            #addtoGroup -u $Name #add to groups
            
            
    }

write-host '-end script-' -foreground "blue"