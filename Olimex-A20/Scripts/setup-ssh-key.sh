#!/bin/bash

scriptfile=""
scriptmail=""
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

echo This will create a public and private keys with use of github SSH!

read -p "Enter filename or leave blank: " scriptfile
if test "$scriptfile" == ""
then
  scriptfile=id_rsa
fi

read -p "Enter e-mail or leave blank: " scriptmail
if test "$scriptmail" == ""
then
  ssh-keygen -t rsa -b 4096
else
  ssh-keygen -t rsa -b 4096 -C "$scriptmail"
fi

eval $(ssh-agent -s)
ssh-add $HOME.ssh/$scriptfile
clip < $HOME.ssh/$scriptfile.pub

cp $HOME.ssh/$scriptfile $scriptpath/$scriptfile
cp $HOME.ssh/$scriptfile.pub $scriptpath/$scriptfile.pub

echo Please follow the procedure described exactly:
echo 1. The key now exists into the clipboard!
echo 2. Go to: https://github.com/settings/keys
echo 3. Create new SSH key and paste it there
echo 4. Import the key with PUTTYGEN and write your password
echo 5. Save the public and private version of the key 
echo 6. Add the PUTTY key to PAGEANT to identify computer

echo You are all set for push and pull with github!
