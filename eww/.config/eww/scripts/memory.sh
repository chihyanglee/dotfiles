#!/usr/bin/env bash

awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {printf "%d%%\n", (total-avail)*100/total}' /proc/meminfo
