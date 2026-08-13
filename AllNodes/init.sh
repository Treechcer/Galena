#!/bin/bash

# This is used to init main node? We can maybe use the same for others?

#https://askubuntu.com/a/15856
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

node="Main"
input="$1"

while [[ true ]]; do
    if [[ "$input" == "Main" ]] || [[ "$input" == "main" ]]; then
        node="Main"
        break
    elif [[ "$input" == "Side" ]] || [[ "$input" == "side" ]]; then
        node="Side"
        break
    fi

    echo "Input which node you want (main / side)"
    read input

done

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

    sudo touch /etc/sudoers.d/$nameSpace
    Permission="$nameSpace ALL=(ALL:ALL) NOPASSWD: ALL"
    sudo bash -c "echo -e '$Permission' >> /etc/sudoers.d/$nameSpace"
    sudo chmod 440 /etc/sudoers.d/$nameSpace

    echo "Created '$nameSpace'"
fi

mkdir -p /home/$nameSpace/ServerData
cp -r . /home/$nameSpace/ServerData
cp -r ./../$node/. /home/$nameSpace/ServerData
chown -R $nameSpace:$nameSpace /home/$nameSpace/ServerData

sudo apt update && sudo apt upgrade

echo "Downlaoding dependencies (might ask for some configuration, not fully automatic!)"
sudo apt install -y python3 python3-pip sqlite3

echo "Executing initialisation of Constructs!"

if [[ "$node" == "Main" ]]; then
    if [ $(sudo raspi-config nonint get_i2c) -eq 1 ]; then
        sudo raspi-config nonint do_i2c 0
        echo "Enabled I2C"
    fi

    #TODO: finish

    #echo "dtoverlay=dwc2,dr_mode=host" >> "/boot/firmware/config.txt"
    #sed -i 's/rootwait/rootwait modules-load=dwc2,g_ether/' "/boot/firmware/cmdline.txt"
else
    sudo sed -i '/^\[all\]/a dtoverlay=dwc2' "/boot/firmware/config.txt"
    sudo sed -i 's/rootwait/rootwait modules-load=dwc2,g_serial/' "/boot/firmware/cmdline.txt"
fi

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

echo "adding powerOff script"
cp ./dataFiles/galena-NodePoweroff.service /etc/systemd/system/galena-NodePoweroff.service
sudo systemctl daemon-reload
sudo systemctl enable NodePoweroff

if [[ "$node" == "Side" ]]; then
    cp ./dataFiles/galena-gitCopy.service /etc/systemd/system/galena-gitCopy.service
    cp ./dataFiles/galena-gitCopy.timer /etc/systemd/system/galena-gitCopy.timer
    sed -i 's|${exec}|/home/'"$nameSpace"'/ServerData/dataFiles/gitCopy.sh|g' /etc/systemd/system/galena-gitCopy.service
    sudo systemctl daemon-reload
    sudo systemctl enable --now galena-gitCopy.timer
fi

#I shouldn't start it probably?
#sudo systemctl start NodePoweroff

if [[ "$node" == "Side" ]] && [[ $(hostname) =~ ^node[1-4]$ ]]; then
    inp=""
    while [ true ]; do
        echo "Do you want to make your hostname 'node1-4'? (Preffered to have hostnames of node1-4 for nodes by how it's in the slots) [1-4 or no]" 
        read inp

        if [[ "$inp" =~ [1-4] ]]; then
            sudo hostname "node$inp"
        elif [ "$inp" == "no" ]; then
            break
        else
            echo "You have to say 1, 2, 3, 4 or no"
        fi

    done

fi

echo "Next time you log in and out 'Galena' should start working!"