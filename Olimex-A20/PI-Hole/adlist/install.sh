#!/bin/bash

strurl=""
strcom=""
strdat=""

for file in *.txt; do
  while IFS= read line
  do
    strdat=$(echo -e "${line}" | tr -d '[:space:]')
    if test "${strdat:0:1}" == "#"
    then
      strcom=${strdat:1}
    fi

    if test "${strdat}" != ""
    then
      strurl=${strdat}
      echo "Adding: ${strcom} | ${strurl}"
      pihole -a adlist add ${strurl} ${strcom}
    fi
  done <"$file"
done
