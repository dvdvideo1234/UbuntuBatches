#!/bin/bash

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
absolutesr=$1

echo Execp: $scriptname
echo Exenm: $scriptpath
echo Srccp: $absolutesr

clear
while true; do
  for f in "$absolutesr"/*.txt; do
    clear
    cat "$f"
    sleep 0.04   # Adjust frame delay (e.g., ~24fps = 0.041s)
  done
done
