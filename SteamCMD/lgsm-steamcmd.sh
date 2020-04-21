#!/bin/bash

base="Documents/LinuxGSM/"
svid=""
svop=""
bool="Y"
array=()

# Change directory to LinuxGSM root

cd ~
cd ${base}

# Gather list of executables with no spaces in the name

for file in $(find . -maxdepth 1 -type f ! -name "*.*" -type f ! -name "* *" -perm -og+rx)
do
  array+=("$file")
done

# Count trough the list above and add them to the array

count=${#array[*]}

echo "Servers available : [$count]"

for ((i = 0 ; i <= ($count-1) ; i++)); do
  echo "[$i] : ${array[i]}"
done

# Select desired server to star it via ID

read -p "Enter server ID: " svid

# Set server title as user can have many servers

xtitle "LinuxGSM [${array[svid]}]"

while test "${bool^^}" != "N"; do
  clear

  # Sow available options and ask user to chose
  ${array[svid]}
  read -p "Enter server option: " svop
  
  if test -z "${svop}"
  then
    bool="Y"
  else
    # Put a new line here and run the server option
    echo -e "\n"
    ${array[svid]} $svop
    
    # When you are happy and you know it
    read -p "Continue: [Y/n] ? " bool
  fi
  
  # Make sure we compare capital with capital
  bool="${bool^^}"
done

# And you really wanna show it say NYA!
exit 0
