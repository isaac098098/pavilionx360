#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)

if [[ "$1" ]]
then
    killall rofi > /dev/null 2>&1
    card=$(echo "$1" | awk '{print $1}')
    alacritty -e nvim "$dir/cards/$card.tex" &
    exit 0
else
    sorted=$(echo "$cards" | sed 's/\.tex$//' | awk '
        function split_levels(name, levels,   i, c, part, type, n) {
            n = split("", levels)
            i = 1
            while (i <= length(name)) {
                c = substr(name, i, 1)
                if (c ~ /[0-9]/) {
                    type = "[0-9]"
                } else {
                    type = "[a-z]"
                }
                part = ""
                while (i <= length(name) && substr(name, i, 1) ~ type) {
                    part = part substr(name, i, 1)
                    i++
                }
                levels[length(levels)+1] = part
            }
            return length(levels)
        }

        function build_sort_key(name,   levels, n, key, i) {
            n = split_levels(name, levels)
            key = ""
            for (i = 1; i <= n; i++) {
                if (levels[i] ~ /^[0-9]+$/) {
                    key = key sprintf("%08d.", levels[i])
                } else {
                    key = key levels[i] "."
                }
            }
            return key
        }
        {
            original = $0
            key = build_sort_key($0)
            print key "|" original }' | cut -d"|" -f2)

    for i in $sorted
    do
        title=$(sed -n '0,/^%%% /s/^%%% //p' "$dir/cards/$i.tex")
        tags=$(grep "^%% tags:" "$dir/cards/$i.tex" | sed -E 's/^.*tags:[[:space:]]*//')
        if [[ "$tags" ]]
        then
            printf "%-8s %s %30s\n" "$i" "$title" "$tags"
        else
            printf "%-8s %s\n" "$i" "$title"
        fi
    done
    exit 0
fi
