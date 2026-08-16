#!/bin/bash

cd "$(dirname "$0")"
#echo "$(pwd)"

#init expanderchip
i2cset -y 1 0x20 3 0x00

#Alert off
i2cset -y -m $((2#01000000)) 1 0x20 1 0x00

#i2cset -y -m $((2#00000100)) 1 0x20 1 0x00 # off 3

getBit(){
    str=""
    z="0"
    o="1"
    for j in $(seq 1 8); do
        if [ "$((9 - $j))" -eq "$1" ]; then
            str="$str$o"
        else
            str="$str$z"
        fi
    done

    echo "$str"
}

for i in $(seq  1 4); do
    chmod +x ./node$i.sh
    source "./node$i.sh"
    runNode="$(get_node_num)"

    if [ "$runNode" = "1" ]; then
        #echo "RUN NODE"
        bit=$(getBit $i)
        sudo i2cset -y -m $(("2#$bit")) 1 0x20 1 0xff
    else
        #echo "NOT RUN NODE"
        bit=$(getBit $i)
        sudo i2cset -y -m $(("2#$bit")) 1 0x20 1 0x00
    fi

done
