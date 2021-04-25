#!/bin/bash

# https://netplan.io/examples/
# https://help.ubuntu.com/community/UbuntuBonding

# To configure netplan, save configuration files under
# /etc/netplan/ with a .yaml extension (e.g. /etc/netplan/config.yaml)
# then run sudo netplan apply. This command parses and applies
# the configuration to the system. Configuration written to
# disk under /etc/netplan/ will persist between reboots.

# mode=0 (balance-rr)
# mode=1 (active-backup)
# mode=2 (balance-xor)
# mode=3 (broadcast)
# mode=4 (802.3ad)
# mode=5 (balance-tlb)
# mode=6 (balance-alb)

action="$1"

case "$action" in
  "install")
    sudo apt-get install vim
    sudo apt-get install ifconfig
    sudo apt-get install ifenslave

    echo "Edit the master and slave interfaces in the configuration!"
    echo -e "Edit \033[4;33mnetwork-bonding.yaml\033[0m config file!"
    echo -e "Chose nterface description master master and slave."
    echo -e "Network interfaces available:\n"
    ifconfig | grep -E "^[A-Za-z0-9]+:"

    echo -e "Write \033[4;33mbonding\033[0m inside the config file!"
    sudo gnome-terminal --wait -x vim /etc/modules

    echo -e "Chose network bonding from the specified below:\e"
    cat bonding-mode.txt

    sudo cp network-bonding.yaml network-bonding-cp.yaml
    sudo gnome-terminal --wait -x vim network-bonding-cp.yaml

    sudo cp network-bonding-cp.yaml /etc/netplan/network-bonding.yaml
  "remove")
    sudo rm -f /etc/netplan/network-bonding.yaml
    echo -e "Remove \033[4;33mbonding\033[0m from the config file!"
    sudo gnome-terminal --wait -x vim /etc/modules
  "setup")
    sudo vim /etc/netplan/network-bonding.yaml
  *)
    echo "Usage: $0 { install | remove | setup }"
  ;;
esac
