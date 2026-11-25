#!/bin/bash

bool=""
forURL="https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip"
scriptname=$(readlink -f "$0")
scriptpath=$(dirname "$scriptname")

read -p "Install dependencies [y/n] ? " bool
if test "$bool" = "y"
then
  cd $scriptpath
  rm -rf "beauty"
  rm -rf "sqlcl"
  sudo apt-get update
  sudo apt-get install git
  sudo apt-get install unzip
  sudo apt-get install maven
  sudo apt-get install default-jdk
fi

# Configure and extract SQLcl

if [ ! -d "$scriptpath/sqlcl" ]; then
  mkdir -p "sqlcl"
  cd "$scriptpath/sqlcl"
 
  if command -v wget >/dev/null 2>&1; then
    wget -O "current.zip" "$forURL"
  elif command -v curl >/dev/null 2>&1; then
    curl -o "current.zip" -LO "$forURL"
  else
    echo "Error: Neither wget nor curl is installed." >&2
    exit 1
  fi
  cd "$scriptpath/sqlcl"
  unzip "current.zip"
fi

# Configure and extract java beautifier

if [ ! -d "$scriptpath/beauty" ]; then
  git clone https://github.com/PhilippSalvisberg/plsql-formatter-settings.git "$scriptpath/beauty"
  cd "$scriptpath/beauty/standalone"

  SQLCL_LIB="$scriptpath/sqlcl/sqlcl/lib"
  VER=23.4.0

  # groupId:artifactId:file in SQLcl lib
  DEPS=(
    "oracle.dbtools:dbtools-common:dbtools-common.jar"
    "oracle.dbtools:dbtools-sqlcl:dbtools-sqlcl.jar"
    "oracle.dbtools:dbtools-arbori:dbtools-arbori.jar"
    "oracle.xml:xmlparserv2-sans-jaxp-services:xmlparserv2_sans_jaxp_services.jar"
    "oracle.i18n:orai18n:orai18n.jar"
    "oracle.i18n:orai18n-mapping:orai18n-mapping.jar"
    "oracle.soda:orajsoda:orajsoda.jar"
  )

  for dep in "${DEPS[@]}"; do
    IFS=':' read -r gid aid file <<< "$dep"
    if [ ! -f "$SQLCL_LIB/$file" ]; then
      echo "ERROR: $SQLCL_LIB/$file not found" >&2
      exit 1
    fi
    mvn -q install:install-file \
      -Dfile="$SQLCL_LIB/$file" \
      -DgroupId="$gid" \
      -DartifactId="$aid" \
      -Dversion="$VER" \
      -Dpackaging=jar
  done
  # [ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.10.1:testCompile (default-testCompile) on project tvdformat
  # find ./ -type f | xargs grep -n "dbtools.arbori.Program" 2>/dev/null
  # grep -rl --include='*.jar' 'oracle/dbtools/arbori/Program.class' "$scriptpath/sqlcl"
  mvn -U -e -DskipTests -Dsqlcl.libdir="$SQLCL_LIB" package
fi

cd "$scriptpath"
