#!/bin/bash

# TEST_MOVE_DIR="/mnt/c/Users/ddobromirov/Documents/Lua-Projs/SVN/UbuntuBatches/Olimex-A20/TEST"
# TEST_MOVE_TO="/mnt/c/Users/ddobromirov/Documents/Lua-Projs/SVN/UbuntuBatches/Olimex-A20/TEST/mnt"
# ./Scripts/move-link.sh $TEST_MOVE_DIR Stuff $TEST_MOVE_TO

runpath="$0"
dirbase="$1"
dirname="$2"
dirdest="$3"

echo -e "\n"
echo "Migrating to symbolic link: ${dirname}"
echo -e "\n"
echo "Path  : ${runpath}"
echo "Base  : ${dirbase}"
echo "Copy  : ${dirdest}"
echo -e "\n"

if [[ -L "${dirbase}/${dirname}" && -d "${dirbase}/${dirname}" ]]; then
  echo "The folder [${dirname}] is already a link!"
else
  # Check existing source
  if [[ ! -d "${dirbase}/${dirname}" ]]; then
    echo "Source data not directory!"
    exit 0
  fi
  # Rewrite the folder if it exists
  if [[ -d "${dirdest}/${dirname}" ]]; then
    sudo rm -rfv ${dirdest}/${dirname}
    if [[ $? -ne 0 ]]; then
      echo "Rewrite destination error!"
      exit 0
    fi
  fi
  # Copy contents to the new location
  cp -rfp ${dirbase}/${dirname}/. ${dirdest}/${dirname}
  if [[ $? -ne 0 ]]; then
    echo "Data reallocation error!"
    exit 0
  fi
  # Remove the contents from the old location
  if [[ -d "${dirbase}/${dirname}" ]]; then
    sudo rm -rfv ${dirbase}/${dirname}
    if [[ $? -ne 0 ]]; then
      echo "Remove source data error!"
      exit 0
    fi
  fi
  # Make symbolic link in the old location to the new location
  ln -s ${dirdest}/${dirname} ${dirbase}/${dirname}
  if [[ $? -ne 0 ]]; then
    echo "Symbolic link creation error!"
    exit 0
  fi
fi
