return {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewFileHistory",
    },
    -- The `event = { "BufReadPost", "BufNewFile" }` that used to be here loaded
    -- diffview on the first buffer of every session, which defeats the point of
    -- also listing `cmd` and `keys`. Those two are enough to load it on demand.
    keys = {
        {
            "<leader>gd",
            function()
                -- Toggle: a second press closes the view instead of stacking
                -- another one on top.
                if next(require("diffview.lib").views) == nil then
                    vim.cmd("DiffviewOpen")
                else
                    vim.cmd("DiffviewClose")
                end
            end,
            desc = "Diffview (toggle)",
        },
        { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
}
