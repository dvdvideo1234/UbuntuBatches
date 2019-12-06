#!/bin/bash

bool=""
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
idread="1.19.6ubuntu1_amd64"
urlbase="http://archive.ubuntu.com/ubuntu/pool/main/d/dpkg"
urltotal=""

rm -rf dpkg
mkdir dpkg
cd dpkg

echo "Base: $urlbase"
echo "Mark the file and copy arhitecture/version"
read -p "Identifier [$idread] : " idread
if test "$idread" != ""
then
  urltotal="$urlbase/dpkg_$idread.deb"
  read -p "Download : $urltotal [y/N]? : " bool
  if test "$bool" == "y"
  then
    wget -O "dpkg_$idread.deb" "$urltotal"
  fi
  read -p "Proceed : dpkg_$idread.deb [y/N]? : " bool
  if test "$bool" == "y"
  then
    ar x dpkg*.deb 
    # Extact the TAR archive into folder `data`
    
    # Manually copy all files
    cp -avr $scriptpath/dpkg/data/* /
    # Make sure it is executable
    chmod +x /usr/bin/dpkg*
    apt-get update
    apt-get install --reinstall dpkg
  fi
else
  echo "You must specify *GZ package URL!"
  exit 0
fi

exit 0
