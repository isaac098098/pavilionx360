#!/bin/bash

lecs=$(grep 'lec' $HOME/notes/current-notes/main.tex | sed -n 's/.*lec_\([0-9]\{2\}\).tex.*/\1/p')
last=$(echo "$lecs" | sort -nr | head -n1)
new=$(printf '%02d' $((10#$last + 1)))

# open last lecture or create new

case "$1" in 
    "Last")
        killall rofi
        sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $((10#$last))).tex}/\\\\\input{lecs/lec_$(printf '%02d' $((10#$last))).tex}/g" $HOME/notes/current-notes/main.tex
        for (( j=1 ; j <= $((10#$last-1)) ; j++ ))
        do
            sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $j).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
        done
        alacritty -e nvim $HOME/notes/current-notes/lecs/lec_"$last".tex
    ;;
    "New")
        killall rofi
        sed -i "/\input{lecs/lec_${last}.tex}/a \\\\\input{lecs/lec_${new}.tex}" $HOME/notes/current-notes/main.tex
        for (( j=1 ; j <= $((10#$last)) ; j++ ))
        do
            sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $j).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
        done
        alacritty -e nvim $HOME/notes/current-notes/lecs/lec_${new}.tex
    ;;
    "Bibliography")
        killall rofi
        alacritty -e nvim $HOME/notes/current-notes/bibl.bib
    ;;
    *)
        # open lecture note interval or specific lectures
        if [[ "$1" =~ ^([0-9]+(-[0-9]+)?)(,[0-9]+(-[0-9]+)?)*$ ]]
        then
            killall rofi
            tabs=()
            idx=()
            IFS=',' read -r -a ints <<< "$1"
            for s in "${ints[@]}"
            do
                if [[ $s == *-* ]]
                then
                    start=${s%-*}
                    end=${s#*-}
                    for i in $(seq "$start" "$end")
                    do
                        if  [ "1" -le "$((i))" ] && [ "$((i))" -le "$((10#$last))" ]
                        then
                            sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $i).tex}/\\\\\input{lecs/lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
                            tabs+=($HOME/notes/current-notes/lecs/lec_$(printf '%02d' $i).tex)
                            idx+=($((i)))
                        fi
                    done
                else
                    if [ "1" -le "$((s))" ] && [ "$((s))" -le "$((10#$last))" ]
                    then
                        sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $s).tex}/\\\\\input{lecs/lec_$(printf '%02d' $s).tex}/g" $HOME/notes/current-notes/main.tex
                        tabs+=($HOME/notes/current-notes/lecs/lec_$(printf '%02d' $s).tex)
                        idx+=($((s)))
                    fi
                fi
            done

            for (( j=1 ; j <= $((10#$last)) ; j++ ))
            do
                if ! [[ "${idx[@]}" =~ "$j" ]]
                then
                    sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $j).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
                fi
            done

            if (( ${#tabs[@]} ))
            then
                alacritty -e nvim -p "${tabs[@]}"
            fi
            
        fi
    ;;
esac

# open single lecture file

for i in $lecs
do
    title=$(sed -n '0,/^%%% /s/^%%% //p' $HOME/notes/current-notes/lecs/lec_"$i".tex)
    date=$(sed -n '1,/.*lecture{.*}{\(.*\)}/s/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lecs/lec_"$i".tex)
    if [[  "$1" == "$(printf "%-30s %44s\n" "$i. $title" "$date")" ]]
    then
        killall rofi
        sed -i "s/^% \\\\\input{lecs/lec_$i.tex}/\\\\\input{lecs/lec_$i.tex}/g" $HOME/notes/current-notes/main.tex
        for (( j=1 ; j <= "$((10#$last))" ; j++ ))
        do
            if [ "$((j))" -ne "$((10#$i))" ]
            then
                sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $j).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
            fi
        done
        alacritty -e nvim "$HOME/notes/current-notes/lecs/lec_$i.tex"
        break
    fi
done

# rofi menu

echo "Last"
echo "New"
for i in $lecs
do
    cur=$(printf '%02d' $((10#$last-10#$i+1)))
    title=$(sed -n '0,/^%%% /s/^%%% //p' $HOME/notes/current-notes/lecs/lec_"$cur".tex)
    date=$(sed -n '1,/.*lecture{.*}{\(.*\)}/s/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lecs/lec_"$cur".tex)
    printf "%-30s %44s\n" "$cur. $title" "$date"
done
echo "Bibliography"
