#!/usr/bin/env bash
set -euo pipefail

mode="${1:-lan}"

get_lan_ip() {
  ip route get 1.1.1.1 2>/dev/null | awk '
    /src/ {
      for (i = 1; i <= NF; i++) {
        if ($i == "src") {
          print $(i+1)
          exit
        }
      }
    }'
}

get_wan_ip() {
  curl -4 -fsS --max-time 3 https://api.ipify.org 2>/dev/null || echo "--"
}

lan_ip="$(get_lan_ip)"
wan_ip=""

case "$mode" in
  lan)
    echo "${lan_ip:-"--"}"
    ;;
  wan)
    wan_ip="$(get_wan_ip)"
    echo "${wan_ip:-"--"}"
    ;;
  both)
    wan_ip="$(get_wan_ip)"
    echo "LAN ${lan_ip:-"--"}  WAN ${wan_ip:-"--"}"
    ;;
  *)
    echo "Usage: $0 {lan|wan|both}" >&2
    exit 1
    ;;
esac
