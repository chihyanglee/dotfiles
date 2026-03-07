#!/usr/bin/env bash

active="$(hyprctl activeworkspace -j | jq -r '.id')"
all="$(hyprctl workspaces -j | jq -r 'map(.id) | sort | .[]')"

out=""
for ws in $all; do
  if [[ "$ws" == "$active" ]]; then
    out+="●$ws  "
  else
    out+="○$ws  "
  fi
done

printf "%s\n" "$out"

