#!/bin/bash

action="$1"
param="$2"
passw=""
srvname="x11vnc"
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
configloc="/etc/init"
configxdp="/etc/X11"

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
        
    # Install dependencies
    sudo apt-get update 
    sudo apt-get install vim
    sudo apt-get install xserver-xorg-video-dummy
    sudo apt-get install $srvname
    sudo cp xorg.conf $configxdp/xorg.conf
    
    # Create runner configurator for the port provided
    eval "$scriptname run $param"
    
    # Create password for the server must not be empty
    getInput "Enter installation password: " passw
    $srvname -storepasswd $passw $scriptpath/$srvname.pass
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
    sudo apt-get remove xserver-xorg-video-dummy
    
    # Remove server configuration
    sudo mv $configloc/$srvname.conf $scriptpath/$srvname.conf.bak
    sudo rm -f $configloc/$srvname.conf
    
    # Remove xdisplay configuration
    sudo mv $configxdp/xorg.conf $scriptpath/xorg.conf.bak
    sudo rm -f $configxdp/xorg.conf
    
    # Remove password not needed anymore
    rm -f $scriptpath/$srvname.pass
  ;;
  "config")
    echo "Configuring package ... $srvname"
    sudo vim $configloc/$srvname.conf
  ;;
  "xsetup")
    echo "Configuring XDisplay ... $srvname"
    sudo vim $configxdp/xorg.conf
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
    echo "XDsp: $configxdp/xorg.conf"
  ;;
  *)
    echo "Usage: $0 { install <port> | remove | config | xsetup | start <port> | stop | stats }"
  ;;
esac

exit 0
