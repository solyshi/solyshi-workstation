#!/bin/bash

if hyprctl clients | grep -q "kitty-btop"; then
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("btop")'
else
    kitty --class kitty-btop -e btop &
fi
