#!/bin/sh
cd $HOME/$(cat $HOME/.local/bin/fav_dir.txt | fzf)
