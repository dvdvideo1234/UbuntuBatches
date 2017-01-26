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
    apt-get update
    apt-get install $srvname
    
    rm -f $scriptpath/$srvname.conf
    echo "start on login-session-start" > $srvname.conf
    echo "" >> $srvname.conf
    echo "script" >> $srvname.conf
    echo "" >> $srvname.conf
    echo "sudo $scriptname start $param" >> $srvname.conf
    echo "" >> $srvname.conf
    echo "end script" >> $srvname.conf
    mv $scriptpath/$srvname.conf $configloc/$srvname.conf
    
    getInput "What password do you wish to use ?" "a password" param
    $srvname -storepasswd $param $scriptpath/$srvname.pass
  ;;
  "remove")
    echo "Removing package ..."
    /usr/bin/killall $srvname
    apt-get remove $srvname
    mv $configloc/$srvname.conf $scriptpath/$srvname.conf
    rm -f $configloc/$srvname.conf
    rm -f $scriptpath/$srvname.pass
  ;;
  "config")
    echo "Opening settings ..."
    gedit $configloc/$srvname.conf
  ;;
  "start")
    /usr/bin/$srvname -xkb -noxrecord -noxfixes -noxdamage -forever -bg -rfbport $param -display :0 -auth /var/run/lightdm/root/:0 -rfbauth $scriptpath/$srvname.pass -o $scriptpath/$srvname.log
  ;;
  "stop")
    /usr/bin/killall $srvname
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
