local programs = require("functionality.programs")

hl.on("hyprland.start", function()
    -- Daemons
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hypridle")

    -- Clipboard
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Apps auf Workspaces
    hl.exec_cmd(programs.terminal, { workspace = "1 silent" })
    hl.exec_cmd(programs.browser, { workspace = "2 silent" })
    hl.exec_cmd(programs.files, { workspace = "3 silent" })
    hl.exec_cmd("thunderbird", { workspace = "9 silent" })
    hl.exec_cmd("tradingview", { workspace = "0 silent" })

    -- Misc
    hl.exec_cmd(os.getenv("HOME") .. "/.config/theme/apply.sh")
end)
