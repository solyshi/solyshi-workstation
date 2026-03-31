#!/bin/bash

if pgrep -x "wl-recorder" > /dev/null; then
    pkill --wait "wl-recorder"
    filename=$(cat /tmp/wl-recorder-current 2>/dev/null)
    rm -f /tmp/wl-recorder-current
    notify-send "Screen Recording" "Recording saved to $filename"
else
    choice=$(printf "Fullscreen\nRegion" | rofi -dmenu -p "Record")

    if [ -z "$choice" ]; then
        exit 0
    fi

    mkdir -p "$HOME/Videos/Recordings"

    if [ "$choice" = "Fullscreen" ]; then
        filename="$HOME/Videos/Recordings/$(date +%Y%m%d_%H%M%S).mp4"
        echo "$filename" > /tmp/wl-recorder-current
        wl-recorder -f "$filename" &
        disown
        notify-send "Screen Recording" "Recording started (Fullscreen)"
    elif [ "$choice" = "Region" ]; then
        geom=$(slurp)
        if [ -z "$geom" ]; then
            exit 0
        fi
        filename="$HOME/Videos/Recordings/$(date +%Y%m%d_%H%M%S).mp4"
        echo "$filename" > /tmp/wl-recorder-current
        wl-recorder -g "$geom" -f "$filename" &
        disown
        notify-send "Screen Recording" "Recording started (Region)"
    else
        notify-send "Screen Recording" "Unknown mode" -u critical
        exit 1
    fi
fi
