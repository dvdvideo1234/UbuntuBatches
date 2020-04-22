#!/bin/bash

svid=0
svop=""
bool="Y"
array=()

# Change directory to LinuxGSM root
cd ~
cd Documents/LinuxGSM/

# Gather list of executables with no spaces in the name
# Count trough the list and add them to the array
for file in $(find . -maxdepth 1 -type f ! -name "*.*" -type f ! -name "* *" -perm -og+rx)
do
  array+=("$file")
done

# Use arithmetic to obtain highest index
maxid=$((${#array[*]} - 1))

while [ 0 -eq 0 ]; do 
  # Keep cycling until proper server ID in range is selected
  echo "Servers available : [$(($maxid + 1))]"

  # List all the server executables
  for ((i = 0 ; i <= $maxid ; i++)); do
    echo "[$i] : ${array[i]}"
  done

  # Select desired server to start via ID
  read -p "Enter server ID: " svid 
  svid=$(echo "$svid" | grep -E "^[+-]?[0-9]+$")
  
  # Check for empty value
  if [ -z "$svid" ]
  then
    echo "Empty value is not correct!"
  else
    # Check the server range is between 0 and maxid
    if [ $svid -ge 0 -a $svid -le $maxid ]
    then
      break
    else
      echo "Server index [$svid] not in range[0, $maxid]"
    fi
  fi
done 

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
