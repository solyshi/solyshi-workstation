-- Matched by description rather than connector name: the previous rule
-- targeted "DP-3", which no longer exists, so it silently did nothing and
-- Hyprland fell back to the panel's first advertised mode (60Hz) on a
-- 144Hz display. Description matching survives cable/port changes.
hl.monitor({
    output   = "desc:AOC 27G2G4 GYGM7HA445868",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})
