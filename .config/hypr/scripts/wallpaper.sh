#!/bin/bash

hyprpaper &

sleep 2

WALLPAPER_DIR="$HOME/pictures/wallpapers/nord/pixel/"
MONITOR="eDP-1"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

hyprctl hyprpaper reload ,"$WALLPAPER"
