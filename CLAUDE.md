# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Arch Linux dotfiles repository for a Hyprland (Wayland) desktop. Managed with **GNU Stow** — each top-level directory is a stow package that mirrors `$HOME`. Run `stow <package>` from the repo root to symlink configs into place.

## Architecture

### Stow Package Layout
Each package mirrors `$HOME`. Most use `<package>/.config/<app>/`, but some target other XDG paths:
```
dotfiles/
├── hypr/.config/hypr/       → ~/.config/hypr/
├── kitty/.config/kitty/     → ~/.config/kitty/
├── zsh/.config/zsh/         → ~/.config/zsh/
├── zsh/.zshrc               → ~/.zshrc
├── vim/.vim/vimrc           → ~/.vim/vimrc
├── scripts/.local/bin/      → ~/.local/bin/ (user scripts)
├── systemd/.config/systemd/user/ → ~/.config/systemd/user/ (hyprland-session.target)
└── ...
```

To add a new config package: `mkdir -p <name>/.config/<name>`, add files, then `stow <name>`.
To add a user script: place it in `scripts/.local/bin/`, then `stow scripts`.
To remove a package: `stow -D <name>`.
New packages must also be added to the `packages` list in `setup.sh`.

`README.md` is the human-facing doc (install steps, package lists, session/systemd background). Don't duplicate it here — this file holds only what an agent needs to edit safely.

### Desktop Stack
- **Hyprland** — Wayland compositor (`hypr/.config/hypr/`)
- **EWW** — top bar and widgets (`eww/.config/eww/`)
- **Kitty** — terminal emulator (`kitty/.config/kitty/`)
- **Tmux** — terminal multiplexer (`tmux/.config/tmux/`)
- **Zsh + Powerlevel10k** — shell (`zsh/.config/zsh/`)
- **Fuzzel** — app launcher (`fuzzel/.config/fuzzel/`)
- **Mako** — notification daemon (`mako/.config/mako/`)
- **Awww + Matugen** — wallpaper setter + color generation (`awww/.config/awww/`, `matugen/.config/matugen/`)
- **Fastfetch** — system info display (`fastfetch/.config/fastfetch/`)
- **hypridle + hyprlock** — idle/lock (`hypr/.config/hypr/hypridle.conf`, `hyprlock.conf`)
- **Neovim (LazyVim)** — editor (`nvim/.config/nvim/`); `vim/` is a minimal fallback
- **Yazi** — file manager, also the wallpaper picker (`yazi/.config/yazi/`)
- **Ghostty** — secondary terminal (`ghostty/.config/ghostty/`)
- **mise** — runtime/tool versions (`mise/.config/mise/`)
- **fcitx5** — input method (Rime, Mozc); configured outside the repo
- **greetd + tuigreet** — login greeter; configured in `/etc/greetd/`, outside the repo

### CLI Replacements
Shell aliases in `zsh/.config/zsh/aliases.zsh` map standard commands to modern alternatives:
- **eza** → `ls`, `ll`, `la`, `lt` (tree)
- **bat** → `cat`, `catn` (with line numbers)
- **ripgrep** → `rg` (smart-case by default)
- **delta** — git pager (configured globally in `~/.gitconfig`)
- **dust** → `du`, **duf** → `df`, **btop** → `top`, **procs** → `ps`

### Theme Pipeline
```
Wallpaper → awww (set wallpaper) → matugen (extract colors) → template files → app reloads
```

Matugen templates in `matugen/.config/matugen/templates/` generate color files consumed by Hyprland, Kitty, EWW, and Fuzzel. Generated files (e.g. `hypr/.config/hypr/theme.lua`, `eww/.config/eww/colors.scss`, `kitty/.config/kitty/themes/generated.conf`, `fuzzel/.config/fuzzel/colors.ini`) are reproducible from any wallpaper image.

### Modular Config Pattern
Main config files act as orchestrators that `source` modular sub-files:
- `hyprland.lua` `require()`s `env`, `monitors`, `input`, `animations`, `rules`, `keybinds`, `autostart`, and `theme` (the last via `pcall`, since matugen may not have generated it yet)
- `eww.yuck` includes widget files from `widgets/`
- `.zshrc` sources `plugins.zsh`, `aliases.zsh`, `p10k.zsh`

