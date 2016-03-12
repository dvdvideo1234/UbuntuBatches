#!/bin/bash

# Install GParted
  wget -q -O – http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add –
  sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb apps" >> /etc/apt/sources.list'
  sudo apt-get update
  sudo apt-get install gparted
# Install Psensor
  sudo apt-get install lm-sensors
  sudo apt-get install hddtemp
  sudo dpkg-reconfigure hddtemp
  sudo sensors-detect
  sudo apt-get install psensor
# Install samba
  sudo apt-get install samba
  sudo apt-get install samba-common
  sudo apt-get install python-glade2
  sudo apt-get install system-config-samba

exit 0