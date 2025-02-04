#!/usr/bin/env bash

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing Niclas Dotfiles for the first time"
    git clone --depth=1 https://github.com/niclaslueth/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
else
    echo "Niclas Dotfiles are already installed"
fi
