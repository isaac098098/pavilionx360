#!/bin/bash

dir="$HOME/zettelkasten/current"

cards=$(ls "$dir/cards" | grep .tex | sort -V)

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

if [ "$1" ]
then
    card=$(echo "$1" | awk '{print $1}')
    killall rofi 2>/dev/null
    NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards st -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/$card.tex" &
    exit 0
fi

for i in $sorted
do
    title=$(sed -n '0,/^%%% /s/^%%% //p' "$dir/cards/$i.tex")
    tags=$(grep "^%% tags:" "$dir/cards/$i.tex" | sed -E 's/^.*tags:[[:space:]]*//')
    if [[ "$tags" ]]
    then
        printf "%-8s %s | %s\n" "$i" "$title" "$tags"
    else
        printf "%-8s %s\n" "$i" "$title"
    fi
done
