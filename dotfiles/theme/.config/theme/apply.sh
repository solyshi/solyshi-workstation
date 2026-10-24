#!/usr/bin/env bash
set -euo pipefail

for _ in {1..5}; do
    sleep 0.1
done

WALLPAPER_FILE="$HOME/.config/theme/wallpaper"
WALLPAPER="$(cat "$WALLPAPER_FILE")"

# Apply to all monitors
hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Generate theme
matugen image "$WALLPAPER"

# Reload apps
hyprctl reload
makoctl reload
spicetify apply
~/.config/waybar/scripts/launch.sh
kill -SIGUSR1 $(pgrep kitty)
echo "config-source" >"${XDG_RUNTIME_DIR}/qutebrowser/fifo" 2>/dev/null || true
