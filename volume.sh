#!/bin/sh
case $1 in
up)
    # unmute if muted
    pactl set-sink-mute 0 0
    current_vol=$(pactl get-sink-volume 0 | head -1 | awk '{print $5}' | sed 's/%//g')
    if [ "$current_vol" -ge 100 ]; then
        pactl set-sink-volume 0 100%
        exit 0
    fi
    pactl set-sink-volume 0 +5%
    ;;
down)
    # unmute if muted
    pactl set-sink-mute 0 0
    pactl set-sink-volume 0 -5%
    ;;
mute)
    pactl set-sink-mute 0 toggle
    ;;
esac

#sound when volume changes
#canberra-gtk-play -i audio-volume-change -d "changeVolume"
