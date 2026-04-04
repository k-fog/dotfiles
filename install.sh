#!/bin/bash -x

CUR=$(pwd)
CONFIG_DIR="$HOME/.config"

# neovim
mkdir -p "$CONFIG_DIR/nvim"
ln -sfn "$CUR/nvim/init.lua" "$CONFIG_DIR/nvim/init.lua"

# tmux
mkdir -p "$CONFIG_DIR/tmux"
ln -sfn "$CUR/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

# zsh
ln -sfn "$CUR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -sfn "$CUR/zsh/.zshrc" "$HOME/.zshrc"

# sheldon (zsh plugin manager)
mkdir -p "$CONFIG_DIR/sheldon"
ln -sfn "$CUR/sheldon/plugins.toml" "$CONFIG_DIR/sheldon/plugins.toml"

# git
ln -sfn "$CUR/git/.gitconfig" "$HOME/.gitconfig"
