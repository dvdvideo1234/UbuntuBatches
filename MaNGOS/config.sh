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
defpworld=""
defprealm=""
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

function syncClinetMapData()
{
  if sudo test -d "$1/mount/$2/$3"; then
    echo "Synchronization for [/$2/run/$3]..." 
    sudo rsync -ar --progress --info=name0 --info=progress2 "$1/mount/$2/$3" "$1/$2/run/"
    sudo chown -R mangos:mangos "$1/$2/run/$3"
    sudo chmod 755 "$1/$2/run/$3"
  fi
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

function getPasswordSQL()
{
  local pass=""
  read -p "What password does the root user have ? " pass
  if test "$pass" == ""
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
    export MYSQL_PWD="$pass"
  fi
  
  eval "$1='$pass'"
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

function updateConfigDB()
{
  cd $1/db 
  # Wipe the configuration file
  rm -f InstallFullDB.config
  # Generate new configuration file
  chmod +x InstallFullDB.sh
  # Update configuration file
  ./InstallFullDB.sh -Config
  # Apply core path
  read -p "Apply CORE_PATH value [y/N] ? " bool
  if test "$bool" == "y"
  then
    sed -i "s@.*CORE_PATH=.*@CORE_PATH=\"$1/mangos\"@" InstallFullDB.config
  fi
  # Apply dev updates
  read -p "Enable DEV_UPDATES [y/N] ? " bool
  if test "$bool" == "y"
  then
    sed -i "s@.*DEV_UPDATES=.*@DEV_UPDATES=\"YES\"@" InstallFullDB.config
  fi
  # Apply action house bot
  read -p "Enable AHBOT [y/N] ? " bool
  if test "$bool" == "y"
  then
    sed -i "s@.*AHBOT=.*@AHBOT=\"YES\"@" InstallFullDB.config
  fi
  # Apply action house bot
  read -p "Enable PLAYERBOTS [y/N] ? " bool
  if test "$bool" == "y"
  then
    sed -i "s@.*PLAYERBOTS_DB=.*@PLAYERBOTS_DB=\"YES\"@" InstallFullDB.config
  fi
  # Revert the current directory to the base one
  cd $1
}

function updateConfigRun()
{
  cd $1/run
  # Prepare logs destination folder
  [ ! -d "$1/run/logs" ] && mkdir -p "$1/run/logs"
  # Update configuration contents run folder
  sed -i "s@.*DataDir.*=.*@DataDir = \"$1/run\"@" mangosd.conf
  # Update configuration contents realm port
  sed -i "s@.*RealmServerPort.*=.*@RealmServerPort = \"$2\"@" realmd.conf
  # Update configuration contents realm logs
  sed -i "s@.*LogsDir.*=.*@LogsDir = \"$1/run/logs\"@" realmd.conf
  # Update configuration contents world port
  sed -i "s@.*WorldServerPort.*=.*@WorldServerPort = \"$3\"@" mangosd.conf
  # Update configuration contents world logs
  sed -i "s@.*LogsDir.*=.*@LogsDir = \"$1/run/logs\"@" mangosd.conf
  # Revert the current directory to the base one
  cd $1
}

function updateRealmlistDB()
{
  local idx=""
  local rlm="$2"
  echo "Realms available in the database:"
  local wtf="SELECT CONCAT('|', LPAD(id, 10,  '_'), '|',
                    RPAD(SUBSTRING(name, 1, 30), 30 ,'_'), '|',
                    LPAD(address, 16,  '_'), ':',
                    RPAD(port, 6,  '_'), '|') FROM $1realmd.realmlist;"  
  for v in $(mysql -uroot -N -e "$wtf"); do echo "$v"; done
  if [[ -z $rlm ]]; then
    read -p "Enter realmlist descriptor (zero proxy no change) [REALM:PORT] " rlm
  fi
  if [[ -z "$rlm" ]]; then return; fi
  echo "Realmlist descriptor: [$rlm]"
  local prr=$(grep -oE $proxyrg <<< $rlm)
  if test "$rlm" = "$prr"; then
    local con=(${rlm//:/ })
    echo "New host address: IP ${con[0]} PORT ${con[1]}"
    read -p "Choose a realm to be updated: " idx
    if [[ ! -z $idx ]]; then
      local wtf="UPDATE $1realmd.realmlist
                    SET ADDRESS = IFNULL(NULLIF('${con[0]}', '0.0.0.0'), ADDRESS),
                           PORT = IFNULL(NULLIF('${con[1]}', '00000'), PORT)
                  WHERE ID = $idx; COMMIT;"
      mysql -uroot -e "$wtf"
    fi
  else
    echo "Realm configuration invalid [$rlm]!"
  fi
}

function getDefautPorts()
{
  local rep="3724"
  local wrp="8085"
  case "$1" in
    classic)
      rep=$(expr $rep + 0)
      wrp=$(expr $wrp + 0)
    ;;
    tbc)
      rep=$(expr $rep + 1)
      wrp=$(expr $wrp + 1)
    ;;
    wotlk)
      rep=$(expr $rep + 2)
      wrp=$(expr $wrp + 2)
    ;;
    cata)
      rep=$(expr $rep + 3)
      wrp=$(expr $wrp + 3)
    ;;
    pandaria)
      rep=$(expr $rep + 4)
      wrp=$(expr $wrp + 4)
    ;;
    legion)
      rep=$(expr $rep + 5)
      wrp=$(expr $wrp + 5)
    ;;
    *)
      echo "Default ports for title [$1] undefined !"
      exit 0
    ;;
  esac
  eval "$2='$rep'"
  eval "$3='$wrp'"
}

