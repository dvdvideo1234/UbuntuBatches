#!/bin/bash

# Upgrading ASRock BMC
# 0. Stop all extensions and addons
# 1. Log in to BMC
# 2. Open Chrome Dev Tools
# 3. Switch to Application tab. Expand "Cookies" and click the appropriate domain name for your server.
# 4. At the end of the existing cookie list, double click the empty spot. Enter "WebServer" under name.
# 5. Should be good to go now.
# 6. Enter update node and chose file

# Add the user to sudo group
# usermod -aG sudo <user>
# /etc/sudoers
# cd /etc/sudoers.d

sudo apt-get install curl
sudo apt-get install vim
sudo apt-get install git
git config --global core.editor "vim"

# Clean PPAs
sudo apt-get autoremove
sudo apt-get autoclean

# Install GParted
sudo wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb apps" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get install gparted

# Install Psensor
sudo apt-get install lm-sensors
sudo apt-get install hddtemp
sudo dpkg-reconfigure hddtemp
sudo sensors-detect
sudo apt-get install psensor

# Configure swapiness
# Start swapping on <swappiness>% free RAM remaining
# vm.swappiness = <swappiness>
# sudo vim /etc/sysctl.conf
# sysctl vm.swappiness
sudo sysctl vm.swappiness=10

# Install samba
# sudo service smbd restart
# sudo /etc/init.d/smbd restart
# sudo vim /etc/samba/smb.conf
# sudo vim /etc/fstab
# For obtaining `<uid>` must be run
# sudo grep ^"$USER" /etc/group
# This outputs user setting <user>:x:<uid>:
# Flags: rw,user,uid=<uid>,suid,nodev,nofail,exec,x-gvfs-show
# [Data]
#    path           = /mnt/Data
#    available      = yes
#    read only      = no
#    browsable      = yes
#    public         = yes
#    writable       = yes
#    create mask    = 0777
#    directory mask = 0777
#    force user     = <user>
#    valid users    = <user>
#    guest ok       = yes
# When Icon is not shown in the windows network
# netbios name     = PC_%h
# name resolve order = lmhosts host wins bcast
# cat /proc/sys/net/ipv6/conf/all/disable_ipv6
# sudo sysctl -p
# net.ipv6.conf.all.disable_ipv6 = 1
# net.ipv6.conf.default.disable_ipv6 = 1
# net.ipv6.conf.lo.disable_ipv6 = 1
# sudo service nmbd start
# sudo systemctl restart nmbd
# Add the samva IP to hosts
# cat /etc/hosts
# 127.0.0.1       localhost
sudo apt-get install cifs-utils
sudo apt-get install python3-samba
sudo apt-get install samba-common-bin
sudo apt-get install samba-common
sudo apt-get install samba-libs
sudo apt-get install samba
sudo ufw allow samba

# Enable suspend and hibernation
# sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
# Disable suspend and hibernation
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# Hibernation status
sudo systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
# Apply changes
sudo systemctl restart systemd-logind.service

# Install Gnome tweak tool
sudo apt-add-repository ppa:webupd8team/gnome3
sudo apt-add-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install chrome-gnome-shell
sudo apt-get install gnome-shell-extensions
sudo apt-get install gnome-tweak-tool
sudo mkdir ~/.themes

# Install Unity tweak tool
sudo apt-get install unity-webapps-common unity-tweak-tool
sudo apt-get install unity-tweak-tool

# Install SSH
sudo apt-get install ssh
sudo ufw allow ssh

# exFAT support
sudo apt-get install exfat-fuse
sudo apt-get install exfat-utils

# Internet and network crap
sudo apt-get instal net-tools

# Clean PPAs
sudo apt-get autoremove
sudo apt-get autoclean

exit 0
