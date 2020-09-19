#!/bin/bash

#This script is for use by the teams at Greenbrier High School for the Cyberpatriot competitions. This script is ment to be easy to understand and use.

#Checks if the script is running as root:
if [ "$(id -u)" != 0 ]; then
   echo "This script must be run as root. Try 'sudo -su root', enter the password, then try again." 1>&2
   exit 1
fi

###This is where all of the functions will be, the menu will be at the bottom.


#Installs nmap
nmap() {
     apt-get install nmap -y -qq
     clear
     echo "Successfuly installed nmap!"
    mainmenu
}
#Asks the user if they would like to quickscan, scan common ports, or scan all ports. 
nmapscan() {
    echo """Scan for ports?
    1: Scan common ports (Recomended)
    2: Scan all ports (Warning: this may take a long time)"""

    read answer
        if [ $answer == 1 ]; then
            nmap –F 192.168.0.1 >> /media/output/networkports.txt
            clear
            echo "Scan Complete! You can find the ports in /media/output/networkports.txt"
            mainmenu
        fi

        if [ $answer == 2 ]; then
            nmap –p- 192.168.0.1 >> /media/output/networkports.txt
            clear
            echo "Scan Complete! You can find the ports in /media/output/networkports.txt"
            mainmenu
        fi
}
#Checks if firewall is on. If not asks the user to turn it on.
firewall() {
    if [ "$(ufw status)" != "Status: inactive" ]; then
        echo "The firewall is not active, would you like to turn it on? Y or N (Recomended)"
        read answer
            if [ $answer == Y ]; then
                ufw enable
                echo "Firewall enabled!"
                mainmenu
            elif [ $answer == N ]; then
                echo "Firewall not enabled"
                mainmenu
            else
                echo "Y or N"
                firewalls
            fi
    elif [ "$(ufw status)" != "Status: active" ]; then
        echo "The firewall is currently active."
        sleep 3s
        mainmenu
    else
        "Error reading status, try again."
        mainmenu
    fi

}
#Securing apache
sapache() {

    echo "Securing apache..."
    a2enmod userdir

	chown -R root:root /etc/apache2
	chown -R root:root /etc/apache

	if [ -e /etc/apache2/apache2.conf ]; then
		echo "<Directory />" >> /etc/apache2/apache2.conf
		echo "        AllowOverride None" >> /etc/apache2/apache2.conf
		echo "        Order Deny,Allow" >> /etc/apache2/apache2.conf
		echo "        Deny from all" >> /etc/apache2/apache2.conf
		echo "</Directory>" >> /etc/apache2/apache2.conf
		echo "UserDir disabled root" >> /etc/apache2/apache2.conf
	fi

	        systemctl restart apache2.service
    mainmenu
}
#These are for the changes made to user profiles on the computer.
userpwd() {
    echo "Please enter users name:"
    read username
    echo "Changing password..."
    passwd $username -$pswd
    echo "Done!"
}
useradmin() {
    echo "Please enter the user that should have administrative privilages."
    read admin

}
users() {
    echo """First we will change the passwords of all but the main user. DO NOT INPUT THE MAIN USER [EX: BALLEN]"""
    echo "Please enter a password: (Note: this will be used for all the users you change)"
    read pswd
    userpwd
    echo "Do you have another user? (Y or N)"
    read answer
        if [ $answer == Y ]; then
            userpwd
        elif [ $answer == N ]; then
            echo "Continuing to administrative users..."
            echo "You will be entering the users that are supposed to have administrative privilages."
            useradmin
        else
            echo "Y or N"
            users
        fi

}

###Menus

#Main Menu

mainmenu() {
    echo """Welcome, Please select an option:
    1: Networking
    2: Services
    3: Programs
    4: 
    5: Users
    """
    read answer
        if [ $answer == 1 ]; then
            clear
            echo """Networking:
            Please select:
            1: Install nmap
            2: Scan ports with nmap
            3: Check Firewall"""
            read answer
                if [ $answer == 1 ]; then
                    nmap
                elif [ $answer == 2 ]; then
                    nmapscan
                elif [ $answer == 3 ]; then
                    firewall
                else
                    echo "Please input in a number listed."
                    clear
                    mainmenu
                fi
        elif [ $answer == 2 ]; then
            clear
            echo """Services:
            Please select:
            1."""
            read answer
        elif [ $answer == 3 ]; then
            echo "Filler"
        elif [ $answer == 4 ]; then
            echo "Filler"
        elif [ $answer == 5 ]; then
            users

	fi
}
mainmenu