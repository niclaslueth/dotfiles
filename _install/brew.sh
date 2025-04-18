#!/usr/bin/env bash

# Install command-line tools using Homebrew.
if ! command -v brew >/dev/null 2>&1 ; then
    # Install Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Brew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! command -v stow >/dev/null 2>&1 ; then
    # Install GNU Stow
    echo "Installing GNU Stow..."
    brew install stow;
fi

# Install Homebrew Bundle
echo "Installing Homebrew Bundle..."
stow brew -t ~;
brew bundle install --file=~/Brewfile;