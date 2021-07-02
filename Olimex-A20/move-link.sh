#!/bin/bash

# TEST_MOVE_DIR="/mnt/c/Users/ddobromirov/Documents/Lua-Projs/SVN/UbuntuBatches/Olimex-A20/TEST"
# TEST_MOVE_TO="/mnt/c/Users/ddobromirov/Documents/Lua-Projs/SVN/UbuntuBatches/Olimex-A20/TEST/mnt"
# ./move-link.sh $TEST_MOVE_DIR Stuff $TEST_MOVE_TO

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

[ -d "${dirdest}/${dirname}" ] && sudo rm -rfv ${dirdest}/${dirname}

sleep 1

cp -rfp ${dirbase}/${dirname}/. ${dirdest}/${dirname} 
