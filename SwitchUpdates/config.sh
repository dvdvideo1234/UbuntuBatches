#!/bin/bash

bool=""
list=""

echo "This script is designed to be run after"
echo "installing a fresh Ubuntu system so the apt-get repos"
echo "will not fall behind in version number and updates"
echo "Sources file will be edited: /etc/apt/sources.list"
read -p "Do you want to apply this change [y/n]? : " bool

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

if test "$bool" == "y"
then
  sed -i "s@.*DEV_UPDATES=.*@DEV_UPDATES=\"YES\"@" InstallFullDB.config

  echo "Please restart the system."
fi

exit 0
