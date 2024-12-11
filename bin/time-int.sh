#!/bin/bash

if [ $# == 2 ]
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

    if [[ $2 =~ ^([0-9]+):([0-9]+)$ ]]; then
        fH=0
        fM=$((10#${BASH_REMATCH[1]}))
        fS=$((10#${BASH_REMATCH[2]}))
    elif [[ $2 =~ ^([0-9]+):([0-9]+):([0-9]+)$ ]]; then
        fH=$((10#${BASH_REMATCH[1]}))
        fM=$((10#${BASH_REMATCH[2]}))
        fS=$((10#${BASH_REMATCH[3]}))
    else
        echo "invalid time format: $2"
        exit 1
    fi

    con=(
        "[ $H -ge 0 ]"
        "[ $M -ge 0 ]"
        "[ $M -lt 60 ]"
        "[ $S -ge 0 ]"
        "[ $S -lt 60 ]"
        "[ $fH -ge 0 ]"
        "[ $fM -ge 0 ]"
        "[ $fM -lt 60 ]"
        "[ $fS -ge 0 ]"
        "[ $fS -lt 60 ]"
    )

    for i in "${con[@]}"
    do
        if ! eval "$i"
        then
            echo "invalid time format"
            exit 1
        fi
    done

    if [ $((fS-S)) -ge 0 ]
    then
        if [ $((fM-M)) -ge 0 ]
        then
            if [ $((fH-H)) -ge 0 ]
            then
                echo "$(printf '%02d' $((fH-H))):$(printf '%02d' $((fM-M))):$(printf '%02d' $((fS-S))).00"
            else
                echo "inconsistent interval"
                exit 1
            fi
        else 
            if [ $((fH-H)) -gt 0 ]
            then
                echo "$(printf '%02d' $((fH-H-1))):$(printf '%02d' $((60+fM-M))):$(printf '%02d' $((fS-S))).00"
            else
                echo "inconsistent interval"
            fi
        fi
    else
        if [ $((fM-M)) -gt 0 ]
        then
            echo "$(printf '%02d' $((fH-H))):$(printf '%02d' $((fM-M-1))):$(printf '%02d' $((60+fS-S))).00"
        else
            if [ $((fH-H)) -gt 0 ]
            then
                echo "$(printf '%02d' $((fH-H-1))):$(printf '%02d' $((60+fM-M))):$(printf '%02d' $((60+fS-S))).00"
            else
                echo "inconsistent interval"
            fi
        fi
    fi
                
        
else
    echo "$0 [initial-time] [end-time] in HH:MM:SS or MM:SS format"
fi
