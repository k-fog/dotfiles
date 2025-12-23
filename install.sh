#!/bin/bash -x

CUR=$(pwd)
CONFIG_DIR="$HOME/.config"

# neovim
mkdir -p "$CONFIG_DIR/nvim"
ln -s "$CUR/init.lua" "$CONFIG_DIR/nvim/init.lua"

# tmux
mkdir -p "$CONFIG_DIR/tmux"
ln -s "$CUR/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

# zsh
ln -s "$CUR/.zsh_aliases" "$HOME/.zsh_aliases"
ln -s "$CUR/.zshrc" "$HOME/.zshrc"
