#!/bin/bash

bool=""

echo "This script is designed to ge run before"
echo "inserting the Guest Addition CD in Ubuntu VirtualBox system."
read -p "Do you want to install this software [y/n]? : " bool

if test "$bool" == "y"
then
  read -p "Do you want to install dependancies [y/n]? : " bool
  if test "$bool" == "y"
  then
    apt-get update
    apt-get install linux-headers-$(uname -r)
    apt-get install build-essential dkms
    apt-get install linux-virtual
    apt-get install virtualbox-ose-guest-x11
    apt-get install virtualbox-guest-dkms 
    apt-get install linux-signed-generic
  fi
  read -p "Do you want to run force-update [y/n]? : " bool
  if test "$bool" == "y"
  then
    update-manager -d
    echo "Click the RESTART button in the update dialog box"
  fi
  echo "Proceed with installing Guest Additions CD .."
fi

exit 0