### EWW Conventions
- Layout belongs in **Yuck** (`box`, `centerbox`, spacing, geometry)
- Styling belongs in **SCSS** (colors, padding, margins, borders, font)
- Shell scripts in `eww/scripts/` provide data via `defpoll`/`deflisten`; prefer EWW magic variables (`EWW_CPU`, `EWW_RAM`, …) where one exists

### Zsh Conventions
- The entrypoint is `zsh/.config/zsh/.zshrc` (dot prefix required — zsh expects `.zshrc` inside `ZDOTDIR`)
- A stub `zsh/.zshrc` sets `ZDOTDIR` and is stowed to `~/.zshrc`
- Third-party plugins (powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions) are managed by **zinit** in `zsh/.config/zsh/plugins.zsh`; zinit bootstraps itself from `.zshrc` into `~/.local/share/zinit/`
- Aliases live in `zsh/.config/zsh/aliases.zsh` — prefer aliasing to modern CLI tools (eza, bat, etc.) over customizing legacy commands

### Fastfetch Conventions
- Config is `fastfetch/.config/fastfetch/config.jsonc`
- Logo images go in `fastfetch/.config/fastfetch/logos/` (gitignored — user-specific)

## Common Commands

```bash
# Stow all packages
./setup.sh

# Stow a single package
stow <package>

# Unstow a package
stow -D <package>

# Validate the Hyprland Lua config without touching the running session
Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

# Reload Hyprland
hyprctl reload

# Restart EWW bar
pkill eww || true; eww daemon; eww open bar

# Check EWW logs
eww logs

# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf

# Test wallpaper/theme pipeline
~/.config/awww/scripts/wallpaper.sh ~/Pictures/Wallpapers/<file>
```

## Key Rules

- Generated theme files should not be hand-edited — modify the Matugen template in `matugen/.config/matugen/templates/` instead.
- The session is launched by `start-hyprland`, not uwsm. `hyprland-session.target` (stowed from the `systemd` package, started/stopped by `autostart.lua`) is what activates `graphical-session.target` — without it, `systemctl --user enable` on any Hypr ecosystem service silently never starts. Keep env vars in `env.lua`, not `~/.config/uwsm/env`.
- Hyprland is configured in **Lua** (`hl.*` API), not hyprlang — hyprlang was deprecated in Hyprland 0.55. Always validate edits with `Hyprland --verify-config` before relying on them; it catches unknown config keys, bad dispatchers and bad rule fields, but *not* unknown `hl.bind` flags. `hyprlock` and `hypridle` are separate programs and still use hyprlang `.conf`. Note `hyprctl dispatch` also takes Lua now — `hyprctl dispatch dpms off` fails, use `hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'`; this matters for anything shelling out to hyprctl, e.g. `hypridle.conf` and EWW `:onclick` handlers.
- **Git operations touching `hypr/` edit the live session.** Stow folds `~/.config/hypr` into a symlink to `hypr/.config/hypr/`, and Hyprland reloads on every file change, so `git checkout`/`stash`/`rebase`/`merge` that adds or removes files there can drop the session into emergency mode. Run `hyprctl keyword misc:disable_autoreload true` first, then `hyprctl reload` once afterwards. Recover with `hyprctl reload`; check `hyprctl configerrors`.
- `hyprlock` has no config-check command — the only test is actually locking. Its errors land in the journal under `hypridle` (which spawns it): `journalctl --user -b | grep -i hyprlock`.
- System files are **not** in this repo and need sudo: `/etc/greetd/config.toml` (tuigreet greeter), `/etc/pam.d/`. Never `systemctl restart greetd` from inside the session — it kills Hyprland.
- Transparency is controlled by Kitty (`background_opacity`), not tmux. Tmux styles should use `bg=default` to preserve transparency.
- Delta is configured globally in `~/.gitconfig`, not in the dotfiles repo. Keep git pager config there.
- Fastfetch logo images are gitignored — only the config is tracked.
