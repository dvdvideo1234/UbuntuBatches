#!/bin/bash

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
backcnfdr="nut-conf"
action="$1"

# git checkout -- config.sh
# sudo chmod +x config.sh

case "$action" in
  install-core)
    sudo apt-get install nut
    sudo apt-get install nut-client
    sudo apt-get install nut-server
    sudo apt autoremove
    sudo apt autoclean
  ;;
  install-web)
    sudo apt-get install apache2
    sudo apt-get install nut-cgi
    sudo apt autoremove
    sudo apt autoclean
    # Enable apache2 CGI module
    sudo a2enmod cgi
    sudo systemctl restart apache2
    echo "Access via: http://192.168.0.7/cgi-bin/nut/upsstats.cgi"
  ;;
  backup)
    echo "Backup configuration in [$scriptpath/$backcnfdr]"
    if sudo test -d "$scriptpath/$backcnfdr"; then
      sudo rm -rf "$scriptpath/$backcnfdr"
    fi
    # Create destination folder
    sudo mkdir "$scriptpath/$backcnfdr"
    # NUT service website crap
    sudo cp /etc/nut/upsstats.html        "$scriptpath/$backcnfdr/upsstats.html"
    sudo cp /etc/nut/upsstats-single.html "$scriptpath/$backcnfdr/upsstats-single.html"
    sudo cp /etc/nut/upsset.conf          "$scriptpath/$backcnfdr/upsset.conf"
    sudo cp /etc/nut/upssched.conf        "$scriptpath/$backcnfdr/upssched.conf"
    sudo cp /etc/nut/hosts.conf           "$scriptpath/$backcnfdr/hosts.conf"
    # NUT service itself
    sudo cp /etc/nut/upssched.conf  "$scriptpath/$backcnfdr/upssched.conf"
    sudo cp /etc/nut/upsd.conf      "$scriptpath/$backcnfdr/upsd.conf"
    sudo cp /etc/nut/nut.conf       "$scriptpath/$backcnfdr/nut.conf"
    sudo cp /etc/nut/upsd.users     "$scriptpath/$backcnfdr/upsd.users"
    sudo cp /etc/nut/ups.conf       "$scriptpath/$backcnfdr/ups.conf"
    sudo cp /etc/nut/upsmon.conf    "$scriptpath/$backcnfdr/upsmon.conf"
    # Change backup permissions
    sudo chown -R olimex:olimex "$scriptpath/$backcnfdr"
    sudo chmod -R 755 "$scriptpath/$backcnfdr"
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
    echo "Mark executable: $scriptname"
    sudo chmod +x "$scriptname"
    echo "[install]: Installs the NUT package"
    echo "[backup] : Backup configuration"
    echo "[scanusb]: Scans for conected UPS"
    echo "[restart]: Restart monitor service"
  ;;
esac
