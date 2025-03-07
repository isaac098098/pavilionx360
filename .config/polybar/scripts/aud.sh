#!/bin/bash

if [[ $(upower --dump | grep -C 7 'BC:A0:80:2C:AA:18') ]]
then
    echo "$(upower --dump | grep -C 7 'BC:A0:80:2C:AA:18' | grep -o '..%')"
    polybar-msg action "#aud.module_show"
    exit 0
else
    polybar-msg action "#aud.module_hide"
    exit 1
fi
