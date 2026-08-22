#!/bin/bash

if [ ! -f "/etc/ssh/sshd_config" ]; then
    sudo touch "/etc/ssh/sshd_config"
fi

sed 's/#PasswordAuthentication no/PasswordAuthentication no' /etc/ssh/sshd_config
sed 's/PasswordAuthentication no/PasswordAuthentication no' /etc/ssh/sshd_config
sed 's/#PasswordAuthentication yes/PasswordAuthentication no' /etc/ssh/sshd_config
sed 's/PasswordAuthentication yes/PasswordAuthentication no' /etc/ssh/sshd_config

sed 's/#PubkeyAuthentication no/PubkeyAuthentication yes' /etc/ssh/sshd_config
sed 's/PubkeyAuthentication no/PubkeyAuthentication yes' /etc/ssh/sshd_config
sed 's/#PubkeyAuthentication yes/PubkeyAuthentication yes' /etc/ssh/sshd_config