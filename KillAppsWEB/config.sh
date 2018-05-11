#!/bin/bash

bool=""

echo "This script kills Amazon app and common web apps"

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

read -p "Proceed with killing web apps [y/n] ? " bool
if test "$bool" = "y"
then
  apt-get purge unity-lens-shopping
  apt-get purge unity-webapps-common
else
  echo "Cave Johnson: We are done here !"
fi

