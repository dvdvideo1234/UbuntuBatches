#!/bin/bash

sudo sudo apt-get update
sudo apt-get install linux-headers-$(uname -r)
sudo apt-get install build-essential
sudo apt-get install virtualbox-ose-guest-x11
sudo apt-get install linux-virtual
sudo apt-get install linux-lowlatency
sudo apt-get install linux-signed-generic

exit 0
