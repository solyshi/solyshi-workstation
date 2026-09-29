local colors = require("appearance.colors")

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,

        resize_on_border = false,

        col = {
            active_border = colors.primary,
            inactive_border = colors.on_primary,
        },

        allow_tearing = false,
        layout = "dwindle",
    },
})
