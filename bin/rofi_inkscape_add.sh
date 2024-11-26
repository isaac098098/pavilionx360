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

    if [ $arg == 0 ]
    then
        echo $1 > $HOME/notes/name
        killall rofi
        # xdotool type "incsvg$(echo $1 | sed 's/\.svg$//')jk"
        xdotool type "incsvg${1}jk"
        i3-msg workspace 7
        cp $HOME/.config/inkscape/templates/default.svg $HOME/notes/current-notes/diagrams/"$1.svg"
        inkscape $HOME/notes/current-notes/diagrams/"$1.svg"
        # xwininfo -root -tree | grep -E 'org.inkscape.Inkscape' | tail -n 1 | awk '{print $1}' | xargs xdotool windowactivate
        # xdotool key 5
        # xdotool key ctrl+4
    fi
fi
