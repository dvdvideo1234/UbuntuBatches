#!/bin/bash

ARDIR=(
/var/lib/dpkg/lock
/var/lib/apt/lists/lock
/var/lib/dpkg/lock-frontend
/var/cache/apt/archives/lock
)

PID=""

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

for LINE in ${ARDIR[@]}
do
  PID=$(lsof $LINE)
  echo [$PID] $LINE
  rm -f $LINE
done

dpkg --configure -a

exit 0

