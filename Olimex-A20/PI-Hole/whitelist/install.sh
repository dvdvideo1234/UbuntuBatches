#!/bin/bash

strurl=""
strdat=""
arGravity=()

# Fix google translate fints looks cunky
arGravity+=("https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt")
arGravity+=("https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/PI-Hole/blocklist/1.txt")

for url in ${arGravity[*]}; do
  rm -f whitelist.txt
  strurl=$(echo -e "${url}" | tr -d '[:space:]')
  winpty curl --insecure ${strurl} -o whitelist.txt

  while IFS= read line
  do
    strdat=$(echo -e "${line}" | tr -d '[:space:]')
    if test "${strdat:0:1}" == "#"
    then
      strdat=""
    fi

    if test "${strdat}" != ""
    then
      echo "Adding: ${strdat}"
      pihole -w ${strdat}
    fi
  done <"whitelist.txt"
done

rm -f whitelist.txt

