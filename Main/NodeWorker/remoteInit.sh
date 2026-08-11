#ssh-keygen -t rsa

for i in $(seq  1 4); do
    chmod +x ./node$i.sh
    source "./node$i.sh"
    runNode="$(get_node_num)"
    if [[ "$runNode" == "1" ]]; then
        echo "Initing node$i"
        
        echo "What's your username that you want to be logged it. (default Galena)"
        read username

        echo "What's your hostname or IP of node? Hostname is recommended because it usually doesn't change. (default node$i)"
        read hostnameOrIp

        if [[ "$username" == "" ]]; then
            username="Galena"
        fi
        if [[ "$hostnameOrIp" == "" ]]; then
            hostnameOrIp="node$i"
        fi
        echo "---"
        echo "$username@$hostnameOrIp"
        echo "(username@hostnameOrIp) is this correct? [yes, no]"
        inp=""
        while [[ true ]]; do
            read inp

            if [[ "$inp" == "yes" ]]; then
                ssh-copy-id $username@$hostnameOrIp

                echo "
get_hostname(){
    node($i)_hostname=$hostnameOrIp
    echo $hostnameOrIp
}

get_username(){
    node($i)_username=$username
    echo $username
}
" >> node$i.sh
            elif [[ "$inp" == "no" ]]; then
                i=$i-1
            fi
        done
    fi
done