#!/bin/bash

bool=""
sisy=$(echo $(uname -a))

echo "This script is designed to be run before inserting the Guest Addition CD in Ubuntu VirtualBox system."
echo "Your system: $sisy"
read -p "Do you want to install this software [y/N]? : " bool

if test "$bool" == "y"
then
  read -p "Do you want to install dependencies [y/N]? : " bool
  if test "$bool" == "y"
  then
    sudo apt-get update
    sudo apt-get install linux-headers-$(uname -r)
    sudo apt-get install build-essential dkms
    sudo apt-get install linux-virtual
    sudo apt-get install virtualbox-guest-x11
    sudo apt-get install virtualbox-guest-dkms 
    sudo apt-get install virtualbox-guest-utils
    sudo apt-get install virtualbox-ose-guest-x11
    sudo apt-get install linux-signed-generic
    
    read -p "Do you want to run package-update [y/N]? : " bool
    if test "$bool" == "y"
    then
      echo "The following packages have upgrade option ..."
      sudo apt list --upgradable
      
      read -p "Start package upgrade [y/N]? : " bool
      if test "$bool" == "y"
      then
        echo "Upgrading package list ..."
        sudo apt upgrade
      fi  
      
      read -p "Reboot the system [y/N]? : " bool
      if test "$bool" == "y"
      then
        echo "Rebooting ..."
        reboot
      fi  
    fi  
  fi
  
  read -p "Do you want to run force-update [y/N]? : " bool
  if test "$bool" == "y"
  then
    sudo update-manager -d
    echo "Click the RESTART button in the update dialog box"
  fi
  
  echo "Proceed with installing Guest Additions CD .."
else
  read -p "Run auto cleanup [y/N]? : " bool
  if test "$bool" == "y"
  then
    sudo apt-get autoremove
    sudo apt-get autoclean
  fi
  
  read -p "Restart clipboard [y/N]? : " bool
  if test "$bool" == "y"
  then
    sudo pkill 'VBoxClient --clipboard' -f & sleep 1 && VBoxClient --clipboard
  fi
fi

exit 0
