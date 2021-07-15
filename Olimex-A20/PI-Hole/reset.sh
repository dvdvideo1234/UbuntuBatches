#!/bin/bash

option=""

# Reconfigure the whole application
read -sp "Do not like settings. Reconfigure ? " option
if test "${option^^}" == "Y"
then
  pihole -r
fi

# Recreate gravity when it is broken
read -sp "Database is broken. Reset ? " option
if test "${option^^}" == "Y"
then
  pihole -g -r
fi

exit 0
