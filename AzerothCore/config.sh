#!/bin/bash

# set -x # Used for debugging

bool=""
action="$1"
option="$2"
verclang=""
vercmake=""
modeinstall=""
proxysv=""
proxymc=""
mysqlpa=""
makecmd=""
proxyrg="([0-9]{1,3}\.){3}[0-9]{1,3}\:[0-9]{1,5}"
servernmae="azerothcore"
cuscmakepa=""
cusclangpa=""
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
        
    read -p "$(echo -e '\nAre you using a proxy [proxy:port] ? ')" proxysv
    proxymc=$(grep -oE $proxyrg <<< $proxysv)
    if test "$proxysv" == "$proxymc"
    then
      echo "Proxy set to [$proxysv] !"
      git config --global http.proxy "$proxysv"
    else
      git config --global -l
      git config --global --unset http.proxy
    fi

    verclang=$(clang --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
    vercmake=$(cmake --version | perl -pe 'if(($_)=/([0-9]+([.][0-9]+)+)/){$_.="\n"}')
    
    cusclangpa=$(which clang)
    read -p "Installed CLang is version: [$verclang] > [6.0]! Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "CLang path: $cusclangpa"
      read -p "Custom CLang path: " cusclangpa
      if [ ! -x "$cusclangpa" ]
      then
        echo "Please install CLang 6.0 or above!"
        echo "http://releases.llvm.org/download.html"
        exit 0
      fi
    fi
    
    # https://www.osetc.com/en/how-to-install-the-latest-version-of-cmake-on-ubuntu-16-04-18-04-linux.html
    cuscmakepa=$(which cmake)
    read -p "Installed CMake is version: [$vercmake] > [3.8]! Continue [y/N] ? " bool
    if test "$bool" != "y"
    then
      echo "CMake path: $cuscmakepa"
      read -p "Custom CMake path: " cuscmakepa
      if [ ! -x "$cuscmakepa" ]
      then
        echo "Please install CMake 3.8 or above!"
        echo "https://github.com/Kitware/CMake/releases"
        exit 0
      fi
    fi
    
    git clone https://github.com/azerothcore/azerothcore-wotlk.git $scriptpath/$servernmae
    
    getMode "Select general install mode:" modeinstall
    
    case "$idtitle" in
    0)
      # http://www.azerothcore.org/wiki/Install-with-Docker
    ;;
    1)
      read -sp "What password does the root user have ? " mysqlpa
      if test "$mysqlpa" == ""
      then
        echo -e "\nVersion: $(mysql --version)"
        echo "To change password for MySQL root user follow the steps below."
        echo "1. sudo /etc/init.d/mysql stop"
        echo "2. sudo pkill mysql"
        echo "3. sudo mkdir -p /var/run/mysqld"
        echo "4. sudo chown mysql /var/run/mysqld"
        echo "5. sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &"
        echo "6. mysql -uroot"
        echo "7. flush privileges;"
        echo "Use the root safe login to change your password."
        echo "Replace the value of <new_password> with your new password."
        echo "1.  use mysql;"
        echo "2.  update user set plugin='mysql_native_password' where user='root';"
        echo "3.  MySQL 5.7+ : update user set authentication_string=PASSWORD('<new_password>') where user='root';"
        echo "4.  MySQL 5.6- : update user set password=PASSWORD('<new_password>') where user='root';"
        echo "5.  If the password function fails use: SET CREDENTIALS FOR 'root' TO '<new_password>';"
        echo "6.  commit;"
        echo "7.  flush privileges;"
        echo "8.  exit;"
        echo "9.  sudo /etc/init.d/mysql stop"
        echo "10. sudo /etc/init.d/mysql start"
        echo "11. If starting the service fails, just restart the system."
        echo "Now start the installation again but this time give the password you set."
        exit 0
      fi
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
