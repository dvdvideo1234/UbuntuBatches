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
    make distclean
    git pull
    ./configure
    make
    checkinstall
  ;;
  "install")
    echo "Installing package ..."

    read -p "Install dependancies [y/N] ? " bool
    if test "$bool" == "y"
    then
      apt-get update
      # Dependancies
      apt-get install libexif
      apt-get install libjpeg
      apt-get install libid3tag
      apt-get install libFLAC
      apt-get install libvorbis
      apt-get install libsqlite3
      apt-get install libavformat
      # Needed compiling binaries
      apt-get install libavutil-dev
      apt-get install libavcodec-dev
      apt-get install libavformat-dev
      apt-get install libjpeg-dev
      apt-get install libsqlite3-dev
      apt-get install libexif-dev
      apt-get install libid3tag0-dev
      apt-get install libbogg-dev
      apt-get install libvorbis-dev
      apt-get install libflac-dev
      # Compiling tools
      apt-get install autoconf
      apt-get install automake
      apt-get install autopoint
      apt-get install make
      # Configuration tools
      apt-get install checkinstall
      apt-get install git
      apt-get install gksu
    fi

    # Set the proxy if any
    read -p "Are you using a proxy [n or <proxy:port>] ? " proxysv
    if test "$proxysv" == "n"
    then
      git config --global -l
      git config --global --unset http.proxy
    else
      git config --global http.proxy "$proxysv"
      echo "Proxy set to [$proxysv] !"
    fi

    read -p "Do you wish to download the sources now [y/N] ? " bool
    if test "$bool" == "y"
    then
      rm -fr $config
      mkdir $config
      cd $config

      git clone http://git.code.sf.net/p/minidlna/git $projdir
    fi

    read -p "Do you want to build the source now [y/N] ? " bool
    if test "$bool" == "y"
    then
      cd $projdir
      ./autogen.sh
      ./configure
      make
      checkinstall
      cp $scriptpath/$config/$projdir/minidlna.conf $scriptpath/$config/minidlna.conf
    fi

    read -p "Do you want to create autostart script [y/N] ? " bool
    if test "$bool" == "y"
    then
      # Create the file
      rm -f $scriptpath/$srvname
      chmod 666 $scriptpath/autostart_header.txt
      chmod 666 $scriptpath/autostart_source.txt
      cat $scriptpath/autostart_header.txt > $scriptpath/$srvname
      echo "" >> $scriptpath/$srvname
      echo "deamonSRV=\"minidlna\"" >> $scriptpath/$srvname
      echo "deamonCNF=\"$scriptpath/$config/minidlna.conf\"" >> $scriptpath/$srvname
      echo "" >> $scriptpath/$srvname
      cat $scriptpath/autostart_source.txt >> $scriptpath/$srvname
      echo "" >> $scriptpath/$srvname

      # Install autostart server configuration
      cp $scriptpath/$srvname /etc/init.d/$srvname
      chmod +x /etc/init.d/$srvname
      update-rc.d $srvname defaults
    fi
  ;;
  "remove")
    echo "Removing package ..."
    apt-get remove $srvname
    update-rc.d -f $srvname remove
    rm /etc/init.d/$srvname
    rm -r $scriptpath/$config
  ;;
  "config")
    echo "Opening settings ..."
    echo "Change what you like then save and close the editor."
    gksu gedit $scriptpath/$config/minidlna.conf
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
