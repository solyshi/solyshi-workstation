local mainMod = require("keybinds.mainmod")
local programs = require("functionality.programs")

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(programs.email))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(programs.music))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(programs.chat))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(programs.wallpaper))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(programs.files))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.filegui))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/rofi/scripts/powermenu.sh"))

-- SCRATCHPADS
-- Spotify and Vesktop are each bound twice on purpose: Hyprland fires every
-- dispatcher registered to a key, so the pair toggles the special workspace
-- and launches the app if it is not running yet. Keep both lines together.
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("pgrep -x spotify || spotify"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.workspace.toggle_special("vesktop"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("pgrep -x vesktop || vesktop"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-scratch-term.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-scratch-btop.sh"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-scratch-zeal.sh"))
