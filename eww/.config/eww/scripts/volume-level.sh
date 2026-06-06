#!/usr/bin/env bash
# Emit volume percentage on every default-sink change (instant updates via pactl subscribe)

get_level() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ |
    awk '{if (/MUTED/) print "0%"; else print int($2*100)"%"}'
}

get_level
pactl subscribe 2>/dev/null | while read -r line; do
  case "$line" in
    *"on sink"*|*"on server"*) get_level ;;
  esac
done
