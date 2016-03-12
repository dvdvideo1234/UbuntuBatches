#!/bin/bash

action="$1"

bool=""
proxysv=""
configdir=""
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
srvname="minidlna"
config=".$srvname"
projdir="$srvname-git"

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
    echo "Installing package ..."
    
    echo "Install dependancies [y or n] ?"
    read -r bool
    if test "$bool" == "y"
    then
      sudo apt-get update
      # Dependancies
      sudo apt-get install libexif
      sudo apt-get install libjpeg
      sudo apt-get install libid3tag
      sudo apt-get install libFLAC
      sudo apt-get install libvorbis
      sudo apt-get install libsqlite3
      sudo apt-get install libavformat
      # Needed compiling binaries
      sudo apt-get install libavutil-dev
      sudo apt-get install libavcodec-dev
      sudo apt-get install libavformat-dev
      sudo apt-get install libjpeg-dev
      sudo apt-get install libsqlite3-dev
      sudo apt-get install libexif-dev
      sudo apt-get install libid3tag0-dev
      sudo apt-get install libbogg-dev
      sudo apt-get install libvorbis-dev
      sudo apt-get install libflac-dev
      # Compiling tools
      sudo apt-get install autoconf
      sudo apt-get install automake
      sudo apt-get install autopoint
      sudo apt-get install make
      # Installation tools
      sudo apt-get install checkinstall
      # Download the project
      sudo apt-get install git
    fi

    echo "Are you using a proxy [no or <proxy:port>]  ?"
    read -r proxysv
    if test "$proxysv" == "no"
    then
      git config --global -l
      git config --global --unset http.proxy
    else
      git config --global http.proxy "$proxysv"
      echo "Proxy set to [$proxysv] !" 
    fi

    sudo rm -fr $config
    sudo mkdir $config
    cd $config

    git clone http://git.code.sf.net/p/minidlna/git $projdir

    cd $projdir
    ./autogen.sh
    ./configure
    make
    sudo checkinstall
    sudo cp $scriptpath/$config/$projdir/minidlna.conf $scriptpath/$config/minidlna.conf

    # Create autostart configuration file
    
    sudo rm -f $scriptpath/$srvname
    sudo chmod 666 $scriptpath/autostart_header.txt
    sudo chmod 666 $scriptpath/autostart_source.txt
    sudo cat $scriptpath/autostart_header.txt > $scriptpath/$srvname
    sudo echo "" >> $scriptpath/$srvname
    sudo echo "deamonSRV=\"minidlna\"" >> $scriptpath/$srvname
    sudo echo "deamoncnf=\"$scriptpath/$config/minidlna.conf\"" >> $scriptpath/$srvname
    sudo echo "" >> $scriptpath/$srvname
    sudo cat $scriptpath/autostart_source.txt >> $scriptpath/$srvname
    sudo echo "" >> $scriptpath/$srvname

    # Install autostart server configuration
    sudo cp $scriptpath/$srvname /etc/init.d/$srvname
    sudo chmod +x /etc/init.d/$srvname
    sudo update-rc.d $srvname defaults

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

