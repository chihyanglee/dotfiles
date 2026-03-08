#!/usr/bin/env bash

wifi="$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes" {print $2; exit}')"
if [[ -n "$wifi" ]]; then
  echo "$wifi"
  exit 0
fi

eth="$(nmcli -t -f device,type,state dev status | awk -F: '$2=="ethernet" && $3=="connected" {print $1; exit}')"
if [[ -n "$eth" ]]; then
  echo "ETH"
  exit 0
fi

echo "OFFLINE"
