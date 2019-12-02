#!/bin/bash

# set -x

bool=""
action="$1"
option="$2"
verclang=""
vercmake=""
modeinstall=""
servernmae="azerothcore"
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

function getMode()
{
  local res1=""
  local res2=""

  # Title names
  local info[0]="[Docker install] {}"
  local info[1]="[General install] {}"

  echo -e $1

  for (( i=0; i<=$(( ${#info[*]} -1 )); i++ ))
  do
    echo "$i >> $(sed -e 's/.*\[\([^]]*\)\].*/\1/g' <<< ${info[$i]})"
  done
  read -p "Enter ID: " res1

  if [[ -z "${info[$res1]}" ]]
  then
    echo "Wrong ID: $res1"
    exit 0
  fi

  res3=$(sed -e 's/.*\[\([^]]*\)\].*/\1/g' <<< ${info[$res1]})
  res2=$(sed -e 's/[^{]*{\([^}]*\)}.*/\1/g' <<< ${info[$res1]})

  echo "getMode: [$res1] > $res2"

  eval "$2='$res1'"
  eval "$3='$res2'"
}


case "$action" in
  "install")
    read -p "Install dependencies [y/N] ? " bool
    if test "$bool" == "y"
    then
      yes y | ./dependencies.sh
    fi

    verclang=$(clang --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
    vercmake=$(cmake --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
       
    read -p "Installed CLang is version: [$verclang] > [6.0]? Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "Please install CLang 6.0 or above!"
      exit 0
    fi
    
    read -p "Installed CMake is version: [$vercmake] > [3.8]? Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "Please install CMake 3.8 or above!"
      exit 0
    fi
    
    git clone https://github.com/azerothcore/azerothcore-wotlk.git $scriptpath/$servernmae
    
    getMode "Select general install mode:" modeinstall
    
    case "$idtitle" in
    0)
      # http://www.azerothcore.org/wiki/Install-with-Docker
    ;;
    1)

    ;;
  ;;
  "config")

  ;;
  "paths")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  *)
    echo "Usage: $0 { install | remove | config | paths }"
  ;;
esac

exit 0
