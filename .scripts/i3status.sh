#!/bin/sh
# shell script to prepend i3status with more stuff

i3status | while :
do
    read line
#    echo "$line" || exit 1
    MUTE=`pacmd list-sources | grep "\*" -A 15 | grep "muted" | cut -f 2 | cut -d " " -f 2`
    if [ $MUTE == "yes" ]; then
        echo "MUTE $line" || exit 1
    else
        echo "LIVE $line" || exit 1
    fi
done
