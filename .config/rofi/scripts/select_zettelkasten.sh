#!/bin/bash

if [[ "$1" ]]
then
    case "$1" in
        "Mathematics")
            dir="$HOME/zettelkasten/mathematics"
        ;;
    esac

    rm $HOME/zettelkasten/current
    ln -s "$dir" $HOME/zettelkasten/current

    exit 0
else
    echo "Mathematics"
    exit 0
fi
