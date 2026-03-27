return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker    = { enabled = false },
        input     = { enabled = true },
        notifier  = { enabled = true },
        dashboard = { enabled = true },
        bigfile   = { enabled = true },
        indent    = { enabled = true },
        terminal  = { enabled = true },
    },
    keys = {
        { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
    },
}
