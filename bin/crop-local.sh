#!/bin/bash
#requires yt-dlp, ffmpeg, time-fmt.sh and time-int.sh

if [ $# == 1 ]; then
	if [ ! -d ./cropped ]; then
		mkdir -p ./cropped
	fi
	while read -u 3 line; do
		read source init fin name <<< $line
        ffmpeg -loglevel quiet -hide_banner -ss "$(./time-fmt.sh $init)" -t "$(./time-int.sh $init $fin)" -i "./$source" -c copy ./cropped/"$name.mp4"
        echo "$name.mp4"
	done 3<$1
	exit 1
fi
