#!/bin/sh

# some of following functions are modified from scripts found on
# https://github.com/joestandring/dwm-bar
# https://github.com/thytom/dwmbar

#SEP=" ⏽ "
SEP=" ^c#04cc0b^^d^ "

dwm_volume () {
    mute=$(pactl get-sink-mute 0 | cut -d ' ' -f2)
    if [[ $mute == yes ]]; then
        printf "🔇 %s%%" "0"
    else
        VOL=$(pactl get-sink-volume 0 | head -1 | awk '{print $5}' | sed 's/%//g')
        if [[ $VOL -le 0 ]]; then
            printf "🔇 %s%%" "$VOL"
        elif [[ $VOL -gt 0 ]] && [[ $VOL -lt 33 ]]; then
            printf "🔈%s%%" "$VOL"
        elif [[ $VOL -gt 33 ]] && [[ $VOL -le 66 ]]; then
            printf "🔉%s%%" "$VOL"
        else
            printf "🔊 %s%%" "$VOL"
        fi
    fi
    printf "%s" "$SEP"
}

dwm_backlight () {
    bright=$(printf %.0f $(light -G))
    if [[ $bright -le 10 ]]; then
        printf "🌜 %s%%" "$bright"
    elif [[ $bright -gt 10 ]] && [[ $bright -le 40 ]]; then
        printf "🔅 %s%%" "$bright"
    elif [[ $bright -gt 40 ]] && [[ $bright -le 80 ]]; then
        printf "🔆 %s%%" "$bright"
    else
        printf "🟡 %s%%" "$bright"
    fi
    printf "%s" "$SEP"
}

dwm_battery () {
    BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
    CHARGE=$(cat /sys/class/power_supply/${BAT}/capacity)
    STATUS=$(cat /sys/class/power_supply/${BAT}/status)
    if [[ $STATUS = Charging ]]; then
        printf "🔌%s%% %s" "$CHARGE" "$STATUS"
    else
        printf "🔋%s%% %s" "$CHARGE" "$STATUS"
    fi
    #printf "%s" "$SEP"
}

dwm_internet () {
    CON_TYPE=$(nmcli -t -f TYPE connection show --active)
    CON_NAME=$(nmcli -t -f NAME connection show --active)
    if [[ $CON_TYPE =~ .*wireless ]]; then
        read -ra ADDR <<< "$(nmcli device wifi list | grep $CON_NAME)"
	strength=${ADDR[-3]}
	if [[ $strength -le 0 ]]; then
	    printf "^c#a89984^睊 ^d^%s%%" "$strength"
	elif [[ $strength -gt 0 ]] && [[ $strength -lt 70 ]]; then
	    printf "^c#0394ab^直 ^d^%s%%" "$strength"
	else
	    printf "^c#07d5f5^ ^d^ %s%%" "$strength"
	fi
    elif [[ $CON_TYPE =~ .*ethernet ]]; then
	printf "^c#07d5f5^^d^ Ethernet"
    elif [[ -z $CON_TYPE ]]; then
	printf "^c#a89984^ ^d^ Disconnected"
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
    printf "🧠 %s/%s%s" "$MEMUSED" "$MEMTOT" "$SEP"
    printf "🖥 %s/%s%s" "$STOUSED" "$STOTOT" "$SEP"
}

dwm_weather () {
    DATA=$(curl -s wttr.in/?format=3 | awk '{print $3, $4}')
    printf "%s%s" "$DATA" "$SEP"
}

# only one-time peek maybe
one_time=$(dwm_weather)$(dwm_internet)$(dwm_resources)

while true
do
    bar="$one_time$(dwm_backlight)$(dwm_volume)$(dwm_battery)"
    xsetroot -name "$bar"
    sleep 0.1
done &
