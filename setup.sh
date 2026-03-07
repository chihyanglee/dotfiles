#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh"

echo "Setting up dotfiles from $DOTFILES"

# Symlink all configs to ~/.config
configs=(hypr kitty fuzzel mako eww awww matugen mise tmux zsh vim gtk-3.0 gtk-4.0 scripts)
mkdir -p ~/.config
for dir in "${configs[@]}"; do
    if [ -d "$DOTFILES/config/$dir" ]; then
        ln -sfn "$DOTFILES/config/$dir" "$HOME/.config/$dir"
        echo "  linked $dir"
    else
        echo "  skipped $dir (not found)"
    fi
done

# Zsh entrypoint
if [ ! -f "$HOME/.zshrc" ] || ! grep -q 'ZDOTDIR' "$HOME/.zshrc"; then
    cat > "$HOME/.zshrc" <<'EOF'
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshrc"
EOF
    echo "  created ~/.zshrc stub"
else
    echo "  ~/.zshrc already configured"
fi

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
    "$HOME/.config/scripts/set-dark-mode.sh"
    echo "  applied dark mode settings"
else
    echo "  skipped dark mode (gsettings not found)"
fi

echo "Done."
