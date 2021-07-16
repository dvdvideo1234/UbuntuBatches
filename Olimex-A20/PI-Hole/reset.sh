#!/bin/bash

option=""

read -sp "Do not like settings. Reconfigure ? " option
if test "${option^^}" == "Y"
then
  pihole -r
fi

read -sp "Database is broken. Reset ? " option
if test "${option^^}" == "Y"
then
  pihole -g -r
fi

read -sp "Delete AD-lists ? " option
if test "${option^^}" == "Y"
then
  sudo sqlite3 /etc/pihole/gravity.db "DELETE FROM adlist;"
fi

read -sp "Delete exact whitelist ? " option
if test "${option^^}" == "Y"
then
  sudo sqlite3 /etc/pihole/gravity.db "delete from domainlist where type=0;"
fi

read -sp "Delete regex whitelist ? " option
if test "${option^^}" == "Y"
then
  sudo sqlite3 /etc/pihole/gravity.db "delete from domainlist where type=2;"
fi

exit 0
