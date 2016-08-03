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

    echo "Install dependancies [y or n] ?"
    read -r bool
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
      # Installation tools
      apt-get install checkinstall
      # Download the project
      apt-get install git
    fi

    # Set the proxy if any
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

    # Download and compile the source
    rm -fr $config
    mkdir $config
    cd $config

    git clone http://git.code.sf.net/p/minidlna/git $projdir

    cd $projdir
    ./autogen.sh
    ./configure
    make
    checkinstall
    cp $scriptpath/$config/$projdir/minidlna.conf $scriptpath/$config/minidlna.conf

    # Create autostart configuration file
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
    gedit $scriptpath/$config/minidlna.conf
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
