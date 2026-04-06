#!/bin/bash

runpath="$0"
basrepo="$1"
keybase="$2"
sshserv="ssh.github.com"

compstr=$(grep -Eio "${sshserv}" ~/.ssh/config)

if test "$compstr" == "$sshserv"
then
  echo "Configuration is done!"
else
  echo -e "\n"
  echo "Confuguring git submodule"
  echo -e "\n"
  echo "Path  : ${runpath}"
  echo "Repo  : ${basrepo}"
  echo "SSH   : ${keybase}"
  echo -e "\n"

  echo "Host github.com" > tmp.txt
  echo " Hostname ssh.github.com" >> tmp.txt
  echo " Port 443" >> tmp.txt

  clip < tmp.txt

  edit ~/.ssh/config
  
  rm -f tmp.txt
fi

ssh -T git@github.com && echo "Connection successful!" || ssh -vv -p 443 git@github.com & echo "Connection fail!"
