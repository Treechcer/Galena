#!/bin/bash

if [ ! -f "/etc/ssh/sshd_config" ]; then
    sudo touch "/etc/ssh/sshd_config"
fi

sudo sed 's/#PasswordAuthentication no/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

sudo sed 's/#PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed 's/PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

#TODO: test, this might work?

text=$(cat /etc/ssh/sshd_config)

if ! echo "$text" | grep -q "PubkeyAuthentication yes"; then
    sudo echo -e "\nPubkeyAuthentication yes" >> /etc/ssh/sshd_config
fi

if ! echo "$text" | grep -q "PasswordAuthentication no"; then
    sudo echo -e "\nPasswordAuthentication no" >> /etc/ssh/sshd_config
fi