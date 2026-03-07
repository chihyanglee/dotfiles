#!/usr/bin/env bash

title="$(hyprctl activewindow -j | jq -r '.title // empty')"

if [[ -n "$title" && "$title" != "null" ]]; then
  echo "$title"
else
  echo "Desktop"
fi

