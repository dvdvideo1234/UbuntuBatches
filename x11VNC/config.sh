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
  read -sp "$1" rez
  while [ -z "$rez" ]; do
    read -sp "$1" rez
  done
  eval "$2=$rez"
}

case "$action" in
  "install")
    echo "Installing package ... $srvname"
    sudo apt-get update 
    sudo apt-get install vim
    sudo apt-get install $srvname
    
    eval "$scriptname run $param"
        
    getInput "Enter installation password: " param
    $srvname -storepasswd $param $scriptpath/$srvname.pass
  ;;
  "run")
    echo "Scripting package ... $srvname"
    echo "#!/bin/bash" > $scriptpath/run.sh
    echo "" >> $scriptpath/run.sh
    echo "$scriptpath/config.sh start $param" >> $scriptpath/run.sh
    sudo chmod +x run.sh
  ;;
  "remove")
    echo "Removing package ... $srvname"
    sudo /usr/bin/killall $srvname
    sudo apt-get remove $srvname
    sudo mv $configloc/$srvname.conf $scriptpath/$srvname.conf
    sudo rm -f $configloc/$srvname.conf
    rm -f $scriptpath/$srvname.pass
  ;;
  "config")
    echo "Configuring package ... $srvname"
    sudo vim $configloc/$srvname.conf
  ;;
  "start")
    echo "Starting package ... $srvname"
    /usr/bin/$srvname -xkb -noxrecord -noxfixes -noxdamage -forever -bg -rfbport $param -display :0 -auth guess -rfbauth $scriptpath/$srvname.pass -o $scriptpath/$srvname.log
  ;;
  "stop")
    echo "Stopping package ... $srvname"
    sudo /usr/bin/killall $srvname
  ;;
  "stats")
    echo "Stats package ... $srvname"
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
