#!/bin/bash
@echo off

#This script is for use by the teams at Greenbrier High School for the Cyberpatriot competitions. This script is ment to be easy to understand and use.

#Checks if the script is running as root:
if [[ $EUID -ne 0 ]]
then
    echo -e "This script MUST be run as root, try putting \033[31msudo\e[0m before the command."
    exit
fi

###This is where all of the functions will be, the menu will be at the bottom.


#Installs nmap and asks the user if they would like to quickscan, scan common, or scan all ports.
function nmap() 
{
     apt-get install nmap -y -qq
     clear
     echo "Successfuly installed nmap!"
}
function nmapscan() 
{
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