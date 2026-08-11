#ssh-keygen -t rsa
i=0

for i in $(seq  1 4); do
    chmod +x ./node$i.sh
    runNode="$(./node$i.sh)"
    if [[ "$runNode" == "1" ]]; then
        echo "Initing node$i"
        
        echo "What's your username that you want to be logged it. (default Galena)"
        read username

        echo "What's your hostname or IP of node? Hostname is recommended because it usually doesn't change. (default node$1)"
        read hostnameOrIp

        if [[ "$username" == "" ]]; then
            username="Galena"
        fi
        if [[ "$hostnameOrIp" == "" ]]; then
            username="node$i"
        fi

        #ssh-copy-id $username@$hotnameOrIp

        echo "$username@$hostnameOrIp"
    fi
done