#!/usr/bin/env bash
while true; do
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
    if [ -n "$BAT_PATH" ] && [ -r "$BAT_PATH/capacity" ]; then
        BAT=$(cat "$BAT_PATH/capacity")
        STAT=$(cat "$BAT_PATH/status")
        echo "BAT: ${BAT}% (${STAT}) | $(date +'%Y-%m-%d %X')"
    else
        date +'%Y-%m-%d %X'
    fi
    sleep 1
done
