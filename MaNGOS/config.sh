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
  "start")
    $scriptpath/run/bin/mangosd -c $scriptpath/run/mangosd.conf -a $scriptpath/run/ahbot.conf
    $scriptpath/run/bin/realmd  -c $scriptpath/run/realmd.conf
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

    read -p "Are you using a proxy [n or <proxy:port>] ? " proxysv
    if test "$proxysv" == "n"
    then
      sudo git config --global -l
      sudo git config --global --unset http.proxy
    else
      sudo git config --global http.proxy "$proxysv"
      echo "Proxy set to [$proxysv] !"
    fi

    read -p "Do you wish to download the sources now [y or n] ? " bool
    if test "$bool" == "y"
    then
      cd $scriptpath
      sudo rm -rf mangos
      sudo rm -rf acid
      sudo rm -rf db
      case "$idtitle" in
      "0")
        sudo git clone https://github.com/cmangos/mangos-classic.git $scriptpath/mangos
        sudo git clone https://github.com/ACID-Scripts/Classic.git $scriptpath/acid
        sudo git clone https://github.com/classicdb/database.git $scriptpath/db
      ;;
      "1")
        sudo git clone https://github.com/cmangos/mangos-tbc.git $scriptpath/mangos
        sudo git clone https://github.com/ACID-Scripts/TBC.git $scriptpath/acid
        sudo git clone https://github.com/TBC-DB/Database.git $scriptpath/db
      ;;
      "2")
        sudo git clone https://github.com/cmangos/mangos-wotlk.git $scriptpath/mangos
        sudo git clone https://github.com/ACID-Scripts/WOTLK.git $scriptpath/acid
        sudo git clone https://github.com/unified-db/Database.git $scriptpath/db
      ;;
      "3")
        sudo git clone https://github.com/cmangos/mangos-cata.git $scriptpath/mangos
        sudo git clone https://github.com/ACID-Scripts/CATA.git $scriptpath/acid
        sudo git clone https://github.com/UDB-434/Database.git $scriptpath/db
      ;;
      esac
    fi

    read -p "Do you want to intall a boost package [y or n] ? " bool
    if test "$bool" == "y"
    then
      sudo apt-get install libboost-all-dev
    fi

    read -p "Do you want to build the source now [y or n] ? " bool
    if test "$bool" == "y"
    then
      sudo rm -rf $scriptpath/build
      sudo mkdir $scriptpath/build
           cd $scriptpath/build
        cmake ../mangos -DCMAKE_INSTALL_PREFIX=$scriptpath/run -DPCH=1 -DDEBUG=0
         make
         make install
    fi

    echo "Installing configuation files. Default is located in $scriptpath/run/etc !"
    sudo cp $scriptpath/mangos/src/mangosd/mangosd.conf.dist.in $scriptpath/run/mangosd.conf
    sudo cp $scriptpath/mangos/src/realmd/realmd.conf.dist.in $scriptpath/run/realmd.conf
    sudo cp $scriptpath/mangos/src/game/AuctionHouseBot/ahbot.conf.dist.in $scriptpath/run/ahbot.conf

    read -p "Execute database command [n or create/drop] ? " bool
    if test "$bool" != "n"
    then
      case "$bool" in
      "create")
        mysql -uroot -p < $scriptpath/mangos/sql/create/db_create_mysql.sql
      ;;
      "drop")
        mysql -uroot -p < $scriptpath/mangos/sql/create/db_drop_mysql.sql
      ;;
      esac
    fi

    read -p "Do you want to initialize databases [y or n] ? " bool
    if test "$bool" == "y"
    then
      mysql -uroot -p mangos < $scriptpath/mangos/sql/base/mangos.sql
      mysql -uroot -p characters < $scriptpath/mangos/sql/base/characters.sql
      mysql -uroot -p realmd < $scriptpath/mangos/sql/base/realmd.sql
    fi

    read -p "Do you want to populate the database [y or n] ? " bool
    if test "$bool" == "y"
    then
      case "$idtitle" in
      "0")
      ;;
      "1")
      ;;
      "2")
          cd $scriptpath/db/
        sudo rm -f InstallFullDB.config
        sudo chmod 777 InstallFullDB.sh
          sh InstallFullDB.sh
        echo "Please replace the following line for CORE_PATH"
        echo "CORE_PATH=$scriptpath/mangos"
        sudo -i gedit InstallFullDB.config
        sudo sh InstallFullDB.sh
      ;;
      "3")
      ;;
      esac
    fi

  ;;
  "purgemysql")
    echo "This will purge the mysql package like it was just installed"
    read -p "Do you want to continue with this process [y or n] ? " bool
    if test "$bool" == "y"
    then
      sudo apt-get purge mysql-server mysql-client mysql-common mysql-server-core-5.5 mysql-client-core-5.5
      sudo rm -rf /etc/mysql /var/lib/mysql
      sudo apt-get autoremove
      sudo apt-get autoclean
    fi
  ;;
  "config")
  ;;
  "stats")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  *)
    echo "Usage: $0 { update | install | remove | config | stats }"
  ;;
esac

exit 0