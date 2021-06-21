#!/bin/sh
# shell script to get mic status

MUTE=`pw-cli e 48 Props | grep 'mute' -A1 | grep 'true'`
if [ -n "$MUTE" ]; then
    echo '{"icon": "microphone_muted", "state": "Warning", "text": ""}' || exit 1
else
    echo '{"icon": "microphone_full", "state": "Good", "text": ""}' || exit 1
fi
