#!/bin/sh
du -a --exclude='*.git*' --exclude='*obs*' $HOME/mybin $HOME/.config | awk '{print $2}' | fzf | xargs -r $EDITOR
