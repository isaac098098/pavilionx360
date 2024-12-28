#!/bin/bash

if [ $# == 1 ]
then
    if [[ $1 =~ ^([0-9]+):([0-9]+)$ ]]
    then
        H=0
        M=$((10#${BASH_REMATCH[1]}))
        S=$((10#${BASH_REMATCH[2]}))
    elif [[ $1 =~ ^([0-9]+):([0-9]+):([0-9]+)$ ]]
    then
        H=$((10#${BASH_REMATCH[1]}))
        M=$((10#${BASH_REMATCH[2]}))
        S=$((10#${BASH_REMATCH[3]}))
    else
        echo "invalid time format: $1"
        exit 1
    fi

    con=(
        "[ $H -ge 0 ]"
        "[ $M -ge 0 ]"
        "[ $M -lt 60 ]"
        "[ $S -ge 0 ]"
        "[ $S -lt 60 ]"
    )

    for i in "${con[@]}"
    do
        if ! eval "$i"
        then
            echo "inconsistent time format"
            exit 1
        fi
    done

    echo "$(printf '%02d' $H):$(printf '%02d' $M):$(printf '%02d' $S).00"
else
    echo "$0 [time] in H:M:S or M:S format"
fi
