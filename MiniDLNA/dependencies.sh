#!/bin/bash

apt-get update

# Dependancies

apt-get install libexif
apt-get install libjpeg
apt-get install libid3tag
apt-get install libFLAC
apt-get install libvorbis
apt-get install libsqlite3
apt-get install libavformat

# Needed compiling binaries

apt-get install libavutil-dev
apt-get install libavcodec-dev
apt-get install libavformat-dev
apt-get install libjpeg-dev
apt-get install libsqlite3-dev
apt-get install libexif-dev
apt-get install libid3tag0-dev
apt-get install libbogg-dev
apt-get install libvorbis-dev
apt-get install libflac-dev

# Compiling tools

apt-get install autoconf
apt-get install automake
apt-get install autopoint
apt-get install make

# Configuration tools

apt-get install checkinstall
apt-get install git
apt-get install gksu

exit 0
