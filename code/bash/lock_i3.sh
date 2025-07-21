#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#00000000'
TEXT='#f0c674ff'
WRONG='#cc6666ff'
VERIFYING='#b5bd68ff'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$VERIFYING     \
--wrong-color=$WRONG         \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$TEXT          \
--bshl-color=$TEXT           \
\
--time-size=70               \
--date-size=22               \
--verif-size=35              \
--wrong-size=35              \
--radius=140                 \
\
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M"           \
--date-str="%A, %Y-%m-%d"    \
--time-font="Iosevka NF SemiBold"     \
--date-font="Iosevka NF SemiBold"     \
--layout-font="Iosevka NF SemiBold"   \
--verif-font="Iosevka NF SemiBold"    \
--wrong-font="Iosevka NF SemiBold"    \
--color=00000000             \
--blur 5                     \
--verif-text="Verifying"     \
--nofork                     \
#--keylayout 0                \
