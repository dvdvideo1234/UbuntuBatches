#!/bin/bash

# Based on https://github.com/cmangos/issues/wiki/Installation-Instructions


action="$1"

bool=""
proxysv=""

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

# Title names
nmtitle[0]="Vanilla"
nmtitle[1]="The burning crusade (TBC)"
nmtitle[2]="Wrath of the lich king (WoTLK)"
nmtitle[3]="Cataclysm"
# Chosen title ID
idtitle=""

case "$action" in
  "update")
    echo "Updating package ..."
    cd $scriptpath/$config/$projdir
    sudo make distclean
    git pull
    ./configure
    sudo make
    sudo checkinstall
  ;;
  "install")
    echo "Which title do you want to install:"

    for (( i=0; i<=$(( ${#nmtitle[*]} -1 )); i++ ))
    do
        echo "$i >> ${nmtitle[$i]}"
    done
    read -p "Enter tiltle ID: " idtitle

    if [[ -z "${nmtitle[$idtitle]}" ]]
    then
      echo "Wrong title ID: $idtitle"
      exit 0
    fi

    echo "Installing package [${nmtitle[$idtitle]}] ..."

    read -p "Install dependancies [y or n] ? " bool
    if test "$bool" == "y"
    then
      sudo apt-get update
      # Dependancies
      sudo apt-get install build-essential
      sudo apt-get install gcc
      sudo apt-get install g++
      sudo apt-get install automake
      sudo apt-get install git-core
      sudo apt-get install autoconf
      sudo apt-get install make
      sudo apt-get install patch
      sudo apt-get install libmysql++-dev
      sudo apt-get install mysql-server
      sudo apt-get install libtool
      sudo apt-get install libssl-dev
      sudo apt-get install grep
      sudo apt-get install binutils
      sudo apt-get install zlibc
      sudo apt-get install libc6
      sudo apt-get install libbz2-dev
      sudo apt-get install cmake
      sudo apt-get install subversion
      sudo apt-get install libboost-all-dev
    fi

    # Set the proxy if any
    echo "Are you using a proxy [no or <proxy:port>]  ?"
    read -r proxysv

    if test "$proxysv" == "no"
    then
      sudo git config --global -l
      sudo git config --global --unset http.proxy
    else
      sudo git config --global http.proxy "$proxysv"
      echo "Proxy set to [$proxysv] !"
    fi

    if [ 1 -eq 0 ]; then #comment

    case "$idtitle" in
    "0")
      git clone https://github.com/cmangos/mangos-classic.git $scriptpath/mangos
      git clone https://github.com/ACID-Scripts/Classic.git $scriptpath/acid
    ;;
    "1")
      git clone https://github.com/cmangos/mangos-tbc.git $scriptpath/mangos
      git clone https://github.com/ACID-Scripts/TBC.git $scriptpath/acid
    ;;
    "2")
      git clone https://github.com/cmangos/mangos-wotlk.git $scriptpath/mangos
      git clone https://github.com/ACID-Scripts/WOTLK.git $scriptpath/acid
      git clone https://github.com/unified-db/Database.git $scriptpath/unifieddb
    ;;
    "3")
      git clone https://github.com/cmangos/mangos-cata.git $scriptpath/mangos
      git clone https://github.com/ACID-Scripts/CATA.git $scriptpath/acid
      git clone https://github.com/UDB-434/Database.git $scriptpath/unifieddb
    ;;
    esac

    read -p "Do you want to intall a boost package [y or n] ? " bool
    if test "$bool" == "y"
    then
      sudo apt-get install libboost-all-dev
    fi

    # Build the thing
    mkdir $scriptpath/build
       cd $scriptpath/build
    cmake ../mangos

  ;;
  "remove")
    echo "Removing package ..."
    sudo apt-get remove $srvname
    sudo update-rc.d -f $srvname remove
    sudo rm /etc/init.d/$srvname
    sudo rm -r $scriptpath/$config
  ;;
  "config")
    echo "Opening settings ..."
    sudo gedit $scriptpath/$config/minidlna.conf
  ;;
  "stats")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
    echo "SRVN: $srvname"
    echo "Conf: $config"
    echo "Proj: $projdir"
  ;;
  *)
    echo "Usage: $0 { update | install | remove | config | stats }"
  ;;
esac

exit 0