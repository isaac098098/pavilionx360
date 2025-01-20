#!/bin/bash

dgs=$(ls $HOME/notes/current-notes/diagrams)
i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name' > $HOME/notes/ws

if [ "$#" -ne 0 ]
then
    arg=0
    for i in $dgs
    do
        if [[ "$1.svg" == "$i" ]]
        then
            arg=1
            break
        fi
    done

    if [[ $arg == 1 ]]
    then
        break
    else
        echo $1 > $HOME/notes/name
        killall rofi
        python3 $HOME/repos/inkscape-shortcut-manager/main.py &
        sleep 0.2
        xdotool type "incsvg"
        sleep 0.2
        xdotool type "${1}"
        sleep 0.2
        xdotool type "jk"
        i3-msg workspace 7
        cp $HOME/.config/inkscape/templates/default.svg $HOME/notes/current-notes/diagrams/"$1.svg"
        inkscape $HOME/notes/current-notes/diagrams/"$1.svg"
        xwininfo -root -tree | grep -E 'org.inkscape.Inkscape' | tail -n 1 | awk '{print $1}' | xargs xdotool windowactivate
        exit
    fi
fi
