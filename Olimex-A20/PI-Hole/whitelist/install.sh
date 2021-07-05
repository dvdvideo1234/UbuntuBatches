#!/bin/bash

strurl=""
strdat=""
arGravity=()

# Bulgarian domains
arGravity+=("https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/PI-Hole/whitelist/1.txt")

# Fix google translate fints looks cunky
arGravity+=("https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt")
arGravity+=("https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt")


for url in ${arGravity[*]}; do
  if [[ -f whitelist.txt ]]; then
    sudo rm -f whitelist.txt
  fi
  
  strurl=$(echo -e "${url}" | tr -d '[:space:]')
  sudo curl --insecure ${strurl} -o whitelist.txt

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

if [[ -f whitelist.txt ]]; then
  sudo rm -f whitelist.txt
fi
