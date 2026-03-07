# Dotfiles

Personal Arch Linux desktop configuration centered around Hyprland.

## Stack

| Component | Role |
|-----------|------|
| **Hyprland** | Wayland compositor |
| **EWW** | Top bar and widgets |
| **Kitty + tmux + zsh** | Terminal (Powerlevel10k prompt) |
| **Matugen + awww** | Wallpaper-driven dynamic theming |
| **Fuzzel** | App launcher / wallpaper picker |
| **Mako** | Notifications |
| **mise** | Dev tool version manager (node, python, go, etc.) |

## Layout

All configs live in `config/` and are symlinked to `~/.config/`. Third-party code (zsh plugins, themes) and wallpapers are kept outside the repo.

```
config/
├── awww/          wallpaper manager + scripts
├── eww/           bar widgets (yuck + scss + shell scripts)
├── fuzzel/        app launcher
├── hypr/          compositor (modular: keybinds, autostart, theme, etc.)
├── kitty/         terminal emulator
├── mako/          notification daemon
├── matugen/       color generation templates
├── mise/          dev tool versions (node, python, go, uv, pnpm)
├── tmux/          terminal multiplexer
├── vim/           editor
└── zsh/           shell (.zshrc, aliases, plugins, p10k)
```

## Theme Pipeline

Changing a wallpaper regenerates the entire color scheme:

```
wallpaper → awww (set) → matugen (extract colors) → generated theme files → app reloads
```

Matugen uses templates in `config/matugen/templates/` to generate color files for Hyprland, Kitty, EWW, and Fuzzel. To change colors, edit the templates — never the generated files directly.

```bash
# Apply a wallpaper and regenerate theme
~/.config/awww/scripts/wallpaper.sh ~/Pictures/Wallpapers/image.jpg

# Interactive picker (bound to a Hyprland keybind)
~/.config/awww/scripts/pick-wallpaper.sh
```

## Setup

```bash
# Clone
git clone <repo-url> ~/dotfiles

# Symlink all configs
ln -sfn ~/dotfiles/config/{hypr,kitty,fuzzel,mako,eww,awww,matugen,mise,tmux,zsh,vim} ~/.config/

# Zsh entrypoint (delegates to the repo)
cat > ~/.zshrc <<'EOF'
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshrc"
EOF

# Zsh plugins (outside the repo)
mkdir -p ~/.local/share/zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/zsh-syntax-highlighting

# Wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# Ensure generated theme placeholder exists
touch ~/.config/hypr/theme.conf
```

## Useful Commands

```bash
hyprctl reload                                # reload Hyprland
pkill eww || true; eww daemon; eww open bar   # restart EWW bar
eww logs                                      # check EWW logs
tmux source-file ~/.config/tmux/tmux.conf     # reload tmux config
```