echo Source: https://github.com/cmangos/issues/wiki/Installation-Instructions

case "$action" in
  "reroute")
    getTitle "Select title to be rerouted:" idtitle drtitle nmtitle
    getDefautPorts "$drtitle" defprealm defpworld
    updateConfigRun "$scriptpath/$drtitle" "$defprealm" "$defpworld"
  ;;
  "rehost")
    getTitle "Select title to be rehosted:" idtitle drtitle nmtitle
    updateRealmlistDB "$drtitle"
  ;;
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
    
    if [ ! -d "$scriptpath/mount/$drtitle" ]; then
      echo "Creating client mount point path: [$scriptpath/mount/$drtitle]..."
      mkdir -p "$scriptpath/mount/$drtitle"
    fi

    read -p "Install dependencies [y/N] ? " bool
    if test "$bool" == "y"
    then
      yes y | ./dependencies.sh
    fi

    read -p "$(echo -e '\nAre you using a proxy [PROXY:PORT] ? ')" proxysv
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
      case "$drtitle" in
      classic)
        git clone https://github.com/cmangos/mangos-classic.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/classic-db.git $scriptpath/$drtitle/db
      ;;
      tbc)
        git clone https://github.com/cmangos/mangos-tbc.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/tbc-db.git $scriptpath/$drtitle/db
      ;;
      wotlk)
        git clone https://github.com/cmangos/mangos-wotlk.git $scriptpath/$drtitle/mangos
        git clone https://github.com/cmangos/wotlk-db.git $scriptpath/$drtitle/db
      ;;
      cata)
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
      case "$drtitle" in
      classic)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in"      
      ;;
      tbc)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in.tbc"  
      ;;
      wotlk)
        shCopyConf "player bot AI" "$scriptpath/$drtitle/run/aiplayerbot.conf"                        \
          "$scriptpath/$drtitle/run/etc/aiplayerbot.conf.dist"                                        \
          "$scriptpath/$drtitle/build/src/modules/PlayerBots/aiplayerbot.conf.dist"                   \
          "$scriptpath/$drtitle/mangos/src/modules/PlayerBots/playerbot/aiplayerbot.conf.dist.in.wotlk" 
      ;;
      esac
    fi

    getPasswordSQL mysqlpa
    if test "$mysqlpa" == ""
    then
      echo "Please provide mysql root password first !"
      exit 0
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
            updateConfigDB "$scriptpath/$drtitle"
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
            case "$drtitle" in
            classic|tbc|wotlk)
              updateConfigDB "$scriptpath/$drtitle"
              read -p "Start the database population  [y/N] ? " bool
              if test "$bool" == "y"
              then
                ./InstallFullDB.sh -InstallAll "root" "$mysqlpa" "DeleteAll"
              fi
            ;;
            cata)
              echo "$nmtitle package DB installation not matched to git [$idtitle][$drtitle] !"
            ;;
            *)
              echo "$nmtitle package DB installation not defined to git [$idtitle][$drtitle] !"
            ;;
            esac
          fi
        fi
      else
        echo "General version error: $dummy !"
      fi
    fi
    
    getDefautPorts "$drtitle" defprealm defpworld
    updateConfigRun "$scriptpath/$drtitle" "$defprealm" "$defpworld"
    updateRealmlistDB "$drtitle" "0.0.0.0:$defpworld"
    
    echo "For extracting the files from the client you can follow the link below:"
    echo "https://github.com/cmangos/issues/wiki/Installation-Instructions#extract-files-from-the-client"
    
    if sudo test -d "$scriptpath/$drtitle/run/bin/tools"; then
      if sudo test -d "$scriptpath/mount/$drtitle"; then
        # Copy the map exreation tools to the client mount point
        echo -n "Copy the map extraction tools to client... "
        sudo chown -R mangos:mangos "$scriptpath/$drtitle/run"
        sudo cp -r -a -f $scriptpath/$drtitle/run/bin/tools/. $scriptpath/mount/$drtitle
        echo "OK"
        # Start map extraction process. Handled by `ExtractResources.sh`
        read -p "Start client map extraction process [y/N] ? " bool
        if test "$bool" == "y"
        then
          sudo sh -c "cd $scriptpath/mount/$drtitle 2> /dev/null && ./ExtractResources.sh || echo FAIL"
        fi
        # Synchronize the needed folder after completion
        read -p "Start client map synchronization [y/N] ? " bool
        if test "$bool" == "y"
        then
          syncClinetMapData "$scriptpath" "$drtitle" "Buildings"
          syncClinetMapData "$scriptpath" "$drtitle" "Cameras"
          syncClinetMapData "$scriptpath" "$drtitle" "dbc"
          syncClinetMapData "$scriptpath" "$drtitle" "vmaps"
          syncClinetMapData "$scriptpath" "$drtitle" "maps"
          syncClinetMapData "$scriptpath" "$drtitle" "mmaps"
        fi
      else
        echo "Client for [$drtitle] not mounted properly!"
      fi
    else
      echo "Map extraction tools for [$drtitle] not compiled!"
    fi
  ;;
  "drop-mangos")
    echo "This will delete the MaNGOS database from your SQL server !!!"
    read -p "Continue with this process [y/N] ? " bool
    if test "$bool" == "y"
    then
      getPasswordSQL mysqlpa
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
      sudo apt-get --purge remove mysql-server
      sudo apt-get --purge remove mysql-client
      sudo apt-get --purge remove mysql-common
      sudo apt-get --purge remove mysql-server-core
      sudo apt-get --purge remove mysql-client-core
      sudo rm -rf /etc/mysql /var/lib/mysql
      sudo apt-get autoremove
      sudo apt-get autoclean
    fi
  ;;
  "setup")
    getTitle "Select a title for the configuration:" idtitle drtitle nmtitle
    echo "Options: { mangosd | realmd | ahbot | anticheat | playerbot | aiplayerbot }"
    case "$option" in
    mangosd|realmd|ahbot|anticheat|playerbot|aiplayerbot)
      vim $scriptpath/$drtitle/run/$option.conf
    ;;
    *)
      echo "Wrong configuration name [$option]!"
      echo "Options: { mangosd | realmd | ahbot | anticheat | playerbot | aiplayerbot }"
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
    getPasswordSQL mysqlpa
    if test "$mysqlpa" == ""
    then
      echo "Please provide mysql root password first !"
      exit 0
    fi
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
