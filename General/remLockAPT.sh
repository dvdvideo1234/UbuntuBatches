#!/bin/bash

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

lsof /var/lib/dpkg/lock | kill
lsof /var/lib/apt/lists/lock | kill
lsof /var/lib/dpkg/lock-frontend | kill
lsof /var/cache/apt/archives/lock | kill

rm /var/lib/dpkg/lock
rm /var/lib/apt/lists/lock
rm /var/lib/dpkg/lock-frontend
rm /var/cache/apt/archives/lock

dpkg --configure -a

apt-get update

exit 0

