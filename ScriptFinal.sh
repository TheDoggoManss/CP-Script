#!/bin/bash

#This script is for use by the teams at Greenbrier High School for the Cyberpatriot competitions. This script is ment to be easy to understand and use.

#Checks if the script is running as root:
if [ "$(id -u)" != 0 ]
then
   echo "This script must be run as root. Try 'sudo -su root', enter the password, then try again." 1>&2
   exit 1
fi

###This is where all of the functions will be, the menu will be at the bottom.


#Installs nmap
nmap() {
     apt-get install nmap -y -qq
     clear
     echo "Successfuly installed nmap!"
}
#Asks the user if they would like to quickscan, scan common ports, or scan all ports. 
nmapscan() {
    echo """Scan for ports?
    1: Scan common ports (Recomended)
    2: Scan all ports (Warning: this may take a long time)"""

    read answer
        if [ $answer == 1 ]
        then
            nmap –F 192.168.0.1 >> /output/networkports.txt
            clear
            echo "Scan Complete! You can find the ports in /output/networkports.txt"
        fi

        if [ $answer == 2 ]
        then
            nmap –F 192.168.0.1 >> /output/networkports.txt
            clear
            echo "Scan Complete! You can find the ports in /output/networkports.txt"
        fi
}
#Checks if firewall is on. If not asks the user to turn it on.
firewall() {
    if [ "$(ufw status)" != Status: inactive ]
        echo "The firewall is not active, would you like to turn it on? Y or N (Recomended)"
        read answer
            if [ $answer == Y ]
                ufw enable
            elif [ $answer == N ]
                echo "Firewall not enabled"
                mainmenu
            else
                echo "Y or N"
            fi
    elif [ "$(ufw status)" != Status: active ]
        echo "The firewall is currently active."
        sleep 3s
        mainmenu
    else
        "Error reading status, try again."
        mainmenu
    fi

}

###Menus

#Main Menu

mainmenu() {
    echo """Welcome, Please select an option:
    1: Networking
    2: Services"""
    read answer
        if [ $answer == 1 ]; then
            clear
            echo """Networking:
            Please select:
            1: Install nmap
            2: Scan ports with nmap
            3: Check Firewall"""
            if [ $answer == 1 ]; then
                nmap
            elif [ $answer == 2 ]; then
                nmapscan
            elif [ $awnser == 3 ]
                firewall
            else
                echo "Please input in a number listed."
            fi            
	fi
}
mainmenu