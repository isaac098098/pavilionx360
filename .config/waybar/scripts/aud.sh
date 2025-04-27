#!/bin/bash

info=$(upower --dump | grep -C 7 'BC:A0:80:2C:AA:18')
if [[ $info ]]
then
    echo "$info" | awk 'NR==15 {print $2}'
    exit 0
fi
