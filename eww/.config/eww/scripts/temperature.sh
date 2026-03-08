#!/usr/bin/env bash

temp="$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -rn | head -n1)"
if [[ -n "$temp" ]]; then
  echo "$((temp / 1000))°C"
else
  echo "--"
fi
