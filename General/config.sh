#!/bin/bash

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

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

exit 0

