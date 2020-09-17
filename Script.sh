#!/bin/bash
@echo off

#Installs: These are all of the necessary programs for the script

	apt-get install nmap
	apt-get install htop
	apt=get install bastille

#First steps of defense
	#Firewall
	ufw enable
	ufw logging on
	ufw logging high
	gedit /etc/ufw/before.rules
	echo "Comment all lines containing icmp and save"
	gedit /etc/ufw/before6.rules
	echo "Comment all lines containing icmp and save"
	ufw disable
	ufw enable
	ufw default deny outgoing
	ufw default deny incoming 
	
#User Accounts and Groups
	sudo gedit users
		echo "add all users to this file and save"
	sudo gedit users1
		echo "Enter the following into this file"
			echo "!/bin/bash"
			echo "for i in $(cat <PATH TO USERS>);do
			echo "-e "123QWEASDzxc!@#\n123QWEASDzxc!@#" | passwd $i"
	chmod -R 744~
	./users1
	grep ':0:' /etc/passwd #users with UID of 0
	sudo gedit /etc/passwd 
		echo "fix ID's as needed,save"
	sudo gedit /etc/group 
		echo "add and remove users from groups as needed, save"
	echo ""/var/log/auth.log
	cp /var/log/auth.log >> /auth.log
	sudo visudo
		echo "comment users that don't belong, save
#Permissions
	chmod -R 444 /var/log
	chmod 440 /etc/passwd
	chmod 440 /etc/shadow
	chmod 440 /etc/group
#Services
	service sshd stop
	service telnet stop
	service vsftpd stop 
	service snmp stop
	service pop3 stop
	service icmp stop
	service sendmail stop
	service dovecot stop
	service --status-all | grep "+"
#Quick Defenses
	sestatus
	gedit /etc/selinux/config
	echo "On oR oFf"
	setenforce enforcing
	echo ALL >>/etc/cron.deny
	gedit /etc/passwd
		echo "change root shell from "/bin/root" to "/sbin/nologin" "
	gedit /etc/pam.d/common-password
		echo "change auth line from pam_permit.so" to "pam_tally.so inerr =fail deny=3 unlock_time=108000"
	gedit /etc/fstab
		echo "add "tmpfs    /dev/shm    tmpfs defaults,noexec,nosuid 0 0""
	gedit /etc/syctl.conf
		echo """add: "net.ipv4.tcp_syncookies = 1", "net.ipv4.tcp_max_syn_backlog = 2048"
			"net.ipv4.tcp_synack_retries = 2", "net.ipv4.tcp_syn_retries = 5"
			"net.ipv4.icmp_echo_ignore_all = 1", "net.ipv4.conf.all.rp_filter = 1"
			"net.ipv4.conf.default.rp_filter = 1"
			"net.ipv4.icmp_echo_ignore_broadcasts = 1"
			"net.ipv4.conf.all.redirects = 0"
			"net.ipv4.conf.default.accept_redirects = 0" reload file with sysctl -p
			Repeat for ipv6"""
	gedit /etc/rc.d
		echo "look for processes that run on startup"
		echo "remove any provesses that do not need to run on startup"
	echo 0 > /proc/sys/net/ipv4/conf/all/arp_accept 
#Monitoring
	gedit/mnt directory
	gedit/media directory
	echo ""~/.bash_history
	gedit /etc/rc.d
	ls /lib
	ls /var/lib
#Software
