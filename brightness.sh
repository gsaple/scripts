#!/bin/bash
case $1 in
up)
    light -A 5
    ;;
down)
    light -U 5
    ;;
esac

current_bright=$(printf %.0f $(light -G))
echo $current_bright
if [ $current_bright -lt 10 ]; then
    light -S 10
fi
