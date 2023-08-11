#!/bin/sh
du -a --exclude='*.git*' \
    --exclude-from=$HOME/Projects/Dotfiles/.gitignore \
    $HOME/Projects/scripts \
    $HOME/Projects/Dotfiles \
    $HOME/Projects/bootstrap \
    $HOME/.local/share/nvim/project_nvim \
    | awk '{print $2}' | fzf | xargs -r $EDITOR
