return {
    "chrisgrieser/nvim-genghis",
    config = function()
        local genghis = require("genghis")
        --
        -- Keymaps
        vim.keymap.set("n", "<leader>Fn", "<cmd>:Genghis createNewFile<cr>", { desc = "Create File in Place" })
        vim.keymap.set("n", "<leader>Fc", "<cmd>:Genghis duplicateFile<cr>", { desc = "Copy current file" })
        vim.keymap.set("n", "<leader>Fd", "<cmd>:Genghis trashFile<cr>", { desc = "Delete current File" })
        vim.keymap.set("v", "<leader>Fe", "<cmd>:Genghis moveSelectionToNewFile<cr>",
            { desc = "Extract selection into a new File" })
        vim.keymap.set("n", "<leader>Fm", "<cmd>:Genghis moveToFolderInCwd<cr>", { desc = "Move current file" })

        genghis.setup({})
    end
}
