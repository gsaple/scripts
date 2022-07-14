#! /bin/sh
 
while true
do
    xsetroot -name "$(printf "📆 %s" "$(date "+%A %d/%m/%Y %T")")"
    sleep 1
done &
    
