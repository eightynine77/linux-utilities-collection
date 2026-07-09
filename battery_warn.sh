#!/usr/bin/env bash

BATTERY=$(upower -e | grep BAT)

last_state=""

upower --monitor-detail | while read -r line; do
    if echo "$line" | grep -q "percentage:"; then
        level=$(echo "$line" | awk '{print $2}' | tr -d '%')

        if [ "$level" -le 25 ] && [ "$last_state" != "low" ]; then
            notify-send -t 6000 "⚠️ Battery Low" "Battery is at ${level}%. Plug in the charger."
            last_state="low"
        elif [ "$level" -ge 79 ] && [ "$last_state" != "high" ]; then
            notify-send -t 6000 "🔋 Battery High" "Battery has reached ${level}%. Consider unplugging."
            last_state="high"
        fi
    fi
done
