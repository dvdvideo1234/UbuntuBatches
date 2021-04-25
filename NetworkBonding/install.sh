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

sudo apt-get install vim
sudo apt-get install ifenslave

echo Shove the "bonding" module in this file

sudo vim /etc/modules

sudo cp network-bonding.yaml /etc/netplan/network-bonding.yaml
