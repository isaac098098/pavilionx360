#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#00000000'
TEXT='#e5b191ff'
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
--time-size=50               \
--date-size=15               \
--verif-size=24              \
--wrong-size=24              \
--radius=150                 \
\
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M"           \
--date-str="%A, %Y-%m-%d"    \
--time-font="Ac437 MBytePC230 CGA-Bold"     \
--date-font="Ac437 MBytePC230 CGA-Bold"     \
--layout-font="Ac437 MBytePC230 CGA-Bold"   \
--verif-font="Ac437 MBytePC230 CGA-Bold"    \
--wrong-font="Ac437 MBytePC230 CGA-Bold"    \
--color=00000000             \
--blur 5                     \
--verif-text="Verifying"     \
--nofork                     \
#--keylayout 0                \
