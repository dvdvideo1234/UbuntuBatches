#!/bin/bash

SCMDACTION="$1"

SCMDUSER=""
SCMDPASS=""
SCMDAPPID=""
SCMDAPPMOD=""
SCMDBOOL=""
SCMDCHKHASH=""
SCMDARCHIT=""
SCMDDATEDT=$(date +"%y-%m-%d_%H-%M-%S")
SCMDPRGNAME=$(readlink -f "$0")
SCMDPRGPATH=$(dirname "$SCMDPRGNAME")

function getInput()
{
  local rez=""
  read -p "$1: " rez
  while [ -z "$rez" ]; do
    read -p "Please put $2: " rez
  done
  eval "$3=$rez"
}

function getAppModID()
{
  local rid=""
  local rmd=""

  echo "$1"

  getInput "Select appid to $SCMDACTION" "appid" rid

  if test "$rid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List (4020)
    read -p "Select a mod for HL1 / CS1.6 [mod_name]: " rmd
  fi # Hor HL1 appid=90 mod_name is empty
  
  eval "$2=$rmd"
  eval "$3=$rid"
}

echo "This script manages SteamCMD dedicated server"

case "$SCMDACTION" in
  "update")
    read -p "Do you want to install dependencies [y/N] ? " SCMDBOOL
    if test "$SCMDBOOL" == "y"
    then
      SCMDARCHIT=$(uname -m)
      echo "Your linux kernel core is : $SCMDARCHIT"
      if test "$SCMDARCHIT" == "x86_64"
      then
        dpkg --add-architecture i386
        apt-get update
        apt-get install lib32gcc1
        apt-get install lib32stdc++6
        apt-get install lib32tinfo5
      else
        apt-get install lib32gcc1
        apt-get install lib32tinfo5
      fi
    fi

    echo "Refreshing directory /steam at <$SCMDPRGPATH>"

    cd $SCMDPRGPATH
    mkdir steam
    cd steam
    rm -f steamcmd*.*

    echo "Downloading Steam ..."
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

    SCMDCHKHASH=$(md5sum steamcmd_linux.tar.gz | cut -d' ' -f1)
    if test "$SCMDCHKHASH" == "09e3f75c1ab5a501945c8c8b10c7f50e"
    then
      echo "Checksum OK"
    else
      echo "Checksum FAIL $SCMDCHKHASH"
      exit 0
    fi

    tar -xvzf steamcmd_linux.tar.gz

    chmod +x steamcmd.sh

    read -p "Do you wish to login now [y/N] ? " SCMDBOOL
    if test "$SCMDBOOL" == "y"
    then
      read -p "Write a steam user, or press [Enter] for anonymous: " SCMDUSER
      if [ -z "$SCMDUSER" ]
      then
        SCMDUSER="anonymous"
      fi
    else
      echo "Running steam update check"
      ./steamcmd.sh +quit
      exit 0
    fi

    getAppModID "Select server application to be installed" SCMDAPPMOD SCMDAPPID

    echo "Application: <$SCMDUSER> <$SCMDAPPID> <$SCMDAPPMOD>"

    if test "$SCMDUSER" == "anonymous"
    then
      if [ -z "$SCMDAPPMOD" ]
      then
        ./steamcmd.sh +login $SCMDUSER +force_install_dir ../$SCMDAPPID +app_update $SCMDAPPID validate +quit
      else
        ./steamcmd.sh +login $SCMDUSER +force_install_dir ../$SCMDAPPID/$SCMDAPPMOD +app_update $SCMDAPPID validate +app_set_config "90 mod $SCMDAPPMOD" +quit
      fi
    else
      getInput "Enter the password for user [$SCMDUSER]" "a password" SCMDPASS
      if [ -z "$SCMDAPPMOD" ]
      then
        ./steamcmd.sh +login $SCMDUSER $SCMDPASS +force_install_dir ../$SCMDAPPID +app_update $SCMDAPPID validate +quit
      else
        ./steamcmd.sh +login $SCMDUSER $SCMDPASS +force_install_dir ../$SCMDAPPID/$SCMDAPPMOD +app_update $SCMDAPPID validate +app_set_config "90 mod $SCMDAPPMOD" +quit
      fi
    fi
  ;;
  "backup")
  ;;
  "stats")
    echo "Date: $SCMDDATEDT"
    echo "Path: $SCMDPRGPATH"
    echo "Name: $SCMDPRGNAME"
  ;;
  "run")
    SCMDARCHIT=$(uname -m)
    if [ -z "$3" ]
    then
      echo "Please provide starting APPID."
    fi
    if [ -z "$4" ]
    then
      echo "Please provide starting MAP."
    fi
    if [ -z "$5" ]
    then
      echo "Please provide starting PLAYERS."
    fi
    if [ -z "$5" ]
    then
      echo "Please provide starting PORT."
    fi
    cd $SCMDPRGPATH/$3
    case "$2" in
    "hl")
      ./$2ds_run -game $4 +maxplayers $5 +map $6 +port $7 +exec server.cfg -autoupdate
    ;;
    "src") # ./config.sh run src 4020 garrysmod 4 gm_flatgrass 27015
      ./$2ds_run -game $4 +maxplayers $5 +map $6 +port $7 +exec server.cfg -autoupdate
    ;;
    *)
      if [ -z "$2" ]
      then
        echo "Please provide starting mode."
      else
        echo "Server <$2> not supported yet."
      fi
      exit 0
    ;;  
    esac
  ;;
  *)
    echo "Usage: $0 { update | run | backup | stats }"
  ;;
esac
