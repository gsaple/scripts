#! /bin/sh

LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")
weather=$DIR/status_data/weather
internet=$DIR/status_data/internet
city=Melbourne

# monitor weather every hour
while true
do
    curl wttr.in/$city?format=3 > $weather
    sleep 1h
done &

# monitor wifi signal every five minutes
while true
do
    CON_NAME=$(nmcli -t -f NAME connection show --active)
    read -ra ADDR <<< "$(nmcli device wifi list | grep $CON_NAME)"
    echo ${ADDR[-3]} > $internet
    sleep 5m
done &
