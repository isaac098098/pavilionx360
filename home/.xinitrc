xset s off
xset -dpms
setxkbmap -layout us -variant intl
xset r rate 200 40
while true; do xsetroot -name "$(date '+%a, %b %d %Y %H:%M')"; sleep 1; done &
unclutter -idle 0.1 -root &
feh --bg-scale ~/pictures/wallpapers/tomorrow_bg.png &
exec dwm
