#!/usr/bin/sh
read -p 'site name: ' site
read -p 'user name: ' user
echo $user | pass insert -e $site/username
pass generate $site/passwd 15

