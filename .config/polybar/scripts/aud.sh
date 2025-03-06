#!/bin/bash

if [[ $(upower --dump | grep -C 7 'BC:A0:80:2C:AA:18') ]]
then
    echo "$(upower --dump | grep -C 7 'BC:A0:80:2C:AA:18' | grep -o '..%')"
    exit 0
else
    exit 1
fi
