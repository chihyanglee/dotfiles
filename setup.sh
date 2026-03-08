#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh"

echo "Setting up dotfiles from $DOTFILES"

# Check stow is installed
if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is required. Install it with: pacman -S stow"
    exit 1
fi

# Stow all packages
mkdir -p ~/.config
packages=(hypr kitty fuzzel mako eww awww matugen mise tmux vim zsh gtk-3.0 gtk-4.0 scripts yazi fastfetch)
for pkg in "${packages[@]}"; do
    if [ -d "$DOTFILES/$pkg" ]; then
        stow -d "$DOTFILES" -t "$HOME" "$pkg"
        echo "  stowed $pkg"
    else
        echo "  skipped $pkg (not found)"
    fi
done

# Zsh plugins
mkdir -p "$ZSH_PLUGIN_DIR"
plugins=(
    "romkatv/powerlevel10k"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
)
for plugin in "${plugins[@]}"; do
    name="${plugin##*/}"
    dest="$ZSH_PLUGIN_DIR/$name"
    if [ -d "$dest" ]; then
        echo "  $name already installed"
    else
        git clone --depth=1 "https://github.com/$plugin.git" "$dest"
        echo "  installed $name"
    fi
done

# Wallpaper directory
mkdir -p "$HOME/Pictures/Wallpapers"

# Theme placeholder
touch "$HOME/.config/hypr/theme.conf"

# Dark mode
if command -v gsettings &>/dev/null; then
    "$HOME/.local/bin/set-dark-mode"
    echo "  applied dark mode settings"
else
    echo "  skipped dark mode (gsettings not found)"
fi

echo "Done."
