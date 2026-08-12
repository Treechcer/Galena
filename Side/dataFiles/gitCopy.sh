#!/bin/bash

path="/home/$USER/gitCopy/"
host=$(bash ./hostname.sh)

mkdir -p "$path"
smbget --recursive --guest smb://$host/"FORGEJO NAS"/ $path