#!/bin/bash

action="$1"

user=""
pass=""
appid=""
appmod=""
bool=""
chkhash=""
archit=""
datedt=$(date +"%y-%m-%d_%H-%M-%S")
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

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

  getInput "Enter an appid to install" "appid" rid

  if test "$rid" == "90"
  then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List (4020)
    getInput "Select a mod for HL1 / CS1.6 [n or <mod_name>]" "a mod" rmd
  fi

  eval "$2=$rmd"
  eval "$3=$rid"
}

echo "This script manages SteamCMD dedicated server"

case "$action" in
  "update")
    read -p "Do you want to install dependencies ? [y or n] " bool
    if test "$bool" = "y"
    then
      archit=$(uname -m)
      echo "Your linux kernel core is : $archit"
      if test "$archit" == "x86_64"
      then
        dpkg --add-architecture i386
        apt-get update
        apt-get install lib32gcc1
        apt-get install lib32stdc++6
      else
        apt-get install lib32gcc1
      fi
    fi

    echo "Refreshing directory /steamcmd at <$scriptpath>"

    cd $scriptpath
    mkdir steamcmd
    cd steamcmd
    rm -f steamcmd*.*

    echo "Downloading steam ..."
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

    chkhash=$(md5sum steamcmd_linux.tar.gz | cut -d' ' -f1)
    if test "$chkhash" == "09e3f75c1ab5a501945c8c8b10c7f50e"
    then
      echo "Checksum OK"
    else
      echo "Checksum FAIL $chkhash"
      exit 0
    fi

    tar -xvzf steamcmd_linux.tar.gz

    chmod +x steamcmd.sh

    read -p "Do you wish to login now ? [y or n] " bool
    if test "$bool" == "y"
    then
      getInput "Enter a user for steam, or login as anonymous" "user name" user
    else
      echo "Running steam update check"
      ./steamcmd.sh +quit
      exit 0
    fi

    getAppModID "Select desired server application to be installed" appmod appid

    if test "$user" == "anonymous"
    then
      if test "$appmod" == "n"
      then
        ./steamcmd.sh +login $user +app_update $appid validate +quit
      else
        ./steamcmd.sh +login $user +app_update $appid validate +app_set_config "90 mod $appmod" +quit
      fi
    else
      getInput "Enter the password for user [$user]" "a password" pass
      if test "$appmod" == "n"
      then
        ./steamcmd.sh +login $user $pass +app_update $appid validate +quit
      else
        ./steamcmd.sh +login $user $pass +app_update $appid validate +app_set_config "90 mod $appmod" +quit
      fi
    fi
  ;;
  "backup")
  ;;
  "stats")
    echo "Date: $datedt"
    echo "Path: $scriptpath"
    echo "Name: $scriptname"
  ;;
  *)
    echo "Usage: $0 { update | backup | stats }"
  ;;
esac

