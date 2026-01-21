return {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function()
        vim.keymap.set("n", "<leader>ft", "<cmd>TodoFzfLua<cr>", { desc = "Fuzzy Find Todos" })
        require("todo-comments").setup({
            keywords = {
                GROUP = { icon = " ", color = "hint" },
                HERE = { icon = " ", color = "here" },
            },
            colors = { here = "#fdf5a4" },
            highlight = { multiline = true },
        })
    end,
}
