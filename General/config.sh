#!/bin/bash

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

# Refresh PPAs
sudo apt-get autoremove && sudo apt-get autoclean

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
apt-get install samba
apt-get install samba-common
apt-get install python-glade2
apt-get install system-config-samba

# Install Gnome tweak tool
sudo apt install chrome-gnome-shell
sudo apt-get install gnome-tweak-tool

# Install Unity tweak tool
sudo apt-get install unity-webapps-common unity-tweak-tool
sudo apt-get install unity-tweak-tool

exit 0

