#!/bin/sh

#First, manually move problematic services from init.d to d.init (i.e.: /etc/d.init/)
cd /etc

var_srv=$1
var_pkg=$(dpkg-query -S init.d/$var_srv|egrep -o '^.*\:'|egrep -o '^.*[^\:]')

#To Reinstall the problematic package:
sudo aptitude reinstall $var_pkg
#To Restore missing configs:
sudo apt-get -o DPkg::options::=--force-confmiss --reinstall install $var_pkg

#Show that both (the backup copy and the newly created copy exist):
ls d.init/$var_srv init.d/$var_srv
#Show the difference between 2 files (the new and the backup):
meld d.init/$var_srv init.d/$var_srv
sudo rm -vi d.init/$var_srv

#To show what files have left for processing
find d.init/|sort

