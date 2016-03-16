#!/bin/bash
 echo this will help you maintain the server such as update functions, backups, and restore, this code will contain modified code of my own, so fell free to republish it as long that you give me credit.
 echo what would you like to do? backup or update
 read -r functions
 while [ -z "$functions" ]; do
     echo ------ Please give an input ------
     read -r functions
 done
 if test "$functions" == "backup"  
 then 
 now=$(date +"%m-%d-%y")
 if [ -z "$now" ]; then
   echo "an error occured while trying to retrieve the date, do it without a date? y or n"
   read -r dateerr
   while [ -z "$dateerr" ]; do
     echo ------ Please give an input ------
     read -r dateerr
   done
   if test "$dateerr" = "y"
   then
    echo we will generate a random number for the file
    now= $RANDOM
    daterr= yes
   else
    echo we are sorry it didnt worked, you can go to the github page to report it
    exit
   fi
 fi
 awnser=y
 if test "$awnser" = "y"
 then
   echo in which folder your server resides,specify the full path!
   read -r path
   while [ -z "$path" ]; do
     echo ------ Please give a path ------
     read -r path
   done
    notown=1
   fi
   echo OK, would you like it hidden from the user?you will need to do ls -a to see it. y or n
   read -r cloak
   while [ -z "$cloak" ]; do
     echo ------ Please give a awnser ------
     read -r cloak
   done
   if test "$cloak" = "y"; then
     mkdir ~/.backup
     cd ~/.backup
     tar -cvzf Backup_$now.tar.gz $path
     touch sums_$now.txt
     md5sum Backup_$now.tar.gz  | cut -c -32 > sums_$now.txt
     oldy=y
     if test "$oldy" = "y"
     then
       touch olddir_$now.txt
       echo $path > olddir_$now.txt
       echo old directory saved
     fi
   else
     mkdir ~/backup
     cd ~/backup
     tar -cvzf Backup_$now.tar.gz $path
     touch sums_$now.txt
     md5sum Backup_$now.tar.gz | cut -c -32 >  sums_$now.txt
     oldy=y
     if test "$oldy" = "y"
     then
       touch olddir_$now.txt
       echo $path > olddir_$now.txt
       echo old directory saved
     fi
   fi
 fi
 if test "$functions" == "update" 
 then
  echo put the appid of the server
  read -r appid
  while [ -z "$appid" ]; do
   echo ------ Please give an input ------
   read -r appid
  done
  echo input your username, you can log as anonymous.
  read -r username
  while [ -z "$username" ]; do
   echo ------ Please give an input ------
   read -r username
  done
  if test "$username" == "anonymous"
  then
   echo the script will log as anonymous
  else 
   echo input your password
   read -r password
   while [ -z "$password" ]; do
     echo ------ Please give an input ------
     read -r password
   done
  fi
  if [ -d "steamcmd" ]; then
   echo steamcmd exist
   cd /home/$USER/steamcmd
  else
   echo "steamcmd does not exist do you wish to install steamcmd?y or n"
   read -r steamcm
   while [ -z "$steamcm" ]; do 
    echo please try again
    read -r steamcm
   done
   if test "$steamcm" == "y"
   then
     echo ------- Downloading steam -------
     mkdir /home/$USER/steamcmd
     cd /home/$USER/steamcmd
     wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
     tar -xvzf steamcmd_linux.tar.gz
     chmod +x steamcmd.sh
   fi
  fi
  ./steamcmd.sh +login $username $password +app_update $appid +quit
 fi
 
exit 0
