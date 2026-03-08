#!/usr/bin/env bash

awk '/^cpu / {usage=100-($5*100/($2+$3+$4+$5+$6+$7+$8)); printf "%d%%\n", usage}' /proc/stat
