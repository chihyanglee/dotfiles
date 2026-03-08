#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="${1:-}"

if [[ -z "$WALLPAPER" ]]; then
  echo "Usage: wallpaper.sh /absolute/path/to/wallpaper"
  exit 1
fi

if [[ ! -f "$WALLPAPER" ]]; then
  echo "File not found: $WALLPAPER"
  exit 1
fi

if ! pgrep -x awww-daemon >/dev/null 2>&1; then
  awww-daemon >/dev/null 2>&1 &
  sleep 1
fi

awww img "$WALLPAPER" --transition-type center --transition-duration 1
matugen image "$WALLPAPER" -m dark

hyprctl reload

pkill eww || true
eww daemon
eww open bar

echo "Applied wallpaper and regenerated theme:"
echo "$WALLPAPER"
