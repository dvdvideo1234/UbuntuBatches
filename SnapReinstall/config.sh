#!/bin/bash

sudo apt purge snap
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/tmp/snapd.*
sudo rm -rf /etc/systemd/system/snapd.service.d
sudo apt install snapd
sudo snap install hello-world
