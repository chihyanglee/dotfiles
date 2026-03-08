#!/usr/bin/env bash

signal="$(nmcli -t -f active,signal dev wifi | awk -F: '$1=="yes" {print $2; exit}')"

if [[ -n "$signal" ]]; then
  echo "${signal}%"
else
  echo "--"
fi

