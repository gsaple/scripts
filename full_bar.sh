#!/bin/sh

# some of following functions are modified from scripts found on
# https://github.com/joestandring/dwm-bar

SEP=" | "
dwm_date () {
    printf "⏰ %s" "$(date "+%H:%M")"
}

dwm_volume () {
    mute=$(pactl get-sink-mute 0 | cut -d ' ' -f2)
    if [ "$mute" == "yes" ]; then
        printf "🔇 %s%%" "0"
    else
        VOL=$(pactl get-sink-volume 0 | head -1 | awk '{print $5}' | sed 's/%//g')
        if [ "$VOL" -le 0 ]; then
            printf "🔇 %s%%" "$VOL"
        elif [ "$VOL" -gt 0 ] && [ "$VOL" -lt 33 ]; then
            printf "🔈%s%%" "$VOL"
        elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
            printf "🔉%s%%" "$VOL"
        else
            printf "🔊 %s%%" "$VOL"
        fi
    fi
    printf "%s" "$SEP"
}

dwm_backlight () {
    bright=$(printf %.0f $(light -G))
    if [ "$bright" -le 10 ]; then
        printf "🌜 %s%%" "$bright"
    elif [ "$bright" -gt 10 ] && [ "$bright" -le 40 ]; then
        printf "🔅 %s%%" "$bright"
    elif [ "$bright" -gt 40 ] && [ "$bright" -le 80 ]; then
        printf "🔆 %s%%" "$bright"
    else
        printf "☀ %s%%" "$bright"
    fi
    printf "%s" "$SEP"
}


dwm_battery () {
    BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
    CHARGE=$(cat /sys/class/power_supply/${BAT}/capacity)
    STATUS=$(cat /sys/class/power_supply/${BAT}/status)
    if [ "$STATUS" = "Charging" ]; then
        printf "🔌%s%% %s" "$CHARGE" "$STATUS"
    else
        printf "🔋%s%% %s" "$CHARGE" "$STATUS"
    fi
    printf "%s" "$SEP"
}

while true
do
    bar="$(dwm_backlight)$(dwm_volume)$(dwm_battery)$(dwm_date)"
    xsetroot -name "$bar"
    sleep 0.1
done &
