#!/bin/bash

if (( $EUID != 0 )); then
  echo "The script must be run as root !"
  exit 0
fi

exit 0

