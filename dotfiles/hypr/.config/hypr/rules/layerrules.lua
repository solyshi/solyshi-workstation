hl.layer_rule({
    name = "waybar-blur",
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.1,
    match = {
        namespace = "waybar",
    }
})
