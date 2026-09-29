#!/bin/bash

if pgrep -x "zeal" > /dev/null; then
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("zeal")'
else
    hyprctl dispatch exec "zeal"
fi
