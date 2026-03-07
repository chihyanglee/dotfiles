#!/usr/bin/env bash

if ! command -v bluetoothctl &>/dev/null; then
  echo "off"
  exit 0
fi

powered="$(bluetoothctl show 2>/dev/null | grep -c "Powered: yes")"
if [[ "$powered" -ge 1 ]]; then
  echo "on"
else
  echo "off"
fi
