package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/?.lua"

require("appearance.colors");
require("appearance.general");
require("appearance.layouts");
require("appearance.theme");
require("appearance.monitors");

require("rules.windowrules")
require("rules.layerrules")

require("functionality.programs");
require("functionality.input");

require("keybinds.main")

require("functionality.autostart");
