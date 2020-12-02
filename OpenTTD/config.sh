#!/bin/bash

bool=""
proxysv=""

# Version taken from: https://www.openttd.org/downloads/opengfx-releases/latest.html
vergfx="0.6.0"

# Version taken from: https://www.openttd.org/downloads/opensfx-releases/latest.html
versfx="0.2.3"

# Version taken from: https://www.openttd.org/downloads/openmsx-releases/latest.html
vermsx="0.3.1"

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

read -p "Install dependencies [y/N]" bool
if test "$bool" == "y"
then
  sudo apt-get install git
  sudo apt-get install build-essential
  sudo apt-get install pkg-config
  sudo apt-get install libsdl1.2-dev
  sudo apt-get install subversion
  sudo apt-get install patch
  sudo apt-get install zlib1g-dev
  sudo apt-get install liblzo2-dev
  sudo apt-get install liblzma-dev
  sudo apt-get install libfontconfig-dev
  sudo apt-get install libicu-dev
  sudo apt-get install unzip
fi

read -p "Reftresh install folder [y/N]" bool
if test "$bool" == "y"
then
  rm -rf OpenTTD

  read -p "Are you using a proxy [n or <proxy:port>] ? " proxysv
  if test "$proxysv" == "n"
  then
    git config --global -l
    git config --global --unset http.proxy
  else
    git config --global http.proxy "$proxysv"
    echo "Proxy set to [$proxysv] !"
  fi

  git clone https://github.com/OpenTTD/OpenTTD
fi

read -p "Complile project [y/N]" bool
if test "$bool" == "y"
then
  cd OpenTTD
  ./configure
  make
fi

read -p "Install custon GFX [$vergfx] [y/N]" bool
if test "$bool" == "y"
then
  cd $scriptpath/OpenTTD/bin/baseset
  wget http://binaries.openttd.org/extra/opengfx/$vergfx/opengfx-$vergfx-all.zip
  unzip opengfx-$vergfx-all.zip
fi

read -p "Install custon SFX [$versfx] [y/N]" bool
if test "$bool" == "y"
then
  cd $scriptpath/OpenTTD/bin/baseset
  wget http://binaries.openttd.org/extra/opengfx/$versfx/opengfx-$versfx-all.zip
  unzip opengfx-$versfx-all.zip
fi

read -p "Install custon MFX [$vermsx] [y/N]" bool
if test "$bool" == "y"
then
  cd $scriptpath/OpenTTD/bin/baseset
  wget http://binaries.openttd.org/extra/opengfx/$vermsx/opengfx-$vermsx-all.zip
  unzip opengfx-$vermsx-all.zip
fi

