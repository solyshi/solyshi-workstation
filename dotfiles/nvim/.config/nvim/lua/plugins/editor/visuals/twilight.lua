return {
    "folke/twilight.nvim",
    config = function()
        vim.keymap.set("n", "<leader>tT", "<cmd>:Twilight<cr>", { desc = "Toggle Twilight" })
    end
}
