return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "lewis6991/gitsigns.nvim",
    },
    cmd = "Neogit",
    keys = {
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    opts = {
        integrations = {
            diffview = true,
        },
        disable_commit_confirmation = true,
    },
}
