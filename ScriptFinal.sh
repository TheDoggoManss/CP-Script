#!/bin/bash

#This script is for use by the teams at Greenbrier High School for the Cyberpatriot competitions. This script is ment to be easy to understand and use.

#Checks if the script is running as root:
if [ "$(id -u)" != 0 ]; then
   echo "This script must be run as root. Try 'sudo -su root', enter the password, then try again." 1>&2
   exit 1
fi

#Setup folders
mkdir -p ~/Desktop/Script/
chmod a+rwx ~/Desktop/Script/

mkdir -p ~/Desktop/Script/Input/
chmod a+rwx ~/Desktop/Script/Input/
touch ~/Desktop/Script/Input/AllUsers.txt
chmod a+rwx ~/Desktop/Script/Input/AllUsers.txt


###This is where all of the functions will be, the menu will be at the bottom.


#Installs nmap
nmapin() {
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
            nmap -F 192.168.0.1 -oN ~/Desktop/Script/Ports.txt
            clear
            echo "Scan Complete! You can find the ports in /media/output/networkports.txt"
            mainmenu
        fi

        if [ $answer == 2 ]; then
            nmap -p- 192.168.0.1 -oN ~/Desktop/Script/Ports.txt
            clear
            echo "Scan Complete! You can find the ports in /media/output/networkports.txt"
            mainmenu
        fi
}
#Checks if firewall is on. If not asks the user to turn it on.
firewallstat() {
    if [ "$(ufw status)" != "Status: active" ]; then
        echo "The firewall is not active, would you like to turn it on? Y or N (Y Recomended)"
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
    elif [ "$(ufw status)" != "Status: inactive" ]; then
        echo "The firewall is currently active."
        sleep 2s
        clear
        mainmenu
    else
        "Error reading status. Would you like to try to install ufw? (Recomended)"
        if [ $answer == Y ]; then
                apt-get install ufw -y -qq
                echo "ufw Installed!"
                mainmenu
            elif [ $answer == N ]; then
                echo "Canceled"
                mainmenu
            else
                echo "Y or N"
                firewall
            fi
    fi

}
#Hardens firewall
firewallhard(){
    echo "Hardening firewall..."
    ufw deny smtp 
	ufw deny pop2 
	ufw deny pop3
	ufw deny imap2 
	ufw deny imaps 
	ufw deny pop3s
	echo "smtp, pop2, pop3, imap2, imaps, and pop3s have been denied on the firewall."
    ufw deny ipp 
	ufw deny printer 
	ufw deny cups
	echo "ipp, printer, and cups have been denied on the firewall."
    ufw deny ms-sql-s 
	ufw deny ms-sql-m 
	ufw deny mysql 
	ufw deny mysql-proxy
    echo "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been denied on the firewall."
    mainmenu
}
#Check if ftp should be allowed.
ftp(){
    echo "Should FTP be allowed? (Y or N)"
    read answer
        if [ $answer == Y ]; then
            ufw deny ftp 
	        ufw deny sftp 
    	    ufw deny saft 
	        ufw deny ftps-data 
	        ufw deny ftps
    	    apt-get purge vsftpd -y -qq
	        echo "vsFTPd has been removed. ftp, sftp, saft, ftps-data, and ftps ports have been denied on the firewall."
            mainmenu
        elif [ $answer == N ]; then
            ufw allow ftp 
	        ufw allow sftp 
	        ufw allow saft 
	        ufw allow ftps-data 
	        ufw allow ftps
	        cp /etc/vsftpd/vsftpd.conf ~/Desktop/backups/
	        cp /etc/vsftpd.conf ~/Desktop/backups/
	        gedit /etc/vsftpd/vsftpd.conf&gedit /etc/vsftpd.conf
	        service vsftpd restart
            mainmenu
        else
            echo "Y or N"
            ftp
        fi
}
#Checks if telnet should be allowed.
telnet(){
    echo "Should Telnet be allowed? (Y or N)"
    read answer
        if [ $answer == Y ]; then
            ufw allow telnet 
	        ufw allow rtelnet 
	        ufw allow telnets
	        echo "Telnet is now allowed!"
            mainmenu
        elif [ $answer == N ]; then
            ufw deny telnet 
	        ufw deny rtelnet 
	        ufw deny telnets
	        apt-get purge telnet -y -qq
	        apt-get purge telnetd -y -qq
	        apt-get purge inetutils-telnetd -y -qq
	        apt-get purge telnetd-ssl -y -qq
            echo "Telnet is no more!"
            mainmenu
        else
            echo "Y or N"
            telnet
        fi
}
#ClamAV Menu
clamav(){
    echo """ClamAV
    Please Select:
    1: Install ClamAV"""
    read answer
        if [ $answer == 1 ]; then
            insclamav
        elif [ $answer == 2 ]; then
            echo "Fil"
        else
            echo "Fil"
        fi
}
#Install ClamAV
insclamav(){
    echo "Installing ClamAV and ClamTk."
    apt-get install clamav clamav-daemon -y
    echo "Stoping ClamAV service."
    systemctl stop clamav-freshclam
    echo "Installing signiture database."
    freshclam
    echo "Restarting ClamAV service."
    systemctl start clamav-freshclam

}
#Uninstall nmap
unnmap() {
    apt-get remove nmap
    clear
    echo "Successfuly uninstalled nmap!"
    mainmenu
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
#Searches for filetypes that are not allowed. (.midi,.mid,.mp3,.mpeg,etc.
filesearch(){
    echo """What filetypes would you like to be searched?
    Plese select:
    1. Audio
    2. Video
    3. Image"""
    read answer
        if [ $answer == 1 ]; then
            find / -name "*.midi" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mid" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mod" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mp3" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mp2" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mpa" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.abs" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.mpega" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.au" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.snd" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.wav" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.aiff" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.sid" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.dlac" -type f >> ~/Desktop/Script/audio.txt
            find / -name "*.ogg" -type f >> ~/Desktop/Script/audio.txt
            clear
            echo "All files found are in ~/Desktop/Script/audio.txt"
            mainmenu
        elif [ $answer == 2 ]; then
            find / -name "*.mpeg" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mpg" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mpe" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.dl" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.movie" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.movi" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mv" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.iff" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.anim5" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.anim3" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.anim7" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.avi" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.vfw" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.avx" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.fli" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.flc" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mov" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.qt" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.spl" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.swf" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.dcr" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.dxr" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.rpm" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.rm" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.smi" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.ra" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.ram" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.rv" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.wmv" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.asf" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.asx" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.wma" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.wax" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.wmv" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.wmx" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.3gp" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mov" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.mp4" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.swf" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.flv" -type f >> ~/Desktop/Script/video.txt
            find / -name "*.m4v" -type f >> ~/Desktop/Script/video.txt
            clear
            echo "All files found are in ~/Desktop/Script/video.txt"
            mainmenu
        elif [ $answer == 3 ]; then
            find / -name "*.tiff" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.tif" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.rs" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.im1" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.gif" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.jpeg" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.jpg" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.jpe" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.png" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.rgb" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.xwd" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.xpm" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.ppm" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.pbm" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.pgm" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.pcx" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.ico" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.svg" -type f >> ~/Desktop/Script/image.txt
            find / -name "*.svgc" -type f >> ~/Desktop/Script/image.txt
            clear
            echo "All files found are in ~/Desktop/Script/image.txt"
            mainmenu
        else
            echo "Y or N"
            filesearch
        fi
}
#Looks at user input file and adds users that are not listed.
usera(){
    echo """First, please input all* of the users into the AllUsers input file! :
    ******NOT THE MAIN USER******
    One user per line, all lowercase"""
    read -p "Press enter to continue"
    for i in `more ~/Desktop/Script/Input/AllUsers.txt `
    do
    echo $i
    if [ "$(grep -c $i /etc/passwd)" == 1 ]; then
        echo '  User Exists'
    else
        echo 'User does not exist, adding now...'
        sudo useradd -p $(openssl passwd -1 $PASS) $i
    fi
    done
    echo "All users are added. If you did not see any users, did you save the Users file?"
    sleep 2s
    clear
    echo "All users are added. If you did not see any users, did you save the Users file?"
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
    echo """First, please input all* of the users into the AdminUsers file! :
    ******NOT THE MAIN USER******
    One user per line, all lowercase"""
    read -p "Press enter to continue"
    for i in `more ~/Desktop/Script/Input/AllUsers.txt `
    do
    echo $i
    if [ "$(sudo -l -U $i)" ] == User $i is not allowed to run sudo on ubuntu. ]; then
        echo '  User Exists'
    else
        echo 'User does not exist, adding now...'
        sudo useradd -p $(openssl passwd -1 $PASS) $i
    fi
    done
    echo "All users are added. If you did not see any users, did you save the Users file?"
    sleep 2s
    clear
    echo "All users are added. If you did not see any users, did you save the Users file?"
    mainmenu
}

