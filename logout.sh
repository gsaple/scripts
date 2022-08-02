#!/bin/sh
select=$(echo -e "restart\nshutdown\nlogout" | dmenu -l 3)
source ~/.bash_logout
case $select in
    "restart")
        systemctl reboot
        ;;
    "shutdown")
        systemctl poweroff
        ;;
    "logout")
	 loginctl terminate-user $USER
        ;;
esac
exit 0
