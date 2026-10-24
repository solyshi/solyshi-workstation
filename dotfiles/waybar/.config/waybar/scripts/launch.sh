#!/usr/bin/env bash
#
# Restart waybar. Prefers a clean reload over SIGKILL so the bar does not
# flicker and children (custom module scripts) get to exit properly.
set -uo pipefail

if pgrep -x waybar >/dev/null; then
    # SIGUSR2 makes waybar re-read config and stylesheet in place.
    pkill -USR2 -x waybar && exit 0

    # Fall back to a graceful restart only if the reload signal failed.
    pkill -TERM -x waybar
    for _ in {1..20}; do
        pgrep -x waybar >/dev/null || break
        sleep 0.1
    done
    pkill -KILL -x waybar 2>/dev/null
fi

waybar >/dev/null 2>&1 &
