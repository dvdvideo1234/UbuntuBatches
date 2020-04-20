#!/bin/bash

base="Documents/LinuxGSM/"
svid=""
svop=""
bool="Y"
array=()

cd ~
cd ${base}

for file in *server
do
  array+=(${file})
done

count=${#array[*]}

echo "Servers available : $count"

for ((i = 0 ; i <= ($count-1) ; i++)); do
  echo "[$i] : ${array[i]}"
done

read -p "Enter server ID: " svid

xtitle "LinuxGSM [${array[svid]}]"

while test "${bool^^}" != "N"; do
  ./${array[svid]}
  
  read -p "Enter server option: " svop
  
  if test -z "${svop}"
  then
    bool="Y"
  else
    ./${array[svid]} $svop
    read -p "Continue: [Y/n] ? " bool
  fi
  
  bool="${bool^^}"
done

exit 0
