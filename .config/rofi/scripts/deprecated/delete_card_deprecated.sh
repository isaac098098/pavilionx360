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

card=$(echo "$1" | awk '{print $1}')
last_char=${card: -1}

if [[ "$last_char" =~ [0-9] ]]
then
has_sub=$(ls "$dir/cards" | sed -nE "s/^${card}([a-z])+\.tex/\1/p")
if [[ "$has_sub" ]]
then
    rofi -config "$HOME/.config/rofi/config.rasi" -e "card has subcards!"
    exit 0
else
    parent=$(echo "$card" | sed -E 's/([a-z]+)[0-9]+$/\1/p' | tail -n 1)
    if [[ "$parent" == "$card" ]]
    then
        rofi -config "$HOME/.config/rofi/config.rasi" -e "removing root cards is forbidden, do it manually!"
        exit 0
    else
        last=$(ls "$dir/cards" | sed -nE "s/^${parent}([0-9]+)\.tex/\1/p" | sort -n | tail -n 1)
        if [[ "$parent$last" == "$card" ]]
        then
            sed -i "/\\input{cards\/$card\.tex}/d" "$dir/main.tex"
            rm "$dir/cards/$card".*
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for i in $new_cards
            do
                sed -i "s/\\\\hyperref\[card:$card\]{\\\\textsf{$card}}/\\\\texttt{broken hyperref}/" "$dir/cards/$i"
            done
            exit 0
        else
            rm "$dir/cards/$card".*
            sed -i "/\\input{cards\/$parent$last\.tex}/d" "$dir/main.tex"
            mv "$dir/cards/$parent$last.tex" "$dir/cards/$card.tex"
            sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$card}|" "$dir/cards/$card.tex"
            sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$card}|" "$dir/cards/$card.tex"
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for i in $new_cards
            do
                sed -i "s/\\\\hyperref\[card:$parent$last\]{\\\\textsf{$parent$last}}/\\\\hyperref[card:$card]{\\\\textsf{$card}}/" "$dir/cards/$i"
                sed -i "s/\\\\hyperref\[card:$card\]{\\\\textsf{$card}}/\\\\texttt{broken hyperref}/" "$dir/cards/$i"
            done
            exit 0
        fi
    fi
fi
elif [[ "$last_char" =~ [a-z] ]]
then
has_sub=$(ls "$dir/cards" | sed -nE "s/^${card}([0-9])+\.tex/\1/p")
if [[ "$has_sub" ]]
then
    rofi -config "$HOME/.config/rofi/config.rasi" -e "card has subcards!"
    exit 0
else
    parent=$(echo "$card" | sed -E 's/([0-9]+)[a-z]+$/\1/p' | tail -n 1)
    if [[ "$parent" == "$card" ]]
    then
        rofi -config "$HOME/.config/rofi/config.rasi" -e "removing root cards is forbidden, do it manually!"
        exit 0
    else
        last=$(ls "$dir/cards" | sed -nE "s/^${parent}([a-z]+)\.tex/\1/p" | awk '{print length, $0}' | sort -n | cut -d' ' -f2- | tail -n 1)
        if [[ "$parent$last" == "$card" ]]
        then
            sed -i "/\\input{cards\/$card\.tex}/d" "$dir/main.tex"
            rm "$dir/cards/$card".*
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for i in $new_cards
            do
                sed -i "s/\\\\hyperref\[card:$card\]{\\\\textsf{$card}}/\\\\texttt{broken hyperref}/" "$dir/cards/$i"
            done
            exit 0
        else
            rm "$dir/cards/$card".*
            sed -i "/\\input{cards\/$parent$last\.tex}/d" "$dir/main.tex"
            mv "$dir/cards/$parent$last.tex" "$dir/cards/$card.tex"
            sed -i -E "s|(\\zheader\{[^}]*\})\{[^}]+\}|\1{$card}|" "$dir/cards/$card.tex"
            sed -i -E "s|(\\zheadernotags\{[^}]*\})\{[^}]+\}|\1{$card}|" "$dir/cards/$card.tex"
            new_cards=$(ls "$dir/cards" | grep .tex | sort -V)
            for i in $new_cards
            do
                sed -i "s/\\\\hyperref\[card:$parent$last\]{\\\\textsf{$parent$last}}/\\\\hyperref[card:$card]{\\\\textsf{$card}}/" "$dir/cards/$i"
                sed -i "s/\\\\hyperref\[card:$card\]{\\\\textsf{$card}}/\\\\texttt{broken hyperref}/" "$dir/cards/$i"
            done
            exit 0
        fi
    fi
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
