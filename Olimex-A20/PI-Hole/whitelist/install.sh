#!/bin/bash

arGravity=()

# Fix google translate fints looks cunky
arGravity+=(https://github.com/anudeepND/whitelist/blob/master/domains/whitelist.txt)

for url in ${arGravity[*]}; do
  strTrim=$(echo -e "${url}" | tr -d '[:space:]')
  echo "Test >>$strTrim<<"
done
