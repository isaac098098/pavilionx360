#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)

if [[ "$1" ]]
then
    killall rofi > /dev/null 2>&1
    if [[ "$1" == "New root node" ]]
    then
        last=$(ls "$dir/cards" | sed -nE "s/^([0-9]+)\.tex/\1/p" | sort -n | tail -n 1)
        if [[ "$last" ]]
        then
            next=$((10#$last + 1))
            eof=$(grep -n "\\\\end{document}" "$dir/main.tex" | cut -f1 -d:)
            sed -i "/\\end{document}/s/\\end{document}/\\input{cards\/$next.tex}\n\n\\\\end{document}/" "$dir/main.tex"
            sed -i "$((10#$eof - 1))d" "$dir/main.tex"
            NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/$next.tex" &
            exit 0
        else
            eof=$(grep -n "\\\\end{document}" "$dir/main.tex" | cut -f1 -d:)
            sed -i "/\\end{document}/s/\\end{document}/\\input{cards\/1.tex}\n\n\\\\end{document}/" "$dir/main.tex"
            NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/1.tex" &
            exit 0
        fi
    else
        card=$(echo "$1" | awk '{print $1}')
        last_char=${card: -1}
        if [[ "$last_char" =~ [0-9] ]]
        then
            last=$(ls "$dir/cards" | sed -nE "s/^${card}([a-z]+)\.tex/\1/p" | awk '{print length, $0}' | sort -n | cut -d' ' -f2- | tail -n 1)
            if [[ "$last" ]]
            then
                next=$(
                    echo "$last" | awk '{
                        for(i=length;i;i--){
                            c=substr($0,i,1)
                            if(c!="z"){
                                d=index("abcdefghijklmnopqrstuuvwxyz",c)
                                printf "%s%s", substr($0,1,i-1), substr("abcdefghijklmnopqrstuuvwxyz", d+1, 1)
                                for(j=i+1;j<=length;j++) printf "a"
                                    print ""; exit
                            }
                        }
                        n=length+1
                        blank=sprintf("%*s",n,"")
                        gsub(/ /,"a",blank)
                        print blank
                    }'
                )

                sed -i "/\\input{cards\/${card}${last}\.tex}/a \\\\\\\\input{cards\/${card}${next}\.tex}" "$dir/main.tex"
                NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/$card$next.tex" &
                exit 0
            else
                sed -i "/\\input{cards\/$card\.tex}/a \\\\\\\\input{cards\/${card}a\.tex}" "$dir/main.tex"
                NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/${card}a.tex" &
                exit 0
            fi
        elif [[ "$last_char" =~ [a-z] ]]
        then
            last=$(ls "$dir/cards" | sed -nE "s/^${card}([0-9]+)\.tex/\1/p" | sort -n | tail -n 1)
            if [[ "$last" ]]
            then
                next=$((10#$last + 1))
                sed -i "/\\input{cards\/${card}${last}\.tex}/a \\\\\\\\input{cards\/${card}${next}\.tex}" "$dir/main.tex"
                NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/$card$next.tex" &
                exit 0
            else
                sed -i "/\\input{cards\/${card}\.tex}/a \\\\\\\\input{cards\/${card}1\.tex}" "$dir/main.tex"
                NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards alacritty -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/${card}1.tex" &
                exit 0
            fi
        fi
    fi
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
            printf "%-8s %s | %s\n" "$i" "$title" "$tags"
        else
            printf "%-8s %s\n" "$i" "$title"
        fi
    done
    echo "New root node"
    exit 0
fi
