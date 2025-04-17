#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

git pull origin master

# *Automodus erkennen:*
# Für Codespaces: CODESPACES=true
# Für Coder Workspaces: meistens ist CODER_ENV oder CODER_WORKSPACE_ID gesetzt
AUTO_MODE=false
if [[ "$CODESPACES" == "true" || -n "$CODER_ENV" || -n "$CODER_WORKSPACE_ID" ]]; then
    AUTO_MODE=true
fi
# Der Parameter --auto aktiviert AUTOMODUS zusätzlich (zB. für Tests/Lokal)
if [[ "$1" == "--auto" ]]; then
    AUTO_MODE=true
fi

# "ask"-Funktion, automatische Beantwortung im AUTO_MODE
ask() {
    # $1=Fragetext, $2=Default-Antwort (y/n)
    if [ "$AUTO_MODE" = true ]; then
        REPLY="$2"
        echo "$1 ($2)   [automatisch: $2]"
    else
        read -p "$1 ($2) " -n 1
        echo ""
    fi
}

function doIt() {
    # MAC: immer NEIN im Auto-Mode (z.B. Codespaces/Coder laufen nie auf Mac)
    ask "Are you on MAC?" "n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export IS_MAC=true
    else
        export IS_MAC=false
    fi

    source ./_install/brew.sh

    if [[ "$IS_MAC" == true ]]; then
        ask "Would you like to put on my Mac Dock" "n"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source ./macOS/dock.sh
        fi
    fi

    ask "Do you want to use my zsh and oh-my-zsh settings?" "y"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source ./_install/zsh.sh
    fi

    ask "Do you want to use asdf?" "n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source ./asdf/plugins.sh
    fi

    if [[ "$IS_MAC" == true ]]; then
        ask "Would you like to use Mackup? (Keep your application settings in sync) (OS X/Linux)" "n"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source ./_install/mackup.sh
        fi
    fi

    ask "Do you want to use Vim and NeoVim?" "y"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source ./_install/nvim.sh
    fi

    ask "Do you want to have my Development/Project folder structure?" "n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source ./macOS/project-folder-structure.sh
    fi

    source ./_install/git.sh

    if [[ "$IS_MAC" == true ]]; then
        source ./macOS/settings.sh
    fi

    echo ""
    echo "Set your user tokens as environment variables, such as ~/.secrets"
    echo "See the README for examples."

    ask "Do you want to restart now? (Recommended)" "n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
}

# Wenn Skript mit --force, -f oder --auto aufgerufen wird, dann los.
if [[ "$1" == "--force" || "$1" == "-f" || "$1" == "--auto" ]]; then
    doIt
else
    ask "This may overwrite existing files in your home directory. Are you sure?" "n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi

unset doIt