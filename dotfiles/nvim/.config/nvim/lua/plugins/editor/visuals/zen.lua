return {
    "folke/zen-mode.nvim",
    config = function()
        vim.keymap.set("n", "<leader>tz", "<cmd>:ZenMode<cr>", { desc = "Toggle Zen Mode" })
    end
}
