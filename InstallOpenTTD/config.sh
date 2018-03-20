#!/bin/bash

bool=""
proxysv=""

echo "http://www.openttd.org/download-opengfx for OpenGFX"
echo "http://www.openttd.org/download-opensfx for OpenSFX"
echo "http://www.openttd.org/download-openmsx for OpenMSX"

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

