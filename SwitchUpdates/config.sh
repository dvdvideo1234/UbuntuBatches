#!/bin/bash

ldir="/etc/apt"
lapp="sources.list"
bool=""
ctry=""

echo "This script is designed to be run after"
echo "installing a fresh Ubuntu system so the apt-get repos"
echo "will not fall behind in version number and updates"
echo "Sources file will be edited: /etc/apt/sources.list"

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

read -p "Create a backup [y/N] ? " bool
if test "$bool" == "y"
then
  cp $ldir/$lapp $lapp[$(date "+%H-%M-%S_%d-%m-%y")].bak
fi

read -p "Apply modification [y/N] ? " bool
if test "$bool" == "y"
then
  sed -i "s@^deb-src@deb@" $ldir/$lapp
  sed -i "s@^deb http://.*\.ubuntu@deb http://archive\.ubuntu@" $ldir/$lapp
  apt-get update
  apt-get -f install
  sudo apt autoremove
  echo "Please restart the system."
fi

exit 0
