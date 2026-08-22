#!/bin/bash

cd "$(dirname "$0")"

keyfile=/home/$USER/.ssh/id_rsa
if [ ! -f "/home/$USER/.ssh/id_rsa" ]; then
    echo "generating new rsa ssh keys"
    ssh-keygen -t rsa -N "" -f "$keyfile"
fi

i=1
while [ $i -le 4 ]; do

    if [ ! -f "./node$i.sh" ]; then
        echo "File node$i.sh doesn't exist. Skipping."
        i=$(($i+1))
        continue
    fi

    chmod +x ./node$i.sh
    . "./node$i.sh"
    runNode="$(get_node_num)"

    if [[ "$runNode" == "1" ]]; then
        echo "Initing node$i"
        
        echo "What's your username that you want to be logged it. (default node)"
        read username

        echo "What's your hostname or IP of node? Hostname is recommended because it usually doesn't change. (default node$i)"
        read hostnameOrIp

        if [[ "$username" == "" ]]; then
            username="node"
        fi
        if [[ "$hostnameOrIp" == "" ]]; then
            hostnameOrIp="node$i"
        fi
        #if [[ ! "$hostnameOrIp" =~ "^.*\.local$" ]]; then
            
        #fi
        
        echo "---"
        echo "$username@$hostnameOrIp"
        echo "(username@hostnameOrIp) is this correct? [yes, no]"
        inp=""
        while [ true ]; do
            read inp

            if [[ "$inp" == "yes" ]]; then
                ssh-copy-id $username@$hostnameOrIp
                node="node$i"
                echo "
get_hostname(){
    ${node}_hostname=$hostnameOrIp
    echo $hostnameOrIp
}

get_username(){
    ${node}_username=$username
    echo $username
}
" >> $node.sh
                i=$(($i+1))
                break
            elif [[ "$inp" == "no" ]]; then
                i=$i
                break
            else 
                echo "Type yes or no."
            fi
        done
    else
        i=$(($i+1))
    fi
done