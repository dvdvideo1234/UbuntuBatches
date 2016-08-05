#!/bin/bash

insdir="$PWD"
user=""
pass=""
dir=""
appid=""
appmod=""
bool=""
chkhash=""
archit=""
datedt=$(date +"%y-%m-%d_%H-%M-%S")

function getInput()
{
  local rez=""
  echo $1
  read -r rez
  while [ -z "$rez" ]; do
    echo Please put $2
    read -r rez
  done
  eval "$3=$rez"
}

echo "This script manages SteamCMD dedicated server"

case "$action" in
  "update")
    read -p "Do you want to install dependencies ? [y or n]" bool
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

    echo "Making directory /steamcmd at $insdir"

    # Making a directory and switching into it
    mkdir $insdir/steamcmd
    cd $insdir/steamcmd

    echo "Downloading steam"
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

    # Make it executable
    chmod +x steamcmd.sh

    read -p "Do you wish to install a game now ? [y or n]" bool
    if test "$bool" == "y"
    then
      getInput "Enter a user for steam, or login as anonymous" "user name" user
    else
      echo "Running steam update check"
      ./steamcmd.sh +quit
      exit 0
    fi

    if test "$user" == "anonymous"
    then
      getInput "Which appid you wish to install ?" "appid" appid
      if test "$appid" == "90"
      then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
        getInput "Do you need to install a mod for HL1 / CS1.6 ? [n or <mod_name>]" "a mod" appmod
      fi
      getInput "Where in [$insdir] do you want to put it ?" "path" dir
      mkdir $insdir/$dir
      if test "$appmod" == "n"
      then
        ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +quit
      else
        ./steamcmd.sh +login $user +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
      fi
    else
      getInput "What is the password for the user [$user] ?" "password" pass
      getInput "Which appid you wish to install ?" "appid" appid
      if test "$appid" == "90"
      then # https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
        getInput "Do you need to install a mod for HL1 / CS1.6 ? [n or <mod_name>]" "a mod" appmod
      fi
      getInput "Where in [$insdir] do you want to put it ?" "path" dir
      mkdir $insdir/$dir
      if test "$appmod" == "n"
      then
        ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +quit
      else
        ./steamcmd.sh +login $user $pass +force_install_dir $insdir/$dir +app_update $appid validate +app_set_config "90 mod $appmod" +quit
      fi
    fi

