#!/bin/bash

bool=""

echo "This script refreshes an Unity/Compris installation"
echo "if the taskbar fails to appear at startup and you end up"
echo "with just a wallpaper and nothing else."
echo "First thing you need to do is right-click the wallpaper"
echo "and click /Open Terminal/ then you run the code below."

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

read -p "Proceed refreshing Unity as it was just installed [y/n] ? " bool

if test "$bool" = "y"
then
  # Refresh Compris
  rm -fr ~/.cache/compizconfig-1
  rm -fr ~/.compiz
  # Fix the not loading session
  rm -fr ~/.Xauthority
  rm -fr ~/.config/autostart
  # Reinstall Compris
  apt-get install --reinstall ubuntu-desktop unity compizconfig-settings-manager upstart
  # Clear Unity desktop
  dconf reset -f /org/compiz/
  setsid unity
else
  echo "Cave Jhonson: We are done here !"
fi

