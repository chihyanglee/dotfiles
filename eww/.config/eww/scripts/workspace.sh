#!/usr/bin/env bash
# Emit the workspace list as JSON, once now and again on every Hyprland
# workspace event (deflisten — no polling).

emit() {
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
}

emit

# Hyprland's event socket. python because bash cannot open a unix socket and
# neither socat nor nc is installed here.
/usr/bin/python3 -uc '
import os, socket
s = socket.socket(socket.AF_UNIX)
s.connect(os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr",
                       os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock"))
for line in s.makefile():
    print(line, end="", flush=True)
' | while read -r line; do
  case "$line" in
    workspace*|createworkspace*|destroyworkspace*|focusedmon*|moveworkspace*) emit ;;
  esac
done
