#!/bin/sh

# toggle between full and time bar

fullBar_id=$(pgrep full_bar.sh)
timeBar_id=$(pgrep time_bar.sh)

# might be mutiple processes created by users, kill all of them
pkill full_bar.sh
pkill time_bar.sh

[[ ! -z $fullBar_id ]] && time_bar.sh && exit 0
[[ ! -z $timeBar_id ]] && full_bar.sh && exit 0
time_bar.sh
