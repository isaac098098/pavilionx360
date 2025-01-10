#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#00000000'
TEXT='#e2b86bff'
WRONG='#e55561ff'
VERIFYING='#bf68d9ff'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$TEXT   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$WRONG         \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$TEXT          \
--bshl-color=$TEXT           \
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
#--keylayout 0                \
