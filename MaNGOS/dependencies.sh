#!/bin/bash

sudo apt-get update

# Dependencies

sudo apt-get install vim
sudo apt-get install build-essential
sudo apt-get install gcc
sudo apt-get install g++
sudo apt-get install automake
sudo apt-get install git-core
sudo apt-get install autoconf
sudo apt-get install make
sudo apt-get install patch
sudo apt-get install libmysql++-dev
sudo apt-get install mysql-server
sudo apt-get install libmysqlclient-dev
sudo apt-get install libtool
sudo apt-get install libssl-dev
sudo apt-get install grep
sudo apt-get install binutils
sudo apt-get install zlibc
sudo apt-get install libc6
sudo apt-get install libbz2-dev
sudo apt-get install cmake
sudo apt-get install subversion
sudo apt-get install libboost-all-dev
sudo apt-get install xtitle
sudo apt-get install rsync

# Clean PPAs
sudo apt-get autoremove
sudo apt-get autoclean

exit 0
