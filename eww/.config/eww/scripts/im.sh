#!/usr/bin/env bash

im="$(fcitx5-remote -n 2>/dev/null)"

case "$im" in
  keyboard-us)  echo "EN" ;;
  rime)         echo "中" ;;
  mozc)         echo "あ" ;;
  *)            echo "EN" ;;
esac
