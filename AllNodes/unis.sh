#!/bin/bash

#temp script, will be redone later!

#https://askubuntu.com/a/15856
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

sudo userdel Galena
sudo rm -rd /home/Galena
sudo rm /etc/sudoers.d/Galena