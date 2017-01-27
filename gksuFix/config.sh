#!/bin/bash

bool=""
param="$1"

echo "This script problems with gksu"

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

read -p "Proceed fixing gksu on the selcted display [y/n] ? " bool

if test "$bool" = "y"
then
  rm -f ~/.Xauthority
  touch ~/.Xauthority
  export DISPLAY=:$param
  apt-get purge gksu
  apt-get install gksu
else
  echo "Cave Jhonson: We are done here !"
fi

