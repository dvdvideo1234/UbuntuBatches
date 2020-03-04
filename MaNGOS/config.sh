#!/bin/bash

action="$1"
option="$2"
bool=""
idtitle=""
nmtitle=""
drtitle=""
mysqlpa=""
makecmd=""
proxysv=""
proxymc=""
proxyrg="([0-9]{1,3}\.){3}[0-9]{1,3}\:[0-9]{1,5}"
dummy=""
startpk=""
endpk=""
sqlstmt=""
result=0

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

function shCreateDesktop()
{
  local key=$1
  echo "#!/bin/bash" > $key.sh
  chmod +x $key.sh
  echo -e "" >> $key.sh
  echo "xtitle \"${key^^}\"" >> $key.sh
  echo -e "" >> $key.sh
  echo "cd $PWD" >> $key.sh
  echo "./config.sh start $key" >> $key.sh

  mv $PWD/$key.sh $HOME/Desktop/$key.sh
}

echo Source: https://github.com/cmangos/issues/wiki/Installation-Instructions

case "$action" in
  "start")
    getTitle "Select title to start:" idtitle drtitle nmtitle
    case "$option" in
    mangos)
      result=1
      while [ $result -ne 0 ]; do
        $scriptpath/$drtitle/run/bin/mangosd -c $scriptpath/$drtitle/run/mangosd.conf -a $scriptpath/$drtitle/run/ahbot.conf
        result=$?
      done
    ;;
    realm)
      result=1
      while [ $result -ne 0 ]; do
        $scriptpath/$drtitle/run/bin/realmd  -c $scriptpath/$drtitle/run/realmd.conf
        result=$?
      done
    ;;
    *)
      echo "Wrong configuration name [$option]!"
      echo "Options: { mangos | realm }"
    ;;
    esac
  ;;
  "install")
    getTitle "The directory will be created automatically\nWhich title do you want to install ?" idtitle drtitle nmtitle

    echo "Installing package: <$nmtitle> in $scriptpath/$drtitle"

    read -p "Install dependencies [y/N] ? " bool
    if test "$bool" == "y"
    then
      yes y | ./dependencies.sh
    fi

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
      echo "1. use mysql;"
      echo "2. update user set plugin='mysql_native_password' where user='root';"
      echo "3. MySQL 5.7+ : update user set authentication_string=PASSWORD('<new_password>') where user='root';"
      echo "4. MySQL 5.6- : update user set password=PASSWORD('<new_password>') where user='root';"
      echo "5. If the password conversion function does not work use: SET CREDENTIALS FOR 'root' TO '<new_password>';"
      echo "6. flush privileges;"
      echo "7. commit;"
      echo "8. exit;"
      echo "9. sudo /etc/init.d/mysql stop"
      echo "10. sudo /etc/init.d/mysql start"
      echo "11. If starting the service fails, just restart the system."
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
        git clone https://github.com/cmangos/mangos-classic.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/classic-db.git $scriptpath/$drtitle/db
      ;;
      1)
        git clone https://github.com/cmangos/mangos-tbc.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/tbc-db.git $scriptpath/$drtitle/db
      ;;
      2)
        git clone https://github.com/cmangos/mangos-wotlk.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/wotlk-db.git $scriptpath/$drtitle/db
      ;;
      3)
        git clone https://github.com/cmangos/mangos-cata.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/cata-db.git $scriptpath/$drtitle/db
      ;;
      *)
        echo "$nmtitle package not matched to git [$idtitle][$drtitle] !"
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

      read -p "Enable precompiled headers [y/N] ? " bool
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

      read -p "Enable PostgreSQL [y/N] ? " bool
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

      read -p "Enable building script DEV [y/N] ? " bool
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
      [ ! -d "$scriptpath/$drtitle/run" ] && mkdir -p "$scriptpath/$drtitle/run"

      rm -f $scriptpath/$drtitle/run/mangosd.conf
      rm -f $scriptpath/$drtitle/run/realmd.conf
      rm -f $scriptpath/$drtitle/run/ahbot.conf

      if [ -d "$scriptpath/$drtitle/mangos/src" ]; then
        cp $scriptpath/$drtitle/mangos/src/mangosd/mangosd.conf.dist.in $scriptpath/$drtitle/run/mangosd.conf
        cp $scriptpath/$drtitle/mangos/src/realmd/realmd.conf.dist.in $scriptpath/$drtitle/run/realmd.conf
        cp $scriptpath/$drtitle/mangos/src/game/AuctionHouseBot/ahbot.conf.dist.in $scriptpath/$drtitle/run/ahbot.conf
      else
        echo "Configuration unavailable. Download sources !"
        exit 0
      fi
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
      read -sp "What password does the root user have ? " mysqlpa
      if test "$mysqlpa" == ""
      then
        echo "Please provide mysql root password first !"
        exit 0
      fi
      getTitle "Select a title for the drop process:" idtitle drtitle nmtitle
      mysql -f -uroot -p$mysqlpa < $scriptpath/$drtitle/mangos/sql/create/db_drop_mysql.sql
      mysql -uroot -p$mysqlpa -e "flush privileges;"
    fi
  ;;
  "purge-mysql")
    echo "This will purge the mysql package like it was never installed !"
    echo "All the data will be deleted and SQL uninstalled !!!"
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
  "setup")
    getTitle "Select a title for the configuration:" idtitle drtitle nmtitle
    case "$option" in
    mangosd|realmd|ahbot)
      vim $scriptpath/$drtitle/run/$option.conf
    ;;
    *)
      echo "Wrong configuration name [$option]!"
      echo "Options: { mangosd | realmd | ahbot }"
    ;;
    esac
  ;;
  "paths")
    echo "Home: $HOME"
    echo "PWDD: $PWD"
    echo "Name: $scriptname"
    echo "Path: $scriptpath"
  ;;
  "desktop-sh")
    shCreateDesktop "realm"
    shCreateDesktop "mangos"
  ;;
  "dbc-export")
    read -p "File: " dummy
    dummy="${dummy,,}"
    echo $dummy
    sqlstmt=$(cat $scriptpath/settings/stmt/$dummy.txt)
    echo $sqlstmt
    getTitle "Select title to start:" idtitle drtitle nmtitle
    read -sp "What password does the root user have ? " mysqlpa
    read -p "Start: " startpk
    read -p "End  : " endpk
    
    
    
    
    mysql -uroot -p$mysqlpa > dbc-export.txt

  ;;
  *)
    echo "Please use some of the options in the list below for [./config.sh]."
    echo "start <option>  --> Starts the server according to the option [mangos][realm] provided."
    echo "install         --> Installs the sever in the folder chosen. Uses the script location."
    echo "drop-mangos     --> Removes the mangos database from the SQL server. Done by project collaborators."
    echo "purge-mysql     --> Completely removes the SQL server installed in dependencies."
    echo "setup <option>  --> Edits the server configuration according to the option [mangos][realm][ahbot] provided."
    echo "desktop-sh      --> Creates titled terminals startup scripts on the desktop for both server processes."
    echo "paths           --> Displays the private server paths used by the installation."
  ;;
esac

exit 0
