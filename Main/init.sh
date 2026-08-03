#!/bin/bash

# This is used to init main node? We can maybe use the same for others?

#https://askubuntu.com/a/15856
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

nameSpace="Galena"

echo "This will create you a new user called Galena"

if id "$nameSpace" &>/dev/null; then
    echo "$nameSpace was alredy initialised."
else
    #match=0
    #while [[ "$match" == 0 ]]; do
    #    read -p "Enter '$nameSpace' password: " password
    #    echo
    #    read -p "Confirm Password: " confirm
    #    echo
    #    if [[ "$password" == "$confirm" ]]; then
    #        match=1
    #    fi
    #done

    useradd --create-home --shell /bin/bash $nameSpace
    sudo passwd $nameSpace
    sudo usermod -a -G sudo $nameSpace

    echo "Created '$nameSpace'"
fi

mkdir -p /home/$nameSpace/ServerData
cp -r . /home/$nameSpace/ServerData
chown -R $nameSpace:$nameSpace /home/$nameSpace/ServerData

sudo apt update && sudo apt upgrade

echo "Downlaoding dependencies (might ask for some configuration, not fully automatic!)"
sudo apt install -y python3 python3-pip sqlite3

echo "Executing initialisation of Constructs!"

place=$(pwd)
cd /home/$nameSpace/ServerData
sudo -u $nameSpace python3 buildConstruct.py
cd "$place"

cp ./dataFiles/galena.service /etc/systemd/system/galena.service

sed -i 's|${user}|'"$nameSpace"'|g' /etc/systemd/system/galena.service
sed -i 's|${wd}|/home/'"$nameSpace"'/ServerData|g' /etc/systemd/system/galena.service
sed -i 's|${exec}|/home/'"$nameSpace"'/ServerData/manager.py|g' /etc/systemd/system/galena.service
systemctl daemon-reload
sudo systemctl enable galena
sudo systemctl start galena

echo "Next time you log in and out 'Galena' should start working!"