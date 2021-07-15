#!/bin/bash

# https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212

strurl=""
strdat=""
arGravity=()

# Global websites
arGravity+=("https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/PI-Hole/whitelist/google.txt")
arGravity+=("https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/PI-Hole/whitelist/facebook.txt")

#specialized stuff
arGravity+=("https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt")
arGravity+=("https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt")

# Bulgarian domains
arGravity+=("https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/PI-Hole/whitelist/bg.txt")

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
