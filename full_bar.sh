#!/bin/sh

# some of following functions are modified from scripts found on
# https://github.com/joestandring/dwm-bar
# https://github.com/thytom/dwmbar

LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")
SEP=","

dwm_volume () {
    mute=$(pactl get-sink-mute 0 | cut -d ' ' -f2)
    if [[ $mute == yes ]]; then
        printf "婢 %s%%" "0"
    else
        VOL=$(pactl get-sink-volume 0 | head -1 | awk '{print $5}' | sed 's/%//g')
        if [[ $VOL -le 0 ]]; then
            printf "婢 %s%%" "$VOL"
        elif [[ $VOL -gt 0 ]] && [[ $VOL -lt 33 ]]; then
            printf " %s%%" "$VOL"
        elif [[ $VOL -gt 33 ]] && [[ $VOL -le 66 ]]; then
            printf "墳 %s%%" "$VOL"
        else
            printf " %s%%" "$VOL"
        fi
    fi
    printf "%s" "$SEP"
}

dwm_backlight () {
    bright=$(printf %.0f $(light -G))
    if [[ $bright -le 10 ]]; then
        printf " %s%%" "$bright"
    elif [[ $bright -gt 10 ]] && [[ $bright -le 40 ]]; then
        printf " %s%%" "$bright"
    elif [[ $bright -gt 40 ]] && [[ $bright -le 80 ]]; then
        printf " %s%%" "$bright"
    else
        printf " %s%%" "$bright"
    fi
    printf "%s" "$SEP"
}

dwm_battery() {
    if [ -d /sys/class/power_supply/BAT0 ]; then
        capacity=$(cat /sys/class/power_supply/BAT0/capacity)
        charging=$(cat /sys/class/power_supply/BAT0/status)
        if [[ "$charging" == "Charging" ]]; then
            ICON=' '
	elif [[ "$charging" == "Discharging" ]]; then
	    ICON='ﮤ '
        elif [[ $capacity -le 25 ]]; then
            ICON=' '
        fi

        if [[ $capacity -ge 90 ]]; then
            BAT_ICON='  '
        elif [[ $capacity -le 25 ]]; then
            BAT_ICON='  '
        elif [[ $capacity -le 60 ]]; then
            BAT_ICON='  '
        elif [[ $capacity -le 90 ]]; then
            BAT_ICON='  '
        fi
    fi
    printf "%s%s%s%%" "$ICON" "$BAT_ICON" "$capacity"
    #printf "%s" "$SEP"
}

dwm_internet () {
    CON_TYPE=$(nmcli -t -f TYPE connection show --active)
    CON_NAME=$(nmcli -t -f NAME connection show --active)
    if [[ $CON_TYPE =~ .*wireless ]]; then
        strength=$(cat $DIR/status_data/internet)
	if [[ $strength -le 0 ]]; then
	    printf "睊 %s%%" "$strength"
	elif [[ $strength -gt 0 ]] && [[ $strength -lt 70 ]]; then
	    printf "直 %s%%" "$strength"
	else
	    printf "  %s%%" "$strength"
	fi
    elif [[ $CON_TYPE =~ .*ethernet ]]; then
	printf " Ethernet"
    elif [[ -z $CON_TYPE ]]; then
	printf "  Disconnected"
    else
	exit 0
    fi
    printf "%s" "$SEP"
}

dwm_resources () {
    free_output=$(free -h | grep Mem)
    df_output=$(df -h /home | tail -n 1)
    MEMUSED=$(echo $free_output | awk '{print $3}')
    MEMTOT=$(echo $free_output | awk '{print $2}')
    STOUSED=$(echo $df_output | awk '{print $3}')
    STOTOT=$(echo $df_output | awk '{print $2}')
    printf " %s/%s%s" "$MEMUSED" "$MEMTOT" "$SEP"
    printf " %s/%s%s" "$STOUSED" "$STOTOT" "$SEP"
}

dwm_weather () {
    DATA=$(cat $DIR/status_data/weather | awk '{print $3}')
    printf "  %s%s" "$DATA" "$SEP"
}

# only one-time peek maybe
one_time=$(dwm_resources)

while true
do
    bar="$one_time$(dwm_backlight)$(dwm_volume)$(dwm_battery)"
    xsetroot -name "$bar"
    sleep 0.1
done &
