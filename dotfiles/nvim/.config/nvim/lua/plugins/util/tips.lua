return {
    "saxon1964/neovim-tips",
    version = "*", -- Only update on tagged releases
    lazy = false,  -- Load on startup for daily tip
    dependencies = {
        "MunifTanjim/nui.nvim",
        -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
        -- "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
        "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
    },
    opts = {
        -- OPTIONAL: Daily tip mode (default: 1)
        daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
        -- OPTIONAL: Bookmark symbol (default: "🌟 ")
        bookmark_symbol = "🌟 ",
    },
    -- The plugin ships commands but no default mappings. These were plain
    -- vim.keymap.set calls in `init`; as `keys` they get a which-key entry and
    -- the `silent` flag is implied by the `<cmd>` form.
    keys = {
        { "<leader>no", "<cmd>NeovimTips<cr>",       desc = "Browse Neovim tips" },
        { "<leader>nr", "<cmd>NeovimTipsRandom<cr>", desc = "Random tip" },
        { "<leader>np", "<cmd>NeovimTipsPdf<cr>",    desc = "Open tips PDF" },
    },
}
