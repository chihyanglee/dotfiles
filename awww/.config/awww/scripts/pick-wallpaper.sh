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

LOG="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper.log"
mkdir -p "$(dirname "$LOG")"

# wallpaper.sh runs under `set -e` and exits silently on any failed check, so record
# exactly what yazi handed back before deciding anything.
{
  printf '\n=== %s ===\n' "$(date -Iseconds)"
  printf 'chooser-file bytes : %s\n' "$(wc -c <"$tmpfile")"
  printf 'chooser-file lines : %s\n' "$(wc -l <"$tmpfile")"
  printf 'selection          : %q\n' "$selection"
  printf 'is a regular file  : %s\n' "$([[ -f $selection ]] && echo yes || echo NO)"
} >>"$LOG"

if [[ -z "${selection:-}" ]]; then
  echo 'empty selection -> nothing to do' >>"$LOG"
  exit 0
fi

# setsid -f always forks, so the child is reparented before this script exits and
# kitty SIGHUPs its process group. Output goes to a log, not /dev/null: wallpaper.sh
# runs under `set -e`, so a single failing command aborts it silently otherwise.
setsid -f "$APPLY_SCRIPT" "$selection" </dev/null >>"$LOG" 2>&1