users() {
    echo """Users
    Please select:
    1. Add users
    2. Add admins
    3. Change users passwords"""
    read answer
        if [ $answer == 1 ]; then
            usera
        fi
}

checkroot() {
    echo "Are all these users supposed to be root?: (Y or N)"
    getent group sudo
    read answer
        if [ $answer == Y ]; then
            echo "Exiting to main menu..."
            mainmenu
        elif [ $answer == N ];then
            echo ""
        fi
}
###Menus

#Main Menu

mainmenu() {
    echo """Welcome, Please select an option:
    1: Networking
    2: Services
    3: Programs
    4: Files
    5: Users
    """
    read answer
        if [ $answer == 1 ]; then
            clear
            echo """Networking:
            Please select:
            1: Install nmap
            2: Scan ports with nmap
            3: Firewall
            4: 
            5: Uninstall nmap"""
            read answer
                if [ $answer == 1 ]; then
                    nmapin
                elif [ $answer == 2 ]; then
                    nmapscan
                elif [ $answer == 3 ]; then
                    echo """Firewall:
                    Please select:
                    1. Check Firewall status
                    2. Harden Firewall
                    3. FTP?
                    4. Telnet?"""
                    read answer
                        if [ $answer == 1 ]; then
                            firewallstat
                        elif [ $answer == 2 ]; then
                            firewallhard
                        elif [ $answer == 3 ]; then
                            ftp
                        elif [ $answer == 4 ]; then
                            telnet
                        else
                            echo "Y or N"
                            mainmenu
                        fi
                elif [ $awnser == 4 ]; then
                    echo"Filler"
                elif [ $awnser == 5 ]; then
                    unnmap
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
            echo """Programs:
            Please select:
            1. ClamAV"""
            read answer
                if [ $answer == 1 ]; then
                    clamav
                else
                    mainmenu
                fi
        elif [ $answer == 4 ]; then
            echo """Files:
            Please Select:
            1. Serch for files
            2. Delete files"""
            read answer
                if [ $answer == 1 ]; then
                    filesearch
                elif [ $answer == 2 ]; then
                    echo"Please manualy go through files."
		    mainmenu
                elif [ $answer == 3 ]; then
                    echo"Filler"
                elif [ $answer == 4 ]; then
                    echo"Filler"
                else
                    mainmenu
                fi
        elif [ $answer == 5 ]; then
            users

	fi
}
mainmenu
