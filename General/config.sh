#!/bin/bash

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

# Add the user to sudo group
# usermod -aG sudo <user>
# /etc/sudoers
# cd /etc/sudoers.d

# Clean PPAs
apt-get autoremove
apt-get autoclean

# Install GParted
wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sh -c 'echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb apps" >> /etc/apt/sources.list'
apt-get update
apt-get install gparted

# Install Psensor
apt-get install lm-sensors
apt-get install hddtemp
dpkg-reconfigure hddtemp
sensors-detect
apt-get install psensor

# Install samba
# sudo service smbd restart
# sudo /etc/init.d/smbd restart
# sudo vim /etc/samba/smb.conf
# sudo vim /etc/fstab
# sudo ufw allow samba
# Flags: exec,user,rw,suid,nodev,nofail,x-gvfs-show
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
apt-get install cifs-utils
apt-get install python3-samba
apt-get install samba-common-bin
apt-get install samba-common
apt-get install samba-libs
apt-get install samba


# Install Gnome tweak tool
apt-add-repository ppa:webupd8team/gnome3
apt-add-repository ppa:numix/ppa
apt-get update
apt-get install chrome-gnome-shell
apt-get install gnome-shell-extensions
apt-get install gnome-tweak-tool
mkdir ~/.themes

# Install Unity tweak tool
apt-get install unity-webapps-common unity-tweak-tool
apt-get install unity-tweak-tool

# Install SSH
apt-get install ssh
ufw allow ssh

# exFAT support
apt-get install exfat-fuse
apt-get install exfat-utils

# Internet and network crap
apt-get instal net-tools

# Clean PPAs
apt-get autoremove
apt-get autoclean

exit 0

