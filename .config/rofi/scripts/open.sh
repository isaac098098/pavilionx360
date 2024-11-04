#!/bin/bash

lecs=$(grep 'lec' $HOME/notes/current-notes/main.tex | sed -n 's/.*lec_\([0-9]\{2\}\).tex.*/\1/p')
last=$(echo "$lecs" | sort -nr | head -n1)
new=$(printf '%02d' $((last + 1)))

# open last lecture or create new

case "$1" in 
    "Last")
        killall rofi
        kitty nvim $HOME/notes/current-notes/lec_"$last".tex
    ;;
    "New")
        killall rofi
        sed -i "/\input{lec_${last}.tex}/a \\\\\input{lec_${new}.tex}" "$HOME/notes/current-notes/main.tex"
        kitty nvim $HOME/notes/current-notes/lec_${new}.tex
    ;;
    "Bibliography")
        killall rofi
        kitty nvim $HOME/notes/current-notes/bibliography.bib
    ;;
    *)
        # open lecture note interval or specific lectures
        if [[ "$1" =~ ^([0-9]+(-[0-9]+)?)(,[0-9]+(-[0-9]+)?)*$ ]]
        then
            killall rofi
            tabs=()
            IFS=',' read -r -a ints <<< "$1"
            for s in "${ints[@]}"
            do
                if [[ $s == *-* ]]
                then
                    start=${s%-*}
                    end=${s#*-}
                    for i in $(seq "$start" "$end")
                    do
                        if  [ "1" -le "$((i))" ] && [ "$((i))" -le "$((last))" ]
                        then
                            tabs+=($HOME/notes/current-notes/lec_$(printf '%02d' $i).tex)
                        fi
                    done
                else
                    if [ "1" -le "$((s))" ] && [ "$((s))" -le "$((last))" ]
                    then
                        tabs+=($HOME/notes/current-notes/lec_$(printf '%02d' $s).tex)
                    fi
                fi
            done
            if (( ${#tabs[@]} ))
            then
                kitty nvim -p "${tabs[@]}"
            fi
        fi
    ;;
esac

# open single lecture file

for i in $lecs
do
    title=$(sed -n 's/^%%% //p' $HOME/notes/current-notes/lec_"$i".tex)
    date=$(sed -n 's/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lec_"$i".tex)
    if [[  "$1" == "$(printf "%-30s %24s\n" "$i. $title" "$date")" ]]
    then
        killall rofi
        sed -i "s/^% \\\\\input{lec_$i.tex}/\\\\\input{lec_$i.tex}/g" $HOME/notes/current-notes/main.tex
        kitty nvim $HOME/notes/current-notes/lec_$(printf '%02d' $i).tex
    fi
done

# rofi menu

echo "Last"
echo "New"
for i in $lecs
do
    title=$(sed -n 's/^%%% //p' $HOME/notes/current-notes/lec_"$i".tex)
    date=$(sed -n 's/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lec_"$i".tex)
    printf "%-30s %24s\n" "$i. $title" "$date"
done
echo "Bibliography"
