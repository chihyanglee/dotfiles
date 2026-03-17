# Dotfiles

Lightweight Arch Linux desktop configuration for **i3wm (X11)**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

| Component | Role |
|-----------|------|
| **i3** (i3-gaps) | X11 tiling window manager with gaps |
| **i3status** | Status bar — network, battery, CPU, memory, volume, clock |
| **picom** | X11 compositor (transparency, blur, shadows, rounded corners) |
| **Kitty** | GPU-accelerated terminal |
| **tmux + zsh** | Multiplexer + shell (Powerlevel10k prompt) |
| **Yazi** | TUI file manager |
| **Rofi** | App launcher |
| **Dunst** | Notification daemon |
| **fcitx5** | Input method (Rime for Chinese, Mozc for Japanese) |
| **feh** | Wallpaper setter |
| **mise** | Dev tool version manager |
| **fastfetch** | System info display |
| **eza** | Modern `ls` with icons and git status |
| **bat** | `cat` with syntax highlighting |
| **ripgrep** | Fast recursive search |
| **delta** | Git diff viewer with syntax highlighting |
| **dust** | Disk usage visualizer |
| **duf** | Disk free viewer |
| **btop** | System monitor |
| **procs** | Process viewer |

## Layout

Each top-level directory is a stow package that mirrors `$HOME`:

```
dotfiles/
├── i3/.config/i3/              tiling window manager
│   └── config
├── i3status/.config/i3status/  status bar
│   └── config
├── picom/.config/picom/        compositor
│   └── picom.conf
├── rofi/.config/rofi/          app launcher
│   ├── config.rasi
│   └── custom.rasi
├── dunst/.config/dunst/        notifications
│   └── dunstrc
├── kitty/.config/kitty/        terminal emulator
├── gtk-3.0/.config/gtk-3.0/    GTK 3 settings
├── gtk-4.0/.config/gtk-4.0/    GTK 4 settings
├── mise/.config/mise/          dev tool versions
├── scripts/.local/bin/         user scripts (dark mode, tmux-launch, etc.)
├── tmux/.config/tmux/          terminal multiplexer
├── fastfetch/.config/fastfetch/ system info (config + logos/)
├── vim/.vim/vimrc              editor
├── nvim/.config/nvim/          neovim (LazyVim)
├── yazi/.config/yazi/          file manager
└── zsh/
    ├── .config/zsh/            shell (.zshrc, aliases, plugins, keybinds, p10k)
    └── .zshrc                  stub that sets ZDOTDIR
```

## Setup

### 1. Install packages

```bash
# Core
sudo pacman -S i3-wm i3status picom kitty tmux zsh rofi dunst feh stow xorg-server xorg-xinit

# Audio (PipeWire + WirePlumber)
sudo pacman -S pipewire wireplumber pipewire-pulse

# Bluetooth
sudo pacman -S bluez bluez-utils
sudo systemctl enable --now bluetooth

# Tools
sudo pacman -S yazi fzf zoxide jq scrot xclip brightnessctl networkmanager mpv glow

# CLI replacements
sudo pacman -S eza bat ripgrep git-delta dust duf btop procs fastfetch

# Input method
sudo pacman -S fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime fcitx5-mozc

# Font
sudo pacman -S ttf-firacode-nerd

# Dev
sudo pacman -S mise
```

### 2. Stow configs

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
```

Or stow individual packages:

```bash
stow i3 kitty zsh rofi  # etc.
```

### 3. Zsh plugins (outside the repo)

```bash
mkdir -p ~/.local/share/zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/zsh-syntax-highlighting
```

### 4. First run

```bash
# Copy a wallpaper into ~/Pictures/Wallpapers/ then:
feh --bg-fill ~/Pictures/Wallpapers/<your-wallpaper>

# Set up dark mode
set-dark-mode

# Configure input methods
fcitx5-configtool   # add Rime and Mozc to input method list
```

### 5. Starting i3

Add to `~/.xinitrc`:

```bash
export XMODIFIERS=@im=fcitx
exec i3
```

Then start with `startx`, or use a display manager like `ly` (lightweight TUI login).
