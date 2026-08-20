#!/bin/bash

#This is tremporary script, made for faster testing of this app and get updates

cd "$(dirname "$0")"

#https://askubuntu.com/a/15856
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

cd ./../..
git reset HEAD --hard
git pull --rebase
cd ./AllNodes/installScripts/

sudo chmod +x init.sh
sudo chmod +x unis.sh

sudo ./unis.sh
sudo ./init.sh