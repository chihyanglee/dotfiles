#!/usr/bin/env bash

active="$(hyprctl activeworkspace -j | jq -r '.id')"
all="$(hyprctl workspaces -j | jq -r '[.[] | select(.id > 0)] | map(.id) | sort | .[]')"

max=5
for ws in $all; do
  (( ws > max )) && max="$ws"
done

json="["
for ((i=1; i<=max; i++)); do
  (( i > 1 )) && json+=","
  if (( i == active )); then
    json+="{\"id\":$i,\"active\":true}"
  else
    json+="{\"id\":$i,\"active\":false}"
  fi
done
json+="]"

echo "$json"
