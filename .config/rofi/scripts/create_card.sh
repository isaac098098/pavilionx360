#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)

if [[ "$1" ]]
then
    killall rofi
    if [[ "$1" == "New" ]]
    then
        last=$(ls "$dir/cards" | sed -nE "s/^([0-9]+)\.tex/\1/p" | sort -n | tail -n 1)
        next=$((10#$last + 1))
        eof=$(grep -n "\\\\end{document}" "$dir/main.tex" | cut -f1 -d:)
        sed -i "/\\end{document}/s/\\end{document}/\\input{cards\/$next.tex}\n\n\\\\end{document}/" "$dir/main.tex"
        sed -i "$((10#$eof - 1))d" "$dir/main.tex"
        alacritty -e nvim "$dir/cards/$next.tex" &
        exit 0
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
                alacritty -e nvim "$dir/cards/$card$next.tex" &
                exit 0
            else
                sed -i "/\\input{cards\/$card\.tex}/a \\\\\\\\input{cards\/${card}a\.tex}" "$dir/main.tex"
                alacritty -e nvim "$dir/cards/${card}a.tex" &
                exit 0
            fi
        elif [[ "$last_char" =~ [a-z] ]]
        then
            last=$(ls "$dir/cards" | sed -nE "s/^${card}([0-9]+)\.tex/\1/p" | sort -n | tail -n 1)
            if [[ "$last" ]]
            then
                next=$((10#$last + 1))
                sed -i "/\\input{cards\/${card}${last}\.tex}/a \\\\\\\\input{cards\/${card}${next}\.tex}" "$dir/main.tex"
                alacritty -e nvim "$dir/cards/$card$next.tex" &
                exit 0
            else
                sed -i "/\\input{cards\/${card}\.tex}/a \\\\\\\\input{cards\/${card}1\.tex}" "$dir/main.tex"
                alacritty -e nvim "$dir/cards/${card}1.tex" &
                exit 0
            fi
        fi
    fi
else
    for i in $cards
    do
        title=$(sed -n '0,/^%%% /s/^%%% //p' "$dir/cards/$i")
        tags=$(grep "^%% tags:" "$dir/cards/$i" | sed -E 's/^.*tags:[[:space:]]*//')
        printf "%-8s %s %59s\n" "${i%.tex}" "$title" "$tags"
    done
    echo "New"
    exit 0
fi
