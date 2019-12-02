#!/bin/bash

# set -x

bool=""
action="$1"
option="$2"
verclang=""
vercmake=""
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

case "$action" in
  "install")
    read -p "Install dependencies [y/N] ? " bool
    if test "$bool" == "y"
    then
      yes y | ./dependencies.sh
    fi

    verclang=$(clang --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
    vercmake=$(cmake --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
       
    read -p "Installed CLang is version: [$verclang] > [6.0]? Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "Please install CLang 6.0 or above!"
      exit 0
    fi
    
    read -p "Installed CMake is version: [$vercmake] > [3.8]? Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "Please install CMake 3.8 or above!"
      exit 0
    fi

  ;;
  "config")

  ;;
  "paths")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  *)
    echo "Usage: $0 { install | remove | config | paths }"
  ;;
esac

exit 0
