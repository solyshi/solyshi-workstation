local mainMod = require("keybinds.mainmod")

-- Media Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Screen Recording
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-recorder.sh"))
