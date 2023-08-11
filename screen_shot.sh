#!/bin/sh
name="$HOME/Pictures/screenshots/$(date +%s_%h%d_%H:%M:%S).png"
select=$(echo -e "full\nselect\nactive" | dmenu -l 3)
case $select in
    "full")
	maim -o -d 2 $name
        ;;
    "select")
        maim -s -o -d 2 $name
	;;
    "active")
	maim -o -i $(xdotool getactivewindow) $name
        ;;
esac
exit 0
