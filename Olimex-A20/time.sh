#!/bin/bash

unlink /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Sofia /etc/localtime

# MMDDhhmmyyyy.ss
# date 112916572020.00
