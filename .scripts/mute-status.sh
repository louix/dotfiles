#!/bin/sh
# shell script to get mic status

MUTE=`pacmd list-sources | grep "\*" -A 15 | grep "muted" | cut -f 2 | cut -d " " -f 2`
if [ $MUTE == "yes" ]; then
    echo '{"icon": "microphone_muted", "state": "Warning", "text": ""}' || exit 1
else
    echo '{"icon": "microphone_full", "state": "Good", "text": ""}' || exit 1
fi
