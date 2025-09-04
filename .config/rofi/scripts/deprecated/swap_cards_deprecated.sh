#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)
found1=0
found2=0

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
card1=$(echo "$1" | awk -F'-' '{print $1}')
card2=$(echo "$1" | awk -F'-' '{print $2}')

if [[ "$card1" ]] && [[ "$card2" ]]
then
for i in $cards
do
    if [[ "$i" == "$card1.tex" ]]
    then
        found1=1
        break
    fi
done

for i in $cards
do
    if [[ "$i" == "$card2.tex" ]]
    then
        found2=1
        break
    fi
done

if [[ $found1 == 1 ]]
then
    if [[ $found2 == 1 ]]
    then
        if [[ "$card1" =~ ^[0-9]+$ ]]
        then
            root1=${BASH_REMATCH[0]}
            if [[ "$card2" =~ ^[0-9]+$ ]]
            then
                root2=${BASH_REMATCH[0]}
                for i in $cards
                do
                    if [[ "$i" =~ ^$root1(.*) ]]
                    then
                        mv "$dir/cards/$i" "$dir/cards/tmp_$i"
                        # echo "$i -> tmp_$i"
                    fi
                done

                for i in $cards
                do
                    if [[ "$i" =~ ^$root2(.*) ]]
                    then
                        new_name="$root1${BASH_REMATCH[1]}"
                        sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{${new_name%.tex}}|" "$dir/cards/$i"
                        sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{${new_name%.tex}}|" "$dir/cards/$i"
                        mv "$dir/cards/$i" "$dir/cards/$new_name"
                        # echo "$i -> $new_name"
                    fi
                done

                tmp_cards=$(ls "$dir/cards" | grep .tex | grep tmp)
                for i in $tmp_cards
                do
                    if [[ "$i" =~ ^tmp_$root1(.*) ]]
                    then
                        new_name="$root2${BASH_REMATCH[1]}"
                        sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{${new_name%.tex}}|" "$dir/cards/$i"
                        sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{${new_name%.tex}}|" "$dir/cards/$i"
                        mv "$dir/cards/$i" "$dir/cards/$new_name"
                        # echo "$i -> $new_name"
                    fi
                done

                new_cards=$(ls "$dir/cards" | grep .tex)
                for i in $new_cards
                do
                    sed -E -i "s|(\\\\hyperref\\[card:)$root1([^]]*\\])|\1tmp_$root1\2|" "$dir/cards/$i"
                    sed -E -i "s|(\\\\textsf\\{)$root1([^]]*\\})|\1tmp_$root1\2|" "$dir/cards/$i"
                done

                for i in $new_cards
                do
                    sed -E -i "s|(\\\\hyperref\\[card:)$root2([^]]*\\])|\1$root1\2|" "$dir/cards/$i"
                    sed -E -i "s|(\\\\textsf\\{)$root2([^]]*\\})|\1$root1\2|" "$dir/cards/$i"
                done
                
                for i in $new_cards
                do
                    sed -E -i "s|(\\\\hyperref\\[card:)tmp_$root1([^]]*\\])|\1$root2\2|" "$dir/cards/$i"
                    sed -E -i "s|(\\\\textsf\\{)tmp_$root1([^]]*\\})|\1$root2\2|" "$dir/cards/$i"
                done
                exit 0
            fi
        else
            # echo "no both root nodes"
            sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$card2}|" "$dir/cards/$card1.tex"
            sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$card1}|" "$dir/cards/$card1.tex"
            sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$card1}|" "$dir/cards/$card2.tex"
            sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$card1}|" "$dir/cards/$card2.tex"
            mv "$dir/cards/$card1.tex" "$dir/cards/tmp"
            mv "$dir/cards/$card2.tex" "$dir/cards/$card1.tex"
            mv "$dir/cards/tmp" "$dir/cards/$card2.tex"
            for i in $cards
            do
                sed -i "s/\\\\hyperref\[card:$card1\]{\\\\textsf{$card1}}/\\\\hyperref[card:tmp]{\\\\textsf{tmp}}/" "$dir/cards/$i"
                sed -i "s/\\\\hyperref\[card:$card2\]{\\\\textsf{$card2}}/\\\\hyperref[card:$card1]{\\\\textsf{$card1}}/" "$dir/cards/$i"
                sed -i "s/\\\\hyperref\[card:tmp\]{\\\\textsf{tmp}}/\\\\hyperref[card:$card2]{\\\\textsf{$card2}}/" "$dir/cards/$i"
            done
            exit 0
        fi
    else
        killall rofi 2>/dev/null
        rofi -config "$HOME/.config/rofi/err.rasi" -e "card $card2 not found!"
        exit 0
    fi
    else
        killall rofi 2>/dev/null
        rofi -config "$HOME/.config/rofi/err.rasi" -e "card $card1 not found!"
        exit 0
    fi
else
    killall rofi 2>/dev/null
    rofi -config "$HOME/.config/rofi/err.rasi" -e "2 arguments required!"
    exit 0
fi
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
