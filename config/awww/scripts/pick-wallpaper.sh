#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
APPLY_SCRIPT="$HOME/.config/awww/scripts/wallpaper.sh"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Wallpaper directory not found: $WALLPAPER_DIR"
  exit 1
fi

if [[ ! -x "$APPLY_SCRIPT" ]]; then
  echo "Wallpaper apply script not found or not executable: $APPLY_SCRIPT"
  exit 1
fi

selection="$(
  find "$WALLPAPER_DIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    | sort \
    | sed "s|$WALLPAPER_DIR/||" \
    | fuzzel --dmenu --prompt='Wallpaper> '
)"

if [[ -z "${selection:-}" ]]; then
  exit 0
fi

"$APPLY_SCRIPT" "$WALLPAPER_DIR/$selection"

