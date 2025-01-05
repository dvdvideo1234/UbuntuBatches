#!/bin/bash

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
backcnfdr="nut-conf"
action="$1"

case "$action" in
  install)
    sudo apt-get install nut
    sudo apt-get install nut-client
    sudo apt-get install nut-server
  ;;
  backup)
    echo "Backup configuration in [$scriptpath/$backcnfdr]"
    [ ! -d "$scriptpath/$backcnfdr" ] && rm -rf "$scriptpath/$backcnfdr"
    sudo mkdir "$scriptpath/$backcnfdr"
    sudo cp /etc/nut/upssched.conf  ~/Downloads/$backcnfdr/upssched.conf
    sudo cp /etc/nut/upsd.conf      ~/Downloads/$backcnfdr/upsd.conf
    sudo cp /etc/nut/nut.conf       ~/Downloads/$backcnfdr/nut.conf
    sudo cp /etc/nut/upsd.users     ~/Downloads/$backcnfdr/upsd.users
    sudo cp /etc/nut/ups.conf       ~/Downloads/$backcnfdr/ups.conf
    sudo cp /etc/nut/upsmon.conf    ~/Downloads/$backcnfdr/upsmon.conf
    sudo chown olimex:olimex "$scriptpath/$backcnfdr"
    sudo chmod 664 "$scriptpath/$backcnfdr"
  ;;
  scanusb)
    echo "Enter the followng information in [/etc/nut]"
    sudo lsusb
    sudo nut-scanner -U
    sudo upsc FSP@localhost
  ;;
  restart)
    sudo service nut-server restart
    sudo service nut-client restart
    sudo systemctl restart nut-monitor
    sudo upsdrvctl stop
    sudo upsdrvctl start
  ;;
  *)
    echo "[install]: Installs the NUT package"
    echo "[backup] : Backup configuration"
    echo "[scanusb]: Scans for conected UPS"
    echo "[restart]: Restart monitor service"
  ;;
esac
