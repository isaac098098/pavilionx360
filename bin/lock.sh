#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#00000000'
TEXT='#e2b86bff'
WRONG='#e55561ff'
VERIFYING='#8ebd6bff'

polybar-msg cmd toggle
sleep 0.1

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
--time-size=45               \
--date-size=17               \
--verif-size=30              \
--wrong-size=30              \
--radius=115                 \
\
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%A, %Y-%m-%d"    \
--time-font="Mx437 IBM VGA 8x16"     \
--date-font="Mx437 IBM VGA 8x16"     \
--layout-font="Mx437 IBM VGA 8x16"   \
--verif-font="Mx437 IBM VGA 8x16"    \
--wrong-font="Mx437 IBM VGA 8x16"    \
--color=00000000             \
--blur 5                     \
--verif-text="Verifying"     \
--nofork                     \
#--keylayout 0                \

polybar-msg cmd toggle
