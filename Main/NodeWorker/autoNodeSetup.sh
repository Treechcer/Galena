#!/bin/bash

cd "$(dirname "$0")"

i=1
while [ $i -le 4 ]; do
    if [ -f "./node$i.sh" ]; then
        chmod +x ./node$i.sh
        source "./node$i.sh"

        if [[ $(get_node_num) != "1" ]]; then
            i=$(($i+1))
            continue;
        fi

        remote="$(get_username)@$(get_hostname)"

        #This might work?

        #sudo -u Galena ssh $remote bash < ../dataFiles/downloadInit.sh

        #sudo -u Galena ssh $remote "sudo bash -c 'echo \"PasswordAuthentication no\n PubkeyAuthentication yes\"  >> /etc/ssh/sshd_config && sudo systemctl restart ssh'"

        sudo -u Galena ssh-copy-id -i ~/.ssh/id_rsa.pub $remote
        
        sudo -u Galena ssh $remote "echo 'test'"
        
        #sudo -u Galena ssh $remote bash < ../dataFiles/addKeyAuth.sh

        #sudo -u Galena ssh $remote touch install.sh
        #sudo -u Galena ssh $remote "echo '#!/bin/bash
#sudo apt install -y git
#rm -rf galena
#git clone https://github.com/Treechcer/galena
#cd galena/AllNodes
#chmod +x init.sh
#./init.sh Side -n$i' >> install.sh"
        #sudo -u Galena ssh $remote chmod +x install.sh
        #sudo -u Galena ssh $remote sudo ./install.sh
        #sudo -u Galena ssh $remote sudo rm ./install.sh

    fi

    i=$(($i+1))
done 