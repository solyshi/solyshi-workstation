return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    -- Every Trouble view lives under <leader>x now. Two of them used to sit
    -- under <leader>c: "cs" (symbols) and "ct" (lsp). The latter collided with
    -- <leader>ct for LSP type definitions in config/lsp-settings.lua -- whichever
    -- loaded last won, so one of the two was permanently unreachable.
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                   desc = "Diagnostics (workspace)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",      desc = "Diagnostics (buffer)" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",           desc = "Symbol outline" },
        { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references / defs" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                       desc = "Location list" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                        desc = "Quickfix list" },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                          desc = "TODO comments" },
    },
}
