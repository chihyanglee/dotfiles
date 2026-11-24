#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up dotfiles from $DOTFILES"

# Check stow is installed
if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is required. Install it with: pacman -S stow"
    exit 1
fi

# Stow all packages
mkdir -p ~/.config
packages=(hypr kitty fuzzel mako eww awww matugen mise tmux vim nvim ghostty zsh gtk-3.0 gtk-4.0 scripts systemd yazi fastfetch)
for pkg in "${packages[@]}"; do
    if [ -d "$DOTFILES/$pkg" ]; then
        stow -d "$DOTFILES" -t "$HOME" "$pkg"
        echo "  stowed $pkg"
    else
        echo "  skipped $pkg (not found)"
    fi
done

# Wallpaper directory
mkdir -p "$HOME/Pictures/Wallpapers"

# Theme placeholder
touch "$HOME/.config/hypr/theme.lua"

# Pick up the stowed systemd user units without waiting for a re-login
if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload
    echo "  reloaded systemd user units"
fi

# Dark mode
if command -v gsettings &>/dev/null; then
    "$HOME/.local/bin/set-dark-mode"
    echo "  applied dark mode settings"
else
    echo "  skipped dark mode (gsettings not found)"
fi

echo "Done."
