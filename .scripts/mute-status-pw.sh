#!/bin/sh
# shell script to get mic status

SINK=`pactl info | grep Source | cut -d ' ' -f 3`
NODE_ID=`pw-cli ls Node | grep $SINK -B 10 | grep -E 'id [0-9]{2}' | cut -d ' ' -f 2 | cut -d ',' -f 1`
MUTE=`pw-cli e $NODE_ID Props | grep 'mute' -A1 | grep 'true'`
if [ -n "$MUTE" ]; then
    echo '{"icon": "microphone_muted", "state": "Warning", "text": ""}' || exit 1
else
    echo '{"icon": "microphone_full", "state": "Good", "text": ""}' || exit 1
fi
