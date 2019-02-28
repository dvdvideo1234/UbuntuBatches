#!/bin/bash

action="$1"

bool=""
idtitle=""
nmtitle=""
drtitle=""
proxysv=""
mysqlpa=""
makecmd=""
proxymc=""
proxyrg="([0-9]{1,3}\.){3}[0-9]{1,3}\:[0-9]{1,5}"
dummy=""

scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

function getTitle()
{
  local res1=""
  local res2=""
  local res3=""

  # Title names
  local info[0]="[Vanilla] {classic}"
  local info[1]="[The burning crusade (TBC)] {tbc}"
  local info[2]="[Wrath of the lich king (WoTLK)] {wotlk}"
  local info[3]="[Cataclysm] {cata}"
  local info[4]="[Mists of Pandaria (MoP)] {pandaria}"
  local info[5]="[Legion] {legion}"

  echo -e $1

  for (( i=0; i<=$(( ${#info[*]} -1 )); i++ ))
  do
    echo "$i >> $(sed -e 's/.*\[\([^]]*\)\].*/\1/g' <<< ${info[$i]})"
  done
  read -p "Enter title ID: " res1

  if [[ -z "${info[$res1]}" ]]
  then
    echo "Wrong title ID: $res1"
    exit 0
  fi

  res3=$(sed -e 's/.*\[\([^]]*\)\].*/\1/g' <<< ${info[$res1]})
  res2=$(sed -e 's/[^{]*{\([^}]*\)}.*/\1/g' <<< ${info[$res1]})

  echo "getTitle: [$res1] > $res3 > $res2"

  eval "$2='$res1'"
  eval "$3='$res2'"
  eval "$4='$res3'"
}

echo Source: https://github.com/cmangos/issues/wiki/Installation-Instructions

case "$action" in
  "start")
    getTitle "Select title to start:" idtitle drtitle nmtitle

    echo "Starting package: $nmtitle ..."

    $scriptpath/$drtitle/run/bin/mangosd -c $scriptpath/$drtitle/run/mangosd.conf -a $scriptpath/$drtitle/run/ahbot.conf
    $scriptpath/$drtitle/run/bin/realmd  -c $scriptpath/$drtitle/run/realmd.conf
  ;;
  "install")
    getTitle "The directory will be created automatically\nWhich title do you want to install ?" idtitle drtitle nmtitle

    echo "Installing package: <$nmtitle> in $scriptpath/$drtitle"

    read -p "Install dependencies [y/N] ? " bool
    if test "$bool" == "y"
    then
      apt-get update
      # Dependencies
      apt-get install build-essential
      apt-get install gcc
      apt-get install g++
      apt-get install automake
      apt-get install git-core
      apt-get install autoconf
      apt-get install make
      apt-get install patch
      apt-get install libmysql++-dev
      apt-get install mysql-server
      apt-get install libtool
      apt-get install libssl-dev
      apt-get install grep
      apt-get install binutils
      apt-get install zlibc
      apt-get install libc6
      apt-get install libbz2-dev
      apt-get install cmake
      apt-get install subversion
      apt-get install libboost-all-dev
    fi
    
    read -sp "What password does the mysql root user have ? " mysqlpa
    if test "$mysqlpa" == ""
    then
      echo -e "\nVersion: $(mysql --version)"
      echo "To change password for MySQL root user follow the steps below."
      echo "1. sudo pkill mysql"
      echo "2. sudo mkdir -p /var/run/mysqld"
      echo "3. sudo chown mysql /var/run/mysqld"
      echo "4. sudo mysqld_safe --skip-grant-tables &"
      echo "5. mysql -uroot" 
      echo "Use the root safe login to change your password."
      echo "Replace the value of <new_password> with your new password."
      echo "1. use mysql;"
      echo "2. update user set plugin='mysql_native_password' where User='root';"
      echo "3. MySQL 5.7+ : update user set authentication_string=PASSWORD('<new_password>') where user='root';"
      echo "4. MySQL 5.6- : update user set password=PASSWORD('<new_password>') where user='root';"
      echo "5. flush privileges;"
      echo "6. commit;"
      echo "7. exit;"
      echo "8. sudo /etc/init.d/mysql stop"
      echo "9. sudo /etc/init.d/mysql start"
      echo "Now start the installation again but this time give the password you set."
      exit 0
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

    read -p "Download the sources [y/N] ? " bool
    if test "$bool" == "y"
    then
      cd $scriptpath
      mkdir $drtitle
      cd $scriptpath/$drtitle

      rm -rf mangos
      rm -rf db
      case "$idtitle" in
      0)
        git clone https://github.com/cmangos/mangos-$drtitle.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/$drtitle-db.git $scriptpath/$drtitle/db
      ;;
      1)
        git clone https://github.com/cmangos/mangos-$drtitle.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/$drtitle-db.git $scriptpath/$drtitle/db
      ;;
      2)
        git clone https://github.com/cmangos/mangos-$drtitle.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/$drtitle-db.git $scriptpath/$drtitle/db
      ;;
      3)
        git clone https://github.com/cmangos/mangos-$drtitle.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/$drtitle-db.git $scriptpath/$drtitle/db
      ;;
      *)
        echo "$nmtitle package not matched to git [$idtitle] !"
        exit 0
      ;;
      esac
    fi

    read -p "Rebuild the sources [y/N] ? " bool
    if test "$bool" == "y"
    then
      rm -rf $scriptpath/$drtitle/build
      mkdir  $scriptpath/$drtitle/build
         cd  $scriptpath/$drtitle/build

      makecmd="cmake ../mangos -DCMAKE_INSTALL_PREFIX=$scriptpath/$drtitle/run"

      read -p "Enable compilation debug mode [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DDEBUG=1"
      else
        makecmd="$makecmd -DDEBUG=0"
      fi

      read -p "Enable precomputed headers [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DPCH=1"
      else
        makecmd="$makecmd -DPCH=0"
      fi

      read -p "Show warnings during compilation [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DWARNINGS=ON"
      else
        makecmd="$makecmd -DWARNINGS=OFF"
      fi

      read -p "Enable Postgre SQL [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DPOSTGRESQL=ON"
      else
        makecmd="$makecmd -DPOSTGRESQL=OFF"
      fi

      read -p "Compile included map extraction tools [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_EXTRACTORS=ON"
      else
        makecmd="$makecmd -DBUILD_EXTRACTORS=OFF"
      fi

      read -p "Enable building scriptdev [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_SCRIPTDEV=ON"
      else
        makecmd="$makecmd -DBUILD_SCRIPTDEV=OFF"
      fi

      read -p "Enable building player bot mod [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_PLAYERBOT=ON"
      else
        makecmd="$makecmd -DBUILD_PLAYERBOT=OFF"
      fi

      echo Command: $makecmd

      eval "$makecmd"
      make
      make install
    fi

    read -p "Renew the configuration [y/N] ? " bool
    if test "$bool" == "y"
    then
      rm -f $scriptpath/$drtitle/run/mangosd.conf
      rm -f $scriptpath/$drtitle/run/realmd.conf
      rm -f $scriptpath/$drtitle/run/ahbot.conf
      cp $scriptpath/$drtitle/mangos/src/mangosd/mangosd.conf.dist.in $scriptpath/$drtitle/run/mangosd.conf
      cp $scriptpath/$drtitle/mangos/src/realmd/realmd.conf.dist.in $scriptpath/$drtitle/run/realmd.conf
      cp $scriptpath/$drtitle/mangos/src/game/AuctionHouseBot/ahbot.conf.dist.in $scriptpath/$drtitle/run/ahbot.conf
    fi

    read -p "Create MaNGOS databases [y/N] ? " bool
    if test "$bool" == "y"
    then
      mysql -f -uroot -p$mysqlpa < $scriptpath/$drtitle/mangos/sql/create/db_create_mysql.sql
      mysql -uroot -p$mysqlpa -e "flush privileges;"
    fi

    read -p "Initialize the databases [y/N] ? " bool
    if test "$bool" == "y"
    then
      mysql -f -umangos -pmangos "$drtitle"mangos < $scriptpath/$drtitle/mangos/sql/base/mangos.sql
      mysql -f -umangos -pmangos "$drtitle"characters < $scriptpath/$drtitle/mangos/sql/base/characters.sql
      mysql -f -umangos -pmangos "$drtitle"realmd < $scriptpath/$drtitle/mangos/sql/base/realmd.sql
    fi

    read -p "Populate the database [y/N] ? " bool
    if test "$bool" == "y"
    then
      case "$idtitle" in
      0|1|2)
        cd $scriptpath/$drtitle/db/
        rm -f InstallFullDB.config
        chmod +x InstallFullDB.sh
        ./InstallFullDB.sh
        read -p "Apply CORE_PATH value [y/N] ? " bool
        if test "$bool" == "y"
        then
          sed -i "s@.*CORE_PATH=.*@CORE_PATH=\"$scriptpath/$drtitle/mangos\"@" InstallFullDB.config
        fi
        read -p "Apply ACID_PATH value [y/N] ? " bool
        if test "$bool" == "y"
        then
          sed -i "s@.*ACID_PATH=.*@ACID_PATH=\"$scriptpath/$drtitle/db/ACID\"@" InstallFullDB.config
        fi
        read -p "Enable DEV_UPDATES [y/N] ? " bool
        if test "$bool" == "y"
        then
          sed -i "s@.*DEV_UPDATES=.*@DEV_UPDATES=\"YES\"@" InstallFullDB.config
        fi
        read -p "Start the database population  [y/N] ? " bool
        if test "$bool" == "y"
        then
          ./InstallFullDB.sh
        fi
      ;;
      3)
        echo "$nmtitle package DB installation not matched to git [$idtitle] !"
      ;;
      *)
        echo "$nmtitle package DB installation not defined to git [$idtitle] !"
      ;;
      esac
    fi

    echo For extracting the files from the client you can follow the link below:
    echo https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client

  ;;
  "drop-mangos")
    echo "This will delete the MaNGOS database from your SQL server !!!"
    read -p "Continue with this process [y/N] ? " bool
    if test "$bool" == "y"
    then
      getTitle "Select a title for the drop process:" idtitle drtitle nmtitle
      mysql -f -uroot -p$mysqlpa < $scriptpath/$drtitle/mangos/sql/create/db_drop_mysql.sql
      mysql -uroot -p$mysqlpa -e "flush privileges;"
    fi
  ;;
  "purge-mysql-server")
    echo "This will purge the mysql package like it was never installed"
    echo "All the data will be deleted and SQL uninstalled!!!"
    read -p "Continue with this process [y/N] ? " bool
    if test "$bool" == "y"
    then
      apt-get --purge remove mysql-server
      apt-get --purge remove mysql-client
      apt-get --purge remove mysql-common
      apt-get --purge remove mysql-server-core
      apt-get --purge remove mysql-client-core
      rm -rf /etc/mysql /var/lib/mysql
      apt-get autoremove
      apt-get autoclean
    fi
  ;;
  "config")
    getTitle "Select a title for the configuration:" idtitle drtitle nmtitle
    gksu gedit $scriptpath/$drtitle/run/mangosd.conf
    gksu gedit $scriptpath/$drtitle/run/realmd.conf
    gksu gedit $scriptpath/$drtitle/run/ahbot.conf
  ;;
  "stats")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  *)
    echo "Usage: $0 { update | install | remove | config | stats }"
  ;;
esac

exit 0
