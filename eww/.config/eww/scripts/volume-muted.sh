#!/usr/bin/env bash
# Emit mute state on every default-sink change

get_muted() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 'true' || echo 'false'
}

get_muted
pactl subscribe 2>/dev/null | while read -r line; do
  case "$line" in
    *"on sink"*|*"on server"*) get_muted ;;
  esac
done
