#!/bin/bash


#diaplay all options

function display_opt {
	echo "Options : "
	echo " -c or  --create  Create a new user account."
	echo " -r or  --reset   Reset password for an existing User account."
	echo " -l or  --list    List all user accounts on the system."
	echo " -h or  --help    Display help and exit."
	echo " -d or  --delete  Delete existing account"

}




#create a new user account
function create_user {
	read -p "Enter the new username:" username

	#Check if the username already exists
	if id "$username" &>/dev/null; then
		echo "Error: The username '$username' already exists. Please choose a different username."
	else
		#prompt for password
		read -sp "Enter the Password for $username: " password

		#create user account
		sudo useradd -m -p "$password" "$username"
		echo "'$username' user account created successfully."
	fi
}




#reset password

function reset_password {
	read -p "Enter the username to reset password: " username

	#check if the username exists
	if id "$username" &>/dev/null; then
		#prompt for password
		read -p "Enter the new password for $username: " password

		#set the new password
		echo "$username:$password" | sudo chpasswd
		echo "Password for user '$username' reset successfully."
	else
		echo "Error: The username '$username' does not exist. Please enter a valid username."
	fi
}




#list user

function list_user {
	echo "All user accounts on the system: "

	awk -F':' '{ print $1}' /etc/passwd
}



#delete user

function delete_user {
	read -p "Enter the username to delete: " username

	#check if the username exists
	if id "$username" &>/dev/null; then
 		sudo userdel -r "$username" # -r flag removes the user's home directory
		echo "User account '$username' deleted successfully."
	else
		echo "Error: The username '$username' does not exists. Please enter a valid username."

	fi	
}




#if loop for no arguments and -h or --help showing all options
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        display_opt
        exit 0
fi



#while loop for argument parsing

while(($#>0))
    do case "$1" in
        -c|--create) create_user;;
        -r|--reset) reset_password;;
        -l|--list) list_user;;
        -d|--delete) delete_user;;
        *) echo "Error: Invalid option '$1'. Use '--help' to see available options."
           exit 1;;
          esac
          shift
    done


