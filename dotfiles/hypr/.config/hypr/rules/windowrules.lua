hl.window_rule({
    name = "ws-browser",
    match = {
        class = "org.qutebrowser.qutebrowser",
    },
    workspace = 2,
})

hl.window_rule({
    name = "ws-yazi",
    match = {
        class = "yazi",
    },
    workspace = 3,
})

hl.window_rule({
    name = "ws-mail",
    match = {
        class = "org.mozilla.Thunderbird",
    },
    workspace = 9,
})

hl.window_rule({
    name = "ws-trading",
    match = {
        class = "TradingView",
    },
    workspace = 10,
})

hl.window_rule({
    name = "ws-dev-gui",
    workspace = 4,
    match = {
        title = ".*DEV.*",
    },
    float = true,
    center = true,
})


-- SCRATCHPADS

hl.window_rule({
    name = "scratchpad-spotify",
    match = {
        class = "spotify",
    },
    workspace = "special:spotify",
    float = true,
    center = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "scratchpad-vesktop",
    match = {
        class = "vesktop",
    },
    workspace = "special:vesktop",
    float = true,
    center = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "scratchpad-terminal",
    match = {
        class = "kitty-scratch",
    },
    workspace = "special:terminal",
    float = true,
    center = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "scratchpad-btop",
    match = {
        class = "kitty-btop",
    },
    workspace = "special:btop",
    float = true,
    center = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "scratchpad-zeal",
    match = {
        class = "org.zealdocs.zeal",
    },
    workspace = "special:zeal",
    float = true,
    center = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
