#!/bin/bash

action="$1"
param="$2"
srvname="x11vnc"
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
configloc="/etc/init"

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

case "$action" in
  "install")
    echo "Installing package ... $srvname"
    sudo apt-get update
    sudo apt-get install $srvname
    
    rm -f $scriptpath/$srvname.conf
    sudo echo "start on login-session-start" > $srvname.conf
    sudo echo "" >> $srvname.conf
    sudo echo "script" >> $srvname.conf
    sudo echo "" >> $srvname.conf
    sudo echo "sudo $scriptname start $param" >> $srvname.conf
    sudo echo "" >> $srvname.conf
    sudo echo "end script" >> $srvname.conf
    sudo mv $scriptpath/$srvname.conf $configloc/$srvname.conf
    
    getInput "What password do you wish to use ?" "a password" param
    sudo $srvname -storepasswd $param $scriptpath/$srvname.pass
  ;;
  "remove")
    echo "Removing package ..."
    sudo /usr/bin/killall $srvname
    sudo apt-get remove $srvname
    sudo mv $configloc/$srvname.conf $scriptpath/$srvname.conf
    sudo rm -f $configloc/$srvname.conf
    sudo rm -f $scriptpath/$srvname.pass
  ;;
  "config")
    echo "Opening settings ..."
    sudo gedit $configloc/$srvname.conf
  ;;
  "start")
    sudo /usr/bin/$srvname -xkb -noxrecord -noxfixes -noxdamage -forever -bg -rfbport $param -display :0 -auth /var/run/lightdm/root/:0 -rfbauth $scriptpath/$srvname.pass -o $scriptpath/$srvname.log
  ;;
  "stop")
    sudo /usr/bin/killall $srvname
  ;;
  "stats")
    echo "Name: $srvname"
    echo "Scrn: $scriptname"
    echo "Path: $scriptpath"
    echo "EtcC: $configloc/$srvname.conf"
  ;;
  *)
    echo "Usage: $0 { install <port> | remove | config | start <port> | stop | stats }"
  ;;
esac

exit 0
