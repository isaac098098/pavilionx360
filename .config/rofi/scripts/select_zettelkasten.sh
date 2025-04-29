#!/bin/bash

if [[ "$1" ]]
then
    case "$1" in
        "Topology")
            dir="$HOME/zettelkasten/topology"
        ;;
    *)
        exit 0
        ;;
    esac

    rm $HOME/zettelkasten/current
    ln -s "$dir" $HOME/zettelkasten/current

    exit 0
else
    echo "Topology"
    exit 0
fi
