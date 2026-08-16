cd "$(dirname "$0")"

i=1
while [ $i -le 4 ]; do
    if [ -f "./node$i.sh" ]; then
        chmod +x ./node$i.sh
        source "./node$i.sh"

        remote="$(get_username)@$(get_hostname)"

        #This might work?

        sudo -u Galena ssh $remote bash < ../dataFiles/downloadInit.sh

    fi
    i=$(($i+1))
done 