#!/bin/bashsudo

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

# Refresh PPAs
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
# /etc/init.d/smbd restart
# /etc/samba/smb.conf
apt-get install samba
apt-get install samba-common
apt-get install python-glade2
apt-get install system-config-samba

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
apt-get exfat-fuse
apt-get exfat-utils

exit 0

