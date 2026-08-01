#!/bin/bash

# This is used to init main node? We can maybe use the same for others?

#https://askubuntu.com/a/15856
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

$nameSpace="Galena"

echo "This will create you a new user called Galena"

if id "$nameSpace" &>/dev/null; then
    echo "$nameSpace was alredy initialised."
else
    match=0
    while(( $math ==0 )); do
    read -p "Enter '$nameSpace' password: " password
    echo
    read -p "Confirm Password: " confirm
    echo
    if [[ "$password" == "$confirm" ]]; then
        match=1
    end
    done

    useradd $nameSpace -p $password
    sudo usermod -a -G sudo $nameSpace

    echo "Created '$nameSpace'"
end

sudo apt update && sudo apt upgrade

echo "Downlaoding dependencies (might ask for some configuration, not fully automatic!)"
sudo apt install -y python3 python3-pip sqlite3

echo "Next time you log in and out 'Galena' should start working!"