xset s off
xset -dpms
xrdb ~/.Xresources
setxkbmap -layout us -variant intl
xset r rate 200 40
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
while true; do xsetroot -name " $(date '+%a, %b %d %Y %H:%M')"; sleep 1; done &
picom &
sxhkd &
unclutter -idle 0.1 -root &
feh --bg-scale --randomize ~/pictures/wallpapers/ &
exec dwm
