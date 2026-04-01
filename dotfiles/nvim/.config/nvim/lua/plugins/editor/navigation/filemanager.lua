return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>-",
            "<cmd>Yazi<cr>",
            desc = "Open File Explorer",
        },
    },
    opts = {
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
}
