#!/bin/bash

action="$1"
option="$2"
vcmake=""
pcmake=""
bool=""

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

case "$action" in
  "install")
    if test "$option" != ""
    then
      wget https://github.com/Kitware/CMake/releases/download/v$option/cmake-$option.tar.gz
      tar -zxvf cmake-$option.tar.gz
      cd cmake-$option
      ./bootstrap
      make
      make install
      
      vcmake=$(cmake --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
      pcmake=$(which cmake)
      
      echo "Congratolations installing CMake!"
      echo "Version : $vcmake"
      echo "Location: $pcmake"
    else
      echo "Provide desired version to be installed!"
    fi
  ;;
  "remove")
    echo "This will delete the CMake from the system !!!"
    read -p "Continue with this process [y/N] ? " bool
    if test "$bool" == "y"
    then
      sudo apt purge cmake
    fi
  ;;
  "paths")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  *)
    echo "Please use some of the options in the list below for [./config.sh]."
    echo "install <ver> --> Installed the user specified version."
    echo "remove        --> Purges the packet from the system."
    echo "paths         --> Displays the paths used by the installation."
  ;;
esac

exit 0
