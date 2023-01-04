#!/bin/sh
du -a --exclude='*.git*' --exclude='*obs*' $HOME/mybin $HOME/.config $HOME/.local/share/nvim/project_nvim | awk '{print $2}' | fzf | xargs -r $EDITOR
