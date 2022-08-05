#!/bin/sh
cd $HOME/$(cat $HOME/mybin/fav_dir.txt | fzf)
