#!/bin/sh
du -a --exclude='*.git' $HOME/mybin $HOME/.config | awk '{print $2}' | fzf | xargs -r $EDITOR
