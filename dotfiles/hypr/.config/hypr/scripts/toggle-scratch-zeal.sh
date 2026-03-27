#!/bin/bash

if pgrep -x "zeal" > /dev/null; then
    hyprctl dispatch togglespecialworkspace zeal
else
    hyprctl dispatch exec "zeal"
fi
