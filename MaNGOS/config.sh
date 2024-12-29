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
  read -p "Enter ID: " res1

  if [[ -z "${info[$res1]}" ]]
  then
    echo "Wrong ID: $res1"
    exit 0
  fi

  res3=$(sed -e 's/.*\[\([^]]*\)\].*/\1/g' <<< ${info[$res1]})
  res2=$(sed -e 's/[^{]*{\([^}]*\)}.*/\1/g' <<< ${info[$res1]})

  echo "Chosen: [$res1] > $res3 > $res2"

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
  echo "cd $PWD" >> $key.sh
  echo "./config.sh start $key" >> $key.sh
  echo -e "" >> $key.sh

  mv $PWD/$key.sh $HOME/Desktop/$key.sh
}

function shCopyConf()
{
  local labe=$1
  local dest=$2
  local sors[1]=$3
  local sors[2]=$4
  local sors[3]=$5
  local sors[4]=$6
  local sors[5]=$7
  
  read -p "Renew $labe [y/N] ? " bool
  if test "$bool" == "y"
  then
    rm -f $dest
    for (( i=0; i<=$(( ${#sors[*]}-1 )); i++ ))
    do
      if [ -f "${sors[$i]}" ]; then
        cp -v ${sors[$i]} $dest
        break
      fi
    done
  fi
}

function getVersion()
{
  local ver="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_SCHEMA='$1mangos'
                AND TABLE_NAME='db_version'
                AND DATA_TYPE='bit'
                AND COLUMN_TYPE='bit(1)';"
  if [ ! -z "$2" ]; then echo -n "$2 ... "; fi
  local res=$(mysql -uroot --silent -e"$ver" 2>&1 > /dev/null)
  if [ ! -z "$res" ]; then
    echo "FAILED > $res"
    false
    return
  else
    echo -n "SUCCESS > "
    for v in $(mysql -uroot -e"$ver")
    do
      if [ ! "COLUMN_NAME" == "$v" ]; then
        echo $v
        return
      fi
    done
  fi
  true
}

echo Source: https://github.com/cmangos/issues/wiki/Installation-Instructions

case "$action" in
  "start")
    getTitle "Select title to start:" idtitle drtitle nmtitle
    case "$option" in
    mangos)
      if test -f "$scriptpath/$drtitle/run/bin/mangosd"; then
        xtitle "${option^^} [${drtitle^^}]"
        result=1
        while [ $result -ne 0 ]; do
          $scriptpath/$drtitle/run/bin/mangosd -c $scriptpath/$drtitle/run/mangosd.conf -a $scriptpath/$drtitle/run/ahbot.conf
          result=$?
        done
      else
        echo "Executable ${option^^} missing for [${nmtitle}] !"
      fi
    ;;
    realm)
      if test -f "$scriptpath/$drtitle/run/bin/realmd"; then
        xtitle "${option^^} [${drtitle^^}]"
        result=1
        while [ $result -ne 0 ]; do
          $scriptpath/$drtitle/run/bin/realmd  -c $scriptpath/$drtitle/run/realmd.conf
          result=$?
        done
      else
        echo "Executable ${option^^} missing for [${nmtitle}] !"
      fi
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
      [ ! -d "$scriptpath/$drtitle" ] && mkdir -p "$scriptpath/$drtitle"
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

      read -p "Enable link-time optimizations [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=1"
      else
        makecmd="$makecmd -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=0"
      fi

      read -p "Enable additional debug-code in core [y/N] ? " bool
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

      read -p "Enable PostgreSQL instead of mysql [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DPOSTGRESQL=ON"
      else
        makecmd="$makecmd -DPOSTGRESQL=OFF"
      fi

      read -p "Enable SQLite instead of mysql [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DSQLITE=ON"
      else
        makecmd="$makecmd -DSQLITE=OFF"
      fi

      read -p "Compile included map extraction tools [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_EXTRACTORS=ON"
      else
        makecmd="$makecmd -DBUILD_EXTRACTORS=OFF"
      fi

      read -p "Compile included map viewer tools [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_RECASTDEMOMOD=ON"
      else
        makecmd="$makecmd -DBUILD_RECASTDEMOMOD=OFF"
      fi

      read -p "Enable building script DEV [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_SCRIPTDEV=ON"
      else
        makecmd="$makecmd -DBUILD_SCRIPTDEV=OFF"
      fi

      read -p "Enable building player bots mod [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_PLAYERBOTS=ON"
      else
        makecmd="$makecmd -DBUILD_PLAYERBOTS=OFF"
      fi

      read -p "Enable action house bots mod [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_AHBOT=ON"
      else
        makecmd="$makecmd -DBUILD_AHBOT=OFF"
      fi

      read -p "Enable metrics, generate data for Grafana [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_METRICS=ON"
      else
        makecmd="$makecmd -DBUILD_METRICS=OFF"
      fi

      read -p "Enable documentation with doxygen [y/N] ? " bool
      if test "$bool" == "y"
      then
        makecmd="$makecmd -DBUILD_DOCS=ON"
      else
        makecmd="$makecmd -DBUILD_DOCS=OFF"
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

      if [ ! -d "$scriptpath/$drtitle/mangos/src" ]; then
        echo "Configuration unavailable. Download sources first !"
        exit 0
      fi

      # find . -name *.conf.* | grep mangosd
      shCopyConf "mangosd" "$scriptpath/$drtitle/run/mangosd.conf"   \
        "$scriptpath/$drtitle/run/etc/mangosd.conf.dist"             \
        "$scriptpath/$drtitle/build/src/mangosd/mangosd.conf.dist"   \
        "$scriptpath/$drtitle/mangos/src/mangosd/mangosd.conf.dist.in"
        
      # find . -name *.conf.* | grep realmd
      shCopyConf "realmd" "$scriptpath/$drtitle/run/realmd.conf"     \
        "$scriptpath/$drtitle/run/etc/realmd.conf.dist"              \
        "$scriptpath/$drtitle/mangos/src/realmd/realmd.conf.dist.in" 

      # find . -name *.conf.* | grep anticheat
      shCopyConf "anticheat system" "$scriptpath/$drtitle/run/anticheat.conf"     \
        "$scriptpath/$drtitle/run/etc/anticheat.conf.dist"                        \
        "$scriptpath/$drtitle/mangos/src/game/Anticheat/module/anticheat.conf.dist.in" 

      # find . -name *.conf.* | grep ahbot
      shCopyConf "action house bot" "$scriptpath/$drtitle/run/ahbot.conf"             \
        "$scriptpath/$drtitle/run/etc/ahbot.conf.dist"                                \
        "$scriptpath/$drtitle/build/src/modules/PlayerBots/ahbot.conf.dist"           \
        "$scriptpath/$drtitle/build/src/mangosd/ahbot.conf.dist"                      \
        "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/ahbot/ahbot.conf.dist.in" \
        "$scriptpath/$drtitle/mangos/src/game/AuctionHouseBot/ahbot.conf.dist.in"

      # find . -name *.conf.* | grep playerbot
      shCopyConf "player bot" "$scriptpath/$drtitle/run/playerbot.conf"           \
        "$scriptpath/$drtitle/run/etc/playerbot.conf.dist"                        \
        "$scriptpath/$drtitle/mangos/src/game/PlayerBot/playerbot.conf.dist.in" 

      # find . -name *.conf.* | grep aiplayerbot
      case "$idtitle" in
      0)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in"      
      ;;
      1)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in.tbc"  
      ;;
      2)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in.wotlk" 
      ;;
      esac
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
    else
      echo "Database password exported to MYSQL_PWD!"
      export MYSQL_PWD="$mysqlpa"
    fi

    read -p "Create MaNGOS databases [y/N] ? " bool
    if test "$bool" == "y"
    then
      mysql -f -uroot < $scriptpath/$drtitle/mangos/sql/create/db_create_mysql.sql
      mysql -uroot -e "flush privileges;"
    fi

    read -p "Initialize the databases [y/N] ? " bool
    if test "$bool" == "y"
    then
      # Check mangos version present
      dummy=$(getVersion $drtitle "Checking mangos version")
      if [[ $dummy != *"FAIL"* ]]
      then
        dummy=$(sed -e "s/^.*\s*>\s*//g" <<< ${dummy})
        if [[ ! -z $dummy ]]
        then
          # Database exists and we must apply the updates
          read -p "Update mangos server since [$drtitle][$dummy] [y/N] ? " bool
          if test "$bool" == "y"
          then
            cd $scriptpath/$drtitle/db/
            rm -f InstallFullDB.config
            chmod +x InstallFullDB.sh
            ./InstallFullDB.sh -UpdateCore
          fi
        else
          # Database does not exist as the version is missing
          # Apply base configuration for mangos
          if [ -f "$scriptpath/$drtitle/mangos/sql/base/mangos.sql" ]; then
            mysql -f -umangos "$drtitle"mangos < $scriptpath/$drtitle/mangos/sql/base/mangos.sql
          fi 
          # Apply base configuration for realmd
          if [ -f "$scriptpath/$drtitle/mangos/sql/base/realmd.sql" ]; then
            mysql -f -umangos "$drtitle"realmd < $scriptpath/$drtitle/mangos/sql/base/realmd.sql
          fi 
          # Apply base configuration for characters
          if [ -f "$scriptpath/$drtitle/mangos/sql/base/characters.sql" ]; then
            mysql -f -umangos "$drtitle"characters < $scriptpath/$drtitle/mangos/sql/base/characters.sql
          fi 
          # Apply base configuration for logs
          if [ -f "$scriptpath/$drtitle/mangos/sql/base/logs.sql" ]; then
            mysql -f -umangos "$drtitle"logs < $scriptpath/$drtitle/mangos/sql/base/logs.sql
          fi 
          # Populate the database entry as empty set is expected
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
        fi
      else
        echo "General version error: $dummy !"
      fi
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
      mysql -f -uroot < $scriptpath/$drtitle/mangos/sql/create/db_drop_mysql.sql
      mysql -uroot -e "flush privileges;"
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
    read -p "DBC file: " dummy
    read -p "Start PK: " startpk
    read -p "End   PK: " endpk
    getTitle "Select a title for extraction:" idtitle drtitle nmtitle
    sqlstmt=$(cat $scriptpath/settings/stmt/${dummy,,}.txt)
    sqlstmt=$(echo ${sqlstmt/\{TITLE\}/$drtitle})
    sqlstmt=$(echo ${sqlstmt/\{STARTPK\}/$startpk})
    sqlstmt=$(echo ${sqlstmt/\{ENDPK\}/$endpk})
    echo "STMT: $sqlstmt"
    read -sp "What password does the root user have ? " mysqlpa
    mysql -uroot -e "$sqlstmt" > dbc-export.txt
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
    echo "dbc-export      --> Exports data from the database associated with a [*.dbc] file."
  ;;
esac

exit 0
