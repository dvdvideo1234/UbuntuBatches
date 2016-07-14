#!/bin/bash

bool=""

echo "This script is designed to ge run before"
echo "inserting the guest addition CD in Ubuntu VirtualBox guest."
read -p "Do you want to install this script [y/n]? : " bool

if test "$bool" == "y"
then
  read -p "Do you want to install dependancies [y/n]? : " bool
  if test "$bool" == "y"
  then
    sudo apt-get update
    sudo apt-get install linux-headers-$(uname -r)
    sudo apt-get install build-essential
    sudo apt-get install virtualbox-ose-guest-x11
    sudo apt-get install linux-virtual
    sudo apt-get install linux-lowlatency
    sudo apt-get install linux-signed-generic
  fi
  read -p "Do you want to run force-update [y/n]? : " bool
  if test "$bool" == "y"
  then
    sudo update-manager -d
    echo "Click the RESTART button in the update dialog box"
  fi
fi

exit 0
