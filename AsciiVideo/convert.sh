#!/bin/bash

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")
sorsdrname=$(readlink -f "$1")
sorsdrpath=$(dirname "$scriptname")

newsrcname="${sorsdrname##*/}"
newdirname="${newsrcname%.*}"

echo Execp: $scriptpath
echo Sours: $sorsdrname
echo Index: $newdirname

cd $scriptpath
rm -rf "$newdirname.frames"
mkdir "$newdirname.frames"

ffmpeg -i $sorsdrname $newdirname.frames/frame_%8d.jpg

cd "$newdirname.frames"
convcount=$(find . -maxdepth 1 -type f | wc -l)
currentpv=0

cd $scriptpath
rm -rf "$newdirname.ascii"
mkdir "$newdirname.ascii"
for f in "$newdirname.frames"/*.jpg; do
  [[ -e "$f" ]] || continue
  ((currentpv++))
  percent=$(( currentpv * 100 / convcount ))
  echo -e "[$percent%]: $f"
  jp2a --width=120 --colors "$f" > "$newdirname.ascii/$(basename "$f" .jpg).txt"
done
