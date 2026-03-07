#!/usr/bin/env bash

days=(日 月 火 水 木 金 土)
echo "${days[$(date +%w)]}"
