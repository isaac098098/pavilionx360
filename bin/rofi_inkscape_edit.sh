#!/bin/bash

dgs=$(ls $HOME/notes/current-notes/diagrams)
i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name' > $HOME/notes/ws

if [ "$#" -ne 0 ]
then
    arg=0
    if [[ -n $dgs ]]
    then
        for i in $dgs
        do
            if [[ "$1.svg" == "$i" ]]
            then
                arg=1
                break
            fi
        done
    fi

    if [ $arg == 1 ]
    then
        echo $1 > $HOME/notes/name
        killall rofi
        i3-msg workspace 7
        inkscape $HOME/notes/current-notes/diagrams/"$1.svg"
        # xwininfo -root -tree | grep -E 'org.inkscape.Inkscape' | tail -n 1 | awk '{print $1}' | xargs xdotool windowactivate
        # xdotool key 5
        # xdotool key ctrl+4
    fi
fi

for i in $dgs
do
    echo "$i" | sed 's/\.svg$//'
done
