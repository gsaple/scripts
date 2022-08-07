#!/bin/sh
case "$1" in
"r")
    feh --bg-fill --randomize --no-fehbg $HOME/wallpapers/* ;;
"w")
    feh --bg-fill --no-fehbg $2 ;;
"s")
    find $HOME/wallpapers -maxdepth 1 -type f | shuf | sxiv - -t
esac

# TODO Pywal stuff here
