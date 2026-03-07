#!/usr/bin/env bash

status="$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n1)"

if [[ "$status" == "1" ]]; then
  echo "ON"
elif [[ "$status" == "0" ]]; then
  echo "OFF"
else
  echo "--"
fi

