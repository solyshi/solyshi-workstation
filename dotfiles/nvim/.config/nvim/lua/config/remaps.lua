vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Fast search and replace: yank the word (or selection) into the small delete
-- register, then pre-fill :%s with it on both sides, cursor between the slashes.
map("n", "<C-f>", 'viw"-y:%s/<C-r>-/<C-r>-/g<Left><Left>', { desc = "Replace word under cursor" })
map("x", "<C-f>", '"-y:%s/<C-r>-/<C-r>-/g<Left><Left>', { desc = "Replace selection" })

-- Clear Search highlights
map("n", "<C-c>",
    function()
        vim.cmd([[nohls]])
        return "<C-c>"
    end, { expr = true })
map("n", "<Esc>",
    function()
        vim.cmd([[nohls]])
        return "<Esc>"
    end, { expr = true })

-- The above borks up the cmdline window, so temporarily restore default behaviour
vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        map("n", "<C-c>", "<C-c>", { buffer = 0 })
        map("n", "<Esc>", "<Esc>", { buffer = 0 })
    end,
})

-- Scroll by 10 lines
map({ "n", "x" }, "<c-e>", '@="10<c-v><c-e>"<cr>', { silent = true, desc = "Scroll down 10 lines" })
map({ "n", "x" }, "<c-y>", '@="10<c-v><c-y>"<cr>', { silent = true, desc = "Scroll up 10 lines" })

-- Select all
map("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Plugin management. These live here rather than in a plugin spec because
-- lazy.nvim bootstraps itself and is never lazy-loaded, so there is no spec to
-- hang a `keys` table off. <leader>pm (Mason) is in plugins/dev/lsp/mason.lua.
map("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy (plugin manager)" })
map("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Lazy sync (update plugins)" })
map("n", "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Lazy startup profile" })
