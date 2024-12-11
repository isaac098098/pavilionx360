#!/bin/bash
#Requires packages yt-dlp, ffmpeg, time-ftm.sh and time-int.sh

if [ $# == 1 ]; then
	if [ ! -d ./cropped ]; then
		mkdir -p ./cropped
	fi
	while read -u 3 line; do
		read source init fin name <<< $line
		if [[ "$source" =~ "www.facebook.com" ]]
        then
			if [ "$init" == "" ]
            then
				yt-dlp --newline --quiet --progress $name -o ./cropped/"%(title)s.%(ext)s"
                echo "$name"
			else
				if [ "$fin" == "" ]
                then
					yt-dlp --newline --quiet --progress $source -o ./cropped/"$init.%(ext)s"
				else
					if [ "$name" == "" ]
                        then
						title=$(yt-dlp $source --print "%(title)s.%(ext)s")
						yt-dlp --newline --quiet --progress $source -o ./cropped/"temp_$title"
						ffmpeg -hide_banner -loglevel quiet -ss "$(./time-fmt.sh $init)" -i ./cropped/"temp_$title" -t "$(./time-int.sh $init $fin)" -c copy ./cropped/"$title"
						rm ./cropped/"temp_$title"
                        echo "$title"
					else
						format=$(yt-dlp $source --print "%(ext)s")
						yt-dlp --newline --quiet --progress "$source" -o ./cropped/"temp_$name.%(ext)s"
						ffmpeg -hide_banner -loglevel quiet -ss "$(./time-fmt.sh $init)" -i ./cropped/"temp_$name.$format" -t "$(./time-int.sh $init $fin)" -c copy ./cropped/"$name.$format"
						rm ./cropped/"temp_$name.$format"
                        echo "$name.$format"
					fi
				fi
			fi
		else
			source=$(yt-dlp -g "$source")
			if [ "$init" == "" ]
                then
				title=$(yt-dlp $source --print "%(title)s.%(ext)s")
				ffmpeg -hide_banner -loglevel quiet -i "$source" -c copy ./cropped/"$title"
                echo "$title"
			else
				if [ "$fin" == "" ]
                then
					ffmpeg -hide_banner -loglevel quiet -i "$source" -c copy ./cropped/"$init.mp4"
				else
					if [ "$name" == "" ]
                    then
						title=$(yt-dlp $source --print "%(title)s.%(ext)s")
						ffmpeg -hide_banner -loglevel quiet -ss "$(./time-fmt.sh $init)" -i "$source" -t "$(./time-int.sh $init $fin)" -c copy ./cropped/"$title"
                        echo "$title"
					else
						ffmpeg -hide_banner -loglevel quiet -ss "$(./time-fmt.sh $init)" -i "$source" -t "$(./time-int.sh $init $fin)" -c copy ./cropped/"$name.mp4"
                        echo "$name.mp4"
					fi
				fi
			fi
		fi
	done 3<$1
	exit 1
fi

if [ $# == 4 ]
then
	if [ ! -d ./cropped ]
    then
		mkdir -p ./cropped
	fi
	source=$(yt-dlp -g "$1")
	ffmpeg -hide_banner -loglevel quiet -ss $2 -i "$source" -t $3 ./cropped/$4
	exit 1
fi

echo "$0 [URL] [starting time in format hh:mm:ss] [final time in format hh:mm:ss] [name]"
echo "$0 [batchfile]"
