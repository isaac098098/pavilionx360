#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)

if [[ "$1" ]]
then
    killall rofi > /dev/null 2>&1
    card=$(echo "$1" | awk '{print $1}')
    last_char=${card: -1}

    if [[ "$last_char" =~ [0-9] ]]
    then
        parent=$(echo $card | sed -nE "s/^(.*)[0-9]+$/\1/p")
        last_sibling=$(echo "$cards" | sed -nE "s/^$parent([0-9]+)\.tex$/\1/p" | sort -n | tail -n 1)

        for (( i=last_char; i<=last_sibling; i++ ))
        do
            new_parent="$parent$((10#$i + 1))"
            mv "$dir/cards/$parent$i.tex" "$dir/cards/$new_parent.tex"
            # mv "$dir/cards/$parent$i.aux" "$dir/cards/$new_parent.aux"
            # echo "$parent$i -> $new_parent"
            
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for k in $new_cards
            do
                sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$new_parent}|" "$dir/cards/$k"
                sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$new_parent}|" "$dir/cards/$k"
                sed -E -i "s|(\\\\hyperref\\[card:)$parent$i([^]]*\\])|\1$new_parent\2|" "$dir/cards/$k"
                sed -E -i "s|(\\\\textsf\\{)$parent$i([^]]*\\})|\1$new_parent\2|" "$dir/cards/$k"
            done
            
            children=$(echo "$cards" | sed -nE "s/^$parent${siblings[$i]}(.*)\.tex$/\1/p")
            for j in $children
            do
                for k in $new_cards
                do
                    sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                    sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                    sed -E -i "s|(\\\\hyperref\\[card:)$parent$i$j([^]]*\\])|\1$new_parent$j\2|" "$dir/cards/$k"
                    sed -E -i "s|(\\\\textsf\\{)$parent$i$j([^]]*\\})|\1$new_parent$j\2|" "$dir/cards/$k"
                done
            done
            for j in $children
            do
                # echo "$parent$i$j -> $new_parent$j"
                mv "$dir/cards/$parent$i$j.tex" "$dir/cards/$new_parent$j.tex"
                # mv "$dir/cards/$parent$i$j.aux" "$dir/cards/$new_parent$j.aux"
            done
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
        done

        alacritty -e nvim "$dir/cards/$card.tex" &
        exit 0
    elif [[ "$last_char" =~ [a-z] ]]
    then
        parent=$(echo $card | sed -nE "s/^(.*)[a-z]+$/\1/p")
        siblings=($(ls "$dir/cards" | sed -nE "s/^$parent([a-z]+)\.tex$/\1/p" | awk '{print length, $0}' | sort -n | cut -d' ' -f2-))

        start=0
        for i in "${!siblings[@]}"
        do
            if [[ "${siblings[$i]}" == "$last_char" ]]
            then
                start=$i
                break
            fi
        done

        for (( i=start; i<${#siblings[@]}; i++ ))
        do
            next=$(
                echo "${siblings[$i]}" | awk '{
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

            new_parent="$parent$next"
            mv "$dir/cards/$parent${siblings[$i]}.tex" "$dir/cards/$new_parent.tex"
            # mv "$dir/cards/$parent${siblings[$i]}.aux" "$dir/cards/$new_parent.aux"
            # echo "$parent$i -> $new_parent"
            
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for k in $new_cards
            do
                sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                sed -E -i "s|(\\\\hyperref\\[card:)$parent${siblings[$i]}$j([^]]*\\])|\1$new_parent$j\2|" "$dir/cards/$k"
                sed -E -i "s|(\\\\textsf\\{)$parent${siblings[$i]}$j([^]]*\\})|\1$new_parent$j\2|" "$dir/cards/$k"
            done
            
            children=$(echo "$cards" | sed -nE "s/^$parent${siblings[$i]}(.*)\.tex$/\1/p")
            for j in $children
            do
                for k in $new_cards
                do
                    sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                    sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$new_parent$j}|" "$dir/cards/$k"
                    sed -E -i "s|(\\\\hyperref\\[card:)$parent${siblings[$i]}$j([^]]*\\])|\1$new_parent$j\2|" "$dir/cards/$k"
                    sed -E -i "s|(\\\\textsf\\{)$parent${siblings[$i]}$j([^]]*\\})|\1$new_parent$j\2|" "$dir/cards/$k"
                done
            done
            for j in $children
            do
                # echo "$parent${siblings[$i]}$j -> $new_parent$j"
                mv "$dir/cards/$parent${siblings[$i]}$j.tex" "$dir/cards/$new_parent$j.tex"
                # mv "$dir/cards/$parent${siblings[$i]}$j.aux" "$dir/cards/$new_parent$j.aux"
            done
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
        done

        alacritty -e nvim "$dir/cards/$card.tex" &
        exit 0
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
