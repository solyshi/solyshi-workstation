#!/bin/bash
if hyprctl clients | grep -q "kitty-scratch"; then
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("terminal")'
else
    kitty --class kitty-scratch &
fi
