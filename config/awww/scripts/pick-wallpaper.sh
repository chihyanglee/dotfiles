#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
APPLY_SCRIPT="$HOME/.config/awww/scripts/wallpaper.sh"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Wallpaper directory not found: $WALLPAPER_DIR"
  exit 1
fi

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

yazi --chooser-file="$tmpfile" "$WALLPAPER_DIR"

selection="$(cat "$tmpfile")"

if [[ -z "${selection:-}" ]]; then
  exit 0
fi

nohup "$APPLY_SCRIPT" "$selection" >/dev/null 2>&1 &
