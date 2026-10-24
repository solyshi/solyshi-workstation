return {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
        -- Was <leader>tT. Renamed to tw so it does not sit one shift-press away
        -- from <leader>tt, and so the mnemonic matches the plugin name.
        { "<leader>tw", "<cmd>Twilight<cr>", desc = "Toggle Twilight (dim inactive code)" },
    },
    -- The old spec set the keymap from `config` with no load trigger, so the
    -- plugin was pulled in on every startup just to register one mapping.
    opts = {},
}
