#!/bin/bash

cd "$(dirname "$0")"

i=1
while [ $i -le 4 ]; do
    if [ -f "./node$i.sh" ]; then
        chmod +x ./node$i.sh
        source "./node$i.sh"

        remote="$(get_username)@$(get_hostname)"

        #This might work?

        #sudo -u Galena ssh $remote bash < ../dataFiles/downloadInit.sh

        sudo -u Galena ssh $remote touch install.sh
        sudo -u Galena ssh $remote "echo '#!/bin/bash
sudo apt install -y git
git clone https://github.com/Treechcer/galena
cd galena/AllNodes
chmod +x init.sh
./init.sh Side -n$i' >> install.sh"
        sudo -u Galena ssh $remote chmod +x install.sh
        sudo -u Galena ssh $remote sudo ./install.sh
        sudo -u Galena ssh $remote sudo rm ./install.sh

    fi
    i=$(($i+1))
done 