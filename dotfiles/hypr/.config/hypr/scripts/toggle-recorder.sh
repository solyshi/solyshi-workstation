#!/bin/bash

REC_BIN="wf-recorder"
TMP_FILE="${XDG_RUNTIME_DIR:-/tmp}/rec-current-path"
REC_DIR="$HOME/Videos/Recordings"

if pgrep -x "$REC_BIN" > /dev/null; then
    pkill -SIGINT -x "$REC_BIN"
    
    sleep 0.5
    
    if [ -f "$TMP_FILE" ]; then
        filename=$(cat "$TMP_FILE")
        rm -f "$TMP_FILE"
        notify-send -i video-display "Screen Recording" "Gespeichert: $(basename "$filename")"
    else
        notify-send "Screen Recording" "Aufnahme beendet."
    fi
    exit 0
fi

choice=$(printf "Fullscreen (Audio)\nRegion (Audio)\nVideo Only" | rofi -dmenu -p "Record")

[ -z "$choice" ] && exit 0

mkdir -p "$REC_DIR"
filename="$REC_DIR/$(date +%Y%m%d_%H%M%S).mkv"

case "$choice" in
    "Fullscreen (Audio)")
        echo "$filename" > "$TMP_FILE"
        $REC_BIN --audio -f "$filename" >/dev/null 2>&1 &
        ;;
    "Region (Audio)")
        geom=$(slurp)
        if [ -z "$geom" ]; then exit 0; fi
        echo "$filename" > "$TMP_FILE"
        $REC_BIN --audio -g "$geom" -f "$filename" >/dev/null 2>&1 &
        ;;
    "Video Only")
        echo "$filename" > "$TMP_FILE"
        $REC_BIN -f "$filename" >/dev/null 2>&1 &
        ;;
esac

disown
notify-send -i media-record "Screen Recording" "Aufnahme gestartet..."
