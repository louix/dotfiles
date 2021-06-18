#!/usr/bin/env bash

CHAMELEON=$(which chameleon)

if [ '$CHAMELEON' ]; then
    RUNNING=$(pgrep chameleon)
    if [ '$RUNNING' ]; then
        pkill chameleon
    fi
    chameleon
    #pgrep chameleon || chameleon
    #pkill chameleon && chameleon
fi

