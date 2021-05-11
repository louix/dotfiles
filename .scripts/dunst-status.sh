#!/bin/sh
# shell script to get mic status

PAUSED=`dunstctl is-paused`
if [ $PAUSED == "true" ]; then
    echo '{"icon": "bell-slash", "state": "Warning", "text": "Focus Mode"}' || exit 1
else
    echo '{"icon": "bell", "state": "Good", "text": ""}' || exit 1
fi
